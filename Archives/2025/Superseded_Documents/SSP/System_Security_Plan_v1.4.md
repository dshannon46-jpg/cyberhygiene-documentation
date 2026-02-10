# SYSTEM SECURITY PLAN

## NIST SP 800-171 Rev 2 Compliance

**Donald E. Shannon LLC** **dba The Contract Coach** **System Name:**
CyberHygiene Production Network **Domain:** cyberinabox.net **Version
1.8** **Date:** December 17, 2025 **Classification:** CONFIDENTIAL BUSINESS INFORMATION

**Distribution Notice:** This document contains proprietary business information, trade secrets, and confidential system security details of Donald E. Shannon LLC. Unauthorized disclosure may cause competitive harm. Upon submission to U.S. Government agencies, this document shall be marked and protected as Controlled Unclassified Information (CUI) per 32 CFR Part 2002.

**Target Completion:** December 31, 2025

## DOCUMENT CONTROL

**Document Status:** DRAFT - Implementation Phase **Security
Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Distribution:** Limited to authorized personnel only

  ------------------------------------------------------------------------------------
  Name / Title             Role      Signature / Date
  ------------------------ --------- -------------------------------------------------
  Donald E.                System    \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_Date:
  ShannonOwner/Principal   Owner     \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

  Donald E.                ISSO      \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_Date:
  ShannonOwner/Principal             \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
  ------------------------------------------------------------------------------------

**Review Schedule:** Quarterly or upon significant system changes **Next
Review Date:** January 31, 2026

### Document Revision History

  --------------------------------------------------------------------------
  Version   Date             Author      Description
  --------- ---------------- ----------- -----------------------------------
  1.0       10/26/2025       D. Shannon  Initial SSP - Implementation Phase

  1.1       10/28/2025       D. Shannon  RAID 5 array rebuilt with
                                         FIPS-compliant LUKS encryption;
                                         GUI/console/SSH login banners
                                         implemented; ClamAV antivirus
                                         installed and configured; Samba
                                         share configured for CUI data

  1.2       10/28/2025       D. Shannon  Wazuh SIEM/XDR v4.9.2 deployed with
                                         vulnerability detection, file
                                         integrity monitoring, and security
                                         configuration assessment; Automated
                                         backup system implemented with ReaR
                                         for weekly full system backups and
                                         daily critical file backups;
                                         Implementation status increased to
                                         94%

  1.3       10/31/2025       D. Shannon  YARA 4.5.2 malware detection fully
                                         operational: Installed from source
                                         with FIPS-compatible OpenSSL 3.2.2;
                                         Deployed 25 malware detection rules
                                         (generic, Linux, Windows);
                                         Integrated with Wazuh active
                                         response for automated
                                         FIM-triggered scanning; Created 8
                                         custom Wazuh alert rules for
                                         malware severity levels;
                                         Successfully tested end-to-end
                                         detection with EICAR; POA&M-014
                                         advanced to 85% complete;
                                         Implementation status increased to
                                         96%

  **1.4**   **11/02/2025**   **D.        **Policy Documentation Package: - 6
                             Shannon**   comprehensive policy documents
                                         (TCC-IRP-001, TCC-RA-001,
                                         TCC-PS-001, TCC-PE-MP-001,
                                         TCC-SI-001, TCC-AUP-001) - 50+
                                         controls formally documented across
                                         11 families - All policies
                                         effective November 2, 2025**

                                         **Implementation Status: -
                                         Increased from 96% to 98% complete
                                         - All major control families now
                                         have policy documentation -
                                         Estimated SPRS score improvement:
                                         +90 to +110 points**

                                         **POA&M Updates: - 14
                                         policy-related items marked
                                         COMPLETED - 10 new items added for
                                         remaining implementation work -
                                         Clear timelines: Q4 2025 and Q1
                                         2026 targets**

                                         **Authorization: - Recommend full
                                         authorization effective January 1,
                                         2026 - 3-year authorization period
                                         through December 31, 2028 - Minimal
                                         residual risk with documented
                                         acceptance**

  **1.5**   **12/02/2025**   **D.        **Added Graylog centralized logging
                             Shannon**   deployment (POA&M-037). Updated AU
                                         controls (AU-2, AU-3, AU-6, AU-7,
                                         AU-9) and SI-4 to document log
                                         management infrastructure. Updated
                                         POA&M status: 30 items, 24 complete
                                         (80%). Added MongoDB 7.0.26,
                                         OpenSearch 2.19.4, Graylog 6.0.14,
                                         and rsyslog forwarding to system
                                         components. Implementation status:
                                         99% complete.**

  **1.6**   **12/06-07/2025** **D.       **Split certificate architecture
                             Shannon**   deployed. Resolved architectural
                                         conflict: IPA CA cert for FreeIPA
                                         services, SSL.com commercial cert
                                         for public websites. Eliminated
                                         browser warnings while maintaining
                                         FreeIPA stability. Automated
                                         compliance scanning infrastructure
                                         deployed. DC1 and Lab Rat
                                         configured with weekly OpenSCAP
                                         scans (DC1: Sundays 02:00, 99%
                                         compliance; Lab Rat: weekly upload
                                         to DC1, 100% compliance).
                                         Centralized report collection on
                                         DC1. Lab Rat workstation domain
                                         onboarding completed. Joined
                                         labrat.cyberinabox.net to FreeIPA
                                         domain. Created user donald.shannon
                                         (developer). Implemented AC-11
                                         session lock, AC-8 login banners.
                                         Enhanced CA-2, CA-7, SC-8, SC-13,
                                         and SC-17 controls.**

  **1.7**   **12/07/2025**   **D.        **Engineering and Accounting
                             Shannon**   workstations onboarded to FreeIPA
                                        domain. Both workstations
                                        (engineering.cyberinabox.net at
                                        192.168.1.104 and
                                        accounting.cyberinabox.net at
                                        192.168.1.113) successfully joined
                                        to cyberinabox.net domain with full
                                        NIST 800-171 security baseline:
                                        FIPS 140-2, SELinux enforcing,
                                        AC-11 session lock, AC-8 login
                                        banners, automated weekly OpenSCAP
                                        scanning. All three production
                                        workstations now operational with
                                        centralized compliance reporting to
                                        DC1. Workstation deployment: 100%
                                        complete (3 of 3). POA&M status
                                        updated to ~87% complete.**

  **1.8**   **12/17/2025**   **D.        **Project timeline updated with two
                             Shannon**   new strategic initiatives. POA&M
                                        items added: POA&M-040 (Local AI
                                        integration for automated system
                                        administration, Dec 2025 - Jan
                                        2026) and POA&M-041 (Project
                                        demonstration at NCMA Nexus
                                        conference, Atlanta GA, Feb 8-10,
                                        2026). AI architecture documented
                                        as air-gapped copilot providing
                                        guidance to system administrators
                                        via conversational interface, with
                                        no direct CUI infrastructure
                                        access. POA&M status: 88% complete
                                        (30/34 items). Website project
                                        timeline updated to reflect new
                                        milestones.**
  --------------------------------------------------------------------------

Note: File location on dc1,cyberinabox.net server is as follows:
/home/dshannon/Documents/Claude/Artifacts/System_Security_Plan_v1.6.docx
All 14 control family implementations - POA&M and implementation metrics
(99% baseline)

**Version 1.6 Update:** Lab Rat workstation (labrat.cyberinabox.net) fully onboarded
to FreeIPA domain with complete NIST 800-171 compliance implementation. Split certificate
architecture deployed to resolve FreeIPA PKI vs public web services conflict.

**Version 1.7 Update:** Engineering (engineering.cyberinabox.net) and Accounting
(accounting.cyberinabox.net) workstations successfully onboarded to FreeIPA domain.
All three production workstations now fully deployed with automated OpenSCAP compliance
scanning and centralized report collection.

## EXECUTIVE SUMMARY

### 1.1 Purpose

This System Security Plan (SSP) documents the security controls
implemented for The Contract Coach's production network environment that
processes, stores, and transmits Controlled Unclassified Information
(CUI) and Federal Contract Information (FCI). This SSP demonstrates
compliance with NIST SP 800-171 Rev 2 requirements as mandated by FAR
52.204-21 and supports Cybersecurity Maturity Model Certification (CMMC)
Level 1 and Level 2 certification readiness.

### 1.2 System Overview

The CyberHygiene Production Network (cyberinabox.net) is a
Microsoft-free, open-source infrastructure built on Rocky Linux 9.6 to
provide secure identity management, file storage, email services, and
client workstation management for The Contract Coach's government
contracting operations.

**Current Implementation Status:** **99% Complete** (as of December 2,
2025) **Target Completion Date:** December 31, 2025 **Compliance
Verification:** 100% OpenSCAP CUI Profile (105/105 checks passed on all
systems)

### 1.3 Compliance Requirements

**Primary Requirements:** - NIST SP 800-171 Rev 2 - Protecting CUI in
Nonfederal Systems - FIPS 140-2/140-3 - Cryptographic Module Validation
- FAR 52.204-21 - Basic Safeguarding of Covered Contractor Information
Systems - DFARS 252.204-7012 - Safeguarding Covered Defense Information
- CMMC Level 1 - Foundational cybersecurity practices (17 practices) -
CMMC Level 2 - Advanced cybersecurity practices (110 practices)

**Supporting Standards:** - NIST SP 800-53 Rev 5 - Security and Privacy
Controls - NIST SP 800-171A - Assessing Security Requirements for CUI -
CIS Controls - Center for Internet Security Benchmarks

### 1.4 Key Findings

**Strengths:** - FIPS 140-2 cryptographic validation active on all
systems (server + 3 workstations) - 100% compliance verified via
OpenSCAP automated scanning on all systems - Three production
workstations fully deployed and hardened - ✓ Lab Rat workstation domain-joined with full FreeIPA integration (December 6, 2025) - Strong authentication via
Kerberos SSO (FreeIPA) - Comprehensive audit logging to dedicated
encrypted partitions - Automatic security patching configured and
operational - 5.5TB encrypted RAID 5 storage array operational - Network
segmentation via firewall with IDS/IPS capability - Centralized logging
infrastructure operational - ✓ Wazuh Security Platform (SIEM/XDR)
operational for threat detection - ✓ Automated vulnerability scanning
with hourly feed updates - ✓ File Integrity Monitoring on all critical
system files - ✓ Security Configuration Assessment (CIS benchmarks)
automated - ✓ Automated backup system with daily and weekly schedules -
✓ Full system recovery capability via bootable ISO images - ✓ Bare-metal
disaster recovery tested and operational - ✓ Multi-layered malware
protection architecture deployed (NEW) - ✓ YARA 4.5.2 malware detection
fully integrated with Wazuh (NEW) - ✓ 25 custom YARA rules deployed
(generic, Linux, Windows malware) (NEW) - ✓ Automated malware scanning
on file integrity monitoring events (NEW) - ✓ 8 custom Wazuh alert rules
for malware severity classification (NEW) - ✓ End-to-end malware
detection pipeline tested and operational (NEW) - ✓ Cloud-based
multi-engine scanning ready (VirusTotal) (NEW) - ✓ Automated ClamAV
1.5.x FIPS version monitoring active (NEW)

**Areas Requiring Completion (see POA&M Section 10):** - Email server
deployment (Postfix/Dovecot with encryption) - Multi-factor
authentication configuration - Formal incident response procedures
documentation - Security awareness training program - File sharing
capability (alternative solution in progress) - ClamAV 1.5.x
FIPS-compatible deployment (awaiting EPEL release)

### 1.5 Authorization

This system is authorized to operate in a production environment for
processing CUI and FCI under the authority of Donald E. Shannon, System
Owner, pending completion of remaining security controls by December 31,
2025.

**Conditional Authorization Granted:** October 26, 2025 **Authorization
Termination Date:** December 31, 2025 (pending full implementation)
**Full Authorization Target:** January 1, 2026 **Current Progress:** 95%
complete

## 2. SYSTEM IDENTIFICATION

### 2.1 System Information

**System Name:** CyberHygiene Production Network **System Acronym:** CPN
**System Owner:** Donald E. Shannon LLC dba The Contract Coach **System
Type:** General Support System (GSS) **Operational Status:**
Implementation Phase (95% Complete)

### 2.2 Organization Information

**Legal Entity:** Donald E. Shannon LLC\
**Doing Business As:** The Contract Coach\
**CAGE Code:** 5QHR9\
**DUNS Number:** 832123793\
**NAICS Codes:** 541611, 541613, 541690\
**Business Location:** Albuquerque, New Mexico

### 2.3 Contact Information

**System Owner / ISSO:** Name: Donald E. Shannon Title: Owner/Principal
Email: Don\@Contractcoach.com Phone: 505.259.8485 Security Clearance:
Active DoD Top Secret

### 2.4 System Categorization

Based on FIPS 199 Standards for Security Categorization:

**Information Type:** Federal Contract Information (FCI) / Controlled
Unclassified Information (CUI)\
**Confidentiality:** MODERATE\
**Integrity:** MODERATE\
**Availability:** LOW\
**Overall System Categorization:** MODERATE

**Rationale:** The system processes and stores government contract
information, proposals, cost/pricing data, and other sensitive business
information that requires protection from unauthorized disclosure
(Confidentiality) and modification (Integrity). Loss of availability
would impact business operations but not result in significant harm to
government interests.

## 3. SYSTEM DESCRIPTION

### 3.1 System Purpose and Functions

The CyberHygiene Production Network provides secure information
technology infrastructure for The Contract Coach's government
contracting business operations.

**Primary Functions:** - Centralized identity and access management
(FreeIPA/LDAP/Kerberos) - Security monitoring and threat detection
(Wazuh SIEM/XDR) - Multi-layered malware protection (YARA + VirusTotal +
ClamAV) (ENHANCED) - Vulnerability management and scanning - File
integrity monitoring and alerting - Automated backup and disaster
recovery - Secure file storage and sharing - Email communications with
encryption (planned) - Client workstation management and authentication
- Document management for proposals and contracts - Security audit
logging and compliance reporting - Certificate management via internal
PKI

**Business Processes Supported:** - Proposal development and submission
- Contract management and administration - Project management
documentation - Cost estimating and pricing - Client communications -
Business development activities - Records retention and compliance

### 3.2 General System Description

**Architecture:** Client-server architecture with centralized services\
**Operating System:** Rocky Linux 9.6 (Blue Onyx) - RHEL binary
compatible\
**Security Posture:** FIPS 140-2 validated, OpenSCAP hardened, SELinux
enforcing\
**Network:** Internal LAN (192.168.1.0/24) behind pfSense
firewall/router

A diagram of a network AI-generated content may be incorrect.

A diagram of a network AI-generated content may be incorrect.

A diagram of a network AI-generated content may be incorrect.

**Core Components:**

#### 1. Domain Controller (dc1.cyberinabox.net - 192.168.1.10)

-   FreeIPA identity management server
-   LDAP directory services (389-ds)
-   Kerberos authentication (KDC)
-   Certificate Authority (Dogtag PKI)
-   **Split Certificate Architecture (December 7, 2025):**
    -   IPA CA Certificate: `/var/lib/ipa/certs/httpd.crt` (FreeIPA services only)
    -   Commercial SSL.com Certificate: `/etc/pki/tls/certs/commercial/wildcard.crt` (public websites)
    -   Purpose: Separate cert management for internal PKI vs public web services
-   DNS services (BIND)
-   NTP time synchronization
-   Centralized logging server (rsyslog)
-   Centralized OpenSCAP compliance report collection (/var/log/openscap/collected-reports)
-   Automated weekly OpenSCAP scans via cron (Sundays 02:00), reports stored locally
-   Encrypted RAID 5 storage (5.5TB)
-   Graylog Centralized Log Management v6.0.14:
    -   Graylog Server (log processing and web UI)
    -   MongoDB 7.0.26 (metadata storage)
    -   OpenSearch 2.19.4 (log indexing and storage)
    -   rsyslog forwarding (UDP port 1514)
    -   Web interface (http://dc1.cyberinabox.net:9000)
    -   Full-text search across all system logs
    -   Dashboard visualization and alerting
    -   Integration with Wazuh for unified visibility
-   Wazuh Security Platform v4.9.2:
    -   Wazuh Manager (security monitoring)
    -   Wazuh Indexer (data storage/search)
    -   Filebeat (log shipper)
    -   Vulnerability detection module
    -   File Integrity Monitoring (FIM)
    -   Security Configuration Assessment (SCA)
    -   Real-time intrusion detection
    -   Automated threat intelligence
-   Multi-Layer Malware Protection:
    -   YARA 4.5.2 - Pattern-based detection (operational)
    -   VirusTotal Integration - Cloud multi-engine scanning (ready)
    -   ClamAV 1.5.x - FIPS-compliant signature scanning (planned
        Dec 2025)

#### 2. Network Security (192.168.1.1)

-   Netgate 2100 pfSense firewall/router
-   Stateful packet inspection
-   IDS/IPS capability (Suricata - planned)
-   VPN capability (planned)
-   Network segmentation ready

#### 3. Client Workstations (DEPLOYED)

**LabRat (HP MicroServer Gen10+ - 192.168.1.115):**
- Primary User: donald.shannon (Developer)
- Role: Development workstation with CUI/FCI access
- OS: Rocky Linux 9.6 Workstation with GUI
- Domain: Joined to cyberinabox.net (December 6, 2025)
- FreeIPA Integration: Full LDAP/Kerberos authentication via SSSD
- Group Memberships: developers, cui_authorized, file_share_rw, remote_access
- FIPS 140-2: Enabled and verified
- SELinux: Enforcing mode
- Encryption: Full disk encryption (LUKS)
- OpenSCAP: 100% compliant with NIST 800-171 CUI profile
- Session Lock: 15-minute idle timeout (AC-11) via dconf policy
- Login Banners: AC-8 compliant banners for console (/etc/issue) and post-login (/etc/motd)
- Compliance Scanning: Automated weekly OpenSCAP scans via cron, reports uploaded to DC1:/var/log/openscap/collected-reports
- Network: Interface eno1, DNS via DC1 (192.168.1.10)

**Engineering (192.168.1.104):**
- Primary Role: Engineering workstation for technical work
- OS: Rocky Linux 9.6 Workstation with GUI
- Domain: Joined to cyberinabox.net (December 7, 2025)
- FreeIPA Integration: Full LDAP/Kerberos authentication via SSSD
- Suggested Groups: engineering, cui_authorized, file_share_rw, remote_access
- FIPS 140-2: Enabled and verified
- SELinux: Enforcing mode
- Encryption: Full disk encryption (LUKS)
- OpenSCAP: 100% compliant with NIST 800-171 CUI profile
- Session Lock: 15-minute idle timeout (AC-11) via dconf policy
- Login Banners: AC-8 compliant banners for console (/etc/issue) and post-login (/etc/motd)
- Compliance Scanning: Automated weekly OpenSCAP scans (Sundays 03:00), reports collected by DC1
- Network: DNS via DC1 (192.168.1.10)

**Accounting (192.168.1.113):**
- Primary Role: Accounting/financial operations workstation
- OS: Rocky Linux 9.6 Workstation with GUI
- Domain: Joined to cyberinabox.net (December 7, 2025)
- FreeIPA Integration: Full LDAP/Kerberos authentication via SSSD
- Suggested Groups: operations, cui_authorized, file_share_rw
- FIPS 140-2: Enabled and verified
- SELinux: Enforcing mode
- Encryption: Full disk encryption (LUKS)
- OpenSCAP: 100% compliant with NIST 800-171 CUI profile
- Session Lock: 15-minute idle timeout (AC-11) via dconf policy
- Login Banners: AC-8 compliant banners for console (/etc/issue) and post-login (/etc/motd)
- Compliance Scanning: Automated weekly OpenSCAP scans (Sundays 03:00), reports collected by DC1
- Network: DNS via DC1 (192.168.1.10)

#### 4. Email Server (planned - mail.cyberinabox.net)

-   Postfix SMTP with TLS enforcement
-   Dovecot IMAP/POP3 with encryption
-   Anti-spam (Rspamd) and anti-virus (ClamAV)
-   SPF, DKIM, DMARC implementation
-   Webmail interface (Roundcube/SOGo)

### 3.3 Network Topology

    Internet (96.72.6.225)
        ↓
    Netgate 2100 pfSense (192.168.1.1)
        ↓
    Internal Switch
        ├── dc1.cyberinabox.net (192.168.1.10) - Domain Controller + Wazuh + Malware Defense
        ├── labrat.cyberinabox.net (192.168.1.115) - Developer Workstation (donald.shannon) ✓ DOMAIN-JOINED
        ├── engineering.cyberinabox.net (192.168.1.104) - Engineering Workstation ✓ DOMAIN-JOINED
        ├── accounting.cyberinabox.net (192.168.1.113) - Accounting Workstation ✓ DOMAIN-JOINED
        └── mail.cyberinabox.net (planned) - Email Server

### 3.4 FreeIPA User Accounts

**Active Users:**

**donald.shannon** - Developer
- Employee ID: User-created December 6, 2025
- Primary Workstation: labrat.cyberinabox.net
- Group Memberships:
  - developers (organizational role)
  - cui_authorized (CUI data access)
  - file_share_rw (read/write file access)
  - remote_access (VPN access when deployed)
- Home Directory: /home/donald.shannon
- Shell: /bin/bash
- Password Policy: NIST 800-171 compliant (14+ chars, 90-day expiration)
- Kerberos Principal: donald.shannon@CYBERINABOX.NET
- Authentication: Kerberos SSO + SSSD integration

**admin** - System Administrator
- FreeIPA administrative account
- Full domain administrative privileges
- Used for system configuration and user management

### 3.5 Certificate Management Architecture

**Implementation Date:** December 7, 2025
**Purpose:** Resolve architectural conflict between FreeIPA PKI and public web services

#### Split Certificate Design

The system implements a **split certificate architecture** to support both internal FreeIPA operations and public-facing web services:

**IPA CA Certificate (Internal PKI)**
- **Location:** `/var/lib/ipa/certs/httpd.crt`
- **Issuer:** CN=Certificate Authority, O=CYBERINABOX.NET
- **Purpose:** FreeIPA web UI and internal PKI operations
- **Services:**
  - FreeIPA web UI (https://dc1.cyberinabox.net/ipa/ui/)
  - Client enrollment (`ipa-client-install`)
  - Kerberos ticket operations
  - Certificate issuance
  - Trust relationship establishment
- **Critical Requirement:** Must NEVER be replaced with commercial certificate
- **Rationale:** FreeIPA clients validate against IPA CA during enrollment; commercial cert breaks PKI trust chain

**Commercial SSL.com Certificate (Public Services)**
- **Location:** `/etc/pki/tls/certs/commercial/wildcard.crt`
- **Issuer:** SSL.com RSA SSL subCA
- **Type:** Wildcard certificate for *.cyberinabox.net
- **Expiration:** October 28, 2026
- **Purpose:** Public-facing web services
- **Services:**
  - Main website (https://cyberinabox.net/)
  - Webmail (https://webmail.cyberinabox.net/)
  - Project management (https://projects.cyberinabox.net/)
- **Benefit:** Eliminates browser certificate warnings for public users
- **Chain File:** `/etc/pki/tls/certs/commercial/chain.pem`
- **Private Key:** `/etc/pki/tls/private/commercial/wildcard.key` (600 permissions)

#### Historical Context

**Problem Identified:** November-December 2025
- Single certificate (`httpd.crt`) used for incompatible purposes
- Installing commercial cert → broke FreeIPA client enrollment
- Reverting to IPA cert → caused browser warnings on public sites
- "Whack-a-mole" cycle of fixes breaking other functionality

**Root Cause:** Architectural conflict
- FreeIPA requires IPA CA-signed certificate for PKI operations
- Public websites require publicly-trusted CA for browser acceptance
- Single certificate cannot satisfy both requirements

**Solution Implemented:** December 7, 2025
- Separated certificates by purpose
- IPA CA cert remains stable at `/var/lib/ipa/certs/httpd.crt`
- Commercial cert deployed to `/etc/pki/tls/certs/commercial/`
- Updated Apache VirtualHost configurations accordingly

#### Operational Procedures

**Certificate Renewal (Commercial Certificate)**

When SSL.com wildcard certificate expires (October 2026):

1. Obtain renewed certificate from SSL.com
2. Backup existing certificate files
3. Install new certificate to `/etc/pki/tls/certs/commercial/`
4. Update chain file if needed
5. Test Apache configuration: `sudo httpd -t`
6. Restart Apache: `sudo systemctl restart httpd`
7. Verify all public websites: cyberinabox.net, webmail, projects
8. **DO NOT touch `/var/lib/ipa/certs/httpd.crt`**

**IPA CA Certificate Management**

- IPA CA certificate is managed automatically by FreeIPA
- Certificate tracked via `getcert list`
- Auto-renewal handled by certmonger
- **CRITICAL:** Never manually replace this certificate
- If issues arise, use `getcert resubmit` to restore IPA CA cert

#### Security Controls Satisfied

- **SC-8 (Transmission Confidentiality):** All services use TLS encryption
- **SC-13 (Cryptographic Protection):** Certificates use strong cryptography (RSA 2048+)
- **SC-17 (Public Key Infrastructure Certificates):** Dual PKI architecture for internal and external trust

#### Compliance Impact

✅ **Resolved Issues:**
- FreeIPA client enrollment works reliably
- Public websites show no browser warnings
- Professional appearance maintained
- Certificate management procedures clarified

✅ **Prevented Future Issues:**
- Clear separation of certificate purposes
- Documented operational constraints
- Eliminated "fix one, break another" cycle

### 3.6 Malware Protection Architecture

The system employs a defense-in-depth malware protection strategy with
multiple detection layers:

    ┌─────────────────────────────────────────────────────────────┐
    │              Multi-Layer Malware Protection                 │
    ├─────────────────────────────────────────────────────────────┤
    │                                                             │
    │  Layer 1: YARA Pattern Detection (OPERATIONAL ✓)           │
    │  ├─ Version: 4.5.2 (built from source with OpenSSL 3.2.2) │
    │  ├─ Rules: 25 custom signatures (7 generic, 9 Linux, 9 Windows) │
    │  ├─ Integration: Wazuh Active Response (FIM rules 550, 554) │
    │  ├─ Alerting: 8 custom Wazuh rules (100100-100111)        │
    │  ├─ Testing: EICAR detection verified end-to-end          │
    │  └─ Status: Fully operational - October 31, 2025          │
    │                                                             │
    │  Layer 2: VirusTotal Cloud Scanning (READY 🔄)             │
    │  ├─ Engines: 70+ antivirus scanners                        │
    │  ├─ Integration: Wazuh FIM triggers                        │
    │  ├─ API: Free tier (500 requests/day)                      │
    │  └─ Status: Documented, awaiting deployment                │
    │                                                             │
    │  Layer 3: ClamAV 1.5.x FIPS (PLANNED ⏳)                   │
    │  ├─ Version: 1.5.x (FIPS 140-2 compatible)                 │
    │  ├─ Database: Signed verification (.cvd.sign)              │
    │  ├─ Monitoring: Automated weekly EPEL checks               │
    │  └─ Target: December 2025                                  │
    │                                                             │
    │  Layer 4: Wazuh SIEM Correlation (OPERATIONAL ✓)           │
    │  ├─ Centralizes all detection events                       │
    │  ├─ Automated alerting and response                        │
    │  └─ Cross-layer threat intelligence                        │
    │                                                             │
    │  Layer 5: Network IDS/IPS (PLANNED ⏳)                     │
    │  ├─ Suricata on pfSense gateway                            │
    │  └─ Target: December 2025                                  │
    │                                                             │
    └─────────────────────────────────────────────────────────────┘

**FIPS Compliance:** - YARA: Uses OpenSSL 3.2.2 (FIPS-approved
cryptography) - VirusTotal: HTTPS/TLS transport (FIPS-compatible) -
ClamAV 1.5.x: Native FIPS 140-2 support (planned)

## 4. SECURITY CONTROL IMPLEMENTATION

This section documents the implementation status of all NIST SP 800-171
security requirements. Each control family is assessed with
implementation details, compliance evidence, and assessment results.

**Control Status Legend:** - **IMPLEMENTED** - Control is fully
operational and verified - **ENHANCED** - Control exceeds baseline
requirements - **PLANNED** - Control design complete, implementation in
progress - **N/A** - Control not applicable to this system

### 4.1 Access Control (AC)

  ----------------------------------------------------------------------------------------
  Control   Control Name     Status        Implementation           Assessment
  ID                                                                
  --------- ---------------- ------------- ------------------------ ----------------------
  3.1.1     Limit system     IMPLEMENTED   FreeIPA provides         Verified via FreeIPA
            access to                      centralized              user database and SSH
            authorized users               authentication. All user configuration audit
                                           accounts managed via     
                                           LDAP. SSH keys enforced. 

  3.1.2     Limit system     IMPLEMENTED   Role-based access        Verified via sudo
            access to                      control via FreeIPA      configuration and
            authorized                     groups and sudo rules.   SELinux policy audit
            functions                      SELinux enforcing        
                                           mandatory access         
                                           controls.                

  3.1.3     Control flow of  IMPLEMENTED   Network segmentation via Verified via firewall
            CUI                            firewall. TLS/SSH        rules, encryption
                                           encryption for data in   verification, network
                                           transit. LUKS encryption traffic analysis
                                           at rest.                 

  3.1.4     Separation of    N/A           Single-person            Documented in
            duties                         organization. Separation operational procedures
                                           enforced via audit       
                                           logging and external     
                                           review processes.        

  3.1.5     Employ principle IMPLEMENTED   Standard users have no   Verified via user
            of least                       administrative access.   permission audit and
            privilege                      Sudo elevation required  sudo logs
                                           for privileged           
                                           operations. Logged.      

  3.1.6     Use              IMPLEMENTED   Administrative tasks     Verified via SSH
            non-privileged                 require sudo elevation.  configuration and
            accounts                       No direct root login via authentication logs
                                           SSH. All activities      
                                           logged.                  

  3.1.7     Prevent          IMPLEMENTED   SELinux enforcing        Verified via SELinux
            non-privileged                 prevents privilege       audit and sudo
            users from                     escalation. Sudo         configuration
            executing                      configuration restricts  
            privileged                     command execution.       
            functions                                               

  3.1.8     Limit            IMPLEMENTED   PAM faillock: 5 failed   Verified via OpenSCAP
            unsuccessful                   attempts trigger         scan (100% pass) and
            logon attempts                 30-minute lockout.       PAM configuration
                                           Configured via OpenSCAP. 

  3.1.9     Provide privacy  IMPLEMENTED   Login banners configured Verified via
            and security                   on SSH and console.      /etc/issue and
            notices                        Users acknowledge        /etc/ssh/sshd_config.
                                           acceptable use policy.   Lab Rat: Console banner
                                           CUI/FCI warnings         at /etc/issue, post-login
                                           displayed at login.      message at /etc/motd.   

  3.1.10    Use session lock IMPLEMENTED   Automatic screen lock    Verified on all
            with                           after 15 minutes idle.   workstations via user
            pattern-hiding                 Password required to     session configuration.
            displays                       unlock. Configured via   Lab Rat: dconf policy
                                           GNOME dconf policy       at
                                           (workstations) and       /etc/dconf/db/local.d/00-screensaver
                                           system-wide settings.    with locked settings.            

  3.1.11    Terminate user   IMPLEMENTED   SSH sessions timeout     Verified via SSH
            session after                  after 15 minutes idle    configuration and user
            defined period                 (ClientAliveInterval).   session policies
                                           GUI sessions lock        
                                           automatically.           

  3.1.12    Monitor and      IMPLEMENTED   SSH access logged to     Verified via
            control remote                 centralized rsyslog.     authentication logs
            access sessions                Failed attempts trigger  and firewall rules
                                           alerts. No               
                                           unauthenticated access.  

  3.1.13    Employ           IMPLEMENTED   SSH with strong ciphers  Verified via SSH and
            cryptographic                  only (FIPS 140-2). TLS   TLS configuration
            mechanisms to                  1.2+ for HTTPS. No       audits
            protect remote                 legacy protocols.        
            access                                                  

  3.1.14    Route remote     IMPLEMENTED   All remote access        Verified via firewall
            access via                     through pfSense          configuration
            managed access                 firewall. SSH on         
            control points                 non-standard port. VPN   
                                           planned for future.      

  3.1.15    Authorize remote IMPLEMENTED   SSH requires             Verified via SSH
            access prior to                authentication via       configuration and
            allowing                       FreeIPA. Public key      access logs
            connections                    authentication enforced. 
                                           No anonymous access.     

  3.1.16    Authorize        N/A           No wireless access       Physical inspection
            wireless access                points in system         confirmed no wireless
            prior to                       boundary. All            APs
            allowing                       connections wired.       
            connections                                             

  3.1.17    Protect wireless N/A           No wireless access       N/A
            access using                   points in system         
            authentication                 boundary.                
            and encryption                                          

  3.1.18    Control          PLANNED       USB device restrictions  Implementation
            connection of                  via USBGuard planned for scheduled - see POA&M
            mobile devices                 December 2025. Mobile    
                                           devices prohibited from  
                                           processing CUI.          

  3.1.19    Encrypt CUI on   IMPLEMENTED   All laptops/mobile       Verified via
            mobile devices                 devices have full disk   cryptsetup status on
                                           encryption (LUKS). FIPS  all systems
                                           140-2 validated          
                                           cryptography.            

  3.1.20    Control use of   PLANNED       USBGuard implementation  Implementation
            portable storage               planned for December     scheduled - see POA&M
            devices                        2025 to restrict         
                                           unauthorized USB         
                                           devices.                 

  3.1.21    Limit use of     IMPLEMENTED   Policy prohibits use of  Documented in
            portable storage               organizational USB       acceptable use policy
            devices on                     devices on               
            external systems               non-organizational       
                                           systems. User training   
                                           required.                

  3.1.22    Control CUI      IMPLEMENTED   CUI prohibited from      Verified via system
            posted or                      public-facing systems.   inventory and data
            processed on                   No CUI on websites or    classification
            publicly                       public repositories.     procedures
            accessible                     Policy enforced.         
            systems                                                 
  ----------------------------------------------------------------------------------------

### 4.2 Awareness and Training (AT)

  --------------------------------------------------------------------------
  Control   Control Name      Status    Implementation          Assessment
  ID                                                            
  --------- ----------------- --------- ----------------------- ------------
  3.2.1     Ensure managers,  PLANNED   Formal security         Training
            systems                     awareness training      program
            administrators,             program to be           scheduled -
            and users are               implemented by December see POA&M
            trained                     2025. Owner has         
                                        extensive security      
                                        training.               

  3.2.2     Provide security  PLANNED   Annual security         Training
            awareness                   awareness training      program
            training on                 planned including       scheduled -
            recognizing and             phishing, social        see POA&M
            reporting threats           engineering, and        
                                        incident reporting.     

  3.2.3     Provide security  PLANNED   Initial training before Training
            training before             CUI access and annual   program
            access, when                refresher training to   scheduled -
            required, and               be implemented.         see POA&M
            annually                                            
  --------------------------------------------------------------------------

### 4.3 Audit and Accountability (AU)

**Status:** All AU controls are **IMPLEMENTED**. The system maintains
comprehensive audit logs on dedicated encrypted partitions, with
centralized logging operational for all systems. Audit records include
timestamps, user identification, event types, and outcomes. Logs are
protected from unauthorized access and retained per policy.

**AU-2 (Auditable Events):** All system logs are centralized in Graylog 6.0.14 for unified searchable storage. rsyslog forwards logs from all system components including:
- System logs (journald)
- FreeIPA authentication and authorization events
- Wazuh security alerts and FIM events
- Linux audit logs (auditd)
- Application logs (email, web servers, NextCloud)

Graylog provides:
- Real-time log ingestion via syslog (UDP 1514)
- Full-text search across all log sources
- Long-term retention (30+ days minimum for NIST compliance)
- Dashboard visualization
- Alert capabilities for security events

Configuration: /etc/rsyslog.d/90-graylog.conf forwards all logs to 127.0.0.1:1514

**AU-3 (Content of Audit Records):** Graylog preserves all original audit record content including timestamps, source identifiers, event types, outcomes, and user identities. OpenSearch provides indexed storage for rapid search and retrieval.

**AU-6 (Audit Review, Analysis, and Reporting):** Graylog Web UI (http://dc1.cyberinabox.net:9000) provides centralized audit review capabilities with:
- Advanced search and filtering
- Dashboard visualization
- Alert configuration for security events
- Integration with Wazuh SIEM for correlation

ISSO reviews security-relevant events daily via Graylog interface. Wazuh provides automated audit review via analytics engine, real-time correlation, and automated alerting on security-relevant events.

**AU-7 (Audit Reduction and Report Generation):** Graylog provides audit reduction through:
- Full-text search with regex support
- Field-based filtering and aggregation
- Dashboard creation for recurring reports
- Export capabilities (CSV, JSON)

This enables ISSO to rapidly analyze large volumes of audit data. Wazuh Indexer enables advanced log aggregation, filtering, and reporting capabilities with historical analysis.

**AU-9 (Protection of Audit Information):** Graylog audit log storage:
- OpenSearch data directory: /var/lib/opensearch (root-owned, 700 permissions)
- MongoDB metadata: /var/lib/mongo (mongod user ownership)
- Access restricted to root and service accounts
- Web UI access restricted to admin account with strong password
- Backend services (MongoDB, OpenSearch) bound to localhost only (no network exposure)

### 4.4 Configuration Management (CM)

**Status:** All CM controls are **IMPLEMENTED**. Configuration baselines
established via OpenSCAP. Automated compliance scanning ensures systems
maintain approved configurations. Changes are documented and tracked.
Security-relevant software updates applied automatically via
dnf-automatic.

**ENHANCEMENTS:** - **CM-6 (Configuration Settings):** Wazuh Security
Configuration Assessment (SCA) provides continuous compliance
verification against CIS Rocky Linux 9 Benchmark, automated deviation
detection, and policy-based configuration enforcement

### 4.5 Identification and Authentication (IA)

**Status:** All IA controls are **IMPLEMENTED** except MFA (planned).
FreeIPA provides centralized authentication with strong password
policies (14+ characters, complexity requirements, 90-day expiration).
Kerberos SSO reduces password exposure. Multi-factor authentication
implementation planned for December 2025.

### 4.6 Incident Response (IR)

**Status:** IR controls are **PARTIALLY IMPLEMENTED**. Logging
infrastructure operational for incident detection. Wazuh SIEM provides
real-time intrusion detection and automated incident response
capabilities. Formal incident response plan documentation scheduled for
December 2025.

### 4.7 Maintenance (MA)

**Status:** All MA controls are **IMPLEMENTED**. Maintenance activities
are logged and tracked. Security patches applied automatically via
dnf-automatic. Maintenance tools are controlled and logged.

### 4.8 Media Protection (MP)

**Status:** All MP controls are **IMPLEMENTED**. Media sanitization
procedures documented. All storage encrypted via LUKS. Media disposal
follows NIST SP 800-88 guidelines.

### 4.9 Physical Protection (PE)

**Status:** All PE controls are **IMPLEMENTED**. Physical access
controls in place. Facility is secured with locks and alarm system.
Visitor access controlled.

### 4.10 Personnel Security (PS)

**Status:** All PS controls are **IMPLEMENTED**. Background
investigations conducted. Personnel termination procedures documented.
System owner maintains active DoD Top Secret clearance.

### 4.11 Risk Assessment (RA)

**Status:** All RA controls are **IMPLEMENTED**.

**Key Implementation:**

**RA-5 (Vulnerability Scanning):** - **Status:** IMPLEMENTED -
**Implementation:** Wazuh vulnerability detection module operational -
Automated vulnerability feeds updated every 60 minutes - Integration
with CVE databases and vendor advisories - Agent-based scanning of
installed packages - Continuous monitoring vs. periodic scanning -
Real-time vulnerability alerts - Automated patch correlation -
**Assessment:** Verified via Wazuh Manager logs and operational status

### 4.12 Security Assessment (CA)

**Status:** All CA controls are **IMPLEMENTED**. OpenSCAP automated
scanning provides continuous compliance verification. Security
assessments documented and tracked.

**Key Implementation:**

**CA-2 (Security Assessments):** - **Status:** IMPLEMENTED -
**Implementation:** Automated OpenSCAP compliance scanning on all systems
- **Scan Profile:** xccdf_org.ssgproject.content_profile_cui (NIST 800-171 CUI profile)
- **Scan Frequency:** Weekly automated scans via cron
- **DC1 Configuration:** Weekly scans Sunday 02:00, reports stored in /var/log/openscap/collected-reports/dc1/ (December 6, 2025)
- **Lab Rat Configuration:** Weekly scans, reports uploaded to DC1:/var/log/openscap/collected-reports/labrat/ (December 6, 2025)
- **Centralized Reporting:** All scan results collected on DC1 for unified compliance review
- **Report Format:** XML results, HTML reports, and automated remediation scripts
- **DC1 Baseline:** 99% compliance (103/104 rules pass, 1 acceptable deviation)
- **Lab Rat Baseline:** 100% compliance verified
- **Review Process:** ISSO reviews collected reports weekly for compliance verification
- **Remediation:** Automated remediation scripts generated for any non-compliant findings
- **Assessment:** Verified via scan results, cron configuration, and centralized report collection

**CA-7 (Continuous Monitoring):** - Wazuh SIEM provides real-time security monitoring
- OpenSCAP provides weekly compliance verification - Graylog aggregates all
audit logs for analysis - Combined approach ensures both security events and
compliance posture are continuously monitored

### 4.13 System and Communications Protection (SC)

**Status:** All SC controls are **IMPLEMENTED**. Network segmentation
operational. Encryption enforced for all communications. Firewall
provides boundary protection. FIPS 140-2 cryptography validated.

### 4.14 System and Information Integrity (SI)

**Status:** All SI controls are **IMPLEMENTED** with **ENHANCED**
capabilities for malware protection.

**Key Implementations:**

**SI-3 (Malicious Code Protection):** ⭐ **ENHANCED** - **Status:**
IMPLEMENTED (Multi-Layer Defense) - **Implementation:** Defense-in-depth
malware protection strategy

**Layer 1: YARA 4.5.2 (Fully Operational - October 31, 2025)** -
Pattern-based malware detection using custom signatures - Built from
source with FIPS-compatible OpenSSL 3.2.2 - Features: Magic file type
detection, Cuckoo integration, Protobuf support - Rules: 25 custom
signatures (7 generic, 9 Linux-specific, 9 Windows-specific) -
Integration: Wazuh active response triggered by FIM events (rules 550,
554) - Alerting: 8 custom Wazuh rules (100100-100111) for severity
classification - Scripts: Python integration (`yara-integration.py`) +
Bash wrapper (`yara-scan.sh`) - Logging: Structured JSON output to
`/var/log/yara.log` - Testing: End-to-end EICAR detection verified and
operational - Installation: `/usr/local/bin/yara` and
`/usr/local/lib/libyara.so.10.0.0`

**Layer 2: VirusTotal Integration (Ready for Deployment)** - Cloud-based
multi-engine scanning (70+ antivirus engines) - Integration via Wazuh
File Integrity Monitoring triggers - API-based scanning with reputation
analysis - Free tier: 500 requests/day (monitored for adequacy) -
Documentation: Complete integration guide prepared

**Layer 3: ClamAV 1.5.x FIPS-Compatible (Planned - December 2025)** -
Signature-based antivirus with FIPS 140-2 support - Database
verification using signed .cvd.sign files - Automated monitoring for
EPEL release (weekly checks via cron) - Source build guide prepared as
fallback option - Estimated deployment: December 10-23, 2025

**Compensating Controls (Active Until ClamAV 1.5.x):** - YARA provides
immediate pattern-based detection - VirusTotal provides cloud-based
multi-engine verification - Wazuh FIM detects unauthorized file
modifications - Network IDS/IPS (Suricata) blocks malicious network
traffic

-   **Assessment:**
    -   YARA: ✅ Operational with end-to-end testing completed
        -   Version check: 4.5.2 with OpenSSL 3.2.2 (FIPS-compatible)
        -   EICAR detection: Verified via active response pipeline
        -   Wazuh integration: Alert generation confirmed (rule 100110)
        -   File locations:
            -   Rules: `/var/ossec/ruleset/yara/rules/*.yar`
            -   Scripts:
                `/var/ossec/ruleset/yara/scripts/yara-integration.py`
            -   Active Response:
                `/var/ossec/active-response/bin/yara-scan.sh`
            -   Wazuh Rules: `/var/ossec/etc/rules/local_rules.xml`
                (rules 100100-100111)
            -   Configuration: `/var/ossec/etc/ossec.conf` (command +
                active-response + localfile)
    -   VirusTotal: Integration guide verified, ready for API key
        deployment
    -   ClamAV monitoring: Weekly cron job operational
        (`/home/dshannon/bin/check-clamav-version.sh`)
    -   Documentation: 8 comprehensive guides created (\~160 KB total)

**SI-4 (System Monitoring):** - **Status:** IMPLEMENTED (Enhanced) -
**Implementation:** System monitoring is provided through integrated tools:
- **Wazuh SIEM 4.9.2:** Real-time security event detection, FIM, vulnerability scanning, compliance assessment
- **Graylog 6.0.14:** Centralized log management and search
- **Suricata IDS/IPS:** Network threat detection (pfSense)
- **Auditd:** System call auditing with OSPP v42 rules

Wazuh forwards security alerts to Graylog for unified visibility. ISSO monitors both Wazuh alerts and Graylog dashboards for security events. Real-time log analysis from all systems (journald, syslog, application logs) provides comprehensive security monitoring. Intrusion detection via correlation rules and threat intelligence, anomaly detection and behavioral analysis, centralized event visibility across all systems, automated alerting on security events, integration with vulnerability scanning, file integrity monitoring correlation, and malware detection event correlation across all layers. - **Assessment:** Verified via Wazuh Manager and Graylog operational status and alert verification

**SI-7 (Software, Firmware, and Information Integrity):** - **Status:**
IMPLEMENTED - **Implementation:** Wazuh File Integrity Monitoring (FIM)
- Real-time change detection on critical files and directories -
Cryptographic checksums (SHA256) of all monitored files - Alert
generation on unauthorized changes - Baseline integrity database
maintained and synchronized - Monitored paths: /etc, /usr/bin,
/usr/sbin, /bin, /sbin, /boot - Scan frequency: Every 12 hours with
real-time monitoring - Change reporting with file diffs for analysis -
**Integration with YARA for malware scanning on file changes** -
**Assessment:** Verified via Wazuh FIM configuration, baseline database,
and operational logs

**SI-2 (Flaw Remediation):** - **Status:** IMPLEMENTED -
**Implementation:** Automated security updates via dnf-automatic with
Wazuh correlation - **Assessment:** Verified via update logs and Wazuh
vulnerability scanning

## 5. CONTINGENCY PLANNING (CP)

### CP-9 (System Backup)

**Status:** **IMPLEMENTED** (Completed 10/28/2025)

**Implementation:** Multi-tier automated backup strategy

**Daily Critical Files Backup:** - Script:
`/usr/local/bin/backup-critical-files.sh` - Target:
`/backup/daily/YYYYMMDD-HHMMSS/` - Retention: 30 days - Systemd timer:
Daily at 2:00 AM (randomized 30min delay) - Scope: FreeIPA configs, CA
certificates, LUKS keys, system configs, SSH keys, Wazuh configuration -
Encryption: FIPS-compliant (LUKS encrypted partition) - Verification:
SHA256 checksums generated for all archives

**Weekly Full System Backup:** - Tool: ReaR (Relax-and-Recover) -
Script: `/usr/local/bin/backup-full-system.sh` - Target:
`/srv/samba/backups/` (RAID 5 encrypted) - Retention: 4 weeks - Systemd
timer: Weekly Sunday at 3:00 AM (randomized 1hr delay) - Format:
Bootable ISO image + full backup tar.gz - Size: \~890MB (ISO), variable
(backup data) - Capability: Bare-metal system recovery

**Assessment:** Verified via successful backup execution, backup file
creation, and systemd timer status

### CP-10 (System Recovery and Reconstitution)

**Status:** **IMPLEMENTED** (Completed 10/28/2025)

**Implementation:** ReaR bootable ISO enables bare-metal recovery

**Recovery Capabilities:** - Full system restoration from bootable ISO -
Automatic hardware detection and adaptation - LUKS encryption recreation
with key restoration - RAID array reconstruction - Network configuration
restoration - All data and configurations restored

**Recovery Objectives:** - Recovery Time Objective (RTO): \< 4 hours -
Recovery Point Objective (RPO): 24 hours (daily backup) - Recovery Test
Status: ISO creation verified, restore testing pending

**Assessment:** ISO successfully created and bootable verified; full
restore test scheduled for December 2025

## 6. SECURITY POLICIES AND PROCEDURES

### 6.1 Policy Framework

The organization maintains a comprehensive set of security policies
aligned with NIST 800-171 requirements. These policies are documented
and available in the organizational policy repository
(`/home/dshannon/Documents/Claude/Policies/`).

**Implemented Policies:**

1.  **Cyber Policies and Procedures**
    (`Gmail - Cyber Policies and Procedures.pdf`)
    -   Overall cybersecurity governance framework
    -   Roles and responsibilities
    -   Security awareness requirements
    -   Incident reporting procedures
2.  **Personnel Security Policy**
    (`Gmail - Personne Security Policy.pdf`)
    -   Background investigation requirements
    -   Access authorization procedures
    -   Personnel termination processes
    -   Security training requirements
3.  **Physical and Media Protection Policy**
    (`Gmail - PS Physical and Media Protection Policy.pdf`)
    -   Physical access control requirements
    -   Media handling and sanitization
    -   Equipment disposal procedures
    -   Visitor management
4.  **System and Information Integrity Policy**
    (`Gmail - System and Information Integrity Policy.pdf`)
    -   Malware protection requirements (SI-3)
    -   Vulnerability management (SI-2, RA-5)
    -   System monitoring requirements (SI-4)
    -   Software integrity verification (SI-7)
    -   Flaw remediation procedures

### 6.2 Malware Protection Policy (SI-3)

**Policy Statement:** The organization employs malicious code protection
mechanisms at information system entry and exit points to detect and
eradicate malicious code.

**Implementation:** - Multi-layered malware detection (YARA + VirusTotal
+ ClamAV 1.5.x) - Real-time file scanning on creation and modification -
Automated signature and pattern database updates - Centralized alert
management via Wazuh SIEM - Incident response procedures for malware
detections - User awareness training on malware threats

**Responsibilities:** - System Owner/ISSO: Overall policy enforcement
and compliance verification - Security Monitoring: Wazuh SIEM automated
detection and alerting - Users: Report suspicious files and behaviors
immediately

**Compliance:** Satisfies NIST 800-171 3.14.1, 3.14.2, 3.14.3 and CMMC
Level 2 SI.3.217

## 10. PLAN OF ACTION & MILESTONES (POA&M)

**Organization:** The Contract Coach **System:** CyberHygiene Production
Network (cyberinabox.net) **Date:** December 2, 2025 **Version:** 1.5
**Classification:** Controlled Unclassified Information (CUI)

## POA&M Summary

**Total Items:** 30 **Completed:** 24 (80%) **In Progress:** 2 (7%) **On
Track:** 4 (13%) **Planned:** 0 (0%)

**Latest Completion:** POA&M-037 - Centralized log management (Graylog) deployed on 12/02/2025

**High Priority Items:** 3 **Medium Priority Items:** 7 **Low Priority
Items:** 1

## Section 1: COMPLETED POA&M Items

Items completed as of November 2, 2025:

  ----------------------------------------------------------------------------------------------------
  POA&M ID    Weakness/Deficiency   NIST Controls Completion     Evidence                 Status
                                                  Date                                    
  ----------- --------------------- ------------- -------------- ------------------------ ------------
  POA&M-003   Backup system not     CP-9, CP-10   10/28/2025     ReaR backup system       ✅ COMPLETED
              implemented                                        operational with weekly  
                                                                 full backups and daily   
                                                                 incremental backups.     
                                                                 Documented in            
                                                                 Backup_Procedures.docx   

  POA&M-008   IDS/IPS not           SI-4          10/28/2025     Wazuh SIEM v4.9.2        ✅ COMPLETED
              operational on                                     deployed with Suricata   (Exceeded)
              firewall                                           integration on pfSense.  
                                                                 Real-time monitoring and 
                                                                 alerting operational.    

  POA&M-009   File integrity        SI-7          10/28/2025     Wazuh FIM operational    ✅ COMPLETED
              monitoring not                                     with 12-hour scan        
              deployed                                           intervals on critical    
                                                                 paths (/etc, /boot,      
                                                                 /var/ossec, /srv/samba)  

  POA&M-015   Incident Response     IR-1, IR-4,   11/02/2025     Incident Response Policy ✅ COMPLETED
              Policy not documented IR-6, IR-8                   and Procedures           
                                                                 (TCC-IRP-001) approved   
                                                                 and effective            

  POA&M-016   Incident Response     IR-2, IR-3,   11/02/2025     Complete IR procedures   ✅ COMPLETED
              Procedures not        IR-4, IR-5,                  documented in            
              documented            IR-6, IR-7,                  TCC-IRP-001, Section 2   
                                    IR-8                                                  

  POA&M-017   Personnel screening   PS-3          11/02/2025     Personnel Security       ✅ COMPLETED
              not documented                                     Policy (TCC-PS-001,      
                                                                 Section 2.3) documents   
                                                                 TS clearance exceeding   
                                                                 CUI requirements         

  POA&M-018   Personnel Security    PS-1, PS-2,   11/02/2025     Personnel Security       ✅ COMPLETED
              Policy not developed  PS-4, PS-5,                  Policy (TCC-PS-001)      
                                    PS-6, PS-7,                  approved and effective   
                                    PS-8                                                  

  POA&M-019   Physical security     PE-1 through  11/02/2025     Physical and Media       ✅ COMPLETED
              controls not          PE-20                        Protection Policy        
              documented                                         (TCC-PE-MP-001, Part 1)  
                                                                 approved                 

  POA&M-020   Media protection      MP-1 through  11/02/2025     Physical and Media       ✅ COMPLETED
              procedures not        MP-8                         Protection Policy        
              developed                                          (TCC-PE-MP-001, Part 2)  
                                                                 approved                 

  POA&M-021   Media sanitization    MP-6          11/02/2025     Media sanitization       ✅ COMPLETED
              not documented                                     procedures documented in 
                                                                 TCC-PE-MP-001, Section   
                                                                 2.6 (LUKS erase, shred)  

  POA&M-022   Risk Assessment       RA-1, RA-2,   11/02/2025     Risk Management Policy   ✅ COMPLETED
              Policy not developed  RA-3, RA-7                   and Procedures           
                                                                 (TCC-RA-001) approved    
                                                                 and effective            

  POA&M-023   Vulnerability         RA-5          11/02/2025     Vulnerability management ✅ COMPLETED
              scanning not                                       documented in            
              documented                                         TCC-RA-001, Section 2.5  
                                                                 (Wazuh continuous        
                                                                 scanning, OpenSCAP       
                                                                 quarterly)               

  POA&M-024   System Integrity      SI-1, SI-2,   11/02/2025     System and Information   ✅ COMPLETED
              Policy not developed  SI-4, SI-5,                  Integrity Policy         
                                    SI-6, SI-7,                  (TCC-SI-001) approved    
                                    SI-10, SI-11,                and effective            
                                    SI-12                                                 

  POA&M-025   Malware protection    SI-3          11/02/2025     Multi-layer malware      ✅ COMPLETED
              not documented                                     protection documented in 
                                                                 TCC-SI-001, Section 2.3  
                                                                 (ClamAV, YARA, Wazuh     
                                                                 FIM, VirusTotal)         

  POA&M-026   Acceptable Use Policy AC-1, PS-6,   11/02/2025     Acceptable Use Policy    ✅ COMPLETED
              not developed         PL-4                         (TCC-AUP-001) approved   
                                                                 and effective            

  POA&M-027   Risk Management       RA-3, RA-5,   11/02/2025     Complete risk management ✅ COMPLETED
              Framework not         RA-7                         framework in TCC-RA-001
              established                                        with NIST SP 800-30
                                                                 methodology

  POA&M-037   Centralized log       AU-2, AU-3,   12/02/2025     Graylog 6.0.14          ✅ COMPLETED
              management not        AU-6, AU-7,                  operational at
              deployed              AU-9                         http://dc1.cyberinabox.net:9000;
                                                                 MongoDB 7.0.26 and
                                                                 OpenSearch 2.19.4
                                                                 installed and running;
                                                                 rsyslog forwarding
                                                                 configured; all system
                                                                 logs centralized and
                                                                 searchable; FIPS
                                                                 compatibility via system
                                                                 Java workaround
  ----------------------------------------------------------------------------------------------------

## Section 2: IN PROGRESS POA&M Items

Items currently being worked on:

  ---------------------------------------------------------------------------------------------------------------------------
  POA&M ID    Weakness/Deficiency   NIST       Resources       Target Date  Priority   Milestone/Task   Status      POC
                                    Controls   Required                                                             
  ----------- --------------------- ---------- --------------- ------------ ---------- ---------------- ----------- ---------
  POA&M-014   Malware protection    SI-3       Multi-layered   12/31/2025   High       **Phase 1        85%         Shannon
              not fully                        malware defense                         Complete         COMPLETE    
              FIPS-compliant                   deployment                              (85%):** YARA                
                                                                                       4.5.2 + Wazuh                
                                                                                       integrated                   
                                                                                       10/31**Phase 2               
                                                                                       Remaining                    
                                                                                       (15%):** ClamAV              
                                                                                       1.5.x FIPS                   
                                                                                       version                      
                                                                                       deployment and               
                                                                                       VirusTotal API               
                                                                                       integration                  

  POA&M-005   Formal Incident       IR-3       Tabletop        06/30/2026   High       Annual IR        SCHEDULED   Shannon
              Response testing not             exercise                                tabletop                     
              conducted                        planning and                            exercise                     
                                               execution                               scheduled June               
                                                                                       2026 per                     
                                                                                       TCC-IRP-001.                 
                                                                                       Exercise                     
                                                                                       scenario                     
                                                                                       development in               
                                                                                       Q1 2026.                     
  ---------------------------------------------------------------------------------------------------------------------------

## Section 3: ON TRACK POA&M Items

Items on schedule for completion:

  -------------------------------------------------------------------------------------------------------------------------
  POA&M ID    Weakness/Deficiency   NIST       Resources        Target Date  Priority   Milestone/Task   Status   POC
                                    Controls   Required                                                           
  ----------- --------------------- ---------- ---------------- ------------ ---------- ---------------- -------- ---------
  POA&M-001   File sharing not      AC-3,      NFS/Kerberos or  12/15/2025   High       1\. Research     ON TRACK Shannon
              operational due to    AC-6, AU-2 NextCloud                                alternatives2.            
              Samba FIPS                       evaluation and                           Select                    
              compatibility issue              implementation                           solution3.                
                                                                                        Deploy4. Test5.           
                                                                                        Document                  

  POA&M-002   Email server not      SC-8,      Postfix,         12/20/2025   Medium     1\. Install      ON TRACK Shannon
              deployed              SC-13,     Dovecot, Rspamd,                         packages2.                
                                    SI-3       ClamAV                                   Configure LDAP            
                                               installation and                         auth3. Enable             
                                               configuration                            encryption4.              
                                                                                        Test delivery5.           
                                                                                        Document                  

  POA&M-004   Multi-factor          IA-2(1),   FreeIPA OTP or   12/22/2025   Medium     1\. Configure    ON TRACK Shannon
              authentication not    IA-2(2)    RADIUS                                   OTP2. Test with           
              configured                       integration                              users3. Document          
                                                                                        procedures4.              
                                                                                        Deploy to all             
                                                                                        systems                   

  POA&M-006   Security awareness    AT-2, AT-3 Training         12/10/2025   Medium     1\. Select       ON TRACK Shannon
              training program not             materials and                            training                  
              implemented                      delivery method                          provider2.                
                                                                                        Schedule annual           
                                                                                        training3.                
                                                                                        Document                  
                                                                                        completion4.              
                                                                                        Establish                 
                                                                                        renewal cycle             

  POA&M-007   USB device            AC-19,     USBGuard         03/31/2026   Medium     1\. Install      ON TRACK Shannon
              restrictions not      AC-20      installation and                         USBGuard2.                
              enforced                         configuration                            Create                    
                                                                                        whitelist3. Test          
                                                                                        restrictions4.            
                                                                                        Deploy to all             
                                                                                        systems                   

  POA&M-010   Commercial SSL        SC-8,      Contact SSL.com  12/31/2025   Medium     1\. Request cert ON TRACK Shannon
              certificate needs     SC-13      for certificate                          with wildcard or          
              reissue with proper              reissue                                  multiple SANs2.           
              SANs                                                                      Install when              
                                                                                        received3.                
                                                                                        Verify all                
                                                                                        services                  

  POA&M-011   System Security Plan  CA-2       Establish review 12/31/2025   Medium     1\. Create       ON TRACK Shannon
              requires quarterly               schedule and                             review                    
              review process                   checklist                                procedures2.              
                                                                                        Schedule first            
                                                                                        quarterly review          
                                                                                        (Jan 2026)3.              
                                                                                        Document process          

  POA&M-012   Disaster recovery     CP-4       Schedule and     12/28/2025   High       1\. Develop test ON TRACK Shannon
              testing not performed            conduct DR test                          plan2. Execute            
                                                                                        test3. Document           
                                                                                        lessons                   
                                                                                        learned4. Update          
                                                                                        procedures                
  -------------------------------------------------------------------------------------------------------------------------

## Section 4: PLANNED POA&M Items

Items scheduled for future implementation:

  ------------------------------------------------------------------------------------------------------------------------------------
  POA&M ID    Weakness/Deficiency   NIST Controls   Resources Required    Target Date  Priority   Milestone/Task   Status    POC
  ----------- --------------------- --------------- --------------------- ------------ ---------- ---------------- --------- ---------
  POA&M-013   Wazuh Dashboard       SI-4            Deploy Dashboard on   01/15/2026   Low        Optional         PLANNED   Shannon
              deployment for        (enhancement)   separate non-FIPS VM                          enhancement -              
              centralized                                                                         core monitoring            
              visibility (Optional)                                                               functional                 
                                                                                                  without it.                
                                                                                                  Would provide              
                                                                                                  improved                   
                                                                                                  visualization.             

  POA&M-028   VPN with MFA for      AC-17, IA-2(1)  VPN software          03/31/2026   High       1\. Select VPN   PLANNED   Shannon
              remote access not                     (OpenVPN/WireGuard)                           solution2.                 
              deployed                              with MFA integration                          Configure with             
                                                                                                  FreeIPA + MFA3.            
                                                                                                  Test                       
                                                                                                  connections4.              
                                                                                                  Document                   
                                                                                                  procedures5.               
                                                                                                  Deploy                     
  ------------------------------------------------------------------------------------------------------------------------------------

## Section 5: NEW POA&M Items (Added November 2, 2025)

Items identified from policy implementation review:

  --------------------------------------------------------------------------------------------------------------------------
  POA&M ID    Weakness/Deficiency   NIST       Resources       Target Date  Priority   Milestone/Task     Status   POC
                                    Controls   Required                                                            
  ----------- --------------------- ---------- --------------- ------------ ---------- ------------------ -------- ---------
  POA&M-029   Session lock not      AC-11      GNOME/system    12/15/2025   High       1\. Configure      NEW      Shannon
              configured (15 min               settings                                15-min auto-lock            
              timeout)                         configuration                           on all                      
                                                                                       workstations2.              
                                                                                       Test                        
                                                                                       functionality3.             
                                                                                       Verify via                  
                                                                                       screenshot4.                
                                                                                       Document in config          
                                                                                       baseline                    

  POA&M-030   Audit &               AU-1       Policy          12/20/2025   High       1\. Draft AU       NEW      Shannon
              Accountability Policy through    development and                         policy using                
              not developed         AU-12      approval                                existing auditd             
                                                                                       config as                   
                                                                                       baseline2. Review           
                                                                                       and approve3.               
                                                                                       Update SSP4. Store          
                                                                                       in policy                   
                                                                                       directory                   

  POA&M-031   Configuration         CM-1       Policy          03/31/2026   Medium     1\. Draft CM       NEW      Shannon
              Management Policy not through    development and                         policy2. Document           
              developed             CM-11      approval                                baseline                    
                                                                                       configurations3.            
                                                                                       Review and                  
                                                                                       approve4. Update            
                                                                                       SSP                         

  POA&M-032   Security Awareness    AT-1       Policy          03/31/2026   Medium     1\. Draft AT       NEW      Shannon
              and Training Policy   through    development and                         policy2. Integrate          
              not developed         AT-4       approval                                with AUP3. Review           
                                                                                       and approve4.               
                                                                                       Update SSP                  

  POA&M-033   Identification and    IA-1       Policy          03/31/2026   Medium     1\. Draft IA       NEW      Shannon
              Authentication Policy through    development and                         policy using                
              not developed         IA-11      approval                                FreeIPA as                  
                                                                                       baseline2.                  
                                                                                       Document password           
                                                                                       policies3. Review           
                                                                                       and approve4.               
                                                                                       Update SSP                  

  POA&M-034   Login banners not     AC-8       Banner          12/15/2025   Low        1\. Create banner  NEW      Shannon
              implemented on all               configuration                           text files2.                
              systems                          files                                   Configure                   
                                                                                       /etc/issue,                 
                                                                                       /etc/motd, SSH              
                                                                                       banner3. Verify on          
                                                                                       all systems4.               
                                                                                       Document                    

  POA&M-035   First annual risk     RA-3       Risk assessment 01/31/2026   High       1\. Use risk       NEW      Shannon
              assessment not                   execution per                           register template           
              conducted                        TCC-RA-001                              from TCC-RA-0012.           
                                                                                       Assess all CPN              
                                                                                       systems3. Document          
                                                                                       findings4. Update           
                                                                                       POA&M with                  
                                                                                       identified risks            
  --------------------------------------------------------------------------------------------------------------------------

## POA&M Metrics

### By Status

-   **Completed:** 16 items (57%)
-   **In Progress:** 2 items (7%)
-   **On Track:** 8 items (29%)
-   **Planned:** 2 items (7%)

### By Priority

-   **High:** 8 items (3 completed, 2 in progress, 2 on track, 1
    planned)
-   **Medium:** 10 items (13 completed as part of policy work)
-   **Low:** 2 items

### By Target Date

-   **Q4 2025 (Oct-Dec):** 10 items
-   **Q1 2026 (Jan-Mar):** 8 items
-   **Q2 2026 (Apr-Jun):** 1 item

### By Control Family

-   **Access Control (AC):** 5 items
-   **Awareness & Training (AT):** 3 items
-   **Audit & Accountability (AU):** 1 item
-   **Security Assessment & Authorization (CA):** 1 item
-   **Configuration Management (CM):** 1 item
-   **Contingency Planning (CP):** 2 items
-   **Identification & Authentication (IA):** 3 items
-   **Incident Response (IR):** 2 items (1 completed, 1 scheduled)
-   **Media Protection (MP):** 2 items (completed)
-   **Physical & Environmental Protection (PE):** 1 item (completed)
-   **Personnel Security (PS):** 2 items (completed)
-   **Risk Assessment (RA):** 4 items (3 completed, 1 new)
-   **System & Communications Protection (SC):** 2 items
-   **System & Information Integrity (SI):** 5 items (3 completed, 1 in
    progress, 1 on track)

## Completion Trend

  -----------------------------------------------------------------------
  Date              Total Items       Completed         \% Complete
  ----------------- ----------------- ----------------- -----------------
  10/26/2025        14                0                 0%

  10/28/2025        14                3                 21%

  10/31/2025        14                3                 21% (POA&M-014
                                                        advanced to 85%)

  11/02/2025        28                16                57%

  Projected         28                24+               85%+
  12/31/2025                                            

  Projected         28                27+               96%+
  03/31/2026                                            
  -----------------------------------------------------------------------

## Risk Summary

### High Risk Items (Requiring Immediate Attention)

1.  **POA&M-001:** File sharing not operational (impacts AC-3, AC-6,
    AU-2)
2.  **POA&M-012:** Disaster recovery not tested (impacts CP-4)
3.  **POA&M-029:** Session lock not configured (impacts AC-11)
4.  **POA&M-030:** AU policy not developed (impacts AU family)
5.  **POA&M-035:** First annual risk assessment (impacts RA-3)

### Medium Risk Items

Most medium risk items are on track for completion by Q1 2026.

### Low Risk Items

-   **POA&M-013:** Optional Wazuh Dashboard (enhancement only)
-   **POA&M-034:** Login banners (low security impact)

## Notes

### Evidence Storage

All completed POA&M items have evidence stored in: - **Policies:**
`/backup/personnel-security/policies/` - **Technical Documentation:**
`/home/dshannon/Documents/Claude/Artifacts/` - **Configuration Files:**
System configuration directories - **Compliance Reports:**
`/backup/compliance-scans/`

### Review Schedule

-   **Quarterly POA&M Review:** January, April, July, October
-   **Next Review:** January 31, 2026
-   **POA&M Owner:** Donald E. Shannon, ISSO

### Completion Criteria

POA&M items are marked complete when: 1. Technical control is
implemented and operational 2. Evidence is documented and stored 3.
Testing/verification is complete 4. SSP is updated to reflect
implementation 5. ISSO reviews and approves completion

### Integration with SSP

This POA&M is Section 10 of the System Security Plan Version 1.4. All
referenced policies and controls are documented in the SSP.

## Document Control

**Classification:** Controlled Unclassified Information (CUI) **Owner:**
Donald E. Shannon, ISSO **Distribution:** Owner/ISSO, Authorized
Auditors, C3PAO Assessors **Location:**
`/home/dshannon/Documents/Claude/Artifacts/Unified_POAM.docx` **Next
Update:** January 31, 2026 (Quarterly Review)

**Revision History:**

  ------------------------------------------------------------------------
  Version           Date         Author          Description
  ----------------- ------------ --------------- -------------------------
  1.0               10/26/2025   D. Shannon      Initial POA&M with 14
                                                 items

  1.1               10/28/2025   D. Shannon      Marked POA&M-003, 008,
                                                 009 complete

  1.2               10/31/2025   D. Shannon      POA&M-014 advanced to 85%

  1.3               11/02/2025   D. Shannon      Unified POA&M: Marked 13
                                                 policy items complete,
                                                 added 8 new items,
                                                 restructured into 5
                                                 sections
  ------------------------------------------------------------------------

*END OF UNIFIED POA&M*

## 11. IMPLEMENTATION METRICS

### Control Implementation Status - UPDATED

**Overall Implementation Status:** **99% Complete** (as of December 2,
2025)

#### By Control Family

  --------------------------------------------------------------------------------------------------
  Family   Family Name      Total      Implemented   Partially     Planned   Not          \%
                            Controls                 Implemented             Applicable   Complete
  -------- ---------------- ---------- ------------- ------------- --------- ------------ ----------
  AC       Access Control   22         20            1 (MFA)       0         1            95%

  AT       Awareness &      4          2             2             0         0            50%
           Training                                                                       

  AU       Audit &          12         12            0             0         0            100%
           Accountability                                                                 

  CA       Security         9          9             0             0         0            100%
           Assessment                                                                     

  CM       Configuration    11         11            0             0         0            100%
           Mgmt                                                                           

  CP       Contingency      4          4             0             0         0            100%
           Planning                                                                       

  IA       Identification & 11         10            1 (MFA)       0         0            91%
           Auth                                                                           

  **IR**   **Incident       **8**      **8**         **0**         **0**     **0**        **100%** ✅
           Response**                                                                     

  MA       Maintenance      6          6             0             0         0            100%

  **MP**   **Media          **8**      **8**         **0**         **0**     **0**        **100%** ✅
           Protection**                                                                   

  **PE**   **Physical       **20**     **15**        **0**         **0**     **5**        **100%** ✅
           Protection**                                                                   

  **PS**   **Personnel      **8**      **8**         **0**         **0**     **0**        **100%** ✅
           Security**                                                                     

  **RA**   **Risk           **6**      **6**         **0**         **0**     **0**        **100%** ✅
           Assessment**                                                                   

  SC       System & Comm    35         34            1 (email)     0         0            97%
           Protection                                                                     

  **SI**   **System & Info  **12**     **12**        **0**         **0**     **0**        **100%** ✅
           Integrity**                                                                    
  --------------------------------------------------------------------------------------------------

**Legend:** ✅ = Policy documented as of November 2, 2025

#### Policy Documentation Completion

  ------------------------------------------------------------------------
  Policy             Status     Effective    Controls Covered
                                Date         
  ------------------ ---------- ------------ -----------------------------
  Incident Response  ✅ Complete 11/02/2025   IR-1 through IR-8 (8
                                             controls)

  Risk Management    ✅ Complete 11/02/2025   RA-1 through RA-9 (6+
                                             controls)

  Personnel Security ✅ Complete 11/02/2025   PS-1 through PS-8 (8
                                             controls)

  Physical & Media   ✅ Complete 11/02/2025   PE-1 through PE-20, MP-1
  Protection                                 through MP-8 (23 controls)

  System &           ✅ Complete 11/02/2025   SI-1 through SI-12 (12
  Information                                controls)
  Integrity                                  

  Acceptable Use     ✅ Complete 11/02/2025   AC-1, PS-6, PL-4 (3 controls)
  (AC/PS/PL)                                 

  Audit &            🔄 In       Q4 2025      AU-1 through AU-12 (12
  Accountability     Progress                controls)

  Configuration      🔄 Planned  Q1 2026      CM-1 through CM-11 (11
  Management                                 controls)

  Awareness &        🔄 In       Q1 2026      AT-1 through AT-4 (4
  Training           Progress                controls)

  Identification &   🔄 Planned  Q1 2026      IA-1 through IA-11 (11
  Authentication                             controls)
  ------------------------------------------------------------------------

**Total Policy Coverage:** 54+ controls across 11 families with
comprehensive documentation

## COMPLIANCE IMPACT SUMMARY

### SPRS Score Improvement

**Previous Status:** Many controls marked "Planned" or "Not Met"
**Current Status:** Policy documentation provides evidence for
"Implemented" status

**Estimated Score Impact:** - Incident Response (IR): +21 points (8
basic + derived requirements) - Risk Assessment (RA): +15 points (6
basic + derived requirements) - Personnel Security (PS): +18 points (8
controls, many previously incomplete) - Physical Protection (PE): +12
points (implemented controls + justified N/A) - Media Protection (MP):
+15 points (comprehensive protection with encryption) - System Integrity
(SI): +24 points (significant technical implementation) - Access Control
(AC): +6 points (policy and user agreements)

**Total Estimated Impact: +90 to +110 points**

### CMMC Level 2 Readiness

**Practice Maturity:** - ✅ **Level 1:** Performed - Technical controls
implemented - ✅ **Level 2:** Documented - Policies and procedures
established - ✅ **Level 2:** Managed - Review schedules and metrics
defined - 🔄 **Level 2:** Reviewed - First annual reviews scheduled for
2026

**Assessment Evidence Package:** - 7 approved policy documents (DOCX
format, signed) - Policy Documentation Summary (executive overview) -
Interactive HTML Policy Index (navigation aid) - OpenSCAP compliance
reports (100% CUI profile) - Wazuh monitoring dashboards (continuous
monitoring evidence) - Backup verification logs (contingency planning
evidence) - Top Secret clearance documentation (personnel security
evidence)

**Assessment Readiness:** **HIGH** - Comprehensive documentation package
ready for C3PAO assessment

## 12. CONCLUSION

The CyberHygiene Production Network represents a robust, NIST 800-171
compliant infrastructure designed specifically for protecting Controlled
Unclassified Information. With **99% of controls currently implemented
and operational**, the system is well-positioned to achieve full
compliance by the target date of December 31, 2025.

### Key Accomplishments

**December 6-7, 2025 Achievements:**

- **Split Certificate Architecture Deployed:** Resolved critical architectural conflict between FreeIPA internal PKI and public web services. Implemented dual-certificate design: IPA CA certificate for FreeIPA operations (stable, never changes), SSL.com commercial certificate for public websites (eliminates browser warnings). Updated Apache VirtualHost configurations for cyberinabox.net, webmail.cyberinabox.net, and projects.cyberinabox.net. Enhanced SC-8, SC-13, and SC-17 security controls. Eliminated "whack-a-mole" cycle of fixes breaking other functionality.

- **Automated Compliance Scanning Infrastructure:** Deployed automated weekly OpenSCAP compliance scanning on DC1 and Lab Rat workstation (CA-2, CA-7 controls). DC1 scans run Sundays at 02:00 with 99% compliance baseline (103/104 rules). Lab Rat scans with reports pulled to centralized collection point via SSH. Combined with Wazuh SIEM and Graylog, provides comprehensive continuous monitoring of both security events and compliance posture.

- **Lab Rat Workstation Domain Onboarding:** Successfully joined labrat.cyberinabox.net to FreeIPA domain with full NIST 800-171 compliance. Created user donald.shannon (developer) with appropriate group memberships (developers, cui_authorized, file_share_rw, remote_access). Implemented AC-11 session lock (15-minute timeout) via dconf policy with locked settings. Configured AC-8 login banners for CUI/FCI warnings. Verified FIPS 140-2 mode, SELinux enforcing, full disk encryption. First production developer workstation fully operational.

**December 2, 2025 Major Achievement:** - **Centralized Log Management:** Graylog 6.0.14 deployed with MongoDB 7.0.26 and OpenSearch 2.19.4 for unified searchable log storage across all systems. Full integration with Wazuh SIEM for correlated visibility. All AU controls enhanced with centralized logging capabilities.

**October 31, 2025 Major Achievement:** - **Multi-Layered Malware
Protection:** YARA 4.5.2 pattern detection deployed and operational with
FIPS-compatible cryptography, VirusTotal cloud scanning ready for
deployment, and ClamAV 1.5.x FIPS-compatible solution planned with
automated monitoring

**October 28, 2025 Achievements:** - Wazuh Security Platform v4.9.2
deployed with full SIEM/XDR capabilities - Automated backup system
operational with daily and weekly schedules - File Integrity Monitoring
active on all critical systems - Vulnerability detection scanning with
continuous updates - Security Configuration Assessment against CIS
benchmarks - Bare-metal disaster recovery capability established

**Foundation Strengths:** - Full FIPS 140-2 validation across all
systems - Comprehensive audit logging with centralized analysis - Strong
authentication via Kerberos with SSO - Automatic security patching with
vulnerability correlation - Three fully-hardened workstations in
production - Defense-in-depth security architecture

### Remaining Tasks

Remaining tasks are clearly defined in the POA&M with realistic
timelines and adequate resources: - Multi-layered malware protection
completion (POA&M-014: 75% complete, on track) - Email server deployment
- Multi-factor authentication - Formal incident response procedures -
Security awareness training - USB device controls

All items are currently on track with no significant risks or delays
anticipated. The organization is committed to completing these items on
schedule and maintaining ongoing compliance through quarterly reviews
and continuous monitoring.

## AUTHORIZATION UPDATE

### Authorization Status - November 2, 2025

**Current Authorization:** Conditional (expires December 31, 2025)
**Updated Status:** Recommend extension based on policy completion

**Authorization Recommendation:** Given the completion of comprehensive
policy documentation covering 50+ controls and 98% overall
implementation status, recommend:

**Full Authorization:** Effective January 1, 2026 **Authorization
Period:** 3 years (through December 31, 2028) **Conditions:** - Complete
remaining policy development (AU, CM, IA, AT) by March 31, 2026 -
Conduct first annual risk assessment by March 31, 2026 - Conduct first
IR tabletop exercise by June 30, 2026 - Implement MFA by March 31, 2026
- Quarterly SSP reviews and updates

**Risk Acceptance:** Residual risks are minimal and acceptable given: -
Top Secret clearance holder as sole system operator - Home office
environment with physical security controls - FIPS 140-2 validated
encryption on all CUI data - Comprehensive monitoring via Wazuh SIEM -
Documented policies and procedures for all major control families

**Approved By:**

/s/ Donald E. Shannon System Owner/ISSO The Contract Coach

**Date:** November 2, 2025

## APPENDICES

### Appendix A: Acronyms and Abbreviations

-   **AC** - Access Control
-   **ATO** - Authorization to Operate
-   **AU** - Audit and Accountability
-   **CA** - Security Assessment
-   **CMMC** - Cybersecurity Maturity Model Certification
-   **CP** - Contingency Planning
-   **CUI** - Controlled Unclassified Information
-   **CVE** - Common Vulnerabilities and Exposures
-   **DFARS** - Defense Federal Acquisition Regulation Supplement
-   **FAR** - Federal Acquisition Regulation
-   **FCI** - Federal Contract Information
-   **FIM** - File Integrity Monitoring
-   **FIPS** - Federal Information Processing Standards
-   **IA** - Identification and Authentication
-   **IDS/IPS** - Intrusion Detection/Prevention System
-   **IR** - Incident Response
-   **ISSO** - Information System Security Officer
-   **LDAP** - Lightweight Directory Access Protocol
-   **LUKS** - Linux Unified Key Setup
-   **MFA** - Multi-Factor Authentication
-   **NIST** - National Institute of Standards and Technology
-   **POA&M** - Plan of Action and Milestones
-   **RA** - Risk Assessment
-   **ReaR** - Relax-and-Recover
-   **SC** - System and Communications Protection
-   **SCA** - Security Configuration Assessment
-   **SI** - System and Information Integrity
-   **SIEM** - Security Information and Event Management
-   **SSH** - Secure Shell
-   **SSP** - System Security Plan
-   **TLS** - Transport Layer Security
-   **XDR** - Extended Detection and Response
-   **YARA** - Yet Another Recursive Acronym (malware detection tool)

### Appendix B: References

1.  NIST Special Publication 800-171 Revision 2, Protecting Controlled
    Unclassified Information in Nonfederal Systems and Organizations
2.  NIST Special Publication 800-171A, Assessing Security Requirements
    for Controlled Unclassified Information
3.  FAR 52.204-21, Basic Safeguarding of Covered Contractor Information
    Systems
4.  DFARS 252.204-7012, Safeguarding Covered Defense Information and
    Cyber Incident Reporting
5.  FIPS 140-2, Security Requirements for Cryptographic Modules
6.  FIPS 199, Standards for Security Categorization of Federal
    Information and Information Systems
7.  CMMC Model Version 2.0, Cybersecurity Maturity Model Certification
8.  32 CFR Part 2002, Controlled Unclassified Information
9.  Wazuh Security Platform Documentation v4.9.2
10. NIST SP 800-88 Rev 1, Guidelines for Media Sanitization
11. YARA Documentation v4.5.2, https://yara.readthedocs.io
12. VirusTotal API Documentation, https://developers.virustotal.com

### Appendix C: Supporting Documentation

**Antimalware Implementation Documentation (NEW):** 1.
`Antimalware_Implementation_Status_Report.md` (40 KB) - Comprehensive
status and technical details 2. `IMPLEMENTATION_CHECKLIST.md` (19 KB) -
12-week deployment plan 3. `Wazuh_YARA_Integration_Guide.md` (21 KB) -
YARA installation and integration 4.
`Wazuh_VirusTotal_Integration_Guide.md` (17 KB) - VirusTotal API setup
and configuration 5. `ClamAV_1.5_Source_Build_Guide.md` (14 KB) - ClamAV
FIPS-compatible build instructions 6.
`ClamAV_FIPS_Solution_Update_Report.md` (29 KB) - Multi-layered defense
architecture 7. `ClamAV_FIPS_Incompatibility_Final_Report.md` (15 KB) -
Problem identification and analysis

**System Documentation:** - `Wazuh_Installation_Summary.md` - Wazuh
deployment documentation - `Wazuh_Operations_Guide.md` - Operational
procedures - `Backup_Implementation_Summary.md` - Backup system
documentation

**Policy Documentation:** - `Cyber Policies and Procedures.pdf` -
Overall cybersecurity framework - `Personnel Security Policy.pdf` -
Personnel security requirements -
`Physical and Media Protection Policy.pdf` - Physical security controls
- `System and Information Integrity Policy.pdf` - System integrity
requirements including SI-3

### Appendix D: Document Maintenance

This System Security Plan shall be reviewed and updated:

-   Quarterly (every 3 months) or more frequently as needed
-   Upon significant system changes (hardware, software, or security
    posture)
-   Following security incidents requiring corrective actions
-   When new threats or vulnerabilities are identified
-   When NIST 800-171 requirements are updated

**Next Scheduled Review:** January 31, 2026

**Review Focus Areas:** - Malware protection deployment progress
(POA&M-014) - YARA rule effectiveness and false positive rates -
VirusTotal API usage and cost analysis - ClamAV 1.5.x testing and
deployment readiness - Wazuh alert tuning and optimization - Backup
restore testing completion - Email server deployment progress - MFA
implementation progress - Training program rollout - Overall POA&M
completion status

**--- END OF SYSTEM SECURITY PLAN ---**

**Document Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Distribution:** Limited to authorized personnel only **Version:** 1.3
DRAFT **Date:** October 31, 2025
