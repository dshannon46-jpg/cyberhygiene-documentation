# Chapter 36: Service Catalog

## 36.1 Core Services

### Authentication Services (dc1.cyberinabox.net)

**Kerberos KDC (Key Distribution Center):**
```
Service: krb5kdc
Port: 88 (TCP/UDP)
Purpose: Issue authentication tickets
Availability: 24/7 critical
Uptime Target: 99.9%

Configuration: /var/kerberos/krb5kdc/kdc.conf
Realm: CYBERINABOX.NET
Ticket Lifetime: 8 hours
Renewable: 7 days
Encryption Types: aes256-cts, aes128-cts

Dependencies: None (standalone)
Clients: All systems and users
```

**LDAP Directory Service:**
```
Service: dirsrv@CYBERINABOX-NET
Port: 389 (LDAP), 636 (LDAPS - preferred)
Purpose: User/group directory, configuration storage
Protocol: LDAPv3
TLS: Required (LDAPS on 636)

Base DN: dc=cyberinabox,dc=net
Bind DN: cn=Directory Manager
Replication: Single master (Phase I)

Users: cn=users,cn=accounts,dc=cyberinabox,dc=net
Groups: cn=groups,cn=accounts,dc=cyberinabox,dc=net
Computers: cn=computers,cn=accounts,dc=cyberinabox,dc=net

Max Connections: 1024
Idle Timeout: 3600 seconds
```

**DNS Service:**
```
Service: named-pkcs11 (BIND with DNSSEC)
Port: 53 (TCP/UDP)
Purpose: Name resolution, service discovery
Zone: cyberinabox.net

Forward Zone: /var/named/data/cyberinabox.net.zone
Reverse Zone: /var/named/data/1.168.192.in-addr.arpa.zone
DNSSEC: Enabled, auto-signing
Dynamic Updates: Kerberos-secured (GSS-TSIG)

Forwarders: 8.8.8.8, 1.1.1.1 (when internet available)
Recursion: Enabled for internal only
Query Rate Limit: 100/second per client
```

**Certificate Authority:**
```
Service: pki-tomcatd@pki-tomcat (Dogtag PKI)
Port: 8080 (HTTP), 8443 (HTTPS)
Purpose: Issue and manage certificates

CA Subject: CN=Certificate Authority,O=IPA.CYBERINABOX.NET
Key Size: 4096-bit RSA
Validity: 20 years
CRL Distribution: http://dc1.cyberinabox.net/ipa/crl/MasterCRL.bin

Certificate Types:
  - Server certificates (2048-bit RSA, 2 years)
  - User certificates (2048-bit RSA, 1 year)
  - Service certificates (2048-bit RSA, 2 years)

Auto-Renewal: Enabled via certmonger
```

**FreeIPA Web UI:**
```
Service: httpd (Apache)
Port: 443 (HTTPS)
URL: https://dc1.cyberinabox.net
Purpose: Web-based administration interface

Authentication: Kerberos (SPNEGO), form-based
TLS: TLS 1.2/1.3, FIPS ciphers
Session Timeout: 20 minutes

Features:
  - User/group management
  - SUDO rule configuration
  - HBAC rule management
  - DNS management
  - Certificate management
  - Password self-service
```

## 36.2 Security Services

### Wazuh SIEM (wazuh.cyberinabox.net)

**Wazuh Manager:**
```
Service: wazuh-manager
Port: 1514 (Agent communication, TCP)
Purpose: Security event collection and correlation

Agents: 6 connected (all systems)
Rules: 3,000+ detection rules
Decoders: 500+ log parsers
Alert Levels: 0-15 (configurable thresholds)

Email Alerts: Level 10+ (to security@cyberinabox.net)
Log Retention: 90 days (alerts), 30 days (raw logs)
Database: PostgreSQL (alert storage)
```

**Wazuh API:**
```
Service: wazuh-api
Port: 55000 (HTTPS)
Purpose: RESTful API for management

Authentication: API tokens
TLS: Required
Rate Limiting: 100 requests/minute per token

Common Operations:
  - Agent management
  - Rule queries
  - Alert retrieval
  - Configuration updates
```

**Wazuh Dashboard:**
```
Service: wazuh-dashboard (OpenSearch Dashboards)
Port: 443 (HTTPS)
URL: https://wazuh.cyberinabox.net
Purpose: Security visualization and investigation

Authentication: Internal users + LDAP (planned)
Session Timeout: 30 minutes
Concurrent Users: 10 (recommended)

Dashboards:
  - Security Events Overview
  - Compliance (NIST 800-171)
  - File Integrity Monitoring
  - Vulnerability Detection
  - Threat Hunting
```

### Suricata IDS/IPS (proxy.cyberinabox.net)

**Suricata Service:**
```
Service: suricata
Mode: IDS (alert only, not blocking - Phase I)
Interface: eth1 (mirror/span port)
Purpose: Network intrusion detection

Rule Sets:
  - Emerging Threats Open (ET Open): 32,000+ rules
  - Custom rules: 50+ local patterns
  Update Frequency: Daily (via suricata-update)

Performance:
  - Throughput: 1 Gbps line rate
  - Packet Processing: 8.8M+ packets analyzed
  - Alerts: 502 detected (Phase I)
  - Blocks: 1,247 (when IPS mode enabled - Phase II)

Alert Output:
  - Fast log: /var/log/suricata/fast.log
  - EVE JSON: /var/log/suricata/eve.json
  - Forward to: Graylog (syslog) + Wazuh (file monitoring)
```

**Suricata Exporter:**
```
Service: suricata_exporter
Port: 9101 (HTTP)
Purpose: Export metrics to Prometheus

Metrics Exposed:
  - Packet capture statistics
  - Alert counts by severity
  - Protocol distribution
  - Dropped packet counts
  - Memory/CPU usage
```

### Malware Detection

**ClamAV Antivirus:**
```
Service: clamd@scan
Socket: /var/run/clamd.scan/clamd.sock
Purpose: On-access virus scanning

Signature Database: ~9 million signatures
Update Frequency: Daily (via freshclam)
Scan Mode: On-access + scheduled

Scheduled Scans:
  - Full system: Weekly (Sunday 01:00)
  - Home directories: Daily (03:00)
  - Downloads: Hourly

Integration: Wazuh monitors for detections
```

**YARA Pattern Matching:**
```
Service: Custom scripts + Wazuh integration
Purpose: Advanced malware detection

Rules Location: /var/lib/yara/rules/
Rule Count: 50+ custom patterns
Scan Frequency: Daily (02:00)

Coverage:
  - Executable files (.exe, .elf, .so)
  - Scripts (.sh, .py, .js, .ps1)
  - Documents (.pdf, .docx with macros)
  - Archives (.zip, .tar with suspicious content)

Alert: Via Wazuh (level 12 for matches)
```

**AIDE File Integrity:**
```
Service: aide (scheduled via cron)
Purpose: Detect unauthorized file changes

Database: /var/lib/aide/aide.db.gz
Update Frequency: Daily (04:00)
Report: Email to admin@cyberinabox.net

Monitored Paths:
  /etc (configuration files)
  /bin, /sbin (system binaries)
  /usr/bin, /usr/sbin (user binaries)
  /boot (kernel and initramfs)

Attributes Checked:
  - Permissions
  - Ownership (user/group)
  - Size
  - Modification time
  - SHA256 checksum
  - File type
  - SELinux context
```

## 36.3 Logging and Monitoring Services

### Graylog (graylog.cyberinabox.net)

**Graylog Server:**
```
Service: graylog-server
Port: 9000 (Web UI, HTTP)
URL: https://graylog.cyberinabox.net
Purpose: Centralized log management

Inputs:
  - Syslog UDP: Port 514
  - Syslog TCP: Port 1514 (reliable delivery)
  - GELF: Port 12201 (structured logging)

Data Volume:
  - Ingestion: ~100 GB/day compressed
  - Storage: 90 days hot (3 TB)
  - Archive: 1 year warm, 7 years cold

Features:
  - Full-text search
  - Real-time dashboards
  - Alert conditions
  - Stream routing
  - Field extractors
```

**Elasticsearch:**
```
Service: elasticsearch
Port: 9200 (HTTP, localhost only)
Purpose: Log storage and indexing

Cluster Name: graylog
Node Name: graylog-0
Heap Size: 16 GB (50% of system memory)

Indices:
  - Naming: graylog_YYYYMMDD
  - Shards: 1 primary, 0 replicas (single node)
  - Retention: 90 days (automatic deletion)
  - Snapshot: Daily to /datastore/backups/
```

**MongoDB:**
```
Service: mongod
Port: 27017 (localhost only)
Purpose: Graylog configuration storage

Database: graylog
Collections: ~50 (streams, users, dashboards, etc.)
Backup: Daily via mongodump
Size: ~500 MB
```

### Prometheus (monitoring.cyberinabox.net)

**Prometheus Server:**
```
Service: prometheus
Port: 9091 (HTTP)
URL: http://monitoring.cyberinabox.net:9091
Purpose: Time-series metrics database

Scrape Interval: 15 seconds
Retention: 30 days
Storage: ~500 MB per million samples

Targets:
  - All systems: Node Exporter (port 9100)
  - proxy: Suricata Exporter (port 9101)
  - Self: Prometheus metrics (port 9091)

Alert Rules: /etc/prometheus/rules/*.yml
Alertmanager: http://localhost:9093

Common Metrics:
  - node_cpu_seconds_total
  - node_memory_MemAvailable_bytes
  - node_filesystem_avail_bytes
  - node_network_receive_bytes_total
  - suricata_alerts_total
```

**Grafana:**
```
Service: grafana-server
Port: 3001 (HTTP)
URL: https://grafana.cyberinabox.net
Purpose: Metrics visualization

Authentication: LDAP (FreeIPA)
Session Timeout: 30 minutes
Data Sources: Prometheus (default)

Dashboards:
  1. Node Exporter Full (system metrics)
  2. Suricata IDS/IPS (network security)
  3. YARA Malware Detection (endpoint security)
  4. System Overview (multi-system)
  5. Disk Space Monitoring
  6. Network Traffic Analysis
  7. Service Health Status
  8. Alert Overview
  9. Backup Status
  10. Certificate Expiration

Users: All authenticated via LDAP
Roles: Viewer (default), Editor, Admin
```

**Alertmanager:**
```
Service: alertmanager
Port: 9093 (HTTP)
Purpose: Alert routing and deduplication

Alert Sources: Prometheus
Receivers:
  - Email: admin@cyberinabox.net
  - Webhook: (Phase II - integration with ticketing)

Alert Grouping: By alertname and severity
Repeat Interval: 4 hours
Silence Support: Yes (temporary alert muting)
```

## 36.4 File Sharing Services

### NFS Server (dms.cyberinabox.net)

**NFS Service:**
```
Service: nfs-server
Port: 2049 (TCP)
Protocol: NFSv4
Security: Kerberos (sec=krb5)

Exports: /etc/exports.d/shares.exports
  /exports/shared:
    Path: /exports/shared
    Size: 300 GB
    Access: All authenticated users (rw)
    Security: sec=krb5

  /exports/engineering:
    Path: /exports/engineering
    Size: 200 GB
    Access: Engineering group (rw)
    Security: sec=krb5

  /exports/home:
    Path: /exports/home
    Size: 500 GB
    Purpose: User home directories
    Security: sec=krb5,root_squash

Permissions: Unix (chmod/chown)
Backup: Daily to /datastore/backups/
```

**Samba/CIFS Service:**
```
Service: smb, nmb
Port: 139, 445 (TCP)
Protocol: SMB 2.1, 3.0, 3.1.1 (SMB1 disabled)
Security: Kerberos authentication

Shares: /etc/samba/smb.conf
  [shared]:
    Path: /exports/shared
    Browseable: Yes
    Read Only: No
    Valid Users: @ipausers

  [engineering]:
    Path: /exports/engineering
    Valid Users: @engineering
    Read Only: No

Workgroup: CYBERINABOX
NetBIOS Name: DMS
WINS Support: No (DNS used)
```

## 36.5 Communication Services

### Email (Postfix)

**Postfix MTA:**
```
Service: postfix
Port: 25 (SMTP), 587 (Submission)
Purpose: Internal mail relay, notifications

Relay Host: None (direct delivery for internal)
Auth: SASL (GSSAPI for Kerberos)
TLS: Required for SMTP connections

Usage:
  - System notifications
  - Alert emails (Wazuh, Grafana, backup reports)
  - User email (via Roundcube)

Daily Volume: ~100-200 messages
Queue: /var/spool/postfix
Logs: /var/log/maillog
```

**Roundcube Webmail:**
```
Service: httpd (PHP-FPM)
Port: 443 (HTTPS)
URL: https://mail.cyberinabox.net
Purpose: Webmail interface

Backend: Dovecot IMAP (local)
SMTP: Postfix (localhost:587)
Authentication: FreeIPA (LDAP)

Features:
  - Send/receive email
  - Folder management
  - Filters/rules
  - Address book
  - HTML/plain text

Max Attachment: 25 MB
Session Timeout: 30 minutes
```

## 36.6 Support Services

### Time Synchronization

**NTP Service:**
```
Service: chronyd
Port: 123 (UDP)
Purpose: Network time synchronization

Upstream: pool.ntp.org (when internet available)
Local Stratum: 3-4
Client Access: Restricted to 192.168.1.0/24

Accuracy: ±50ms typical
Clients: All internal systems
Config: /etc/chrony.conf
```

### DHCP (Phase II)

**DHCP Service (planned):**
```
Service: dhcpd
Port: 67 (UDP)
Purpose: Dynamic IP assignment

Range: 192.168.1.200-249
Lease Time: 24 hours
DNS Server: 192.168.1.10 (dc1)
Gateway: 192.168.1.1

Reservations: For critical workstations
Options: DNS, gateway, NTP, domain name
```

---

**Service Catalog Quick Reference:**

**Critical Services (24/7):**
- Kerberos KDC (dc1:88) - Authentication
- LDAP (dc1:636) - Directory
- DNS (dc1:53) - Name resolution
- Wazuh Manager (wazuh:1514) - Security monitoring

**Web Interfaces:**
- FreeIPA: https://dc1.cyberinabox.net
- Wazuh: https://wazuh.cyberinabox.net
- Grafana: https://grafana.cyberinabox.net
- Graylog: https://graylog.cyberinabox.net
- Webmail: https://mail.cyberinabox.net

**Monitoring:**
- Prometheus: monitoring:9091
- Grafana: monitoring:3001
- Node Exporter: all systems:9100
- Suricata Exporter: proxy:9101

**File Sharing:**
- NFS: dms:2049 (sec=krb5)
- Samba: dms:445 (Kerberos auth)

**Security:**
- Suricata IDS: proxy (passive monitoring)
- ClamAV: All systems (on-access scanning)
- YARA: All systems (daily scans)
- AIDE: All systems (daily integrity checks)

---

**Related Chapters:**
- Chapter 33: System Specifications
- Chapter 34: Network Topology
- Chapter 37: API & Integrations
- Appendix B: Service URLs & Access Points

**For Help:**
- Service issues: dshannon@cyberinabox.net
- Service catalog updates: Document changes
- New service requests: Email administrator
