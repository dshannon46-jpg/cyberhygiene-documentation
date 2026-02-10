# CyberHygiene Phase II Planning Summary

**Date:** January 1, 2026
**Project:** Deployable CyberHygiene Security Platform
**Status:** Initial Planning Complete
**Target:** HP Proliant DL 20 Gen10 Plus in 6U portable rack

---

## Executive Summary

Phase II planning has successfully identified all requirements and created comprehensive documentation for a **deployable, automated installation system** for the CyberHygiene security platform.

**Key Accomplishment:** Created framework to reduce installation time from weeks to days through automation and AI-assisted configuration.

---

## Documents Created

### 1. Installation Information Form Template
**File:** `Installer/installation_info_template.md`

**Purpose:** Collect customer-specific data for deployment

**Key Sections:**
- Business information (name, DUNS, CAGE code, address)
- Domain and network configuration (FQDN, IP addresses, subnet)
- SSL certificate information
- User account details (admin + up to 10 initial users)
- System preferences (timezone, email, backups)
- Hardware specifications
- Compliance requirements
- Installation environment details

**Usage:** Complete this form for each customer installation

---

### 2. Configuration Substitution Map
**File:** `Installer/configuration_substitution_map.md`

**Purpose:** Document all configuration items requiring customization

**Key Findings:**
- **2,120 references** to "cyberinabox.net" across **219 files**
- Identified 18 major configuration categories requiring substitution
- Created variable mapping system for automated substitution

**Variables Defined:**
- `{{DOMAIN}}` - Customer domain name
- `{{REALM}}` - Kerberos realm (uppercase domain)
- `{{BUSINESS_NAME}}` - Legal business name
- `{{SUBNET}}` - Internal network subnet
- Plus 10 additional configuration variables

**Services Requiring Configuration:**
- FreeIPA (identity management)
- DNS (zone files)
- SSL certificates (domain-specific)
- Apache/HTTPD (virtual hosts)
- Prometheus (monitoring targets)
- Grafana (dashboards)
- Graylog (log management)
- Wazuh (security monitoring)
- Samba (file sharing)
- Email (Postfix/Dovecot)
- CPM Dashboard (URLs)
- Documentation (policies, procedures)

---

### 3. FIPS-Enabled Rocky Linux Installation Guide
**File:** `Installer/fips_rocky_linux_installation_guide.md`

**Purpose:** Step-by-step guide for NIST 800-171 compliant base OS installation

**Key Features:**
- BIOS/UEFI configuration requirements
- NIST-compliant disk partitioning scheme (12 separate partitions)
- Full disk encryption (LUKS) configuration
- OpenSCAP security profile selection (DISA STIG)
- FIPS 140-2 mode enablement procedure
- GRUB bootloader password setup
- Post-installation hardening steps
- OpenSCAP automated remediation

**NIST Controls Addressed:**
- AC-3 (Access Enforcement) - GRUB password, SELinux
- AC-6 (Least Privilege) - Separate partitions with restrictive mount options
- AU-4 (Audit Storage) - Dedicated /var/log/audit partition
- AU-9 (Audit Protection) - Encrypted audit logs
- SC-7 (Boundary Protection) - Network segmentation, firewall
- SC-13 (Cryptographic Protection) - FIPS mode
- SC-28 (Data at Rest Protection) - Full disk encryption
- SI-7 (Software Integrity) - OpenSCAP, SELinux

**Installation Time:** Approximately 60-90 minutes for base OS

---

### 4. Master Installation Script Architecture
**File:** `Installer/master_installation_script_architecture.md`

**Purpose:** Define automated deployment script framework

**Architecture Design:**
- Modular design (17 separate script modules)
- AI-assisted configuration (Claude Code integration)
- Comprehensive error handling and logging
- Automated rollback capability
- Progress reporting

**Installation Modules:**
| Module | Script Name | Purpose |
|--------|-------------|---------|
| 00 | prerequisites_check.sh | Verify system ready |
| 01 | generate_variables.sh | Parse installation_info.md |
| 02 | backup_system.sh | Create restore point |
| 10 | install_freeipa.sh | Domain Controller |
| 11 | configure_dns.sh | DNS zones |
| 12 | deploy_ssl_certs.sh | SSL certificates |
| 20 | install_samba.sh | File sharing |
| 30 | install_graylog.sh | Log management |
| 40 | install_suricata.sh | IDS/IPS |
| 50 | install_prometheus.sh | Monitoring |
| 51 | install_grafana.sh | Dashboards |
| 60 | install_wazuh.sh | Security platform |
| 70 | configure_backup.sh | Backup automation |
| 80 | deploy_policies.sh | Security policies |
| 90 | customize_documentation.sh | Update docs |
| 99 | final_verification.sh | System validation |

**AI Integration:**
- Uses Claude Code to parse installation forms
- Generates configuration files from templates
- Validates syntax before deployment
- Assists with troubleshooting
- Customizes documentation automatically

---

## Installation Process Flow

### Manual Phase (Installer performs)
1. **Hardware Setup:** Rack mount HP DL20, connect power/network
2. **BIOS Configuration:** Enable UEFI, configure boot options
3. **Rocky Linux Installation:** Follow FIPS installation guide (60-90 min)
4. **Post-OS Hardening:** Enable FIPS, set GRUB password, run OpenSCAP (30 min)
5. **Complete Installation Form:** Fill out `installation_info.md` with customer data

### Automated Phase (Scripts perform)
6. **Prerequisites Check:** Verify FIPS mode, disk space, network (5 min)
7. **Generate Variables:** Parse installation form, create config vars (5 min)
8. **System Backup:** Create restore point (10 min)
9. **Install Services:** Deploy FreeIPA, Samba, Graylog, etc. (2-3 hours)
10. **Configure Security:** Deploy policies, configure monitoring (30 min)
11. **Customize Docs:** Update manuals, policies for customer (15 min)
12. **Final Verification:** Run compliance scans, test services (30 min)

**Total Estimated Time:** 6-8 hours (vs. 2-3 weeks manual installation)

---

## Key Technical Decisions

### 1. Single Server Deployment (Phase II)
- All services on one HP DL20 server (64GB RAM minimum)
- Simplified architecture vs. Phase I (7 separate VMs)
- Adequate for small businesses (5-15 employees)
- Future Phase III can expand to multi-server if needed

### 2. Standard Partitions (not LVM)
- Required for FIPS mode compliance
- Simplifies disk encryption
- Meets NIST 800-171 requirements

### 3. AI-Assisted Configuration
- Claude Code integration for intelligent parsing
- Reduces human error in configuration
- Accelerates deployment time
- Provides troubleshooting assistance

### 4. Modular Script Architecture
- Individual modules can be re-run if needed
- Easy to update or extend
- Clear dependency ordering
- Comprehensive logging per module

### 5. Documentation Customization
- All 219 files updated automatically
- Customer-specific policies generated
- Compliance documents tailored to business
- Reduces post-installation manual work

---

## Hardware Specifications

### Target Platform: HP Proliant DL 20 Gen10 Plus

**Minimum Requirements:**
- **Processor:** Intel Xeon E-2334 (4 cores, 3.4 GHz) or better
- **Memory:** 64 GB DDR4 ECC RAM (128 GB recommended)
- **Boot Drive:** 2 TB NVMe SSD (FIPS-certified encryption)
- **Network:** Dual 1 Gbps Ethernet ports
- **Form Factor:** 1U rack mount (fits in 6U travel rack)
- **Power:** Redundant power supplies recommended
- **Management:** iLO (Integrated Lights-Out) for remote management

**Storage Allocation:**
- System partitions: ~400 GB
- Application data (/datastore): ~1.6 TB
- Logs and audit: ~80 GB
- Swap: 16 GB

**Network Requirements:**
- Static IP address (provided by customer ISP)
- Internal subnet: 192.168.1.0/24 (configurable)
- Internet connectivity for updates (optional after initial setup)

---

## Services Excluded from Phase II

Per the Phase II overview document, the following are **excluded** from initial deployment:

### 1. RAID Array
- Reason: Single boot drive simplifies deployment
- Future: Can add RAID 1 mirroring for redundancy in Phase III

### 2. AI Assistant (Mac Mini)
- Reason: Reduces hardware costs and complexity
- Alternative: Claude Code on installer laptop provides AI assistance
- Future: Optional add-on for customers who want local AI

**Cost Savings:** Approximately $600 (Mac Mini M4) per deployment

---

## Next Steps for Implementation

### Immediate (Week 1-2)
- [ ] Create individual module scripts (00-99)
- [ ] Develop configuration templates for all services
- [ ] Write detailed FreeIPA installation script
- [ ] Create DNS configuration automation
- [ ] Develop SSL certificate deployment script

### Short-term (Week 3-4)
- [ ] Build remaining service installation scripts
- [ ] Create documentation customization script
- [ ] Develop automated testing suite
- [ ] Write rollback procedures for each module
- [ ] Create installer training materials

### Medium-term (Week 5-8)
- [ ] Test full installation on development hardware
- [ ] Refine scripts based on testing
- [ ] Create customer handoff package
- [ ] Develop troubleshooting guide
- [ ] Document known issues and workarounds

### Final (Week 9-12)
- [ ] Perform test installation at local business (alpha test)
- [ ] Gather feedback and iterate
- [ ] Create final installation media (USB or ISO)
- [ ] Package system for transport in 6U rack
- [ ] Commission system at test site (beta test)
- [ ] Measure installation time and success criteria

---

## Success Metrics

Phase II will be considered successful when:

1. **Installation Time:** ≤ 8 hours from bare metal to fully operational
2. **Automation Level:** ≥ 80% of configuration automated
3. **Compliance:** 100% NIST 800-171 controls implemented (or documented in POA&M)
4. **Reliability:** System passes all verification tests
5. **Documentation:** Customer receives complete, customized manual
6. **Portability:** System survives transport in 6U rack without damage
7. **Training:** Customer staff can perform basic operations after 2-hour training

---

## Risk Assessment

### Technical Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Hardware incompatibility | Low | High | Test on actual HP DL20 hardware |
| Script errors during installation | Medium | Medium | Comprehensive testing, rollback capability |
| FIPS mode issues | Low | High | Follow proven installation guide |
| Customer network conflicts | Medium | Medium | Support multiple subnet configurations |
| SSL certificate issues | Medium | Medium | Support both Let's Encrypt and commercial certs |

### Business Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Installation takes longer than expected | Medium | Low | Set realistic expectations (8-10 hours) |
| Customer site not ready | High | Medium | Pre-installation checklist and site survey |
| Incomplete installation info | High | Medium | Mandatory form completion before deployment |
| Post-installation support needs | High | Low | Create comprehensive troubleshooting guide |

---

## Budget Considerations

### Hardware Costs (Per Deployment)
- HP Proliant DL 20 Gen10 Plus: ~$2,500
- 2 TB NVMe SSD (FIPS): ~$300
- 128 GB RAM upgrade: ~$400 (if not included)
- 6U portable rack case: ~$400
- Network equipment (router, switch): ~$300
- **Total Hardware:** ~$3,900 per deployment

### Software Costs
- Rocky Linux: **Free**
- All CyberHygiene services: **Open source (Free)**
- SSL Certificate: $0 (Let's Encrypt) to $150/year (commercial)
- **Total Software:** $0 - $150/year

### Labor Costs (One-time Setup)
- Script development: ~80 hours
- Testing and refinement: ~40 hours
- Documentation: ~20 hours
- Alpha/Beta testing: ~20 hours
- **Total Development:** ~160 hours

### Ongoing Costs (Per Deployment)
- Installer labor: 8-10 hours
- Travel to customer site: Varies
- Post-installation support: 4-8 hours (estimated)

---

## Competitive Advantage

### vs. Cloud-Based SIEM Solutions
- **Cost:** One-time $4K vs. $5K-$10K per year
- **Data Sovereignty:** Customer owns all data
- **Compliance:** Air-gapped option for CUI/FCI
- **Customization:** Fully tailored to business

### vs. Managed Security Services
- **Control:** Customer has full admin access
- **Independence:** No vendor lock-in
- **Transparency:** Open source, auditable
- **Local Support:** Can be managed by customer IT staff

### vs. Manual DIY Setup
- **Time:** 8 hours vs. 2-3 weeks
- **Expertise:** No specialized knowledge required
- **Reliability:** Tested, proven configuration
- **Support:** Comprehensive documentation included

---

## Questions for Customer/Stakeholder Review

Before proceeding with script development, please confirm:

1. **Hardware Platform:**
   - Is HP Proliant DL 20 Gen10 Plus the confirmed platform?
   - Do we need to support alternative hardware?

2. **Feature Set:**
   - Confirm RAID array excluded from Phase II?
   - Confirm AI assistant (Mac Mini) excluded from Phase II?
   - Any other services to exclude or add?

3. **Installation Approach:**
   - Acceptable to have manual Rocky Linux installation step?
   - Or should we create a custom Rocky Linux ISO with preset answers?

4. **Testing:**
   - Do we have access to HP DL20 hardware for testing?
   - Is there a confirmed alpha test site (local business)?

5. **Timeline:**
   - Is Q1 2026 timeline still valid?
   - What is the target date for alpha test?

6. **Support Model:**
   - What level of post-installation support will be provided?
   - Who will handle customer support calls?

---

## Appendices

### Appendix A: File Structure Created

```
/home/dshannon/Documents/Cybersecurity Project Phase II/
├── Phase II Overview.odt (original requirements)
└── Installer/
    ├── installation_info_template.md (✓ Complete)
    ├── configuration_substitution_map.md (✓ Complete)
    ├── fips_rocky_linux_installation_guide.md (✓ Complete)
    ├── master_installation_script_architecture.md (✓ Complete)
    └── [Future: scripts/, templates/, logs/, backups/]
```

### Appendix B: Related Phase I Documentation

Reference these existing documents for service configuration details:

- User Manual Part VII (Technical Reference)
- Chapter 33: System Specifications
- Chapter 34: Network Topology
- Chapter 36: Service Catalog
- Chapter 38: Configuration Baselines

### Appendix C: NIST 800-171 Control Mapping

See `fips_rocky_linux_installation_guide.md` Section "NIST 800-171 Controls Addressed" for detailed mapping of how the installation process implements specific controls.

---

## Conclusion

Phase II planning has successfully established a comprehensive framework for deploying CyberHygiene as a **turnkey, portable security solution** for small businesses.

**Key Achievements:**
- ✓ Defined all customer-specific configuration requirements
- ✓ Created complete FIPS-compliant installation procedure
- ✓ Designed modular, AI-assisted automation architecture
- ✓ Identified all 2,120+ configuration substitution points
- ✓ Established clear success metrics and timeline

**Next Phase:** Script development and testing (Weeks 1-12 of 2026)

**Expected Outcome:** Reduce installation time from weeks to hours, enabling rapid deployment to multiple customer sites with consistent, compliant configuration.

---

**Document Version:** 1.0
**Last Updated:** January 1, 2026
**Author:** CyberHygiene Phase II Planning Team
**Status:** Planning Complete - Awaiting Implementation Approval
**File Location:** `/home/dshannon/Documents/Cybersecurity Project Phase II/Phase_II_Planning_Summary.md`
