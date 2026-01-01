# Acceptable Use Policy

**Document ID:** TCC-AUP-001
**Version:** 1.0
**Effective Date:** November 2, 2025
**Review Schedule:** Annually
**Next Review:** November 2, 2026
**Owner:** Donald E. Shannon, ISSO/System Owner
**Distribution:** All CPN users (employees and contractors)
**Classification:** Controlled Unclassified Information (CUI)

---

## Overview

The Contract Coach is committed to protecting the organization, employees, contractors, and clients from illegal or damaging actions by individuals, either knowingly or unknowingly. The CyberHygiene Production Network (CPN) and all associated systems, including computer equipment, mobile devices, software, operating systems, storage media, and network accounts are the property of The Contract Coach. These systems shall be used for business purposes in serving the interests of the company and our clients, particularly in fulfillment of government contracts requiring protection of Controlled Unclassified Information (CUI) and Federal Contract Information (FCI).

Effective security is a team effort involving the participation and support of every person who accesses CPN systems. It is the responsibility of every user to know these guidelines and to conduct their activities accordingly.

## Purpose

The purpose of this policy is to outline the acceptable use of computer equipment, network resources, and other electronic devices within The Contract Coach's CyberHygiene Production Network. These rules are in place to protect users, the organization, our clients, and the confidentiality, integrity, and availability of CUI and FCI. Inappropriate use exposes The Contract Coach to cyber risks including malware attacks (viruses, ransomware), compromise of network systems and services, data breaches, loss of CUI, contract termination, and legal liability under FAR 52.204-21 and DFARS 252.204-7012.

This policy supports compliance with NIST SP 800-171 Rev 2 (AC-1, PS-6, PL-4) and CMMC Level 2 requirements.

## Scope

This policy applies to:

**Systems and Equipment:**
- Domain controller: dc1.cyberinabox.net (192.168.1.10)
- All workstations (LabRat, Engineering, Accounting)
- Network infrastructure (pfSense firewall, switches)
- File shares (Samba shares on /srv/samba)
- All information, electronic devices, and network resources used to conduct The Contract Coach business

**Personnel:**
- Owner/Principal (Donald E. Shannon)
- All employees
- Contractors and consultants with CPN access
- Temporary workers
- Third parties accessing CPN resources

**Information:**
- All data on CPN systems (CUI, FCI, proprietary business information)
- Email, documents, databases, backups
- System configurations and credentials

This policy applies to all equipment and accounts, whether owned or leased by The Contract Coach, owned by employees or contractors, or provided by third parties.

## Policy

### 1. General Use and Ownership

#### 1.1 Information Ownership
The Contract Coach proprietary information and Government FCI/CUI stored on electronic and computing devices, whether owned or leased by The Contract Coach or by individuals, remains the sole property of The Contract Coach. Users must ensure through technical and procedural means that proprietary information and CUI/FCI are protected in accordance with this policy and all referenced security policies.

#### 1.2 Reporting Requirements
Users have a responsibility to promptly report (within 1 hour of discovery):
- Theft, loss, or unauthorized disclosure of The Contract Coach proprietary information or CUI/FCI
- Security incidents or suspected incidents
- Malware infections or suspected infections
- System malfunctions that could affect CUI protection
- Physical security breaches
- Policy violations observed

**Reporting Contact:**
- ISSO: Don Shannon
- Email: Don@contractcoach.com
- Phone: 505.259.8485

#### 1.3 Access Authorization
Users may access, use, or share The Contract Coach proprietary information or CUI/FCI only to the extent it is authorized and necessary to fulfill assigned job duties. Access is granted based on least privilege principles and documented business need.

#### 1.4 Personal Use
Limited personal use of CPN systems is permitted provided it:
- Does not interfere with business operations
- Does not violate any provision of this policy
- Does not involve storage of personal CUI or sensitive personal information
- Does not consume excessive system resources
- Occurs during non-business hours when possible

**Examples of Acceptable Personal Use:**
- Checking personal email during breaks (not on CPN email system)
- Brief personal research or online shopping during lunch
- Personal financial management (not on CPN systems processing CUI)

**Examples of Unacceptable Personal Use:**
- Personal business activities or operating a business
- Excessive use that impacts work productivity
- Any activity listed in Section 3 (Unacceptable Use)

#### 1.5 Monitoring
For security, incident response, and network maintenance purposes, authorized individuals (ISSO, system administrators) may monitor equipment, systems, network traffic, and user activities at any time. Monitoring includes but is not limited to:
- Audit log review (auditd, rsyslog)
- Network traffic analysis (Suricata IDS on pfSense)
- Security information and event management (Wazuh SIEM)
- File integrity monitoring (Wazuh FIM)
- Authentication logging (FreeIPA)
- File access logging (Samba VFS audit module)

**Users have no expectation of privacy** when using CPN systems. All activities may be logged, monitored, and reviewed.

#### 1.6 Compliance Audits
The Contract Coach reserves the right to audit networks, systems, and user activities on a periodic basis or in response to security incidents to ensure compliance with this policy and all security policies. Audits may include:
- Quarterly access reviews
- Annual security assessments
- Incident-driven forensic investigations
- Compliance verification scans (OpenSCAP)
- Contractor activity reviews

### 2. Security and CUI/FCI Protection

#### 2.1 Device Security
All computing devices that connect to CPN must comply with:
- FIPS 140-2 mode enabled (all systems)
- Full-disk encryption (LUKS) for all systems processing or storing CUI
- SELinux enforcing mode
- Wazuh agent installed and operational
- Automatic security updates enabled (dnf-automatic)
- ClamAV anti-malware installed and current

#### 2.2 Password Requirements
System-level and user-level passwords must comply with FreeIPA password policy (documented in CLAUDE.md):
- Minimum 14 characters
- At least 3 character classes (uppercase, lowercase, numbers, special characters)
- 90-day expiration
- 24 password history (no reuse)
- 5 failed attempts = 30-minute lockout

**Password Protection:**
- Passwords must never be shared with others
- Passwords must never be written down or stored in plaintext
- Passwords must not be stored in browser password managers (use password manager software if needed: KeePassXC recommended)
- Providing access to another individual, either deliberately or through failure to secure your account, is strictly prohibited
- Family and household members must never use your CPN credentials or systems

#### 2.3 Screen Lock
All computing devices must be secured with a password-protected lock screen:
- Automatic activation set to 15 minutes or less
- Users must manually lock screens when leaving workspace: `Ctrl+Alt+L` on Linux
- Users must fully log off when finished working for the day
- Screens visible from windows must use privacy filters

#### 2.4 Email and External Communication
- CPN email system (when deployed) for business use only
- External email from personal accounts discussing CUI must use encryption
- Postings from a Contract Coach email address to public forums must include disclaimer: "Opinions expressed are my own and not necessarily those of The Contract Coach"
- Email signature should not reveal sensitive business information

#### 2.5 Email Security
Users must exercise extreme caution with email:
- Do not open email attachments from unknown senders
- Do not click links in unsolicited emails (phishing)
- Verify sender identity before opening attachments, even from known senders
- Report suspicious emails to ISSO immediately
- Do not respond to requests for passwords or credentials
- Mark CUI emails with "CUI" in subject line

#### 2.6 CUI Marking and Handling
Users must properly mark and handle CUI per 32 CFR Part 2002:
- Mark documents with "CUI" header and footer
- Include CUI in email subject lines when applicable
- Store CUI only on encrypted CPN systems
- Do not send CUI via unencrypted channels
- Do not store CUI on personal devices, cloud services, or unencrypted media
- Refer to CUI marking guide for detailed requirements

### 3. Unacceptable Use

The following activities are prohibited. Users may NOT be exempted from these restrictions except as explicitly documented and approved by Owner/Principal for legitimate business purposes.

**Under no circumstances is any user authorized to engage in any activity that is illegal under local, state, federal, or international law while utilizing The Contract Coach-owned resources.**

The lists below provide a framework for activities which constitute unacceptable use.

#### 3.1 System and Network Activities (Strictly Prohibited)

The following activities are **strictly prohibited** with **no exceptions**:

1. **Intellectual Property Violations:** Violations of the rights of any person or company protected by copyright, trade secret, patent, or other intellectual property, including installation or distribution of "pirated" or unlicensed software

2. **Unauthorized Copying:** Unauthorized copying of copyrighted material including digitization and distribution of photographs, music, videos, books, or software for which The Contract Coach or the user does not have an active license

3. **Unauthorized Access:** Accessing data, a server, or an account for any purpose other than conducting authorized business, even if you have authorized access to the system

4. **Export Control Violations:** Exporting software, technical information, encryption software, or technology in violation of international or regional export control laws

5. **Malware Introduction:** Introduction of malicious programs into the network or systems (viruses, worms, trojans, ransomware, spyware, keyloggers, etc.)

6. **Password Sharing:** Revealing your account password to others or allowing use of your account by others, including family and household members

7. **Harassment:** Using CPN systems to actively engage in procuring or transmitting material that violates sexual harassment or hostile workplace laws

8. **Fraudulent Offers:** Making fraudulent offers of products, items, or services originating from any Contract Coach account

9. **Unauthorized Data Collection:** Effecting security breaches or disruptions of network communication, including but not limited to:
   - Port scanning
   - Ping floods, SYN floods, or other denial-of-service attacks
   - Packet spoofing
   - Sniffing network traffic without authorization
   - ARP poisoning

10. **Circumventing Security:** Circumventing user authentication or security of any host, network, or account ("cracking" or "hacking")

11. **Network Interference:** Interfering with or denying service to any user (except as authorized for security purposes by ISSO)

12. **Unauthorized Software:** Installing or using any software not approved by ISSO, including but not limited to:
    - Peer-to-peer file sharing applications
    - Remote access tools not authorized
    - Cryptocurrency mining software
    - Hacking tools (unless authorized for security testing)
    - Software from untrusted sources

#### 3.2 Email and Communication Activities (Strictly Prohibited)

1. **Spam:** Sending unsolicited email messages ("spam"), including advertising material to individuals who did not specifically request such material

2. **Email Harassment:** Sending annoying or harassing email, including harassment based on sex, race, religion, national origin, disability, or age

3. **Forged Email:** Forging or attempting to forge email header information

4. **Solicitation:** Soliciting for personal gain or non-business purposes

5. **Chain Letters:** Sending or forwarding chain letters or pyramid schemes

6. **Phishing:** Creating or forwarding phishing emails or participating in social engineering attacks

#### 3.3 Blogging and Social Media

1. **Unauthorized Disclosure:** Blogging or posting on social media about CUI, FCI, contract-specific information, or proprietary business information

2. **Impersonation:** Employees and contractors are prohibited from posting to blogging or social media sites using The Contract Coach name without explicit authorization

3. **Company Representation:** Representing yourself as speaking for The Contract Coach without authorization

4. **Client Information:** Discussing clients, contracts, or business relationships on social media without authorization

### 4. Acceptable Personal Use

The following personal activities are acceptable provided they comply with Section 1.4 (limited, non-interfering personal use):

1. **Checking Personal Email:** During breaks or non-business hours (not using CPN email system)

2. **Brief Personal Research:** Online shopping, news reading, personal finance (during breaks)

3. **Personal Education:** Professional development, online courses related to job skills

4. **Emergency Personal Business:** Handling personal emergencies (doctor appointments, family emergencies)

**Not Acceptable Even as Personal Use:**
- Storing personal CUI or sensitive personal information on CPN
- Operating a personal business
- Excessive gaming
- Streaming entertainment content (bandwidth consumption)
- Any activity listed in Section 3 (Unacceptable Use)

### 5. Removable Media and Data Transfer

#### 5.1 USB Drives and Removable Media
- Only authorized, encrypted (LUKS) USB drives may be used
- USB drives must be scanned for malware before connecting to CPN
- Personal USB drives must not be used for CUI
- USBGuard restrictions will be implemented (future enhancement)

#### 5.2 Cloud Storage
- **Prohibited:** CUI must never be stored in commercial cloud services (Dropbox, Google Drive, OneDrive, iCloud, etc.)
- Personal cloud services may be used for personal data only, on personal devices only
- Government-approved cloud services (e.g., approved FedRAMP providers) may be used only with explicit authorization for specific contracts

#### 5.3 Mobile Devices
- Personal mobile devices (smartphones, tablets) may not access CPN systems (until mobile device management implemented)
- CUI must not be stored on mobile devices
- Do not photograph or screenshot CUI on mobile devices
- Mobile devices must not be used to photograph CPN systems or configurations

### 6. Software Installation

#### 6.1 Authorized Software
- Only software approved by ISSO may be installed
- Software must be obtained from trusted repositories (Rocky Linux BaseOS/AppStream)
- All software installations logged via dnf logging
- Software license compliance is mandatory

#### 6.2 Prohibited Software
- Unlicensed or pirated software
- Peer-to-peer file sharing (BitTorrent, etc.)
- Remote access tools not approved (TeamViewer, etc. - unless authorized)
- Cryptocurrency mining software
- Hacking or penetration testing tools (unless authorized for security assessment)
- Software from untrusted sources

#### 6.3 Software Request Process
To request software installation:
1. Submit request to ISSO with business justification
2. ISSO assesses security implications
3. ISSO verifies licensing compliance
4. If approved, ISSO installs software
5. Software added to approved baseline

### 7. Physical Security Responsibilities

Users must:
- Lock workstations when leaving workspace (Ctrl+Alt+L)
- Log off at end of workday
- Never leave systems logged in and unattended
- Protect printouts containing CUI (retrieve immediately, shred when done)
- Report lost or stolen equipment immediately
- Not allow unauthorized individuals to view CUI on screens
- Use privacy filters on screens visible from windows or public areas

### 8. Incident Reporting

Users must report the following incidents immediately (within 1 hour):

1. **Security Incidents:**
   - Suspected malware infection
   - Suspected unauthorized access
   - Unusual system behavior
   - Missing or stolen equipment
   - CUI data breach or suspected breach

2. **Policy Violations:**
   - Observed violations of this policy by others
   - Requests to violate security policies
   - Suspicious activity by other users

3. **System Issues:**
   - Wazuh agent not running
   - Anti-malware not updating
   - FIPS mode disabled
   - Encryption errors

**Reporting Procedure:**
- Email: Don@contractcoach.com
- Phone: 505.259.8485
- Document what you observed, when, and any evidence
- Do not investigate security incidents yourself (unless you are the ISSO)
- Preserve evidence (don't delete logs, don't reboot unless directed)

### 9. Remote Access

**Current Status:** Remote access not currently configured

**Future Remote Access Requirements (when implemented):**
- VPN required for all remote connections
- Multi-factor authentication (MFA) required
- No storage of CUI on remote devices
- Remote devices must meet same security requirements as CPN systems
- Remote access sessions monitored and logged

### 10. Bring Your Own Device (BYOD)

**Current Policy:** BYOD not permitted for CPN access

**Personal Devices:**
- Personal laptops, tablets, and smartphones may not connect to CPN
- Personal devices may not process or store CUI
- Personal devices may not access Samba file shares
- Future BYOD program may be developed with mobile device management (MDM)

### 11. Training and Awareness

All users must:
- Complete annual security awareness training
- Acknowledge receipt and understanding of this policy (annually)
- Stay informed of policy updates
- Complete role-specific training (e.g., CUI marking for proposal developers)

### 12. Compliance and Enforcement

#### 12.1 Policy Violations
Violations of this policy may result in:
- Verbal or written warning
- Temporary suspension of access
- Permanent revocation of access
- Termination of employment or contract
- Legal action (civil or criminal)
- Reporting to law enforcement or government agencies

#### 12.2 Contractor-Specific Enforcement
Contractors who violate this policy may have:
- FreeIPA account disabled immediately
- Contract terminated for cause
- Company barred from future Contract Coach engagements
- Government contracting officer notified (if contract-related violation)

#### 12.3 Sanctions Process
Follows Personnel Security Policy (TCC-PS-001), Section PS-8:
- Minor violations: Counseling, remedial training
- Moderate violations: Written warning, access suspension
- Major violations: Termination, legal action
- Criminal violations: Law enforcement referral, DoD reporting

### 13. Solopreneur Applicability

As a single-person business with occasional contractors, certain provisions of this policy are modified:

- References to "employees" refer to Owner/Principal or authorized contractors
- No HR department exists; Owner self-enforces policy and makes all decisions
- No supervisor escalation needed for policy questions (Owner is final authority)
- Owner serves as both user and system administrator

**Owner Responsibilities:**
- Lead by example in policy compliance
- Enforce policy for all contractors
- Document all policy violations and enforcement actions
- Review and update policy annually

### 14. Policy Acknowledgment

All users must sign an acknowledgment form indicating they have read, understood, and agree to comply with this policy.

**Acknowledgment Form:**

---

**The Contract Coach Acceptable Use Policy Acknowledgment**

I, _________________________ (print name), acknowledge that I have received, read, and understood The Contract Coach Acceptable Use Policy (TCC-AUP-001). I understand that:

- CPN systems are for authorized business use
- All activity on CPN systems may be monitored and logged
- I have no expectation of privacy when using CPN systems
- I must protect CUI and FCI in accordance with this policy
- I must report security incidents and policy violations immediately
- Violations of this policy may result in access revocation, termination, and legal action

I agree to comply with all provisions of this policy and all referenced security policies.

Signature: _______________________________ Date: _______________

FreeIPA Username: _______________________________

Role: [ ] Employee [ ] Contractor [ ] Consultant

---

**For Official Use:**
- Acknowledgment received by: _______________________
- Date filed: _______________________
- FreeIPA account: _______________________
- Access granted date: _______________________

## References

- NIST SP 800-171 Rev 2 (AC-1, PS-6, PL-4)
- FAR 52.204-21 (Basic Safeguarding of Covered Contractor Information Systems)
- DFARS 252.204-7012 (Safeguarding Covered Defense Information)
- 32 CFR Part 2002 (Controlled Unclassified Information)
- System Security Plan (SSP)
- Personnel Security Policy (TCC-PS-001)
- Incident Response Policy (TCC-IRP-001)
- Physical and Media Protection Policy (TCC-PE-MP-001)
- FreeIPA Password Policy (documented in CLAUDE.md)

---

## Appendix A: Quick Reference - Do's and Don'ts

### DO:
✓ Lock your screen when leaving your workspace (Ctrl+Alt+L)
✓ Use strong, unique passwords
✓ Report security incidents immediately
✓ Mark CUI documents properly ("CUI" header/footer)
✓ Verify email sender before opening attachments
✓ Store CUI only on encrypted CPN systems
✓ Complete security training annually
✓ Ask ISSO if you're unsure about policy

### DON'T:
✗ Share your password with anyone
✗ Store CUI on personal devices or cloud storage
✗ Click links in suspicious emails
✗ Install unauthorized software
✗ Leave systems logged in and unattended
✗ Use personal USB drives for CUI
✗ Discuss CUI on social media
✗ Ignore security warnings or bypass security controls

---

## Appendix B: Reporting Template

**Security Incident Report**

**Your Information:**
- Name: _______________________
- Date/Time of Incident: _______________________
- Date/Time Reported: _______________________

**Incident Details:**
- Type of Incident: [ ] Malware [ ] Unauthorized Access [ ] Lost/Stolen Equipment [ ] Policy Violation [ ] Other: _______
- Affected System(s): _______________________
- Description of Incident: _______________________
- CUI Potentially Affected? [ ] Yes [ ] No [ ] Unknown
- Evidence Preserved? [ ] Yes [ ] No

**Actions Taken:**
- Immediate actions you took: _______________________
- Who else was notified: _______________________

**Submit to:** Don@contractcoach.com or call 505.259.8485

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
- All CPN users
- Signed acknowledgment required before account activation
- Filed in: `/backup/personnel-security/policies/`
