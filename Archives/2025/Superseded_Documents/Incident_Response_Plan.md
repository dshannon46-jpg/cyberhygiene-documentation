# INCIDENT RESPONSE PLAN
**Organization:** The Contract Coach (Donald E. Shannon LLC)
**System:** CyberHygiene Production Network (cyberinabox.net)
**Version:** 1.0
**Effective Date:** November 1, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)

**NIST Controls:** IR-1, IR-4, IR-5, IR-6, IR-7, IR-8

---

## DOCUMENT CONTROL

| Name / Title | Role | Signature / Date |
|---|---|---|
| Donald E. Shannon<br>Owner/Principal | System Owner | _____________________<br>Date: _______________ |
| Donald E. Shannon<br>Owner/Principal | ISSO / Incident Response Coordinator | _____________________<br>Date: _______________ |

**Review Schedule:** Annually or after significant incident
**Next Review Date:** November 1, 2026

---

## 1. PURPOSE AND SCOPE

### 1.1 Purpose
This Incident Response Plan (IRP) establishes procedures for detecting, responding to, reporting, and recovering from cybersecurity incidents affecting The Contract Coach's CyberHygiene Production Network. This plan ensures compliance with NIST SP 800-171 incident response requirements and DFARS 252.204-7012 cyber incident reporting obligations.

### 1.2 Scope
This plan applies to:
- All systems within the cyberinabox.net domain
- Domain controller (dc1.cyberinabox.net)
- All workstations (ws1, ws2, ws3)
- Network infrastructure (pfSense firewall)
- All data classified as CUI or FCI
- System owner and authorized users

### 1.3 Incident Definition
A cybersecurity incident is any event that:
- Compromises confidentiality, integrity, or availability of CUI/FCI
- Represents an actual or suspected violation of security policies
- Results in unauthorized access to systems or data
- Involves malware infection or attempted infection
- Represents a denial of service or system compromise
- Involves theft or loss of CUI-containing devices or media

---

## 2. INCIDENT RESPONSE TEAM

### 2.1 Team Structure
For a single-person organization, the Incident Response Team consists of:

**Incident Response Coordinator:** Donald E. Shannon
- Primary responsibility for all incident response activities
- Detection, analysis, containment, eradication, recovery
- External notifications and reporting
- Documentation and lessons learned

**External Resources:**
- FBI Cyber Division (for significant incidents)
- DoD Cyber Crime Center (DC3) (for defense-related incidents)
- SSL.com Support (certificate-related incidents)
- Rocky Linux Security Team (OS vulnerabilities)
- Local law enforcement (physical security incidents)

### 2.2 Contact Information

**Internal Contact:**
- Name: Donald E. Shannon
- Title: Owner/Principal, ISSO
- Phone: 505-259-8485
- Email: Don@Contractcoach.com
- Alternate: dshannon46@gmail.com

**External Emergency Contacts:**

**FBI Cyber Division:**
- Phone: 1-855-292-3937 (1-855-CYBER-37)
- Email: cywatch@fbi.gov
- Website: https://www.ic3.gov

**DoD Cyber Crime Center (DC3):**
- Defense Industrial Base (DIB) Cybersecurity Program
- Phone: 410-981-0096
- Email: dibcac@dc3.mil
- Portal: https://dibnet.dod.mil

**US-CERT (CISA):**
- Phone: 1-888-282-0870
- Email: central@us-cert.gov
- Website: https://www.us-cert.gov

**Rocky Linux Security:**
- Email: secalert@rockylinux.org
- Mailing List: rocky-security-announce@lists.resf.org

---

## 3. INCIDENT CATEGORIES AND SEVERITY

### 3.1 Incident Categories

**Category 1: Unauthorized Access**
- Successful intrusion into systems or networks
- Unauthorized privilege escalation
- Account compromise or credential theft
- Unauthorized access to CUI/FCI data

**Category 2: Malware**
- Virus, worm, or trojan detection
- Ransomware infection
- Rootkit or backdoor installation
- Potentially unwanted programs (PUPs)

**Category 3: Denial of Service**
- Network or system unavailability
- Resource exhaustion attacks
- Distributed denial of service (DDoS)
- Service degradation

**Category 4: Data Breach**
- CUI/FCI data exfiltration
- Unauthorized disclosure of sensitive information
- Loss or theft of devices containing CUI
- Improper data disposal

**Category 5: Physical Security**
- Unauthorized physical access to facilities
- Theft or loss of equipment
- Damage to systems or infrastructure
- Environmental incidents (fire, flood, power)

**Category 6: Policy Violation**
- Insider threat activities
- Unauthorized software installation
- Policy circumvention attempts
- Misuse of systems or resources

### 3.2 Severity Levels

**CRITICAL (P1) - Immediate Response Required**
- Active data breach involving CUI/FCI exfiltration
- Ransomware infection with data encryption
- Complete system compromise or takeover
- Widespread malware outbreak
- **Response Time:** Immediate (within 15 minutes)
- **Reporting:** Within 72 hours to DoD (DFARS requirement)

**HIGH (P2) - Urgent Response Required**
- Confirmed unauthorized access to systems
- Suspected CUI/FCI data compromise
- Significant service disruption
- Multiple system malware infections
- **Response Time:** Within 1 hour
- **Reporting:** Within 72-96 hours as appropriate

**MEDIUM (P3) - Prompt Response Required**
- Attempted unauthorized access (blocked)
- Single system malware infection (contained)
- Policy violations with security impact
- Suspicious activity requiring investigation
- **Response Time:** Within 4 hours
- **Reporting:** Per normal procedures

**LOW (P4) - Standard Response**
- Failed login attempts (normal threshold)
- Blocked malware attempts
- Minor policy violations
- Routine security alerts
- **Response Time:** Within 24 hours
- **Reporting:** Document in logs only

---

## 4. INCIDENT RESPONSE PROCESS

### 4.1 Phase 1: PREPARATION

**Ongoing Activities:**
- [ ] Maintain Wazuh SIEM monitoring operational 24/7
- [ ] Keep vulnerability signatures updated (hourly)
- [ ] Maintain current system backups (daily + weekly)
- [ ] Review security alerts daily
- [ ] Keep incident response kit ready (forensic tools, contact lists)
- [ ] Maintain evidence storage (USB drives, external storage)
- [ ] Keep offline copies of critical documentation
- [ ] Test backup restoration procedures monthly

**Incident Response Tools:**
- Wazuh SIEM/XDR for detection and monitoring
- Audit logs: /var/log/audit/audit.log
- System logs: journalctl
- Network capture: tcpdump, Wireshark
- Forensic imaging: dd, dc3dd
- Hash verification: sha256sum
- FreeIPA logs: /var/log/dirsrv/, /var/log/krb5kdc.log

### 4.2 Phase 2: DETECTION AND ANALYSIS

**Detection Sources:**
1. **Wazuh SIEM Alerts**
   - High/critical severity alerts require immediate review
   - File integrity monitoring alerts
   - Malware detection alerts
   - Authentication failure patterns
   - Vulnerability detection alerts

2. **System Monitoring**
   - Unusual CPU/memory/network usage
   - Unexpected processes or services
   - Unauthorized scheduled tasks
   - Suspicious file modifications

3. **User Reports**
   - Unusual system behavior
   - Suspicious emails or phishing attempts
   - Lost or stolen devices
   - Observed policy violations

**Initial Analysis Checklist:**
- [ ] Identify incident category and severity level
- [ ] Document initial indicators of compromise (IOCs)
- [ ] Determine affected systems and scope
- [ ] Assess potential impact to CUI/FCI data
- [ ] Begin incident log and timeline
- [ ] Preserve volatile evidence if needed
- [ ] Escalate to appropriate severity level

**Incident Log Template:**
```
Incident ID: INC-YYYY-MM-DD-###
Detection Time: [Date/Time]
Reported By: [Source]
Category: [Category]
Severity: [P1/P2/P3/P4]
Affected Systems: [List]
Initial Description: [Brief summary]
```

### 4.3 Phase 3: CONTAINMENT

**Short-Term Containment (Immediate Actions):**

**For Malware Infections:**
- [ ] Isolate infected system from network
  ```bash
  sudo ip link set <interface> down
  ```
- [ ] Kill malicious processes if identified
- [ ] Block malicious IPs at firewall
- [ ] Disable compromised user accounts
  ```bash
  ipa user-disable <username>
  ```
- [ ] Take memory dump if needed for forensics
- [ ] Document all containment actions with timestamps

**For Unauthorized Access:**
- [ ] Force password resets for affected accounts
- [ ] Revoke Kerberos tickets
  ```bash
  ipa user-mod <username> --password-expiration=now
  kdestroy
  ```
- [ ] Block source IP addresses at firewall
- [ ] Review and close unauthorized access paths
- [ ] Enable additional logging if needed

**For Data Breach:**
- [ ] Identify scope of compromised data
- [ ] Preserve evidence of exfiltration
- [ ] Document affected CUI/FCI datasets
- [ ] Notify appropriate authorities (DoD within 72 hours)
- [ ] Assess notification requirements for affected parties

**Long-Term Containment:**
- [ ] Apply temporary security patches or workarounds
- [ ] Implement compensating controls
- [ ] Segment affected systems on separate VLAN if needed
- [ ] Increase monitoring and logging on affected systems
- [ ] Prepare for system rebuild if compromise severe

### 4.4 Phase 4: ERADICATION

**Malware Eradication:**
- [ ] Identify and remove all malware components
- [ ] Scan all systems with updated AV definitions
- [ ] Remove backdoors, rootkits, or persistence mechanisms
- [ ] Clean or reimage affected systems
- [ ] Verify eradication with multiple tools
- [ ] Check for lateral movement to other systems

**Access Restoration:**
- [ ] Close all unauthorized access paths
- [ ] Remove unauthorized user accounts
- [ ] Reset passwords for all potentially compromised accounts
- [ ] Revoke and reissue certificates if needed
- [ ] Patch vulnerabilities that enabled access
- [ ] Review and update firewall rules

**Verification:**
- [ ] Run full system scans (ClamAV, YARA)
- [ ] Verify file integrity (FIM baseline check)
- [ ] Review audit logs for residual activity
- [ ] Check for new IOCs or suspicious activity
- [ ] Confirm clean bill of health before restoration

### 4.5 Phase 5: RECOVERY

**System Restoration Process:**
1. **Verify Eradication Complete**
   - [ ] All malware removed
   - [ ] Vulnerabilities patched
   - [ ] Clean system validation

2. **Restore from Backup (if needed)**
   ```bash
   # Restore from last known clean backup
   sudo ipa-restore /var/lib/ipa/backup/ipa-full-YYYY-MM-DD-HH-MM-SS

   # Or restore specific files
   sudo restic restore latest --target /
   ```

3. **System Hardening**
   - [ ] Apply all security updates
   - [ ] Run OpenSCAP remediation
   - [ ] Verify FIPS mode enabled
   - [ ] Update firewall rules
   - [ ] Enable enhanced logging

4. **Service Restoration**
   - [ ] Bring systems back online gradually
   - [ ] Monitor for suspicious activity
   - [ ] Verify functionality of all services
   - [ ] Test authentication and access controls
   - [ ] Confirm data integrity

5. **Enhanced Monitoring**
   - [ ] Increase Wazuh alert sensitivity temporarily
   - [ ] Review logs frequently for 30 days
   - [ ] Watch for reinfection or continued IOCs
   - [ ] Document system behavior baseline

**Return to Operations Approval:**
- [ ] All eradication verification complete
- [ ] System functionality validated
- [ ] Enhanced monitoring in place
- [ ] Incident documentation complete
- [ ] Sign-off by System Owner

### 4.6 Phase 6: POST-INCIDENT ACTIVITY

**Lessons Learned Meeting:**
Conduct within 7 days of incident closure.

**Discussion Topics:**
1. What happened and when was it detected?
2. How well did staff and procedures work?
3. What information was needed sooner?
4. Were any actions taken that might have inhibited recovery?
5. What would we do differently next time?
6. How can we prevent similar incidents?
7. What corrective actions are needed?

**Documentation Requirements:**
- [ ] Complete incident report with timeline
- [ ] Document all indicators of compromise (IOCs)
- [ ] Preserve forensic evidence (if applicable)
- [ ] Record all actions taken and by whom
- [ ] Document root cause analysis
- [ ] List corrective actions and responsible parties
- [ ] Update incident response procedures if needed
- [ ] Share IOCs with security community (anonymized)

**Corrective Actions:**
- [ ] Update security controls
- [ ] Apply additional patches
- [ ] Revise policies or procedures
- [ ] Implement new monitoring rules
- [ ] Update training materials
- [ ] Schedule follow-up reviews

---

## 5. EXTERNAL REPORTING REQUIREMENTS

### 5.1 DFARS 252.204-7012 Reporting

**When Required:**
Cyber incidents affecting covered defense information (CDI) or affecting contractor's ability to perform on DoD contract.

**Reporting Timeline:** Within **72 hours** of discovery

**Reporting Method:**
- DoD Cyber Crime Center (DC3) at https://dibnet.dod.mil
- Submit incident report with:
  - Description of incident
  - Type of information compromised
  - Systems/networks affected
  - Timeframe of incident
  - Actions taken to respond

**Report Template Elements:**
```
1. Contractor Information
   - Company name, CAGE code, POC

2. Contract Information
   - Contract number(s) affected
   - Contracting activity

3. Incident Details
   - Date/time of discovery
   - Type of incident
   - Systems affected
   - Data compromised (CDI/CUI)

4. Impact Assessment
   - Scope of breach
   - Data at risk
   - Operational impact

5. Response Actions
   - Containment steps taken
   - Mitigation measures
   - Evidence preservation
```

### 5.2 Other Reporting Requirements

**FBI Cyber Division (IC3):**
- Major cyber crimes
- Significant financial fraud
- Organized cybercrime activity
- Report via: https://www.ic3.gov

**US-CERT (CISA):**
- Significant incidents affecting critical infrastructure
- Novel attack methods
- Widespread vulnerabilities
- Email: central@us-cert.gov

**Law Enforcement:**
- Physical theft of equipment
- Criminal activity observed
- Contact local FBI field office

---

## 6. EVIDENCE PRESERVATION

### 6.1 Digital Evidence Handling

**Chain of Custody Requirements:**
- Document who collected evidence, when, and how
- Maintain evidence in secured location
- Limit access to authorized personnel only
- Use write-blockers for disk imaging
- Generate and document hash values
- Preserve original evidence, work with copies

**Evidence Collection Procedures:**

**1. Volatile Data (capture before system shutdown):**
```bash
# Memory dump
sudo dd if=/dev/mem of=/evidence/memory-$(hostname)-$(date +%Y%m%d-%H%M%S).img

# Network connections
sudo ss -tulpn > /evidence/network-connections.txt

# Running processes
ps auxww > /evidence/processes.txt

# Logged in users
who -a > /evidence/users.txt
```

**2. Non-Volatile Data:**
```bash
# Disk imaging (use write blocker)
sudo dd if=/dev/sda of=/evidence/disk-image.img bs=4M conv=noerror,sync
sha256sum /evidence/disk-image.img > /evidence/disk-image.img.sha256

# Log files
sudo tar -czf /evidence/logs-$(hostname)-$(date +%Y%m%d).tar.gz /var/log/
```

**3. Evidence Documentation:**
- Date and time of collection
- System name and IP address
- Person who collected evidence
- Tools and methods used
- Hash values for integrity verification
- Storage location and access control

### 6.2 Evidence Retention

**Retention Period:**
- All incident evidence: 3 years minimum
- Evidence for ongoing legal/regulatory matters: Until case resolved
- High-severity incidents: 7 years

**Storage Requirements:**
- Encrypted storage media
- Access logs maintained
- Multiple copies (on-site + off-site)
- Regular integrity checks

---

## 7. COMMUNICATION PLAN

### 7.1 Internal Communications

**Incident Notification:**
Since this is a single-person organization, formal internal notification is not required. However, maintain detailed incident log for own reference and auditing.

### 7.2 External Communications

**Customer Notification (if CUI/FCI compromised):**
- Determine contractual notification requirements
- Coordinate with customer's security team
- Provide factual, timely updates
- Document all customer communications

**Regulatory Authorities:**
- DoD: Within 72 hours (DFARS requirement)
- FBI: For significant criminal activity
- US-CERT: For novel or widespread threats

**Vendors/Partners:**
- Notify if their systems potentially affected
- Share threat indicators (anonymized)
- Request assistance if needed

**Public Communications:**
- Generally not required for small business
- Consult legal counsel before public disclosure
- Coordinate with law enforcement if investigation ongoing

---

## 8. SPECIFIC INCIDENT SCENARIOS

### 8.1 Ransomware Attack

**Immediate Actions:**
1. Isolate infected systems immediately
2. Do NOT pay ransom
3. Identify ransomware variant (Wazuh alerts)
4. Check for decryption tools available
5. Restore from last clean backup
6. Report to FBI via IC3

**Prevention:**
- Daily backups with offline copies
- User training on phishing
- Email filtering and web filtering
- Restrict PowerShell execution
- Application whitelisting

### 8.2 Phishing / Social Engineering

**Response:**
1. Mark email as phishing in email client
2. Report to email provider
3. Check if any links clicked or files downloaded
4. Scan system for malware
5. Reset passwords if credentials entered
6. Report to FBI IC3 if financial loss

**Prevention:**
- Security awareness training
- Email filtering (SPF, DKIM, DMARC)
- Multi-factor authentication
- User verification before sensitive actions

### 8.3 Lost or Stolen Device

**Response:**
1. Report to local law enforcement
2. Remotely wipe device if capability exists
3. Disable user accounts associated with device
4. Revoke certificates
5. Assess CUI/FCI data on device
6. Notify DoD if CDI/CUI was on device
7. Report to FBI if device contained classified info

**Prevention:**
- Full disk encryption (LUKS) on all devices
- Strong authentication
- Auto-lock screens
- Remote wipe capability
- Data minimization on mobile devices

### 8.4 Insider Threat

**Response:**
1. Document all suspicious activity
2. Preserve evidence before confrontation
3. Disable account access immediately if termination
4. Review audit logs for extent of activity
5. Assess data accessed or exfiltrated
6. Report to law enforcement if criminal

**Prevention:**
- Principle of least privilege
- Separation of duties (where possible)
- Audit logging and review
- Background checks
- Exit procedures and access termination

### 8.5 Vulnerability Exploitation

**Response:**
1. Identify affected systems
2. Apply emergency patch or workaround
3. Check for exploitation in logs
4. Search for IOCs of successful exploit
5. Increase monitoring on affected systems

**Prevention:**
- Automated patching (dnf-automatic)
- Vulnerability scanning (Wazuh)
- Network segmentation
- Intrusion detection

---

## 9. TRAINING AND TESTING

### 9.1 Training Requirements

**Annual Training:**
- Incident response procedures review
- Roles and responsibilities
- Reporting requirements
- Evidence handling procedures
- Communication protocols

**Next Training Date:** November 1, 2026

### 9.2 Plan Testing

**Tabletop Exercises:**
- Frequency: Semi-annually
- Scenario-based walk-through of procedures
- Identify gaps or improvements needed
- Update plan based on findings

**Next Exercise:** May 1, 2026

**Testing Scenarios:**
1. Ransomware infection scenario
2. Data breach via phishing
3. Lost device with CUI
4. Insider threat investigation
5. Zero-day vulnerability exploitation

---

## 10. PLAN MAINTENANCE

**Review Schedule:**
- Annual review (minimum)
- After significant incidents
- After major system changes
- After regulatory changes
- After testing exercises

**Update Triggers:**
- New systems or services deployed
- Changes to external requirements
- Lessons learned from incidents
- Testing identifies gaps
- Contact information changes

**Version Control:**
| Version | Date | Changes | Author |
|---|---|---|---|
| 1.0 | Nov 1, 2025 | Initial release | D. Shannon |
|  |  |  |  |
|  |  |  |  |

---

## APPENDIX A: INCIDENT SEVERITY MATRIX

| Factor | Critical (P1) | High (P2) | Medium (P3) | Low (P4) |
|---|---|---|---|---|
| **CUI/FCI Impact** | Confirmed exfiltration | Potential compromise | Attempted access | No impact |
| **System Impact** | Multiple systems down | Single system down | Degraded service | No impact |
| **Data Impact** | Data destroyed/encrypted | Data modified | Data accessed | No impact |
| **Scope** | Enterprise-wide | Multiple systems | Single system | Isolated |
| **Response Time** | Immediate (15 min) | 1 hour | 4 hours | 24 hours |
| **Reporting** | DoD + FBI (72 hrs) | DoD (72-96 hrs) | Internal | Logs only |

---

## APPENDIX B: INCIDENT RESPONSE CONTACT CARD

**Print and keep near workstation:**

```
┌─────────────────────────────────────────────────┐
│     INCIDENT RESPONSE QUICK REFERENCE           │
├─────────────────────────────────────────────────┤
│ INTERNAL CONTACT:                               │
│   Donald Shannon: 505-259-8485                  │
│   Don@Contractcoach.com                         │
│                                                 │
│ FBI CYBER: 1-855-292-3937 (cywatch@fbi.gov)    │
│ DoD DC3: 410-981-0096 (dibcac@dc3.mil)         │
│ US-CERT: 1-888-282-0870                        │
│                                                 │
│ CRITICAL INCIDENT STEPS:                        │
│  1. Isolate affected system                    │
│  2. Document incident details                  │
│  3. Preserve evidence                          │
│  4. Report within 72 hours (if CUI/CDI)        │
│  5. Begin containment actions                  │
└─────────────────────────────────────────────────┘
```

---

## APPENDIX C: INCIDENT REPORT TEMPLATE

**Incident ID:** INC-YYYY-MM-DD-###
**Report Date:** ___________________
**Reported By:** Donald E. Shannon

### INCIDENT SUMMARY
**Detection Date/Time:** ___________________
**Incident Category:** [ ] Unauthorized Access [ ] Malware [ ] DoS [ ] Data Breach [ ] Physical [ ] Policy Violation
**Severity Level:** [ ] Critical [ ] High [ ] Medium [ ] Low
**Affected Systems:** ___________________
**CUI/FCI Impact:** [ ] Yes [ ] No [ ] Unknown

### INCIDENT DESCRIPTION
[Detailed description of what happened, when discovered, and initial indicators]

### AFFECTED SYSTEMS AND DATA
**Systems:**
-
-

**Data:**
-
-

### TIMELINE OF EVENTS
| Date/Time | Event | Action Taken |
|---|---|---|
|  |  |  |
|  |  |  |

### RESPONSE ACTIONS
**Containment:**

**Eradication:**

**Recovery:**

### ROOT CAUSE ANALYSIS
**Cause:**
**Contributing Factors:**
**Vulnerabilities Exploited:**

### IMPACT ASSESSMENT
**Confidentiality:** [ ] None [ ] Minor [ ] Moderate [ ] Severe
**Integrity:** [ ] None [ ] Minor [ ] Moderate [ ] Severe
**Availability:** [ ] None [ ] Minor [ ] Moderate [ ] Severe

### LESSONS LEARNED
**What went well:**

**What needs improvement:**

**Corrective actions:**

### EXTERNAL REPORTING
**DoD Reported:** [ ] Yes [ ] No [ ] N/A - Date: _______
**FBI Reported:** [ ] Yes [ ] No [ ] N/A - Date: _______
**Customer Notified:** [ ] Yes [ ] No [ ] N/A - Date: _______

### CLOSURE
**Incident Resolved:** [ ] Yes [ ] No
**Closure Date:** ___________________
**Approved By:** ___________________

---

**END OF INCIDENT RESPONSE PLAN**
