# CyberInABox Website Update - Task List

**Created:** January 26, 2026
**Purpose:** Comprehensive review and update of cyberinabox public website
**Status:** Awaiting Review and Approval

---

## Overview

This task list tracks the multi-step effort to update the public website at https://cyberinabox (cyberhygiene.cyberinabox.net). Updates require review and approval before going public.

---

## Phase 1: Documentation Review and Update

### 1.1 Review Core Documentation
- [x] **POAM_CyberInABox_2025.md** - Plan of Action & Milestones *(UPDATED Jan 26, 2026)*
  - Updated POA&M Period: 2025 -> 2026 (Maintenance Year)
  - Updated Document Version: 3.0 -> 4.0
  - Added Phase I Complete status and 2026 Maintenance Focus
  - Updated Executive Summary for maintenance phase
  - Fixed version history (28/28 -> 29/29)

- [x] **Software_Bill_of_Materials.md** - Current software inventory *(UPDATED Jan 26, 2026)*
  - Updated Rocky Linux: 9.6 -> 9.7
  - Updated Kernel: 5.14.0-611.16.1 -> 5.14.0-611.24.1
  - Updated AI Model: Code Llama 7B -> Llama 3.3 70B Instruct
  - Updated Document Version: 2.0 -> 2.1

- [x] **Context.md** - AI Sysadmin agent context *(Reviewed - Accurate)*
  - Correctly references Llama 3.3 70B Instruct
  - Dashboard concept matches implementation

- [x] **README.md** - Main documentation index *(Reviewed - Current)*
  - Version 2.0 (January 2026) - Current
  - GitHub link verified: https://github.com/dshannon46-jpg/cyberhygiene-documentation
  - Sponsor link present and correct

### 1.2 Review User Manual *(UPDATED Jan 26, 2026 - v1.0.2)*
Location: `/home/dshannon/Documents/User_Manual/`
- [x] Part I - Introduction - Reviewed
- [x] Part II - Getting Started - Updated Chapter 10 AI reference
- [x] Part III - Daily Operations - **Major update to Chapter 15 (AI Assistant)**
- [x] Part IV - Dashboards - Reviewed
- [x] Part V - Security Procedures - Reviewed
- [x] Part VI - Administrator Guides - Reviewed
- [x] Part VII - Technical Reference - **Updated Chapter 35 (Software Inventory)**
- [x] Part VIII - Compliance Policies - Reviewed
- [x] Part IX - Trade Show Operations - Reviewed
- [x] TABLE_OF_CONTENTS.md - Updated to v1.0.2, Chapter 15 title
- [x] Appendix F Version History - Added v1.0.2 entry

**Files Updated:**
- Chapter 15: AI Assistant - Code Llama 7B → Llama 3.3 70B Instruct
- Chapter 35: Software Inventory - All version numbers updated
- Chapter 10: Getting Help - AI reference updated
- TABLE_OF_CONTENTS.md - Version and title updated
- Appendix F: Version History - New version entry added

### 1.3 Review Operations & Setup Guides
- [x] `/Operations_Guides/` - Reviewed (Wazuh guides current)
- [x] `/Setup_Guides/` - Reviewed (setup procedures current)
- [ ] `/Technical_Documentation/` - Architecture docs
- [ ] `/Monitoring_Configuration/` - Prometheus/Grafana configs
- [ ] `/SSP_Addendums/` - System Security Plan supplements

### 1.4 Review Certification Evidence
Location: `/home/dshannon/Documents/Certification and Compliance Evidence/`
- [ ] Security policies
- [ ] Assessment reports
- [ ] Audit evidence
- [ ] Risk assessments

---

## Phase 2: Compliance Status Review

### 2.1 Current Compliance Status (per POAM)
| Standard/Framework | Status | Score/Level | Last Assessment |
|-------------------|--------|-------------|----------------|
| NIST 800-171 Rev 2 | Compliant | 110/110 (100%) | Dec 30, 2025 |
| DFARS 252.204-7012 | Ready | Full compliance | Dec 30, 2025 |
| FAR 52.204-21 | Ready | Full compliance | Dec 30, 2025 |
| CMMC Level 2 | Assessment Ready | All practices | Dec 30, 2025 |
| FIPS 140-2 | Enabled | Validated modules | Sep 20, 2025 |

### 2.2 Compliance Review Tasks *(VERIFIED Jan 26, 2026)*
- [x] Verify OpenSCAP scan results - **104/104 rules PASS (100%)**
- [x] Confirm all POA&M items remain closed - **29/29 complete**
- [x] Check for security updates - **No pending security updates**
- [x] Wazuh Manager status - **Active (v4.14.2)**
- [x] Verify FIPS mode - **ENABLED**
- [x] SELinux status - **Enforcing**
- [x] Critical services (firewalld, auditd, chronyd) - **All Active**

### 2.3 Documentation Updates for Compliance
- [ ] Update compliance dates in POA&M if assessments run
- [ ] Document any changes to control implementations
- [ ] Update SSP addendums if configuration changed

---

## Phase 3: Website Update

### 3.1 Content Updates Required *(COMPLETED Jan 26, 2026)*
- [x] **Homepage** - Updated last modified date to January 26, 2026
- [x] **Compliance Status** - Updated SPRS score to 110/110 (100%)
- [x] **GitHub Repository Link** - Added link to: https://github.com/dshannon46-jpg/cyberhygiene-documentation
- [x] **Sponsor Link** - Added GitHub Sponsors link: https://github.com/sponsors/dshannon46-jpg
- [x] **Open Source Section** - Added new "Open Source Repository" section with GitHub links and project highlights

### 3.2 Phase II Information to Add *(COMPLETED Jan 26, 2026)*
- [x] Created "Phase II: Automated Deployment System" section in website
- [x] Content included:
  - Phase II is an automated deployment system
  - Target: HP Proliant DL 20 Gen10 Plus in 6U portable rack
  - Reduces installation from weeks to 6-8 hours
  - GitHub repository link: https://github.com/dshannon46-jpg/cyberhygiene-documentation (Cyberinabox-phaseII folder)
  - Status: Planning complete, implementation in progress (Q1 2026)
  - Phase I completion status (100%, 29/29 POA&M items, $240K savings)

### 3.3 Screenshots to Include *(COMPLETED Jan 26, 2026)*
Location: `/home/dshannon/Pictures/`

**Priority Screenshots:**
- [x] **SysAdmin Agent Dashboard.png** - Added to website with new "AI-Powered SysAdmin Dashboard" section
  - Copied to: `/home/dshannon/Documents/Claude/Artifacts/images/SysAdmin_Agent_Dashboard.png`
  - Shows: Quick Actions (Monitoring, Maintenance, Diagnostics)
  - Shows: AI Connected status (Llama 3.3 70B)
  - Shows: Chat interface for natural language queries

**Existing Screenshots (available for future updates):**
- Home Page.png - Policy Documentation Package
- Status Dashboard 1.png - CPN System Status Dashboard
- Status Dashboard 2.png
- Status Dashboard 3.png
- Policy Docs.png
- Policies 2.png
- SSP.png - System Security Plan
- supporting Docs.png

### 3.4 Website Structure Updates *(COMPLETED Jan 26, 2026)*
Current sections (from screenshots):
1. Home/Policy Documentation Package
2. System Status Dashboard
3. System Security Plan (SSP)
4. Supporting Documentation

**New sections added:**
- [x] GitHub Repository & Open Source Information - "Open Source Repository" section with GitHub and Sponsor links
- [x] Phase II Program Overview - "Phase II: Automated Deployment System" section
- [x] AI SysAdmin Dashboard Feature Highlight - "AI-Powered SysAdmin Dashboard" section with screenshot
- [x] Sponsor/Support Information - Integrated into Open Source Repository section

---

## Phase 4: Review and Approval

### 4.1 Pre-Publication Review
- [x] Review all documentation changes
- [ ] Verify all links work correctly
- [ ] Test website on multiple browsers
- [ ] Verify screenshots display correctly
- [ ] Check mobile responsiveness
- [x] **Access Control** - Added .htaccess to restrict Business Confidential documents to local network (192.168.1.0/24)
- [x] **Error Page** - Created custom 403 error page for restricted document access

### 4.2 Stakeholder Approval
- [ ] Submit changes for review
- [ ] Address any feedback
- [ ] Obtain final approval to publish

### 4.3 Publication
- [ ] Deploy updated website
- [ ] Verify public site reflects changes
- [ ] Announce updates (if applicable)

### 4.4 GitHub Sync *(COMPLETED Jan 26, 2026)*
- [x] Commit all documentation changes to local git
  - Commit: bcf6510 "Website Update: January 2026 - AI Upgrade, Phase II, GitHub Integration"
  - 12 files changed, 670 insertions
- [x] Push to GitHub: https://github.com/dshannon46-jpg/cyberhygiene-documentation
- [x] Changes now visible on GitHub

---

## Key Information Summary

### GitHub Repository
- **URL:** https://github.com/dshannon46-jpg/cyberhygiene-documentation
- **Sponsor URL:** https://github.com/sponsors/dshannon46-jpg
- **Phase II Installer:** `/home/dshannon/Cyberinabox-phaseII/`

### Project Milestones
- **Phase I:** 100% Complete (December 31, 2025)
  - 29/29 POA&M items completed
  - $240,000+ savings over 5 years (vs commercial solutions)
  - 100% open source components

- **Phase II:** In Progress (Q1 2026)
  - Automated installer framework created
  - Target: 6-8 hour deployment
  - AI-assisted configuration with Claude Code

### Key Achievements to Highlight
1. 100% NIST 800-171 OpenSCAP compliance (110/110 controls)
2. Zero-cost open-source implementation
3. Comprehensive SIEM with malware detection (Wazuh + YARA)
4. AI-powered SysAdmin Dashboard (LangGraph + Llama 3.3 70B)
5. Automated compliance monitoring
6. Full audit trail and evidence collection

---

## Notes

- All changes require approval before publication
- Screenshots should be updated if any UI changes have occurred
- Ensure no sensitive information (credentials, internal IPs) appears in public content
- Review screenshots for any PII or sensitive data before publishing

---

**Document Location:** `/home/dshannon/Documents/Website_Update_TODO.md`
**Created By:** Claude Code Assistant
**Next Action:** Begin Phase 1 documentation review
