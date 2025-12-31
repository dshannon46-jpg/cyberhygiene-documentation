# Certification and Compliance Evidence Repository
**CyberHygiene Production Network (cyberinabox.net)**
**Last Updated:** December 26, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)

---

## Purpose

This repository contains all official certification, compliance, and security documentation for the CyberHygiene Production Network. All documents are organized by type and NIST control family for quick reference and audit readiness.

**Compliance Framework:** NIST SP 800-171 Revision 2
**Security Level:** CMMC Level 2 (target)
**Current SPRS Score:** 105 / 110 points (97.6%)

---

## Directory Structure

```
Certification and Compliance Evidence/
├── SSP/                      # System Security Plans
│   ├── Current/              # Active SSP versions
│   └── Archives/             # Historical SSP versions
├── POAM/                     # Plans of Action and Milestones
│   ├── Current/              # Active POA&M tracking
│   └── Archives/             # Completed POA&M items
├── Policies/                 # Security policies by control family
│   ├── Access_Control/
│   ├── Audit_and_Accountability/
│   ├── Awareness_and_Training/
│   ├── Configuration_Management/
│   ├── Identification_and_Authentication/
│   ├── Incident_Response/
│   ├── Maintenance/
│   ├── Media_Protection/
│   ├── Personnel_Security/
│   ├── Physical_Protection/
│   ├── Risk_Assessment/
│   ├── Security_Assessment/
│   ├── System_Communications_Protection/
│   └── System_Information_Integrity/
├── Assessments/              # Compliance assessments and scans
│   ├── SPRS/                 # DoD SPRS submissions
│   ├── OpenSCAP/             # SCAP compliance scans
│   └── Vulnerability_Scans/  # Security scan results
├── Evidence/                 # Supporting technical evidence
│   ├── Encryption/           # LUKS, FIPS, TLS evidence
│   ├── Authentication/       # FreeIPA, Kerberos evidence
│   ├── Monitoring/           # Wazuh, audit logs
│   ├── Network_Security/     # Firewall, IDS/IPS
│   └── Software_Inventory/   # SBOM, package inventories
├── Procedures/               # Standard operating procedures
└── README.md                 # This file
```

---

## Quick Reference

### System Security Plan (SSP)

**Current Version:** System_Security_Plan_v1.6.docx
**Location:** `SSP/Current/`
**Last Updated:** December 26, 2025
**Status:** Current (includes AI server, SPRS score, updated infrastructure)

**Key Sections:**
- Executive Summary
- System Description
- NIST 800-171 Control Implementation (14 families, 110 controls)
- Risk Assessment
- POA&M Summary
- Appendices (system inventory, network diagrams, evidence)

**Update Requirements:** See `SSP/SSP_v1.6_Update_Requirements.md` for detailed change list

### Plan of Action & Milestones (POA&M)

**Current Version:** Unified_POAM_v2.0.docx
**Location:** `POAM/Current/`
**Last Updated:** December 26, 2025
**Total Items:** 31 (16 completed, 2 in progress, 11 on track, 2 planned)

**SPRS Gaps Integrated (3 new items):**
- POA&M-SPRS-1: IA-8 MFA for Non-Org Users (-3 points, target Q1 2026)
- POA&M-SPRS-2: IR-3 Incident Response Testing (-0.5 points, target Q2 2026)
- POA&M-SPRS-3: SI-8 Spam Protection (-2 points, target Q1 2026)

**Reference Document:** POAM_SPRS_Gaps_Supplement.md (detailed remediation plans)
**Projected Score Upon Completion:** 110 / 110 points (100%)

### SPRS Assessment

**Current Version:** CyberHygiene_SPRS_Assessment_v1.0.{docx, pdf}
**Location:** `Assessments/SPRS/`
**Assessment Date:** December 25, 2025
**Score:** 105 / 110 points (97.6% compliance)

**Contents:**
- Executive Summary
- Detailed control assessment (all 110 requirements)
- Scoring methodology
- POA&M with remediation timelines
- Supporting evidence
- Certification statement

**Status:** Ready for DoD SPRS portal submission (requires signature blocks)

### Security Policies

**Location:** `Policies/[Control_Family]/`
**Current Policies (11 documents):**

| Control Family | Policy Document | Version | Format |
|----------------|----------------|---------|--------|
| Awareness and Training | Acceptable_Use_Policy | v1.0 | md, docx |
| Incident Response | Incident_Response_Policy | v1.0 | md |
| Media Protection | Physical_and_Media_Protection_Policy | v1.0 | md, docx |
| Personnel Security | Personnel_Security_Policy | v1.0 | md, docx |
| Risk Assessment | Risk_Management_Policy | v1.0 | md |
| Risk Assessment | Cyber_Risk_Policy | v1.0 | docx |
| System Information Integrity | System_and_Information_Integrity_Policy | v1.0 | md, docx |

**Note:** Additional policies may be needed for full coverage of all 14 control families.

### OpenSCAP Compliance Scans

**Location:** `Assessments/OpenSCAP/`
**Profile:** xccdf_org.ssgproject.content_profile_cui
**Last Scan:** December 2025
**Result:** 105/105 checks passed (100% compliance)

**Files:**
- `OpenSCAP_Compliance_Report.md` - Summary report
- `oscap-compliance-report.html` - Detailed HTML report
- `ssg-rl9-ds-xccdf.results.xml` - XML results file
- `oscap-remediation.sh` - Auto-generated remediation script

### Software Bill of Materials (SBOM)

**Current Version:** Software_Bill_of_Materials_v2.0.md
**Location:** `Evidence/Software_Inventory/`
**Last Updated:** December 26, 2025
**Scope:** Multi-system (all 5 systems)

**Coverage:**
- **dc1.cyberinabox.net** - Rocky Linux 9.6 (~1,750 packages)
- **ai.cyberinabox.net** - macOS Sequoia (~450 packages)
- **ws1.cyberinabox.net** - Rocky Linux 9.6 (~1,200 packages)
- **ws2.cyberinabox.net** - Rocky Linux 9.6 (~1,100 packages)
- **ws3.cyberinabox.net** - Rocky Linux 9.6 (~1,100 packages)

**Total Software Packages:** ~5,600 across all systems

**Key Features:**
- Heterogeneous platform coverage (x86_64 + ARM64)
- AI/ML software inventory (Ollama, Code Llama 7B)
- Security software documentation
- License compliance tracking
- Supply chain security verification
- Vulnerability management baseline

**Compliance:**
- ✅ CM-8: System Component Inventory
- ✅ SR-2: Supply Chain Risk Management
- ✅ SI-2: Flaw Remediation baseline
- ✅ CMMC Level 2 requirements

**Review Schedule:** Quarterly (next: March 31, 2026)

---

## Compliance Status Summary

### NIST SP 800-171 Rev 2 Control Families

| Family | Code | Requirements | Status | Score |
|--------|------|--------------|--------|-------|
| Access Control | AC | 22 | ✅ 100% | 40/40 |
| Awareness and Training | AT | 3 | ✅ 100% | 7/7 |
| Audit and Accountability | AU | 9 | ✅ 100% | 19/19 |
| Configuration Management | CM | 9 | ✅ 100% | 19/19 |
| Identification and Authentication | IA | 11 | ⚠️ 85.7% | 18/21 |
| Incident Response | IR | 6 | ⚠️ 92.9% | 6.5/7 |
| Maintenance | MA | 6 | ✅ 100% | 10/10 |
| Media Protection | MP | 8 | ✅ 100% | 11/11 |
| Personnel Security | PS | 8 | ✅ 100% | 9/9 |
| Physical Protection | PE | 6 | ✅ 100% | 8/8 |
| Risk Assessment | RA | 3 | ✅ 100% | 7/7 |
| Security Assessment | CA | 3 | ✅ 100% | 7/7 |
| System and Communications Protection | SC | 9 | ✅ 100% | 39/39 |
| System and Information Integrity | SI | 7 | ⚠️ 90.9% | 20/22 |
| **TOTAL** | | **110** | **97.6%** | **220.5/226** |

**SPRS Normalized Score:** 105 / 110 points

### Outstanding Gaps (3)

1. **IA-8:** Multi-Factor Authentication for contractors (-3 points, Q1 2026)
2. **IR-3:** Incident Response tabletop exercise (-0.5 points, Q2 2026)
3. **SI-8:** Email spam protection operational (-2 points, Q1 2026)

---

## Key Infrastructure Details

**Network Domain:** cyberinabox.net
**FreeIPA Realm:** CYBERINABOX.NET
**Network Segment:** 192.168.1.0/24

### System Inventory (5 systems)

| Hostname | IP | Role | Hardware | OS |
|----------|-----|------|----------|-----|
| dc1.cyberinabox.net | 192.168.1.10 | Domain Controller | HP MicroServer Gen10+ | Rocky Linux 9.6 |
| ai.cyberinabox.net | 192.168.1.7 | AI/ML Server | Apple Mac Mini M4 Pro | macOS Sequoia |
| ws1.cyberinabox.net | 192.168.1.21 | Admin Workstation | Custom Build | Rocky Linux 9.6 |
| ws2.cyberinabox.net | 192.168.1.22 | Engineering WS | Dell OptiPlex 7050 | Rocky Linux 9.6 |
| ws3.cyberinabox.net | 192.168.1.23 | Operations WS | Dell OptiPlex 7050 | Rocky Linux 9.6 |

**Total Resources:**
- CPU Cores: 28 (mix of x86-64 and ARM64)
- RAM: 192 GB
- Storage: ~13 TB (100% encrypted)
- Network: Gigabit Ethernet + 10GbE on AI server

### Security Controls Highlights

**Encryption:**
- ✅ FIPS 140-2 mode enabled on all Rocky Linux systems
- ✅ LUKS full-disk encryption (8 partitions, AES-256-XTS)
- ✅ Apple T2/M4 Secure Enclave (hardware encryption on AI server)
- ✅ TLS 1.2+ for all network communications
- ✅ VPN capability (OpenVPN/WireGuard with AES-256)

**Authentication:**
- ✅ FreeIPA centralized identity management
- ✅ Kerberos authentication
- ✅ Password policy: 14-char min, 90-day expiration, 24 history
- ✅ Account lockout: 5 attempts = 30-minute lockout
- ⚠️ MFA for contractors (planned Q1 2026)

**Monitoring:**
- ✅ Wazuh SIEM (5/5 systems monitored)
- ✅ Comprehensive audit logging (30+ day retention)
- ✅ Suricata IDS/IPS on network perimeter
- ✅ AI-assisted log analysis (Ollama on Apple Silicon)

**Network Security:**
- ✅ pfSense firewall with stateful inspection
- ✅ Network segmentation capability (VLANs)
- ✅ Default deny firewall rules
- ✅ Geo-blocking for high-risk countries

---

## Document Management

### Version Control

All documents follow semantic versioning:
- **Major version (X.0):** Significant structural changes or complete rewrites
- **Minor version (X.Y):** Content updates, new sections, or substantial revisions
- **Draft suffix:** Work in progress, not yet finalized

### Archival Policy

- Superseded documents moved to Archives/ subdirectories
- Minimum 3-year retention for all compliance documents
- Annual review cycle for all policies and procedures
- Quarterly review for SSP and POA&M

### Access Control

**Classification:** All documents in this repository are classified as CUI (Controlled Unclassified Information)

**Access Restrictions:**
- Read access: Authorized personnel with security clearance
- Write access: System Administrator, Security Officer
- Distribution: Limited to need-to-know basis

**File Permissions:**
- Owner: dshannon:dshannon
- Mode: 0640 (owner read/write, group read, no world access)
- SELinux context: user_home_t

---

## Audit Trail

### Recent Changes

**December 26, 2025:**
- **Repository Organization:**
  - Created hierarchical directory structure with subdirectories
  - Organized 17 policy and procedure documents by NIST control family
  - Moved SPRS assessment documents to Assessments/SPRS/
  - Moved OpenSCAP scan results to Assessments/OpenSCAP/ (9 files)
  - Moved SBOM to Evidence/Software_Inventory/
- **SSP v1.6 Finalized:**
  - Updated from v1.5 to v1.6 (41.7 KB)
  - Added AI server (Mac Mini M4 Pro) to system description
  - Updated infrastructure totals (5 systems, 28 cores, 192GB RAM, 13TB)
  - Updated SPRS score (105/110 points)
  - Added Apple Silicon security controls
  - Integrated POA&M summary with 3 SPRS gaps
- **POA&M v2.0 Created:**
  - Integrated 3 SPRS gaps into On Track section
  - Updated totals (31 items, 11 on track)
  - Updated metrics and version history
- **SBOM v2.0 Created:**
  - Expanded from single-system to multi-system coverage
  - Added AI server (macOS, Ollama, Code Llama 7B)
  - Added workstations (ws1, ws2, ws3)
  - Total: ~5,600 packages across 5 systems
- **Documentation:**
  - Created comprehensive README index
  - Fixed ownership and permissions throughout
  - Archived superseded versions (SSP v1.5, POA&M v1.0, SBOM v1.0)

**December 25, 2025:**
- Completed SPRS assessment (105/110 points)
- Generated SPRS submission documents (DOCX and PDF)
- Identified 3 gaps for POA&M remediation

**December 2, 2025:**
- Released SSP v1.5
- Updated POA&M (28 items tracked)

**November 2, 2025:**
- Completed multiple POA&M items (16 total)
- Updated compliance documentation

---

## Upcoming Reviews

**Next Scheduled Reviews:**

| Document | Current Version | Next Review | Reviewer |
|----------|----------------|-------------|----------|
| SSP | v1.6 (draft) | Mar 31, 2026 | Security Officer |
| POA&M | v1.0 + Supplement | Monthly | Security Team |
| SPRS Assessment | v1.0 | Upon POA&M completion | System Administrator |
| Security Policies | v1.0 | Jun 30, 2026 | Security Officer |
| OpenSCAP Scans | Dec 2025 | Mar 31, 2026 | System Administrator |

**Annual Reviews:**
- Complete SSP review and update
- All security policies review and approval
- Risk assessment update
- Compliance posture assessment

---

## Contact Information

**System Owner:** [To be filled]
**Security Officer:** Daniel Shannon
**System Administrator:** Daniel Shannon
**Organization:** CyberHygiene Consulting LLC

**For Questions:**
- Security matters: [Security Officer email]
- Technical matters: [System Administrator email]
- Compliance matters: [Compliance Officer email]

---

## Quick Links

**Web Dashboards:**
- Policy Index: https://cyberinabox.net/policy-index.html
- CPM Dashboard: https://cyberinabox.net/cpm-dashboard.html
- AI Administration: https://cyberinabox.net/ai-dashboard.html

**External Resources:**
- NIST SP 800-171 Rev 2: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final
- DoD SPRS Portal: https://www.sprs.csd.disa.mil/
- CMMC 2.0: https://dodcio.defense.gov/CMMC/

**Related Documents:**
- CyberHygiene Technical Specifications v1.3
- System Architecture Diagrams
- Network Topology Documentation
- Disaster Recovery Plan
- Incident Response Plan

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-26 | D. Shannon | Initial README creation |

---

**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Distribution:** Official Use Only - Need to Know Basis
**Last Updated:** December 26, 2025
