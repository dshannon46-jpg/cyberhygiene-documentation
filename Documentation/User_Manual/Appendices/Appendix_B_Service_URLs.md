# Appendix B: Service URLs & Access Points

## Primary Dashboards

| Service | URL | Port | Purpose | Authentication |
|---------|-----|------|---------|----------------|
| **CPM Dashboard** | https://cpm.cyberinabox.net | 443 | System overview, compliance status | Username + Password |
| **Wazuh SIEM** | https://wazuh.cyberinabox.net | 443 | Security monitoring, threat detection | Username + Password + MFA |
| **Grafana** | https://grafana.cyberinabox.net | 3001 | System health metrics, performance | Username + Password |
| **Graylog** | https://graylog.cyberinabox.net | 443 | Log analysis and search | Username + Password |

## Administrative Interfaces

| Service | URL | Port | Purpose | Access Level |
|---------|-----|------|---------|--------------|
| **FreeIPA** | https://dc1.cyberinabox.net | 443 | Identity management, self-service | All users |
| **Prometheus** | https://dc1.cyberinabox.net:9091 | 9091 | Metrics backend (advanced users) | Administrators |

## Public Resources

| Service | URL | Purpose | Login Required |
|---------|-----|---------|----------------|
| **Project Website** | https://cyberhygiene.cyberinabox.net | Project info, documentation | No |
| **Roundcube Webmail** | https://mail.cyberinabox.net | Email access | Yes |

## SSH Access Points

| System | Hostname | IP Address | Primary Function |
|--------|----------|------------|------------------|
| **Domain Controller** | dc1.cyberinabox.net | 192.168.1.10 | FreeIPA, DNS, CA, Kerberos |
| **Document Management** | dms.cyberinabox.net | 192.168.1.20 | File shares, backups |
| **Log Management** | graylog.cyberinabox.net | 192.168.1.30 | Centralized logging |
| **Proxy Server** | proxy.cyberinabox.net | 192.168.1.40 | Web proxy, Suricata IDS/IPS |
| **Monitoring** | monitoring.cyberinabox.net | 192.168.1.50 | Prometheus, Grafana |
| **Security** | wazuh.cyberinabox.net | 192.168.1.60 | SIEM, compliance monitoring |

**SSH Connection Examples:**
```bash
# Connect to domain controller
ssh username@dc1.cyberinabox.net

# Connect to file server
ssh username@dms.cyberinabox.net

# Connect using IP address
ssh username@192.168.1.10
```

## File Share Access

### NFS Shares

| Share | Server | Export Path | Mount Point | Authentication |
|-------|--------|-------------|-------------|----------------|
| **Home Directories** | dms.cyberinabox.net | /exports/home | /home | Kerberos |
| **Shared Files** | dms.cyberinabox.net | /exports/shared | /mnt/shared | Kerberos |
| **Backups** | dms.cyberinabox.net | /exports/backups | /mnt/backups | Kerberos (admin only) |

**Mount Command Example:**
```bash
sudo mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared
```

### Samba (SMB/CIFS) Shares

| Share | Server | Share Name | Windows Path | Authentication |
|-------|--------|------------|--------------|----------------|
| **Shared Files** | dms.cyberinabox.net | shared | \\dms.cyberinabox.net\shared | Kerberos/Password |
| **Home Directory** | dms.cyberinabox.net | homes | \\dms.cyberinabox.net\username | Kerberos/Password |

**Windows Mount Example:**
```
Map Network Drive:
\\dms.cyberinabox.net\shared
```

**Linux Mount Example:**
```bash
sudo mount -t cifs //dms.cyberinabox.net/shared /mnt/shared -o credentials=/etc/samba/creds
```

## API Endpoints

### Prometheus API

```
Base URL: https://dc1.cyberinabox.net:9091
API Endpoint: /api/v1/
```

**Example Queries:**
```bash
# Query current CPU usage
curl -k 'https://dc1.cyberinabox.net:9091/api/v1/query?query=node_cpu_seconds_total'

# Query memory usage
curl -k 'https://dc1.cyberinabox.net:9091/api/v1/query?query=node_memory_MemAvailable_bytes'

# List all targets
curl -k 'https://dc1.cyberinabox.net:9091/api/v1/targets' | jq .
```

### Grafana API

```
Base URL: https://grafana.cyberinabox.net
API Endpoint: /api/
Authentication: API Token required
```

**Example:**
```bash
# Get dashboards (requires API token)
curl -H "Authorization: Bearer <api_token>" \
  https://grafana.cyberinabox.net/api/dashboards
```

### FreeIPA API

```
Base URL: https://dc1.cyberinabox.net/ipa
API Endpoint: /session/json
Authentication: Kerberos or session cookie
```

**Example:**
```bash
# Get Kerberos ticket first
kinit admin

# Query user info
curl -k -H "Content-Type: application/json" \
  -H "Referer: https://dc1.cyberinabox.net/ipa" \
  --negotiate -u : \
  -d '{"method":"user_show","params":[["username"],{}]}' \
  https://dc1.cyberinabox.net/ipa/session/json
```

## Network Services

### DNS Servers

| Server | IP Address | Type | Notes |
|--------|------------|------|-------|
| **Primary DNS** | 192.168.1.10 | Authoritative | FreeIPA integrated BIND |
| **Secondary DNS** | (External provider) | Forwarder | Fallback only |

**DNS Testing:**
```bash
# Query internal DNS
dig @192.168.1.10 dc1.cyberinabox.net

# Query using system resolver
nslookup wazuh.cyberinabox.net
```

### NTP (Time Synchronization)

| Server | Purpose | Stratum |
|--------|---------|---------|
| **dc1.cyberinabox.net** | Internal NTP server | 3 |
| **pool.ntp.org** | External time source | 2 |

**NTP Check:**
```bash
# Check time synchronization
timedatectl status

# Query NTP server
ntpq -p
```

### LDAP Directory

| Service | URL | Port | Encryption |
|---------|-----|------|------------|
| **LDAP** | ldap://dc1.cyberinabox.net | 389 | StartTLS |
| **LDAPS** | ldaps://dc1.cyberinabox.net | 636 | SSL/TLS |

**Base DN:** `dc=cyberinabox,dc=net`

**LDAP Query Example:**
```bash
# Search for user
ldapsearch -H ldap://dc1.cyberinabox.net \
  -D "uid=username,cn=users,cn=accounts,dc=cyberinabox,dc=net" \
  -W -b "dc=cyberinabox,dc=net" "(uid=username)"
```

### Kerberos KDC

| Service | Server | Port | Protocol |
|---------|--------|------|----------|
| **KDC** | dc1.cyberinabox.net | 88 | TCP/UDP |
| **Kpasswd** | dc1.cyberinabox.net | 464 | TCP/UDP |
| **Kadmin** | dc1.cyberinabox.net | 749 | TCP |

**Realm:** `CYBERINABOX.NET`

**Get Ticket:**
```bash
kinit username@CYBERINABOX.NET
```

## Monitoring Endpoints

### Prometheus Exporters

| Exporter | System | Port | Metrics |
|----------|--------|------|---------|
| **Node Exporter** | dc1.cyberinabox.net | 9100 | System metrics |
| **Node Exporter** | dms.cyberinabox.net | 9100 | System metrics |
| **Node Exporter** | graylog.cyberinabox.net | 9100 | System metrics |
| **Node Exporter** | proxy.cyberinabox.net | 9100 | System metrics |
| **Node Exporter** | monitoring.cyberinabox.net | 9100 | System metrics |
| **Node Exporter** | wazuh.cyberinabox.net | 9100 | System metrics |
| **Suricata Exporter** | proxy.cyberinabox.net | 9101 | Network security metrics |

**Access Metrics:**
```bash
# View raw metrics
curl http://dc1.cyberinabox.net:9100/metrics
```

### Health Check Endpoints

| Service | URL | Expected Response |
|---------|-----|-------------------|
| **Grafana** | https://grafana.cyberinabox.net/api/health | {"status":"ok"} |
| **Prometheus** | https://dc1.cyberinabox.net:9091/-/healthy | HTTP 200 OK |
| **Wazuh API** | https://wazuh.cyberinabox.net:55000/ | Wazuh API version |

## Email Services

| Service | Server | Port | Protocol | Encryption |
|---------|--------|------|----------|------------|
| **SMTP** | mail.cyberinabox.net | 25 | SMTP | StartTLS |
| **Submission** | mail.cyberinabox.net | 587 | SMTP | StartTLS required |
| **IMAP** | mail.cyberinabox.net | 143 | IMAP | StartTLS |
| **IMAPS** | mail.cyberinabox.net | 993 | IMAP | SSL/TLS |
| **Webmail** | https://mail.cyberinabox.net | 443 | HTTPS | TLS 1.3 |

**Email Client Configuration:**
```
Incoming Mail (IMAP):
  Server: mail.cyberinabox.net
  Port: 993
  Security: SSL/TLS
  Authentication: Normal password

Outgoing Mail (SMTP):
  Server: mail.cyberinabox.net
  Port: 587
  Security: STARTTLS
  Authentication: Normal password
```

## Port Reference

### Commonly Used Ports

| Port | Protocol | Service | Access |
|------|----------|---------|--------|
| **22** | TCP | SSH | Internal + external (rate-limited) |
| **25** | TCP | SMTP | Internal only |
| **53** | TCP/UDP | DNS | Internal + external |
| **80** | TCP | HTTP | Redirects to HTTPS |
| **88** | TCP/UDP | Kerberos | Internal only |
| **123** | UDP | NTP | Internal only |
| **389** | TCP | LDAP | Internal only |
| **443** | TCP | HTTPS | Internal + external |
| **445** | TCP | SMB/CIFS | Internal only |
| **464** | TCP/UDP | Kpasswd | Internal only |
| **587** | TCP | SMTP Submission | Internal + external |
| **636** | TCP | LDAPS | Internal only |
| **993** | TCP | IMAPS | Internal + external |
| **2049** | TCP | NFS | Internal only |
| **3001** | TCP | Grafana | Internal + external |
| **9090** | TCP | Prometheus (standard) | Internal only |
| **9091** | TCP | Prometheus (custom) | Internal + external (restricted) |
| **9100** | TCP | Node Exporter | Internal only |
| **9101** | TCP | Suricata Exporter | Internal only |

### Security Ports (Internal Only)

| Port | Protocol | Service | Purpose |
|------|----------|---------|---------|
| **1514** | TCP | Wazuh Agent | Agent-to-manager communication |
| **1515** | TCP | Wazuh Registration | Agent enrollment |
| **1516** | TCP | Wazuh Cluster | Cluster communication |
| **55000** | TCP | Wazuh API | RESTful API |

## Quick Access Scripts

### SSH Config

Add to `~/.ssh/config`:
```
# CyberHygiene Systems
Host dc1
    HostName dc1.cyberinabox.net
    User your_username

Host dms
    HostName dms.cyberinabox.net
    User your_username

Host graylog
    HostName graylog.cyberinabox.net
    User your_username

Host proxy
    HostName proxy.cyberinabox.net
    User your_username

Host monitoring
    HostName monitoring.cyberinabox.net
    User your_username

Host wazuh
    HostName wazuh.cyberinabox.net
    User your_username

# Global settings for all CyberHygiene systems
Host *cyberinabox.net
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ForwardAgent no
```

**Usage after configuration:**
```bash
ssh dc1    # Instead of ssh username@dc1.cyberinabox.net
ssh dms
ssh wazuh
```

### Browser Bookmarks

**Recommended bookmark organization:**

```
CyberHygiene/
├── Dashboards/
│   ├── CPM Dashboard
│   ├── Wazuh SIEM
│   ├── Grafana
│   └── Graylog
├── Administration/
│   ├── FreeIPA
│   └── Prometheus
└── Resources/
    ├── Project Website
    └── Webmail
```

### Environment Variables

Add to `~/.bashrc` or `~/.profile`:
```bash
# CyberHygiene environment variables
export CYBERHYGIENE_DOMAIN="cyberinabox.net"
export CYBERHYGIENE_DC="dc1.cyberinabox.net"
export CYBERHYGIENE_DMS="dms.cyberinabox.net"
export KRB5_REALM="CYBERINABOX.NET"

# Useful aliases
alias ssh-dc='ssh username@dc1.cyberinabox.net'
alias ssh-dms='ssh username@dms.cyberinabox.net'
alias mount-shared='sudo mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared'
```

---

**Quick Access Summary:**

**For Daily Use:**
- CPM Dashboard: https://cpm.cyberinabox.net
- Grafana: https://grafana.cyberinabox.net
- FreeIPA (password change): https://dc1.cyberinabox.net

**For Security Team:**
- Wazuh: https://wazuh.cyberinabox.net
- Graylog: https://graylog.cyberinabox.net

**For Administrators:**
- Prometheus: https://dc1.cyberinabox.net:9091
- All systems via SSH: port 22

**For Everyone:**
- Project Website: https://cyberhygiene.cyberinabox.net
- Email: https://mail.cyberinabox.net

---

**Related Appendices:**
- Appendix A: Glossary of Terms
- Appendix C: Command Reference
- Appendix E: Contact Information

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 11: Accessing the Network
- Chapter 14: Web Applications & Services

**For Help:**
- System Administrator: dshannon@cyberinabox.net
- Cannot access a service? See Chapter 10: Getting Help & Support
