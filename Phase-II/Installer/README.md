# CyberHygiene Phase II Automated Installer

**Version:** 2.0
**Updated:** January 29, 2026
**Purpose:** Automated deployment system for CyberHygiene security platform
**Compliance:** NIST 800-171

[![Sponsor](https://img.shields.io/badge/Sponsor-%E2%9D%A4-ff69b4?logo=githubsponsors&logoColor=white)](https://github.com/sponsors/The-CyberHygiene-Project)
---

## Quick Start

### Prerequisites
1. HP Proliant DL 20 Gen10 Plus (or equivalent) server
2. Rocky Linux 9.5 installed with FIPS mode enabled
3. Completed `installation_info.md` form
4. (Optional) SSL certificates for domain
5. Internet access for package downloads

### Installation Steps

```bash
# 1. Navigate to installer directory
cd "/home/admin/Documents/Installer"

# 2. Complete the installation information form
cp installation_info_template.md installation_info.md
nano installation_info.md
# Fill in all fields (replace all ___ placeholders)

# 3. Run the master installation script
sudo ./master_install.sh
```

That's it! The script will guide you through the rest.

---

## What Gets Installed

### Core Infrastructure
- **FreeIPA** - Identity management, DNS, Kerberos, Certificate Authority
- **Samba** - File sharing with Kerberos authentication
- **SSL Certificates** - Domain wildcard certificate deployment

### Security Monitoring (SIEM)
- **Wazuh** - Security monitoring, File Integrity Monitoring, compliance
- **Graylog** - Centralized log management (MongoDB + OpenSearch)
- **Suricata** - Network Intrusion Detection System (IDS)
- **YARA** - Malware detection and scanning

### Endpoint Protection
- **fapolicyd** - Application whitelisting (NIST 800-171 3.4.8)
- **USBGuard** - USB device access control (NIST 800-171 3.1.21)

### Monitoring & Visualization
- **Prometheus** - Metrics collection
- **Grafana** - Dashboard visualization
- **SysAdmin Agent** - AI-assisted administration dashboard (Streamlit + Ollama)

---

## Installation Process

1. System prerequisites check
2. Variable generation from installation form
3. System state backup
4. FreeIPA domain controller installation
5. DNS configuration
6. SSL certificate deployment
7. Samba file sharing setup
8. Graylog log management (MongoDB + OpenSearch)
9. Suricata network IDS
10. Prometheus metrics collection
11. Grafana visualization
12. Wazuh SIEM platform
13. fapolicyd application whitelisting
14. USBGuard USB security
15. YARA malware detection
16. SysAdmin Agent Dashboard
17. Backup configuration
18. Policy deployment
19. Documentation customization
20. Final system verification

---

## Directory Structure

```
Installer/
├── master_install.sh              # Main installation script
├── installation_info.md           # Customer data (YOU FILL THIS OUT)
├── installation_info_template.md  # Blank template
├── install_vars.sh                # Generated variables (created automatically)
├── CREDENTIALS_*.txt              # Generated passwords (KEEP SECURE!)
├── README.md                      # This file
├── scripts/                       # Installation modules
│   ├── 00_prerequisites_check.sh  # System requirements verification
│   ├── 01_generate_variables.sh   # Parse installation form
│   ├── 02_backup_system.sh        # Pre-install backup
│   ├── 10_install_freeipa.sh      # FreeIPA domain controller
│   ├── 11_configure_dns.sh        # DNS records
│   ├── 12_deploy_ssl_certs.sh     # SSL certificates
│   ├── 20_install_samba.sh        # File sharing
│   ├── 30_install_graylog.sh      # Log management (MongoDB + OpenSearch)
│   ├── 40_install_suricata.sh     # Network IDS
│   ├── 50_install_prometheus.sh   # Metrics collection
│   ├── 51_install_grafana.sh      # Visualization
│   ├── 60_install_wazuh.sh        # SIEM platform
│   ├── 61_install_fapolicyd.sh    # Application whitelisting
│   ├── 62_install_usbguard.sh     # USB device control
│   ├── 63_install_yara.sh         # Malware detection
│   ├── 65_install_sysadmin_agent.sh # AI dashboard
│   ├── 70_configure_backup.sh     # Backup automation
│   ├── 80_deploy_policies.sh      # Security policies
│   ├── 90_customize_documentation.sh # Customer docs
│   └── 99_final_verification.sh   # Comprehensive testing
├── templates/                     # Configuration templates
├── logs/                          # Installation logs (created automatically)
└── backups/                       # System backups (created automatically)
```

---

## Command Line Options

### Dry Run (Test Mode)
Test the installation without making changes:
```bash
sudo ./master_install.sh --dry-run
```

### Install Specific Service
Install only one service (requires FreeIPA already installed):
```bash
sudo ./master_install.sh --service=wazuh
sudo ./master_install.sh --service=graylog
sudo ./master_install.sh --service=fapolicyd
```

### Skip Backups
Skip system backup creation (not recommended):
```bash
sudo ./master_install.sh --skip-backups
```

---

## Installation Modules

### Module 00: Prerequisites Check
- Verifies system meets requirements
- Checks FIPS mode, SELinux, disk space, memory
- Validates installation form completion

### Module 01: Generate Variables
- Parses `installation_info.md`
- Creates `install_vars.sh` with all configuration
- Generates secure passwords
- Creates credentials file

### Module 02: Backup System
- Backs up current system state
- Saves package list, configurations
- Creates restore point

### Module 10: Install FreeIPA
- **Most critical component**
- Installs domain controller
- Configures DNS, Kerberos, LDAP, CA
- Creates initial DNS records
- Sets password policies

### Module 11: Configure DNS
- Additional DNS configuration
- Creates service records (Graylog, Wazuh, Grafana)
- Sets up CNAME records
- Tests resolution

### Module 12: Deploy SSL Certificates
- Installs wildcard SSL certificate
- Options: Customer-provided, FreeIPA CA, Let's Encrypt
- Verifies certificate validity
- Installs to system-wide locations

### Module 20: Install Samba
- File sharing server
- Integrated with FreeIPA Kerberos
- Creates shared directories
- Enables Windows file sharing

### Module 30: Install Graylog
**NIST 800-171 Control:** 3.3.1, 3.3.2 (Audit & Accountability)

- Installs MongoDB 7.x for metadata storage
- Installs OpenSearch 2.x for log indexing
- Installs Graylog 6.x server
- Configures syslog inputs (TCP/UDP 514)
- Sets up GELF inputs (TCP/UDP 12201)
- Enables Beats input (5044)

**Ports:**
- 9000/tcp - Web UI
- 514/tcp,udp - Syslog
- 5044/tcp - Beats
- 12201/tcp,udp - GELF

### Module 40: Install Suricata
**NIST 800-171 Control:** 3.14.6, 3.14.7 (System & Info Integrity)

- Network Intrusion Detection System
- Downloads and updates rule sets
- Configures network interface monitoring
- Integrates with Wazuh for alerts

### Module 50: Install Prometheus
- Metrics collection and time-series database
- Node exporter for system metrics
- Service discovery for monitored endpoints

### Module 51: Install Grafana
- Dashboard visualization platform
- Pre-configured dashboards for system monitoring
- Integration with Prometheus data source

### Module 60: Install Wazuh
**NIST 800-171 Control:** 3.3.1, 3.3.2, 3.14.6, 3.14.7

- Wazuh Indexer (OpenSearch-based)
- Wazuh Manager (agent coordination, rules engine)
- Wazuh Dashboard (web interface)
- **CRITICAL:** Includes SELinux context fix for Node.js binaries
- Configures fapolicyd trust entries

**Ports:**
- 5601/tcp - Dashboard (HTTPS)
- 9200/tcp - Indexer API
- 1514/tcp,udp - Agent connection
- 55000/tcp - Wazuh API

**Features:**
- File Integrity Monitoring (FIM)
- Log Analysis & Correlation
- Vulnerability Detection
- Security Configuration Assessment
- Rootkit Detection
- Active Response

### Module 61: Install fapolicyd
**NIST 800-171 Control:** 3.4.8 (Application Whitelisting)

- File Access Policy Daemon
- Blocks unauthorized executables
- Integrates with RPM package trust
- Pre-configures trust for Wazuh node binaries
- Sets SELinux context for Wazuh Dashboard

**Key Files:**
- `/etc/fapolicyd/fapolicyd.conf` - Main configuration
- `/etc/fapolicyd/fapolicyd.trust` - Trusted files database
- `/var/lib/fapolicyd/data/trust.db` - Compiled trust database

### Module 62: Install USBGuard
**NIST 800-171 Control:** 3.1.21 (Portable Storage)

- USB device access control
- Generates initial policy from connected devices
- Blocks unauthorized USB devices by default
- Audit logging of USB events

**Key Files:**
- `/etc/usbguard/usbguard-daemon.conf` - Daemon configuration
- `/etc/usbguard/rules.conf` - Device allow/block rules

### Module 63: Install YARA
**NIST 800-171 Control:** 3.14.2 (Malicious Code Protection)

- YARA malware detection engine
- Custom rules for ransomware indicators
- Web shell detection rules
- Cryptocurrency miner detection
- Automated daily scanning via systemd timer

**Key Files:**
- `/etc/yara/rules.d/` - YARA rule files
- `/etc/yara/yara-scan.sh` - Scan script
- `/var/log/yara/` - Scan results

### Module 65: Install SysAdmin Agent
- AI-assisted system administration dashboard
- Streamlit web interface
- Ollama local LLM backend (llama3.2:3b)
- System monitoring overview
- Service status dashboard
- Security status display
- Quick links to all management interfaces

**Access:** `https://dc1.domain.com/sysadmin/`

### Module 70: Configure Backup
- Automated backup scheduling
- Encryption configuration
- Retention policies

### Module 80: Deploy Policies
- Security policy deployment
- NIST 800-171 compliance settings

### Module 90: Customize Documentation
- Customer-specific documentation
- Handoff materials preparation

### Module 99: Final Verification
- Comprehensive testing of all services
- NIST 800-171 compliance verification
- System resource checks
- Generates detailed verification report

**Tests Include:**
- FIPS mode enabled
- SELinux enforcing
- Firewall active
- All services running (FreeIPA, Wazuh, Graylog, Suricata, etc.)
- fapolicyd trust database
- USBGuard rules
- YARA rules installed
- SSL certificate validity
- Disk space and memory availability

---

## Web Interfaces After Installation

| Service | URL | Default User |
|---------|-----|--------------|
| FreeIPA | https://dc1.domain.com/ipa/ui/ | admin |
| Wazuh Dashboard | https://dc1.domain.com:5601 | admin |
| Graylog | http://dc1.domain.com:9000 | admin |
| Grafana | http://dc1.domain.com:3000 | admin |
| Prometheus | http://dc1.domain.com:9090 | - |
| SysAdmin Agent | https://dc1.domain.com/sysadmin/ | - |

---

## Important Files Generated

### `install_vars.sh`
Contains all configuration variables extracted from installation form.

**Key Variables:**
- `DOMAIN` - Customer domain name
- `REALM` - Kerberos realm
- `BUSINESS_NAME` - Company name
- `SUBNET` - Network subnet
- `DS_PASSWORD` - Directory Server password
- `ADMIN_PASSWORD` - FreeIPA admin password

### `CREDENTIALS_YYYYMMDD.txt`
Contains all generated passwords for the installation.

**Contents:**
- FreeIPA Directory Manager password
- FreeIPA Admin password
- Wazuh admin password
- Graylog admin password
- Grafana admin password
- GRUB bootloader password
- Backup encryption key
- Server IP addresses
- Access URLs

---

## Troubleshooting

### Wazuh Dashboard fails to start (exit code 126)

**Symptom:** `systemctl status wazuh-dashboard` shows "Permission denied" for node binary.

**Cause:** SELinux blocks execution of Node.js binaries with incorrect context.

**Solution:**
```bash
# Fix SELinux context for node binaries
chcon -t bin_t /usr/share/wazuh-dashboard/node/bin/node
chcon -t bin_t /usr/share/wazuh-dashboard/node/fallback/bin/node

# Make permanent
semanage fcontext -a -t bin_t "/usr/share/wazuh-dashboard/node(/.*)?/bin/node"
restorecon -Rv /usr/share/wazuh-dashboard/node/

# Also add to fapolicyd trust
fapolicyd-cli --file add /usr/share/wazuh-dashboard/node/bin/node
fapolicyd-cli --file add /usr/share/wazuh-dashboard/node/fallback/bin/node
fapolicyd-cli --update

# Restart services
systemctl restart fapolicyd
systemctl restart wazuh-dashboard
```

### fapolicyd blocks application execution

**Symptom:** Applications fail with "Operation not permitted" in audit log.

**Solution:**
```bash
# Check what's being blocked
ausearch -m FANOTIFY -ts recent

# Add trust for specific binary
fapolicyd-cli --file add /path/to/binary

# Update trust database
fapolicyd-cli --update

# Restart service
systemctl restart fapolicyd
```

### Graylog web interface not accessible

**Solution:**
```bash
# Check all dependent services
systemctl status mongod
systemctl status opensearch
systemctl status graylog-server

# Check Graylog logs
journalctl -u graylog-server -n 50

# Verify OpenSearch is responding
curl http://localhost:9200

# Verify Graylog API
curl http://localhost:9000/api/system/lbstatus
```

### FreeIPA installation fails

**Common causes:**
- Hostname not set correctly (must be FQDN)
- Firewall blocking ports
- Insufficient memory

**Solution:**
```bash
# Check hostname
hostname -f  # Must return FQDN like dc1.domain.com

# Verify firewall
firewall-cmd --list-all

# Check FreeIPA logs
tail -100 /var/log/ipaserver-install.log
```

### SELinux denials

**Solution:**
```bash
# Check for denials
ausearch -m AVC -ts recent

# Generate policy module (if needed)
audit2allow -a -M mymodule
semodule -i mymodule.pp

# DO NOT disable SELinux - fix the policy instead
```

---

## Post-Installation Steps

### 1. Review Verification Report
Check `VERIFICATION_REPORT_YYYYMMDD.txt` for any failures.

### 2. Change Default Passwords
All services are installed with default or generated passwords. Change immediately:
- Wazuh Dashboard (admin/admin by default)
- Graylog (from CREDENTIALS file)
- Grafana (admin/admin by default)

### 3. Configure Wazuh Agents
Deploy Wazuh agents to monitored systems:
```bash
# On client systems
curl -so wazuh-agent.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.x.x-1.x86_64.rpm
rpm -ivh wazuh-agent.rpm
/var/ossec/bin/agent-auth -m dc1.domain.com
systemctl enable --now wazuh-agent
```

### 4. Configure Log Sources in Graylog
1. Access Graylog web UI (port 9000)
2. Navigate to System > Inputs
3. Create Syslog UDP input on port 514
4. Configure clients to send logs

### 5. Test All Services
```bash
# Run verification again
sudo /path/to/scripts/99_final_verification.sh
```

---

## NIST 800-171 Compliance Mapping

| Control | Description | Implementation |
|---------|-------------|----------------|
| 3.1.1 | Limit system access | FreeIPA access control |
| 3.1.21 | Portable storage | USBGuard |
| 3.3.1 | Create audit records | Graylog, Wazuh |
| 3.3.2 | Audit record content | Graylog log parsing |
| 3.4.8 | Application whitelisting | fapolicyd |
| 3.5.1 | Identification | FreeIPA/Kerberos |
| 3.5.2 | Authentication | FreeIPA/Kerberos |
| 3.13.1 | Communications protection | Firewall, SSL/TLS |
| 3.14.2 | Malicious code protection | YARA, Wazuh |
| 3.14.6 | Monitor security events | Wazuh, Suricata |
| 3.14.7 | Identify unauthorized use | Wazuh alerts |

---

## Service Management Commands

```bash
# FreeIPA
ipactl status
ipactl restart

# Wazuh
systemctl status wazuh-manager wazuh-indexer wazuh-dashboard

# Graylog
systemctl status mongod opensearch graylog-server

# Security tools
systemctl status suricata fapolicyd usbguard

# Monitoring
systemctl status prometheus grafana-server

# SysAdmin Agent
systemctl status sysadmin-agent ollama
```

---

## Version History

**v2.0 - January 29, 2026**
- Added Graylog 6.x with MongoDB 7.x and OpenSearch 2.x
- Added Suricata IDS for network monitoring
- Added Prometheus and Grafana for metrics
- Added Wazuh SIEM with critical SELinux fix
- Added fapolicyd application whitelisting
- Added USBGuard USB device control
- Added YARA malware detection
- Added SysAdmin Agent Dashboard (Streamlit + Ollama)
- Updated verification script for all new components
- Comprehensive NIST 800-171 compliance coverage

**v1.0 - January 1, 2026**
- Initial release
- Core modules: Prerequisites, Variables, Backup, FreeIPA, DNS, SSL, Samba, Verification
- Automated installation framework
- Password generation and management
- Comprehensive logging and error handling

## Support This Project

Your help makes a real difference for small defense contractors facing CMMC/NIST hurdles.

- **In-kind contributions** (our top need): Ansible refactoring for the custom ISO, penetration testing, documentation, or testing on varied hardware → Open an Issue or PR!
- **Financial support**: Help offset development costs (hardware, time, presentation travel) via [GitHub Sponsors ❤️](https://github.com/sponsors/The-CyberHygiene-Project)

Thank you to all current and future sponsors and contributors!---

## License & Credits

**CyberHygiene Phase II Automated Installer**
For: Small business NIST 800-171 compliance

**Open Source Components:**
- FreeIPA (Identity Management)
- Wazuh (SIEM)
- Graylog (Log Management)
- Suricata (Network IDS)
- Prometheus/Grafana (Monitoring)
- fapolicyd (Application Whitelisting)
- USBGuard (USB Security)
- YARA (Malware Detection)
- Ollama (Local LLM)
- Streamlit (Dashboard Framework)
- Rocky Linux (Operating System)

---

**For questions or issues, refer to the installation logs and verification report.**
