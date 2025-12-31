# PLAN OF ACTION & MILESTONES (POA&M)

**Organization:** The Contract Coach
**System:** CyberHygiene Production Network (cyberinabox.net)
**Date:** November 2, 2025
**Version:** 1.4
**Classification:** Controlled Unclassified Information (CUI)

---

## POA&M Summary

**Total Items:** 28
**Completed:** 16 (57%)
**In Progress:** 2 (7%)
**On Track:** 8 (29%)
**Planned:** 2 (7%)

**High Priority Items:** 3
**Medium Priority Items:** 7
**Low Priority Items:** 1

---

## Section 1: COMPLETED POA&M Items

Items completed as of November 2, 2025:

| POA&M ID | Weakness/Deficiency | NIST Controls | Completion Date | Evidence | Status |
|----------|---------------------|---------------|-----------------|----------|--------|
| POA&M-003 | Backup system not implemented | CP-9, CP-10 | 10/28/2025 | ReaR backup system operational with weekly full backups and daily incremental backups. Documented in Backup_Procedures.docx | ✅ COMPLETED |
| POA&M-008 | IDS/IPS not operational on firewall | SI-4 | 10/28/2025 | Wazuh SIEM v4.9.2 deployed with Suricata integration on pfSense. Real-time monitoring and alerting operational. | ✅ COMPLETED (Exceeded) |
| POA&M-009 | File integrity monitoring not deployed | SI-7 | 10/28/2025 | Wazuh FIM operational with 12-hour scan intervals on critical paths (/etc, /boot, /var/ossec, /srv/samba) | ✅ COMPLETED |
| POA&M-015 | Incident Response Policy not documented | IR-1, IR-4, IR-6, IR-8 | 11/02/2025 | Incident Response Policy and Procedures (TCC-IRP-001) approved and effective | ✅ COMPLETED |
| POA&M-016 | Incident Response Procedures not documented | IR-2, IR-3, IR-4, IR-5, IR-6, IR-7, IR-8 | 11/02/2025 | Complete IR procedures documented in TCC-IRP-001, Section 2 | ✅ COMPLETED |
| POA&M-017 | Personnel screening not documented | PS-3 | 11/02/2025 | Personnel Security Policy (TCC-PS-001, Section 2.3) documents TS clearance exceeding CUI requirements | ✅ COMPLETED |
| POA&M-018 | Personnel Security Policy not developed | PS-1, PS-2, PS-4, PS-5, PS-6, PS-7, PS-8 | 11/02/2025 | Personnel Security Policy (TCC-PS-001) approved and effective | ✅ COMPLETED |
| POA&M-019 | Physical security controls not documented | PE-1 through PE-20 | 11/02/2025 | Physical and Media Protection Policy (TCC-PE-MP-001, Part 1) approved | ✅ COMPLETED |
| POA&M-020 | Media protection procedures not developed | MP-1 through MP-8 | 11/02/2025 | Physical and Media Protection Policy (TCC-PE-MP-001, Part 2) approved | ✅ COMPLETED |
| POA&M-021 | Media sanitization not documented | MP-6 | 11/02/2025 | Media sanitization procedures documented in TCC-PE-MP-001, Section 2.6 (LUKS erase, shred) | ✅ COMPLETED |
| POA&M-022 | Risk Assessment Policy not developed | RA-1, RA-2, RA-3, RA-7 | 11/02/2025 | Risk Management Policy and Procedures (TCC-RA-001) approved and effective | ✅ COMPLETED |
| POA&M-023 | Vulnerability scanning not documented | RA-5 | 11/02/2025 | Vulnerability management documented in TCC-RA-001, Section 2.5 (Wazuh continuous scanning, OpenSCAP quarterly) | ✅ COMPLETED |
| POA&M-024 | System Integrity Policy not developed | SI-1, SI-2, SI-4, SI-5, SI-6, SI-7, SI-10, SI-11, SI-12 | 11/02/2025 | System and Information Integrity Policy (TCC-SI-001) approved and effective | ✅ COMPLETED |
| POA&M-025 | Malware protection not documented | SI-3 | 11/02/2025 | Multi-layer malware protection documented in TCC-SI-001, Section 2.3 (ClamAV, YARA, Wazuh FIM, VirusTotal) | ✅ COMPLETED |
| POA&M-026 | Acceptable Use Policy not developed | AC-1, PS-6, PL-4 | 11/02/2025 | Acceptable Use Policy (TCC-AUP-001) approved and effective | ✅ COMPLETED |
| POA&M-027 | Risk Management Framework not established | RA-3, RA-5, RA-7 | 11/02/2025 | Complete risk management framework in TCC-RA-001 with NIST SP 800-30 methodology | ✅ COMPLETED |

---

## Section 2: IN PROGRESS POA&M Items

Items currently being worked on:

| POA&M ID | Weakness/Deficiency | NIST Controls | Resources Required | Target Date | Priority | Milestone/Task | Status | POC |
|----------|---------------------|---------------|-------------------|-------------|----------|----------------|--------|-----|
| POA&M-014 | Malware protection not fully FIPS-compliant | SI-3 | Multi-layered malware defense deployment | 12/31/2025 | High | **Phase 1 Complete (85%):** YARA 4.5.2 + Wazuh integrated 10/31<br>**Phase 2 Remaining (15%):** ClamAV 1.5.x FIPS version deployment and VirusTotal API integration | 85% COMPLETE | Shannon |
| POA&M-005 | Formal Incident Response testing not conducted | IR-3 | Tabletop exercise planning and execution | 06/30/2026 | High | Annual IR tabletop exercise scheduled June 2026 per TCC-IRP-001. Exercise scenario development in Q1 2026. | SCHEDULED | Shannon |

---

## Section 3: ON TRACK POA&M Items

Items on schedule for completion:

| POA&M ID | Weakness/Deficiency | NIST Controls | Resources Required | Target Date | Priority | Milestone/Task | Status | POC |
|----------|---------------------|---------------|-------------------|-------------|----------|----------------|--------|-----|
| POA&M-001 | File sharing not operational due to Samba FIPS compatibility issue | AC-3, AC-6, AU-2 | NFS/Kerberos or NextCloud evaluation and implementation | 12/15/2025 | High | 1. Research alternatives<br>2. Select solution<br>3. Deploy<br>4. Test<br>5. Document | ON TRACK | Shannon |
| POA&M-002 | Email server not deployed | SC-8, SC-13, SI-3 | Postfix, Dovecot, Rspamd, ClamAV installation and configuration | 12/20/2025 | Medium | 1. Install packages<br>2. Configure LDAP auth<br>3. Enable encryption<br>4. Test delivery<br>5. Document | ON TRACK | Shannon |
| POA&M-004 | Multi-factor authentication not configured | IA-2(1), IA-2(2) | FreeIPA OTP or RADIUS integration | 12/22/2025 | Medium | 1. Configure OTP<br>2. Test with users<br>3. Document procedures<br>4. Deploy to all systems | ON TRACK | Shannon |
| POA&M-006 | Security awareness training program not implemented | AT-2, AT-3 | Training materials and delivery method | 12/10/2025 | Medium | 1. Select training provider<br>2. Schedule annual training<br>3. Document completion<br>4. Establish renewal cycle | ON TRACK | Shannon |
| POA&M-007 | USB device restrictions not enforced | AC-19, AC-20 | USBGuard installation and configuration | 03/31/2026 | Medium | 1. Install USBGuard<br>2. Create whitelist<br>3. Test restrictions<br>4. Deploy to all systems | ON TRACK | Shannon |
| POA&M-010 | Commercial SSL certificate needs reissue with proper SANs | SC-8, SC-13 | Contact SSL.com for certificate reissue | 12/31/2025 | Medium | 1. Request cert with wildcard or multiple SANs<br>2. Install when received<br>3. Verify all services | ON TRACK | Shannon |
| POA&M-011 | System Security Plan requires quarterly review process | CA-2 | Establish review schedule and checklist | 12/31/2025 | Medium | 1. Create review procedures<br>2. Schedule first quarterly review (Jan 2026)<br>3. Document process | ON TRACK | Shannon |
| POA&M-012 | Disaster recovery testing not performed | CP-4 | Schedule and conduct DR test | 12/28/2025 | High | 1. Develop test plan<br>2. Execute test<br>3. Document lessons learned<br>4. Update procedures | ON TRACK | Shannon |

---

## Section 4: PLANNED POA&M Items

Items scheduled for future implementation:

| POA&M ID | Weakness/Deficiency | NIST Controls | Resources Required | Target Date | Priority | Milestone/Task | Status | POC |
|----------|---------------------|---------------|-------------------|-------------|----------|----------------|--------|-----|
| POA&M-013 | Wazuh Dashboard deployment for centralized visibility (Optional) | SI-4 (enhancement) | Deploy Dashboard on separate non-FIPS VM | 01/15/2026 | Low | Optional enhancement - core monitoring functional without it. Would provide improved visualization. | PLANNED | Shannon |
| POA&M-028 | VPN with MFA for remote access not deployed | AC-17, IA-2(1) | VPN software (OpenVPN/WireGuard) with MFA integration | 03/31/2026 | High | 1. Select VPN solution<br>2. Configure with FreeIPA + MFA<br>3. Test connections<br>4. Document procedures<br>5. Deploy | PLANNED | Shannon |

---

## Section 5: NEW POA&M Items (Added November 2, 2025)

Items identified from policy implementation review:

| POA&M ID | Weakness/Deficiency | NIST Controls | Resources Required | Target Date | Priority | Milestone/Task | Status | POC |
|----------|---------------------|---------------|-------------------|-------------|----------|----------------|--------|-----|
| POA&M-029 | Session lock not configured (15 min timeout) | AC-11 | GNOME/system settings configuration | 12/15/2025 | High | 1. Configure 15-min auto-lock on all workstations<br>2. Test functionality<br>3. Verify via screenshot<br>4. Document in config baseline | NEW | Shannon |
| POA&M-030 | Audit & Accountability Policy not developed | AU-1 through AU-12 | Policy development and approval | 12/20/2025 | High | 1. Draft AU policy using existing auditd config as baseline<br>2. Review and approve<br>3. Update SSP<br>4. Store in policy directory | NEW | Shannon |
| POA&M-031 | Configuration Management Policy not developed | CM-1 through CM-11 | Policy development and approval | 03/31/2026 | Medium | 1. Draft CM policy<br>2. Document baseline configurations<br>3. Review and approve<br>4. Update SSP | NEW | Shannon |
| POA&M-032 | Security Awareness and Training Policy not developed | AT-1 through AT-4 | Policy development and approval | 03/31/2026 | Medium | 1. Draft AT policy<br>2. Integrate with AUP<br>3. Review and approve<br>4. Update SSP | NEW | Shannon |
| POA&M-033 | Identification and Authentication Policy not developed | IA-1 through IA-11 | Policy development and approval | 03/31/2026 | Medium | 1. Draft IA policy using FreeIPA as baseline<br>2. Document password policies<br>3. Review and approve<br>4. Update SSP | NEW | Shannon |
| POA&M-034 | Login banners not implemented on all systems | AC-8 | Banner configuration files | 12/15/2025 | Low | 1. Create banner text files<br>2. Configure /etc/issue, /etc/motd, SSH banner<br>3. Verify on all systems<br>4. Document | NEW | Shannon |
| POA&M-035 | First annual risk assessment not conducted | RA-3 | Risk assessment execution per TCC-RA-001 | 01/31/2026 | High | 1. Use risk register template from TCC-RA-001<br>2. Assess all CPN systems<br>3. Document findings<br>4. Update POA&M with identified risks | NEW | Shannon |

---

## POA&M Metrics

### By Status
- **Completed:** 16 items (57%)
- **In Progress:** 2 items (7%)
- **On Track:** 8 items (29%)
- **Planned:** 2 items (7%)

### By Priority
- **High:** 8 items (3 completed, 2 in progress, 2 on track, 1 planned)
- **Medium:** 10 items (13 completed as part of policy work)
- **Low:** 2 items

### By Target Date
- **Q4 2025 (Oct-Dec):** 10 items
- **Q1 2026 (Jan-Mar):** 8 items
- **Q2 2026 (Apr-Jun):** 1 item

### By Control Family
- **Access Control (AC):** 5 items
- **Awareness & Training (AT):** 3 items
- **Audit & Accountability (AU):** 1 item
- **Security Assessment & Authorization (CA):** 1 item
- **Configuration Management (CM):** 1 item
- **Contingency Planning (CP):** 2 items
- **Identification & Authentication (IA):** 3 items
- **Incident Response (IR):** 2 items (1 completed, 1 scheduled)
- **Media Protection (MP):** 2 items (completed)
- **Physical & Environmental Protection (PE):** 1 item (completed)
- **Personnel Security (PS):** 2 items (completed)
- **Risk Assessment (RA):** 4 items (3 completed, 1 new)
- **System & Communications Protection (SC):** 2 items
- **System & Information Integrity (SI):** 5 items (3 completed, 1 in progress, 1 on track)

---

## Completion Trend

| Date | Total Items | Completed | % Complete |
|------|-------------|-----------|------------|
| 10/26/2025 | 14 | 0 | 0% |
| 10/28/2025 | 14 | 3 | 21% |
| 10/31/2025 | 14 | 3 | 21% (POA&M-014 advanced to 85%) |
| 11/02/2025 | 28 | 16 | 57% |
| Projected 12/31/2025 | 28 | 24+ | 85%+ |
| Projected 03/31/2026 | 28 | 27+ | 96%+ |

---

## Risk Summary

### High Risk Items (Requiring Immediate Attention)
1. **POA&M-001:** File sharing not operational (impacts AC-3, AC-6, AU-2)
2. **POA&M-012:** Disaster recovery not tested (impacts CP-4)
3. **POA&M-029:** Session lock not configured (impacts AC-11)
4. **POA&M-030:** AU policy not developed (impacts AU family)
5. **POA&M-035:** First annual risk assessment (impacts RA-3)

### Medium Risk Items
Most medium risk items are on track for completion by Q1 2026.

### Low Risk Items
- **POA&M-013:** Optional Wazuh Dashboard (enhancement only)
- **POA&M-034:** Login banners (low security impact)

---

## Notes

### Evidence Storage
All completed POA&M items have evidence stored in:
- **Policies:** `/backup/personnel-security/policies/`
- **Technical Documentation:** `/home/dshannon/Documents/Claude/Artifacts/`
- **Configuration Files:** System configuration directories
- **Compliance Reports:** `/backup/compliance-scans/`

### Review Schedule
- **Quarterly POA&M Review:** January, April, July, October
- **Next Review:** January 31, 2026
- **POA&M Owner:** Donald E. Shannon, ISSO

### Completion Criteria
POA&M items are marked complete when:
1. Technical control is implemented and operational
2. Evidence is documented and stored
3. Testing/verification is complete
4. SSP is updated to reflect implementation
5. ISSO reviews and approves completion

### Integration with SSP
This POA&M is Section 10 of the System Security Plan Version 1.4. All referenced policies and controls are documented in the SSP.

---

## Document Control

**Classification:** Controlled Unclassified Information (CUI)
**Owner:** Donald E. Shannon, ISSO
**Distribution:** Owner/ISSO, Authorized Auditors, C3PAO Assessors
**Location:** `/home/dshannon/Documents/Claude/Artifacts/Unified_POAM.docx`
**Next Update:** January 31, 2026 (Quarterly Review)

**Revision History:**

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 10/26/2025 | D. Shannon | Initial POA&M with 14 items |
| 1.1 | 10/28/2025 | D. Shannon | Marked POA&M-003, 008, 009 complete |
| 1.2 | 10/31/2025 | D. Shannon | POA&M-014 advanced to 85% |
| 1.3 | 11/02/2025 | D. Shannon | Unified POA&M: Marked 13 policy items complete, added 8 new items, restructured into 5 sections |

---

*END OF UNIFIED POA&M*
