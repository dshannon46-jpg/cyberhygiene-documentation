# Document Classification and Marking Guide
**The Contract Coach - CyberHygiene Production Network**
**Effective Date:** December 2, 2025
**Owner:** Donald E. Shannon (ISSO)

---

## Purpose

This guide provides clear instructions on how to properly mark security documentation, system plans, and technical documents for The Contract Coach LLC. It clarifies when to use internal business classifications versus government CUI markings.

## Classification Categories

### 1. CONFIDENTIAL BUSINESS INFORMATION

**Use When:**
- Document contains proprietary business information, trade secrets, or internal security details
- Document is used for **internal business purposes** or shared with business partners/colleagues
- Document has **NOT yet been submitted** to U.S. Government agencies
- Sharing with potential customers, partners, or vendors who are NOT government entities

**Examples:**
- System Security Plans (SSP) used internally
- Security policies shared with contractors or subcontractors
- Technical documentation for business planning
- Compliance dashboards for internal review
- Evidence packages prepared for CMMC assessment (before government submission)

**Marking Format:**
```
Classification: CONFIDENTIAL BUSINESS INFORMATION

Distribution Notice: This document contains proprietary business information,
trade secrets, and confidential system security details of Donald E. Shannon LLC.
Unauthorized disclosure may cause competitive harm. Upon submission to U.S.
Government agencies, this document shall be marked and protected as Controlled
Unclassified Information (CUI) per 32 CFR Part 2002.
```

**Distribution Restrictions:**
- May be shared with business colleagues, consultants, and partners under NDA
- Should be protected from public disclosure
- Does NOT require CUI banner or specific government handling procedures
- Appropriate for discussions with CMMC assessors during pre-assessment

### 2. CONTROLLED UNCLASSIFIED INFORMATION (CUI)

**Use When:**
- Document has been **submitted to or is intended for** U.S. Government agencies
- Document contains information **created by or for the government**
- Processing **actual CUI data** from government contracts
- Document will be shared with government personnel (DoD, contracting officers, etc.)

**Examples:**
- SSP submitted with proposal response
- Security documentation requested by government contracting officer
- System documentation for active government contracts
- Incident reports submitted to DoD Cyber Crime Center
- Any document containing actual CUI from government sources

**Marking Format:**
```
Classification: CONTROLLED UNCLASSIFIED INFORMATION (CUI)

Distribution Notice: This document contains Controlled Unclassified Information
(CUI) and must be protected per 32 CFR Part 2002. Distribution limited to
individuals with authorized access and a need-to-know. Unauthorized disclosure
may result in civil or criminal penalties.
```

**Distribution Restrictions:**
- Only share with authorized government personnel
- Requires CUI banner at top and bottom of each page
- Must be stored on encrypted media
- Email transmission requires TLS encryption
- Cannot be shared with unauthorized third parties

## When Classification Changes

### Transition from Business Information to CUI

**Trigger Events:**
1. **Proposal Submission:** When SSP is included in government proposal
2. **Contract Award:** Upon award of government contract containing CUI clause
3. **Government Request:** When agency requests security documentation
4. **CUI Receipt:** When actual CUI data flows into your systems

**Action Required:**
1. Update document classification banner
2. Add CUI distribution notice
3. Apply CUI handling procedures
4. Update access controls and distribution lists
5. Notify recipients of classification change

### Document Versions

**Recommended Practice:**
Maintain two versions of critical documents:

1. **Internal Version:** Marked "CONFIDENTIAL BUSINESS INFORMATION"
   - Used for business planning, partner discussions, internal review
   - Can be shared with CMMC assessors and consultants
   - Easier to share without government restrictions

2. **Government Version:** Marked "CONTROLLED UNCLASSIFIED INFORMATION (CUI)"
   - Used when submitting to government agencies
   - Includes government-specific requirements
   - Restricted distribution

## Practical Examples

### Example 1: System Security Plan

**Scenario A - Internal Use:**
You're reviewing your SSP with a cybersecurity consultant to improve your security posture.

**Marking:** CONFIDENTIAL BUSINESS INFORMATION
**Reason:** No government submission, internal business improvement

**Scenario B - Proposal Submission:**
You're including the SSP as part of a proposal response to DoD.

**Marking:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Reason:** Being submitted to government agency

### Example 2: CMMC Assessment

**Before Assessment:**
Sharing documentation with C3PAO (CMMC assessor) during preparation.

**Marking:** CONFIDENTIAL BUSINESS INFORMATION
**Reason:** Assessment preparation, no government submission yet

**During/After Assessment:**
Assessment package will be uploaded to CMMC Enclave for DoD review.

**Marking:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Reason:** Will be reviewed by government personnel

### Example 3: Security Policies

**Scenario A - Contractor Onboarding:**
Providing security policies to a new subcontractor for review and acceptance.

**Marking:** CONFIDENTIAL BUSINESS INFORMATION
**Reason:** Business relationship, not government submission

**Scenario B - Contract Compliance:**
Government contracting officer requests copy of security policies for contract compliance review.

**Marking:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Reason:** Direct government request

## Current System Documentation Status

### Documents Marked "CONFIDENTIAL BUSINESS INFORMATION"

As of December 2, 2025, the following documents use the business information marking:

1. **System_Security_Plan_v1.5.docx**
2. **System_Status_Dashboard.html**
3. **Policy_Index.html**
4. All security policy documents (until submitted to government)

**Rationale:** These documents are currently used for:
- Internal security program management
- Business planning and improvement
- Potential sharing with colleagues and consultants
- CMMC preparation activities

**Government Submission:** When these documents are submitted to government agencies (proposal, contract requirement, etc.), create a copy with CUI marking.

## Marking Best Practices

### 1. Header and Footer Markings

**CONFIDENTIAL BUSINESS INFORMATION:**
- Header: "Classification: CONFIDENTIAL BUSINESS INFORMATION"
- Footer: Same classification + distribution notice
- Color: Red banner acceptable but not required

**CUI:**
- Header: "CONTROLLED UNCLASSIFIED INFORMATION (CUI)"
- Footer: Same, on every page
- Color: Purple banner recommended

### 2. Email Transmission

**CONFIDENTIAL BUSINESS INFORMATION:**
- Subject line: `[CONFIDENTIAL] - [Subject]`
- Body: Include classification notice at top
- Encryption: TLS recommended but not required

**CUI:**
- Subject line: `[CUI] - [Subject]`
- Body: Include CUI banner
- Encryption: TLS or encrypted email REQUIRED
- Cannot use unencrypted email

### 3. Storage Requirements

**CONFIDENTIAL BUSINESS INFORMATION:**
- Encrypted partition recommended
- Access controls appropriate for business data
- Backups encrypted

**CUI:**
- MUST be stored on encrypted media (LUKS encryption)
- Access limited to authorized personnel only
- Backups must be encrypted
- Audit trail required for access

## Frequently Asked Questions

**Q: Can I share "CONFIDENTIAL BUSINESS INFORMATION" documents with my attorney?**
A: Yes, under attorney-client privilege and appropriate NDA.

**Q: Do I need to mark routine business emails as "CONFIDENTIAL BUSINESS INFORMATION"?**
A: No, only documents containing security details, trade secrets, or proprietary information.

**Q: When working on an active government contract, is everything CUI?**
A: No. Only documents containing government-provided CUI or submitted to the government need CUI marking. Internal business documents remain "CONFIDENTIAL BUSINESS INFORMATION."

**Q: Can I discuss CUI-marked documents over the phone?**
A: Yes, if the recipient is authorized and has need-to-know. Document the disclosure.

**Q: What if I accidentally send CUI to an unauthorized person?**
A: This is a security incident. Follow incident response procedures and notify the government within 72 hours per DFARS 252.204-7012.

**Q: Do I need different versions for different customers?**
A: Government customers require CUI marking. Commercial customers can receive "CONFIDENTIAL BUSINESS INFORMATION" version (customize as needed).

## References

- **32 CFR Part 2002:** CUI Program regulations
- **NIST SP 800-171 Rev 2:** Protecting CUI in nonfederal systems
- **DFARS 252.204-7012:** Safeguarding CUI clause
- **CMMC Level 2:** Requires documented CUI handling procedures

## Document Control

| Version | Date | Changes | Approved By |
|---------|------|---------|-------------|
| 1.0 | December 2, 2025 | Initial release | Donald E. Shannon |

---

**For Questions or Clarification:**
Contact: Donald E. Shannon (ISSO)
Email: Don@contractcoach.com
Phone: 505.259.8485

---

**Classification:** CONFIDENTIAL BUSINESS INFORMATION

**Distribution Notice:** This document contains proprietary business information and internal security guidance of Donald E. Shannon LLC. Unauthorized disclosure may cause competitive harm. Upon submission to U.S. Government agencies, this document shall be marked and protected as Controlled Unclassified Information (CUI) per 32 CFR Part 2002.
