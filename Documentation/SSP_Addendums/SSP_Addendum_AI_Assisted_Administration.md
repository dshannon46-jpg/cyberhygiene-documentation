# SSP Addendum: AI-Assisted System Administration

**Document ID:** SSP-ADD-AI-001
**Version:** 1.0
**Effective Date:** January 31, 2026
**Classification:** Controlled Unclassified Information (CUI)
**Author:** Donald E. Shannon, ISSO

---

## 1. Purpose

This addendum documents the implementation of AI-assisted system administration capabilities within the CyberInABox infrastructure. The SysAdmin Agent Dashboard v2.0 provides Explainable AI features designed to meet CMMC Level 2 requirements for transparency, accountability, and human oversight of automated systems.

---

## 2. System Description

### 2.1 SysAdmin Agent Dashboard v2.0

| Attribute | Value |
|-----------|-------|
| **URL** | https://dc1.cyberinabox.net/sysadmin/ |
| **Framework** | Streamlit 1.x with LangChain/LangGraph |
| **Service** | sysadmin-agent.service (systemd) |
| **Port** | 8501 (internal), proxied via Apache HTTPS |
| **Repository** | https://github.com/dshannon46-jpg/sysadmin-agent |

### 2.2 AI Model Configuration

| Model | Parameters | Quantization | Purpose |
|-------|------------|--------------|---------|
| Llama 3.3 70B Instruct | 70 Billion | Q4_K_M | Primary: System administration, security analysis |
| Code Llama 7B | 7 Billion | Q4_K_M | Secondary: Code assistance |

**AI Server Details:**
- Host: ai.cyberinabox.net (Mac Mini M4 Pro)
- API Port: 11443 (HTTPS with TLS 1.2/1.3)
- Context Window: 128K tokens
- License: Llama 3.3 Community License

---

## 3. Explainable AI Features

### 3.1 Confidence Scoring

Every AI response includes a confidence assessment:

| Level | Score Range | Description |
|-------|-------------|-------------|
| HIGH | 85-100% | High certainty based on multiple verified sources |
| MEDIUM | 60-84% | Reasonable confidence with some uncertainty |
| LOW | 0-59% | Limited confidence; human verification required |

### 3.2 Evidence Logging

All AI recommendations include:
- **Supporting Evidence**: Data sources and documentation references
- **Alternative Hypotheses**: Other possible explanations or approaches
- **Validation Steps**: Specific commands or checks to verify recommendations
- **Limitations**: Known constraints or edge cases

### 3.3 Human Review Classification

| Flag | Description | Action Required |
|------|-------------|-----------------|
| REQUIRED | Security-critical, high-risk, or low-confidence | Must have human approval before action |
| RECOMMENDED | Medium-risk or medium-confidence | Should review before action |
| ROUTINE | Low-risk, well-understood operations | Standard monitoring sufficient |

### 3.4 Response Schema

```json
{
  "response": "AI-generated response text",
  "confidence": {
    "level": "HIGH|MEDIUM|LOW",
    "score": 0-100,
    "reasoning": "Explanation of confidence assessment"
  },
  "evidence": ["Supporting data point 1", "Supporting data point 2"],
  "alternatives": ["Alternative explanation 1", "Alternative explanation 2"],
  "validation_steps": ["Step to verify recommendation"],
  "human_review": "REQUIRED|RECOMMENDED|ROUTINE",
  "limitations": ["Known limitation or edge case"]
}
```

---

## 4. Feedback and Evaluation System

### 4.1 User Feedback Collection

Users can provide feedback on every AI response:
- **Positive/Negative Rating**: Basic accuracy indicator
- **Issue Categories**: Factual error, security concern, overconfidence, missing information, other
- **Detailed Comments**: Free-form feedback for improvement

### 4.2 Feedback Database

| Table | Purpose |
|-------|---------|
| ai_responses | Stores all AI responses with confidence levels |
| feedback | Links user feedback to specific responses |
| evaluation_metrics | Aggregated daily performance metrics |

**Storage Location:** `/data/ai-workspace/sysadmin-agent/database/feedback.db`

### 4.3 Automated Evaluation Reports

**Schedule:** Daily at 6:00 AM (systemd timer: sysadmin-agent-eval.timer)

**Metrics Tracked:**
- Total responses generated
- Feedback submission rate
- Positive/negative feedback ratio
- Confidence calibration (stated vs actual accuracy)
- Issue category distribution

**Alert Thresholds:**
| Metric | Threshold | Alert |
|--------|-----------|-------|
| Calibration Error | > 25% | Indicates model over/under-confidence |
| Negative Feedback Rate | > 40% | Response quality degradation |
| Feedback Rate | < 5% | Insufficient data for evaluation |

**Report Retention:** 90 days

---

## 5. Automated Abnormal Event Detection

### 5.1 Event Categories Monitored

| Category | Description | Indicators |
|----------|-------------|------------|
| Failed Logins | Authentication failures | SSH brute force, PAM failures, Kerberos rejections |
| USB Violations | USBGuard policy blocks | Unauthorized devices, after-hours attempts |
| Data Transfers | Suspicious network activity | External destinations, large outbound flows, off-hours transfers |
| SELinux Security | Security-sensitive denials | Shadow file access, key access, sudoers modifications |

### 5.2 Alert Severity Levels

| Severity | Description | Dashboard Display |
|----------|-------------|-------------------|
| CRITICAL | Immediate security concern | Red alert, top of list |
| HIGH | Significant security event | Orange alert |
| MEDIUM | Moderate concern | Yellow alert |
| LOW | Informational | Blue alert |

### 5.3 Detection Sources

- `/var/log/secure` - Authentication events
- `/var/log/messages` - System events
- `/var/log/audit/audit.log` - Audit events
- `journalctl` - Systemd journal for USBGuard, network services

---

## 6. Human-in-the-Loop Controls

### 6.1 Approval Workflow

All high-risk actions require explicit human approval:
1. AI suggests action with explanation and confidence
2. User reviews recommendation and supporting evidence
3. User explicitly approves or rejects action
4. Action executed only after approval
5. All decisions logged to audit trail

### 6.2 Command Restrictions

**Forbidden Commands (Never Executed):**
- `rm -rf /`
- `mkfs`
- `dd if=/dev/zero`
- Password/credential modifications
- Direct database modifications

**Approval Required:**
- System updates (dnf update)
- Service restarts
- Configuration changes
- User account modifications

### 6.3 Audit Logging

All AI interactions logged to: `/data/ai-workspace/sysadmin-agent/logs/agent_audit.log`

**Log Format (JSON Lines):**
```json
{
  "timestamp": "2026-01-31T10:30:45Z",
  "event_type": "AI_RESPONSE|COMMAND_APPROVED|FEEDBACK_SUBMITTED",
  "user": "admin",
  "session_id": "uuid",
  "details": {...}
}
```

---

## 7. Security Controls Mapping

### 7.1 NIST 800-171 Controls

| Control | Implementation |
|---------|----------------|
| 3.1.1 - Access Control | Dashboard access restricted via Apache authentication |
| 3.1.2 - Transaction Control | Human approval required for system modifications |
| 3.3.1 - Audit Events | All AI interactions logged with timestamps |
| 3.3.2 - Audit Content | Complete context captured (query, response, confidence, action) |
| 3.4.1 - System Baselines | Abnormal event detection compares against expected behavior |
| 3.4.2 - Security Configuration | AI cannot modify security configurations without approval |
| 3.12.1 - Security Assessment | Continuous model evaluation and calibration tracking |
| 3.14.1 - Flaw Remediation | AI assists in identifying but cannot auto-remediate |

### 7.2 CMMC Level 2 Practices

| Practice | Evidence |
|----------|----------|
| AC.L2-3.1.1 | Apache proxy authentication configuration |
| AU.L2-3.3.1 | agent_audit.log with AI interaction records |
| AU.L2-3.3.2 | Feedback database with complete response context |
| CA.L2-3.12.1 | Daily evaluation reports with calibration analysis |
| CM.L2-3.4.1 | Abnormal event detector baselines |
| SI.L2-3.14.1 | AI-assisted log analysis for flaw identification |

---

## 8. Compliance Reporting

### 8.1 Automated Reports

The system generates CMMC-compliant reports including:
- Executive summary of AI operations
- Audit event summaries
- Human oversight metrics
- Confidence calibration analysis
- Control compliance status

### 8.2 Export Formats

| Format | Purpose |
|--------|---------|
| Markdown | Human-readable reports |
| JSON | Machine-readable for automated processing |
| PDF | Formal audit documentation (manual export) |

---

## 9. Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    dc1.cyberinabox.net                          │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │   Apache     │───▶│  Streamlit   │───▶│  LangChain/      │  │
│  │   (HTTPS)    │    │  Dashboard   │    │  LangGraph       │  │
│  └──────────────┘    └──────────────┘    └────────┬─────────┘  │
│                                                    │            │
│  ┌──────────────┐    ┌──────────────┐              │            │
│  │  Feedback    │◀───│  Evaluation  │              │            │
│  │  Database    │    │  Reports     │              │            │
│  └──────────────┘    └──────────────┘              │            │
│                                                    │            │
│  ┌──────────────┐    ┌──────────────┐              │            │
│  │  Abnormal    │───▶│  Security    │              │            │
│  │  Event Det.  │    │  Alerts      │              │            │
│  └──────────────┘    └──────────────┘              │            │
└─────────────────────────────────────────────────────│────────────┘
                                                     │ HTTPS/TLS
                                                     │ Port 11443
┌─────────────────────────────────────────────────────│────────────┐
│                    ai.cyberinabox.net              ▼            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │            Llama 3.3 70B Instruct (Q4_K_M)              │   │
│  │            Mac Mini M4 Pro (Apple Silicon)              │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 10. Evidence Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| Dashboard Source | /data/ai-workspace/sysadmin-agent/app.py | Main application |
| Feedback DB Schema | /data/ai-workspace/sysadmin-agent/database/feedback_db.py | Database implementation |
| Evaluation Reports | /data/ai-workspace/sysadmin-agent/database/evaluation_reports.py | Report generation |
| Event Detector | /data/ai-workspace/sysadmin-agent/tools/abnormal_event_detector.py | Security monitoring |
| Audit Logs | /data/ai-workspace/sysadmin-agent/logs/agent_audit.log | Interaction logs |
| Service Config | /etc/systemd/system/sysadmin-agent.service | Systemd service |
| Eval Timer | /etc/systemd/system/sysadmin-agent-eval.timer | Daily report timer |
| Apache Config | /etc/httpd/conf.d/sysadmin-agent.conf | Proxy configuration |

---

## 11. Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | January 31, 2026 | D. Shannon | Initial release - SysAdmin Agent Dashboard v2.0 with Explainable AI |

---

## 12. Approval

| Role | Name | Signature | Date |
|------|------|-----------|------|
| ISSO | Donald E. Shannon | | |
| System Owner | | | |

---

**Document Classification:** Controlled Unclassified Information (CUI)
**Distribution:** Internal use only - CyberInABox Project Team
