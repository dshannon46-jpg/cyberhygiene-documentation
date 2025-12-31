# RISK ACCEPTANCE MEMORANDUM
## ClamAV Antivirus FIPS Mode Incompatibility

**Document Control:**
- **Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
- **Date:** December 26, 2025
- **Version:** 1.0
- **Status:** PENDING APPROVAL
- **Related POA&M:** POA&M-014 (Malware Protection FIPS Compliance)
- **NIST Control:** SI-3 (Malicious Code Protection)

---

## EXECUTIVE SUMMARY

This memorandum documents the acceptance of residual risk associated with the inability to deploy ClamAV antivirus software in a FIPS 140-2 compliant configuration on the CyberHygiene Production Network. Due to a known incompatibility between ClamAV 1.4.3 and OpenSSL 3 cryptographic libraries operating in FIPS mode, traditional endpoint antivirus protection cannot be implemented without disabling FIPS mode—which would result in non-compliance with NIST SP 800-171 cryptographic requirements.

**Risk Level:** MEDIUM (with compensating controls: LOW)

**Recommended Decision:** ACCEPT risk with documented compensating controls

---

## 1. ISSUE DESCRIPTION

### 1.1 Technical Problem

**System Configuration:**
- Operating System: Rocky Linux 9.6 (Blue Onyx)
- Cryptographic Mode: FIPS 140-2 enabled (required for NIST SP 800-171 compliance)
- Antivirus Software: ClamAV 1.4.3
- Cryptographic Library: OpenSSL 3 with FIPS provider

**Observed Behavior:**
When attempting to start ClamAV services (clamd, freshclam) or perform on-demand scans with FIPS mode enabled, the following errors occur:

```
LibClamAV Error: Can't load /var/lib/clamav/daily.cvd: Can't allocate memory
LibClamAV Error: cli_loaddbdir: error loading database /var/lib/clamav/daily.cvd
ERROR: Can't allocate memory
```

**Root Cause Analysis:**
- This is NOT a system memory issue (system has 30GB RAM, 19GB available)
- ClamAV 1.4.3 with OpenSSL 3 has a known bug when cryptographic operations are restricted to FIPS-approved algorithms
- The "memory allocation" error is a misleading message; the actual issue is cryptographic library incompatibility
- ClamAV attempts to use non-FIPS-approved algorithms during database verification, which are blocked by OpenSSL FIPS provider

**Investigation Date:** December 26, 2025
**Investigated By:** System Administrator (D. Shannon)

### 1.2 Impact on NIST SP 800-171 Compliance

**Affected Control:**
- **SI-3 - Malicious Code Protection**
  - **Requirement:** "Employ malicious code protection mechanisms at system entry and exit points to detect and eradicate malicious code."
  - **Current Implementation Status:** PARTIAL - Network-level protections in place, endpoint AV not operational

**SPRS Score Impact:**
- Without compensating controls: Potential deduction of 2-3 points
- With documented compensating controls: No deduction (alternate implementation)

---

## 2. ALTERNATIVES CONSIDERED

### 2.1 Option A: Disable FIPS Mode
**Description:** Disable FIPS 140-2 cryptographic restrictions to allow ClamAV to function

**Analysis:**
- ✅ Advantage: ClamAV would function normally
- ❌ Disadvantage: Loss of FIPS 140-2 compliance
- ❌ Disadvantage: Violation of NIST SP 800-171 SC-13 (Cryptographic Protection)
- ❌ Disadvantage: SPRS score reduction (-5 to -10 points)
- ❌ Disadvantage: Disqualification from CMMC Level 2 certification

**Decision:** **REJECTED** - Unacceptable compliance impact

### 2.2 Option B: Upgrade to FIPS-Compatible Commercial Antivirus
**Description:** Replace ClamAV with commercial enterprise antivirus (Trend Micro, McAfee, Symantec)

**Analysis:**
- ✅ Advantage: FIPS-compatible endpoint protection
- ✅ Advantage: Enterprise support and updates
- ❌ Disadvantage: Annual licensing cost: $1,500-$3,000 for 5 systems
- ❌ Disadvantage: 4-6 week procurement and deployment timeline
- ⚠️ Consideration: May introduce proprietary/closed-source software into environment

**Decision:** **DEFERRED** - Consider for future budget cycle (FY 2026)

### 2.3 Option C: Accept Risk with Compensating Controls
**Description:** Document risk acceptance and implement layered security controls to mitigate malware threats

**Analysis:**
- ✅ Advantage: Maintains FIPS 140-2 compliance
- ✅ Advantage: No additional cost
- ✅ Advantage: Immediate implementation
- ✅ Advantage: Defense-in-depth approach aligns with NIST best practices
- ⚠️ Consideration: Requires comprehensive documentation
- ⚠️ Consideration: Requires ongoing monitoring and validation

**Decision:** **RECOMMENDED** - Documented below

---

## 3. COMPENSATING CONTROLS

The CyberHygiene Production Network implements multiple layers of security controls that provide defense-in-depth malware protection, mitigating the absence of endpoint antivirus software.

### 3.1 Network Perimeter Protection

#### Suricata IDS/IPS (Implemented)
- **Technology:** Suricata 6.x Intrusion Detection/Prevention System
- **Location:** pfSense firewall (network perimeter)
- **Functionality:**
  - Real-time network traffic inspection
  - Signature-based malware detection
  - Protocol anomaly detection
  - Automatic blocking of known malicious IP addresses
- **Update Frequency:** Daily rule updates from Emerging Threats (ET) Open ruleset
- **Coverage:** 100% of inbound/outbound network traffic
- **NIST Control:** SI-4 (Information System Monitoring)

#### pfSense Firewall with Geo-blocking (Implemented)
- **Technology:** pfSense 2.7.x with stateful packet inspection
- **Functionality:**
  - Default-deny firewall policy
  - Geographic blocking of high-risk countries
  - Application-layer filtering
  - Connection rate limiting
- **NIST Control:** SC-7 (Boundary Protection)

### 3.2 Email Security

#### SpamAssassin with Malware Filtering (Implemented)
- **Technology:** SpamAssassin 3.4.6 integrated with Postfix/Dovecot
- **Status:** Active and running (verified December 26, 2025)
- **Functionality:**
  - Bayesian spam classification
  - Real-time Blackhole List (RBL) checking
  - SPF/DKIM/DMARC verification
  - Attachment filtering for executable file types
  - Content-based malware pattern detection
- **Effectiveness:** >95% spam detection rate
- **NIST Control:** SI-8 (Spam Protection), SI-3 (Malicious Code Protection - email gateway)

#### Email Attachment Restrictions (Implemented)
- **Blocked Extensions:** .exe, .bat, .cmd, .com, .pif, .scr, .vbs, .js
- **Quarantine:** Suspicious attachments moved to administrator review queue
- **NIST Control:** SI-3 (Malicious Code Protection)

### 3.3 Host-Based Security

#### File Integrity Monitoring (Implemented)
- **Technology:** Wazuh 4.x SIEM with FIM module
- **Coverage:** All 5 systems (dc1, ai, ws1, ws2, ws3)
- **Monitored Directories:**
  - `/bin`, `/sbin`, `/usr/bin`, `/usr/sbin`
  - `/etc` (all configuration files)
  - `/root` and `/home` (user directories)
  - `/var/www/html` (web content)
- **Functionality:**
  - Real-time detection of unauthorized file modifications
  - SHA-256 hash verification
  - Automatic alerting on changes
  - 30-day audit trail retention
- **NIST Control:** SI-7 (Software, Firmware, and Information Integrity)

#### SELinux Mandatory Access Control (Implemented)
- **Mode:** Enforcing (all systems)
- **Functionality:**
  - Application sandboxing and confinement
  - Prevention of unauthorized code execution
  - Process isolation
  - Type enforcement (TE) policy
- **Effect:** Prevents malware from executing outside allowed contexts
- **NIST Control:** AC-3 (Access Enforcement), AC-6 (Least Privilege)

#### System Hardening and Application Whitelisting (Implemented)
- **NIST CIS Benchmarks:** Applied and verified via OpenSCAP
- **Functionality:**
  - Disabled unnecessary services
  - Removed development tools from production systems
  - Read-only mounting of /boot partition
  - Executable space protection (NX bit enforcement)
- **Effect:** Limits attack surface for malware execution
- **NIST Control:** CM-7 (Least Functionality)

### 3.4 Operational Controls

#### System Activity Monitoring (Implemented)
- **Technology:** Wazuh SIEM + Auditd
- **Functionality:**
  - Real-time process execution monitoring
  - Network connection monitoring
  - User activity logging
  - Automated alerting on suspicious behavior
- **Monitoring Coverage:** 24/7 automated monitoring
- **Alert Response Time:** <1 hour during business hours
- **NIST Control:** SI-4 (Information System Monitoring), AU-6 (Audit Review)

#### Regular Vulnerability Scanning (Implemented)
- **Technology:** OpenSCAP with NIST 800-171 CUI profile
- **Frequency:** Monthly (minimum), on-demand as needed
- **Last Scan:** December 2025 - **100% compliant (105/105 checks passed)**
- **Remediation:** Critical/High findings addressed within 30 days
- **NIST Control:** RA-5 (Vulnerability Scanning)

#### Patch Management (Implemented)
- **Frequency:** Weekly security updates via `dnf upgrade`
- **Testing:** Updates tested on non-production system first
- **Deployment:** Automated with Ansible playbooks
- **Tracking:** All updates logged in change management system
- **NIST Control:** SI-2 (Flaw Remediation)

#### Air-Gapped Architecture (Implemented)
- **Configuration:** Production servers have NO direct internet access
- **Update Mechanism:** Updates downloaded via proxy/bastion host
- **Browsing Policy:** No web browsing permitted on production systems
- **Effect:** Eliminates drive-by download and web-based malware vectors
- **NIST Control:** SC-7 (Boundary Protection)

#### User Training and Awareness (Scheduled)
- **Frequency:** Annual mandatory training
- **Topics:** Phishing awareness, social engineering, safe computing
- **Next Training:** Q1 2026 (POA&M-006)
- **NIST Control:** AT-2 (Security Awareness Training)

---

## 4. RISK ASSESSMENT

### 4.1 Threat Analysis

**Primary Malware Threat Vectors:**

| Vector | Risk Level | Mitigated By | Residual Risk |
|--------|------------|--------------|---------------|
| Email attachments | HIGH | SpamAssassin, attachment filtering | LOW |
| Web downloads | HIGH | Air-gapped architecture, no browsing | NEGLIGIBLE |
| Removable media (USB) | MEDIUM | USB restrictions (POA&M-007), SELinux | LOW |
| Network-based attacks | MEDIUM | Suricata IDS/IPS, firewall | LOW |
| Insider threat | MEDIUM | Wazuh monitoring, FIM, audit logging | LOW |
| Supply chain (software) | MEDIUM | Package signature verification, SBOM | LOW |

### 4.2 Likelihood Assessment

**Without Endpoint Antivirus + With Compensating Controls:**

- **Probability of Malware Introduction:** LOW (5-15% annually)
  - Air-gapped systems eliminate most common infection vectors
  - Email filtering blocks >95% of malicious attachments
  - Network IDS/IPS detects known malware signatures
  - User population: 2-3 users (limited attack surface)

- **Probability of Undetected Infection:** VERY LOW (<5% annually)
  - File integrity monitoring detects unauthorized changes
  - Process monitoring detects anomalous behavior
  - Network monitoring detects command-and-control (C2) traffic
  - SELinux prevents unauthorized code execution

### 4.3 Impact Assessment

**If Malware Were to Successfully Infect a System:**

- **Confidentiality Impact:** MEDIUM
  - CUI data stored on encrypted volumes (LUKS AES-256)
  - Access controls limit data exposure
  - Network segmentation contains lateral movement

- **Integrity Impact:** MEDIUM
  - File integrity monitoring provides rapid detection
  - Daily backups allow restoration to known-good state
  - Database replication limits single-point-of-failure

- **Availability Impact:** LOW
  - Redundant systems and backups enable rapid recovery
  - Disaster recovery procedures documented and tested
  - Maximum tolerable downtime: 4 hours

### 4.4 Overall Risk Rating

**Risk Calculation:**
- Likelihood: LOW (2/5)
- Impact: MEDIUM (3/5)
- **Risk Score: 6/25 (LOW-MEDIUM)**

**With Compensating Controls:**
- **Adjusted Risk Score: 4/25 (LOW)**

**Risk Acceptance Justification:**
The residual risk of malware infection is acceptable given:
1. Multiple overlapping security controls (defense-in-depth)
2. Limited attack surface (air-gapped, no browsing, small user base)
3. Rapid detection capabilities (FIM, SIEM, IDS/IPS)
4. Documented incident response procedures
5. Regular backup and recovery testing

---

## 5. MONITORING AND VALIDATION

To ensure continued effectiveness of compensating controls, the following monitoring and validation activities will be performed:

### 5.1 Ongoing Monitoring

| Activity | Frequency | Responsibility | Evidence |
|----------|-----------|----------------|----------|
| Wazuh SIEM alert review | Daily | System Administrator | Alert logs |
| Suricata IDS/IPS review | Weekly | Security Officer | IDS logs, blocked connections |
| SpamAssassin effectiveness metrics | Monthly | System Administrator | Spam detection rate reports |
| File integrity monitoring reports | Weekly | System Administrator | FIM change reports |
| Security event log review | Daily | System Administrator | Auditd logs, auth logs |

### 5.2 Periodic Validation

| Activity | Frequency | Responsibility | Next Due |
|----------|-----------|----------------|----------|
| OpenSCAP compliance scan | Monthly | System Administrator | January 31, 2026 |
| Vulnerability assessment | Quarterly | Security Officer | March 31, 2026 |
| Penetration testing (optional) | Annually | External Assessor | Q4 2026 |
| Compensating controls review | Quarterly | Security Officer | March 31, 2026 |
| Risk reassessment | Annually | Security Officer | December 31, 2026 |

### 5.3 Success Metrics

**Key Performance Indicators (KPIs):**
- ✅ Zero successful malware infections detected (target: 0 per year)
- ✅ Suricata IDS detection rate >95% (measured against test malware signatures)
- ✅ SpamAssassin spam/malware blocking rate >95%
- ✅ File integrity monitoring 100% operational (all systems)
- ✅ Security patch compliance >95% within 30 days of release
- ✅ Incident response time <1 hour for critical alerts

---

## 6. CONTINGENCY PLANS

### 6.1 Short-Term Actions (0-6 Months)

1. **Enhanced Monitoring:**
   - Configure additional Wazuh rules for malware-like behavior
   - Enable verbose logging for Suricata IDS/IPS
   - Implement automated alerting for suspicious file modifications

2. **Procedural Controls:**
   - Quarterly review of this risk acceptance memo
   - Monthly verification of compensating control effectiveness
   - Update incident response procedures to include malware-specific scenarios

3. **Training:**
   - Complete security awareness training (POA&M-006, due Q1 2026)
   - Tabletop exercise for malware incident response (POA&M-SPRS-2, due Q2 2026)

### 6.2 Long-Term Actions (6-12 Months)

1. **Commercial AV Evaluation:**
   - Research FIPS-compatible commercial antivirus solutions
   - Request quotes for 5-system license (FY 2026 budget consideration)
   - Pilot test leading candidate in non-production environment

2. **Alternative Technologies:**
   - Evaluate application whitelisting solutions (e.g., fapolicyd)
   - Consider host-based intrusion prevention systems (HIPS)
   - Assess cloud-based malware scanning for email attachments

### 6.3 Trigger Events for Reassessment

This risk acceptance will be immediately reassessed if any of the following occur:

- ✗ Successful malware infection detected on any system
- ✗ Compensating control failure (e.g., Wazuh SIEM offline >24 hours)
- ✗ Change in threat landscape (new malware targeting Rocky Linux 9)
- ✗ Regulatory requirement change mandating endpoint AV
- ✗ CMMC assessor requires endpoint AV for certification
- ✗ ClamAV FIPS compatibility fix becomes available
- ✗ Two or more compensating controls fail simultaneously

---

## 7. APPROVAL AND ACCEPTANCE

### 7.1 Recommendation

Based on the analysis presented in this memorandum, it is recommended that the residual risk associated with the absence of endpoint antivirus software be **ACCEPTED**, subject to the following conditions:

1. ✅ All documented compensating controls remain operational and effective
2. ✅ Monitoring and validation activities are performed as scheduled
3. ✅ This risk acceptance is reviewed quarterly and reassessed annually
4. ✅ Commercial antivirus solution is evaluated during FY 2026 budget cycle
5. ✅ Incident response procedures are updated to address malware scenarios

### 7.2 Supporting Documentation

The following documents support this risk acceptance decision:

- **POA&M-014:** Malware Protection FIPS Compliance (status: BLOCKED)
- **System Security Plan v1.6:** Section on Malicious Code Protection (SI-3)
- **OpenSCAP Compliance Report:** December 2025 (100% pass rate)
- **Wazuh SIEM Configuration:** File Integrity Monitoring rules
- **Suricata IDS/IPS Logs:** Network threat detection evidence
- **SpamAssassin Configuration:** Email filtering effectiveness report
- **Technical Investigation Report:** ClamAV FIPS Incompatibility (December 26, 2025)

### 7.3 Approval Signature Blocks

---

**RECOMMENDED FOR APPROVAL:**

**System Administrator:**
Name: Daniel Shannon
Signature: _________________________________ Date: __________
Recommendation: ACCEPT with compensating controls

---

**REVIEWED BY:**

**Security Officer:**
Name: Daniel Shannon
Signature: _________________________________ Date: __________
Concurrence: [ ] Approve  [ ] Disapprove  [ ] Approve with Modifications

---

**FINAL APPROVAL:**

**System Owner / Authorizing Official:**
Name: _______________________
Signature: _________________________________ Date: __________
Decision: [ ] ACCEPT RISK  [ ] REJECT (require additional controls)

---

**Risk Acceptance Period:** December 26, 2025 - December 31, 2026 (1 year)
**Next Review Date:** March 31, 2026 (Quarterly)
**Reassessment Date:** December 31, 2026 (Annual)

---

## 8. REVISION HISTORY

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-26 | D. Shannon | Initial risk acceptance memo for ClamAV FIPS incompatibility |

---

**CLASSIFICATION:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**DISTRIBUTION:** Official Use Only - Need to Know Basis
**RETENTION:** 3 years from date of supersession or 6 years from approval date, whichever is later

---

**END OF DOCUMENT**
