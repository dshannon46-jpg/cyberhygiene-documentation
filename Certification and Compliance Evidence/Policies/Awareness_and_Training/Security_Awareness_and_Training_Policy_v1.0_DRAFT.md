# Security Awareness and Training Policy

**Document ID:** TCC-ATP-001
**Version:** 1.0 (DRAFT)
**Effective Date:** TBD (Pending Approval)
**Review Schedule:** Annually
**Next Review:** December 2026
**Owner:** Daniel Shannon, ISSO/System Owner
**Distribution:** Authorized personnel only
**Classification:** CUI

---

## 1. Purpose

This policy establishes The Contract Coach's requirements for security awareness and training on the CyberHygiene Production Network (CPN). It ensures all personnel understand their security responsibilities and are equipped to protect Controlled Unclassified Information (CUI) in compliance with NIST SP 800-171 Rev 2 (AT-1 through AT-4) and CMMC Level 2.

---

## 2. Scope

This policy applies to:

- **All Personnel:**
  - Employees
  - Contractors and subcontractors
  - Temporary staff
  - Third-party service providers with CPN access

- **Training Topics:**
  - CUI handling and protection
  - Password security and authentication
  - Phishing and social engineering awareness
  - Incident reporting procedures
  - Physical security
  - Acceptable use of systems
  - Clean desk/clear screen requirements

---

## 3. Policy Statements

### 3.1 Security Awareness Training (AT-2)

**The organization shall:**

1. **Provide Initial Training:**
   - All new personnel receive security awareness training before system access
   - Training completed within 5 business days of start date
   - Acknowledgment of Acceptable Use Policy required

2. **Annual Refresher Training:**
   - All personnel complete refresher training annually
   - Training deadline: January 31 each year
   - Covers updates to threats, policies, and procedures

3. **Training Content:**
   - **CUI Fundamentals:**
     - Definition and examples of CUI/FCI
     - Marking requirements
     - Storage and transmission restrictions
     - Destruction procedures

   - **Password and Authentication Security:**
     - Strong password creation (14+ characters)
     - Password manager usage encouraged
     - Multi-factor authentication (MFA) requirements
     - Prohibition on password sharing

   - **Social Engineering and Phishing:**
     - Recognizing phishing emails
     - Verifying sender authenticity
     - Suspicious link and attachment handling
     - Reporting procedures

   - **Incident Recognition and Reporting:**
     - What constitutes a security incident
     - Reporting channels (ISSO contact: 505.259.8485)
     - Immediate reporting requirements
     - 72-hour DoD reporting for CUI incidents

   - **Physical Security:**
     - Visitor escort requirements
     - Clean desk policy
     - Screen lock when leaving workstation (15 minutes automatic)
     - Secure disposal of CUI (shredding, degaussing)

   - **Mobile Device and Removable Media:**
     - Authorized devices only
     - Encryption requirements
     - USB device restrictions
     - Prohibition on personal cloud storage (Dropbox, Google Drive)

   - **Remote Work Security:**
     - VPN usage requirements
     - Home network security
     - Videoconferencing security (backgrounds, information exposure)

4. **Training Delivery Methods:**
   - **In-person:** One-on-one session with ISSO (preferred for new hires)
   - **Online:** NIST CSRC awareness materials or approved third-party platform
   - **Documentation:** Security awareness handbook provided
   - **Refreshers:** Email bulletins, security tips, tabletop exercises

5. **Training Effectiveness Measurement:**
   - Phishing simulation tests (quarterly)
   - Incident reporting response time tracking
   - Knowledge assessment quiz (minimum 80% passing score)
   - Training attendance records maintained

### 3.2 Role-Based Security Training (AT-3)

**The organization shall provide specialized training for:**

1. **System Administrators:**
   - **Topics:**
     - Secure system configuration (NIST 800-171 CUI profile)
     - Audit log review and analysis
     - Vulnerability management
     - Patch deployment procedures
     - Incident response procedures
   - **Frequency:** Annual training + monthly security bulletins
   - **Certification:** Encouraged but not required (CISSP, Security+, CySA+)

2. **Information System Security Officer (ISSO):**
   - **Topics:**
     - NIST SP 800-171 Rev 2 requirements
     - CMMC framework and assessment process
     - Risk assessment methodologies
     - Security control implementation
     - Incident response and forensics
   - **Frequency:** Annual formal training + ongoing professional development
   - **Certification:** Encouraged (CISSP, CAP, CISM)

3. **Contractors/Temporary Staff:**
   - **Topics:**
     - CUI handling specific to their role
     - Limited system access procedures
     - Incident reporting to ISSO
     - Acceptable Use Policy
   - **Frequency:** Initial training before access granted
   - **Special Requirements:** Multi-factor authentication training (POA&M-SPRS-1)

### 3.3 Security Training Records (AT-4)

**The organization shall:**

1. **Maintain Training Records:**
   - Employee name and role
   - Training date and type (initial, annual, role-based)
   - Training completion status
   - Assessment scores (if applicable)
   - Acknowledgment signature

2. **Record Retention:**
   - Maintain for duration of employment + 3 years
   - Stored securely in `/srv/hr/training-records/` (encrypted)
   - Access restricted to ISSO and HR function

3. **Compliance Tracking:**
   - Monthly report of training compliance rates
   - Automated reminders 30 days before annual deadline
   - Non-compliance escalated to System Owner

4. **Training Audit Trail:**
   - Date training material updated
   - Instructors/facilitators
   - Attendee list for group sessions
   - Training material version numbers

---

## 4. Roles and Responsibilities

### 4.1 System Owner

- Allocate resources for security training
- Ensure personnel compliance with training requirements
- Enforce consequences for non-compliance
- Approve training policy and materials

### 4.2 Information System Security Officer (ISSO)

- Develop security awareness training materials
- Deliver initial and annual security awareness training
- Track training completion and compliance
- Update training content based on emerging threats
- Conduct phishing simulation exercises
- Maintain training records

### 4.3 System Administrator

- Complete annual role-based security training
- Stay current on security best practices
- Assist in developing technical training materials
- Complete continuing education (20 hours/year recommended)

### 4.4 All Personnel

- Complete mandatory security awareness training
- Immediately report security incidents
- Apply security principles in daily work
- Ask questions when unsure about security procedures
- Maintain confidentiality of CUI

---

## 5. Training Program Implementation

### 5.1 New Employee Onboarding

**Day 1:**
- Provide Acceptable Use Policy for review
- Schedule security awareness training session

**Week 1:**
- Complete initial security awareness training (2 hours)
- Review incident reporting procedures
- Tour physical security controls
- Sign Acceptable Use Policy acknowledgment
- Receive system access credentials (after training completion)

**Week 2:**
- Role-based training if applicable (system admin, ISSO)
- Hands-on demonstration of security tools (password manager, VPN)

### 5.2 Annual Training Program

**Training Schedule:**
- **Month:** January (annual training month)
- **Duration:** 1 hour refresher
- **Format:** Online module + in-person Q&A session (if needed)
- **Deadline:** January 31

**Annual Training Topics:**
- Review of previous year's security incidents (anonymized lessons learned)
- New threats and attack techniques
- Policy updates and changes
- Compliance status and goals
- Hands-on: Spotting phishing emails exercise

### 5.3 Ongoing Security Awareness

**Monthly Security Tips:**
- Email bulletin with security topic (password hygiene, phishing trends, etc.)
- 5-minute read
- Real-world examples and case studies

**Quarterly Phishing Simulations:**
- Simulated phishing emails sent to all users
- Track click rates and reporting rates
- Individualized feedback for clicked links
- Aggregate results shared (no individual shaming)
- Goal: <5% click rate, >75% reporting rate

**Incident-Driven Training:**
- Security bulletins issued within 24 hours of significant threats
- Targeted training after incidents revealing gaps
- "Lessons Learned" sessions post-incident

### 5.4 Training Materials

**Resources Provided:**
- **Security Awareness Handbook** (PDF, 20 pages)
  - Quick reference guide
  - CUI marking examples
  - Incident reporting flowchart
  - Contact information

- **Online Resources:**
  - NIST Cybersecurity Framework materials
  - CISA security tips and alerts
  - Internal SharePoint/Wiki with policies

- **Job Aids:**
  - CUI marking guide (laminated card)
  - Phishing red flags checklist
  - Incident response quick reference card

---

## 6. Training Effectiveness Metrics

**Key Performance Indicators (KPIs):**

| Metric | Target | Measurement Frequency |
|--------|--------|----------------------|
| Annual training completion rate | 100% by Jan 31 | Monthly |
| New hire training completion | 100% within 5 days | Per hire |
| Phishing simulation click rate | <5% | Quarterly |
| Incident reporting rate | >90% of simulations | Quarterly |
| Security quiz pass rate | >80% | Annually |
| Time to report incidents | <1 hour for critical | Per incident |

**Quarterly Training Report:**
- Compliance rates by department/role
- Phishing simulation results and trends
- Training effectiveness analysis
- Recommendations for improvement
- Budget and resource needs

---

## 7. Non-Compliance and Enforcement

**Consequences for Non-Completion:**

1. **First Reminder:** Email notification 30 days before deadline
2. **Second Reminder:** Email + supervisor notification 14 days before deadline
3. **Final Warning:** System access suspension warning 7 days before deadline
4. **Enforcement:** System access suspended until training completed

**Exceptions:**
- Extended leave (medical, military) - training upon return
- Emergency situations - ISSO approval for extension

**Repeated Non-Compliance:**
- Performance review impact
- Formal written warning
- Potential termination for willful disregard

---

## 8. Special Training Requirements

### 8.1 Insider Threat Awareness

**All personnel shall receive annual training on:**
- Recognizing indicators of insider threats
- Reporting suspicious behavior
- Protection of whistleblowers
- Consequences of unauthorized disclosure

### 8.2 Social Media and Public Communications

**Personnel shall be trained on:**
- Prohibition on discussing CUI on social media
- Operational security (OPSEC) principles
- Inadvertent information disclosure risks
- Company social media policy

### 8.3 Bring Your Own Device (BYOD)

**If applicable:**
- Prohibitions on CUI access from personal devices
- Acceptable use of personal devices
- Security requirements (encryption, passcode)
- Remote wipe capabilities

---

## 9. Compliance Mapping

| NIST SP 800-171 Control | Implementation |
|-------------------------|----------------|
| **AT-1** Policy and Procedures | This document |
| **AT-2** Security Awareness Training | Section 3.1 |
| **AT-3** Role-Based Security Training | Section 3.2 |
| **AT-4** Security Training Records | Section 3.3 |

---

## 10. Policy Review and Updates

- **Review Frequency:** Annually or upon significant threat landscape changes
- **Update Triggers:**
  - New regulatory requirements
  - Significant security incidents
  - Changes to organizational structure or mission
  - Emerging threats (ransomware variants, supply chain attacks)
  - Audit findings or assessment recommendations

- **Approval Authority:** System Owner / ISSO

---

## 11. Related Documents

- Acceptable Use Policy (TCC-AUP-001)
- Incident Response Policy (TCC-IRP-001)
- Personnel Security Policy (TCC-PSP-001)
- System Security Plan (SSP) - Section AT (Awareness and Training)
- NIST SP 800-171 Rev 2
- NIST SP 800-50 (Building an Information Technology Security Awareness and Training Program)

---

## 12. Definitions

- **CUI:** Controlled Unclassified Information requiring protection per NIST SP 800-171
- **FCI:** Federal Contract Information - information provided by or generated for the government under a contract
- **Phishing:** Fraudulent attempt to obtain sensitive information by disguising as trustworthy entity
- **Social Engineering:** Psychological manipulation to trick users into making security mistakes
- **Role-Based Training:** Specialized training based on system access and responsibilities

---

## 13. Approval Signatures

**Prepared By:**
Name: Daniel Shannon, Information System Security Officer
Signature: _________________________________ Date: __________

**Reviewed By:**
Name: _______________________, Human Resources (if applicable)
Signature: _________________________________ Date: __________

**Approved By:**
Name: _______________________, System Owner
Signature: _________________________________ Date: __________

---

**CLASSIFICATION:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**DISTRIBUTION:** Official Use Only - Need to Know Basis
**STATUS:** DRAFT - Pending Review and Approval

---

**END OF DOCUMENT**
