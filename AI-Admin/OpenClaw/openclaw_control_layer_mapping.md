# OpenClaw DC Hardening — Control Layer Mapping

**What can a configuration file do? What can't it?**

This document maps every recommendation from the hardening guide to its enforcement
layer. The short answer: **16 of the 34+ controls can be enforced via OpenClaw
configuration alone** (up from 13 in v1.0, after adding exec approvals, Lobster,
and Citadel Guard). The rest — and critically, the highest-risk ones — require
OS-level, infrastructure, or process controls that exist *outside* of OpenClaw's
trust boundary.

---

## ✅ Enforceable via OpenClaw Configuration (openclaw.json)

These are in the hardened config file (`openclaw_dc_hardened.json`). They are
necessary but not sufficient on their own.

| # | Control | Config Key / Mechanism | Hardening Doc Section |
|---|---------|------------------------|----------------------|
| 1 | Gateway bound to loopback only | `gateway.bind: "loopback"` | §3.1 |
| 2 | Token-based auth on gateway | `gateway.auth.mode: "token"` | §3.1 |
| 3 | Disable mDNS broadcasting | Env var `OPENCLAW_DISABLE_BONJOUR=1` (set in systemd unit) | §3.1 |
| 4 | Deny exec tool | `agents.defaults.tools.denylist: ["exec"]` | §3.2 |
| 5 | Deny process tool | `agents.defaults.tools.denylist: ["process"]` | §3.2 |
| 6 | Deny write/edit/apply_patch | `agents.defaults.tools.denylist` | §3.2 |
| 7 | Allowlist read-only tools only | `agents.defaults.tools.allowlist: ["read"]` | §3.2 |
| 8 | Enable sandbox for all sessions | `agents.defaults.sandbox.enabled: true`, `scope: "all"` | §3.3 |
| 9 | Docker sandbox with no network | `agents.defaults.sandbox.docker.network: "none"` | §3.3 |
| 10 | Non-root user in sandbox | `agents.defaults.sandbox.docker.user: "1000:1000"` | §3.3 |
| 11 | Disable all channel integrations | `channels.*.enabled: false` (all channels) | §3.4 |
| 12 | Redact sensitive data in logs | `logging.redactSensitive: "tools"` | §6.2 |
| 13 | Exec approvals fail-closed | `tools.exec.security: "allowlist"`, `askFallback: "deny"` | §2.4 |
| 14 | Lobster approval gates enabled | `plugins.allow: ["lobster"]` + `lobster.approvalRequired: true` | §2.4 |
| 15 | Citadel Guard prompt injection defense | `plugins.allow: ["citadel-guard"]` + hooks config | §2.4 / §8.1 |
| 16 | Citadel Guard HTTP API disabled | `citadel-guard.httpApi: false` | §2.4 |

**Important caveat on sandbox:** OpenClaw config *enables* the sandbox and sets
network to "none," but the actual Docker image hardening (read-only filesystem,
dropped capabilities, no shell) is enforced in a *Dockerfile*, which is external
to OpenClaw's config. See the "Cannot" section below.

---

## 🛡️ Native Defense-in-Depth Layer (Config-Enforced, but In-Process)

Controls 13–16 above constitute a three-component native defense-in-depth layer
that significantly narrows the attack surface *without* requiring custom software.
They are configured entirely in `openclaw.json` and enforced by OpenClaw's own
runtime. However, they share a critical architectural characteristic: **they all
execute inside the agent's process space.** A fully compromised agent could
theoretically reach the exec approvals socket or manipulate plugin state.

This is why they complement — but do not replace — the external sudo proxy.

### Layer 1: Exec Approvals

OpenClaw's built-in exec approval system enforces command-level gating on the
execution host. In this deployment it is configured as a redundant catch:

- `security: "allowlist"` with an *empty* allowlist means no command is
  pre-authorized. Every exec attempt triggers the approval flow.
- `ask: "on-miss"` + `askFallback: "deny"` makes the system fail closed. If
  the approval UI is unreachable (container isolation, network partition), the
  command is denied automatically.
- `autoAllowSkills: false` prevents skill CLIs from being implicitly trusted.
- `forwardTo` routes approval prompts to the SOC channel, giving operators an
  out-of-band view independent of the agent's own session.

**Prerequisite:** Verify PR #3357 is in your build. Issue #2402 showed that
pre-fix exec approvals were fire-and-forget — the tool returned immediately
without blocking for approval, making the gate effectively a no-op.

### Layer 2: Lobster Plugin

Lobster structures multi-step operations as deterministic, resumable pipelines
with explicit approval checkpoints:

- Side-effect steps (restart, send, modify) require an approval checkpoint
  before proceeding. The Lobster runtime enforces this, not the agent.
- Pipelines are data (JSON/YAML), making them loggable, diffable, and
  replayable — a significant improvement over free-form shell commands for
  audit purposes.
- Resumable workflows mean that if an approval is delayed, the pipeline
  halts and returns a token. When approval arrives, it resumes exactly where
  it stopped without re-executing prior steps.
- Runtime safety policy (timeouts, output caps, sandbox enforcement) is
  baked into the Lobster config block, not the agent prompt.

### Layer 3: Citadel Guard Plugin

Citadel Guard addresses §8.1 (prompt injection via log content) at the tool
output boundary:

- `after_tool_call` hook scans every tool result asynchronously before it
  enters the model's context window. This is the point where crafted log
  entries (e.g., a Suricata-logged packet payload containing adversarial
  instructions) would first be visible to the model.
- `tool_result_persist` hook performs synchronous sanitization on results that
  are written to persistent storage, preventing injection payloads from
  surviving across sessions.
- Multi-layer detection (heuristic patterns, ML classifier, semantic
  similarity to known injection templates) reduces false negatives.
- `action: "sanitize_and_flag"` strips the adversarial content and surfaces a
  warning to the operator — it does not silently pass or silently drop.

**Critical gap in Citadel Guard:** The HTTP API path (`/v1/chat/completions`)
bypasses all hooks entirely. This is disabled in the config (`httpApi: false`).
If any component re-enables it, the injection defense is void for that path.

### Residual Gap

All three layers run inside the OpenClaw gateway process on the same host. The
exec approvals socket (`~/.openclaw/exec-approvals.sock`) and plugin state are
theoretically reachable by a fully compromised agent process. This is why the
**external sudo proxy (§2.3) remains the primary privilege escalation control.**
The native layer reduces the surface area for accidents and catches prompt
injection before it reaches the model — the external proxy prevents a
compromised agent from actually executing privileged commands.

---

## ❌ Cannot Be Enforced via OpenClaw Configuration

These require controls at the OS, network, infrastructure, or organizational level.
They are the controls that actually prevent a compromised or manipulated OpenClaw
from causing damage — because they enforce boundaries the agent *cannot reach*.

### A. OS-Level Controls (on the Domain Controller)

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| Dedicated service account (`openclaw-svc`) | `/etc/passwd`, `useradd` | OpenClaw runs *as* this user. It can't create or constrain its own OS identity. |
| Whitelist-only sudoers | `/etc/sudoers.d/openclaw-svc` | sudo policy is an OS security boundary. If OpenClaw could write its own sudoers, the control would be meaningless. |
| Sudo token timeout = 0 | `/etc/sudoers` (`Defaults timestamp_timeout=0`) | Prevents credential caching between commands. OS-enforced. |
| File permissions on `~/.openclaw` | `chmod 700` / `600` on config, credentials, sessions | `openclaw security audit --fix` *helps*, but must be verified independently. A compromised agent could re-open permissions. |

### B. The Sudo Approval Proxy (Custom Software)

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| External sudo approval gate | A proxy service between OpenClaw and `sudo` | This is the single most critical control in the architecture. OpenClaw's built-in HITL runs inside the same process — an agent can bypass its own prompts. The proxy must be *outside* the agent's process and trust boundary. Requires custom development or an existing PAM/privileged access management solution. |
| Structured command submission (not raw shell strings) | Proxy input validation | Prevents the agent from smuggling arbitrary commands. |
| Operator notification + approval workflow | Proxy + SOC integration | The approval interface and notification path are infrastructure, not agent config. |
| Cryptographically signed approval | Proxy auth mechanism | Requires key management outside OpenClaw. |
| Timeout-based auto-denial | Proxy logic | Time-based safety net if operator doesn't respond. |

### C. Network & Infrastructure

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| TLS on Ollama API | Ollama config + certificate | Ollama is a separate service. Its transport security is its own config. |
| API key auth on Ollama | Ollama config | Same — Ollama's auth is independent. |
| Rate limiting on Ollama | Ollama config or a reverse proxy in front of it | Prevents runaway inference loops. |
| Firewall rules (DC outbound) | `iptables` / `nftables` / Windows Firewall | Must be enforced at the network layer, below the application. |
| Suricata monitoring on VLAN | Suricata deployment | Already in your stack — ensure it covers the segmented VLAN. |
| Air-gap integrity (Mac Mini) | Physical security + periodic interface audits | No software control can enforce a physical air gap. |
| USB port disabling | BIOS/UEFI or physical | Hardware-level. |

### D. Docker Image Hardening

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| Read-only root filesystem | `Dockerfile` / `docker run --read-only` | OpenClaw config enables the sandbox, but the *image itself* must be built hardened. |
| Dropped Linux capabilities | `docker-compose.yml` (`cap_drop: ALL`) | Enforced at container runtime, not inside the container. |
| No shell in image | `Dockerfile` (don't install bash/sh) | Image build decision. |
| Read-only bind mounts (log dirs only) | `docker-compose.yml` volume definitions | Must be defined in the compose file alongside the config. |

### E. Logging & Monitoring Infrastructure

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| Log forwarding to Graylog | Sidecar agent or host-level log shipper | OpenClaw can't securely forward its own logs — it could falsify them. A sidecar outside the container captures and forwards. |
| Tamper-evident log storage | Append-only / WORM storage policy | Storage infrastructure decision, not agent config. |
| Agent cannot write its own logs | Sidecar capture + container FS is read-only | Enforced by the container hardening above. |

### F. The HITL Approval Interface

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| Structured approval UI (not free-form text) | Custom operator dashboard | OpenClaw has no built-in approval interface suitable for privileged DC operations. |
| Two-step approval with cooling-off window | Custom workflow logic | Safety mechanism against social engineering. Must be in the proxy/UI layer. |
| Citation verification display | Custom UI | Shows operator which log entries informed the recommendation so they can verify. |
| Anomaly flagging (deviation from baseline) | Custom logic in the approval layer | Highlights unusual proposals. |
| Synthetic anomaly injection (trust audits) | Operator process | Periodic testing that operators are actually reviewing, not rubber-stamping. |

### G. Process & Governance (NIST Requirements)

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| Formal AI use policy | Organizational document | NIST Govern function. No technical control substitutes. |
| AI Bill of Materials (AI-BOM) | Documentation + process | Model provenance, training data lineage, version pinning. |
| Designated AI risk owner | Organizational role | Accountability. |
| Model weight SHA-256 verification | Pre-deployment process | Verify integrity of the 70B model before it runs. |
| Incident response runbook | Document + drill | What to do when something goes wrong. |
| Red-team exercises | Scheduled testing | Adversarial testing of the agent. |
| Quarterly posture review | Process cadence | NIST Manage function. |
| Operator rotation schedule | HR/ops process | Prevents trust bias buildup. |

### H. Log Content Sanitization (Partially Addressed by Citadel Guard)

| Control | What enforces it | Why config can't do it |
|---------|-----------------|----------------------|
| Sanitize log content before model ingestion | Citadel Guard plugin (in-process) + custom middleware (out-of-process) | Citadel Guard now covers the tool-output boundary via hooks — it scans results before they reach the model context. However, it runs in-process and its HTTP API path bypasses hooks entirely. A belt-and-suspenders approach retains the custom pre-processing middleware between log sources and OpenClaw for content that enters via non-tool paths. |

---

## Summary

| Layer | Controls | % of Total |
|-------|----------|------------|
| OpenClaw config (what you asked about) | 16 | ~47% |
| Native defense-in-depth (exec approvals + Lobster + Citadel Guard) | 4 (subset of above) | ~12% |
| OS-level (sudoers, service account) | 4 | ~12% |
| Sudo approval proxy (custom) | 5 | ~15% |
| Network & infrastructure | 7 | ~21% |
| Docker image hardening | 4 | ~12% |
| Logging infrastructure | 3 | ~9% |
| HITL interface (custom) | 5 | ~15% |
| Process & governance (NIST) | 8 | ~24% |
| Log sanitization middleware | 1 | ~3% |

*(Percentages exceed 100% because some controls span layers.)*

**The key insight:** OpenClaw's config handles the *agent-facing* surface — what the
agent is allowed to see and do *within its own process*. The native defense-in-depth
layer (exec approvals + Lobster + Citadel Guard) significantly hardens that
in-process surface: it catches prompt injection at the tool-output boundary, gates
commands with fail-closed approval semantics, and structures operations as auditable
pipelines. But the controls that actually stop a compromised or manipulated agent
from causing damage on a Domain Controller — the sudo boundary, the network
boundary, the container boundary, the log integrity boundary — all live *outside*
of OpenClaw's config, by design. That's not a gap. That's the architecture working
as intended.
