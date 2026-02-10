# DC1 Security & System Dashboard Bookmarks

**Server:** dc1.cyberinabox.net (192.168.1.10)
**Created:** December 28, 2025

---

## 🔒 Security Dashboards

### Wazuh Security Platform
**URL:** ~~https://wazuh.cyberinabox.net/~~ (Web Dashboard Not Compatible with FIPS Mode)
**Status:** ✅ Backend Services Running | ❌ Dashboard Incompatible with FIPS
**Purpose:** Security monitoring, threat detection, compliance management

**Current Status:**
- ✅ **Wazuh Manager:** Running and monitoring system (`systemctl status wazuh-manager`)
- ✅ **Wazuh Indexer:** Running and collecting security data (`systemctl status wazuh-indexer`)
- ❌ **Wazuh Dashboard:** NOT COMPATIBLE with FIPS mode (uses MD5 hashing)

**Active Security Monitoring:**
- Security event monitoring
- File integrity monitoring (FIM)
- Vulnerability detection
- Log analysis and correlation
- Suricata IDS/IPS integration (network threat detection)
- CMMC/NIST compliance monitoring

**FIPS Mode Limitation:**
The Wazuh Dashboard web interface (version 4.9.2) is incompatible with FIPS mode due to its use of MD5 hashing in core functionality. This is a known limitation of OpenSearch-based dashboards.

**Alternatives to Access Wazuh Data:**
1. **System Status Dashboard** - https://cyberinabox.net/System_Status_Dashboard.html
   - View Wazuh manager status, FIM, alerts
   - Already working and FIPS-compliant

2. **Wazuh REST API** - Available on dc1
   - Programmatic access to all security data
   - Command line: `curl -k -u admin:admin https://localhost:55000/`

3. **Log Files** - Direct access
   - Manager log: `/var/ossec/logs/ossec.log`
   - Alerts: `/var/ossec/logs/alerts/alerts.log`
   - FIM log: `/var/ossec/logs/ossec.log`

**Future Options:**
- Install dashboard on separate non-FIPS server pointing to dc1's indexer
- Wait for FIPS-compatible Wazuh dashboard release

### Suricata IDS/IPS
**Status:** ✅ Installed and Running
**Purpose:** Network intrusion detection and prevention
**Version:** 7.0.13
**Interface:** eno1 (192.168.1.0/24)
**Rules:** 47,342 signatures loaded (Emerging Threats Open)
**Features:**
- Real-time network traffic analysis
- Deep packet inspection
- Protocol anomaly detection
- Malware detection
- TLS/SSL inspection with JA3 fingerprinting
- Network threat detection and alerting
**Logging:**
- EVE JSON format: `/var/log/suricata/eve.json`
- Fast alerts: `/var/log/suricata/fast.log`
- Statistics: `/var/log/suricata/stats.log`
**Integration:**
- Connected to Wazuh SIEM for alert correlation
- Monitors all traffic on 192.168.1.0/24 network
**Email Alerts:** ✅ Configured and Active
- **Recipient:** dshannon@cyberinabox.net
- **Alert Levels:**
  - Level 7 (Medium): Policy violations, suspicious traffic
  - Level 10 (High): Malware detection, exploit attempts
  - Level 12 (Critical): C&C connections, critical threats - **Always emailed**
- **Special Rules:**
  - Multiple alerts from same source (5+ in 5 minutes) - Emailed
  - Outbound C&C connections - Emailed immediately
  - Critical severity threats - Emailed immediately
- **Alert Configuration:** `/var/ossec/etc/rules/local_rules.xml` (rules 100300-100307)
- **Test:** `curl http://testmynids.org/uid/index.html`
**Management:**
- Service: `systemctl status suricata`
- Update rules: `sudo suricata-update`
- Config: `/etc/suricata/suricata.yaml`
- Email settings: `/var/ossec/etc/ossec.conf`

### FreeIPA - Identity Management
**URL:** https://dc1.cyberinabox.net/ipa/ui
**Purpose:** User and group management, authentication, DNS, certificates
**Login:** admin / Cyber369In@Box
**Features:**
- User and group management
- DNS management
- Certificate authority
- Kerberos authentication
- SUDO rules and HBAC

---

## 🎛️ System Administration Dashboards

### Cockpit - System Management
**URL:** https://dc1.cyberinabox.net:9090
**Purpose:** Web-based system administration interface
**Features:**
- System resource monitoring (CPU, memory, disk, network)
- Service management
- Storage management
- Network configuration
- Terminal access
- Log viewing

### CyberHygiene AI Assistant
**URL:** https://cyberinabox.net/ai-dashboard.html
**Purpose:** AI-powered system assistant and chatbot
**Features:**
- Natural language system queries
- Log analysis
- Network device scanning
- System status checks
- Interactive AI chat interface

### CPM System Status Dashboard
**URL:** https://cyberinabox.net/cpm-dashboard.html
**Purpose:** Comprehensive system status monitoring
**Features:**
- Real-time system metrics
- Service status
- Log file viewing
- Performance graphs
- System health indicators

### System Status Dashboard (AI-Enhanced) ⭐ NEW
**URL:** http://192.168.1.10:5500
**Legacy URL:** https://cyberinabox.net/System_Status_Dashboard.html (auto-redirects to new dashboard)
**Purpose:** Interactive AI-powered system administration and monitoring
**Features:**
- 🤖 **AI Assistant** - Natural language system queries with command execution
- 📊 **Live Metrics** - Real-time CPU, memory, disk, uptime (auto-updating)
- 🔒 **Approval System** - Explicit authorization before any command execution
- 📝 **Audit Trail** - Complete logging of all AI interactions
- ⚡ **Quick Commands** - One-click buttons for common tasks
- **Plus all original features:**
  - Wazuh manager status
  - File integrity monitoring (FIM) status
  - Security agent status
  - Alert statistics
  - Integration status

### CyberHygiene Switchboard
**URL:** https://cyberinabox.net/switchboard.html
**Purpose:** Central dashboard with links to all services
**Features:**
- Quick access to all dashboards
- Service status indicators
- Organized by category (admin, security, collaboration, monitoring)

---

## 📧 Communication & Collaboration

### Roundcube Webmail
**URL:** https://webmail.cyberinabox.net/
**Alternative:** https://dc1.cyberinabox.net/roundcubemail
**Purpose:** Web-based email client
**Login:** dshannon@cyberinabox.net / [your password]
**Features:**
- Read/send emails
- Contact management
- Calendar integration
- Attachment handling

### Nextcloud
**URL:** https://cyberinabox.net/nextcloud
**Purpose:** File sharing and collaboration platform
**Features:**
- File storage and sharing
- Calendar and contacts
- Document collaboration
- Mobile sync

### Redmine Project Management
**URL:** https://projects.cyberinabox.net/
**Purpose:** Project tracking and issue management
**Features:**
- Project management
- Issue tracking
- Wiki documentation
- Time tracking

---

## 📊 Monitoring & Logging

### Grafana
**URL:** https://grafana.cyberinabox.net/
**Status:** ✅ Installed and Running
**Purpose:** Metrics visualization and monitoring
**Login:** admin / [password changed from default]
**Version:** 12.3.1
**Data Sources:** Prometheus (configured)
**Dashboards:**
- **Node Exporter Full**: https://grafana.cyberinabox.net/d/rYdddlPWk/ - Comprehensive system metrics
- **Suricata IDS/IPS**: https://grafana.cyberinabox.net/d/suricata-ids/ - Network security monitoring
**Features:**
- System metrics dashboards
- Network security monitoring
- Performance graphs
- Custom dashboards
- Alerting
- Data source integration

### Prometheus
**URL:** http://127.0.0.1:9091 (local access only)
**Status:** ✅ Installed and Running
**Purpose:** Time-series metrics collection and storage
**Version:** 3.8.1
**Exporters:**
- **Node Exporter** (system metrics) - port 9100
- **Suricata Exporter** (IDS/IPS metrics) - port 9101
**Scrape Interval:** 15 seconds
**Data Retention:** 15 days (default)
**Features:**
- System metrics collection (CPU, memory, disk, network)
- Network security metrics (packets, alerts, flows, protocols)
- Custom metric queries with PromQL
- Integrated with Grafana for visualization
- TSDB storage at /var/lib/prometheus
**Configuration:** /etc/prometheus/prometheus.yml

### Graylog (Referenced - May not be installed)
**URL:** https://graylog.cyberinabox.net
**Status:** ⚠️ DNS not configured
**Purpose:** Log management and analysis
**Features:**
- Centralized log collection
- Log search and analysis
- Alerting
- Compliance reporting

### AI Log Analysis
**URL:** https://cyberinabox.net/ai-dashboard.html?mode=logs
**Purpose:** AI-powered log analysis
**Features:**
- Natural language log queries
- Pattern detection
- Anomaly identification

---

## 🌐 Network & Infrastructure

### pfSense Firewall
**URL:** https://192.168.1.1
**Purpose:** Network firewall and routing
**Features:**
- Firewall rules management
- VPN configuration
- Traffic monitoring
- Network diagnostics

### Ollama AI Server
**URL:** http://192.168.1.7:11434
**Purpose:** Local AI model server
**Features:**
- AI model hosting
- API access for AI queries
- Model management

---

## 📋 Policy & Compliance

### Policy Index (Original)
**URL:** https://cyberinabox.net/policy-index.html
**Purpose:** Security policies and procedures

### Contract Coach Policy Index
**URL:** https://cyberinabox.net/Policy_Index.html
**Purpose:** Comprehensive policy documentation
**Features:**
- NIST 800-171 controls
- CMMC compliance documentation
- Security policies
- Procedures and guidelines

---

## 🔧 Quick Reference URLs

### Most Frequently Used:
```
https://cyberinabox.net/switchboard.html       # Main dashboard
https://dc1.cyberinabox.net:9090               # Cockpit
https://cyberinabox.net/ai-dashboard.html      # AI Assistant
https://webmail.cyberinabox.net/               # Email
https://dc1.cyberinabox.net/ipa/ui             # User Management
```

### Security Monitoring:
```
https://cyberinabox.net/System_Status_Dashboard.html  # Wazuh Status
https://cyberinabox.net/cpm-dashboard.html            # System Status
https://grafana.cyberinabox.net/                      # Grafana Metrics
https://wazuh.cyberinabox.net/                        # Wazuh (dashboard incompatible)
```

### Backup & System Management:
```
~/scripts/menu.sh                               # Backup scripts menu
~/scripts/check-last-backup.sh                  # Check backup status
/root/BACKUP_RESTORE_PROCEDURES.md              # Backup documentation
```

---

## 🔨 Setup Notes

### DNS Records Status:

**✅ Configured:**
- wazuh.cyberinabox.net → 192.168.1.10
- webmail.cyberinabox.net → 192.168.1.10

**⏳ Optional (if needed):**

**Nextcloud (if using separate hostname):**
```bash
sudo ipa dnsrecord-add cyberinabox.net. nextcloud --a-rec=192.168.1.10
```

**Graylog (if installed):**
```bash
sudo ipa dnsrecord-add cyberinabox.net. graylog --a-rec=192.168.1.10
```

### FIPS Mode Incompatibilities:

**Wazuh Dashboard (NOT INSTALLABLE):**
The Wazuh Dashboard web interface is **incompatible with FIPS mode** and cannot be installed on this server.

**Reason:** Uses MD5 hashing in core functionality (OpenSearch saved objects migration)
**Error:** `error:0308010C:digital envelope routines::unsupported`
**Status:** Backend services (manager + indexer) are running and collecting security data
**Workaround:** Use System Status Dashboard at https://cyberinabox.net/System_Status_Dashboard.html

**Alternative:** Install Wazuh dashboard on a separate non-FIPS server and point it to dc1's wazuh-indexer (192.168.1.10:9200)

### Services That May Not Be Installed:
- Graylog (referenced but not configured)

---

## 📱 Mobile Access

All HTTPS dashboards are accessible from mobile devices on the network:
- **iOS/Android:** Use any modern web browser
- **Self-signed certificates:** May require accepting certificate warnings
- **Commercial SSL:** cyberinabox.net domains use valid SSL.com wildcard certificate

---

## 🔐 Security Notes

### Access Control:
- All dashboards require HTTPS
- FreeIPA uses Kerberos authentication
- Cockpit uses PAM authentication
- Webmail uses IMAP authentication

### Network Access:
- Internal network: 192.168.1.0/24
- All services accessible from local network
- External access requires VPN or firewall rules

### Credentials:
- **FreeIPA:** admin / Cyber369In@Box
- **Cockpit:** Use system credentials (dshannon)
- **Webmail:** dshannon@cyberinabox.net / [your password]

---

## 📖 Browser Bookmark Organization

Suggested folder structure for browser bookmarks:

```
📁 CyberHygiene DC1
  📁 Main Dashboards
    🔖 Switchboard
    🔖 AI Assistant
    🔖 Cockpit
  📁 Security
    🔖 Wazuh Status
    🔖 FreeIPA
    🔖 System Status
  📁 Communication
    🔖 Webmail
    🔖 Nextcloud
    🔖 Redmine
  📁 System Admin
    🔖 CPM Dashboard
    🔖 Policy Index
  📁 Network
    🔖 pfSense Firewall
```

---

**Last Updated:** December 28, 2025
**Maintained By:** dshannon
