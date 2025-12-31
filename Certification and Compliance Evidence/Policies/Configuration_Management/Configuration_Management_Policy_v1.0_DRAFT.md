# Configuration Management Policy

**Document ID:** TCC-CMP-001
**Version:** 1.0 (DRAFT)
**Effective Date:** TBD (Pending Approval)
**Review Schedule:** Annually
**Next Review:** December 2026
**Owner:** Daniel Shannon, ISSO/System Owner
**Distribution:** Authorized personnel only
**Classification:** CUI

---

## 1. Purpose

This policy establishes The Contract Coach's requirements for configuration management on the CyberHygiene Production Network (CPN). It ensures systems are configured securely, changes are controlled, and baseline configurations are maintained to protect Controlled Unclassified Information (CUI) in compliance with NIST SP 800-171 Rev 2 (CM-1 through CM-11) and CMMC Level 2.

---

## 2. Scope

This policy applies to:

- **All CPN Systems:**
  - dc1.cyberinabox.net (Rocky Linux 9.6) - Domain Controller
  - ai.cyberinabox.net (macOS Sequoia) - AI/ML Server
  - ws1, ws2, ws3.cyberinabox.net (Rocky Linux 9.6) - Workstations
  - pfSense firewall - Network infrastructure

- **Configuration Items:** Operating systems, applications, firmware, network devices, security tools, baseline configurations

- **All Personnel:** Employees, contractors, and subcontractors with system administration privileges

---

## 3. Policy Statements

### 3.1 Baseline Configurations (CM-2, CM-6)

**The organization shall:**

1. **Establish Security Baselines (CM-2):**
   - Maintain documented baseline configurations for each system type
   - Baselines based on industry standards:
     - **Rocky Linux:** NIST 800-171 CUI profile (SCAP)
     - **macOS:** CIS Apple macOS Benchmark
     - **pfSense:** DISA STIG where applicable
   - Document deviations from baseline with security justification

2. **Configuration Settings (CM-6):**
   - FIPS 140-2 cryptographic mode enabled (Rocky Linux systems)
   - SELinux enforcing mode (Rocky Linux systems)
   - FileVault/LUKS full-disk encryption enabled
   - Automatic updates disabled (manual control for stability)
   - Unnecessary services disabled (principle of least functionality)

3. **Baseline Documentation Location:**
   - `/Documentation/Baselines/` on dc1.cyberinabox.net
   - Version-controlled configuration files in Git repository
   - Software Bill of Materials (SBOM) maintained quarterly

### 3.2 Configuration Change Control (CM-3)

**Change Management Process:**

1. **Change Request Requirements:**
   - All configuration changes require documented justification
   - Changes classified by risk level:
     - **Low:** Application updates, user account changes
     - **Medium:** Service configuration changes, new software installation
     - **High:** Operating system upgrades, security control modifications

2. **Change Approval:**
   - **Low risk:** System Administrator approval
   - **Medium risk:** ISSO review and approval
   - **High risk:** System Owner approval + testing in non-production environment

3. **Change Testing:**
   - **High-risk changes:** Tested on non-production system first
   - **Medium-risk changes:** Tested during off-peak hours with rollback plan
   - **Emergency changes:** Document post-implementation

4. **Change Documentation:**
   - Change log maintained in `/var/log/change-management/`
   - Include: Date, change description, approver, outcome, rollback procedure
   - POA&M updated if change addresses security finding

5. **Prohibited Changes:**
   - Disabling FIPS mode
   - Disabling SELinux
   - Disabling audit logging
   - Removing encryption
   - Opening unnecessary firewall ports
   - Installing unauthorized software

### 3.3 Security Impact Analysis (CM-4)

**Before implementing changes, analyze:**

1. Impact on security controls (weakening vs. strengthening)
2. Effect on CUI confidentiality, integrity, availability
3. Compatibility with FIPS 140-2 and NIST 800-171 requirements
4. Potential for introducing vulnerabilities
5. Dependencies on other system components

**High-impact changes require:**
- Written security impact analysis
- ISSO approval
- Post-implementation validation

### 3.4 Access Restrictions for Change (CM-5)

**Physical Access Controls:**
- Server room locked (physical key required)
- Access log maintained
- Authorized personnel only

**Logical Access Controls:**
- Administrative access requires:
  - Unique user account (no shared accounts)
  - Kerberos authentication via FreeIPA
  - sudo elevation for privileged commands (logged via auditd)
- Root account disabled for remote login
- Multi-factor authentication required for contractors (POA&M-SPRS-1)

**Change Implementation Windows:**
- Planned changes: Tuesday/Thursday 1800-2000 MST
- Emergency changes: Any time with immediate documentation

### 3.5 Configuration Settings (CM-6)

**Mandatory Security Settings:**

| Configuration Item | Required Setting | Verification |
|--------------------|------------------|--------------|
| FIPS Mode | Enabled (Rocky Linux) | `fips-mode-setup --check` |
| SELinux | Enforcing | `getenforce` |
| Encryption | LUKS AES-256 / FileVault | `lsblk`, `fdesetup status` |
| Firewall | Enabled, default-deny | `firewall-cmd --state` |
| Auditd | Running, CUI profile | `systemctl status auditd` |
| SSH | Key-based only, no root login | `/etc/ssh/sshd_config` |
| Password Policy | 14-char min, 90-day expiry | FreeIPA policy |
| Session Lock | 15-minute timeout | `gsettings` or screen saver |

### 3.6 Least Functionality (CM-7)

**The organization shall:**

1. **Disable Unnecessary Services:**
   - Remove development tools from production systems
   - Disable unused network services (telnet, FTP, etc.)
   - Remove or disable unnecessary software packages

2. **Principle of Least Functionality:**
   - Systems configured for specific mission functions only
   - No personal use software on production systems
   - Web browsing prohibited on servers (air-gapped)

3. **Prohibited Software:**
   - Peer-to-peer file sharing applications
   - Unauthorized remote access tools
   - Unapproved encryption software
   - Games or entertainment software

### 3.7 Component Inventory (CM-8)

**The organization shall maintain:**

1. **System Inventory:**
   - Hardware inventory (servers, workstations, network devices)
   - Location, serial numbers, acquisition dates
   - Assignment (user/function)
   - Update quarterly

2. **Software Inventory (SBOM):**
   - Operating systems and versions
   - Installed applications and patch levels
   - Security software (Wazuh, ClamAV, Suricata)
   - Update quarterly or upon major changes
   - Location: `Evidence/Software_Inventory/`

3. **Automated Inventory Tools:**
   - `rpm -qa` (Rocky Linux package inventory)
   - `brew list` (macOS Homebrew packages)
   - Wazuh agent inventory module

### 3.8 Configuration Management Plan (CM-9)

**The organization shall:**

1. Maintain this Configuration Management Policy as the CM Plan
2. Include baseline configurations in System Security Plan (SSP)
3. Track configuration items in version control (Git where applicable)
4. Review CM Plan annually or upon significant infrastructure changes

### 3.9 Software Usage Restrictions (CM-10)

**Requirements:**

1. **Licensed Software Only:**
   - All software properly licensed
   - License tracking spreadsheet maintained
   - Annual license compliance review

2. **Open Source Software:**
   - Only from trusted repositories (RHEL/Rocky official repos)
   - Security vulnerabilities monitored
   - Approval required for non-standard packages

3. **Software Installation:**
   - Installed from official repositories only
   - Package signatures verified
   - Custom/third-party software requires ISSO approval

### 3.10 User-Installed Software (CM-11)

**Restrictions:**

1. **Production Systems:**
   - Users prohibited from installing software
   - sudo access limited to System Administrator
   - Change management process required for all installations

2. **Workstations:**
   - Standard software suite pre-installed
   - Additional software requests submitted via change management
   - ISSO reviews security implications

3. **Monitoring:**
   - File integrity monitoring (Wazuh FIM) detects unauthorized installations
   - Package installation events logged via auditd
   - Monthly review of installed software inventory

---

## 4. Roles and Responsibilities

### 4.1 System Owner

- Approve high-risk configuration changes
- Ensure adequate resources for configuration management
- Review and approve CM Policy annually

### 4.2 Information System Security Officer (ISSO)

- Define security baseline configurations
- Review medium and high-risk change requests
- Conduct security impact analysis for changes
- Validate compliance with configuration requirements
- Maintain configuration management documentation

### 4.3 System Administrator

- Implement and maintain baseline configurations
- Execute approved configuration changes
- Document all configuration modifications
- Monitor for unauthorized changes
- Generate quarterly software inventory reports
- Respond to configuration drift alerts

### 4.4 All Users

- Do not attempt to modify system configurations
- Request software installations through proper channels
- Report suspected unauthorized changes
- Comply with software usage restrictions

---

## 5. Implementation Details

### 5.1 Baseline Configuration Files

**Rocky Linux Systems:**
```
/etc/fips-mode-setup.conf          # FIPS mode configuration
/etc/selinux/config                # SELinux configuration
/etc/ssh/sshd_config               # SSH hardening
/etc/audit/audit.rules             # Audit configuration (CUI profile)
/etc/firewalld/                    # Firewall rules
```

**macOS System (ai.cyberinabox.net):**
```
/etc/pf.conf                       # Packet filter firewall
~/Library/Preferences/             # Security preferences
/System/Library/LaunchDaemons/     # System services
```

**Version Control:**
- Configuration files backed up to `/backup/configs/`
- Git repository for tracking changes (where applicable)
- Daily differential backups

### 5.2 Configuration Compliance Verification

**Monthly Compliance Checks:**

1. **OpenSCAP Scans:**
   ```bash
   oscap xccdf eval --profile cui \
     --results-arf /root/oscap-$(date +%Y%m%d).xml \
     /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
   ```

2. **Manual Verification:**
   - FIPS mode status
   - SELinux mode
   - Critical service status
   - Firewall rules review
   - User account audit

3. **Configuration Drift Detection:**
   - Wazuh FIM monitors system files
   - Alerts on unauthorized changes to:
     - `/etc/` (configuration files)
     - `/usr/bin/`, `/usr/sbin/` (binaries)
     - `/boot/` (kernel and boot files)

### 5.3 Change Management Log Format

**Required Fields:**
```
Date: YYYY-MM-DD HH:MM:SS
Change ID: CM-YYYY-NNN
System(s): <hostname(s)>
Risk Level: Low / Medium / High
Description: <detailed change description>
Justification: <business or security need>
Approved By: <name and role>
Implemented By: <name>
Testing Performed: <test description and results>
Rollback Procedure: <steps to reverse change>
Outcome: Success / Failed / Rolled Back
Post-Implementation Validation: <verification results>
```

**Log Location:** `/var/log/change-management/changes.log`

---

## 6. Compliance Mapping

| NIST SP 800-171 Control | Implementation |
|-------------------------|----------------|
| **CM-1** Policy and Procedures | This document |
| **CM-2** Baseline Configuration | Section 3.1 |
| **CM-3** Configuration Change Control | Section 3.2 |
| **CM-4** Security Impact Analysis | Section 3.3 |
| **CM-5** Access Restrictions for Change | Section 3.4 |
| **CM-6** Configuration Settings | Section 3.5 |
| **CM-7** Least Functionality | Section 3.6 |
| **CM-8** Information System Component Inventory | Section 3.7 |
| **CM-9** Configuration Management Plan | Section 3.8 |
| **CM-10** Software Usage Restrictions | Section 3.9 |
| **CM-11** User-Installed Software | Section 3.10 |

---

## 7. Enforcement and Penalties

Violations of this policy may result in:

1. Immediate reversal of unauthorized changes
2. Suspension of administrative access
3. Written reprimand
4. Termination of employment or contract
5. Civil or criminal prosecution (for malicious changes)

All violations shall be investigated as potential security incidents.

---

## 8. Policy Review and Updates

- **Review Frequency:** Annually or upon significant infrastructure changes
- **Update Triggers:**
  - New NIST guidance or regulatory requirements
  - Security incidents revealing configuration weaknesses
  - Technology refresh or major system upgrades
  - Audit findings

- **Approval Authority:** System Owner / ISSO

---

## 9. Related Documents

- System Security Plan (SSP) - Section CM (Configuration Management)
- Software Bill of Materials (SBOM) v2.0
- Baseline Configuration Documentation
- Change Management Log
- NIST SP 800-171 Rev 2
- NIST SP 800-53 Rev 5 (CM family)
- CIS Benchmarks (Rocky Linux 9, macOS)

---

## 10. Definitions

- **Baseline Configuration:** Documented set of specifications for a system approved as the secure starting point
- **Configuration Item:** Hardware, software, or documentation item under configuration management
- **Configuration Management:** Process of establishing and maintaining consistency of system performance and attributes
- **Security Impact Analysis:** Assessment of potential security effects from proposed system changes
- **SBOM:** Software Bill of Materials - comprehensive inventory of software components

---

## 11. Approval Signatures

**Prepared By:**
Name: Daniel Shannon, System Administrator
Signature: _________________________________ Date: __________

**Reviewed By:**
Name: Daniel Shannon, Information System Security Officer
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
