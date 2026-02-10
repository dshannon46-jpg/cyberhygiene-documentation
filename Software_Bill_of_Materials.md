# SOFTWARE BILL OF MATERIALS (SBOM) - Multi-System

**System:** CyberHygiene Production Network (All Systems)
**Organization:** The Contract Coach
**Classification:** Controlled Unclassified Information (CUI)
**Version:** 2.2
**Date Generated:** January 31, 2026
**Scope:** 6 systems (1 server, 4 workstations, 1 AI server)
**Architectures:** x86_64 (Rocky Linux), ARM64 (Apple Silicon)

---

## EXECUTIVE SUMMARY

### System Inventory

| Hostname | IP | Platform | Architecture | Packages | Role |
|----------|-----|----------|--------------|----------|------|
| **dc1.cyberinabox.net** | 192.168.1.10 | Rocky Linux 9.7 | x86_64 | ~1,730 | Domain Controller, FIPS enabled |
| **engineering** | 192.168.1.104 | Rocky Linux 9.7 | x86_64 | ~1,200 | Engineering Workstation, FIPS enabled |
| **accounting** | 192.168.1.113 | Rocky Linux 9.7 | x86_64 | ~1,100 | Accounting Workstation, FIPS enabled |
| **labrat** | 192.168.1.115 | Rocky Linux 9.6 | x86_64 | ~1,100 | Lab Workstation, FIPS enabled |
| **ai** | 192.168.1.7 | macOS Sequoia | ARM64 (M4 Pro) | ~450 | AI/ML Server, Ollama platform |

**Total Systems:** 6 (including Prometheus self-monitoring)
**Total Software Packages:** ~5,580 across all systems
**Heterogeneous Environment:** Mixed x86_64 (Intel/AMD) and ARM64 (Apple Silicon)

### Platform Distribution

- **Rocky Linux 9.7:** 3 systems (dc1, engineering, accounting) - FIPS 140-2 mode enabled
- **Rocky Linux 9.6:** 1 system (labrat) - FIPS 140-2 mode enabled
- **macOS Sequoia:** 1 system (ai) - Apple Silicon with hardware encryption

---

## PURPOSE

This Software Bill of Materials (SBOM) provides a comprehensive inventory of all software components installed across the entire CyberHygiene Production Network. This multi-system SBOM supports:

- **Supply chain security assessment** per NIST 800-171 SR-2
- **Vulnerability management** and patch tracking across heterogeneous platforms
- **Software licensing compliance** (Rocky Linux, macOS, open source)
- **System security auditing** and configuration management (CM-8)
- **Incident response and forensics** capabilities
- **CMMC Level 2 compliance** (Component Inventory requirements)

---

## DOCUMENT CLASSIFICATION

**Classification:** CUI (Controlled Unclassified Information)
**Distribution:** Owner/ISSO, Authorized Auditors, C3PAO Assessors
**Retention:** Maintain current version + 3 years historical
**Review Schedule:** Quarterly (with each SSP review)

---

## VERSION HISTORY

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-02 | D. Shannon | Initial SBOM for dc1.cyberinabox.net only (1,750 packages) |
| 2.0 | 2025-12-26 | D. Shannon | Multi-system SBOM: Added ai, ws1, ws2, ws3. Total 5 systems, ~5,600 packages. |
| 2.1 | 2026-01-23 | D. Shannon | Updated system names (ws1→engineering, ws2→accounting, ws3→labrat). Rocky Linux 9.6→9.7 upgrade. Major software updates: NextCloud 32.0.5, Graylog 6.1.16, Grafana 12.3.1, Wazuh 4.14.2, OpenSSL 3.5.1, PHP 8.2.30. Added OnlyOffice Desktop Editor 9.2.1, fapolicyd. Removed AIDE/ClamAV (not installed). |
| 2.2 | 2026-01-31 | D. Shannon | Added SysAdmin Agent Dashboard v2.0 with Explainable AI components. New Python packages: LangChain, LangGraph, Streamlit. Added Llama 3.3 70B model on AI server. Added AI evaluation and compliance reporting system. |

---

## SYSTEM 1: dc1.cyberinabox.net (Domain Controller)

**Platform:** Rocky Linux 9.7 (Blue Onyx)
**Kernel:** 5.14.0-611.24.1.el9_7.x86_64
**Architecture:** x86_64
**FIPS Mode:** Enabled
**Total Packages:** 1,729 RPM + 1 Flatpak + Python venv packages
**Role:** FreeIPA Domain Controller, Primary DNS, Samba File Server, Wazuh SIEM, Graylog, Web Server, NextCloud, SysAdmin Agent Dashboard

### Critical Security Software (dc1)

#### Identity & Access Management
- **389-ds-base** 2.6.1-x.el9_7 - LDAP Directory Server (FreeIPA backend)
- **ipa-server** 4.12.2-22.el9_7.1 - FreeIPA Identity Management Server
- **krb5-server** 1.21.1-x.el9_7 - Kerberos 5 KDC
- **sssd** 2.9.x-x.el9_7 - System Security Services Daemon
- **certmonger** 0.79.x - Certificate Management

#### Security & Monitoring
- **wazuh-manager** 4.14.2-1 - Wazuh SIEM Manager
- **graylog-server** 6.1.16-1 - Centralized Log Management
- **grafana** 12.3.1-1 - Metrics Visualization
- **fapolicyd** 1.3.3-106.el9_6.1 - File Access Policy Daemon (application whitelisting)
- **audit** 3.0.7-x.el9_7 - User space tools for kernel auditing
- **SELinux** - Mandatory Access Control (enforcing mode)
- **suricata** 7.x - Network Intrusion Detection System

#### Encryption & FIPS
- **openssl** 3.5.1-5.el9_7 (FIPS validated)
- **gnutls** 3.8.x-x.el9_7 (FIPS validated)
- **cryptsetup** 2.7.x-x.el9_7 - LUKS encryption tools

#### Database Services
- **mongodb-org** 7.0.28-1.el9 - Document database (Graylog backend)

#### File Services
- **samba** 4.22.4-6.el9 - SMB/CIFS file sharing
- **mdadm** 4.3-x.el9_7 - Software RAID management

#### Web Services
- **httpd** 2.4.62-7.el9_7.3 - Apache HTTP Server
- **mod_ssl** 2.4.62-7.el9_7.3 - SSL/TLS module for Apache
- **php** 8.2.30-1.module_php.8.2.el9.remi - PHP scripting language (Remi repository)

#### Collaboration
- **NextCloud** 32.0.5 - File sharing and collaboration platform

#### Email Services
- **postfix** 3.5.25-1.el9 - SMTP Mail Transfer Agent
- **dovecot** 2.3.16-15.el9 - IMAP/POP3 Mail Server

#### Container Runtime
- **podman** 5.6.0-11.el9_7 - Container management

#### Desktop Applications (Flatpak)
- **OnlyOffice Desktop Editor** 9.2.1 - Office productivity suite

---

### SysAdmin Agent Dashboard v2.0 (NEW)

**Location:** `/data/ai-workspace/sysadmin-agent/`
**Service:** `sysadmin-agent.service` (systemd)
**URL:** `https://dc1.cyberinabox.net/sysadmin/`
**Purpose:** AI-assisted system administration with Explainable AI for CMMC compliance

#### Core Application
- **Streamlit** 1.x - Web application framework
- **Python** 3.9.x - Runtime environment

#### AI/ML Framework
- **LangChain** 0.3.x - LLM application framework
- **LangChain-OpenAI** 0.3.x - OpenAI-compatible LLM integration
- **LangGraph** 0.2.x - Stateful AI agent workflows
- **httpx** 0.x - Async HTTP client (Ollama communication)

#### Data & Storage
- **SQLite** 3.x - Feedback and evaluation database
- **Pandas** 2.x - Data analysis (trend visualization)

#### Explainable AI Components

| Component | File | Description |
|-----------|------|-------------|
| ExplainableResponse | `models/explainable_response.py` | Schema for transparent AI responses |
| Feedback Database | `database/feedback_db.py` | User feedback storage and metrics |
| Evaluation Reports | `database/evaluation_reports.py` | Compliance report generation |
| Event Detector | `tools/abnormal_event_detector.py` | Automated security event detection |
| Daily Evaluation | `scripts/daily_evaluation.py` | Scheduled report generation |

#### Explainable AI Features

**Transparency Elements (per AI response):**
- Confidence scores (HIGH/MEDIUM/LOW with 0-100%)
- Supporting evidence (log entries, metrics)
- Alternative hypotheses
- Validation steps for human verification
- Human review requirement flags

**Continuous Evaluation:**
- Feedback collection (thumbs up/down, issue categories)
- Confidence calibration analysis
- Historical trend tracking
- CMMC compliance report generation

**Automated Detection:**
- Failed login attempts (SSH, PAM, Kerberos)
- USB policy violations (USBGuard integration)
- Suspicious data transfers
- Security-sensitive SELinux denials

#### Scheduled Tasks
- **sysadmin-agent-eval.timer** - Daily evaluation report (6:00 AM)
- **Report Retention:** 90 days

#### Security Posture
- Human-in-the-loop for all high-impact commands
- Complete audit logging to JSON
- No external API calls (local LLM only)
- HTTPS proxy via Apache (TLS 1.2+)

---

## SYSTEM 2: ai.cyberinabox.net (AI/ML Server)

**Platform:** macOS Sequoia (15.x)
**Hardware:** Apple Mac Mini (2024) - M4 Pro
**Chip:** Apple M4 Pro (14-core CPU, 20-core GPU, 16-core Neural Engine)
**Architecture:** ARM64 (Apple Silicon)
**RAM:** 64 GB unified memory
**Storage:** NVMe SSD with hardware encryption (M4 Secure Enclave)
**Total Packages:** ~450 (estimated)
**Role:** AI/ML Infrastructure, Local LLM Hosting, System Administration AI

### macOS System Software

#### Operating System
- **macOS Sequoia** 15.2 (or latest) - Apple's Unix-based operating system
- **XNU Kernel** - Darwin kernel (ARM64 optimized)
- **System Integrity Protection (SIP)** - Enabled
- **Gatekeeper** - Enabled (application code signing enforcement)

#### Security & Encryption
- **FileVault** - Full-disk encryption (enabled)
- **M4 Security Chip** - Hardware encryption and Secure Enclave
- **Secure Boot** - Boot integrity verification
- **XProtect** - Built-in malware protection (macOS native)
- **macOS Firewall** - Application-level firewall (enabled)

#### AI/ML Platform Software

##### Ollama Platform
- **Ollama** 0.5.x - LLM inference engine (optimized for Apple Silicon)
  - Purpose: Local large language model hosting
  - API: HTTPS REST API on port 11443 (proxied, TLS secured)
  - Optimization: Metal Performance Shaders (MPS) for GPU acceleration
  - License: Open source (MIT License)

##### AI Models (UPDATED)

| Model | Parameters | Size | Speed | Use Case |
|-------|------------|------|-------|----------|
| **Llama 3.3 70B Instruct** | 70B | ~40 GB | 15-25 tok/s | Primary: SysAdmin Agent, security analysis |
| **Code Llama 7B** | 7B | 3.8 GB | 40-60 tok/s | Secondary: Code assistance |

**Llama 3.3 70B Instruct:**
- Quantization: Q4_K_M (optimized for Apple Silicon)
- Context Window: 128K tokens
- License: Llama 3.3 Community License
- Use: System administration, log analysis, security assessment, compliance assistance

#### Development Tools
- **Command Line Tools for Xcode** - Compiler toolchain (clang, git, make)
- **Homebrew** (optional) - Package manager for macOS
- **Python 3.x** - Pre-installed with macOS
- **OpenSSL** (LibreSSL) - TLS/SSL library (macOS system version)

### Security Posture (AI Server)

**Hardening Measures:**
- FileVault full-disk encryption enabled
- System Integrity Protection (SIP) enabled
- Gatekeeper enabled (code signing required)
- Firewall enabled (default deny inbound)
- Automatic security updates enabled
- All AI API traffic proxied through dc1 via HTTPS (TLS 1.2+)
- Self-signed certificate with CA validation

**Compliance Notes:**
- Hardware encryption via M4 Secure Enclave meets FIPS 140-2 equivalent
- macOS security features provide defense-in-depth
- No CUI stored on AI server (administrative use only)
- All AI model inference performed locally (no external API calls)

---

## SYSTEM 3: engineering (Engineering Workstation)

**Platform:** Rocky Linux 9.7 (Blue Onyx)
**Kernel:** 5.14.0-611.20.1.el9_7.x86_64
**Architecture:** x86_64
**Hardware:** High-performance workstation (48 CPU cores)
**IP Address:** 192.168.1.104
**FIPS Mode:** Enabled
**Total Packages:** ~1,200
**Role:** Engineering and Development Workstation

### Key Software Categories (engineering)

**Similar to dc1 base packages, with the following additions:**

#### Desktop Environment
- **GNOME** 40.x - Desktop environment
- **gnome-shell** - GNOME Shell interface
- **gdm** - GNOME Display Manager

#### Development Tools
- **Podman** - Container runtime
- **Python development tools** - pip, virtualenv
- **gcc** - GNU Compiler Collection
- **git** - Version control
- **vim** / **nano** - Text editors

#### Engineering Tools
- **Network analysis tools** - tcpdump, wireshark
- **Technical documentation tools**

**Security:** Same FIPS-validated cryptography as dc1
**Encryption:** LUKS full-disk encryption on all partitions
**Authentication:** FreeIPA Kerberos integration

---

## SYSTEM 4: accounting (Accounting Workstation)

**Platform:** Rocky Linux 9.7 (Blue Onyx)
**Kernel:** 5.14.0-611.20.1.el9_7.x86_64
**Architecture:** x86_64
**Hardware:** Standard workstation (32 CPU cores)
**IP Address:** 192.168.1.113
**FIPS Mode:** Enabled
**Total Packages:** ~1,100
**Role:** Accounting and Business Workstation

### Key Software Categories (accounting)

**Similar to engineering base, with business-specific additions:**

#### Business Applications
- **LibreOffice** - Office productivity suite
- **PDF tools** - Document management
- **Email client** - Evolution / Thunderbird

#### Operations Tools
- **Network monitoring clients**
- **Backup verification tools**
- **Documentation and reporting tools**

**Security:** FIPS-validated cryptography, LUKS encryption
**Authentication:** FreeIPA Kerberos integration

---

## SYSTEM 5: labrat (Lab Workstation)

**Platform:** Rocky Linux 9.6 (Blue Onyx)
**Kernel:** 5.14.0-570.x.el9_6.x86_64
**Architecture:** x86_64
**Hardware:** Lab workstation (32 CPU cores)
**IP Address:** 192.168.1.115
**FIPS Mode:** Enabled
**Total Packages:** ~1,100
**Role:** Lab and Testing Workstation

### Key Software Categories (labrat)

**Testing and lab environment with:**

#### Lab Tools
- Testing frameworks
- Development tools
- Experimental software evaluation

**Note:** System pending upgrade to Rocky Linux 9.7

**Security:** FIPS-validated cryptography, LUKS encryption
**Authentication:** FreeIPA Kerberos integration

---

## CROSS-SYSTEM SECURITY CONTROLS

### Common Security Software (All Rocky Linux Systems)

**Encryption & FIPS:**
- LUKS disk encryption (AES-256-XTS) on all CUI partitions
- FIPS 140-2 mode enabled system-wide
- OpenSSL 3.5.x (FIPS validated)
- GnuTLS (FIPS validated)

**Authentication:**
- FreeIPA client integration (Kerberos)
- SSSD for centralized authentication
- PAM stack hardened per NIST 800-171

**Monitoring:**
- Wazuh agent on all systems (reporting to dc1)
- Auditd with comprehensive rules
- Prometheus node_exporter for metrics (HTTPS/TLS)

**Application Control:**
- fapolicyd (File Access Policy Daemon) - application whitelisting
- SELinux mandatory access control (enforcing)

**Network Security:**
- Firewalld (default deny)
- SSH hardened configuration
- TLS 1.2+ for all encrypted communications

### Heterogeneous Platform Security

**Rocky Linux (x86_64):**
- FIPS 140-2 validated cryptography
- SELinux enforcing mode
- OpenSCAP CUI profile compliance

**macOS (ARM64):**
- Apple M4 Secure Enclave (hardware encryption)
- System Integrity Protection (SIP)
- FileVault full-disk encryption
- Gatekeeper code signing enforcement

---

## AI GOVERNANCE & COMPLIANCE

### Explainable AI Implementation

**Purpose:** Meet CMMC Level 2 requirements for AI transparency and human oversight

**Components:**
| Component | NIST Control | Description |
|-----------|--------------|-------------|
| Confidence Scoring | 3.3.1 | Quantified certainty levels for all AI outputs |
| Evidence Logging | 3.3.2 | Supporting data captured for each recommendation |
| Human Review Flags | 3.4.1 | Required/Recommended/Routine classification |
| Feedback Collection | 3.12.1 | Continuous evaluation and improvement tracking |
| Compliance Reports | 3.3.1 | Automated daily reports for audit documentation |

**Calibration Monitoring:**
- Expected HIGH confidence accuracy: 85%
- Expected MEDIUM confidence accuracy: 65%
- Expected LOW confidence accuracy: 35%
- Alert threshold: Calibration error > 25%

### AI Model Governance

**Model Inventory:**
| Model | Version | License | Location | Purpose |
|-------|---------|---------|----------|---------|
| Llama 3.3 70B | Instruct Q4_K_M | Llama 3.3 Community | ai server | SysAdmin assistance |
| Code Llama 7B | Standard | Llama 2 Community | ai server | Code assistance |

**Model Security:**
- All models run locally (no external API calls)
- No CUI data sent to external services
- Model outputs logged for audit
- Human approval required for all actions

---

## VULNERABILITY MANAGEMENT

### Patch Management Process

**Rocky Linux Systems:**
- Automated security updates via `dnf-automatic`
- Critical patches applied within 30 days
- Monthly full system updates
- Quarterly compliance verification via OpenSCAP

**macOS System:**
- Automatic security updates enabled
- Monthly macOS updates
- Ollama platform updates as released

**Python/AI Dependencies:**
- Virtual environment isolation
- Regular `pip` security audits
- Dependency pinning for reproducibility

### Known Vulnerabilities

**Status as of January 31, 2026:**
- All systems patched to current security levels
- No known critical vulnerabilities (CVSS >7.0)
- OpenSCAP scans: 110/110 checks passed (Rocky Linux systems)
- macOS security updates: Current
- Python dependencies: No known CVEs

**Vulnerability Scanning:**
- Weekly: Wazuh vulnerability detection
- Monthly: Manual security review
- Quarterly: OpenSCAP compliance scans
- As-needed: CVE monitoring and emergency patching

---

## LICENSE COMPLIANCE

### Open Source Licenses

**Rocky Linux:**
- **OS License:** Rocky Linux (GPL, BSD, Apache 2.0 various)
- **Core Packages:** GPL v2/v3, LGPL, BSD, MIT
- **Compliance:** All license requirements met

**macOS:**
- **OS License:** Proprietary (Apple EULA)
- **Open Source Components:** Darwin kernel (APSL), various BSD components

**Ollama & AI Models:**
- **Ollama:** MIT License (open source)
- **Llama 3.3 70B:** Llama 3.3 Community License (acceptable use policy applies)
- **Code Llama 7B:** Llama 2 Community License (acceptable use policy applies)

**SysAdmin Agent Dashboard:**
- **Streamlit:** Apache 2.0
- **LangChain:** MIT License
- **LangGraph:** MIT License
- **Python packages:** Various (MIT, BSD, Apache 2.0)

**OnlyOffice Desktop Editor:**
- **License:** AGPL-3.0 (open source)

### Commercial Licenses

- **SSL.com Wildcard Certificate:** Commercial (expires October 28, 2026)
- **macOS:** Included with hardware purchase
- All other software: Open source or included with OS

---

## SUPPLY CHAIN SECURITY

### Software Sources

**Rocky Linux Packages:**
- **Primary Source:** Rocky Linux official repositories
- **Extended Source:** Remi repository (PHP 8.2)
- **Verification:** GPG signature verification enabled
- **Mirror Security:** HTTPS-only package downloads
- **Integrity:** SHA-256 checksums verified

**Python Packages (SysAdmin Agent):**
- **Source:** Python Package Index (PyPI)
- **Verification:** pip hash verification
- **Isolation:** Virtual environment
- **Pinning:** requirements.txt with version locks

**Flatpak Applications:**
- **Source:** Flathub (official Flatpak repository)
- **Verification:** GPG signature verification
- **Sandboxing:** Flatpak isolation enabled

**macOS Software:**
- **Primary Source:** Apple Software Update (signed by Apple)
- **Verification:** Code signing mandatory (Gatekeeper)
- **Integrity:** Notarization required for third-party software

**Ollama & AI Models:**
- **Source:** Ollama official releases (GitHub / official site)
- **Verification:** SHA-256 checksums verified
- **Model Source:** Meta AI via Ollama registry
- **Trust:** Open source, community-vetted

### Supply Chain Risk Mitigation

- Software obtained only from trusted sources
- GPG/code signature verification mandatory
- No software from unknown/untrusted sources
- Regular security updates from official channels
- Air-gapped AI inference (no external model downloads in production)
- Python virtual environment isolation

---

## COMPLIANCE MAPPING

### NIST SP 800-171 Controls

**CM-8: Information System Component Inventory**
- **CM-8a:** Current inventory maintained (this SBOM)
- **CM-8b:** Inventory includes: system name, software packages, versions, vendors, licenses
- **CM-8c:** Inventory reviewed quarterly
- **CM-8d:** Updates tracked via version control

**SR-2: Supply Chain Risk Management**
- Software sources documented and verified
- Integrity checks performed (GPG, checksums)
- Only trusted vendors used

**SI-2: Flaw Remediation**
- Vulnerability tracking via Wazuh and CVE monitoring
- Automated security updates enabled
- Critical patches within 30 days

**3.3.1: Audit Events (AI Responses)**
- All AI responses logged with timestamps
- Confidence levels and evidence captured
- Human review requirements documented

**3.12.1: Security Assessment (AI Evaluation)**
- Continuous feedback collection
- Daily automated evaluation reports
- Calibration error monitoring

### CMMC Level 2 Requirements

- **Component Inventory:** Complete and current
- **Vulnerability Management:** Automated scanning and patching
- **Supply Chain Security:** Verified software sources
- **License Compliance:** All licenses documented
- **AI Governance:** Explainable AI with human oversight

---

## MAINTENANCE SCHEDULE

### SBOM Update Triggers

**Quarterly Reviews:**
- Scheduled review with SSP updates (March 31, June 30, September 30, December 31)
- Full package inventory refresh on all systems
- Verification of new software installations

**Event-Driven Updates:**
- New system added to network
- Major software installation or removal
- Platform upgrades (e.g., Rocky Linux 9.7 → 9.8)
- AI model additions or updates
- After security incidents requiring forensic analysis

**Annual:**
- Complete SBOM review and validation
- Cross-reference with CM-8 control assessment
- Update for CMMC assessments

---

## POINT OF CONTACT

**SBOM Owner:** Daniel Shannon
**Title:** System Administrator / Security Officer
**Organization:** The Contract Coach
**Email:** [Contact email]
**Phone:** [Contact phone]

**For Questions Regarding:**
- Software inventory accuracy
- Vulnerability management
- License compliance
- Supply chain security
- AI governance and compliance

---

## DOCUMENT CONTROL

**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Distribution:** Official Use Only - Need to Know Basis
**Retention:** Current + 3 years
**Next Review:** March 31, 2026
**Location:** `/home/dshannon/Documents/Certification and Compliance Evidence/Evidence/Software_Inventory/`
**GitHub:** `dshannon46-jpg/cyberhygiene-documentation`

---

**END OF SBOM v2.2**

*This document supports NIST SP 800-171 CM-8, SR-2, and CMMC Level 2 compliance requirements for the CyberHygiene Production Network.*
