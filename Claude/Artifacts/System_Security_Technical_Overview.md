# SYSTEM SECURITY TECHNICAL OVERVIEW

**Organization:** The Contract Coach
**System:** CyberHygiene Production Network (cyberinabox.net)
**Classification:** Controlled Unclassified Information (CUI)
**Date Created:** December 2, 2025
**ISSO/Owner:** Donald E. Shannon
**Version:** 1.0

---

## PURPOSE

This technical overview provides a comprehensive guide to the security software products deployed in the CyberHygiene Production Network (CPN), their purpose, configuration, and interactions. This document is intended for:

- System administrators and operators
- Security auditors and C3PAO assessors
- Technical personnel requiring understanding of system architecture
- ISSO for system security planning and incident response

---

## SYSTEM ARCHITECTURE SUMMARY

The CyberHygiene Production Network is a NIST 800-171 compliant environment built on open-source technologies, running in FIPS 140-2 mode on Rocky Linux 9.6. The system is designed to handle Controlled Unclassified Information (CUI) and Federal Contract Information (FCI) for small businesses operating under government contracts.

**Primary Server:** HP MicroServer Gen10 Plus
**Hostname:** dc1.cyberinabox.net
**IP Address:** 192.168.1.10
**Operating System:** Rocky Linux 9.6 (FIPS Mode Enabled)
**Domain:** cyberinabox.net
**Kerberos Realm:** CYBERINABOX.NET

---

## SECURITY PRODUCT INVENTORY

### 1. FREEIPA - IDENTITY & ACCESS MANAGEMENT

**Product:** FreeIPA (Open-source identity management)
**Version:** Latest (Rocky Linux 9 package)
**Primary Function:** Centralized identity, authentication, and authorization
**NIST Controls:** AC-2, AC-3, IA-2, IA-5, IA-8

#### Purpose

FreeIPA provides integrated identity management services, replacing traditional Active Directory for Linux/Unix environments. It manages user accounts, groups, hosts, services, and role-based access control (RBAC) for the entire CPN domain.

#### Key Components

- **389 Directory Server** - LDAP directory service (port 389/636)
- **MIT Kerberos KDC** - Authentication service (port 88)
- **Dogtag Certificate System** - Integrated Certificate Authority
- **BIND DNS** - DNS service (delegated to pfSense in CPN)
- **Apache HTTP Server** - Web management interface (port 443)
- **SSSD** - System Security Services Daemon (client-side authentication)

#### Configuration Details

- **Domain:** cyberinabox.net
- **Realm:** CYBERINABOX.NET
- **LDAP Base DN:** dc=cyberinabox,dc=net
- **Admin User:** admin
- **Password Policy:** NIST 800-171 compliant (14 char minimum, 90-day expiration, 24 password history)
- **Certificate:** SSL.com wildcard certificate (*.cyberinabox.net) - Valid Oct 2025 - Oct 2026
- **Web Interface:** https://dc1.cyberinabox.net/ipa/ui
- **Configuration Files:**
  - `/etc/ipa/` - IPA server configuration
  - `/etc/dirsrv/` - 389 Directory Server configuration
  - `/etc/krb5.conf` - Kerberos client configuration
  - `/var/log/dirsrv/slapd-CYBERINABOX-NET/` - LDAP logs
  - `/var/log/krb5kdc.log` - Kerberos authentication logs

#### Integration Points

- **Wazuh** - Monitors FreeIPA logs (/var/log/dirsrv/, /var/log/krb5kdc.log)
- **Graylog** - Receives FreeIPA syslog events via rsyslog forwarding
- **SSH** - GSSAPI/Kerberos authentication for all domain-joined hosts
- **Postfix/Dovecot** - LDAP authentication for email users
- **NextCloud** - Separated authentication (FIPS limitation)
- **Auditd** - Logs all authentication events to /var/log/audit/audit.log

#### Management Commands

```bash
# Service management
sudo ipactl status           # Check all IPA services
sudo ipactl restart          # Restart all IPA services

# User management
kinit admin                  # Obtain Kerberos ticket
ipa user-add <username>      # Create user
ipa user-mod <username>      # Modify user
ipa user-disable <username>  # Disable account

# Group management
ipa group-add <groupname>    # Create group
ipa group-add-member <group> --users=<user>  # Add user to group

# Password policy
ipa pwpolicy-show            # View current policy
ipa pwpolicy-mod             # Modify password policy
```

---

### 2. WAZUH - SECURITY INFORMATION & EVENT MANAGEMENT (SIEM)

**Product:** Wazuh Open Source SIEM
**Version:** 4.9.2
**Primary Function:** Security monitoring, intrusion detection, compliance scanning
**NIST Controls:** SI-4, AU-2, AU-3, AU-6, SI-7, RA-5

#### Purpose

Wazuh provides comprehensive security monitoring, log analysis, file integrity monitoring (FIM), vulnerability detection, and compliance scanning. It serves as the central security intelligence platform for the CPN.

#### Key Components

- **wazuh-manager** - Central analysis engine
- **wazuh-db** - Database for agent and configuration data
- **wazuh-analysisd** - Log analysis and correlation
- **wazuh-remoted** - Agent communication service (port 1514 TCP)
- **wazuh-authd** - Agent authentication service (port 1515 TCP)
- **wazuh-syscheckd** - File Integrity Monitoring engine
- **wazuh-logcollector** - Log collection service
- **wazuh-integratord** - External integrations (VirusTotal, etc.)
- **wazuh-apid** - REST API service (port 55000)

#### Configuration Details

- **Manager:** dc1.cyberinabox.net (127.0.0.1)
- **Installation Path:** /var/ossec/
- **Configuration:** /var/ossec/etc/ossec.conf
- **Logs:**
  - `/var/ossec/logs/ossec.log` - Manager operational log
  - `/var/ossec/logs/alerts/alerts.log` - Security alerts
  - `/var/ossec/logs/integrations.log` - External integration events
- **Active Agents:** 1 (self-monitoring)
- **FIM Scan Interval:** 12 hours
- **Monitored Paths:** /etc, /usr/bin, /usr/sbin, /bin, /sbin, /boot

#### Integration Points

- **Suricata IDS/IPS** - Receives alerts from pfSense firewall
- **VirusTotal** - API integration for file hash analysis (API key configured)
- **YARA** - Active response for malware scanning (rules_id: 550, 554)
- **Graylog** - Forwards Wazuh alerts to centralized log management
- **Auditd** - Monitors Linux audit logs (/var/log/audit/audit.log)
- **FreeIPA** - Monitors authentication and authorization events
- **OpenSCAP** - Compliance scanning results parsed by Wazuh

#### VirusTotal Integration

- **API Key:** 8c396becab25decda1df853fad94135730294def12b4bf4a22c30911df5bbfd4
- **Group:** syscheck (triggered on file changes)
- **Alert Format:** JSON
- **Purpose:** Multi-engine malware scanning (70+ antivirus engines)
- **Configuration:** /var/ossec/etc/ossec.conf lines 362-367

#### Active Response

- **YARA Scanning:** Triggered on file change alerts (rules 550, 554)
- **Script:** /var/ossec/active-response/bin/yara-scan.sh
- **Location:** Local (runs on manager)
- **Timeout:** Not allowed (runs to completion)

#### Compliance Modules

- **SCA (Security Configuration Assessment)** - NIST 800-171 policy checks
- **Vulnerability Detection** - CVE scanning with 60-minute feed updates
- **Rootcheck** - Rootkit and system anomaly detection (12-hour interval)
- **Syscollector** - System inventory (hardware, OS, network, packages, ports, processes)

#### Management Commands

```bash
# Service management
sudo systemctl status wazuh-manager
sudo /var/ossec/bin/wazuh-control restart
sudo /var/ossec/bin/wazuh-control status

# Agent management
sudo /var/ossec/bin/manage_agents      # Interactive agent management
sudo /var/ossec/bin/agent_control -l   # List connected agents

# Log monitoring
sudo tail -f /var/ossec/logs/ossec.log
sudo tail -f /var/ossec/logs/alerts/alerts.log

# Configuration test
sudo /var/ossec/bin/wazuh-control check
```

---

### 3. GRAYLOG - CENTRALIZED LOG MANAGEMENT

**Product:** Graylog Open Source Log Management
**Version:** 6.0.14
**Primary Function:** Centralized log collection, search, and analysis
**NIST Controls:** AU-2, AU-3, AU-6, AU-7, AU-9

#### Purpose

Graylog provides centralized log management for the entire CPN, aggregating logs from all systems, applications, and security tools into a single searchable repository. It enables long-term log retention, advanced search capabilities, and dashboard visualization.

#### Key Components

- **Graylog Server** - Log processing and web interface (port 9000)
- **MongoDB** - Metadata storage (port 27017)
- **OpenSearch** - Log data indexing and search engine (port 9200)

#### Configuration Details

**Graylog Server:**
- **Version:** 6.0.14
- **Installation Path:** /usr/share/graylog-server/
- **Configuration:** /etc/graylog/server/server.conf
- **Web Interface:** http://dc1.cyberinabox.net:9000
- **Admin Credentials:** admin / admin (⚠️ CHANGE IN PRODUCTION)
- **Password Secret:** 718badd2be465a64bf7b796046743deccae70dd0bae68434383374457d1ff313bf33a0f1d27aaaaa58e08fb1b6a25f03
- **Root Password (SHA2):** 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
- **Syslog Input:** UDP port 1514 (RSYSLOG_SyslogProtocol23Format)
- **Service:** graylog-server.service
- **Logs:** /var/log/graylog-server/
- **Java Workaround:** Uses system OpenJDK 17 instead of bundled JVM (FIPS compatibility)

**MongoDB:**
- **Version:** 7.0.26
- **Installation Path:** /usr/bin/mongod
- **Data Directory:** /var/lib/mongo
- **Configuration:** /etc/mongod.conf
- **Bind Address:** 127.0.0.1:27017
- **Service:** mongod.service
- **Logs:** /var/log/mongodb/mongod.log
- **Purpose:** Stores Graylog metadata (users, streams, dashboards, configuration)

**OpenSearch:**
- **Version:** 2.19.4
- **Installation Path:** /usr/share/opensearch/
- **Data Directory:** /var/lib/opensearch
- **Configuration:** /etc/opensearch/opensearch.yml
- **Cluster Name:** graylog
- **Node Name:** $(hostname)
- **Bind Address:** 127.0.0.1:9200
- **Discovery Type:** single-node
- **Security:** Disabled (localhost-only access)
- **Auto Create Index:** false (managed by Graylog)
- **Service:** opensearch.service
- **Logs:** /var/log/opensearch/
- **Purpose:** Stores and indexes all log data, provides search API

#### Integration Points

- **rsyslog** - System log forwarding (configured via /etc/rsyslog.d/90-graylog.conf)
- **Wazuh** - Security alerts and FIM events
- **FreeIPA** - Authentication and authorization events
- **Auditd** - Linux audit logs
- **Postfix/Dovecot** - Email server logs
- **Apache/httpd** - Web server logs (FreeIPA UI, NextCloud)
- **All System Services** - journald logs forwarded via rsyslog

#### Log Flow Architecture

```
System Logs → journald → rsyslog → Graylog (UDP 1514) → OpenSearch → Web UI (9000)
      ↓
FreeIPA Logs → syslog → rsyslog → Graylog
Wazuh Alerts → syslog → rsyslog → Graylog
Audit Logs → syslog → rsyslog → Graylog
```

#### Management Commands

```bash
# Service management
sudo systemctl status graylog-server
sudo systemctl status mongod
sudo systemctl status opensearch

# Restart services
sudo systemctl restart graylog-server
sudo systemctl restart mongod
sudo systemctl restart opensearch

# View logs
sudo journalctl -u graylog-server -f
sudo journalctl -u mongod -f
sudo journalctl -u opensearch -f

# Test log forwarding
logger -p local0.info "Test message to Graylog"

# Check OpenSearch health
curl -X GET "localhost:9200/_cluster/health?pretty"

# Check Graylog API
curl -u admin:admin -X GET "http://localhost:9000/api/system"
```

---

### 4. SURICATA IDS/IPS (via pfSense)

**Product:** Suricata Intrusion Detection/Prevention System
**Version:** Latest (pfSense package)
**Primary Function:** Network intrusion detection and prevention
**NIST Controls:** SI-4, SC-7

#### Purpose

Suricata provides real-time network traffic analysis and threat detection at the network perimeter. It monitors all inbound and outbound traffic, detecting malicious activity, exploit attempts, and policy violations.

#### Configuration Details

- **Location:** pfSense firewall (192.168.1.1)
- **Mode:** Inline IDS/IPS
- **Interfaces:** WAN, LAN
- **Ruleset:** Emerging Threats (ET) Open + custom rules
- **Alert Destination:** Wazuh SIEM on dc1.cyberinabox.net
- **Update Schedule:** Daily automatic ruleset updates

#### Integration Points

- **Wazuh** - Receives and correlates Suricata alerts
- **Graylog** - Logs forwarded via Wazuh integration
- **pfSense** - Native integration, managed via pfSense web interface

#### Management

- **Access:** https://192.168.1.1 (pfSense web interface)
- **Location:** Services → Suricata

---

### 5. CLAMAV & YARA - MALWARE PROTECTION

**Product:** ClamAV (antivirus) + YARA (pattern matching)
**Versions:** ClamAV 1.4.3, YARA 4.5.2
**Primary Function:** Multi-layered malware detection
**NIST Controls:** SI-3

#### Purpose

Multi-layered malware protection using signature-based (ClamAV) and rule-based (YARA) detection engines. YARA provides FIPS-compatible malware detection, while ClamAV 1.5.x awaits EPEL release for full FIPS support.

#### Components

**YARA (Active - FIPS Compatible):**
- **Version:** 4.5.2
- **Installation:** /usr/bin/yara
- **Rules Location:** /var/ossec/ruleset/yara/
- **Integration:** Wazuh active response (triggered on file changes)
- **Logs:** /var/log/yara.log

**ClamAV (Installed - Awaiting 1.5.x for FIPS):**
- **Version:** 1.4.3 (current), awaiting 1.5.x from EPEL
- **Installation:** /usr/bin/clamscan
- **Definitions:** /var/lib/clamav/
- **Service:** clamd.service (optional)
- **Logs:** /var/log/clamav/clamd.log
- **Status:** Installed but awaiting FIPS-compatible version (see POA&M-014)

#### Compensating Controls (6-Layer Defense)

1. **YARA 4.5.2** - Rule-based malware detection (FIPS-compatible) ✅
2. **VirusTotal API** - 70+ antivirus engines via Wazuh integration ✅
3. **Wazuh FIM** - Behavioral monitoring and file change detection ✅
4. **Vulnerability Scanning** - Continuous CVE detection via Wazuh ✅
5. **Suricata IDS/IPS** - Network-based threat detection ✅
6. **SELinux + Auditd** - Mandatory access control and audit logging ✅

#### Integration Points

- **Wazuh** - YARA active response, VirusTotal integration
- **Graylog** - Malware detection logs centralized
- **SELinux** - Enforces access controls, prevents unauthorized execution

---

### 6. SELINUX & AUDITD - MANDATORY ACCESS CONTROL & AUDIT

**Product:** SELinux (Security-Enhanced Linux) + Linux Audit Daemon
**Versions:** SELinux (kernel-integrated), auditd (Rocky Linux 9 package)
**Primary Function:** Mandatory access control and comprehensive audit logging
**NIST Controls:** AC-3, AC-6, AU-2, AU-3, AU-12

#### Purpose

SELinux provides mandatory access control (MAC) that restricts processes and users to the minimum necessary privileges, even if running as root. Auditd provides comprehensive logging of all security-relevant events for forensic analysis and compliance.

#### SELinux Configuration

- **Mode:** Enforcing (verified via `sestatus`)
- **Policy:** targeted
- **Configuration:** /etc/selinux/config
- **Logs:** /var/log/audit/audit.log (AVC denials)
- **Tools:**
  - `sestatus` - Check SELinux status
  - `ausearch -m avc` - Search for denials
  - `sealert -a /var/log/audit/audit.log` - Analyze denials

#### Auditd Configuration

- **Rules:** OSPP v42 (Operating System Protection Profile)
- **Configuration:** /etc/audit/auditd.conf
- **Rules Directory:** /etc/audit/rules.d/
- **Log File:** /var/log/audit/audit.log
- **Log Rotation:** Automatic when size limit reached
- **Retention:** 30+ days minimum (NIST requirement)
- **Monitored Events:**
  - File access and modification
  - Authentication attempts (success/failure)
  - Privilege escalation (sudo, su)
  - Network connections
  - System calls

#### Integration Points

- **Wazuh** - Parses and correlates audit logs
- **Graylog** - Stores audit logs for long-term retention
- **FreeIPA** - Audit events for authentication/authorization

---

### 7. NEXTCLOUD - FILE SHARING

**Product:** NextCloud
**Version:** 28.0.0.11
**Primary Function:** Secure cloud file storage and sharing
**NIST Controls:** AC-3, AC-6, SC-8, SC-28

#### Purpose

NextCloud provides secure cloud-based file storage and sharing for CUI data, with FIPS-compliant encryption and granular access controls.

#### Configuration Details

- **Access URL:** https://dc1.cyberinabox.net
- **Authentication:** Local (separated from FreeIPA due to Samba FIPS incompatibility)
- **PHP Version:** 8.1.32 (FIPS-compatible)
- **Data Directory:** /var/www/html/nextcloud/data (LUKS encrypted)
- **Encryption:** FIPS 140-2 compliant, LUKS full-disk encryption
- **Transport Security:** HTTPS with HSTS
- **Configuration:** /var/www/html/nextcloud/config/config.php

#### Integration Points

- **Graylog** - Web server access logs (/var/log/httpd/)
- **Wazuh** - FIM monitoring of NextCloud directories
- **Apache** - Serves NextCloud over HTTPS

#### Note on Samba

Samba file sharing was found FIPS-incompatible (NT_STATUS_BAD_TOKEN_TYPE with Kerberos in FIPS mode). NextCloud serves as the FIPS-compliant alternative. Kerberos remains fully operational for all other services (FreeIPA, SSH, workstation authentication).

---

### 8. POSTFIX & DOVECOT - EMAIL SERVER

**Product:** Postfix (SMTP) + Dovecot (IMAP/POP3)
**Versions:** Latest Rocky Linux 9 packages
**Primary Function:** Secure email services with LDAP authentication
**NIST Controls:** SC-8, SC-13, SI-3

#### Purpose

Provides secure email services for the CPN with FreeIPA LDAP authentication and TLS encryption.

#### Configuration Details

**Postfix (SMTP):**
- **Service:** postfix.service
- **Port:** 25 (SMTP with TLS)
- **Configuration:** /etc/postfix/main.cf
- **Authentication:** LDAP via FreeIPA
- **TLS:** Enabled (smtpd_tls_security_level = may)
- **Certificate:** /var/lib/ipa/certs/httpd.crt
- **Logs:** /var/log/maillog

**Dovecot (IMAP/POP3):**
- **Service:** dovecot.service
- **Ports:** 993 (IMAPS), 995 (POP3S)
- **Configuration:** /etc/dovecot/dovecot.conf
- **Authentication:** LDAP via FreeIPA
- **TLS:** Required
- **Certificate:** /var/lib/ipa/certs/httpd.crt
- **Logs:** /var/log/maillog

#### Integration Points

- **FreeIPA** - LDAP authentication for email users
- **Graylog** - Centralized email logs
- **Wazuh** - Monitors email server security events

#### Enhancements Pending (POA&M-002E)

- DNS records (SPF, DKIM, DMARC)
- Rspamd anti-spam filtering
- OpenDKIM email signing
- Roundcube webmail interface
- Port 587 submission with TLS
- ClamAV integration (when FIPS-compatible version available)

---

### 9. OPENSCAP - COMPLIANCE SCANNING

**Product:** OpenSCAP (Security Compliance Scanner)
**Version:** Latest (Rocky Linux 9 package)
**Primary Function:** Automated NIST 800-171 compliance scanning
**NIST Controls:** CA-2, CA-7, RA-5

#### Purpose

OpenSCAP provides automated compliance scanning against NIST 800-171 CUI profile, generating detailed reports and remediation scripts.

#### Configuration Details

- **Profile:** xccdf_org.ssgproject.content_profile_cui
- **Content:** /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
- **Scan Frequency:** Quarterly (per POA&M-011)
- **Reports:** /backup/compliance-scans/
- **Format:** HTML + XML

#### Usage

```bash
# Run compliance scan
sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --results /backup/compliance-scans/oscap-results-$(date +%Y%m%d).xml \
    --report /backup/compliance-scans/oscap-report-$(date +%Y%m%d).html \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# Generate remediation script
sudo oscap xccdf generate fix \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --output /root/remediation.sh \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

#### Integration Points

- **Wazuh** - Parses OpenSCAP results for compliance monitoring
- **Graylog** - Stores scan results and events
- **POA&M** - Scan findings tracked in POA&M items

---

### 10. REAR - BACKUP & RECOVERY

**Product:** Relax-and-Recover (ReaR)
**Version:** Latest (EPEL package)
**Primary Function:** Bare-metal disaster recovery and backup
**NIST Controls:** CP-9, CP-10

#### Purpose

ReaR provides automated bare-metal backup and disaster recovery capabilities, creating bootable ISO images and full system backups.

#### Configuration Details

- **Configuration:** /etc/rear/local.conf
- **Backup Location:** /backup/rear/
- **Schedule:** Weekly full backup, daily incremental (via cron)
- **Last Full Backup:** November 15, 2025 02:00 UTC
- **Encryption:** LUKS encrypted partition
- **Recovery Media:** ISO available in /backup/rear/
- **Logs:** /var/log/rear/

#### Integration Points

- **Graylog** - Backup job logs centralized
- **Wazuh** - Monitors backup completion and failures

---

## SYSTEM INTERACTION MAP

```
┌─────────────────────────────────────────────────────────────────┐
│                    USER/WORKSTATION                              │
│         (SSH, Web Browser, Email Client)                        │
└────────────┬────────────────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    pfSense FIREWALL                              │
│        Suricata IDS/IPS (192.168.1.1)                           │
└────────────┬────────────────────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────────────────────┐
│              dc1.cyberinabox.net (192.168.1.10)                 │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ FREEIPA (Identity & Access Management)                   │  │
│  │ • LDAP (389 Directory Server)                            │  │
│  │ • Kerberos (MIT KDC)                                     │  │
│  │ • Certificate Authority                                  │  │
│  │ • Web Interface (Apache/httpd)                           │  │
│  └────┬─────────────────────────────────────────────────┬───┘  │
│       │                                                   │      │
│       ▼                                                   ▼      │
│  ┌─────────────────────────┐     ┌─────────────────────────┐   │
│  │ WAZUH SIEM              │     │ POSTFIX/DOVECOT        │   │
│  │ • Manager/Analysisd     │     │ • SMTP (Postfix)       │   │
│  │ • File Integrity (FIM)  │────▶│ • IMAP/POP3 (Dovecot)  │   │
│  │ • Vulnerability Scan    │     │ • LDAP Auth            │   │
│  │ • VirusTotal API        │     └─────────────────────────┘   │
│  │ • YARA Integration      │                                    │
│  │ • SCA Compliance        │                                    │
│  └────┬────────────────────┘                                    │
│       │                                                          │
│       ▼                                                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ GRAYLOG (Centralized Logging)                            │  │
│  │ ┌────────────────┐  ┌──────────────┐  ┌──────────────┐  │  │
│  │ │ Graylog Server │  │   MongoDB    │  │  OpenSearch  │  │  │
│  │ │   (Port 9000)  │─▶│ (Port 27017) │  │ (Port 9200)  │  │  │
│  │ │   Web UI/API   │  │   Metadata   │  │  Log Storage │  │  │
│  │ └────────────────┘  └──────────────┘  └──────────────┘  │  │
│  │         ▲                                                 │  │
│  │         │ rsyslog (UDP 1514)                            │  │
│  └─────────┼─────────────────────────────────────────────────┘  │
│            │                                                     │
│  ┌─────────┴──────────────────────────────────────────────┐    │
│  │ RSYSLOG (Log Forwarding)                               │    │
│  │ • System logs (journald)                               │    │
│  │ • FreeIPA logs                                         │    │
│  │ • Wazuh logs                                           │    │
│  │ • Audit logs                                           │    │
│  │ • Application logs                                     │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ SECURITY CONTROLS                                        │  │
│  │ • SELinux (Mandatory Access Control)                     │  │
│  │ • Auditd (Comprehensive Audit Logging)                   │  │
│  │ • FIPS 140-2 Mode (Cryptographic Standards)              │  │
│  │ • LUKS (Full Disk Encryption)                            │  │
│  │ • Firewalld (Host-based Firewall)                        │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ APPLICATION SERVICES                                     │  │
│  │ • NextCloud (File Sharing)                               │  │
│  │ • ReaR (Backup & Recovery)                               │  │
│  │ • OpenSCAP (Compliance Scanning)                         │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## AUTHENTICATION & AUTHORIZATION FLOW

1. **User Login Attempt** (SSH, Web, Email):
   - Client requests service access
   - Service redirects to Kerberos KDC (via FreeIPA)
   - User provides credentials

2. **Kerberos Authentication**:
   - FreeIPA Kerberos KDC validates credentials against LDAP directory
   - On success, issues Ticket Granting Ticket (TGT)
   - Client caches TGT for subsequent service requests

3. **Authorization Check**:
   - Service requests Service Ticket from KDC using TGT
   - KDC checks LDAP group membership and RBAC rules
   - Issues Service Ticket if authorized

4. **Access Granted**:
   - Service validates Service Ticket
   - User gains access based on group membership and permissions
   - Session established

5. **Audit Trail**:
   - Authentication event logged to `/var/log/krb5kdc.log`
   - Authorization decision logged to `/var/log/dirsrv/.../access`
   - Service access logged to `/var/log/secure`
   - All events forwarded to Wazuh and Graylog
   - Auditd captures system-level events

---

## LOG FLOW & CORRELATION

1. **Log Generation**:
   - All services generate logs (syslog, application logs)
   - Auditd captures system-level security events
   - Wazuh generates security alerts and FIM events

2. **Local Storage**:
   - Logs written to `/var/log/` directories
   - Auditd logs to `/var/log/audit/audit.log`
   - Wazuh logs to `/var/ossec/logs/`

3. **Centralization**:
   - rsyslog forwards all logs to Graylog (UDP 1514)
   - Graylog processes and indexes logs in OpenSearch
   - Metadata stored in MongoDB

4. **Analysis & Correlation**:
   - Wazuh analyzes logs in real-time
   - Correlates events across multiple sources
   - Generates security alerts based on rules

5. **Visualization & Search**:
   - Graylog Web UI provides search interface
   - Wazuh provides security-focused dashboards
   - Long-term retention in OpenSearch

6. **Compliance & Forensics**:
   - 30+ day retention for NIST compliance
   - Searchable archive for incident investigation
   - Evidence collection for audits

---

## SECURITY MONITORING WORKFLOW

1. **Event Detection**:
   - **Network Level:** Suricata IDS/IPS detects threats
   - **Host Level:** Wazuh FIM detects file changes
   - **Application Level:** Log analysis detects anomalies
   - **User Level:** Auditd logs all user actions

2. **Alert Generation**:
   - Suricata forwards alerts to Wazuh
   - Wazuh correlates events and generates alerts
   - High-severity alerts trigger active response (YARA scan)

3. **Incident Investigation**:
   - ISSO reviews alerts in Wazuh
   - Searches Graylog for related events
   - Analyzes audit logs for user actions
   - Determines scope and impact

4. **Response Actions**:
   - Active response scripts (YARA scan, account disable)
   - Manual investigation and containment
   - Incident logging per TCC-IRP-001
   - DoD 72-hour reporting if CUI incident

5. **Remediation & Recovery**:
   - Apply security patches (dnf-automatic)
   - Update firewall rules (pfSense)
   - Restore from backup if needed (ReaR)
   - Update POA&M with lessons learned

---

## COMPLIANCE AUTOMATION

### Continuous Compliance Monitoring

- **Wazuh SCA:** Runs policy checks against NIST 800-171 controls
- **OpenSCAP:** Quarterly automated scans
- **FIM:** Detects unauthorized configuration changes
- **Vulnerability Scanning:** Continuous CVE detection with 60-min feed updates

### Evidence Collection

- **Audit Logs:** 30+ day retention in Graylog
- **Compliance Reports:** OpenSCAP HTML/XML reports in /backup/compliance-scans/
- **System Configuration:** Baseline tracked in Git
- **Policy Documents:** Stored in /backup/personnel-security/policies/

### Automated Remediation

- **Security Patches:** dnf-automatic applies security updates daily
- **Configuration Drift:** Wazuh FIM alerts on unauthorized changes
- **Malware Detection:** YARA active response automatically scans suspicious files

---

## FIPS 140-2 CRYPTOGRAPHIC COMPLIANCE

All cryptographic operations use FIPS 140-2 validated modules:

- **Kernel Crypto API:** Linux kernel FIPS mode enabled
- **OpenSSL:** FIPS 140-2 validated cryptographic library
- **LUKS:** Full-disk encryption using FIPS-approved algorithms
- **SSH:** FIPS-compliant cipher suites only
- **TLS/HTTPS:** FIPS-compliant cipher suites for web services
- **Kerberos:** FIPS-approved encryption types

### FIPS Verification

```bash
# Check FIPS mode
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled  # Must return 1

# Verify kernel boot parameter
cat /proc/cmdline | grep fips      # Must show fips=1
```

---

## TROUBLESHOOTING GUIDE

### FreeIPA Issues

**Services won't start:**
```bash
# Check disk space
df -h

# Check SELinux denials
sudo ausearch -m avc -ts recent
sudo sealert -a /var/log/audit/audit.log

# Check service logs
sudo journalctl -xe -u ipa
sudo tail -f /var/log/dirsrv/slapd-CYBERINABOX-NET/errors
```

**Kerberos authentication failures:**
```bash
# Check time synchronization (must be within 5 minutes)
chronyc tracking

# Regenerate Kerberos ticket
kdestroy
kinit admin
```

### Wazuh Issues

**Manager won't start:**
```bash
# Check configuration syntax
sudo /var/ossec/bin/wazuh-control check

# Verify file ownership (must be wazuh:wazuh)
ls -la /var/ossec/etc/ossec.conf

# Fix ownership if needed
sudo chown -R wazuh:wazuh /var/ossec

# Check logs
sudo tail -f /var/ossec/logs/ossec.log
```

### Graylog Issues

**Server won't start:**
```bash
# Check Java path (FIPS workaround)
grep JAVA /etc/sysconfig/graylog-server  # Should be JAVA=/usr/bin/java

# Check MongoDB and OpenSearch
sudo systemctl status mongod
sudo systemctl status opensearch

# Check logs
sudo journalctl -u graylog-server -f
```

**No logs received:**
```bash
# Test rsyslog forwarding
logger -p local0.info "Test message to Graylog"

# Check Graylog input
curl -u admin:admin "http://localhost:9000/api/system/inputs"

# Verify port listening
sudo ss -tulpn | grep 1514
```

### SELinux Denials

```bash
# Find recent denials
sudo ausearch -m avc -ts recent

# Analyze denials
sudo sealert -a /var/log/audit/audit.log

# Generate policy module (if legitimate)
sudo ausearch -m avc -ts recent | audit2allow -M mypolicy
sudo semodule -i mypolicy.pp
```

---

## MAINTENANCE SCHEDULE

### Daily
- Review Wazuh security alerts
- Monitor Graylog for anomalies
- Verify backup completion (ReaR)
- Check system health (CPU, disk, memory)

### Weekly
- Review audit logs in Graylog
- Full system backup (ReaR)
- Vulnerability scan results review (Wazuh)

### Monthly
- Apply non-security updates (dnf update)
- User access review (FreeIPA groups)
- POA&M progress review

### Quarterly
- OpenSCAP compliance scan
- SSP review and update
- Disaster recovery testing
- Facility security inspection

### Annually
- Security assessment/penetration testing
- Incident response tabletop exercise
- All policy document reviews
- Annual risk assessment

---

## CRITICAL FILE LOCATIONS

### Configuration Files

| Service | Configuration File | Description |
|---------|-------------------|-------------|
| FreeIPA | /etc/ipa/ | IPA server configuration |
| LDAP | /etc/dirsrv/ | 389 Directory Server |
| Kerberos | /etc/krb5.conf | Kerberos client config |
| Wazuh | /var/ossec/etc/ossec.conf | Manager configuration |
| Graylog | /etc/graylog/server/server.conf | Graylog server settings |
| MongoDB | /etc/mongod.conf | MongoDB configuration |
| OpenSearch | /etc/opensearch/opensearch.yml | OpenSearch settings |
| Postfix | /etc/postfix/main.cf | SMTP configuration |
| Dovecot | /etc/dovecot/dovecot.conf | IMAP/POP3 configuration |
| NextCloud | /var/www/html/nextcloud/config/config.php | NextCloud settings |
| rsyslog | /etc/rsyslog.d/90-graylog.conf | Log forwarding config |
| SELinux | /etc/selinux/config | SELinux mode/policy |
| Auditd | /etc/audit/auditd.conf | Audit daemon config |

### Log Files

| Service | Log Location | Description |
|---------|-------------|-------------|
| FreeIPA LDAP | /var/log/dirsrv/slapd-CYBERINABOX-NET/ | Directory server logs |
| Kerberos | /var/log/krb5kdc.log | Authentication logs |
| Wazuh | /var/ossec/logs/ | All Wazuh logs |
| Graylog | /var/log/graylog-server/ | Graylog server logs |
| MongoDB | /var/log/mongodb/mongod.log | Database logs |
| OpenSearch | /var/log/opensearch/ | Search engine logs |
| Auditd | /var/log/audit/audit.log | System audit events |
| System | /var/log/messages | General system log |
| Security | /var/log/secure | Authentication events |
| Mail | /var/log/maillog | Email server logs |

### Data Directories

| Service | Data Location | Description |
|---------|--------------|-------------|
| FreeIPA | /var/lib/ipa/ | IPA data and certificates |
| LDAP | /var/lib/dirsrv/ | Directory database |
| Wazuh | /var/ossec/ | Wazuh installation |
| Graylog | /var/lib/graylog-server/ | Graylog data |
| MongoDB | /var/lib/mongo/ | Database files |
| OpenSearch | /var/lib/opensearch/ | Index data |
| NextCloud | /var/www/html/nextcloud/data/ | User files (encrypted) |
| Backups | /backup/ | ReaR backups, compliance scans |

---

## NETWORK PORTS REFERENCE

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| HTTP | 80 | TCP | FreeIPA web (redirects to HTTPS) |
| HTTPS | 443 | TCP | FreeIPA/NextCloud web UI |
| LDAP | 389 | TCP | Directory service |
| LDAPS | 636 | TCP | LDAP over TLS |
| Kerberos | 88 | TCP/UDP | Authentication |
| Kerberos Admin | 464 | TCP/UDP | Password changes |
| SMTP | 25 | TCP | Email submission |
| IMAPS | 993 | TCP | Secure IMAP |
| POP3S | 995 | TCP | Secure POP3 |
| Wazuh Agent | 1514 | TCP | Agent communication |
| Wazuh Auth | 1515 | TCP | Agent enrollment |
| Wazuh API | 55000 | TCP | REST API |
| Graylog Web | 9000 | TCP | Web interface |
| Graylog Syslog | 1514 | UDP | Log ingestion |
| MongoDB | 27017 | TCP | Database (localhost) |
| OpenSearch | 9200 | TCP | Search API (localhost) |

---

## DOCUMENT CONTROL

**Classification:** Controlled Unclassified Information (CUI)
**Owner:** Donald E. Shannon, ISSO
**Distribution:** Owner/ISSO, System Administrators, Authorized Auditors
**Location:** /home/dshannon/Documents/Claude/Artifacts/System_Security_Technical_Overview.md
**Next Review:** March 2, 2026 (Quarterly)

**Revision History:**

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 12/02/2025 | D. Shannon | Initial creation - comprehensive technical overview of all security products and their interactions |

---

*END OF SYSTEM SECURITY TECHNICAL OVERVIEW*
