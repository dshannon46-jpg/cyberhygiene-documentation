# Chapter 35: Software Inventory

## 35.1 Software Bill of Materials (SBOM)

### Critical Infrastructure Software

**Identity and Access Management:**
```
FreeIPA Server: 4.11.1
  Components:
    - 389-ds-base: 2.4.5 (Directory Server)
    - krb5-server: 1.21.1 (Kerberos KDC)
    - bind-dyndb-ldap: 11.10 (DNS)
    - pki-ca: 11.5.0 (Certificate Authority)
    - httpd: 2.4.57 (Web server)
    - mod_auth_gssapi: 1.6.5 (Kerberos auth)
    - sssd: 2.9.4 (Client authentication)
    - certmonger: 0.79.17 (Certificate management)

  Purpose: Centralized authentication, authorization, PKI
  License: GPL v3
  Vendor: FreeIPA Project / Red Hat
```

**Security Monitoring:**
```
Wazuh Manager: 4.14.2
  Components:
    - wazuh-manager: 4.9.2
    - wazuh-api: 4.9.2
    - filebeat: 8.11.3
    - opensearch: 2.11.1
    - wazuh-dashboard: 4.9.2

  Purpose: SIEM, threat detection, compliance monitoring
  License: GPL v2 (Wazuh), Apache 2.0 (OpenSearch)
  Vendor: Wazuh Inc.

Wazuh Agent: 4.9.2 (deployed on all 6 systems)
  Purpose: Endpoint monitoring, log collection

Suricata: 7.0.7
  Purpose: Network IDS/IPS
  License: GPL v2
  Vendor: OISF (Open Information Security Foundation)
  Rule Sets: Emerging Threats (ET Open)

ClamAV: 1.4.3
  Purpose: Antivirus scanning
  License: GPL v2
  Vendor: Cisco Talos
  Database Version: Updated daily

YARA: 4.5.2
  Purpose: Malware pattern matching
  License: BSD 3-Clause
  Vendor: VirusTotal

AIDE: 0.18.6
  Purpose: File integrity monitoring
  License: GPL v2
```

**Logging and Monitoring:**
```
Graylog Server: 6.1.3
  Components:
    - graylog-server: 6.1.3
    - elasticsearch: 7.10.2
    - mongodb: 7.0.15

  Purpose: Centralized log management
  License: Server Side Public License (SSPL)
  Vendor: Graylog Inc.

Prometheus: 2.48.1
  Purpose: Metrics collection and storage
  License: Apache 2.0
  Vendor: Prometheus Authors / CNCF

Grafana: 11.4.0
  Purpose: Metrics visualization
  License: AGPL v3
  Vendor: Grafana Labs

Alertmanager: 0.26.0
  Purpose: Alert routing and management
  License: Apache 2.0

Node Exporter: 1.7.0 (on all systems)
  Purpose: System metrics export
  License: Apache 2.0
```

**Web Services:**
```
Apache HTTP Server: 2.4.57
  Modules:
    - mod_ssl: 2.4.57
    - mod_auth_gssapi: 1.6.5
    - mod_wsgi: 4.9.4 (Python 3.9)

  Purpose: Web server for FreeIPA, various dashboards
  License: Apache 2.0

Nginx: 1.20.1
  Purpose: Reverse proxy for Grafana
  License: BSD 2-Clause

Postfix: 3.5.9
  Purpose: Mail transfer agent
  License: IBM Public License
```

**Databases:**
```
PostgreSQL: 13.18
  Purpose: NextCloud database
  License: PostgreSQL License (similar to MIT)

MongoDB: 7.0.15
  Purpose: Graylog configuration storage
  License: Server Side Public License (SSPL)

389 Directory Server: 2.4.5
  Purpose: LDAP database for FreeIPA
  License: GPL v3
```

**File Sharing:**
```
NFS Utilities: 2.5.4
  Components:
    - nfs-server
    - rpcbind
    - nfs-utils

  Purpose: Unix file sharing
  License: GPL v2

Samba: 4.19.4
  Components:
    - smbd: 4.19.4
    - nmbd: 4.19.4
    - winbindd: 4.19.4

  Purpose: Windows-compatible file sharing
  License: GPL v3
```

## 35.2 Operating System Packages

### Base System

**Core Rocky Linux 9.7 Packages:**
```
Kernel: kernel-5.14.0-611.24.1.el9_7.x86_64
  - FIPS mode enabled
  - SELinux support
  - Auditd integration

System Libraries:
  - glibc: 2.34-100.el9_5.2
  - openssl: 3.0.7-27.el9 (FIPS validated)
  - openssl-libs: 3.0.7-27.el9
  - systemd: 252-32.el9_5
  - selinux-policy: 38.1.35-3.el9_5
  - audit: 3.1.2-2.el9

Security:
  - firewalld: 1.3.4-1.el9
  - policycoreutils: 3.6-2.1.el9
  - cryptsetup: 2.7.0-1.el9
  - aide: 0.18.6-1.el9
  - fail2ban: 1.0.2 (EPEL)

Package Management:
  - dnf: 4.14.0-8.el9
  - rpm: 4.16.1.3-27.el9
  - dnf-automatic: 4.14.0-8.el9
```

**Development Tools:**
```
Python: 3.9.18
  Packages:
    - python3: 3.9.18
    - python3-pip: 21.3.1
    - python3-setuptools: 57.4.0
    - python3-requests: 2.25.1
    - python3-pyyaml: 5.4.1

Git: 2.43.0
  Purpose: Version control

Compilers (build dependencies):
  - gcc: 11.4.1
  - make: 4.3
  - cmake: 3.26.5
```

**System Utilities:**
```
Text Processing:
  - vim: 8.2.2637
  - nano: 5.6.1
  - grep: 3.6
  - sed: 4.8
  - awk (gawk): 5.1.0

Network Tools:
  - iproute: 6.2.0
  - net-tools: 2.0
  - bind-utils: 9.16.23 (dig, nslookup)
  - tcpdump: 4.99.0
  - wireshark-cli: 3.4.10
  - nmap: 7.92
  - curl: 7.76.1
  - wget: 1.21.1

Monitoring:
  - htop: 3.2.1
  - iotop: 0.6
  - iftop: 1.0
  - sysstat: 12.5.4 (sar, iostat)
  - lsof: 4.94.0
```

## 35.3 Custom Software and Scripts

### Local Scripts and Tools

**Backup Scripts:**
```
Location: /usr/local/bin/

backup-all-systems.sh
  Purpose: Master backup orchestration
  Language: Bash
  Size: ~500 lines
  Author: Donald Shannon
  Last Modified: 2025-12-31

backup-system.sh
  Purpose: Individual system backup
  Language: Bash
  Size: ~300 lines

backup-databases.sh
  Purpose: Database-specific backups
  Language: Bash
  Size: ~200 lines

backup-verify.sh
  Purpose: Daily backup verification
  Language: Bash
  Size: ~250 lines

backup-monthly-test.sh
  Purpose: Monthly restore testing
  Language: Bash
  Size: ~300 lines

restore-file.sh
  Purpose: Single file restoration
  Language: Bash
  Size: ~150 lines

restore-system.sh
  Purpose: Full system restoration
  Language: Bash
  Size: ~250 lines
```

**Monitoring Scripts:**
```
check-certificates.sh
  Purpose: Certificate expiration monitoring
  Language: Bash
  Size: ~200 lines
  Schedule: Daily via cron

generate-update-report.sh
  Purpose: System update status report
  Language: Bash
  Size: ~150 lines
  Schedule: Weekly

emergency-update.sh
  Purpose: Emergency security patching
  Language: Bash
  Size: ~180 lines
  Usage: Manual (emergency only)
```

**Custom Exporters:**
```
suricata_exporter.py
  Purpose: Export Suricata metrics to Prometheus
  Language: Python 3.9
  Location: /usr/local/bin/
  Port: 9101
  Dependencies: prometheus_client, json
```

## 35.4 Third-Party Repositories

### Enabled Repositories

```bash
# List all enabled repos
dnf repolist

Rocky Linux Repositories:
  baseos: Rocky Linux 9 - BaseOS
  appstream: Rocky Linux 9 - AppStream
  extras: Rocky Linux 9 - Extras
  crb: Rocky Linux 9 - CRB (PowerTools)

EPEL (Extra Packages for Enterprise Linux):
  epel: EPEL 9
  epel-testing: EPEL 9 Testing (disabled by default)

Vendor-Specific:
  grafana: Grafana Official Repository
  prometheus: Prometheus Official Repository
  wazuh: Wazuh Official Repository
  graylog: Graylog Official Repository
  mongodb: MongoDB Official Repository
  postgresql: PostgreSQL Official Repository

FreeIPA:
  Included in Rocky Linux AppStream
  No third-party repo needed
```

## 35.5 License Compliance

### Software Licenses Overview

**Open Source Licenses:**
```
GPL v2 (GNU General Public License v2):
  - Suricata
  - ClamAV
  - Wazuh Manager (core)
  - NFS utilities
  - Linux kernel

GPL v3:
  - FreeIPA
  - 389 Directory Server
  - Samba
  - AIDE

Apache License 2.0:
  - Prometheus
  - Grafana (AGPL for Enterprise features)
  - OpenSearch (Elasticsearch alternative)
  - Node Exporter
  - Apache HTTP Server

AGPL v3 (Affero GPL):
  - Grafana (open source version)

BSD/MIT-like:
  - PostgreSQL (PostgreSQL License)
  - Nginx (BSD 2-Clause)
  - YARA (BSD 3-Clause)
  - Python (PSF License)

Server Side Public License (SSPL):
  - MongoDB
  - Graylog Server

  Note: SSPL licenses require source availability
        for hosted/SaaS deployments
```

**Commercial/Proprietary:**
```
None - All software is open source

Potential Commercial Options (not currently used):
  - Red Hat Enterprise Linux (we use Rocky Linux)
  - Wazuh Cloud (we use self-hosted)
  - Grafana Enterprise (we use OSS version)
  - Suricata ET Pro rules (we use ET Open)
```

**License Compliance Notes:**
```
All software licenses reviewed and approved:
  ✓ GPL-compatible
  ✓ Commercial use allowed
  ✓ Modification allowed
  ✓ Distribution allowed (with source)
  ✓ No patent restrictions
  ✓ FIPS 140-2 compatible

Documentation:
  - License files: /usr/share/licenses/
  - SBOM: Maintained in documentation
  - Compliance: Verified in security assessments
```

## 35.6 Software Update Policy

### Update Sources

```
Automatic Security Updates:
  - Source: Rocky Linux BaseOS + AppStream
  - Frequency: Weekly (Sunday 03:00)
  - Scope: Security-only (upgrade_type=security)
  - Tool: dnf-automatic

Manual Updates:
  - Source: All repositories
  - Frequency: Monthly maintenance window
  - Scope: All available updates
  - Tool: dnf upgrade

Vendor Updates:
  - Wazuh: Official repository, manual updates
  - Grafana: Official repository, manual updates
  - Graylog: Official repository, manual updates
  - MongoDB: Official repository, manual updates
```

### Version Pinning

```
Critical Software (version pinned):
  - kernel: Keep 3 versions (current + 2 previous)
  - freeipa-*: Update only during maintenance
  - wazuh-*: Manual updates after testing

Unpinned (auto-update allowed):
  - Security libraries (openssl, glibc)
  - Utilities (curl, wget, etc.)
  - Monitoring exporters
```

---

**Software Inventory Quick Reference:**

**Core Infrastructure:**
- FreeIPA: 4.11.1 (Identity Management)
- Wazuh: 4.14.2 (SIEM)
- Suricata: 7.0.7 (IDS/IPS)
- Graylog: 6.1.3 (Logging)
- Prometheus: 2.48.1 (Metrics)
- Grafana: 11.4.0 (Visualization)

**Operating System:**
- Rocky Linux: 9.7
- Kernel: 5.14.0-611.24.1
- Python: 3.9.21
- PostgreSQL: 13.18
- MongoDB: 7.0.15

**Total Packages:**
- Per system: 800-1200 packages
- Custom scripts: 20+ scripts
- Licenses: 100% open source

**Updates:**
- Security: Weekly automatic
- All packages: Monthly manual
- Kernel: Quarterly or as needed

**Compliance:**
- All licenses: OSS compatible
- FIPS: All cryptography validated
- SBOM: Maintained and current

---

**Related Chapters:**
- Chapter 33: System Specifications
- Chapter 31: Security Updates & Patching
- Chapter 4: Security Baseline
- Appendix C: Command Reference

**For Updates:**
- Check versions: `rpm -qa | grep package`
- Update single package: `sudo dnf upgrade package`
- View update history: `sudo dnf history`
- Administrator: dshannon@cyberinabox.net
