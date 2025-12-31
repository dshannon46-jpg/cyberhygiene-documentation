# NIST 800-171 Rev 2 Compliance Documentation Guide
## Required Policies and Procedures for Small Business
**Organization:** CyberInABox.net  
**Date:** October 26, 2025  
**Purpose:** CMMC Level 2 / NIST 800-171 Compliance  
**Scope:** Small Business (<15 users) handling CUI/FCI

---

## 📋 EXECUTIVE SUMMARY

To demonstrate NIST 800-171 Rev 2 compliance (also required for CMMC Level 2), you must document **policies and procedures** that address all **110 security requirements** across **14 control families**.

**This guide provides:**
- ✅ Complete list of required documentation
- ✅ What must be included in each document
- ✅ Templates and guidance for small businesses
- ✅ Prioritization for implementation
- ✅ Your current compliance status

**Key Point:** Having the technical controls (which you do!) is only half the battle. You must **document** what you're doing, **why** you're doing it, and **how** it's implemented.

---

## 🎯 DOCUMENTATION TIERS

### Tier 1: System Security Plan (SSP) - **REQUIRED**
The master document that describes your entire security posture.

### Tier 2: Core Policies (10-12 documents) - **REQUIRED**
High-level policies approved by management covering each control family.

### Tier 3: Procedures (20-30 documents) - **REQUIRED**
Step-by-step instructions for implementing controls.

### Tier 4: Supporting Documents - **HIGHLY RECOMMENDED**
Forms, templates, logs, evidence of implementation.

---

## 📊 THE 14 CONTROL FAMILIES

NIST 800-171 Rev 2 organizes requirements into 14 families. Each family requires specific documentation.

---

## 1. ACCESS CONTROL (AC) - 22 Requirements

### Required Policies

#### **Access Control Policy** ⭐ CRITICAL
**Purpose:** Define how access to CUI is controlled  
**Must Include:**
- User authorization procedures
- Account management (creation, modification, deletion)
- Principle of least privilege
- Role-based access control (RBAC)
- Remote access controls
- Wireless access restrictions (if applicable)
- Mobile device controls
- Session lock requirements (15 minutes max)
- Session termination procedures
- Account monitoring and review

**Your Status:** ✅ Partially implemented (FreeIPA RBAC in place)  
**What You Need:** Document your FreeIPA groups and access decisions

#### **User Account Management Procedure**
**Must Include:**
- Process for requesting new accounts
- Approval workflow
- Account provisioning steps
- Group membership assignment criteria
- Account deactivation process
- Quarterly access reviews
- Emergency access procedures

**Template Example:**
```
1. User Account Request
   - Requester: [Manager name]
   - User information: [Name, role, department]
   - Access needed: [CUI/FCI authorization, groups]
   - Justification: [Business need]
   - Approval: [Security Officer signature]

2. Account Creation
   - IT creates account in FreeIPA
   - Assigns to appropriate groups based on role
   - Sets temporary password
   - Notifies user via secure channel

3. Account Review
   - Quarterly review of all active accounts
   - Verify access still needed
   - Remove unnecessary permissions
   - Document review in access log
```

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

#### **Privileged Access Management Procedure**
**Must Include:**
- Who can have sudo/admin access
- Approval requirements
- Logging of privileged activities
- Periodic review of privileged accounts
- Multi-factor authentication requirements (for admins)

**Your Status:** ✅ Partially implemented (sudo rules exist)  
**What You Need:** Document approval process for granting sudo

---

## 2. AWARENESS AND TRAINING (AT) - 2 Requirements

### Required Policies

#### **Security Awareness Training Policy** ⭐ CRITICAL
**Purpose:** Ensure all users understand security responsibilities  
**Must Include:**
- Annual security training requirement for all users
- Role-based training for privileged users
- CUI/FCI handling procedures
- Phishing awareness
- Password management
- Incident reporting procedures
- Acceptable use policy
- Training tracking and records

**Template Example:**
```
All users must complete:
1. Security Awareness Training (Annual)
   - CUI/FCI identification and handling
   - Password requirements and management
   - Phishing and social engineering awareness
   - Physical security procedures
   - Incident reporting
   - Acceptable use of systems

2. Role-Based Training
   - Administrators: Advanced security training
   - Developers: Secure coding practices
   - All staff: Job-specific security requirements

3. Documentation
   - Training completion certificates
   - Test scores (if applicable)
   - Annual acknowledgment of security policies
```

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

#### **Security Training Records**
- Training attendance logs
- Training completion certificates
- Policy acknowledgment forms
- Annual training schedule

**Your Status:** 🔄 Need to create  
**Priority:** MEDIUM

---

## 3. AUDIT AND ACCOUNTABILITY (AU) - 9 Requirements

### Required Policies

#### **Audit and Accountability Policy** ⭐ CRITICAL
**Purpose:** Define what is logged and how logs are protected  
**Must Include:**
- Events that must be audited
- Log retention period (at least 90 days, recommend 1 year)
- Log protection mechanisms
- Log review procedures
- Time synchronization requirements
- Audit record content requirements
- Response to audit processing failures

**Your Status:** ✅ Partially implemented (auditd running)  
**What You Need:** Document log review process

**Events to Audit (Minimum):**
- Successful and failed account logons
- Account management events (create, delete, modify)
- Privileged function use (sudo commands)
- System startup and shutdown
- Security policy changes
- Configuration changes
- File access to CUI
- Network connections

#### **Log Review Procedure**
**Must Include:**
- Who reviews logs (Security Officer, IT Admin)
- Review frequency (weekly minimum)
- What to look for (failed logins, privilege escalation, etc.)
- Escalation procedures for suspicious activity
- Documentation of reviews

**Template Example:**
```
Weekly Log Review Process:
1. Review authentication logs
   - Check for failed login attempts (>5 failures)
   - Verify all successful admin logins authorized
   - Look for unusual login times/locations

2. Review sudo logs
   - Verify all privileged commands authorized
   - Check for unauthorized privilege escalation
   - Document any anomalies

3. Review file access logs (CUI/FCI)
   - Verify access by authorized users only
   - Check for bulk downloads
   - Investigate unusual access patterns

4. Documentation
   - Date of review
   - Reviewer name
   - Issues found
   - Actions taken
   - Sign log review form
```

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

---

## 4. CONFIGURATION MANAGEMENT (CM) - 9 Requirements

### Required Policies

#### **Configuration Management Policy** ⭐ CRITICAL
**Purpose:** Maintain secure baseline configurations  
**Must Include:**
- Baseline configuration standards
- Change control procedures
- Configuration documentation
- Least functionality principle
- Software restriction policies
- User-installed software restrictions
- Security configuration settings

**Your Status:** ✅ Partially implemented (OpenSCAP baselines)  
**What You Need:** Document change control process

#### **Change Management Procedure**
**Must Include:**
- Change request process
- Impact analysis requirements
- Testing requirements
- Approval workflow
- Rollback procedures
- Documentation requirements

**Template Example:**
```
Change Request Process:
1. Request
   - Change description
   - Business justification
   - Impact assessment
   - Security impact analysis
   - Testing plan

2. Approval
   - Technical review by IT
   - Security review by Security Officer
   - Management approval (if significant impact)

3. Implementation
   - Backup system before change
   - Test in non-production (if possible)
   - Implement during maintenance window
   - Verify change successful
   - Document completion

4. Post-Implementation
   - Update configuration documentation
   - Update baseline if needed
   - Monitor for issues
```

**Your Status:** 🔄 Need to create  
**Priority:** MEDIUM

#### **Baseline Configuration Documentation**
**Must Include:**
- Operating system configurations (Rocky Linux 9.6)
- Security settings (FIPS, OpenSCAP profiles)
- Network configurations
- Application configurations
- Approved software lists

**Your Status:** ✅ Partially documented (Technical Specs)  
**What You Need:** Formalize into CM baseline document

---

## 5. IDENTIFICATION AND AUTHENTICATION (IA) - 11 Requirements

### Required Policies

#### **Identification and Authentication Policy** ⭐ CRITICAL
**Purpose:** Control who can access the system and how  
**Must Include:**
- User identification requirements
- Authentication mechanisms
- Password requirements (complexity, length, expiration)
- Multi-factor authentication (MFA) requirements
- Session lock requirements
- Authentication feedback obscuring
- Replay-resistant authentication
- Device identification and authentication

**Your Status:** ✅ Well implemented (FreeIPA + Kerberos)  
**What You Need:** Document existing password policies and procedures

**Your Current Settings (Document These):**
```
Password Requirements:
- Minimum length: 14 characters
- Character classes: 3 of 4 (upper, lower, digit, special)
- Password history: 24 passwords
- Maximum age: 90 days
- Minimum age: 1 day
- Account lockout: 5 failed attempts
- Lockout duration: 30 minutes
- Reset interval: 15 minutes

Authentication Methods:
- Kerberos single sign-on
- LDAP for directory services
- Certificate-based (available via FreeIPA CA)
- MFA ready (OTP can be enabled)
```

#### **Account Management Procedure**
(See Access Control section above - covers both AC and IA)

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

---

## 6. INCIDENT RESPONSE (IR) - 5 Requirements

### Required Policies

#### **Incident Response Plan** ⭐ CRITICAL
**Purpose:** Detect, respond to, and recover from security incidents  
**Must Include:**
- Incident response team roles
- Incident categories and severity levels
- Detection and reporting procedures
- Incident handling procedures
- Communication plans
- Evidence collection procedures
- Post-incident review process
- Coordination with external entities (if needed)

**Your Status:** 🔄 Need to create  
**Priority:** CRITICAL

**Template Example:**
```
Incident Response Plan

1. Incident Response Team
   - Incident Commander: [Name, contact]
   - Technical Lead: [Name, contact]
   - Security Officer: [Name, contact]
   - Legal Counsel: [Name, contact] (if applicable)

2. Incident Categories
   Level 1 (Critical): Data breach, ransomware, system compromise
   Level 2 (High): Malware infection, unauthorized access
   Level 3 (Medium): Failed security control, suspicious activity
   Level 4 (Low): Policy violation, security awareness issue

3. Response Procedures
   a. Detection
      - Monitor alerts from systems
      - User reports of suspicious activity
      - Log review findings
      
   b. Initial Response (within 1 hour)
      - Verify incident is real
      - Classify severity
      - Notify Incident Commander
      - Begin documentation
      
   c. Containment (within 2 hours for critical)
      - Isolate affected systems
      - Disable compromised accounts
      - Preserve evidence
      - Prevent spread
      
   d. Eradication
      - Remove malware/threats
      - Close vulnerabilities
      - Apply patches
      - Reset compromised credentials
      
   e. Recovery
      - Restore from clean backups
      - Verify system integrity
      - Return to normal operations
      - Implement additional monitoring
      
   f. Post-Incident Review (within 5 days)
      - Document what happened
      - Identify root cause
      - Determine improvements needed
      - Update procedures
      - Lessons learned report

4. Reporting Requirements
   - Internal notification within 1 hour
   - Management notification within 4 hours
   - Government reporting: 72 hours (if CUI breach)
   - Customer notification: Per contract requirements
```

**Your Status:** 🔄 Need to create  
**Priority:** CRITICAL

#### **Incident Tracking Log**
- Date/time of incident
- Category and severity
- Description
- Actions taken
- Resolution
- Lessons learned

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

---

## 7. MAINTENANCE (MA) - 6 Requirements

### Required Policies

#### **System Maintenance Policy**
**Purpose:** Ensure systems are maintained securely  
**Must Include:**
- Scheduled maintenance procedures
- Maintenance personnel authorization
- Maintenance tools control
- Remote maintenance requirements
- Maintenance logging
- Timely maintenance execution

**Your Status:** ✅ Partially implemented (auto-updates configured)  
**What You Need:** Document maintenance procedures

**Template Example:**
```
System Maintenance Procedures

1. Scheduled Maintenance
   - Weekly: Security updates (automated via dnf-automatic)
   - Monthly: System health check
   - Quarterly: Comprehensive system review
   - Annual: Hardware inspection

2. Maintenance Authorization
   - System administrators authorized for routine maintenance
   - Critical changes require Security Officer approval
   - Emergency maintenance: document and review afterward

3. Maintenance Activities
   - Apply security patches within 30 days of release
   - Update antivirus/anti-malware definitions daily
   - Review and update firewall rules quarterly
   - Test backup restoration quarterly
   - Review and update documentation quarterly

4. Maintenance Logging
   - Document all maintenance activities
   - Include: date, person, activity, outcome
   - Retain maintenance logs for 1 year
```

**Your Status:** 🔄 Need to formalize  
**Priority:** MEDIUM

---

## 8. MEDIA PROTECTION (MP) - 8 Requirements

### Required Policies

#### **Media Protection Policy** ⭐ CRITICAL
**Purpose:** Protect CUI on all media types  
**Must Include:**
- Media access restrictions
- Media marking requirements (CUI labels)
- Media sanitization procedures
- Media disposal procedures
- Media transportation procedures
- Cryptographic protection requirements
- Portable storage device controls

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

**Template Example:**
```
Media Protection Policy

1. CUI Media Marking
   - All media containing CUI must be labeled:
     "CUI - Controlled Unclassified Information"
   - Label placement: visible on media surface
   - Applies to: USB drives, external HDD, optical media, paper

2. Media Storage
   - CUI media stored in locked cabinet/safe when not in use
   - Access limited to authorized personnel
   - Access log maintained

3. Media Transportation
   - CUI media transported in locked container
   - Courier must be authorized personnel
   - Chain of custody documented

4. Media Sanitization (Before Reuse/Disposal)
   - Digital media: Overwrite with DoD 5220.22-M (3 passes) or
     physical destruction
   - Paper: Cross-cut shred or incinerate
   - Document sanitization with certificate

5. Portable Media Controls
   - USB drives containing CUI must be encrypted
   - Personal USB drives prohibited on CUI systems
   - External hard drives require approval

6. Backup Media
   - Encrypted during storage
   - Stored in secure location
   - Access logged
   - Tested quarterly for restoration
```

**Your Status:** 🔄 Need to create  
**Priority:** HIGH (especially for backup media)

---

## 9. PERSONNEL SECURITY (PS) - 2 Requirements

### Required Policies

#### **Personnel Security Policy**
**Purpose:** Ensure personnel are trustworthy  
**Must Include:**
- Personnel screening requirements
- Position risk categorization
- Personnel termination procedures
- Personnel transfer procedures
- Access agreement requirements

**Your Status:** 🔄 Need to create  
**Priority:** MEDIUM

**Template Example:**
```
Personnel Security Policy

1. Personnel Screening
   For positions with CUI/FCI access:
   - Background check required before access granted
   - Verify identity and credentials
   - Check employment history
   - Check references
   - Re-screen every 5 years

2. Position Categories
   - High Risk: System administrators, security officers
     (Extensive background check required)
   - Moderate Risk: Users with CUI access
     (Standard background check)
   - Low Risk: Users without CUI access
     (Identity verification only)

3. Access Agreements
   All personnel must sign:
   - Acceptable Use Policy
   - Non-Disclosure Agreement (NDA)
   - Rules of Behavior for CUI handling
   - Security policy acknowledgment
   Annual re-acknowledgment required

4. Termination Procedures
   Within 24 hours of termination:
   - Disable all user accounts
   - Revoke physical access (badges, keys)
   - Collect company devices
   - Collect CUI media
   - Remove from all groups and access lists
   - Document termination in personnel file

5. Transfer Procedures
   When employee changes roles:
   - Review and adjust access permissions
   - Remove access no longer needed
   - Grant new access as appropriate
   - Document changes
```

**Your Status:** 🔄 Need to create  
**Priority:** MEDIUM

---

## 10. PHYSICAL PROTECTION (PE) - 6 Requirements

### Required Policies

#### **Physical Security Policy**
**Purpose:** Protect physical access to systems processing CUI  
**Must Include:**
- Physical access authorizations
- Physical access controls (locks, guards, etc.)
- Visitor control procedures
- Access logs
- Physical security monitoring
- Delivery and removal controls

**Your Status:** 🔄 Need to create  
**Priority:** MEDIUM (depends on your environment)

**Template Example:**
```
Physical Security Policy

1. Facility Access Control
   - Server room access limited to IT staff
   - Badge/key required for entry
   - Access log maintained (electronic or paper)
   - Review access logs monthly

2. Visitor Control
   - All visitors must sign in/out
   - Escort required at all times
   - Visitor badge issued
   - Visitor log retained for 1 year

3. Physical Access Monitoring
   - Security cameras at entry points (if applicable)
   - Review footage if incident suspected
   - Retain footage for 90 days

4. Workstation Security
   - Workstations locked when unattended
   - Session timeout: 15 minutes
   - Physical lock for laptops (cable lock)
   - Clean desk policy for CUI documents

5. Delivery and Removal
   - Equipment deliveries logged
   - Equipment removals require approval
   - Sanitize equipment before removal
   - Document all movements

6. Environmental Controls
   - Fire suppression in server room
   - Temperature monitoring
   - Backup power (UPS) for critical systems
   - Emergency procedures documented
```

**Your Status:** 🔄 Need to create based on your facility  
**Priority:** MEDIUM

---

## 11. RISK ASSESSMENT (RA) - 3 Requirements

### Required Policies

#### **Risk Assessment Policy** ⭐ CRITICAL
**Purpose:** Identify and manage security risks  
**Must Include:**
- Risk assessment methodology
- Assessment frequency (annual minimum)
- Risk categorization
- Vulnerability scanning requirements
- Threat source identification
- Risk response procedures

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

**Template Example:**
```
Risk Assessment Policy

1. Risk Assessment Schedule
   - Initial assessment: Before system operation
   - Periodic assessment: Annually
   - Ad-hoc assessment: After significant changes
   - Vulnerability scanning: Monthly

2. Risk Assessment Process
   Step 1: Identify Threats
   - External: Hackers, malware, natural disasters
   - Internal: Insider threats, human error
   - System vulnerabilities

   Step 2: Assess Likelihood
   - High: Likely to occur within 1 year
   - Medium: May occur within 1-3 years
   - Low: Unlikely to occur within 3 years

   Step 3: Assess Impact
   - High: Significant CUI breach, major business disruption
   - Medium: Limited CUI exposure, moderate disruption
   - Low: Minimal impact

   Step 4: Calculate Risk Level
   - Critical: High likelihood + High impact
   - High: High likelihood + Medium impact, or Medium + High
   - Medium: Medium + Medium, or High + Low
   - Low: Low likelihood and/or Low impact

   Step 5: Risk Response
   - Accept: Document decision (low risk only)
   - Mitigate: Implement controls to reduce risk
   - Transfer: Insurance or third-party
   - Avoid: Change processes to eliminate risk

3. Vulnerability Scanning
   - Monthly automated vulnerability scans
   - Critical vulnerabilities: Remediate within 15 days
   - High vulnerabilities: Remediate within 30 days
   - Medium/Low: Remediate within 90 days
   - Document scan results and remediation

4. Risk Register
   Maintain register of identified risks:
   - Risk description
   - Likelihood and impact
   - Risk level
   - Mitigation measures
   - Residual risk
   - Owner
   - Review date
```

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

#### **Annual Risk Assessment Report**
- Must be completed annually
- Document all identified risks
- Document risk responses
- Management sign-off

**Your Status:** 🔄 Need to create  
**Priority:** HIGH

---

## 12. SECURITY ASSESSMENT (SA) - 7 Requirements

### Required Policies

#### **Security Assessment Policy**
**Purpose:** Verify security controls are working  
**Must Include:**
- Security control assessment procedures
- Assessment frequency
- Assessment scope
- Developer security testing requirements
- Flaw remediation procedures
- Security testing for new systems

**Your Status:** ✅ Partially implemented (OpenSCAP scanning)  
**What You Need:** Document assessment process

**Template Example:**
```
Security Assessment Policy

1. Security Control Assessment
   - Annual comprehensive assessment
   - Quarterly targeted assessments
   - OpenSCAP compliance scanning: Monthly
   - Penetration testing: Annually (or before major changes)

2. Assessment Activities
   a. Configuration Review
      - Verify baseline configurations
      - Check OpenSCAP compliance (NIST 800-171 profile)
      - Review firewall rules
      - Review user access permissions

   b. Vulnerability Assessment
      - Monthly vulnerability scanning
      - Review scan results
      - Prioritize remediation
      - Track remediation progress

   c. Security Control Testing
      - Test backup restoration
      - Test incident response procedures
      - Test account lockout mechanisms
      - Test logging and monitoring

3. Assessment Documentation
   - Assessment plan
   - Assessment findings
   - Risk level of findings
   - Remediation recommendations
   - Plan of Action and Milestones (POA&M)
   - Management response

4. Remediation Procedures
   - Critical findings: Fix within 7 days
   - High findings: Fix within 30 days
   - Medium findings: Fix within 90 days
   - Low findings: Fix or accept risk within 180 days
   - Document all remediation actions

5. Plan of Action and Milestones (POA&M)
   For each finding not immediately fixed:
   - Description of issue
   - Risk level
   - Scheduled completion date
   - Resources required
   - Milestone dates
   - Status updates
   - Responsible party
```

**Your Status:** 🔄 Need to formalize  
**Priority:** HIGH

---

## 13. SYSTEM AND COMMUNICATIONS PROTECTION (SC) - 22 Requirements

### Required Policies

#### **System and Communications Protection Policy** ⭐ CRITICAL
**Purpose:** Protect system boundaries and communications  
**Must Include:**
- Boundary protection (firewall) requirements
- Network segmentation
- Cryptographic protection requirements (FIPS 140-2)
- Remote access controls
- VoIP protection (if applicable)
- Denial of service protection
- Cryptographic key management
- Public access system separation
- Session authenticity

**Your Status:** ✅ Well implemented technically (FIPS, firewalls)  
**What You Need:** Document existing protections

**Template Example:**
```
System and Communications Protection Policy

1. Boundary Protection
   - pfSense firewall protects network perimeter
   - Default deny all policy
   - Explicit allow rules for necessary traffic
   - Quarterly firewall rule review
   - IDS/IPS enabled (Suricata) [when implemented]

2. Network Segmentation
   - Current: Single internal network
   - Future: VLAN segmentation planned
     * Management VLAN
     * User VLAN
     * DMZ for external services

3. Cryptographic Protection (FIPS 140-2)
   - FIPS mode enabled on all systems
   - TLS 1.2 minimum for communications
   - HTTPS for all web services
   - SSH for remote administration
   - LUKS encryption for data at rest
   - VPN encryption: AES-256 (when implemented)

4. Remote Access
   - VPN required for remote access (when implemented)
   - Multi-factor authentication required
   - Remote access logged and monitored
   - Session timeout: 30 minutes
   - Split tunneling prohibited

5. Data in Transit Protection
   - All CUI transmitted encrypted (TLS 1.2+)
   - Email encryption required for CUI
   - File transfers: SFTP or encrypted HTTPS

6. Data at Rest Protection
   - Full disk encryption (LUKS) on all systems
   - RAID array encryption
   - Backup media encryption
   - Mobile device encryption required

7. Wireless Security (if applicable)
   - WPA3 required (WPA2 minimum)
   - Separate guest network (no CUI access)
   - Wireless authentication via 802.1X (future)

8. Key Management
   - Encryption keys stored securely
   - LUKS passphrases in secure vault
   - Certificate management via FreeIPA CA
   - Key rotation: Annually or upon compromise
```

**Your Status:** 🔄 Need to formalize  
**Priority:** HIGH

---

## 14. SYSTEM AND INFORMATION INTEGRITY (SI) - 8 Requirements

### Required Policies

#### **System and Information Integrity Policy** ⭐ CRITICAL
**Purpose:** Detect and respond to integrity violations  
**Must Include:**
- Flaw remediation procedures
- Malware protection requirements
- Security alert management
- Software and information integrity checks
- Spam protection
- Error handling
- Information input validation

**Your Status:** ✅ Partially implemented (auto-updates)  
**What You Need:** Document remaining controls

**Template Example:**
```
System and Information Integrity Policy

1. Flaw Remediation (Patch Management)
   - Security updates: Automated daily (dnf-automatic)
   - Critical patches: Within 30 days of release
   - High patches: Within 60 days
   - Testing: Verify patches before production (when possible)
   - Downtime: Coordinate during maintenance windows
   - Rollback plan: Document before applying patches

2. Malicious Code Protection
   - Anti-malware on all endpoints (when clients deployed)
   - Real-time scanning enabled
   - Daily signature updates
   - Weekly full system scans
   - Quarantine suspicious files
   - Alert on malware detection

3. Security Alerts and Advisories
   - Subscribe to security mailing lists:
     * Rocky Linux security announcements
     * FreeIPA security announcements
     * NIST vulnerability database
   - Review alerts daily
   - Assess applicability to environment
   - Take action within timeframes above

4. Information System Monitoring
   - Centralized logging to /var/log
   - Log review: Weekly minimum
   - Automated alerting for critical events
   - Intrusion detection: Suricata IDS [when implemented]
   - File integrity monitoring: AIDE or similar [future]
   - Network traffic monitoring

5. Software and Firmware Integrity
   - Verify software authenticity before installation
   - Use official repositories only
   - GPG signature verification for packages
   - Hash verification for downloads
   - Maintain approved software list

6. Spam Protection (Email)
   - Spam filtering on mail server [when implemented]
   - Sender Policy Framework (SPF)
   - DomainKeys Identified Mail (DKIM)
   - DMARC policy
   - User training on phishing

7. Input Validation
   - Validate all user inputs in applications
   - Sanitize data before processing
   - Prevent injection attacks
   - Error messages don't reveal sensitive info
```

**Your Status:** 🔄 Need to formalize  
**Priority:** HIGH

---

## 📊 DOCUMENTATION PRIORITY MATRIX

### ⭐ CRITICAL Priority (Complete First - Next 30 Days)

1. **System Security Plan (SSP)** - Master document
2. **Access Control Policy** + Procedures
3. **Incident Response Plan**
4. **Audit and Accountability Policy** + Log Review Procedure
5. **Identification and Authentication Policy**
6. **System and Communications Protection Policy**
7. **Media Protection Policy**
8. **Risk Assessment Policy** + Initial Assessment

**Why Critical:** Required for any compliance audit, address highest-risk areas

### 🔥 HIGH Priority (Complete Within 60 Days)

9. **Security Awareness Training Policy** + Records
10. **Configuration Management Policy** + Change Control
11. **Security Assessment Policy** + POA&M
12. **System and Information Integrity Policy**
13. **Personnel Security Policy**

**Why High:** Core operational procedures needed for day-to-day compliance

### ⚡ MEDIUM Priority (Complete Within 90 Days)

14. **Maintenance Policy**
15. **Physical Security Policy**
16. **Baseline Configuration Documentation**
17. **User Onboarding/Offboarding Procedures**
18. **Backup and Recovery Procedures**

**Why Medium:** Important but less frequently referenced, or already partially implemented

### 📝 Supporting Documents (Ongoing)

19. Forms and Templates
20. Training Materials
21. Log Review Forms
22. Incident Report Forms
23. Change Request Forms
24. Access Request Forms
25. Security Control Test Results
26. Evidence Files

---

## 📋 SYSTEM SECURITY PLAN (SSP) OUTLINE

Your **master document** that references all other policies. Required for compliance.

### SSP Structure

```
1. SYSTEM IDENTIFICATION
   - System name: CyberInABox Infrastructure
   - System owner: [Name]
   - Security officer: [Name]
   - System location: [Address]
   - System description: NIST 800-171 compliant infrastructure
   
2. SYSTEM ENVIRONMENT
   - Hardware inventory
   - Software inventory
   - Network diagram
   - Data flow diagram
   - System boundaries
   
3. SYSTEM CATEGORIZATION
   - Information types: CUI, FCI
   - Confidentiality impact: MODERATE
   - Integrity impact: MODERATE
   - Availability impact: LOW
   - Overall categorization: MODERATE
   
4. CONTROL IMPLEMENTATION
   For each of 110 controls:
   - Control ID (e.g., AC-1, AC-2, etc.)
   - Control description
   - Implementation status
   - How it's implemented (reference to policy/procedure)
   - Implementation evidence
   - Responsible party
   
5. SECURITY CONTROL SUMMARY
   - Controls implemented: [number]
   - Controls planned: [number]
   - Controls not applicable: [number]
   - Alternative implementations: [describe]
   
6. PLAN OF ACTION AND MILESTONES (POA&M)
   - Outstanding items
   - Scheduled completion
   - Resources required
   
7. APPENDICES
   - Policies and procedures (referenced)
   - Network diagrams
   - Hardware/software inventory
   - Evidence files
```

### Sample Control Implementation Entry

```
AC-2: Account Management

Implementation Status: Implemented
Implementation Date: October 26, 2025

Description:
The organization uses FreeIPA for centralized account management.
All user accounts are created, modified, and disabled according to
documented procedures in the Account Management Procedure (reference:
AMP-001, dated Oct 26, 2025).

How Implemented:
- FreeIPA provides centralized LDAP directory
- Role-based access control via FreeIPA groups
- Account creation requires manager approval
- Accounts disabled within 24 hours of termination
- Quarterly access reviews performed by Security Officer
- Privileged accounts subject to additional controls

Evidence:
- FreeIPA configuration (Attachment A)
- Account Management Procedure (AMP-001)
- Sample access review log (Attachment B)
- User account list (Attachment C)

Responsible Party: IT Administrator
Last Review: October 26, 2025
Next Review: January 26, 2026
```

---

## 🎯 YOUR CURRENT COMPLIANCE STATUS

Based on your implemented technical controls, here's where you stand:

### ✅ WELL IMPLEMENTED (Technical Controls)

| Control Family | Status | What You Have |
|----------------|--------|---------------|
| **AC - Access Control** | 80% | FreeIPA RBAC, sudo rules, HBAC |
| **AU - Audit** | 70% | auditd, centralized logging |
| **CM - Config Mgmt** | 80% | OpenSCAP baselines, FIPS |
| **IA - Authentication** | 90% | FreeIPA, Kerberos, strong passwords |
| **SC - System Protection** | 85% | FIPS 140-2, encryption, firewall |
| **SI - System Integrity** | 70% | Auto-updates, security scanning |

### 🔄 PARTIALLY IMPLEMENTED (Need Documentation)

| Control Family | Status | What's Missing |
|----------------|--------|----------------|
| **AT - Training** | 30% | Need training policy and records |
| **IR - Incident Response** | 20% | Need incident response plan |
| **MA - Maintenance** | 50% | Need documented procedures |
| **MP - Media Protection** | 30% | Need media handling procedures |
| **PS - Personnel Security** | 40% | Need screening and agreements |
| **PE - Physical Security** | 40% | Need physical security policy |
| **RA - Risk Assessment** | 30% | Need risk assessment and register |
| **SA - Security Assessment** | 50% | Need documented assessment process |

### 📈 OVERALL COMPLIANCE ESTIMATE

**Technical Implementation:** ~75%  
**Documentation:** ~35%  
**Overall NIST 800-171 Compliance:** ~55%

**To reach 100%:**
- Complete critical policies (30 days)
- Document existing procedures (60 days)
- Create remaining procedures (90 days)
- Conduct initial risk assessment (30 days)
- Implement POA&M for gaps (90 days)

---

## 📝 QUICK START: YOUR FIRST 5 DOCUMENTS

Start with these to get immediate value:

### 1. System Security Plan (SSP) - TEMPLATE
Create a basic SSP that references your other documents. Start simple and expand.

### 2. Access Control Policy
Document your FreeIPA setup, group structure, and account management process.

### 3. Incident Response Plan
Define who does what when something bad happens. Include contacts and procedures.

### 4. Security Awareness Training Policy
Document what training is required and how often. Create acknowledgment forms.

### 5. Log Review Procedure
Document your log review process (weekly reviews, what to look for, escalation).

**Time Estimate:** 2-3 days for initial versions of these 5 documents

---

## 🛠️ TOOLS AND TEMPLATES

### Recommended Tools

**Document Creation:**
- LibreOffice Writer (included in Rocky Linux)
- Markdown (for version control friendly docs)
- Git (for version control of documents)

**Policy Management:**
- Simple folder structure on encrypted drive
- Version control (Git)
- Regular backups

**Evidence Collection:**
- Screenshots of configurations
- Export of FreeIPA settings
- OpenSCAP scan results
- Log excerpts
- System inventories

### Document Naming Convention

```
[Type]-[ID]-[Name]-v[Version].ext

Examples:
POLICY-001-Access_Control-v1.0.pdf
PROC-002-Account_Management-v1.0.pdf
PLAN-001-Incident_Response-v1.0.pdf
FORM-001-Access_Request-v1.0.pdf
```

### Version Control

```
Version Format: Major.Minor

Major version: Significant policy changes, requires re-approval
Minor version: Clarifications, typo fixes, minor updates

Example:
v1.0 - Initial release
v1.1 - Fixed typos, clarified wording
v2.0 - Added new requirements, changed approval process
```

---

## 📅 90-DAY IMPLEMENTATION ROADMAP

### Days 1-30: Critical Foundation

**Week 1-2: Core Policies**
- [ ] Create System Security Plan (SSP) outline
- [ ] Document Access Control Policy
- [ ] Document Identification & Authentication Policy
- [ ] Create Incident Response Plan

**Week 3-4: Operational Procedures**
- [ ] Write Account Management Procedure
- [ ] Write Log Review Procedure
- [ ] Create Media Protection Policy
- [ ] Conduct initial Risk Assessment

**Deliverable:** 8 critical documents, SSP at 40%

### Days 31-60: Expand Coverage

**Week 5-6: Security Assessment**
- [ ] Document Security Assessment Policy
- [ ] Create Plan of Action & Milestones (POA&M)
- [ ] Document Configuration Management
- [ ] Write Change Control Procedure

**Week 7-8: Communications & Training**
- [ ] Create Security Awareness Training Policy
- [ ] Develop training materials
- [ ] Document System Protection measures
- [ ] Create Personnel Security Policy

**Deliverable:** 8 additional documents, SSP at 70%

### Days 61-90: Complete and Polish

**Week 9-10: Remaining Policies**
- [ ] Document Maintenance Policy
- [ ] Document Physical Security Policy
- [ ] Create supporting forms and templates
- [ ] Complete baseline configuration docs

**Week 11-12: Finalize**
- [ ] Complete SSP (all 110 controls documented)
- [ ] Compile evidence files
- [ ] Management review and approval
- [ ] Train staff on new policies

**Deliverable:** Complete NIST 800-171 documentation package

---

## 💰 BUDGET CONSIDERATIONS

### DIY Approach (Recommended for Small Business)

**Costs:**
- Time: ~80-120 hours total (spread over 90 days)
- Tools: $0 (use LibreOffice, free templates)
- Training: $500-1000 (online courses for SSP writing)

**Total: $500-1000 + your time**

### Template/Framework Purchase

**Options:**
- NIST 800-171 template packages: $500-2000
- Compliance automation tools: $2000-5000/year
- Pre-written policies: $1000-3000

**Pros:** Saves time, professional quality  
**Cons:** Still need customization, may be overkill for small business

### Consultant Assistance

**Options:**
- Part-time consultant: $100-200/hour
- Full documentation package: $10,000-30,000
- Gap assessment: $3,000-8,000

**Pros:** Professional quality, expertise  
**Cons:** Expensive, you still need to maintain

### **Recommendation for Your Size:**
Start DIY with free templates, get a gap assessment ($3-5k) after 90 days to verify

---

## 📚 RESOURCES AND TEMPLATES

### Official Resources

**NIST Publications (Free):**
- NIST SP 800-171 Rev 2: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final
- NIST SP 800-171A: Assessment procedures
- NIST SP 800-53: Detailed control descriptions

**CMMC Resources:**
- CMMC Model: https://www.acq.osd.mil/cmmc/
- CMMC Assessment Guide
- DIB CS: https://dibnet.dod.mil/

### Template Sources

**Free Templates:**
- NIST Cybersecurity Framework templates
- SANS Policy Templates: https://www.sans.org/information-security-policy/
- CIS Controls: https://www.cisecurity.org/controls/

**Commercial Templates:**
- Compliance Forge: NIST 800-171 toolkit
- SecurelyShare: Policy templates
- Vanta/Drata: Compliance automation (expensive)

---

## ✅ DOCUMENTATION CHECKLIST

Use this to track your progress:

### Tier 1: Foundation Documents
- [ ] System Security Plan (SSP) outline
- [ ] System description and boundaries
- [ ] Network and data flow diagrams
- [ ] Hardware and software inventory
- [ ] System categorization

### Tier 2: Required Policies (14)
- [ ] Access Control Policy
- [ ] Awareness and Training Policy
- [ ] Audit and Accountability Policy
- [ ] Configuration Management Policy
- [ ] Identification and Authentication Policy
- [ ] Incident Response Policy
- [ ] Maintenance Policy
- [ ] Media Protection Policy
- [ ] Personnel Security Policy
- [ ] Physical Protection Policy
- [ ] Risk Assessment Policy
- [ ] Security Assessment Policy
- [ ] System and Communications Protection Policy
- [ ] System and Information Integrity Policy

### Tier 3: Key Procedures (10)
- [ ] Account Management Procedure
- [ ] Change Control Procedure
- [ ] Log Review Procedure
- [ ] Incident Response Procedure
- [ ] Risk Assessment Procedure
- [ ] Security Assessment Procedure
- [ ] Backup and Recovery Procedure
- [ ] Media Sanitization Procedure
- [ ] Personnel Onboarding Procedure
- [ ] Personnel Offboarding Procedure

### Tier 4: Supporting Documents
- [ ] Access Request Form
- [ ] Change Request Form
- [ ] Incident Report Form
- [ ] Log Review Form
- [ ] Risk Register
- [ ] Plan of Action and Milestones (POA&M)
- [ ] Training Acknowledgment Form
- [ ] User Agreement / Rules of Behavior
- [ ] Evidence files (configs, screenshots, scan results)

### Assessment and Reviews
- [ ] Initial Risk Assessment completed
- [ ] OpenSCAP compliance scan results
- [ ] Annual Security Assessment plan
- [ ] POA&M for any gaps
- [ ] Management review and approval

---

## 🎯 NEXT STEPS FOR YOU

### Immediate Actions (This Week)

1. **Review this guide** and familiarize yourself with requirements
2. **Create documentation folder structure** on your encrypted drive
3. **Start with SSP outline** - basic template to organize everything
4. **Write Access Control Policy** - document your FreeIPA setup
5. **Create Incident Response Plan** - critical for security

### This Month

6. **Complete 8 critical documents** from the 30-day roadmap
7. **Conduct initial risk assessment** 
8. **Create POA&M** for identified gaps
9. **Get management buy-in** on documentation effort

### Next 90 Days

10. **Follow the 90-day roadmap** to complete all documentation
11. **Train staff** on new policies and procedures
12. **Consider gap assessment** by third party
13. **Prepare for future audit/assessment**

---

## 📞 GETTING HELP

### When You Need Assistance

**DIY Resources:**
- NIST website has excellent guidance
- YouTube has NIST 800-171 tutorial series
- Reddit r/nist and r/CMMC communities

**Professional Help:**
- Gap assessment consultant (recommended after 90 days)
- Policy writing services
- Compliance automation tools

**Questions for Me:**
- I can help review policies
- Provide templates
- Answer specific compliance questions
- Guide your implementation

---

## 🏆 SUCCESS CRITERIA

You'll know you're ready for compliance when:

✅ **All 14 policy areas documented**  
✅ **SSP complete with all 110 controls addressed**  
✅ **Key procedures written and implemented**  
✅ **Staff trained and policies acknowledged**  
✅ **Risk assessment completed**  
✅ **POA&M in place for any gaps**  
✅ **Evidence files collected and organized**  
✅ **Management review and approval obtained**  
✅ **Regular reviews scheduled (annual minimum)**  

**Timeline:** 90 days for initial documentation  
**Maintenance:** Quarterly reviews, annual updates

---

## 📊 COMPLIANCE SELF-ASSESSMENT

Rate your current status (1-5 scale):

```
5 = Fully implemented and documented
4 = Implemented, documentation in progress
3 = Partially implemented
2 = Planned but not started
1 = Not addressed

__ Access Control
__ Awareness and Training
__ Audit and Accountability
__ Configuration Management
__ Identification and Authentication
__ Incident Response
__ Maintenance
__ Media Protection
__ Personnel Security
__ Physical Protection
__ Risk Assessment
__ Security Assessment
__ System and Communications Protection
__ System and Information Integrity

Total Score: __ / 70

50-70: Great start, finish documentation
35-49: Good foundation, expand coverage
20-34: Solid technical base, need policies
<20: Significant work needed
```

---

**FINAL THOUGHTS**

Documentation is **NOT** busywork. It's:
- **Evidence** that you take security seriously
- **Proof** for auditors and customers
- **Procedures** that ensure consistency
- **Training** materials for new staff
- **Reference** when incidents occur
- **Protection** in case of legal issues

**The good news:** You've already implemented most technical controls. Now you just need to document what you're already doing!

**Start small, stay consistent, and you'll have a complete compliance package in 90 days.**

---

**Document Version:** 1.0  
**Last Updated:** October 26, 2025  
**Next Review:** January 26, 2026  
**Questions?** Ask Claude! 😊

---

**END OF GUIDE**

*This document should be part of your System Security Plan package.*
