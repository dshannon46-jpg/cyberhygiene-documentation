# System and Information Integrity Policy

**Document ID:** TCC-SI-001
**Version:** 1.0
**Effective Date:** November 2, 2025
**Review Schedule:** Annually or upon system changes
**Next Review:** November 2, 2026
**Owner:** Donald E. Shannon, ISSO/System Owner
**Distribution:** Authorized personnel only
**Classification:** Controlled Unclassified Information (CUI)

---

## Purpose

This policy establishes requirements for maintaining the integrity of systems and information within The Contract Coach's CyberHygiene Production Network (CPN), ensuring flaws are remediated, malicious code is detected, and security functions are monitored to protect Controlled Unclassified Information (CUI) and Federal Contract Information (FCI). It aligns with NIST SP 800-171 Revision 2 (SI-1 through SI-12) and supports CMMC Level 2 by integrating automated tools, including the Wazuh security information and event management (SIEM) platform deployed as the Wazuh Manager on dc1.cyberinabox.net (192.168.1.10). The policy safeguards data integrity for government contracting operations, including secure file storage on the encrypted RAID 5 array.

## Scope

This policy applies to all CPN systems, including:

**Server:**
- **dc1.cyberinabox.net** (192.168.1.10)
  - Rocky Linux 9.6 with FIPS 140-2 mode enabled
  - Wazuh Manager (centralized SIEM and security monitoring)
  - FreeIPA domain controller
  - Samba file server with encrypted RAID 5 storage
  - rsyslog centralized logging server

**Workstations:**
- LabRat (192.168.1.115)
- Engineering (192.168.1.104)
- Accounting (192.168.1.113)

**Network Infrastructure:**
- pfSense firewall (192.168.1.1, NetGate 2100)
  - Suricata IDS/IPS with Wazuh integration
  - Network traffic monitoring

**Security Tools:**
- **Wazuh SIEM:** Log aggregation, vulnerability detection, file integrity monitoring, active response
- **ClamAV:** Malware detection and prevention
- **dnf-automatic:** Automated security patching
- **OpenSCAP:** Compliance verification and configuration assessment
- **Suricata:** Network intrusion detection/prevention

**Personnel:**
- All users responsible for reporting system anomalies and integrity issues

**Exclusions:** Non-security integrity functions (e.g., business application logic, data validation) are covered under Configuration Management Policy.

## Definitions

- **Wazuh Manager:** Centralized SIEM server on dc1 for real-time monitoring, alerting, threat detection, and compliance reporting

- **Flaw Remediation:** Process of patching vulnerabilities and correcting security weaknesses, including those detected by Wazuh vulnerability scanner

- **Integrity Verification:** Confirmation that system configurations and file contents match approved baselines via Wazuh agents and OpenSCAP scans

- **Malicious Code:** Software designed to compromise system security, including viruses, worms, trojans, ransomware, spyware

- **File Integrity Monitoring (FIM):** Continuous monitoring of critical files and directories for unauthorized changes

- **CVE (Common Vulnerabilities and Exposures):** Standardized identifier for known security vulnerabilities

- **CVSS (Common Vulnerability Scoring System):** Standard for assessing severity of vulnerabilities (0.0-10.0 scale)

## Policy Statements

### 1. System and Information Integrity Policy and Procedures (SI-1)

The Contract Coach shall maintain and review this policy annually. Implementation procedures are documented in Section 2 of this document. Compliance is verified through:
- Quarterly Wazuh dashboard reviews
- Quarterly OpenSCAP compliance scans
- Monthly vulnerability scan reports
- Weekly flaw remediation status reviews

### 2. Flaw Remediation (SI-2)

**Vulnerability Identification:**
- Wazuh vulnerability detection runs continuously on all systems
- CVE feed updates every 60 minutes
- OpenSCAP scans quarterly (minimum)
- Manual security bulletins reviewed weekly (US-CERT, Rocky Linux, vendor advisories)

**Remediation Timelines:**
- **Critical vulnerabilities (CVSS 9.0-10.0):** 7 days maximum
- **High severity (CVSS 7.0-8.9):** 30 days
- **Medium severity (CVSS 4.0-6.9):** 90 days
- **Low severity (CVSS 0.1-3.9):** Next scheduled maintenance window

**Automated Patching:**
- `dnf-automatic` enabled on all CPN systems
- Security updates applied automatically (with testing on non-production first)
- Critical patches may require manual application with immediate testing

**Flaw Remediation Process:**
1. Wazuh vulnerability detector identifies flaw and generates alert
2. ISSO reviews alert and assesses CVSS score and exploitability
3. Prioritize remediation based on severity and criticality of affected system
4. Test patch on lowest-criticality system first (LabRat workstation)
5. Apply patch to production systems (workstations, then domain controller)
6. Verify FIPS mode integrity after patching: `fips-mode-setup --check`
7. Rescan with Wazuh and OpenSCAP to verify remediation
8. Document remediation in POA&M
9. Escalate to Owner/Principal if patch causes operational issues

**Exception Process:**
- If patch unavailable or incompatible, implement compensating controls
- Document accepted risk with Owner/Principal approval
- Add to POA&M with target remediation date
- Re-assess monthly until resolved

### 3. Malicious Code Protection (SI-3)

**Anti-Malware Deployment:**
- ClamAV installed on all CPN systems (domain controller and workstations)
- Wazuh agents monitor for malware indicators via FIM and log analysis
- Signature updates daily via `freshclam` service
- Real-time scanning of Samba file shares

**Scanning Schedule:**
- **Real-time:** Samba VFS scanner checks all files accessed on shares
- **Daily:** Automated full system scan at 2:00 AM
- **On-demand:** User-initiated scans for suspicious files
- **On-access:** ClamAV daemon monitors file operations

**Malware Response:**
```bash
# Automated quarantine for detected malware
# Wazuh active response moves infected files to /var/quarantine/
# ClamAV logs detections to /var/log/clamav/
# ISSO receives immediate alert via Wazuh dashboard
```

**Signature Updates:**
- ClamAV signatures update daily via `freshclam`
- Wazuh malware detection rules update automatically
- Custom YARA rules for targeted threats (if applicable)
- Verify update success daily: `sudo systemctl status clamav-freshclam`

**User Responsibilities:**
- Report suspicious files or behaviors immediately to ISSO
- Do not attempt to open or execute suspected malware
- Do not disable anti-malware tools
- Avoid downloading software from untrusted sources

### 4. System Monitoring (SI-4)

**Continuous Monitoring via Wazuh Manager:**
- **Log Aggregation:** rsyslog forwards all system logs to dc1
- **Real-Time Analysis:** Wazuh analyzes logs as they arrive
- **Alert Generation:** Immediate notifications for security events
- **Dashboard Visibility:** Real-time security posture via web interface

**Monitoring Scope:**
- Authentication attempts (successful and failed)
- Privilege escalation (sudo usage)
- File access on CUI directories (/srv/samba, /home)
- System configuration changes (/etc, /var/ossec, FreeIPA configs)
- Network connections (via Suricata IDS integration)
- Process execution (new binaries, suspicious commands)
- Software installation/removal (dnf activity)

**Network Monitoring:**
- Suricata IDS/IPS on pfSense monitors all network traffic
- Rules updated daily from Emerging Threats and Snort
- Integration with Wazuh for centralized alerting
- Focus on: malware communication, data exfiltration, port scans, DoS attacks

**File Integrity Monitoring (FIM):**
Wazuh monitors these critical paths (12-hour scan interval):
- `/etc/` - System configuration files
- `/var/ossec/` - Wazuh configuration
- `/etc/ipa/` - FreeIPA configuration
- `/etc/samba/` - Samba configuration
- `/srv/samba/` - CUI file shares (selected directories)
- `/usr/local/bin/` - Custom scripts
- `/boot/` - Boot files and kernel

**Alert Priorities:**
- **Critical:** Immediate ISSO notification (SMS/email), investigate within 1 hour
- **High:** Email alert, investigate within 4 hours
- **Medium:** Dashboard alert, review within 24 hours
- **Low:** Weekly summary review

**Review Schedule:**
- **Daily:** ISSO reviews Wazuh dashboard for critical/high alerts
- **Weekly:** Comprehensive review of all alerts and trends
- **Monthly:** Statistical analysis and reporting to Owner/Principal
- **Quarterly:** Monitoring effectiveness assessment

### 5. Security Alerts, Advisories, and Directives (SI-5)

**Information Sources:**
- **US-CERT (CISA):** Subscribe to alerts via email and RSS
- **Rocky Linux Security:** Monitor errata and security advisories
- **NIST National Vulnerability Database:** CVE notifications
- **Wazuh Feed:** Integrated vulnerability intelligence
- **Vendor Security Bulletins:** HP (firmware), NetGate (pfSense)
- **DISA STIGs:** DoD security guidance updates

**Alert Processing:**
1. Wazuh automatically ingests CVE feeds (updated hourly)
2. ISSO reviews US-CERT/CISA alerts weekly
3. Critical alerts trigger immediate assessment of CPN exposure
4. Applicable alerts generate remediation tasks in POA&M
5. High-priority alerts drive immediate patching (per SI-2 timelines)

**Dissemination:**
- Security-relevant alerts shared with all CPN users
- Training updates for new threat vectors (per TCC-AT-001)
- Contractor notifications for applicable risks
- Client notifications if contract-specific vulnerabilities identified

**Response Actions:**
```bash
# Example: US-CERT alert for critical Linux kernel vulnerability
# 1. Check CPN systems for vulnerable kernel version
uname -r
rpm -q kernel

# 2. Review Wazuh vulnerability detector for auto-detection
# Dashboard: Vulnerabilities > Search: CVE-YYYY-NNNNN

# 3. If vulnerable, apply emergency patch
sudo dnf update kernel --security
sudo reboot

# 4. Verify patch and FIPS mode post-reboot
uname -r
fips-mode-setup --check

# 5. Document in POA&M and incident log
```

### 6. Security Functionality Verification (SI-6)

**Quarterly Verification via OpenSCAP:**
```bash
# Run comprehensive CUI profile scan
sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --results /backup/compliance-scans/oscap-$(date +%Y%m%d).xml \
    --report /backup/compliance-scans/oscap-$(date +%Y%m%d).html \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

**Critical Security Functions to Verify:**
- **FIPS 140-2 mode:** `fips-mode-setup --check` (must return "FIPS mode is enabled")
- **SELinux enforcement:** `getenforce` (must return "Enforcing")
- **Firewall status:** `sudo firewall-cmd --state` (must return "running")
- **Audit daemon:** `sudo systemctl status auditd` (must be active)
- **Wazuh Manager:** `sudo systemctl status wazuh-manager` (must be active)
- **ClamAV updates:** `sudo systemctl status clamav-freshclam` (must be active)
- **Automatic updates:** `sudo systemctl status dnf-automatic.timer` (must be active)

**Wazuh Dashboard Correlation:**
- Review Wazuh compliance module for PCI-DSS, NIST 800-171, CIS benchmarks
- Correlate OpenSCAP results with Wazuh Security Configuration Assessment (SCA)
- Generate combined compliance report quarterly

**Deviation Response:**
- Any security function failure triggers immediate investigation
- Remediate within 30 days or document compensating control
- Critical function failures (FIPS, SELinux) require same-day remediation
- Update POA&M with remediation plan and target date

### 7. Software, Firmware, and Information Integrity (SI-7)

**Software Integrity:**
- All software installed via trusted repositories (Rocky Linux BaseOS, AppStream)
- Package signature verification enforced: `rpm --checksig`
- Checksum validation during updates: `dnf verify`
- Wazuh FIM detects unauthorized changes to binaries

**Firmware Integrity:**
- HP iLO 5 firmware on dc1 HP MicroServer Gen10+
- Firmware updates obtained directly from HP support site
- Checksum verification before applying updates
- Post-update verification via iLO console
- Document firmware versions in system baseline

**File Integrity Monitoring:**
Wazuh monitors file hashes (SHA-256) for:
- All files in `/etc/` (system configuration)
- All files in `/var/ossec/` (Wazuh configuration)
- FreeIPA configuration: `/etc/ipa/`, `/var/lib/ipa/`
- Samba configuration: `/etc/samba/`
- Critical binaries: `/bin/`, `/sbin/`, `/usr/bin/`, `/usr/sbin/`
- Boot files: `/boot/`

**Integrity Verification Process:**
```bash
# Verify RPM package integrity
sudo rpm -Va | grep -E '^..5' # Check for modified files

# Verify specific package
sudo rpm -V package_name

# Check Wazuh FIM alerts
# Dashboard: Integrity Monitoring > Search: last 24 hours

# Investigate unauthorized changes
sudo ausearch -f /path/to/modified/file -ts recent
```

**Response to Integrity Violations:**
1. Wazuh FIM alert triggers immediate investigation
2. Determine if change was authorized (check change log, recent admin activity)
3. If unauthorized:
   - Preserve evidence (copy audit logs)
   - Restore file from backup or reinstall package
   - Initiate incident response procedure (TCC-IRP-001)
   - Investigate root cause
4. Document all integrity incidents
5. Update baseline if change was legitimate but undocumented

### 8. Spam Protection (SI-8)

**Current Status:** Not applicable - CPN does not currently operate inbound email services

**Future Implementation (when Postfix/Dovecot deployed):**
- Deploy SpamAssassin or Rspamd for spam filtering
- Configure DKIM, SPF, DMARC for email authentication
- Implement sender reputation checks
- Quarantine suspected spam
- User training on phishing recognition

### 9. Information Input Validation (SI-10)

**Application-Level Controls:**
- Web applications (if deployed) shall validate all user inputs
- FreeIPA web interface uses built-in input validation
- Wazuh dashboard validates all API inputs
- Samba validates file names and paths

**System-Level Controls:**
- SELinux enforces type enforcement for all processes
- File system mount options enforce security (noexec, nosuid for /tmp)
- Firewall restricts network inputs to authorized ports/protocols

**User-Uploaded Files:**
- Samba shares scan all uploaded files with ClamAV (real-time)
- File type restrictions enforced (if configured)
- Max file size limits prevent DoS via storage exhaustion
- Executable files flagged and quarantined

### 10. Error Handling (SI-11)

**Error Message Policy:**
- System errors shall not reveal sensitive information (file paths, credentials, internal IP addresses)
- User-facing errors provide minimal detail
- Detailed error information logged to audit logs (ISSO access only)
- Application errors captured in centralized logging

**Logging Requirements:**
- All errors logged with sufficient detail for troubleshooting
- Error logs protected with same controls as audit logs
- SELinux prevents unauthorized error log access
- Wazuh monitors error patterns for anomalies

### 11. Information Handling and Retention (SI-12)

**CUI Data Handling:**
- All CUI data stored on LUKS-encrypted partitions (FIPS 140-2)
- CUI marked per 32 CFR Part 2002 requirements
- Access restricted via FreeIPA group membership
- Samba audit logging tracks all CUI file access

**Data Retention:**
- Audit logs: 90 days online, 3 years archived
- System backups: 30 days daily, 1 year full backups
- CUI documents: Per contract requirements (minimum 3 years)
- Compliance reports: 3 years
- Incident records: 3 years post-incident

**Secure Disposal:**
- LUKS-encrypted media: `cryptsetup luksErase` destroys encryption keys
- Unencrypted media (if any): `shred -vfz -n 10` (NIST SP 800-88)
- Physical media destruction for high-sensitivity data
- Document all disposal activities

## Roles and Responsibilities

| Role | Responsibilities |
|------|------------------|
| **ISSO (Don Shannon)** | Configure Wazuh rules and alerts; review dashboards daily; oversee vulnerability remediation; conduct integrity verifications; maintain documentation in `/backup/integrity-logs/`; respond to security alerts; coordinate incident response for integrity violations |
| **Owner/Principal (Don Shannon)** | Approve critical remediation actions; review quarterly Wazuh reports; accept residual risks; authorize emergency patches; ensure policy compliance |
| **Users/Contractors** | Report potential integrity issues immediately (unexpected file changes, suspicious behavior); comply with no-unauthorized-software rule; report malware detections; do not disable security tools |
| **System Administrator (ISSO concurrent role)** | Apply security patches; configure security tools; maintain system baselines; execute OpenSCAP scans; manage Wazuh Manager |

## Compliance and Enforcement

**Monitoring:**
- Wazuh dashboards provide real-time security metrics
- Quarterly OpenSCAP/Wazuh correlation reports
- Monthly vulnerability trending analysis
- Integration with Audit and Accountability Policy (TCC-AU-001) for log protection

**Training:**
- Covered in Security Awareness and Training Procedure (TCC-AT-002)
- Wazuh alert recognition and response
- Malware identification and reporting
- Incident reporting procedures

**Enforcement:**
- Non-compliance (e.g., ignored Wazuh alerts, disabled security tools) results in access revocation per Personnel Security Policy (TCC-PS-001)
- Security incidents trigger Incident Response Policy (TCC-IRP-001)
- Violations may result in contract termination

**Metrics:**
- Mean Time to Detect (MTTD): Target <1 hour
- Mean Time to Respond (MTTR): Target <4 hours
- Patch compliance rate: Target >95%
- OpenSCAP compliance score: Target >95%
- False positive rate: Track and tune Wazuh rules

## References

- NIST SP 800-171 Rev 2, SI Family (System and Information Integrity)
- NIST SP 800-53 Rev 5 (SI controls)
- System Security Plan (SSP), Section 3.14
- Wazuh Documentation: https://documentation.wazuh.com
- ClamAV Documentation: https://www.clamav.net/documents
- Rocky Linux Security Guide
- DISA STIG for RHEL 9
- Risk Management Policy (TCC-RA-001)
- Incident Response Policy (TCC-IRP-001)
- Configuration Management Baseline

---

## Section 2: System and Information Integrity Procedures

### Procedure 1: Daily Wazuh Dashboard Review

**Frequency:** Daily (weekday mornings)

**Process:**
1. Access Wazuh dashboard: https://dc1.cyberinabox.net:443
2. Review Security Events dashboard:
   - Critical and High severity alerts from last 24 hours
   - Authentication failures (look for patterns)
   - File Integrity Monitoring alerts
   - Malware detections
3. Review Vulnerabilities dashboard:
   - New CVEs detected
   - Critical vulnerabilities (CVSS >9.0)
   - Unpatched systems
4. Review Compliance dashboard:
   - NIST 800-171 compliance status
   - CIS benchmark failures
   - Configuration drift
5. Investigate any anomalies
6. Document findings in `/backup/integrity-logs/daily-review-$(date +%Y%m%d).txt`
7. Create tickets for remediation actions

**Time Required:** 15-30 minutes

### Procedure 2: Weekly Vulnerability Remediation

**Frequency:** Weekly (Friday mornings)

**Process:**
```bash
# 1. Review available security updates
sudo dnf updateinfo list security

# 2. Test updates on LabRat workstation first
# (SSH to LabRat)
sudo dnf update --security -y

# 3. Verify FIPS mode after update
fips-mode-setup --check

# 4. Reboot if kernel updated
sudo reboot

# 5. Post-reboot verification
uname -r
sudo systemctl status wazuh-agent

# 6. If successful, apply to other workstations
# (Repeat for Engineering and Accounting)

# 7. Finally, update domain controller (dc1) during maintenance window
# (Schedule for weekend or evening)

# 8. Document all updates in POA&M
```

### Procedure 3: Quarterly Compliance Verification

**Frequency:** Quarterly (first week of Jan, Apr, Jul, Oct)

**Process:**
```bash
# 1. Run comprehensive OpenSCAP scan
sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --results /backup/compliance-scans/oscap-$(date +%Y%m%d).xml \
    --report /backup/compliance-scans/oscap-$(date +%Y%m%d).html \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# 2. Review results
firefox /backup/compliance-scans/oscap-$(date +%Y%m%d).html

# 3. Verify critical security functions
fips-mode-setup --check
getenforce
sudo systemctl status auditd
sudo systemctl status wazuh-manager
sudo systemctl status clamav-freshclam

# 4. Generate Wazuh compliance report
# Dashboard: Management > Reporting > Generate Report (NIST 800-171)

# 5. Correlate findings
# Compare OpenSCAP failures with Wazuh SCA results
# Identify discrepancies

# 6. Create remediation plan for failures
# Add to POA&M with target dates

# 7. Brief Owner/Principal on compliance posture
# Provide summary report with trends

# 8. Update SSP if needed
```

---

## Appendix: Wazuh Alert Examples and Responses

### Example 1: File Integrity Violation
**Alert:** "File /etc/samba/smb.conf modified"
**Response:**
1. Check if change was authorized (recent admin activity?)
2. Review audit logs: `sudo ausearch -f /etc/samba/smb.conf -ts recent`
3. If unauthorized, restore from backup and investigate
4. If authorized, update change log

### Example 2: Critical Vulnerability Detected
**Alert:** "CVE-2024-XXXXX detected - CVSS 9.8 - kernel vulnerability"
**Response:**
1. Assess exploit availability (check NVD, exploit-db)
2. Verify all affected systems via Wazuh vulnerability dashboard
3. Test patch on LabRat within 24 hours
4. Deploy to production within 7 days
5. Document in POA&M

### Example 3: Malware Detection
**Alert:** "ClamAV detected: Trojan.Generic in /srv/samba/share/file.exe"
**Response:**
1. Automatic quarantine by ClamAV (moved to /var/quarantine/)
2. Identify user who uploaded file: `sudo grep file.exe /var/log/samba/log.smbd`
3. Notify user immediately
4. Scan user's workstation: `sudo clamscan -r /home/username/`
5. Initiate incident response if widespread infection
6. User training on safe file handling

---

## Approval

**Prepared By:**
Donald E. Shannon, ISSO

**Approved By:**
/s/ Donald E. Shannon
Owner/Principal, The Contract Coach

**Date:** November 2, 2025

**Next Review Date:** November 2, 2026
