# SOFTWARE BILL OF MATERIALS (SBOM)

**System:** CyberHygiene Production Network - dc1.cyberinabox.net
**Organization:** The Contract Coach
**Classification:** Controlled Unclassified Information (CUI)
**Date Generated:** December 2, 2025
**Platform:** Rocky Linux 9.6 (Blue Onyx)
**Kernel:** 5.14.0-570.58.1.el9_6.x86_64
**Architecture:** x86_64
**FIPS Mode:** Enabled
**Total Packages:** 1,750

---

## PURPOSE

This Software Bill of Materials (SBOM) provides a comprehensive inventory of all software components installed on the CyberHygiene Production Network domain controller (dc1.cyberinabox.net). This document supports:

- **Supply chain security assessment** per NIST 800-171 SR-2
- **Vulnerability management** and patch tracking
- **Software licensing compliance**
- **System security auditing**
- **Incident response and forensics**
- **Configuration management**

---

## DOCUMENT CLASSIFICATION

**Classification:** CUI (Controlled Unclassified Information)
**Distribution:** Owner/ISSO, Authorized Auditors, C3PAO Assessors
**Retention:** Maintain current version + 3 years historical
**Review Schedule:** Quarterly (with each SSP review)

---

## CRITICAL SECURITY SOFTWARE

### Identity & Access Management

| Package | Version | Vendor | Purpose |
|---------|---------|--------|---------|
| **389-ds-base** | 2.6.1-12.el9_6 | Rocky Enterprise Software Foundation | LDAP Directory Server (FreeIPA backend) |
| **389-ds-base-libs** | 2.6.1-12.el9_6 | Rocky Enterprise Software Foundation | Core libraries for 389 Directory Server |
| **ipa-selinux** | 4.12.2-14.el9_6.5 | Rocky Enterprise Software Foundation | FreeIPA SELinux policy |
| **libipa_hbac** | 2.9.6-4.el9_6.2 | Rocky Enterprise Software Foundation | FreeIPA HBAC Evaluator library |
| **libsss_idmap** | 2.9.6-4.el9_6.2 | Rocky Enterprise Software Foundation | FreeIPA Idmap library |
| **python3-libipa_hbac** | 2.9.6-4.el9_6.2 | Rocky Enterprise Software Foundation | Python3 bindings for FreeIPA HBAC |
| **rocky-logos-ipa** | 90.16-1.el9 | Rocky Enterprise Software Foundation | Rocky Linux icons used by FreeIPA |
| **certmonger** | 0.79.20-1.el9 | Rocky Enterprise Software Foundation | Certificate status monitor and PKI enrollment client |
| **adcli** | 0.9.2-1.el9 | Rocky Enterprise Software Foundation | Active Directory enrollment |

### Security Monitoring & SIEM

| Package | Version | Vendor | Purpose |
|---------|---------|--------|---------|
| **wazuh-manager** | 4.9.2-1 | Wazuh, Inc | Security monitoring, log analysis, FIM, vulnerability detection |
| **wazuh-indexer** | 4.9.2-1 | Wazuh, Inc | Elasticsearch-compatible search engine for Wazuh |
| **graylog-server** | 6.0.14-1 | Graylog, Inc | Centralized log management and analysis |
| **mongodb-org-server** | 7.0.26-1.el9 | MongoDB | NoSQL database (Graylog metadata storage) |
| **mongodb-org-mongos** | 7.0.26-1.el9 | MongoDB | MongoDB sharded cluster query router |
| **mongodb-org-tools** | 7.0.26-1.el9 | MongoDB | MongoDB command-line tools |
| **mongodb-database-tools** | 100.13.0-1 | MongoDB | MongoDB Database Tools |
| **mongodb-mongosh** | 2.5.10-1.el8 | MongoDB | MongoDB Shell CLI REPL |
| **opensearch** | 2.19.4-1 | OpenSearch | Open source search and analytics engine (Graylog log storage) |

### Malware Protection

| Package | Version | Vendor | Purpose |
|---------|---------|--------|---------|
| **clamav** | 1.4.3-2.el9 | Fedora Project | Antivirus scanner (awaiting FIPS-compatible 1.5.x) |
| **clamav-lib** | 1.4.3-2.el9 | Fedora Project | ClamAV dynamic libraries |
| **clamav-data** | 1.4.3-2.el9 | Fedora Project | Virus signature database |
| **clamav-freshclam** | 1.4.3-2.el9 | Fedora Project | Auto-updater for virus definitions |
| **clamav-filesystem** | 1.4.3-2.el9 | Fedora Project | Filesystem structure for ClamAV |
| **yara** | 4.5.2-1.el9 | Rocky Enterprise Software Foundation | Pattern matching for malware research (FIPS-compatible) |

### Email Services

| Package | Version | Vendor | Purpose |
|---------|---------|--------|---------|
| **postfix** | 3.5.25-1.el9 | Rocky Enterprise Software Foundation | Mail Transport Agent (SMTP) |
| **dovecot** | 2.3.16-15.el9 | Rocky Enterprise Software Foundation | Secure IMAP and POP3 server |
| **dovecot-pigeonhole** | 2.3.16-15.el9 | Rocky Enterprise Software Foundation | Sieve mail filtering plug-in |

### Audit & Compliance

| Package | Version | Vendor | Purpose |
|---------|---------|--------|---------|
| **audit** | 3.1.5-4.el9 | Rocky Enterprise Software Foundation | User space tools for kernel auditing |
| **audit-libs** | 3.1.5-4.el9 | Rocky Enterprise Software Foundation | Dynamic library for libaudit |
| **openscap** | 1.3.10-2.el9_4 | Rocky Enterprise Software Foundation | SCAP compliance scanner |
| **openscap-scanner** | 1.3.10-2.el9_4 | Rocky Enterprise Software Foundation | OpenSCAP scanning tool |
| **scap-security-guide** | 0.1.78-1.el9_6 | Rocky Enterprise Software Foundation | SCAP Security Guide content |

---

## OPERATING SYSTEM & CORE COMPONENTS

### Base System

| Component | Version | Notes |
|-----------|---------|-------|
| **Operating System** | Rocky Linux 9.6 (Blue Onyx) | RHEL-compatible enterprise Linux |
| **Kernel** | 5.14.0-570.58.1.el9_6.x86_64 | Linux kernel with FIPS support |
| **FIPS Mode** | Enabled | FIPS 140-2 cryptographic validation |
| **SELinux** | Enforcing (Targeted policy) | Mandatory access control |
| **systemd** | 252 | System and service manager |
| **glibc** | 2.34 | GNU C Library |

### Cryptographic Libraries

| Package | Version | Purpose |
|---------|---------|---------|
| **openssl** | 3.0.7 | FIPS 140-2 validated cryptographic library |
| **openssl-libs** | 3.0.7 | OpenSSL shared libraries |
| **gnutls** | 3.8.3 | Secure communications library |
| **libgcrypt** | 1.10.0 | General purpose cryptographic library |
| **nss** | 3.90.0 | Network Security Services |

### Security Packages

| Package | Version | Purpose |
|---------|---------|---------|
| **selinux-policy** | 38.1.50-1.el9_6 | SELinux reference policy |
| **selinux-policy-targeted** | 38.1.50-1.el9_6 | SELinux targeted policy |
| **policycoreutils** | 3.6-2.1.el9 | SELinux policy core utilities |
| **libselinux** | 3.6-1.el9 | SELinux library |
| **firewalld** | 1.3.4-2.el9_6 | Firewall daemon with D-Bus interface |

---

## WEB SERVICES & APPLICATION SERVERS

### Web Servers

| Package | Version | Purpose |
|---------|---------|---------|
| **httpd** | 2.4.57-11.el9_5.1 | Apache HTTP Server (FreeIPA, NextCloud) |
| **httpd-core** | 2.4.57-11.el9_5.1 | Apache HTTP Server core modules |
| **httpd-filesystem** | 2.4.57-11.el9_5.1 | Apache filesystem layout |
| **httpd-tools** | 2.4.57-11.el9_5.1 | Apache HTTP Server tools |
| **mod_ssl** | 2.4.57-11.el9_5.1 | SSL/TLS module for Apache |

### PHP (for NextCloud)

| Package | Version | Purpose |
|---------|---------|---------|
| **php** | 8.1.32 | PHP scripting language |
| **php-fpm** | 8.1.32 | PHP FastCGI Process Manager |
| **php-cli** | 8.1.32 | PHP command-line interface |
| **php-common** | 8.1.32 | Common files for PHP |
| **php-mysqlnd** | 8.1.32 | MySQL Native Driver for PHP |
| **php-pdo** | 8.1.32 | PHP Data Objects |
| **php-gd** | 8.1.32 | GD graphics library for PHP |
| **php-mbstring** | 8.1.32 | Multi-byte string extension |
| **php-xml** | 8.1.32 | XML manipulation extension |
| **php-ldap** | 8.1.32 | LDAP extension for PHP |

### Java Runtime (for Graylog, MongoDB, OpenSearch)

| Package | Version | Purpose |
|---------|---------|---------|
| **java-17-openjdk** | 17.0.13 | OpenJDK Java Runtime Environment |
| **java-17-openjdk-headless** | 17.0.13 | OpenJDK JRE without GUI support |
| **java-17-openjdk-devel** | 17.0.13 | OpenJDK Development Environment |

---

## DATABASE SYSTEMS

### Relational Databases

| Package | Version | Purpose |
|---------|---------|---------|
| **mariadb** | 10.5.22 | MariaDB database server |
| **mariadb-server** | 10.5.22 | MariaDB server daemon |
| **mariadb-common** | 10.5.22 | MariaDB common files |

### NoSQL Databases

| Package | Version | Purpose |
|---------|---------|---------|
| **mongodb-org-server** | 7.0.26 | MongoDB NoSQL database (Graylog metadata) |
| **opensearch** | 2.19.4 | OpenSearch search engine (Graylog logs) |

---

## NETWORKING & SECURITY

### Network Services

| Package | Version | Purpose |
|---------|---------|---------|
| **bind** | 9.16.23-31.el9_6 | Berkeley Internet Name Domain (DNS) server |
| **bind-utils** | 9.16.23-31.el9_6 | DNS utilities (dig, nslookup, host) |
| **bind-libs** | 9.16.23-31.el9_6 | BIND DNS libraries |
| **bind-dnssec-utils** | 9.16.23-31.el9_6 | DNSSEC management utilities |
| **openssh** | 8.7p1-38.el9_4.4 | OpenSSH SSH protocol implementation |
| **openssh-server** | 8.7p1-38.el9_4.4 | OpenSSH SSH daemon |
| **openssh-clients** | 8.7p1-38.el9_4.4 | OpenSSH SSH client |

### VPN & Remote Access

| Package | Version | Purpose |
|---------|---------|---------|
| **openvpn** | 2.6.12-1.el9 | Full-featured SSL VPN solution |
| **wireguard-tools** | 1.0.20210914-2.el9 | WireGuard VPN tools |

### Network Management

| Package | Version | Purpose |
|---------|---------|---------|
| **NetworkManager** | 1.50.0-6.el9_6 | Network connection manager |
| **iproute** | 6.2.0-6.el9_4 | Advanced IP routing and network device configuration |
| **iputils** | 20210202-10.el9 | Network monitoring tools (ping, tracepath) |
| **net-tools** | 2.0-0.62.20160912git.el9 | Basic networking tools (netstat, ifconfig) |

---

## BACKUP & DISASTER RECOVERY

| Package | Version | Purpose |
|---------|---------|---------|
| **rear** | 2.6-25.el9 | Relax-and-Recover bare-metal disaster recovery |
| **rsync** | 3.2.3-19.el9 | Fast incremental file transfer |
| **tar** | 1.34-6.el9_1 | GNU tar archiving program |
| **gzip** | 1.12-1.el9 | GNU compression utility |
| **bzip2** | 1.0.8-10.el9_5 | High-quality block-sorting file compressor |
| **xz** | 5.2.5-8.el9_0 | LZMA compression utilities |

---

## DEVELOPMENT TOOLS & COMPILERS

### Compilers

| Package | Version | Purpose |
|---------|---------|---------|
| **gcc** | 11.5.0-2.el9 | GNU C compiler |
| **gcc-c++** | 11.5.0-2.el9 | GNU C++ compiler |
| **make** | 4.3-8.el9 | GNU make utility |
| **autoconf** | 2.69-39.el9 | GNU automatic configure script builder |
| **automake** | 1.16.2-8.el9 | GNU automatic makefile generator |

### Programming Languages

| Package | Version | Purpose |
|---------|---------|---------|
| **python3** | 3.9.21-1.el9_6 | Python 3 interpreter |
| **python3-libs** | 3.9.21-1.el9_6 | Python 3 runtime libraries |
| **perl** | 5.32.1 | Perl programming language |
| **ruby** | 3.0.4 | Ruby programming language |
| **cargo** | 1.84.1-1.el9 | Rust package manager |

### Version Control

| Package | Version | Purpose |
|---------|---------|---------|
| **git** | 2.43.5-1.el9_4 | Fast Version Control System |
| **git-core** | 2.43.5-1.el9_4 | Core package of git |

---

## STORAGE & FILESYSTEM

### RAID Management

| Package | Version | Purpose |
|---------|---------|---------|
| **mdadm** | 4.2-14.el9 | Tool for managing Linux Software RAID arrays |

### Encryption

| Package | Version | Purpose |
|---------|---------|---------|
| **cryptsetup** | 2.7.2-3.el9 | Utility for setting up encrypted disks (LUKS) |
| **cryptsetup-libs** | 2.7.2-3.el9 | Cryptsetup shared libraries |
| **device-mapper** | 1.02.201-2.el9 | Device mapper userspace library |

### Filesystem Tools

| Package | Version | Purpose |
|---------|---------|---------|
| **xfsprogs** | 6.3.0-3.el9 | XFS filesystem utilities |
| **e2fsprogs** | 1.46.5-5.el9 | Ext2/3/4 filesystem utilities |
| **btrfs-progs** | 6.7.1-1.el9 | Btrfs filesystem utilities |
| **lvm2** | 2.03.24-3.el9_6 | Logical Volume Manager 2 |

---

## MONITORING & DIAGNOSTICS

### System Monitoring

| Package | Version | Purpose |
|---------|---------|---------|
| **sysstat** | 12.5.4-7.el9 | System performance monitoring tools (sar, iostat) |
| **procps-ng** | 3.3.17-14.el9 | System and process monitoring utilities (ps, top, free) |
| **psmisc** | 23.4-3.el9 | Utilities for managing processes (killall, fuser, pstree) |
| **lsof** | 4.94.0-1.el9 | List open files |
| **strace** | 6.7-1.el9 | System call tracer |

### Network Diagnostics

| Package | Version | Purpose |
|---------|---------|---------|
| **tcpdump** | 4.99.0-9.el9 | Network traffic analyzer |
| **wireshark-cli** | 3.4.10-9.el9_6 | Network protocol analyzer (CLI) |
| **nmap** | 7.92-2.el9 | Network exploration tool and security scanner |
| **traceroute** | 2.1.0-16.el9 | Trace network route to host |
| **mtr** | 0.94-6.el9 | Network diagnostic tool |

---

## PACKAGE MANAGEMENT & UPDATES

| Package | Version | Purpose |
|---------|---------|---------|
| **dnf** | 4.14.0-17.el9 | Package manager forked from YUM |
| **dnf-automatic** | 4.14.0-17.el9 | Automatic updates with DNF |
| **rpm** | 4.16.1.3-34.el9 | RPM Package Manager |
| **yum** | 4.14.0-17.el9 | Package manager (compatibility layer) |
| **subscription-manager** | 1.29.42-1.el9_4 | Subscription and repository management |

---

## DESKTOP ENVIRONMENT (for GUI management)

### GNOME Desktop

| Package | Version | Purpose |
|---------|---------|---------|
| **gnome-shell** | 40.10-11.el9_5 | GNOME Shell |
| **gnome-terminal** | 3.40.3-3.el9 | GNOME Terminal emulator |
| **gnome-session** | 40.1.1-5.el9 | GNOME Session Manager |
| **gdm** | 40.1-25.el9_6 | GNOME Display Manager |

### X Window System

| Package | Version | Purpose |
|---------|---------|---------|
| **xorg-x11-server-Xorg** | 1.20.11-26.el9 | X.Org X11 server |
| **xorg-x11-drv-fbdev** | 0.5.0-5.el9 | Xorg framebuffer driver |

---

## CERTIFICATES & PKI

| Package | Version | Purpose |
|---------|---------|---------|
| **ca-certificates** | 2024.2.69_v8.0.303-91.4.el9_4 | Mozilla CA root certificate bundle |
| **certbot** | 3.1.0-1.el9 | Let's Encrypt certificate automation |
| **certmonger** | 0.79.20-1.el9 | Certificate monitoring and renewal |
| **dogtag-pki** | 11.5.3-1.el9_6 | Dogtag Certificate System (FreeIPA CA) |

---

## TIME SYNCHRONIZATION

| Package | Version | Purpose |
|---------|---------|---------|
| **chrony** | 4.5-1.el9 | Versatile NTP client and server |
| **timedatex** | 0.5-5.el9 | D-Bus service for system time management |

---

## LOGGING & SYSLOG

| Package | Version | Purpose |
|---------|---------|---------|
| **rsyslog** | 8.2310.0-1.el9 | Rocket-fast system for log processing |
| **rsyslog-logrotate** | 8.2310.0-1.el9 | Log rotation for rsyslog |
| **logrotate** | 3.20.1-4.el9 | Log file rotation utility |

---

## THIRD-PARTY REPOSITORIES

### Enabled Repositories

| Repository | Description | URL |
|------------|-------------|-----|
| **Rocky Linux BaseOS** | Base operating system packages | mirror.rockylinux.org |
| **Rocky Linux AppStream** | Additional applications | mirror.rockylinux.org |
| **EPEL 9** | Extra Packages for Enterprise Linux | dl.fedoraproject.org/pub/epel |
| **Wazuh** | Wazuh security platform | packages.wazuh.com |
| **Graylog** | Graylog log management | packages.graylog2.org |
| **MongoDB** | MongoDB NoSQL database | repo.mongodb.org |
| **OpenSearch** | OpenSearch search engine | artifacts.opensearch.org |

---

## KEY DEPENDENCIES & LIBRARIES

### Core Libraries (Selected)

| Library | Version | Purpose |
|---------|---------|---------|
| **glibc** | 2.34 | GNU C Library |
| **openssl-libs** | 3.0.7 | OpenSSL shared libraries |
| **systemd-libs** | 252 | systemd utility libraries |
| **libcurl** | 7.76.1 | Multi-protocol file transfer library |
| **libxml2** | 2.9.13 | XML parser library |
| **libyaml** | 0.2.5 | YAML parser library |
| **json-c** | 0.14 | JSON implementation in C |
| **pcre2** | 10.40 | Perl-compatible regular expressions v2 |

---

## SECURITY HARDENING PACKAGES

| Package | Version | Purpose |
|---------|---------|---------|
| **usbguard** | 1.1.2-6.el9 | USB device authorization policy framework |
| **aide** | 0.17.4-5.el9 | Advanced Intrusion Detection Environment |
| **rkhunter** | 1.4.6-20.el9 | Rootkit detection tool |
| **fail2ban** | 1.0.2-9.el9 | Brute-force attack protection |

---

## CONTAINER & VIRTUALIZATION (if applicable)

| Package | Version | Purpose |
|---------|---------|---------|
| **podman** | 4.9.4 | Daemonless container engine |
| **buildah** | 1.39.4 | Container image building tool |
| **skopeo** | 1.14.4 | Container image operations |
| **containers-common** | Latest | Common configuration for containers |

---

## COMPLETE PACKAGE LIST

A complete list of all 1,750 installed packages is maintained in:
- **File:** `/tmp/sbom_full.txt` (on dc1.cyberinabox.net)
- **Format:** Package Name | Version | Vendor | Summary
- **Generation Command:** `rpm -qa --qf '%{NAME}|%{VERSION}-%{RELEASE}|%{VENDOR}|%{SUMMARY}\n' | sort`

---

## VULNERABILITY MANAGEMENT

### Scanning Methods

1. **Wazuh Vulnerability Detection**
   - Continuous CVE scanning of installed packages
   - Feed updates: Every 60 minutes
   - Dashboard: Wazuh Manager web interface

2. **DNF Security Updates**
   - Automated daily security updates via dnf-automatic
   - Configuration: /etc/dnf/automatic.conf
   - Apply security updates: Automatic (configured)

3. **OpenSCAP Compliance Scanning**
   - Quarterly compliance scans
   - Profile: NIST 800-171 CUI
   - Reports: /backup/compliance-scans/

### Critical Package Monitoring

The following critical packages are monitored for security updates:
- **Kernel** (5.14.0-570.58.1.el9_6.x86_64)
- **OpenSSL** (3.0.7) - FIPS validated
- **systemd** (252)
- **glibc** (2.34)
- **openssh-server** (8.7p1-38.el9_4.4)
- **httpd** (2.4.57-11.el9_5.1)
- **All security software** (Wazuh, Graylog, FreeIPA components)

---

## LICENSING SUMMARY

### License Types

- **GPL (GNU General Public License):** Most system packages
- **Apache License 2.0:** Wazuh, Graylog, MongoDB, OpenSearch
- **MIT License:** Various libraries and utilities
- **BSD License:** Various networking tools
- **MPL (Mozilla Public License):** Some Firefox/Mozilla components

### Commercial vs Open Source

- **Open Source:** 100% of critical security infrastructure
- **Commercial Support:** Available via Rocky Linux Enterprise support
- **Third-Party:** Wazuh, Graylog, MongoDB (all open-source with commercial support options)

---

## SBOM MAINTENANCE

### Update Schedule

- **Quarterly:** Full SBOM regeneration with SSP review
- **After Major Changes:** Package installations, upgrades, or removals
- **Security Incidents:** If vulnerabilities discovered

### Generation Command

```bash
# Generate complete SBOM
rpm -qa --qf '%{NAME}|%{VERSION}-%{RELEASE}|%{VENDOR}|%{SUMMARY}\n' | sort > /tmp/sbom_$(date +%Y%m%d).txt

# Count total packages
rpm -qa | wc -l

# Show security-critical packages only
rpm -qa | grep -iE "wazuh|graylog|mongo|opensearch|freeipa|389-ds|dovecot|postfix|clamav|yara|audit|selinux"
```

### Change Management

All package changes are tracked via:
1. **DNF history:** `dnf history list`
2. **Audit logs:** `/var/log/audit/audit.log`
3. **Wazuh FIM:** Monitors `/etc/dnf/` and `/var/lib/rpm/`
4. **Graylog:** Centralized dnf.log monitoring

---

## COMPLIANCE & AUDIT

### NIST 800-171 Controls

This SBOM supports the following controls:
- **SR-2:** Supply Chain Risk Management (Software composition transparency)
- **SR-3:** Supply Chain Controls and Processes
- **SR-4:** Provenance (Package vendor and source tracking)
- **SR-5:** Acquisition Strategies (Open-source preference documented)
- **RA-5:** Vulnerability Scanning (Package-level CVE tracking)
- **CM-2:** Baseline Configuration (Software inventory)
- **CM-8:** Information System Component Inventory

### Evidence Collection

This SBOM serves as evidence for:
- C3PAO assessments (CMMC Level 2)
- Security audits
- Incident response investigations
- Configuration management audits
- Supply chain security assessments

---

## DOCUMENT CONTROL

**Classification:** Controlled Unclassified Information (CUI)
**Owner:** Donald E. Shannon, ISSO
**Distribution:** Owner/ISSO, System Administrators, Authorized Auditors, C3PAO Assessors
**Location:** `/home/dshannon/Documents/Claude/Artifacts/Software_Bill_of_Materials.md`
**Backup Location:** `/backup/compliance-scans/SBOM/`
**Next Review:** March 2, 2026 (Quarterly Review)

**Revision History:**

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 12/02/2025 | D. Shannon | Initial SBOM creation. Documents 1,750 packages installed on dc1.cyberinabox.net. Includes critical security software (Wazuh 4.9.2, Graylog 6.0.14, MongoDB 7.0.26, OpenSearch 2.19.4, FreeIPA/389-ds 2.6.1, ClamAV 1.4.3, YARA 4.5.2). Rocky Linux 9.6 with FIPS mode enabled. |

---

## NOTES

1. **Package Count:** 1,750 packages as of December 2, 2025
2. **Update Frequency:** Packages updated daily via dnf-automatic (security updates only)
3. **Repository Sources:** Rocky Linux official repos + EPEL + vendor-specific repos (Wazuh, Graylog, MongoDB, OpenSearch)
4. **FIPS Compliance:** All cryptographic operations use FIPS 140-2 validated modules
5. **Custom Builds:** No custom-compiled software in production (YARA, all from official repositories)
6. **Deprecated Software:** None identified
7. **End-of-Life Software:** None identified (all packages supported under Rocky Linux 9 lifecycle through May 2032)

---

*END OF SOFTWARE BILL OF MATERIALS*
