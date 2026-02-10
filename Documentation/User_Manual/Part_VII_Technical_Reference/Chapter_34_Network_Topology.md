# Chapter 34: Network Topology

## 34.1 Network Overview

### Physical Network Layout

```
CyberHygiene Production Network
Internal Isolated Network: 192.168.1.0/24

                    [Router/Firewall]
                     192.168.1.1
                          |
                ┌─────────┴─────────┐
                |   Core Switch     |
                |   (1 Gbps)        |
                └─────────┬─────────┘
                          |
        ┌─────────────────┼─────────────────┬─────────────────┐
        |                 |                 |                 |
        |                 |                 |                 |
   [Server VLAN 10]  [Management]     [Workstations]    [Storage]
   192.168.1.10/24   192.168.1.1-9   192.168.1.200/24   (NAS)
        |
        ├─── dc1.cyberinabox.net (.10)
        ├─── dms.cyberinabox.net (.20)
        ├─── graylog.cyberinabox.net (.30)
        ├─── proxy.cyberinabox.net (.40)
        ├─── monitoring.cyberinabox.net (.50)
        └─── wazuh.cyberinabox.net (.60)
```

### Network Segments

**Production Servers (VLAN 10):**
```
Subnet: 192.168.1.0/24
Range: 192.168.1.10-69
Purpose: Production server infrastructure

Systems:
  - dc1.cyberinabox.net (192.168.1.10) - Domain Controller
  - dms.cyberinabox.net (192.168.1.20) - File Server
  - graylog.cyberinabox.net (192.168.1.30) - Log Management
  - proxy.cyberinabox.net (192.168.1.40) - Proxy/IDS
  - monitoring.cyberinabox.net (192.168.1.50) - Monitoring
  - wazuh.cyberinabox.net (192.168.1.60) - SIEM

Access: Restricted to administrators and authorized systems
Firewall: Strict rules, deny by default
```

**Management Network:**
```
Range: 192.168.1.1-9
Purpose: Network infrastructure management

Devices:
  - Router/Firewall: 192.168.1.1
  - Core Switch: 192.168.1.2
  - Backup NAS: 192.168.1.5

Access: Administrator only
```

**Workstation Network (Phase II):**
```
Subnet: 192.168.1.200-249
Purpose: User workstations (DHCP)
Status: Planned for Phase II

Features:
  - DHCP-assigned addresses
  - VLAN isolation from servers
  - Internet access via proxy (when configured)
  - Wazuh agent deployment
```

## 34.2 Server Connectivity Matrix

### Network Connections

**dc1.cyberinabox.net (192.168.1.10):**

```
Inbound Connections (Allowed):
  Port 22 (SSH):
    From: All internal systems
    Protocol: TCP
    Authentication: Kerberos + SSH keys

  Port 53 (DNS):
    From: All internal systems
    Protocol: UDP/TCP
    Purpose: Name resolution

  Port 88 (Kerberos):
    From: All internal systems
    Protocol: UDP/TCP
    Purpose: Authentication tickets

  Port 389/636 (LDAP/LDAPS):
    From: All internal systems
    Protocol: TCP
    Purpose: Directory queries
    Note: 636 (LDAPS) preferred, TLS required

  Port 443 (HTTPS):
    From: All internal + administrators
    Protocol: TCP
    Purpose: FreeIPA Web UI

  Port 464 (Kerberos kadmin):
    From: Administrators only
    Protocol: UDP/TCP
    Purpose: Password changes

Outbound Connections:
  Port 123 (NTP):
    To: pool.ntp.org (when internet available)
    Purpose: Time synchronization

  Port 443 (HTTPS):
    To: Red Hat servers (updates)
    Purpose: Software updates

  Port 9091 (Prometheus):
    To: monitoring.cyberinabox.net
    Purpose: Metrics export (Node Exporter on 9100)
```

**dms.cyberinabox.net (192.168.1.20):**

```
Inbound Connections:
  Port 22 (SSH):
    From: Administrators
    Protocol: TCP

  Port 111, 2049 (NFS):
    From: All authenticated systems
    Protocol: TCP/UDP
    Security: Kerberos (sec=krb5)

  Port 139, 445 (SMB/Samba):
    From: All authenticated systems
    Protocol: TCP
    Authentication: Kerberos (via FreeIPA)

  Port 873 (Rsync):
    From: Backup systems only
    Protocol: TCP
    Purpose: Backup transfers

Outbound Connections:
  Port 88, 464 (Kerberos):
    To: dc1.cyberinabox.net
    Purpose: Authentication

  Port 636 (LDAPS):
    To: dc1.cyberinabox.net
    Purpose: User/group lookups
```

**graylog.cyberinabox.net (192.168.1.30):**

```
Inbound Connections:
  Port 22 (SSH):
    From: Administrators

  Port 514 (Syslog UDP):
    From: All internal systems
    Protocol: UDP
    Purpose: Log ingestion

  Port 1514 (Syslog TCP):
    From: All internal systems
    Protocol: TCP
    Purpose: Reliable log delivery

  Port 9000 (Graylog Web):
    From: Administrators, users
    Protocol: TCP (HTTP)
    Note: Behind reverse proxy with HTTPS

  Port 9200 (Elasticsearch):
    From: Localhost only
    Protocol: TCP
    Purpose: Graylog → Elasticsearch

  Port 27017 (MongoDB):
    From: Localhost only
    Protocol: TCP
    Purpose: Graylog configuration

Outbound Connections:
  Port 636 (LDAPS):
    To: dc1.cyberinabox.net
    Purpose: User authentication
```

**proxy.cyberinabox.net (192.168.1.40):**

```
Network Interfaces:
  eth0: 192.168.1.40 (management)
  eth1: Bridge/mirror port (traffic inspection)

Inbound Connections:
  Port 22 (SSH):
    From: Administrators

  Port 9101 (Suricata Exporter):
    From: monitoring.cyberinabox.net
    Purpose: Metrics export

Outbound Connections:
  Port 9091 (Prometheus):
    To: monitoring.cyberinabox.net
    Purpose: Push metrics

  Port 1514 (Syslog):
    To: graylog.cyberinabox.net
    Purpose: Forward Suricata alerts

Traffic Inspection:
  - All network traffic mirrored to eth1
  - Suricata analyzes in real-time
  - Alerts forwarded to Graylog and Wazuh
```

**monitoring.cyberinabox.net (192.168.1.50):**

```
Inbound Connections:
  Port 22 (SSH):
    From: Administrators

  Port 3001 (Grafana):
    From: All authenticated users
    Protocol: TCP (HTTP)
    Note: Behind reverse proxy with HTTPS

  Port 9091 (Prometheus):
    From: Administrators (query/API)
    Protocol: TCP

  Port 9093 (Alertmanager):
    From: Prometheus, administrators
    Protocol: TCP

Outbound Connections (Prometheus Scraping):
  Port 9100 (Node Exporter):
    To: All systems
    Frequency: Every 15 seconds
    Purpose: System metrics

  Port 9101 (Suricata Exporter):
    To: proxy.cyberinabox.net
    Purpose: Network security metrics

  Port 636 (LDAPS):
    To: dc1.cyberinabox.net
    Purpose: Grafana authentication
```

**wazuh.cyberinabox.net (192.168.1.60):**

```
Inbound Connections:
  Port 22 (SSH):
    From: Administrators

  Port 443 (Wazuh Dashboard):
    From: Security team, administrators
    Protocol: TCP (HTTPS)

  Port 1514 (Wazuh Agent):
    From: All monitored systems
    Protocol: TCP
    Security: TLS encrypted
    Purpose: Agent → Manager communication

  Port 1515 (Wazuh API):
    From: Dashboard, administrators
    Protocol: TCP (HTTPS)

  Port 55000 (Wazuh API):
    From: Dashboard, integrations
    Protocol: TCP (HTTPS)

Outbound Connections:
  Port 1514 (Syslog):
    To: graylog.cyberinabox.net
    Purpose: Forward alerts to Graylog

  Port 25 (SMTP):
    To: mail.cyberinabox.net
    Purpose: Email alerts
```

## 34.3 Service Communication Flows

### Authentication Flow

```
User Login → SSH to any system:

1. User → dc1 (port 88 UDP)
   Request Kerberos TGT

2. dc1 → User
   Return TGT (Ticket Granting Ticket)

3. User → dc1 (port 88 UDP)
   Request service ticket for host/target.cyberinabox.net

4. dc1 → User
   Return service ticket

5. User → target (port 22 TCP)
   Present service ticket via GSSAPI

6. target → dc1 (port 88 UDP, if needed)
   Verify ticket validity

7. target → User
   SSH session established

All Steps:
  - Encrypted with Kerberos keys
  - No passwords transmitted over network
  - Tickets cached locally (8-hour lifetime)
```

### Logging Flow

```
Log Generation → Graylog:

1. Application → rsyslog (local)
   Application writes to syslog

2. rsyslog → graylog (port 514 UDP or 1514 TCP)
   Forward logs with structured data

3. graylog → Elasticsearch (port 9200 TCP, localhost)
   Index logs for searching

4. User → graylog (port 9000 HTTPS)
   Query logs via web interface

5. graylog → User
   Return search results

Volume:
  - ~100 GB/day compressed
  - 15-second average latency
  - 90-day retention (hot storage)
```

### Monitoring Flow

```
Metrics Collection → Visualization:

1. Node Exporter (all systems, port 9100)
   Expose system metrics (HTTP endpoint)

2. Prometheus → Node Exporter (every 15 seconds)
   Scrape metrics via HTTP GET

3. Prometheus → Prometheus TSDB (localhost)
   Store time-series data

4. Grafana → Prometheus (port 9091)
   Query metrics via PromQL

5. Grafana → User (port 3001 HTTPS)
   Display dashboards

6. Alertmanager ← Prometheus (port 9093)
   Send alerts when thresholds exceeded

7. Alertmanager → Email (port 25 SMTP)
   Notify administrators
```

### Security Alert Flow

```
Security Event → Response:

1. Event occurs on any system
   - Failed login
   - File modification
   - Malware detection
   - IDS alert

2. Wazuh Agent → Wazuh Manager (port 1514 TCP)
   Send event data (encrypted)

3. Wazuh Manager → Internal analysis
   Correlate event, apply rules

4. Wazuh Manager → Graylog (port 1514 TCP)
   Forward alert for logging

5. Wazuh Manager → Email (port 25 SMTP)
   Alert administrator (if level ≥ 10)

6. Administrator → Wazuh Dashboard (port 443 HTTPS)
   Investigate alert

Response Time:
  - Event to alert: < 1 second
  - Alert to notification: < 5 seconds
  - Total latency: < 10 seconds
```

## 34.4 DNS Structure

### DNS Zone Configuration

**Forward Zone: cyberinabox.net**

```
Zone File: /var/named/data/cyberinabox.net.zone
Master: dc1.cyberinabox.net
DNSSEC: Enabled
Dynamic Updates: Yes (via Kerberos)

Records:
  SOA:
    Primary: dc1.cyberinabox.net.
    Admin: admin.cyberinabox.net.
    Serial: [auto-incremented]
    Refresh: 3600
    Retry: 900
    Expire: 1209600
    Minimum: 3600

  NS:
    cyberinabox.net. IN NS dc1.cyberinabox.net.

  A Records (Production Servers):
    dc1.cyberinabox.net.        IN A 192.168.1.10
    dms.cyberinabox.net.        IN A 192.168.1.20
    graylog.cyberinabox.net.    IN A 192.168.1.30
    proxy.cyberinabox.net.      IN A 192.168.1.40
    monitoring.cyberinabox.net. IN A 192.168.1.50
    wazuh.cyberinabox.net.      IN A 192.168.1.60

  CNAME Records (Service Aliases):
    grafana.cyberinabox.net.    IN CNAME monitoring.cyberinabox.net.
    prometheus.cyberinabox.net. IN CNAME monitoring.cyberinabox.net.
    mail.cyberinabox.net.       IN CNAME dc1.cyberinabox.net.
    cpm.cyberinabox.net.        IN CNAME monitoring.cyberinabox.net.

  SRV Records (Service Discovery):
    _kerberos._tcp.cyberinabox.net. IN SRV 0 100 88 dc1.cyberinabox.net.
    _kerberos._udp.cyberinabox.net. IN SRV 0 100 88 dc1.cyberinabox.net.
    _kerberos-master._tcp.cyberinabox.net. IN SRV 0 100 88 dc1.cyberinabox.net.
    _kerberos-master._udp.cyberinabox.net. IN SRV 0 100 88 dc1.cyberinabox.net.
    _kpasswd._tcp.cyberinabox.net. IN SRV 0 100 464 dc1.cyberinabox.net.
    _kpasswd._udp.cyberinabox.net. IN SRV 0 100 464 dc1.cyberinabox.net.
    _ldap._tcp.cyberinabox.net. IN SRV 0 100 389 dc1.cyberinabox.net.

  TXT Records:
    cyberinabox.net. IN TXT "v=spf1 mx ~all"
    _kerberos.cyberinabox.net. IN TXT "CYBERINABOX.NET"
```

**Reverse Zone: 1.168.192.in-addr.arpa**

```
Zone File: /var/named/data/1.168.192.in-addr.arpa.zone
Purpose: Reverse DNS lookups

Records:
  SOA: [Similar to forward zone]

  NS:
    1.168.192.in-addr.arpa. IN NS dc1.cyberinabox.net.

  PTR Records:
    10.1.168.192.in-addr.arpa. IN PTR dc1.cyberinabox.net.
    20.1.168.192.in-addr.arpa. IN PTR dms.cyberinabox.net.
    30.1.168.192.in-addr.arpa. IN PTR graylog.cyberinabox.net.
    40.1.168.192.in-addr.arpa. IN PTR proxy.cyberinabox.net.
    50.1.168.192.in-addr.arpa. IN PTR monitoring.cyberinabox.net.
    60.1.168.192.in-addr.arpa. IN PTR wazuh.cyberinabox.net.
```

## 34.5 Firewall Configuration

### Default Firewall Rules (firewalld)

**All Systems Default Rules:**

```bash
# Default zone: public
# Default policy: reject (with exceptions)

# Allowed Services (all systems):
firewall-cmd --list-services
ssh https kerberos kerberos-adm ldaps

# Explanation:
# ssh (22/tcp): Administrative access
# https (443/tcp): Web interfaces
# kerberos (88/tcp,udp): Authentication
# kerberos-adm (464/tcp,udp, 749/tcp): Password changes
# ldaps (636/tcp): Directory queries
```

**System-Specific Rules:**

**dc1.cyberinabox.net:**
```bash
firewall-cmd --list-all

public (active)
  services: dns freeipa-4 freeipa-ldap freeipa-ldaps freeipa-replication https kerberos kerberos-adm ldap ldaps ntp ssh
  ports: 80/tcp 443/tcp 389/tcp 636/tcp 88/tcp 88/udp 464/tcp 464/udp 53/tcp 53/udp 123/udp
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

**dms.cyberinabox.net:**
```bash
firewall-cmd --list-all

public
  services: mountd nfs rpc-bind samba samba-client ssh https
  ports: 2049/tcp 111/tcp 111/udp 139/tcp 445/tcp 20048/tcp
  rich rules:
    rule family="ipv4" source address="192.168.1.0/24" service name="nfs" accept
    rule family="ipv4" source address="192.168.1.0/24" service name="samba" accept
```

**graylog.cyberinabox.net:**
```bash
public
  services: ssh https
  ports: 514/udp 1514/tcp 9000/tcp
  rich rules:
    rule family="ipv4" source address="192.168.1.0/24" port port="514" protocol="udp" accept
    rule family="ipv4" source address="192.168.1.0/24" port port="1514" protocol="tcp" accept
```

**monitoring.cyberinabox.net:**
```bash
public
  services: ssh https
  ports: 3001/tcp 9091/tcp 9093/tcp 9100/tcp
  rich rules:
    rule family="ipv4" source address="192.168.1.0/24" port port="9100" protocol="tcp" accept
```

**wazuh.cyberinabox.net:**
```bash
public
  services: ssh https
  ports: 1514/tcp 1515/tcp 55000/tcp
  rich rules:
    rule family="ipv4" source address="192.168.1.0/24" port port="1514" protocol="tcp" accept
```

---

**Network Topology Quick Reference:**

**Network:** 192.168.1.0/24

**Production Servers:**
- dc1: 192.168.1.10 (FreeIPA, DNS, Kerberos)
- dms: 192.168.1.20 (File Server, NFS, Samba)
- graylog: 192.168.1.30 (Logging, Elasticsearch)
- proxy: 192.168.1.40 (Suricata IDS/IPS)
- monitoring: 192.168.1.50 (Prometheus, Grafana)
- wazuh: 192.168.1.60 (SIEM, Security Monitoring)

**Key Ports:**
- 22: SSH (all systems)
- 53: DNS (dc1)
- 88: Kerberos (dc1)
- 443: HTTPS (web interfaces)
- 636: LDAPS (dc1)
- 1514: Log ingestion (graylog), Wazuh agents
- 2049: NFS (dms)
- 9100: Node Exporter (all systems)

**DNS:**
- Primary: dc1.cyberinabox.net
- Zone: cyberinabox.net
- DNSSEC: Enabled
- Dynamic Updates: Kerberos-secured

**Firewall:**
- Tool: firewalld
- Default: Deny all, allow specific
- Logging: Enabled for denied packets

---

**Related Chapters:**
- Chapter 3: System Architecture
- Chapter 33: System Specifications
- Chapter 36: Service Catalog
- Appendix B: Service URLs & Access Points
- Appendix C: Command Reference

**For Help:**
- Network issues: dshannon@cyberinabox.net
- Firewall changes: Requires testing and approval
- DNS updates: Via FreeIPA or ipa dnsrecord-mod command
