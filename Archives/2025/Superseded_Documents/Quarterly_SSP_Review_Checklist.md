# QUARTERLY SYSTEM SECURITY PLAN REVIEW CHECKLIST
**Organization:** The Contract Coach (Donald E. Shannon LLC)
**System:** CyberHygiene Production Network (cyberinabox.net)
**Review Frequency:** Quarterly (Jan 31, Apr 30, Jul 31, Oct 31)
**NIST Control:** CA-2 (Security Assessments)

---

## DOCUMENT CONTROL

**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Review Period:** Q_____ (From: __________ To: __________)
**Review Date:** ____________________
**Reviewed By:** ____________________
**Next Review Due:** ____________________

---

## 1. ADMINISTRATIVE REVIEW

### 1.1 Personnel and Access Control Changes
- [ ] Review current user accounts (active/inactive)
- [ ] Verify no unauthorized accounts exist
- [ ] Check for accounts requiring deactivation
- [ ] Review sudo/privileged access assignments
- [ ] Verify Kerberos ticket policies are current
- [ ] Review password policy compliance

**Users Reviewed:** ______
**Changes Required:** [ ] Yes [ ] No
**Actions Taken:** _________________________________________________

### 1.2 System Inventory Updates
- [ ] Verify all systems are accounted for (dc1 + workstations)
- [ ] Check for new hardware additions
- [ ] Verify decommissioned equipment properly handled
- [ ] Update hardware inventory if changes detected
- [ ] Verify FIPS mode enabled on all systems

**Systems Inventoried:** ______
**Changes Detected:** [ ] Yes [ ] No
**Documentation Updated:** [ ] Yes [ ] No [ ] N/A

### 1.3 Contact Information
- [ ] Verify system owner contact information current
- [ ] Verify ISSO contact information current
- [ ] Update emergency contact procedures if needed

**Contacts Verified:** [ ] Yes [ ] No
**Updates Required:** _________________________________________________

---

## 2. TECHNICAL SECURITY REVIEW

### 2.1 Vulnerability Management
- [ ] Review Wazuh vulnerability scan results
- [ ] Identify critical/high vulnerabilities requiring action
- [ ] Verify vulnerability remediation timelines met
- [ ] Check CVE database for new threats to Rocky Linux 9
- [ ] Review security patch status (dnf-automatic logs)

**Critical Vulnerabilities:** ______
**High Vulnerabilities:** ______
**Remediation Status:** _________________________________________________

### 2.2 Security Monitoring and Logging
- [ ] Review Wazuh SIEM alerts and incidents
- [ ] Verify audit logging operational on all systems
- [ ] Check log storage capacity (target: <75% full)
- [ ] Review failed login attempts and lockouts
- [ ] Verify centralized logging functional
- [ ] Check for suspicious authentication patterns

**Alerts This Quarter:** ______
**Incidents Detected:** ______
**Log Storage Used:** ______%
**Actions Required:** _________________________________________________

### 2.3 File Integrity Monitoring
- [ ] Review Wazuh FIM alerts for unauthorized changes
- [ ] Verify no critical system files modified without approval
- [ ] Check for new files in sensitive directories
- [ ] Verify baseline integrity database current
- [ ] Document authorized changes to system files

**FIM Alerts:** ______
**Unauthorized Changes:** [ ] Yes [ ] No
**Actions Taken:** _________________________________________________

### 2.4 Malware Protection
- [ ] Verify ClamAV service operational and databases current
- [ ] Review YARA malware detection alerts
- [ ] Check VirusTotal integration status (if enabled)
- [ ] Verify no malware detected or properly remediated
- [ ] Update malware signatures if needed

**Malware Detected:** [ ] Yes [ ] No
**ClamAV Status:** [ ] Operational [ ] Issues Detected
**Actions Taken:** _________________________________________________

### 2.5 Backup and Recovery
- [ ] Verify daily backup completion (last 90 days)
- [ ] Verify weekly full backup completion
- [ ] Test sample file restoration
- [ ] Check backup storage capacity
- [ ] Verify offsite backup rotation current
- [ ] Review ReaR ISO creation logs

**Daily Backups Successful:** ______%
**Weekly Backups Successful:** ______%
**Last Restore Test:** __________________
**Actions Required:** _________________________________________________

### 2.6 Encryption and Cryptography
- [ ] Verify FIPS 140-2 mode enabled on all systems
- [ ] Check LUKS encryption status on all encrypted partitions
- [ ] Verify SSL/TLS certificates valid and not expiring soon
- [ ] Review certificate expiration dates
- [ ] Check Kerberos encryption types in use

**FIPS Mode:** [ ] Enabled All Systems [ ] Issues Detected
**Cert Expiration Dates:** _________________________________________________
**Actions Required:** _________________________________________________

---

## 3. COMPLIANCE REVIEW

### 3.1 OpenSCAP Compliance Scanning
- [ ] Run OpenSCAP CUI profile scan on all systems
- [ ] Verify 100% compliance maintained
- [ ] Review any newly failed checks
- [ ] Document remediation for failed items
- [ ] Update baseline if authorized changes made

**Compliance Score:** dc1: ___/110  ws1: ___/110  ws2: ___/110  ws3: ___/110
**Failed Checks:** ______
**Actions Required:** _________________________________________________

### 3.2 POA&M Status Review
- [ ] Review all open POA&M items
- [ ] Update completion status for each item
- [ ] Verify target dates realistic and achievable
- [ ] Escalate at-risk items
- [ ] Close completed items with evidence

**Total POA&M Items:** ______
**Completed This Quarter:** ______
**At Risk:** ______
**Overdue:** ______

### 3.3 Security Controls Assessment
- [ ] Review implementation status of all 110 NIST controls
- [ ] Identify controls requiring updates or improvements
- [ ] Verify compensating controls still effective
- [ ] Document any control weaknesses discovered
- [ ] Update SSP control descriptions if needed

**Controls Requiring Updates:** ______
**New Weaknesses Identified:** [ ] Yes [ ] No
**SSP Updated:** [ ] Yes [ ] No [ ] N/A

---

## 4. INCIDENT AND CHANGE MANAGEMENT

### 4.1 Incident Review
- [ ] Review all security incidents this quarter
- [ ] Verify incidents properly documented and resolved
- [ ] Identify trends or recurring issues
- [ ] Assess incident response effectiveness
- [ ] Update IR procedures based on lessons learned

**Incidents This Quarter:** ______
**Average Resolution Time:** ______
**Procedure Updates Needed:** [ ] Yes [ ] No

### 4.2 Change Management
- [ ] Review all system changes this quarter
- [ ] Verify changes properly authorized and documented
- [ ] Check for unauthorized or undocumented changes
- [ ] Assess impact of changes on security posture
- [ ] Update configuration baselines if needed

**Authorized Changes:** ______
**Configuration Baseline Current:** [ ] Yes [ ] No
**Documentation Updated:** [ ] Yes [ ] No [ ] N/A

---

## 5. TRAINING AND AWARENESS

### 5.1 Security Training
- [ ] Verify annual security awareness training current
- [ ] Review training completion records
- [ ] Identify need for additional training topics
- [ ] Update training materials if regulations changed
- [ ] Schedule next training cycle

**Last Training Date:** __________________
**Next Training Due:** __________________
**Updates Required:** [ ] Yes [ ] No

### 5.2 Policy and Procedure Updates
- [ ] Review all security policies for currency
- [ ] Check for new regulatory requirements
- [ ] Update procedures based on operational changes
- [ ] Verify all personnel aware of policy changes
- [ ] Document policy review and approval

**Policies Reviewed:** ______
**Updates Made:** [ ] Yes [ ] No
**Effective Date:** __________________

---

## 6. RISK ASSESSMENT

### 6.1 Threat Environment Review
- [ ] Review current threat landscape for government contractors
- [ ] Identify new threats applicable to small business
- [ ] Assess impact of recent cyber incidents in industry
- [ ] Update threat intelligence sources
- [ ] Adjust security controls based on threat changes

**New Threats Identified:** ______
**Risk Level Changes:** [ ] Yes [ ] No
**Control Adjustments:** _________________________________________________

### 6.2 Risk Register Update
- [ ] Review existing risk register entries
- [ ] Update risk likelihood and impact ratings
- [ ] Add newly identified risks
- [ ] Close mitigated risks
- [ ] Verify risk mitigation strategies effective

**Active Risks:** ______
**New Risks This Quarter:** ______
**Mitigated Risks:** ______

---

## 7. NETWORK AND INFRASTRUCTURE

### 7.1 Network Security
- [ ] Review pfSense firewall rules and policies
- [ ] Verify no unnecessary ports open
- [ ] Check for unusual network traffic patterns
- [ ] Review VPN access logs (if deployed)
- [ ] Verify network segmentation maintained

**Firewall Rules Reviewed:** [ ] Yes [ ] No
**Issues Detected:** [ ] Yes [ ] No
**Actions Taken:** _________________________________________________

### 7.2 Physical Security
- [ ] Verify physical access controls maintained
- [ ] Check environmental controls (HVAC, fire suppression)
- [ ] Review equipment location and security
- [ ] Verify visitor logs maintained (if applicable)
- [ ] Assess physical security improvements needed

**Physical Security Status:** [ ] Adequate [ ] Improvements Needed
**Actions Required:** _________________________________________________

---

## 8. THIRD-PARTY AND SUPPLY CHAIN

### 8.1 Vendor and Service Provider Review
- [ ] Review all third-party service providers
- [ ] Verify vendor security requirements met
- [ ] Check for vendor security incidents affecting systems
- [ ] Review SLAs and security agreements
- [ ] Assess vendor compliance with CUI requirements

**Active Vendors:** ______
**Security Issues:** [ ] Yes [ ] No
**Actions Required:** _________________________________________________

---

## 9. REVIEW SUMMARY AND ACTION ITEMS

### 9.1 Overall Security Posture
**Current Implementation Status:** ______%
**Compliance Status:** [ ] Fully Compliant [ ] Minor Issues [ ] Major Issues
**Overall Risk Rating:** [ ] Low [ ] Moderate [ ] High

### 9.2 Key Findings
1. _________________________________________________________________
2. _________________________________________________________________
3. _________________________________________________________________
4. _________________________________________________________________
5. _________________________________________________________________

### 9.3 Action Items with Deadlines
| # | Action Item | Responsible | Target Date | Status |
|---|---|---|---|---|
| 1 | | Shannon | | |
| 2 | | Shannon | | |
| 3 | | Shannon | | |
| 4 | | Shannon | | |
| 5 | | Shannon | | |

### 9.4 SSP Updates Required
- [ ] Update control descriptions
- [ ] Update system inventory
- [ ] Update POA&M section
- [ ] Update implementation status percentage
- [ ] Update risk assessment section
- [ ] Other: _________________________________________________

---

## 10. APPROVAL AND SIGN-OFF

**Review Completed By:**
Name: Donald E. Shannon
Title: System Owner / ISSO
Signature: ___________________________
Date: ___________________________

**Next Quarterly Review Scheduled:** ___________________________

**Review Status:** [ ] Complete [ ] Incomplete - Action Items Pending

---

## APPENDIX A: QUARTERLY REVIEW SCHEDULE

| Quarter | Review Period | Review Due Date | Status |
|---|---|---|---|
| Q1 2026 | Jan 1 - Mar 31 | January 31, 2026 | |
| Q2 2026 | Apr 1 - Jun 30 | April 30, 2026 | |
| Q3 2026 | Jul 1 - Sep 30 | July 31, 2026 | |
| Q4 2026 | Oct 1 - Dec 31 | October 31, 2026 | |

---

**END OF CHECKLIST**
