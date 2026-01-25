# Personnel Security Policy

**Document ID:** TCC-PS-001
**Version:** 1.0
**Effective Date:** November 2, 2025
**Review Schedule:** Annually or upon significant organizational changes
**Next Review:** November 2, 2026
**Owner:** Donald E. Shannon, ISSO/System Owner
**Distribution:** Authorized personnel only
**Classification:** Controlled Unclassified Information (CUI)

---

## Purpose

This policy establishes requirements for personnel security within The Contract Coach, ensuring that individuals accessing the CyberHygiene Production Network (CPN) and handling Controlled Unclassified Information (CUI) or Federal Contract Information (FCI) are trustworthy and appropriately vetted. It aligns with NIST SP 800-171 Revision 2 (PS-1 through PS-8) and supports CMMC Level 2 by mitigating insider threats through screening, access agreements, and termination/transfer processes. The policy promotes a secure environment for government contracting operations, including proposal development and contract administration.

## Scope

This policy applies to all personnel, including:

- **Employees:** Donald E. Shannon (Owner/Principal/ISSO)
- **Contractors and subcontractors:** Individuals accessing CPN resources via FreeIPA authentication or Samba file shares on dc1.cyberinabox.net
- **Third parties:** Any individual involved in CUI/FCI processing

**Personnel Lifecycle Coverage:**
- Onboarding and initial access provisioning
- Ongoing access maintenance and reviews
- Role changes and transfers
- Termination and access revocation

**Exclusions:** Non-CUI administrative staff (none currently).

**Note:** As a solopreneur business, the Owner/Principal holds a current Top Secret (TS) security clearance, which exceeds all requirements for CUI access screening. Many personnel security controls are not applicable due to the single-person nature of the organization.

## Definitions

- **Personnel Screening:** Verification of background, including criminal history, credit checks (where applicable), and security clearances

- **Access Agreement:** Non-Disclosure Agreement (NDA) or similar binding document outlining CUI handling responsibilities

- **Position Risk Designation:** Assessment of roles based on CUI access level (High/Moderate/Low)

- **Insider Threat:** Potential for harm from individuals with authorized access (malicious or accidental)

- **Separation:** Termination of employment or contract relationship

- **Transfer:** Change in job responsibilities or access requirements within the organization

## Policy Statements

### 1. Personnel Security Policy and Procedures (PS-1)

The Contract Coach shall maintain and review this policy annually. Procedures for implementation are documented in Section 2 of this document. Compliance is verified through:
- Quarterly System Security Plan (SSP) reviews
- Annual access recertification
- FreeIPA account audits
- Wazuh authentication log reviews

### 2. Position Risk Designation (PS-2)

All positions involving CPN access shall be designated based on risk level:

**High Risk:**
- **Position:** ISSO/System Owner/Owner/Principal
- **Access:** Full administrative access to all CPN systems
- **CUI Exposure:** Complete access to all CUI/FCI data
- **Requirement:** Top Secret security clearance (currently held by Don Shannon)
- **Screening:** FBI background investigation, credit check, reference interviews, adjudication by DoD CAF
- **Reinvestigation:** Every 5 years per TS clearance requirements

**Moderate Risk:**
- **Position:** Contractors/consultants with CUI access
- **Access:** Limited to specific Samba shares or workstations
- **CUI Exposure:** Partial access to specific CUI datasets
- **Requirement:** NDA execution, basic screening
- **Screening:** Self-attestation, proof of citizenship/residency, reference check
- **Review:** Annual recertification

**Low Risk:**
- **Position:** Administrative support without CUI access
- **Access:** No CPN access
- **CUI Exposure:** None
- **Requirement:** Minimal vetting
- **Current Status:** No such positions exist

**Review Triggers:**
- Role changes affecting access levels
- New contract requirements
- Security incidents involving personnel
- Annual policy review

### 3. Personnel Screening (PS-3)

Prior to granting CPN access, all personnel shall undergo screening proportional to position risk:

**High-Risk Positions (ISSO/Owner):**
- Top Secret security clearance process (already completed)
  - FBI background investigation (Single Scope Background Investigation)
  - Credit history review
  - Reference interviews with associates and neighbors
  - Criminal history check (FBI fingerprint-based)
  - Adjudication by DoD Consolidated Adjudication Facility (CAF)
- Result: TS clearance EXCEEDS requirements for CUI access per NIST SP 800-171
- Reinvestigation: Every 5 years per DoD requirements
- Current Status: Don Shannon holds active TS clearance

**Moderate-Risk Positions (Contractors):**
- Self-attestation form (template in `/backup/personnel-security/templates/`)
- Proof of U.S. citizenship or lawful permanent residency
- Criminal background check (if contract value >$10,000 or CUI access >30 days)
- Reference verification (minimum 2 professional references)
- NDA execution before any CPN access

**Screening Frequency:**
- Initial: Before first access to CPN
- Periodic: Every 5 years or upon clearance renewal
- Event-driven: After security incidents or concerning behavior

**Record Retention:**
- Screening documentation: 3 years post-separation
- NDA agreements: 7 years (contract requirement)
- Clearance verification: Duration of employment + 3 years
- Storage location: `/backup/personnel-security/` (LUKS encrypted)

### 4. Personnel Termination (PS-4)

Upon termination or separation (voluntary or involuntary):

**Immediate Actions (within 1 hour of notification):**
```bash
# Disable FreeIPA account
kinit admin
ipa user-disable <username>

# Verify account disabled
ipa user-show <username> | grep -i disabled

# Force Kerberos ticket expiration
# (automatic upon account disable)
```

**Within 24 Hours:**
- Conduct exit interview (if planned separation)
- Recover all CUI media:
  - Encrypted USB drives
  - Physical documents
  - Company-issued hardware (if applicable)
  - Access badges or keys

- Audit user activity logs:
```bash
# Review authentication history
sudo ausearch -ua <username> -ts recent

# Check file access on Samba shares
sudo grep <username> /var/log/samba/log.smbd

# Review Wazuh agent logs for user's workstation
# Dashboard: Agents > <agent> > Security Events
```

- Change any shared passwords known to separating individual
- Review and revoke any delegated administrative privileges

**Within 7 Days:**
- Complete documentation of separation in personnel file
- Archive user home directory (if needed for records retention)
- Update access control lists and group memberships
- Notify clients if contractor had direct client interaction
- File final activity report

**Notification Requirements:**
- **Planned Separations:** ISSO must be notified 48 hours in advance minimum
- **Unplanned Separations:** ISSO notified immediately upon decision
- **For Cause Terminations:** Immediate access revocation, no advance notice

**Post-Termination Monitoring:**
- Monitor for attempted access for 30 days post-separation
- Review Wazuh alerts for former username or associated IP addresses
- Verify no residual access remains (quarterly audit)

### 5. Personnel Transfer (PS-5)

For internal transfers or role changes affecting risk level or access requirements:

**Assessment Requirements:**
- Re-evaluate position risk designation
- Assess new CUI access requirements
- Determine if additional screening needed
- Review current clearance/screening adequacy

**Access Adjustments:**
```bash
# Remove from previous role groups
kinit admin
ipa group-remove-member <old_group> --users=<username>

# Add to new role groups
ipa group-add-member <new_group> --users=<username>

# Verify group memberships
ipa user-show <username> | grep -A 10 "Member of groups"

# Adjust Samba share permissions if needed
# Review /etc/samba/smb.conf for share ACLs
```

**Elevated Access Transfers:**
- If transfer increases CUI access, verify screening sufficiency
- Update position risk designation
- Require new NDA addendum if scope changes
- Conduct additional screening if moving from Low to Moderate/High risk

**Documentation:**
- Update personnel file within 7 days
- Document reason for transfer
- Record new access levels
- File screening updates (if applicable)
- Update SSP personnel listing

**Special Case - Solopreneur Environment:**
- Owner/Principal holds all roles (ISSO, System Owner, User)
- Transfers not applicable to single-person operation
- Document any changes in third-party contractor relationships

### 6. Access Agreements (PS-6)

All personnel shall sign an NDA or CUI Access Agreement prior to access, acknowledging:

**Required Agreement Elements:**
- Responsibilities for protecting CUI per 32 CFR Part 2002
- Proper CUI marking and handling procedures
- Incident reporting requirements per IR Policy (TCC-IRP-001)
- Acceptable use of CPN systems
- Prohibition on unauthorized disclosure
- Consequences of policy violations
- Agreement to comply with all security policies
- Acknowledgment of monitoring and audit rights

**Agreement Execution:**
- **Timing:** Before any CPN access granted
- **Method:** Digital signature accepted (via DocuSign or equivalent)
- **Witnesses:** Not required for NDAs
- **Copies:** Original to personnel file, copy to individual

**Agreement Renewal:**
- **Frequency:** Every 2 years
- **Trigger Date:** Anniversary of initial execution
- **Reminder:** 30 days before expiration
- **Consequence of Non-Renewal:** Access suspended until renewed

**Owner/Principal Self-Agreement:**
- As sole proprietor, Owner acknowledges CUI responsibilities
- Self-signed Acceptable Use Policy serves as access agreement
- Documented in personnel security file
- Updated annually

**Template Location:**
- `/backup/personnel-security/templates/CUI_Access_Agreement.docx`
- `/backup/personnel-security/templates/NDA_Template.docx`

### 7. Third-Party Personnel Security (PS-7)

Contractors, subcontractors, and third-party personnel must meet equivalent security standards:

**Contractor Requirements:**
- Provide evidence of their own security policies
- Submit CMMC self-assessment or certification (if applicable)
- Meet screening requirements per Position Risk Designation (PS-2)
- Execute NDA before any CPN access
- Comply with all Contract Coach security policies

**Contract Flow-Down Clauses:**
- FAR 52.204-21 (Basic Safeguarding of Covered Contractor Information Systems)
- DFARS 252.204-7012 (Safeguarding Covered Defense Information and Cyber Incident Reporting)
- Incident reporting within 72 hours
- Right to audit contractor security practices
- Security requirement acceptance clause

**Contractor Monitoring:**
```bash
# Review contractor account activity
sudo ausearch -ua contractor_name -ts week

# Check Samba file access
sudo grep contractor_name /var/log/samba/log.smbd

# Review Wazuh authentication events
# Dashboard: Security Events > Authentication > Filter by contractor username
```

**Supervised Access:**
- Remote access via FreeIPA authentication (logged)
- Samba file access audited via VFS audit module
- Wazuh SIEM monitors all contractor activity
- Monthly review of contractor access logs
- Quarterly contractor account recertification

**Contractor Account Management:**
```bash
# Create time-limited contractor account
kinit admin
ipa user-add contractor_name --first=First --last=Last \
    --email=contractor@example.com --shell=/bin/bash

# Set account expiration (e.g., 90 days)
ipa user-mod contractor_name --principal-expiration=20260201000000Z

# Restrict to specific groups (least privilege)
ipa group-add-member contractors --users=contractor_name
ipa group-add-member file_share_ro --users=contractor_name

# Do NOT add to sudorule or admin groups
# Verify no elevated privileges
ipa user-show contractor_name
```

**Vendor Due Diligence:**
- Request vendor security questionnaire
- Review vendor incident history
- Assess vendor's supply chain security
- Verify vendor compliance with federal security requirements
- Document vendor assessment in risk register (per TCC-RA-001)

### 8. Personnel Sanctions (PS-8)

Violations of security policies shall result in appropriate sanctions:

**Violation Categories:**

**Minor Violations (Unintentional):**
- Examples: Incorrect CUI marking, minor policy deviation
- Response: Documented counseling, remedial training
- Authority: ISSO
- Documentation: Personnel file notation

**Moderate Violations:**
- Examples: Failure to report incident, policy non-compliance
- Response: Written warning, mandatory refresher training, access suspension (temporary)
- Authority: ISSO with Owner approval
- Documentation: Formal written warning in personnel file

**Major Violations:**
- Examples: Unauthorized CUI disclosure, willful policy violation, security incident caused by negligence
- Response: Access revocation, termination, legal action
- Authority: Owner/Principal
- Documentation: Complete incident report, termination documentation

**Criminal Violations:**
- Examples: Intentional CUI theft, espionage, sabotage
- Response: Immediate termination, law enforcement referral
- Reporting: FBI, DoD Counterintelligence, contracting officer
- Authority: Owner/Principal
- Timeline: Immediate action, report within 24 hours

**Sanction Process:**
1. Incident detection and initial assessment
2. Evidence gathering (audit logs, witness statements)
3. Determination of violation severity
4. Selection of appropriate sanction
5. Notification to individual
6. Implementation of sanction
7. Documentation in personnel file
8. Follow-up monitoring (if applicable)

**Progressive Discipline:**
- First minor offense: Verbal counseling
- Second minor offense: Written warning
- Third minor offense or first moderate: Access suspension + mandatory training
- Major offense: Termination + possible legal action

**Integration with Other Policies:**
- Incident Response Policy (TCC-IRP-001): Security incident procedures
- Risk Management Policy (TCC-RA-001): Personnel risk assessment
- Training Policy (TCC-AT-001): Remedial training requirements

**Appeals Process:**
- Individual may appeal sanction to Owner/Principal (if not already Owner's decision)
- Appeal must be in writing within 10 business days
- Owner's decision is final
- Access remains suspended during appeal

## Roles and Responsibilities

| Role | Responsibilities |
|------|------------------|
| **ISSO (Don Shannon)** | Oversee screening processes; maintain personnel security records in `/backup/personnel-security/`; execute access provisioning/revocation; monitor compliance; conduct periodic access reviews; enforce sanctions (minor/moderate) |
| **Owner/Principal (Don Shannon)** | Approve high-risk position designations; authorize major sanctions; accept residual personnel risks; ensure policy compliance; approve contractor engagements; make final personnel security decisions |
| **Personnel/Contractors** | Complete required screening; adhere to access agreements; report security concerns or personal changes (legal issues, foreign contacts); participate in security training; comply with all policies |
| **HR/Contract Administrator** | If engaged in future: Coordinate background checks, manage contractor agreements, track screening renewals. **Current Status:** ISSO handles all personnel security functions |

**Note:** As a solopreneur, the ISSO and Owner/Principal roles are fulfilled by the same individual (Don Shannon), providing unified decision authority for all personnel security matters.

## Compliance and Enforcement

**Monitoring Activities:**
- Annual audits of screening records and expirations
- Quarterly FreeIPA account reviews
- Monthly contractor access log reviews
- Wazuh authentication monitoring (continuous)
- Integration with OpenSCAP compliance scans

**Training Requirements:**
- Security awareness training covers personnel security responsibilities
- Annual refresher on CUI handling and NDA obligations
- Incident reporting procedures (72-hour DoD requirement)
- Documented in Security Awareness and Training Policy (TCC-AT-001)

**Audit Procedures:**
```bash
# List all active FreeIPA users
kinit admin
ipa user-find --all

# Check for accounts without recent activity
sudo aureport -au --summary

# Review contractor account expirations
ipa user-find --principal-expiration="<$(date +%Y%m%d)000000Z"

# List users in privileged groups
ipa group-show admins
ipa group-show backup_operators
```

**Enforcement:**
- Non-compliance may result in immediate access revocation
- Violations may lead to contract termination
- Criminal violations reported to authorities per IR Policy
- Quarterly compliance reporting to Owner/Principal

**Record Keeping:**
- Personnel security files: `/backup/personnel-security/` (encrypted)
- Retention: 3 years post-separation minimum
- Backup: Included in daily backup procedures
- Access control: ISSO only (file permissions 600)

## References

- NIST SP 800-171 Rev 2, PS Family (Personnel Security)
- DFARS 252.204-7012 (Safeguarding Covered Defense Information)
- FAR 52.204-21 (Basic Safeguarding of Covered Contractor Information Systems)
- 32 CFR Part 2002 (Controlled Unclassified Information Program)
- System Security Plan (SSP), Section 3.9
- Risk Management Policy (TCC-RA-001)
- Incident Response Policy (TCC-IRP-001)
- Security Awareness and Training Policy (TCC-AT-001)

---

## Section 2: Personnel Security Procedures

### Procedure 1: Contractor Onboarding

**Trigger:** New contractor engagement requiring CPN access

**Steps:**

**1. Pre-Engagement Assessment (before contract award):**
- Determine CUI access requirements
- Assess position risk level (typically Moderate)
- Request contractor security questionnaire
- Review contractor's CMMC status or self-assessment
- Evaluate contractor's security policies
- Conduct risk assessment (per TCC-RA-001, Supply Chain Risk)

**2. Contract Execution:**
- Include FAR 52.204-21 and DFARS 252.204-7012 flow-down clauses
- Specify incident reporting requirements (72 hours)
- Define access scope and duration
- Include audit rights clause

**3. Screening (before access grant):**
- Collect completed self-attestation form
- Verify U.S. citizenship or lawful permanent residency
- Conduct reference checks (minimum 2)
- Criminal background check (if contract >$10K or access >30 days)
- Document screening results in contractor file

**4. Access Agreement:**
- Provide NDA and CUI Access Agreement
- Review CUI marking and handling requirements
- Explain incident reporting procedures
- Obtain signature (digital or wet signature)
- File executed agreement

**5. Account Provisioning:**
```bash
# Create FreeIPA account
kinit admin

# Add contractor user
ipa user-add contractor_name --first=FirstName --last=LastName \
    --email=contractor@company.com \
    --shell=/bin/bash \
    --homedir=/home/contractor_name

# Set time-limited principal expiration
ipa user-mod contractor_name --principal-expiration=20260531000000Z

# Set strong password (provide securely, require change on first login)
ipa passwd contractor_name

# Add to appropriate groups (least privilege)
ipa group-add-member contractors --users=contractor_name

# Grant read-only file share access (if needed)
ipa group-add-member file_share_ro --users=contractor_name

# Verify no admin privileges
ipa user-show contractor_name | grep -A 20 "Member of groups"
# Should NOT see: admins, sudorule, backup_operators
```

**6. Access Briefing:**
- Demonstrate FreeIPA authentication process
- Explain Samba file share access procedures
- Review acceptable use policy
- Provide Wazuh monitoring disclosure (inform of logging)
- Provide ISSO contact information for questions/incidents

**7. Documentation:**
- Create contractor personnel file: `/backup/personnel-security/contractors/<name>/`
- File all screening documents
- Store executed NDA and access agreement
- Document FreeIPA account details (username, expiration, groups)
- Add to contractor tracking spreadsheet

**8. Wazuh Monitoring Setup:**
- Verify Wazuh agent deployed to contractor's assigned workstation (if applicable)
- Configure alerts for contractor username
- Enable FIM for contractor's file access
- Set up authentication monitoring

**Timeline:** Complete onboarding within 5 business days of contract execution.

### Procedure 2: Periodic Access Review

**Frequency:** Quarterly

**Process:**

**Step 1: Generate User List:**
```bash
# List all active FreeIPA users
kinit admin
ipa user-find --all > /tmp/user_review_$(date +%Y%m%d).txt

# Identify users by group
ipa group-show admins
ipa group-show contractors
ipa group-show file_share_rw
ipa group-show file_share_ro
```

**Step 2: Review Each Account:**
For each user, verify:
- Current employment/contract status
- Access level still appropriate for role
- NDA still current (within 2 years)
- Screening still valid (within 5 years)
- No suspicious activity in logs

**Step 3: Check for Inactive Accounts:**
```bash
# Find users with no recent authentication
sudo aureport -au --summary | grep FAILED
sudo last -F | grep <username>

# Review Wazuh for authentication activity
# Dashboard: Security Events > Authentication > Last 90 days
```

**Step 4: Review Contractor Expirations:**
```bash
# List contractor accounts with expirations
ipa user-find --all | grep -A 5 contractor

# Check for expired or soon-to-expire principals
ipa user-find --principal-expiration="<$(date -d '+30 days' +%Y%m%d)000000Z"
```

**Step 5: Review Privileged Access:**
```bash
# List all admin users
ipa group-show admins

# List sudo rule members
ipa group-show backup_operators

# Verify only authorized individuals have elevated privileges
```

**Step 6: Remediation:**
- Disable inactive accounts (no activity in 90 days):
```bash
ipa user-disable <username>
```

- Remove unnecessary group memberships
- Extend or terminate expiring contractor accounts (with approval)
- Update documentation for any changes

**Step 7: Documentation:**
- Complete access review checklist
- Document findings and actions
- Report to Owner/Principal if any anomalies
- File review report: `/backup/personnel-security/access-reviews/YYYY-QN.txt`

**Step 8: Update SSP:**
- Update SSP personnel listing if changes occurred
- Document compliance with PS-7 (periodic reviews)

### Procedure 3: Emergency Access Revocation

**Trigger:** Immediate security concern (incident, termination for cause, insider threat)

**Timeline:** Within 1 hour of trigger

**Steps:**

**1. Immediate Account Disable:**
```bash
# Emergency account lockout
kinit admin
ipa user-disable <username>

# Verify disabled
ipa user-show <username> | grep -i disabled
# Output should show: Account disabled: True
```

**2. Kill Active Sessions:**
```bash
# Find active SSH sessions
sudo who
sudo pkill -KILL -u <username>

# Verify no active Kerberos tickets
sudo klist -A
```

**3. Block Network Access (if needed):**
```bash
# Add temporary firewall block for user's IP
sudo firewall-cmd --add-rich-rule='rule family="ipv4" source address="<user_ip>" reject'

# Or configure on pfSense:
# Firewall > Rules > LAN > Add block rule for source IP
```

**4. Preserve Evidence:**
```bash
# Copy user's recent activity logs
sudo mkdir -p /backup/incident-evidence/$(date +%Y%m%d)-<username>

# Preserve authentication logs
sudo cp /var/log/secure /backup/incident-evidence/$(date +%Y%m%d)-<username>/

# Preserve audit logs
sudo cp -r /var/log/audit /backup/incident-evidence/$(date +%Y%m%d)-<username>/

# Preserve Samba access logs
sudo cp /var/log/samba/*.smbd /backup/incident-evidence/$(date +%Y%m%d)-<username>/

# Preserve Wazuh alerts
sudo cp /var/ossec/logs/alerts/alerts.log /backup/incident-evidence/$(date +%Y%m%d)-<username>/
```

**5. Audit Recent Activity:**
```bash
# Review authentication history
sudo ausearch -ua <username> -ts today

# Check file access
sudo grep <username> /var/log/samba/log.smbd | tail -50

# Review Wazuh timeline
# Dashboard: Security Events > Search: username
```

**6. Assess Impact:**
- Determine what CUI was accessed
- Identify any files modified or deleted
- Check for data exfiltration (large file transfers)
- Review FIM alerts for suspicious changes

**7. Incident Response:**
- Follow Incident Response Policy (TCC-IRP-001)
- Determine if DoD reporting required (72-hour clock starts)
- Notify Owner/Principal immediately
- Consider law enforcement involvement

**8. Documentation:**
- Create incident log
- Document timeline of events
- Record all actions taken
- File in incident response and personnel security folders

---

## Appendix A: Personnel Security Checklist

### New Contractor Onboarding

- [ ] Contract includes FAR 52.204-21 and DFARS 252.204-7012
- [ ] Contractor security questionnaire completed
- [ ] CMMC status reviewed (if applicable)
- [ ] Position risk level designated (typically Moderate)
- [ ] Self-attestation form completed
- [ ] Citizenship/residency verified
- [ ] Reference checks completed (min 2)
- [ ] Criminal background check completed (if required)
- [ ] NDA executed and filed
- [ ] CUI Access Agreement signed
- [ ] FreeIPA account created with time-limited expiration
- [ ] User added to appropriate groups (least privilege)
- [ ] Admin privileges verified as NOT granted
- [ ] Access briefing conducted
- [ ] Wazuh monitoring configured
- [ ] Contractor personnel file created
- [ ] Contractor tracking spreadsheet updated
- [ ] SSP updated with new personnel

### Quarterly Access Review

- [ ] All user accounts listed
- [ ] Employment/contract status verified for each user
- [ ] NDA currency checked (2-year renewal)
- [ ] Screening validity checked (5-year renewal)
- [ ] Inactive accounts identified (>90 days no activity)
- [ ] Contractor account expirations reviewed
- [ ] Privileged access justified for each admin user
- [ ] Unnecessary group memberships removed
- [ ] Wazuh logs reviewed for suspicious activity
- [ ] Actions documented in access review report
- [ ] Owner/Principal briefed on findings
- [ ] SSP updated if changes made
- [ ] Review report filed

### Personnel Termination

- [ ] FreeIPA account disabled immediately
- [ ] Active sessions killed
- [ ] Network access blocked (if needed)
- [ ] Exit interview conducted (if planned)
- [ ] All CUI media recovered
- [ ] Audit logs reviewed for 24-hour period before termination
- [ ] Recent file access audited
- [ ] Shared passwords changed
- [ ] Activity evidence preserved
- [ ] Separation documented in personnel file
- [ ] SSP updated
- [ ] Monitoring continued for 30 days post-separation
- [ ] Personnel file archived after 3 years

---

## Appendix B: Forms and Templates

### Self-Attestation Form (Contractor Screening)

**The Contract Coach - Contractor Self-Attestation Form**

**Contractor Information:**
- Full Legal Name: _______________________
- Date of Birth: _______________________
- SSN (last 4 digits): _______
- Current Address: _______________________
- Phone: _______________________
- Email: _______________________

**Citizenship:**
- [ ] U.S. Citizen
- [ ] Lawful Permanent Resident (Green Card Number: _______)
- [ ] Other (specify): __________

**Background Questions:**
I certify that the following statements are true:

1. I have not been convicted of any felony in the past 7 years: [ ] Yes [ ] No
2. I have not been convicted of any crime involving fraud, theft, or dishonesty: [ ] Yes [ ] No
3. I am not currently under investigation for any criminal activity: [ ] Yes [ ] No
4. I have not been terminated from employment for security violations: [ ] Yes [ ] No
5. I understand the requirements for protecting CUI: [ ] Yes [ ] No
6. I agree to report any security incidents within 72 hours: [ ] Yes [ ] No

If you answered "No" to any question, provide explanation: _______________________

**References:**
Please provide two professional references:

Reference 1:
- Name: _______________________
- Relationship: _______________________
- Phone: _______________________
- Email: _______________________

Reference 2:
- Name: _______________________
- Relationship: _______________________
- Phone: _______________________
- Email: _______________________

**Certification:**
I certify that the information provided in this form is true and complete to the best of my knowledge. I understand that any false statement may result in immediate termination and possible legal action.

Signature: _______________________ Date: _______________________

**For Official Use Only:**
- Screening completed by: _______________________
- Date: _______________________
- Reference checks: [ ] Completed [ ] Satisfactory
- Background check: [ ] Completed [ ] Satisfactory
- Approved for access: [ ] Yes [ ] No
- Position risk level: [ ] High [ ] Moderate [ ] Low

---

## Approval

**Prepared By:**
Donald E. Shannon, ISSO

**Approved By:**
/s/ Donald E. Shannon
Owner/Principal, The Contract Coach

**Date:** November 2, 2025

**Next Review Date:** November 2, 2026

---

## Document Control

**Revision History:**
- Version 1.0 - November 2, 2025 - Initial policy establishment

**Distribution:**
- Owner/Principal (Don Shannon)
- Filed in: `/backup/personnel-security/policies/`
- SSP Reference: Section 3.9

**Updates Triggered By:**
- NIST SP 800-171 revisions
- Security incidents involving personnel
- Organizational structure changes
- New contract requirements
- Annual policy review cycle
