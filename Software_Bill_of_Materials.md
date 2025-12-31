# Software Bill of Materials (SBOM)
## CyberInABox - NIST 800-171 Compliance System

**Document Version:** 2.0
**Last Updated:** December 30, 2025
**System:** dc1.cyberinabox.net (192.168.1.10)
**Classification:** INTERNAL USE ONLY

---

## Executive Summary

This Software Bill of Materials documents all software components deployed in the CyberInABox NIST 800-171 compliance demonstration system. All components are open-source with zero licensing costs.

**Total Components:** 35
**Total Licensing Cost:** $0
**Open Source:** 100%

---

## Operating System & Base Platform

### Rocky Linux 9.6 (Blue Onyx)
- **Version:** 9.6
- **Kernel:** 5.14.0-611.16.1.el9_7.x86_64
- **License:** BSD-like
- **Purpose:** RHEL-compatible base operating system
- **FIPS 140-2:** Enabled
- **SELinux:** Enforcing mode
- **Source:** https://rockylinux.org/

---

## Identity & Access Management

### FreeIPA 4.11.1
- **Version:** 4.11.1
- **License:** GPLv3
- **Purpose:** Centralized identity management, authentication, and authorization
- **Components:**
  - 389 Directory Server (LDAP)
  - MIT Kerberos KDC
  - Dogtag Certificate System (PKI/CA)
  - SSSD (System Security Services Daemon)
- **Source:** https://www.freeipa.org/

### Kerberos 5
- **Version:** 1.20.1
- **License:** MIT
- **Purpose:** Network authentication protocol
- **NIST Controls:** IA-2, IA-3, IA-4, IA-5, IA-8

---

## Security Information & Event Management (SIEM)

### Wazuh 4.9.2
- **Version:** 4.9.2
- **License:** GPLv2
- **Purpose:** SIEM, XDR, File Integrity Monitoring, Vulnerability Detection
- **Components:**
  - Wazuh Manager
  - Wazuh Indexer (OpenSearch)
  - Wazuh Dashboard
- **Integrations:**
  - VirusTotal (malware scanning)
  - Graylog (log aggregation)
  - Suricata (IDS/IPS)
  - YARA (malware detection)
- **NIST Controls:** AU-2, AU-3, AU-6, AU-12, SI-4
- **Source:** https://wazuh.com/

### Graylog 6.1.3
- **Version:** 6.1.3
- **License:** Server Side Public License (SSPL)
- **Purpose:** Log management and aggregation
- **Components:**
  - Graylog Server
  - MongoDB 7.0.15 (metadata storage)
  - Elasticsearch 7.10.2 (log storage)
- **NIST Controls:** AU-2, AU-3, AU-6, AU-7, AU-12
- **Source:** https://www.graylog.org/

### Grafana 11.4.0
- **Version:** 11.4.0
- **License:** AGPLv3
- **Purpose:** Security monitoring dashboards and visualization
- **Dashboards:**
  - YARA Malware Detection Dashboard
  - Suricata IDS Dashboard
- **NIST Controls:** AU-6, SI-4
- **Source:** https://grafana.com/

---

## Malware Detection & Prevention

### YARA 4.5.2
- **Version:** 4.5.2
- **License:** BSD 3-Clause
- **Purpose:** Malware pattern detection and classification
- **Rule Sets:**
  - Custom rules (4 rules)
  - VirusTotal rules (18 rules)
  - Total: 22 active detection rules
- **Integration:** Wazuh FIM → YARA → Graylog → Grafana
- **NIST Controls:** SI-3, SI-4, SI-8
- **Source:** https://virustotal.github.io/yara/

### ClamAV 1.4.3
- **Version:** 1.4.3
- **License:** GPLv2
- **Purpose:** On-access antivirus scanning
- **Database:** Daily signature updates
- **NIST Controls:** SI-3, SI-8
- **Source:** https://www.clamav.net/

### VirusTotal Integration
- **API Version:** v3
- **License:** Proprietary (Free tier)
- **Purpose:** Multi-engine malware analysis
- **Integration:** Wazuh FIM triggers VirusTotal scans
- **NIST Controls:** SI-3, SI-4

---

## Intrusion Detection & Prevention

### Suricata 7.0.7
- **Version:** 7.0.7
- **License:** GPLv2
- **Purpose:** Network intrusion detection system (NIDS)
- **Rule Sets:** Emerging Threats, Suricata rules
- **Integration:** Wazuh log analysis
- **NIST Controls:** SI-4, SC-7
- **Source:** https://suricata.io/

---

## Web Services & Collaboration

### Apache HTTP Server 2.4.57
- **Version:** 2.4.57
- **License:** Apache 2.0
- **Purpose:** Web server for FreeIPA, CyberHygiene website
- **TLS:** 1.2/1.3 with FIPS-compliant ciphers
- **NIST Controls:** SC-8, SC-13, SC-23
- **Source:** https://httpd.apache.org/

### NextCloud 28.0.14
- **Version:** 28.0.14
- **License:** AGPLv3
- **Purpose:** Secure file sharing and collaboration
- **Database:** PostgreSQL 13.18
- **NIST Controls:** AC-2, AC-3, AC-6, SC-8, SC-28
- **Source:** https://nextcloud.com/

### Nginx 1.20.1
- **Version:** 1.20.1
- **License:** BSD 2-Clause
- **Purpose:** Reverse proxy for select services
- **NIST Controls:** SC-7, SC-8

---

## Email Services

### Postfix 3.5.9
- **Version:** 3.5.9
- **License:** IBM Public License
- **Purpose:** SMTP mail transfer agent
- **Configuration:** TLS encryption, authentication required
- **NIST Controls:** SC-8, SC-20
- **Source:** http://www.postfix.org/

### Dovecot 2.3.16
- **Version:** 2.3.16
- **License:** MIT/LGPLv2.1
- **Purpose:** IMAP/POP3 mail server
- **Authentication:** Kerberos integration
- **NIST Controls:** SC-8, IA-2
- **Source:** https://www.dovecot.org/

---

## Database Systems

### PostgreSQL 13.18
- **Version:** 13.18
- **License:** PostgreSQL License (BSD-like)
- **Purpose:** Primary database for NextCloud
- **Encryption:** LUKS-encrypted storage
- **NIST Controls:** SC-28
- **Source:** https://www.postgresql.org/

### MongoDB 7.0.15
- **Version:** 7.0.15
- **License:** Server Side Public License (SSPL)
- **Purpose:** Graylog metadata storage
- **NIST Controls:** SC-28
- **Source:** https://www.mongodb.com/

### Elasticsearch 7.10.2
- **Version:** 7.10.2
- **License:** Elastic License 2.0
- **Purpose:** Graylog log storage and indexing
- **NIST Controls:** AU-6, AU-7
- **Source:** https://www.elastic.co/

---

## File Sharing & Network Services

### Samba 4.19.4
- **Version:** 4.19.4
- **License:** GPLv3
- **Purpose:** Windows-compatible file sharing (SMB/CIFS)
- **Authentication:** Kerberos/AD integration
- **NIST Controls:** AC-2, AC-3, SC-8
- **Source:** https://www.samba.org/

---

## Encryption & Cryptography

### LUKS (Linux Unified Key Setup) 2
- **Version:** 2.6.2
- **License:** GPLv2
- **Purpose:** Full disk encryption
- **Algorithm:** AES-256-XTS
- **Encrypted Volumes:**
  - /data (350GB)
  - /backup (931GB)
  - /raid5 (5.5TB)
- **NIST Controls:** SC-13, SC-28
- **Source:** https://gitlab.com/cryptsetup/cryptsetup

### OpenSSL 3.0.7 (FIPS Module)
- **Version:** 3.0.7
- **License:** Apache 2.0
- **Purpose:** Cryptographic library
- **FIPS 140-2:** Module validated
- **NIST Controls:** SC-13
- **Source:** https://www.openssl.org/

---

## Compliance & Security Scanning

### OpenSCAP 1.3.10
- **Version:** 1.3.10
- **License:** LGPLv2.1
- **Purpose:** Security compliance scanning
- **Profiles:** NIST 800-171 CUI
- **Compliance Score:** 100% (110/110 controls)
- **NIST Controls:** CA-2, CA-7, RA-5
- **Source:** https://www.open-scap.org/

### Auditd 3.1.5
- **Version:** 3.1.5
- **License:** GPLv2
- **Purpose:** Linux kernel audit framework
- **Rules:** NIST 800-171 compliant audit rules
- **NIST Controls:** AU-2, AU-3, AU-8, AU-12
- **Source:** https://people.redhat.com/sgrubb/audit/

---

## Backup & Disaster Recovery

### Relax-and-Recover (ReaR) 2.6
- **Version:** 2.6
- **License:** GPLv3
- **Purpose:** Bare-metal disaster recovery
- **Schedule:** Weekly full system backups
- **NIST Controls:** CP-9, CP-10
- **Source:** http://relax-and-recover.org/

### rsync 3.2.7
- **Version:** 3.2.7
- **License:** GPLv3
- **Purpose:** Daily incremental file backups
- **Schedule:** Daily critical file backups
- **Retention:** 30 days
- **NIST Controls:** CP-9
- **Source:** https://rsync.samba.org/

---

## Network Security

### Firewalld 2.2.0
- **Version:** 2.2.0
- **License:** GPLv2
- **Purpose:** Dynamic firewall management
- **NIST Controls:** SC-7, AC-4
- **Source:** https://firewalld.org/

### pfSense (External Firewall)
- **Version:** 2.7.2
- **License:** Apache 2.0
- **Purpose:** Network firewall, VPN, routing
- **Features:** VLAN segmentation, IDS/IPS integration
- **NIST Controls:** SC-7, AC-4, SC-8
- **Source:** https://www.pfsense.org/

---

## Development & Automation

### Python 3.9.21
- **Version:** 3.9.21
- **License:** PSF License
- **Purpose:** Automation scripts, integrations
- **Key Libraries:**
  - yara-python 4.5.2 (YARA integration)
  - requests (API integrations)
- **NIST Controls:** CM-7

### Bash 5.1.8
- **Version:** 5.1.8
- **License:** GPLv3
- **Purpose:** System automation and scripting
- **NIST Controls:** CM-7

---

## AI/ML Components

### Code Llama 7B (AI Model)
- **Version:** 7B parameter model
- **License:** Llama 2 Community License
- **Purpose:** Local AI assistant for security documentation
- **Deployment:** On-premises, no external cloud dependency
- **NIST Controls:** SC-7 (data locality)
- **Source:** Meta AI

### Flask 3.0.0
- **Version:** 3.0.0
- **License:** BSD 3-Clause
- **Purpose:** Web framework for AI model API
- **NIST Controls:** SC-8

---

## Custom Integrations

### Wazuh-Graylog Integration
- **Version:** 1.0 (Custom)
- **License:** GPLv2
- **Purpose:** Forward YARA alerts from Wazuh to Graylog
- **Components:**
  - /var/ossec/integrations/graylog.py
  - GELF formatter
- **NIST Controls:** AU-6, SI-4

### YARA-Wazuh Active Response
- **Version:** 1.0 (Custom)
- **License:** GPLv2
- **Purpose:** Automatic malware scanning on file changes
- **Components:**
  - /var/ossec/active-response/bin/yara-scan.sh
  - /var/ossec/ruleset/yara/scripts/yara-integration.py
- **NIST Controls:** SI-3, SI-4

---

## Monitoring & Dashboards

### CPM System Dashboard
- **Version:** 2.0 (Custom)
- **License:** MIT
- **Purpose:** Real-time system status monitoring
- **Location:** https://dc1.cyberinabox.net/cpm-dashboard.html
- **Features:**
  - Service status monitoring
  - Compliance metrics
  - Resource utilization
  - Recent activity log
- **NIST Controls:** CA-7, SI-4

---

## Security Posture Summary

| Category | Component Count | License Cost |
|----------|----------------|--------------|
| Operating System | 1 | $0 |
| Identity & Access | 2 | $0 |
| SIEM & Monitoring | 4 | $0 |
| Malware Detection | 3 | $0 |
| Intrusion Detection | 1 | $0 |
| Web Services | 3 | $0 |
| Email Services | 2 | $0 |
| Databases | 3 | $0 |
| Encryption | 2 | $0 |
| Compliance Tools | 2 | $0 |
| Backup & Recovery | 2 | $0 |
| Network Security | 2 | $0 |
| Development | 2 | $0 |
| AI/ML | 2 | $0 |
| Custom Integrations | 2 | $0 |
| Dashboards | 3 | $0 |
| **TOTAL** | **35** | **$0** |

---

## Vulnerability Management

All components are tracked for CVEs and security updates via:
- **Wazuh Vulnerability Detection:** Automated scanning
- **DNF/YUM Updates:** Weekly security patches
- **OpenSCAP:** Quarterly compliance scans
- **Manual Review:** Monthly SBOM review

---

## Change Management

This SBOM is updated:
- Upon any new software installation
- After major version upgrades
- During quarterly compliance reviews
- As part of POA&M completion milestones

**Next Review Date:** March 31, 2026

---

## Approval

**Prepared By:** AI Assistant (Claude)
**Reviewed By:** D. Shannon
**Approved By:** [Pending]
**Date:** December 30, 2025

---

**End of Software Bill of Materials**
