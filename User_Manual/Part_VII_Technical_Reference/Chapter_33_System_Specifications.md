# Chapter 33: System Specifications

## 33.1 Hardware Specifications

### Server Hardware Overview

**Current Infrastructure:**

```
Total Servers: 6 production systems
Virtualization: VMware/Physical (mixed environment)
Network: 1 Gbps internal, isolated from internet
Storage: Dedicated storage array + local disks
Backup: NAS device with 10TB capacity
```

### Individual System Specifications

**dc1.cyberinabox.net (Domain Controller / FreeIPA)**

```
Role: Primary Domain Controller, DNS, CA, Kerberos KDC
IP Address: 192.168.1.10
Hostname: dc1.cyberinabox.net
FQDN: dc1.cyberinabox.net

Hardware:
  CPU: 4 vCPUs (Intel Xeon equivalent)
  RAM: 8 GB
  Disk: 100 GB (OS + IPA database)
  Network: 1x 1 Gbps NIC

Operating System:
  OS: Rocky Linux 9.5 (Blue Onyx)
  Kernel: 5.14.0-611.16.1.el9_7.x86_64
  Architecture: x86_64
  FIPS Mode: Enabled

Critical Services:
  - FreeIPA (ipa)
  - 389 Directory Server (LDAP)
  - MIT Kerberos (krb5kdc)
  - ISC BIND (named-pkcs11)
  - Dogtag Certificate System (pki-tomcatd)
  - Apache HTTP Server (httpd)
  - Certmonger (certmonger)

Resource Usage (Typical):
  CPU: 15-25% average
  Memory: 4-5 GB used (3 GB free)
  Disk: 45 GB used (55 GB free)
  Network: 5-15 Mbps
```

**dms.cyberinabox.net (Document Management / File Server)**

```
Role: File server, NFS, Samba, Document storage
IP Address: 192.168.1.20
Hostname: dms.cyberinabox.net

Hardware:
  CPU: 4 vCPUs
  RAM: 16 GB
  Disk: 2 TB (1 TB OS, 1 TB data/backups)
  Network: 1x 1 Gbps NIC

Operating System:
  OS: Rocky Linux 9.5
  Kernel: 5.14.0-611.16.1.el9_7.x86_64
  FIPS Mode: Enabled

Critical Services:
  - NFS Server (nfs-server)
  - Samba (smb)
  - Rsync (rsync)
  - Backup Scripts (cron)

Storage Layout:
  /home: 500 GB (user home directories)
  /exports/shared: 300 GB (shared team files)
  /exports/engineering: 200 GB (engineering workspace)
  /datastore/backups: 700 GB (backup storage)

Resource Usage:
  CPU: 10-20% average
  Memory: 8-12 GB used
  Disk: 1.2 TB used (800 GB free)
  Network: 20-50 Mbps (file transfers)
```

**graylog.cyberinabox.net (Log Management)**

```
Role: Centralized logging, Graylog, Elasticsearch, MongoDB
IP Address: 192.168.1.30
Hostname: graylog.cyberinabox.net

Hardware:
  CPU: 8 vCPUs (log processing intensive)
  RAM: 32 GB (Elasticsearch requires high memory)
  Disk: 1.5 TB (log storage)
  Network: 1x 1 Gbps NIC

Operating System:
  OS: Rocky Linux 9.5
  Kernel: 5.14.0-611.16.1.el9_7.x86_64
  FIPS Mode: Enabled

Critical Services:
  - Graylog Server (graylog-server)
  - Elasticsearch 7.x (elasticsearch)
  - MongoDB 6.x (mongod)
  - Rsyslog (rsyslog)

Storage Layout:
  /: 100 GB (OS)
  /var/lib/elasticsearch: 1 TB (Elasticsearch indices)
  /datastore/graylog-archives: 300 GB (compressed archives)

Data Volume:
  Daily Ingestion: ~100 GB compressed logs
  Hot Storage: 90 days (3 TB before compression)
  Retention: 90 days hot, 1 year warm, 7 years cold

Resource Usage:
  CPU: 40-60% average (spikes during indexing)
  Memory: 24-28 GB used (Elasticsearch heap: 16 GB)
  Disk I/O: High (constant log writes)
  Network: 30-100 Mbps (log ingestion)
```

**proxy.cyberinabox.net (Network Proxy / IDS)**

```
Role: Proxy server, Suricata IDS/IPS, Network security
IP Address: 192.168.1.40
Hostname: proxy.cyberinabox.net

Hardware:
  CPU: 4 vCPUs
  RAM: 8 GB
  Disk: 200 GB
  Network: 2x 1 Gbps NICs (bridged for IDS)

Operating System:
  OS: Rocky Linux 9.5
  Kernel: 5.14.0-611.16.1.el9_7.x86_64
  FIPS Mode: Enabled

Critical Services:
  - Suricata (suricata) - IDS/IPS
  - Firewalld (firewalld)
  - Suricata Exporter (custom)

Network Configuration:
  eth0: 192.168.1.40 (management)
  eth1: Bridge mode (traffic inspection)

Suricata Statistics:
  Packets Processed: 8,834,006 (Phase I)
  Data Analyzed: 4.8 GB
  Threats Detected: 502 alerts
  Threats Blocked: 1,247
  Rules Loaded: 32,000+ signatures

Resource Usage:
  CPU: 25-35% average (spikes during attacks)
  Memory: 4-6 GB used
  Disk: 50 GB used (mostly logs)
  Network: 50-200 Mbps (varies with traffic)
```

**monitoring.cyberinabox.net (Monitoring / Metrics)**

```
Role: Prometheus, Grafana, Alertmanager, Exporters
IP Address: 192.168.1.50
Hostname: monitoring.cyberinabox.net

Hardware:
  CPU: 4 vCPUs
  RAM: 8 GB
  Disk: 300 GB
  Network: 1x 1 Gbps NIC

Operating System:
  OS: Rocky Linux 9.5
  Kernel: 5.14.0-611.16.1.el9_7.x86_64
  FIPS Mode: Enabled

Critical Services:
  - Prometheus (prometheus)
  - Grafana (grafana-server)
  - Alertmanager (alertmanager)
  - Node Exporter (node_exporter)
  - Suricata Exporter (suricata_exporter)

Data Retention:
  Prometheus: 30 days of metrics
  Grafana: Persistent dashboards and settings

Resource Usage:
  CPU: 15-25% average
  Memory: 5-6 GB used
  Disk: 80 GB used (metrics data)
  Network: 10-20 Mbps (metrics collection)
```

**wazuh.cyberinabox.net (Security Monitoring / SIEM)**

```
Role: Wazuh Manager, Security Event Management
IP Address: 192.168.1.60
Hostname: wazuh.cyberinabox.net

Hardware:
  CPU: 8 vCPUs (event correlation intensive)
  RAM: 16 GB
  Disk: 500 GB
  Network: 1x 1 Gbps NIC

Operating System:
  OS: Rocky Linux 9.5
  Kernel: 5.14.0-611.16.1.el9_7.x86_64
  FIPS Mode: Enabled

Critical Services:
  - Wazuh Manager (wazuh-manager)
  - Wazuh API (wazuh-api)
  - Wazuh Dashboard (wazuh-dashboard)
  - Filebeat (filebeat)
  - PostgreSQL (postgresql)

Monitoring Coverage:
  - 6 agents deployed (all systems)
  - 110 NIST 800-171 controls monitored
  - File integrity monitoring (AIDE)
  - Vulnerability detection
  - Malware detection (ClamAV + YARA integration)

Resource Usage:
  CPU: 30-45% average
  Memory: 10-12 GB used
  Disk: 200 GB used (alerts and logs)
  Network: 20-40 Mbps (agent communication)
```

## 33.2 Software Specifications

### Operating System Details

**Base Operating System:**

```
Distribution: Rocky Linux 9.5 (Blue Onyx)
Release Date: December 2024
Support: Until May 2032
Kernel: 5.14.0-611.16.1.el9_7.x86_64

Key Features:
  - FIPS 140-2 compliant
  - SELinux enforcing mode
  - Secure Boot enabled (where applicable)
  - Package signing (GPG)
  - Automatic security updates

Package Management:
  Tool: DNF 4.x
  Repositories:
    - baseos
    - appstream
    - extras
    - powertools (CRB)
  Total Packages Installed: ~800-1200 per system
```

### Core Software Versions

**Identity and Access Management:**

```
FreeIPA: 4.11.x
  Components:
    - 389 Directory Server 2.4.x (LDAP)
    - MIT Kerberos 1.21.x
    - SSSD 2.9.x
    - Certmonger 0.79.x
    - Dogtag PKI 11.x
    - ISC BIND 9.16.x (DNSSEC enabled)

Features Enabled:
  - Kerberos SSO
  - Two-factor authentication (OTP/TOTP)
  - DNS with DNSSEC
  - Integrated CA (4096-bit RSA)
  - SUDO rules
  - HBAC rules
```

**Security Monitoring:**

```
Wazuh: 4.8.x
  - Manager: 4.8.0
  - Agent: 4.8.0
  - API: 4.8.0
  - Dashboard: OpenSearch Dashboards 2.x

Suricata: 7.0.x
  - IDS/IPS Mode: IDS (alerts only)
  - Rule Sets: ET Open, ET Pro subset
  - Protocol Support: HTTP, TLS, DNS, SMB, SSH
  - Performance: 1 Gbps line rate

ClamAV: 1.3.x
  - Daily signature updates
  - On-access scanning: Enabled
  - Database: ~9 million signatures

YARA: 4.5.x
  - Custom rules: 50+ patterns
  - Integration: Wazuh + standalone scans
  - Coverage: Executables, scripts, documents

AIDE: 0.18.x
  - Database: /var/lib/aide/aide.db.gz
  - Check frequency: Daily
  - Scope: /etc, /bin, /sbin, /usr/bin, /usr/sbin, /boot
```

**Logging and Monitoring:**

```
Graylog: 5.2.x
  - Elasticsearch: 7.17.x (OpenSearch alternative)
  - MongoDB: 6.0.x
  - Log retention: 90 days hot

Prometheus: 2.48.x
  - Retention: 30 days
  - Scrape interval: 15 seconds
  - Storage: ~500 MB per million samples

Grafana: 10.2.x
  - Authentication: LDAP (FreeIPA)
  - Dashboards: 10 pre-configured
  - Alert channels: Email, webhook

Exporters:
  - Node Exporter: 1.7.x (all systems)
  - Suricata Exporter: Custom (proxy)
  - Process Exporter: 0.7.x (critical services)
```

**Web Services:**

```
Apache HTTP Server: 2.4.57
  - TLS: 1.2, 1.3 only
  - Ciphers: FIPS-compliant suite
  - Modules: mod_ssl, mod_auth_gssapi, mod_wsgi

Nginx: 1.20.x (Grafana proxy)
  - TLS: 1.2, 1.3
  - Reverse proxy configuration
  - Rate limiting enabled

Postfix: 3.5.x
  - TLS: Required for SMTP
  - SASL: GSSAPI authentication
  - Relay: Internal only
```

**Database Systems:**

```
PostgreSQL: 15.x
  - Used by: Wazuh, Grafana
  - TLS: Enabled
  - Authentication: md5, gss
  - Backup: Daily via pg_dump

MongoDB: 6.0.x
  - Used by: Graylog
  - Authentication: SCRAM-SHA-256
  - Replication: Single node (Phase I)
  - Backup: Daily via mongodump

389 Directory Server: 2.4.x
  - Used by: FreeIPA
  - Replication: Single master (Phase I)
  - TLS: Required (LDAPS port 636)
  - Backup: db2ldif + ipa-backup
```

### Development and Automation Tools

```
Python: 3.9.x
  - Standard library
  - Additional packages: requests, pyyaml, jinja2

Bash: 5.1.x
  - Primary scripting language
  - All automation scripts

Git: 2.43.x
  - Documentation version control
  - Configuration management

Ansible: 2.14.x (Phase II)
  - Not yet deployed
  - Planned for configuration management
```

## 33.3 Network Specifications

### Network Architecture

```
Network Type: Isolated internal network
Subnet: 192.168.1.0/24
Gateway: 192.168.1.1
DNS: 192.168.1.10 (dc1)
Broadcast: 192.168.1.255

IP Allocation:
  192.168.1.1-9: Network infrastructure (router, switches)
  192.168.1.10-69: Servers (currently using .10-.60)
  192.168.1.70-199: Reserved for additional servers
  192.168.1.200-249: DHCP pool (workstations)
  192.168.1.250-254: Network management

VLAN Configuration:
  VLAN 1: Default (management)
  VLAN 10: Production servers
  VLAN 20: Workstations (Phase II)
  VLAN 30: DMZ (Phase II)
```

### Network Services

```
DNS:
  Primary: dc1.cyberinabox.net (192.168.1.10)
  Zone: cyberinabox.net
  Reverse Zone: 1.168.192.in-addr.arpa
  DNSSEC: Enabled

DHCP:
  Server: dc1.cyberinabox.net
  Range: 192.168.1.200-249
  Lease Time: 24 hours
  Options: DNS, Gateway, NTP

NTP:
  Server: dc1.cyberinabox.net
  Upstream: pool.ntp.org (when internet available)
  Stratum: 3-4

Firewall:
  Type: firewalld on all systems
  Default Zone: public
  Allowed Services: ssh, https, kerberos, ldaps, nfs, smb
  Custom Rules: Per-system basis
  Logging: Enabled for denied packets
```

### Network Performance

```
Bandwidth:
  Internal: 1 Gbps full-duplex
  Measured throughput: 940 Mbps (TCP)
  Latency: <1ms between systems

Storage Network (if separate):
  Type: NFS over TCP
  Performance: 100-120 MB/s sustained
  Protocol: NFSv4 with Kerberos (sec=krb5)
```

## 33.4 Security Specifications

### Cryptographic Standards

```
FIPS 140-2 Mode: Enabled on all systems
  - Kernel: FIPS mode active
  - OpenSSL: FIPS provider
  - Libraries: FIPS-validated cryptography
  - Verification: fips-mode-setup --check

TLS Configuration:
  Minimum Version: TLS 1.2
  Preferred Version: TLS 1.3
  Cipher Suites: FIPS 140-2 compliant only
  Certificate Key Size: 2048-bit RSA minimum
  Signature Algorithm: SHA-256 or better

SSH Configuration:
  Protocol: SSHv2 only
  Key Exchange: ecdh-sha2-nistp256, diffie-hellman-group14-sha256
  Ciphers: aes256-gcm@openssh.com, aes256-ctr
  MACs: hmac-sha2-256, hmac-sha2-512
  Host Keys: RSA 3072-bit, ED25519

Kerberos Encryption:
  Supported: aes256-cts-hmac-sha1-96, aes128-cts-hmac-sha1-96
  Ticket Lifetime: 8 hours
  Renewable: 7 days
  PKINIT: Enabled (certificate-based authentication)
```

### Access Control

```
Authentication Methods:
  Primary: Kerberos (GSSAPI)
  Secondary: SSH keys
  Fallback: Password (strong passwords required)
  MFA: OTP/TOTP for privileged users

Password Policy:
  Minimum Length: 15 characters
  Complexity: 3 of 4 character classes
  History: 24 passwords
  Max Age: 90 days (standard), 60 days (privileged)
  Lockout: 5 failed attempts, 30 minute lockout

SUDO Configuration:
  Managed via: FreeIPA SUDO rules
  Logging: All sudo commands logged
  Authentication: Required for each command
  Timeout: 5 minutes

SELinux:
  Mode: Enforcing
  Policy: Targeted
  Custom Policies: Minimal (prefer standard labels)
  Audit: All denials logged
```

### Compliance Specifications

```
NIST 800-171 Compliance:
  Controls Implemented: 110/110 (100%)
  Verification: Automated via Wazuh
  Audit Frequency: Continuous
  Reporting: Monthly compliance reports

STIG (Security Technical Implementation Guide):
  Base: RHEL 9 STIG applied where applicable
  Custom Exceptions: Documented in SSP addendums
  Verification: Manual + OpenSCAP scans

Audit Logging:
  auditd: Enabled on all systems
  Log Retention: 1 year local, 7 years archived
  Tamper Protection: Log forwarding to Graylog
  Review Frequency: Daily (automated) + Weekly (manual)

File Integrity:
  Tool: AIDE (Advanced Intrusion Detection Environment)
  Scope: System binaries, configurations
  Check Frequency: Daily
  Alert Threshold: Any change to critical files
```

---

**System Specifications Quick Reference:**

**Server Count:** 6 production systems

**Systems:**
- dc1: FreeIPA/Domain Controller (4 vCPU, 8 GB RAM, 100 GB)
- dms: File Server (4 vCPU, 16 GB RAM, 2 TB)
- graylog: Log Management (8 vCPU, 32 GB RAM, 1.5 TB)
- proxy: IDS/Proxy (4 vCPU, 8 GB RAM, 200 GB)
- monitoring: Prometheus/Grafana (4 vCPU, 8 GB RAM, 300 GB)
- wazuh: SIEM (8 vCPU, 16 GB RAM, 500 GB)

**Operating System:**
- OS: Rocky Linux 9.5
- Kernel: 5.14.0-611.16.1.el9_7.x86_64
- FIPS: Enabled on all systems
- SELinux: Enforcing

**Key Software Versions:**
- FreeIPA: 4.11.x
- Wazuh: 4.8.x
- Suricata: 7.0.x
- Graylog: 5.2.x
- Prometheus: 2.48.x
- Grafana: 10.2.x

**Network:**
- Subnet: 192.168.1.0/24
- Bandwidth: 1 Gbps internal
- DNS: dc1.cyberinabox.net
- Firewall: firewalld (all systems)

**Security:**
- FIPS 140-2: Enabled
- TLS: 1.2/1.3 only
- NIST 800-171: 100% compliant
- Password Min: 15 characters
- Audit: All systems

---

**Related Chapters:**
- Chapter 3: System Architecture
- Chapter 4: Security Baseline
- Chapter 34: Network Topology
- Chapter 35: Software Inventory
- Appendix B: Service URLs & Access Points
- Appendix C: Command Reference

**For Updates:**
- System Administrator: dshannon@cyberinabox.net
- Hardware changes require planning and approval
- Software updates via monthly maintenance window
