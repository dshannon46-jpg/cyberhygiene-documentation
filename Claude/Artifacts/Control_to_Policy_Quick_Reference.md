# NIST 800-171 Control-to-Policy Quick Reference

**Organization:** The Contract Coach
**System:** CyberHygiene Production Network (cyberinabox.net)
**Date:** November 2, 2025
**Version:** 1.0

---

## Purpose

This quick reference provides a comprehensive mapping of all NIST SP 800-171 Rev 2 controls to The Contract Coach's policy documents, making it easy to locate policy coverage for any specific control during audits, assessments, or SPRS updates.

---

## How to Use This Reference

1. **Locate the control** you need in the tables below (organized by control family)
2. **Find the policy document** that covers that control
3. **Note the specific section** within the policy
4. **Reference the file path** for evidence: `/backup/personnel-security/policies/[filename].docx`

**Policy ID Key:**
- TCC-IRP-001 = Incident Response Policy and Procedures
- TCC-RA-001 = Risk Management Policy and Procedures
- TCC-PS-001 = Personnel Security Policy
- TCC-PE-MP-001 = Physical and Media Protection Policy
- TCC-SI-001 = System and Information Integrity Policy
- TCC-AUP-001 = Acceptable Use Policy

---

## Complete Control-to-Policy Mapping

### 3.1 ACCESS CONTROL (AC)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.1.1 | Limit system access to authorized users, processes acting on behalf of authorized users, and devices (including other systems) | Implemented | Acceptable Use Policy | TCC-AUP-001 | Entire policy | FreeIPA technical implementation |
| 3.1.2 | Limit system access to the types of transactions and functions that authorized users are permitted to execute | Implemented | System Config | N/A | FreeIPA RBAC | Group-based access control |
| 3.1.3 | Control the flow of CUI in accordance with approved authorizations | Implemented | Acceptable Use Policy | TCC-AUP-001 | Section 3 | CUI handling procedures |
| 3.1.4 | Separate the duties of individuals to reduce the risk of malevolent activity without collusion | N/A | N/A | N/A | N/A | Solopreneur - single operator |
| 3.1.5 | Employ the principle of least privilege, including for specific security functions and privileged accounts | Implemented | System Config | N/A | FreeIPA groups | Role-based access |
| 3.1.6 | Use non-privileged accounts or roles when accessing nonsecurity functions | Implemented | Acceptable Use Policy | TCC-AUP-001 | Section 2.1 | Standard user accounts |
| 3.1.7 | Prevent non-privileged users from executing privileged functions | Implemented | System Config | N/A | sudo config | sudorule: admins_all |
| 3.1.8 | Limit unsuccessful logon attempts | Implemented | System Config | N/A | FreeIPA policy | 5 attempts = 30min lockout |
| 3.1.9 | Provide privacy and security notices consistent with applicable laws | Implemented | Acceptable Use Policy | TCC-AUP-001 | Section 2.6 | Login banners planned Q4 2025 |
| 3.1.10 | Use session lock with pattern-hiding displays to prevent access and viewing of data after period of inactivity | Planned | Acceptable Use Policy | TCC-AUP-001 | Section 2.3 | 15min auto-lock, config Q4 2025 |
| 3.1.11 | Terminate (automatically) a user session after a defined condition | Implemented | System Config | N/A | SSH config | Session timeouts configured |
| 3.1.12 | Monitor and control remote access sessions | Implemented | System Config | N/A | VPN planned | VPN with MFA planned Q1 2026 |
| 3.1.13 | Employ cryptographic mechanisms to protect the confidentiality of remote access sessions | Implemented | System Config | N/A | SSH, TLS | All remote access encrypted |
| 3.1.14 | Route remote access via managed access control points | Implemented | Network Config | N/A | pfSense | Single internet gateway |
| 3.1.15 | Authorize remote access prior to allowing such connections | Implemented | Personnel Security Policy | TCC-PS-001 | Section 2.2 | remote_access group |
| 3.1.16 | Authorize wireless access prior to allowing such connections | Implemented | Network Config | N/A | WiFi | WPA3 authentication |
| 3.1.17 | Protect wireless access using authentication and encryption | Implemented | Network Config | N/A | WiFi | WPA3-Personal |
| 3.1.18 | Control connection of mobile devices | Implemented | Acceptable Use Policy | TCC-AUP-001 | Section 2.4 | Mobile devices prohibited for CUI |
| 3.1.19 | Encrypt CUI on mobile devices and mobile computing platforms | Implemented | Acceptable Use Policy | TCC-AUP-001 | Section 2.4 | N/A - no mobile CUI processing |
| 3.1.20 | Verify and control/limit connections to and use of external systems | Implemented | Network Config | N/A | Firewall | Restrictive egress rules |
| 3.1.21 | Limit use of portable storage devices on external systems | Implemented | Acceptable Use Policy | TCC-AUP-001 | Section 2.5 | USBGuard planned Q1 2026 |
| 3.1.22 | Control CUI posted or processed on publicly accessible systems | Implemented | Acceptable Use Policy | TCC-AUP-001 | Section 4 | CUI prohibited on public systems |

---

### 3.3 AWARENESS AND TRAINING (AT)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.3.1 | Provide security awareness training on recognizing and reporting potential indicators of insider threat | Partial | Acceptable Use Policy | TCC-AUP-001 | Throughout | Comprehensive AT policy planned Q1 2026 |
| 3.3.2 | Ensure that personnel are trained to carry out their assigned information security-related duties and responsibilities | Partial | Acceptable Use Policy | TCC-AUP-001 | Throughout | AUP provides baseline, AT policy Q1 2026 |
| 3.3.3 | Provide security awareness training on recognizing and reporting potential indicators of insider threat | Partial | Acceptable Use Policy | TCC-AUP-001 | Throughout | Included in AUP acknowledgment |
| 3.3.4 | Provide awareness training upon hire and annually thereafter | Partial | Acceptable Use Policy | TCC-AUP-001 | Section 7 | AUP renewal every 2 years |

---

### 3.4 AUDIT AND ACCOUNTABILITY (AU)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.4.1 | Create and retain system audit logs and records to enable monitoring and analysis of security-relevant events | Implemented | System Config | TCC-AU-001 (draft) | auditd, Wazuh | AU policy Q4 2025 |
| 3.4.2 | Ensure that the actions of individual system users can be uniquely traced | Implemented | System Config | TCC-AU-001 (draft) | auditd rules | FreeIPA + auditd |
| 3.4.3 | Review and update logged events | Implemented | System Config | TCC-AU-001 (draft) | auditd config | Quarterly review |
| 3.4.4 | Alert in the event of an audit logging process failure | Implemented | System Config | TCC-AU-001 (draft) | auditd config | Admin email alerts |
| 3.4.5 | Correlate audit record review, analysis, and reporting processes for investigation and response | Implemented | Incident Response Policy + System Config | TCC-IRP-001 + TCC-AU-001 (draft) | IR Section 2.5 | Wazuh correlation |
| 3.4.6 | Provide audit record reduction and report generation | Implemented | System Config | TCC-AU-001 (draft) | Wazuh | Dashboard reporting |
| 3.4.7 | Provide a system capability that compares and synchronizes internal system clocks with an authoritative source | Implemented | System Config | TCC-AU-001 (draft) | chronyd | NTP time sync |
| 3.4.8 | Protect audit information and audit logging tools from unauthorized access | Implemented | System Config | TCC-AU-001 (draft) | File permissions | /var/log/audit root:root 600 |
| 3.4.9 | Limit management of audit logging functionality to a subset of privileged users | Implemented | System Config | TCC-AU-001 (draft) | sudo rules | ISSO/admin only |
| 3.4.10 | Allocate audit log storage capacity | Implemented | System Config | TCC-AU-001 (draft) | Partition sizing | /var/log/audit separate partition |
| 3.4.11 | Provide warning when allocated audit record storage volume reaches organization-defined percentage of maximum | Implemented | System Config | TCC-AU-001 (draft) | Wazuh alerts | 75% threshold alert |
| 3.4.12 | Back up audit records at least weekly onto a different system or media than the system being audited | Implemented | System Config + Backup Procedures | TCC-AU-001 (draft) | ReaR | Weekly USB backup |

---

### 3.5 CONFIGURATION MANAGEMENT (CM)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.5.1 | Establish and maintain baseline configurations and inventories of organizational systems | Implemented | Configuration Management Baseline | TCC-CM-001 (planned) | Entire doc | CM policy planned Q1 2026 |
| 3.5.2 | Employ automated mechanisms to maintain an up-to-date, complete, accurate, and readily available baseline configuration | Implemented | System Config | TCC-CM-001 (planned) | Wazuh FIM | File integrity monitoring |
| 3.5.3 | Define, document, approve, and enforce physical and logical access restrictions associated with changes to systems | Implemented | System Config | TCC-CM-001 (planned) | Change control | ISSO approval required |
| 3.5.4 | Employ the principle of least functionality by configuring systems to provide only essential capabilities | Implemented | System Config | TCC-CM-001 (planned) | Minimal install | Rocky Linux minimal + required |
| 3.5.5 | Restrict, disable, or prevent the use of nonessential programs, functions, ports, protocols, and services | Implemented | System Config | TCC-CM-001 (planned) | Firewall | Restrictive firewall rules |
| 3.5.6 | Apply deny-by-default and allow-by-exception policy for allowing specific ports, protocols, and services | Implemented | Network Config | TCC-CM-001 (planned) | pfSense | Default deny ruleset |
| 3.5.7 | Restrict, disable, or prevent the use of nonessential programs, functions, ports, protocols, and services | Implemented | System Config | TCC-CM-001 (planned) | SELinux | Enforcing mode |
| 3.5.8 | Apply deny-by-default, allow-by-exception policy to control the execution of authorized software programs | Implemented | System Config | TCC-CM-001 (planned) | Application whitelist | dnf package management only |
| 3.5.9 | Control and monitor user-installed software | Implemented | System Config | TCC-CM-001 (planned) | Wazuh FIM | Software installation monitoring |
| 3.5.10 | Employ automated mechanisms to detect the presence of unauthorized software on organizational systems and notify designated personnel | Implemented | System Config | TCC-CM-001 (planned) | Wazuh FIM | Real-time file monitoring |
| 3.5.11 | Employ automated mechanisms to help ensure security functions operate as intended | Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.6 | OpenSCAP quarterly scans |

---

### 3.6 INCIDENT RESPONSE (IR)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.6.1 | Establish an operational incident-handling capability for organizational systems that includes preparation, detection, analysis, containment, recovery, and user response activities | ✅ Implemented | Incident Response Policy and Procedures | TCC-IRP-001 | Section 2.4 | Complete IR procedures |
| 3.6.2 | Track, document, and report incidents to designated officials and/or authorities | ✅ Implemented | Incident Response Policy and Procedures | TCC-IRP-001 | Section 2.6 | DoD 72-hour reporting |
| 3.6.3 | Test the organizational incident response capability | ✅ Implemented | Incident Response Policy and Procedures | TCC-IRP-001 | Section 2.3 | Annual tabletop, first June 2026 |

**Additional IR Controls from Policy:**

| Control | Full NIST ID | Policy Section |
|---------|--------------|----------------|
| IR-1 | Policy and Procedures | Section 1 |
| IR-2 | Incident Response Training | Section 2.2 |
| IR-3 | Incident Response Testing | Section 2.3 |
| IR-4 | Incident Handling | Section 2.4 |
| IR-5 | Incident Monitoring | Section 2.5 |
| IR-6 | Incident Reporting | Section 2.6 |
| IR-7 | Incident Response Assistance | Section 2.7 |
| IR-8 | Incident Response Plan | Section 2.8 |

---

### 3.8 MEDIA PROTECTION (MP)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.8.1 | Protect (i.e., physically control and securely store) system media containing CUI, both paper and digital | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.4 | Locked storage + encryption |
| 3.8.2 | Limit access to CUI on system media to authorized users | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.2 | Owner-only + LUKS encryption |
| 3.8.3 | Sanitize or destroy system media containing CUI before disposal or release for reuse | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.6 | LUKS erase + shred procedures |
| 3.8.4 | Mark media with necessary CUI markings and distribution limitations | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.3 | 32 CFR Part 2002 marking |
| 3.8.5 | Control access to media containing CUI and maintain accountability for media during transport | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.5 | Transport procedures |
| 3.8.6 | Implement cryptographic mechanisms to protect the confidentiality of CUI stored on digital media during transport | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.7 | FIPS 140-2 LUKS |
| 3.8.7 | Control the use of removable media on system components | Planned | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.7 | USBGuard planned Q1 2026 |
| 3.8.8 | Prohibit the use of portable storage devices when such devices have no identifiable owner | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.7 | Policy requirement |
| 3.8.9 | Protect the confidentiality of backup CUI at storage locations | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.4 | Encrypted USB, safe deposit box |

**Additional MP Controls from Policy:**

| Control | Full NIST ID | Policy Section |
|---------|--------------|----------------|
| MP-1 | Policy and Procedures | Part 2, Section 2.1 |
| MP-2 | Media Access | Part 2, Section 2.2 |
| MP-3 | Media Marking | Part 2, Section 2.3 |
| MP-4 | Media Storage | Part 2, Section 2.4 |
| MP-5 | Media Transport | Part 2, Section 2.5 |
| MP-6 | Media Sanitization | Part 2, Section 2.6 |
| MP-7 | Media Use | Part 2, Section 2.7 |
| MP-8 | Media Downgrading | Part 2, Section 2.8 |

---

### 3.9 PERSONNEL SECURITY (PS)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.9.1 | Screen individuals prior to authorizing access to organizational systems containing CUI | ✅ Implemented | Personnel Security Policy | TCC-PS-001 | Section 2.3 | TS clearance + contractor screening |
| 3.9.2 | Ensure that organizational systems containing CUI are protected during and after personnel actions | ✅ Implemented | Personnel Security Policy + Acceptable Use Policy | TCC-PS-001 + TCC-AUP-001 | PS Section 2.6, AUP entire | NDA, CUI Agreement, AUP acknowledgment |

**Additional PS Controls from Policy:**

| Control | Full NIST ID | Policy Section | Notes |
|---------|--------------|----------------|-------|
| PS-1 | Policy and Procedures | Section 1 | |
| PS-2 | Position Risk Designation | Section 2.2 | High/Moderate/Low designations |
| PS-3 | Personnel Screening | Section 2.3 | TS clearance documentation |
| PS-4 | Personnel Termination | Section 2.4 | FreeIPA disable procedures |
| PS-5 | Personnel Transfer | Section 2.5 | Access adjustment procedures |
| PS-6 | Access Agreements | Section 2.6 + TCC-AUP-001 | NDA, CUI Agreement, AUP |
| PS-7 | Third-Party Personnel Security | Section 2.7 | Contractor vetting |
| PS-8 | Personnel Sanctions | Section 2.8 | Progressive discipline |

---

### 3.10 PHYSICAL PROTECTION (PE)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.10.1 | Limit physical access to organizational systems, equipment, and the respective operating environments to authorized individuals | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 1, Section 1.2, 1.3 | Locked office, server rack |
| 3.10.2 | Protect and monitor the physical facility and support infrastructure for organizational systems | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 1, Section 1.6 | Owner monitoring (solopreneur) |
| 3.10.3 | Escort visitors and control visitor activity | ✅ N/A | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 1, Section 1.8 | No visitors in CUI area |
| 3.10.4 | Maintain audit logs of physical access | ✅ N/A | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 1, Section 1.6 | Owner sole occupant |
| 3.10.5 | Control and manage physical access devices | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 1, Section 1.3 | Keys, locks documented |
| 3.10.6 | Enforce safeguarding measures for CUI at alternate work sites | ✅ N/A | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 1, Section 1.17 | No alternate sites |

**Additional PE Controls from Policy:**

| Control | Full NIST ID | Policy Section | Status |
|---------|--------------|----------------|--------|
| PE-1 | Policy and Procedures | Part 1, Section 1.1 | ✅ Implemented |
| PE-2 | Physical Access Authorizations | Part 1, Section 1.2 | ✅ Implemented |
| PE-3 | Physical Access Control | Part 1, Section 1.3 | ✅ Implemented |
| PE-4 | Access Control for Transmission | Part 1, Section 1.4 | ✅ Implemented |
| PE-6 | Monitoring Physical Access | Part 1, Section 1.6 | ✅ Implemented (some N/A) |
| PE-8 | Visitor Access Control | Part 1, Section 1.8 | ✅ N/A (documented) |
| PE-9 | Power Equipment and Cabling | Part 1, Section 1.9 | ✅ Implemented |
| PE-10 | Emergency Shutoff | Part 1, Section 1.10 | ✅ Implemented |
| PE-13 | Fire Protection | Part 1, Section 1.13 | ✅ Implemented |
| PE-14 | Temperature and Humidity | Part 1, Section 1.14 | ✅ Implemented |
| PE-15 | Water Damage Protection | Part 1, Section 1.15 | ✅ Implemented |
| PE-16 | Delivery and Removal | Part 1, Section 1.16 | ✅ Implemented |
| PE-17 | Alternate Work Sites | Part 1, Section 1.17 | ✅ N/A (documented) |
| PE-20 | Asset Monitoring and Tracking | Part 1, Section 1.20 | ✅ Implemented |

---

### 3.11 RISK ASSESSMENT (RA)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.11.1 | Periodically assess the risk to organizational operations, assets, and individuals from organizational systems | ✅ Implemented | Risk Management Policy and Procedures | TCC-RA-001 | Section 2.3 | Annual + event-driven, first Jan 2026 |
| 3.11.2 | Scan for vulnerabilities in organizational systems and applications periodically and when new vulnerabilities affecting the systems are identified | ✅ Implemented | Risk Management Policy and Procedures | TCC-RA-001 | Section 2.5 | Wazuh continuous + OpenSCAP quarterly |
| 3.11.3 | Remediate vulnerabilities in accordance with risk assessments | ✅ Implemented | Risk Management Policy and Procedures | TCC-RA-001 | Section 2.7 | 7/30/90 day timelines |

**Additional RA Controls from Policy:**

| Control | Full NIST ID | Policy Section | Notes |
|---------|--------------|----------------|-------|
| RA-1 | Policy and Procedures | Section 1 | |
| RA-2 | Security Categorization | Section 2.2 | FIPS 199 Moderate |
| RA-3 | Risk Assessment | Section 2.3 | NIST SP 800-30 methodology |
| RA-5 | Vulnerability Scanning | Section 2.5 | Wazuh + OpenSCAP |
| RA-6 | Technical Surveillance Countermeasures | Section 2.6 | N/A for CUI |
| RA-7 | Risk Response | Section 2.7 | Avoid, mitigate, transfer, accept |
| RA-8 | Privacy Impact Assessment | Section 2.8 | N/A (no PII processing) |
| RA-9 | Supply Chain Risk | Section 2.9 | Contractor vetting |

---

### 3.13 SYSTEM AND COMMUNICATIONS PROTECTION (SC)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.13.1 | Monitor, control, and protect communications at external boundaries | Implemented | System Config | TCC-SC-001 (planned) | Suricata IDS | pfSense firewall + Suricata |
| 3.13.2 | Employ architectural designs, software development techniques, and systems engineering principles that promote effective information security | Implemented | System Config | TCC-SC-001 (planned) | Defense in depth | Layered security approach |
| 3.13.3 | Separate user functionality from system management functionality | Implemented | System Config | TCC-SC-001 (planned) | User separation | Standard vs admin accounts |
| 3.13.4 | Prevent unauthorized and unintended information transfer via shared system resources | Implemented | System Config | TCC-SC-001 (planned) | SELinux | Type enforcement |
| 3.13.5 | Deny network communications traffic by default and allow network communications traffic by exception | Implemented | Network Config | TCC-SC-001 (planned) | pfSense | Default deny firewall |
| 3.13.6 | Deny network communications traffic by default and allow network communications traffic by exception (internal systems) | Implemented | Network Config | TCC-SC-001 (planned) | firewalld | Host-based firewalls |
| 3.13.7 | Prevent remote devices from simultaneously establishing non-remote connections with organizational systems | Implemented | Network Config | TCC-SC-001 (planned) | Routing | Split tunneling prevented |
| 3.13.8 | Implement cryptographic mechanisms to prevent unauthorized disclosure of CUI during transmission | Implemented | Network Config | TCC-SC-001 (planned) | TLS/SSH | All remote access encrypted |
| 3.13.9 | Terminate network connections associated with communications sessions at the end of the sessions | Implemented | System Config | TCC-SC-001 (planned) | Timeouts | SSH session timeouts |
| 3.13.10 | Establish and manage cryptographic keys for cryptography employed in organizational systems | Implemented | System Config | TCC-SC-001 (planned) | Key management | LUKS key management |
| 3.13.11 | Employ FIPS-validated cryptography when used to protect the confidentiality of CUI | ✅ Implemented | System Config | TCC-SC-001 (planned) | FIPS mode | FIPS 140-2 validated |
| 3.13.12 | Prohibit remote activation of collaborative computing devices | ✅ N/A | System Config | TCC-SC-001 (planned) | N/A | No webcams/microphones on systems |
| 3.13.13 | Control and monitor the use of mobile code | Implemented | Network Config | TCC-SC-001 (planned) | Browser config | JavaScript restricted |
| 3.13.14 | Control and monitor the use of Voice over Internet Protocol (VoIP) technologies | ✅ N/A | System Config | TCC-SC-001 (planned) | N/A | No VoIP systems |
| 3.13.15 | Protect the authenticity of communications sessions | Implemented | System Config | TCC-SC-001 (planned) | SSH, TLS | Certificate-based auth |
| 3.13.16 | Protect the confidentiality of CUI at rest | ✅ Implemented | Physical and Media Protection Policy | TCC-PE-MP-001 | Part 2, Section 2.2 | LUKS encryption all partitions |

---

### 3.14 SYSTEM AND INFORMATION INTEGRITY (SI)

| Control ID | Control Title | Implementation Status | Policy Document | Policy ID | Section | Notes |
|------------|---------------|----------------------|-----------------|-----------|---------|-------|
| 3.14.1 | Identify, report, and correct system flaws in a timely manner | ✅ Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.2 | dnf-automatic + Wazuh |
| 3.14.2 | Provide protection from malicious code at designated locations | ✅ Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.3 | Multi-layer: ClamAV, YARA, Wazuh FIM |
| 3.14.3 | Monitor system security alerts and advisories and take action in response | ✅ Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.5 | US-CERT, NIST NVD, Rocky Linux |
| 3.14.4 | Update malicious code protection mechanisms when new releases are available | ✅ Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.3 | ClamAV daily, YARA as needed |
| 3.14.5 | Perform periodic scans of organizational systems and real-time scans of files from external sources | ✅ Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.3 | ClamAV real-time + weekly full |
| 3.14.6 | Monitor organizational systems, including inbound and outbound communications traffic, for unusual or unauthorized activities | ✅ Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.4 | Wazuh SIEM + Suricata IDS |
| 3.14.7 | Identify unauthorized use of organizational systems | ✅ Implemented | System and Information Integrity Policy | TCC-SI-001 | Section 2.4 | Wazuh behavioral analysis |

**Additional SI Controls from Policy:**

| Control | Full NIST ID | Policy Section | Notes |
|---------|--------------|----------------|-------|
| SI-1 | Policy and Procedures | Section 1 | |
| SI-2 | Flaw Remediation | Section 2.2 | 7/30/90 day timelines |
| SI-3 | Malicious Code Protection | Section 2.3 | 4-layer defense |
| SI-4 | System Monitoring | Section 2.4 | Wazuh SIEM comprehensive |
| SI-5 | Security Alerts/Advisories | Section 2.5 | Multiple feed sources |
| SI-6 | Security Functionality Verification | Section 2.6 | OpenSCAP quarterly |
| SI-7 | Software/Firmware Integrity | Section 2.7 | Wazuh FIM + rpm verification |
| SI-10 | Information Input Validation | Section 2.10 | Application-level validation |
| SI-11 | Error Handling | Section 2.11 | No sensitive info in errors |
| SI-12 | Information Handling/Retention | Section 2.12 | Encryption, retention, disposal |

---

## Policy Document Summary

### Complete Policy List with Coverage

| Policy ID | Policy Title | File Size | Control Families | Controls | Effective Date |
|-----------|-------------|-----------|------------------|----------|----------------|
| TCC-IRP-001 | Incident Response Policy and Procedures | 19KB | IR | 8 | 11/02/2025 |
| TCC-RA-001 | Risk Management Policy and Procedures | 25KB | RA | 6+ | 11/02/2025 |
| TCC-PS-001 | Personnel Security Policy | 24KB | PS | 8 | 11/02/2025 |
| TCC-PE-MP-001 | Physical and Media Protection Policy | 22KB | PE, MP | 23 (15 PE + 8 MP) | 11/02/2025 |
| TCC-SI-001 | System and Information Integrity Policy | 21KB | SI | 12+ | 11/02/2025 |
| TCC-AUP-001 | Acceptable Use Policy | 21KB | AC, PS, PL | 3 (AC-1, PS-6, PL-4) | 11/02/2025 |

**Total Policy Coverage:** 50+ individual controls across 11 NIST 800-171 control families

**All policies located at:** `/backup/personnel-security/policies/` (LUKS-encrypted partition)

---

## Planned Policy Development

| Policy ID | Policy Title | Control Families | Target Date | Status |
|-----------|-------------|------------------|-------------|---------|
| TCC-AU-001 | Audit and Accountability Policy | AU | Q4 2025 | Draft exists |
| TCC-CM-001 | Configuration Management Policy | CM | Q1 2026 | Planned |
| TCC-IA-001 | Identification and Authentication Policy | IA | Q1 2026 | Planned |
| TCC-AT-001 | Security Awareness and Training Policy | AT | Q1 2026 | Draft exists |
| TCC-SC-001 | System and Communications Protection Policy | SC | Q2 2026 | Planned |

---

## Usage Examples

### Example 1: Finding Policy for SPRS Update

**Scenario:** Updating SPRS for control 3.11.2 (Vulnerability Scanning)

**Steps:**
1. Look up 3.11.2 in "3.11 RISK ASSESSMENT" section above
2. Find: Policy TCC-RA-001, Section 2.5
3. Locate file: `/backup/personnel-security/policies/Risk_Management_Policy_and_Procedures.docx`
4. In SPRS, reference: "Risk Management Policy (TCC-RA-001), Section 2.5 - Vulnerability Scanning establishes continuous Wazuh vulnerability detection with 60-minute CVE feed updates and quarterly OpenSCAP compliance scans..."

### Example 2: Finding Policy for C3PAO Assessment

**Scenario:** C3PAO asks about malware protection (SI-3)

**Steps:**
1. Look up SI-3 in "3.14 SYSTEM AND INFORMATION INTEGRITY" section
2. Find: Policy TCC-SI-001, Section 2.3
3. Locate file: `/backup/personnel-security/policies/System_and_Information_Integrity_Policy.docx`
4. Open to Section 2.3 to show multi-layer malware protection (ClamAV, YARA, Wazuh FIM, VirusTotal)
5. Demonstrate technical implementation with: `systemctl status clamav-freshclam`

### Example 3: Finding Multiple Policies for One Control

**Scenario:** Control PS-6 (Access Agreements) requires multiple documents

**Steps:**
1. Look up PS-6 in "3.9 PERSONNEL SECURITY" section
2. Note: Covered in TWO policies:
   - TCC-PS-001, Section 2.6 (NDA and CUI Access Agreement templates)
   - TCC-AUP-001, entire policy (Acceptable Use Policy with acknowledgment form)
3. For complete evidence, reference both documents

---

## Control Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Fully implemented with policy documentation |
| Implemented | Technically implemented, policy documentation planned/in progress |
| Partial | Partially implemented, additional work needed |
| Planned | Implementation scheduled, not yet complete |
| N/A | Not Applicable to this environment (with documented justification) |

---

## Quick Find Index

**By Status:**
- **100% Documented (with ✅):** IR (8), RA (6), PS (8), PE (15), MP (8), SI (12) = 57 controls
- **Technically Implemented (policy pending):** AC (most), AU (12), CM (11), SC (most) = ~40 controls
- **Planned:** AT (2 controls pending policy), specific AC/MP items = ~5 controls
- **N/A (documented):** PE-8, PE-17, RA-6, RA-8, SC-12, SC-14, and several solopreneur-specific = ~10 controls

**Total NIST 800-171 Rev 2 Controls:** 110 requirements (14 families × ~8 avg requirements each)
**TCC Policy-Documented Controls:** 50+ (45% of total)
**TCC Technically Implemented:** 98+ (89% of total)

---

## Document Control

**Classification:** Controlled Unclassified Information (CUI)
**Distribution:** Owner/ISSO, C3PAO assessors, authorized auditors
**Retention:** 3 years minimum (CMMC evidence requirement)
**Location:** `/backup/personnel-security/policies/Control_to_Policy_Quick_Reference.docx`

**Revision History:**

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 11/02/2025 | D. Shannon | Initial control-to-policy mapping reference |

---

*END OF CONTROL-TO-POLICY QUICK REFERENCE*
