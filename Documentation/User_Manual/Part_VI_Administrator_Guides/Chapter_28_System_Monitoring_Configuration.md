# Chapter 28: System Monitoring Configuration

## 28.1 Monitoring Stack Overview

### Architecture

**Monitoring Components:**

```
Data Collection Layer:
  - Node Exporter (port 9100): System metrics (CPU, memory, disk, network)
  - Suricata Exporter (port 9101): Network security metrics
  - Custom Exporters: Application-specific metrics
  - SNMP Exporter: Network device metrics (Phase II)

Storage & Processing:
  - Prometheus (port 9091): Time-series metrics database
  - Graylog: Log aggregation and analysis
  - Elasticsearch: Log storage and search
  - Wazuh: Security event correlation

Visualization:
  - Grafana (port 3001): Dashboards and alerting
  - Wazuh Dashboard: Security visualization
  - Graylog Web UI: Log search interface
  - CPM Dashboard: Compliance overview

Alerting:
  - Grafana Alerts: Metric-based alerts
  - Wazuh Rules: Security event alerts
  - Graylog Alerts: Log pattern alerts
  - Email notifications: All systems
```

### Monitoring Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Monitoring Flow                       │
└─────────────────────────────────────────────────────────┘

All Systems (dc1, dms, proxy, graylog, wazuh, monitoring)
    │
    ├─→ Node Exporter (9100) ───→ Prometheus ─┐
    ├─→ Suricata Exporter (9101) ──→           │
    ├─→ Wazuh Agent ───→ Wazuh Server ────────┤
    └─→ Rsyslog ───→ Graylog ─────────────────┤
                                                │
                                                ↓
                                    ┌───────────────────┐
                                    │   Visualization   │
                                    │                   │
                                    │  Grafana (3001)   │
                                    │  Wazuh Dashboard  │
                                    │  Graylog UI       │
                                    │  CPM Dashboard    │
                                    └───────────────────┘
                                                │
                                                ↓
                                    ┌───────────────────┐
                                    │  Alerting System  │
                                    │                   │
                                    │ Email/SMS/Webhook │
                                    └───────────────────┘
```

## 28.2 Prometheus Configuration

### Prometheus Server Setup

**Location:** monitoring.cyberinabox.net

**Configuration File:** `/etc/prometheus/prometheus.yml`

```yaml
# Global configuration
global:
  scrape_interval: 15s      # Scrape targets every 15 seconds
  evaluation_interval: 15s   # Evaluate rules every 15 seconds
  external_labels:
    cluster: 'cyberhygiene'
    environment: 'production'

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - localhost:9093

# Load rules once and periodically evaluate
rule_files:
  - "/etc/prometheus/rules/*.yml"

# Scrape configurations
scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9091']
        labels:
          instance: 'monitoring'
          role: 'prometheus'

  # Node Exporter - All Systems
  - job_name: 'node'
    static_configs:
      - targets:
          - 'dc1.cyberinabox.net:9100'
          - 'dms.cyberinabox.net:9100'
          - 'graylog.cyberinabox.net:9100'
          - 'proxy.cyberinabox.net:9100'
          - 'monitoring.cyberinabox.net:9100'
          - 'wazuh.cyberinabox.net:9100'
        labels:
          environment: 'production'

  # Suricata Exporter - Proxy
  - job_name: 'suricata'
    static_configs:
      - targets: ['proxy.cyberinabox.net:9101']
        labels:
          instance: 'proxy'
          role: 'ids_ips'

  # Wazuh Exporter (if configured)
  - job_name: 'wazuh'
    static_configs:
      - targets: ['wazuh.cyberinabox.net:9102']
        labels:
          instance: 'wazuh'
          role: 'siem'

  # Graylog Exporter (if configured)
  - job_name: 'graylog'
    static_configs:
      - targets: ['graylog.cyberinabox.net:9103']
        labels:
          instance: 'graylog'
          role: 'logging'
```

### Adding New Targets

**Add New Server to Monitoring:**

```bash
# SSH to monitoring server
ssh admin@monitoring.cyberinabox.net

# Edit Prometheus config
sudo vi /etc/prometheus/prometheus.yml

# Add new target under appropriate job
scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets:
          - 'dc1.cyberinabox.net:9100'
          - 'newserver.cyberinabox.net:9100'  # Add this line

# Validate configuration
promtool check config /etc/prometheus/prometheus.yml

# Reload Prometheus (no downtime)
sudo systemctl reload prometheus

# Verify target is up
# Access: http://monitoring.cyberinabox.net:9091/targets
```

### Prometheus Alert Rules

**Alert Rule File:** `/etc/prometheus/rules/alerts.yml`

```yaml
groups:
  - name: system_alerts
    interval: 30s
    rules:
      # High CPU usage
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is {{ $value }}% on {{ $labels.instance }}"

      # High memory usage
      - alert: HighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          description: "Memory usage is {{ $value }}% on {{ $labels.instance }}"

      # Low disk space
      - alert: LowDiskSpace
        expr: (node_filesystem_avail_bytes{fstype!="tmpfs"} / node_filesystem_size_bytes{fstype!="tmpfs"}) * 100 < 15
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Low disk space on {{ $labels.instance }}"
          description: "Disk {{ $labels.mountpoint }} has only {{ $value }}% available on {{ $labels.instance }}"

      # System down
      - alert: InstanceDown
        expr: up == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} down"
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 2 minutes"

      # High network traffic
      - alert: HighNetworkTraffic
        expr: rate(node_network_receive_bytes_total[5m]) > 100000000
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High network traffic on {{ $labels.instance }}"
          description: "Network receive rate is {{ $value }} bytes/sec on {{ $labels.instance }}"

  - name: security_alerts
    interval: 30s
    rules:
      # Suricata - High alert rate
      - alert: HighIDSAlertRate
        expr: rate(suricata_alerts_total[5m]) > 10
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High IDS alert rate"
          description: "Suricata is triggering {{ $value }} alerts/sec"

      # Suricata - Packets dropped
      - alert: PacketsDropped
        expr: rate(suricata_dropped_packets_total[5m]) > 100
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Packets being dropped"
          description: "{{ $value }} packets/sec dropped by Suricata"
```

**Adding New Alert Rule:**

```bash
# Edit alert rules
sudo vi /etc/prometheus/rules/alerts.yml

# Add new alert under appropriate group
# Example: Alert when service is down
      - alert: ServiceDown
        expr: node_systemd_unit_state{name="httpd.service",state="active"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service httpd is down on {{ $labels.instance }}"
          description: "Critical service httpd has been down for more than 1 minute"

# Validate rules
promtool check rules /etc/prometheus/rules/alerts.yml

# Reload Prometheus
sudo systemctl reload prometheus

# Verify alerts in Grafana or Prometheus web UI
```

## 28.3 Grafana Configuration

### Grafana Server Setup

**Location:** monitoring.cyberinabox.net:3001

**Configuration File:** `/etc/grafana/grafana.ini`

```ini
[server]
protocol = http
http_addr = 0.0.0.0
http_port = 3001
domain = grafana.cyberinabox.net
root_url = https://grafana.cyberinabox.net

[security]
admin_user = admin
admin_password = [secure password]
disable_gravatar = true
cookie_secure = true

[auth]
disable_login_form = false
oauth_auto_login = false

[auth.anonymous]
enabled = false

[auth.ldap]
enabled = true
config_file = /etc/grafana/ldap.toml
allow_sign_up = true

[users]
allow_sign_up = false
allow_org_create = false
auto_assign_org = true
auto_assign_org_role = Viewer

[smtp]
enabled = true
host = mail.cyberinabox.net:587
user = grafana@cyberinabox.net
password = [smtp password]
from_address = grafana@cyberinabox.net
from_name = Grafana Monitoring
```

### LDAP Integration

**LDAP Configuration:** `/etc/grafana/ldap.toml`

```toml
[[servers]]
host = "dc1.cyberinabox.net"
port = 636
use_ssl = true
start_tls = false
ssl_skip_verify = false

bind_dn = "uid=grafana,cn=users,cn=accounts,dc=cyberinabox,dc=net"
bind_password = '[service account password]'

search_filter = "(uid=%s)"
search_base_dns = ["cn=users,cn=accounts,dc=cyberinabox,dc=net"]

[servers.attributes]
name = "givenName"
surname = "sn"
username = "uid"
member_of = "memberOf"
email = "mail"

# Group mappings
[[servers.group_mappings]]
group_dn = "cn=admins,cn=groups,cn=accounts,dc=cyberinabox,dc=net"
org_role = "Admin"

[[servers.group_mappings]]
group_dn = "cn=operations,cn=groups,cn=accounts,dc=cyberinabox,dc=net"
org_role = "Editor"

[[servers.group_mappings]]
group_dn = "cn=ipausers,cn=groups,cn=accounts,dc=cyberinabox,dc=net"
org_role = "Viewer"
```

### Data Sources

**Adding Prometheus Data Source:**

**Web UI Method:**
```
1. Login to Grafana: https://grafana.cyberinabox.net
2. Configuration (gear icon) → Data sources
3. "Add data source"
4. Select "Prometheus"
5. Configure:
   Name: Prometheus
   URL: http://localhost:9091
   Access: Server (default)
   Scrape interval: 15s
6. Click "Save & test"
7. Should see: "Data source is working"
```

**Provisioning Method (Automated):**

Create file: `/etc/grafana/provisioning/datasources/prometheus.yml`

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9091
    isDefault: true
    editable: false
    jsonData:
      timeInterval: "15s"
```

### Dashboard Provisioning

**Auto-Load Dashboards on Startup:**

Create file: `/etc/grafana/provisioning/dashboards/default.yml`

```yaml
apiVersion: 1

providers:
  - name: 'Default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards
```

**Place Dashboard JSON Files:**
```bash
# Export dashboard from Grafana UI
# Dashboard → Share → Export → Save to file

# Copy to provisioning directory
sudo cp node-exporter-full.json /var/lib/grafana/dashboards/

# Set permissions
sudo chown grafana:grafana /var/lib/grafana/dashboards/*.json
sudo chmod 644 /var/lib/grafana/dashboards/*.json

# Restart Grafana to load
sudo systemctl restart grafana-server

# Dashboard will appear in Grafana automatically
```

## 28.4 Wazuh Configuration

### Wazuh Manager Setup

**Location:** wazuh.cyberinabox.net

**Manager Configuration:** `/var/ossec/etc/ossec.conf`

```xml
<ossec_config>
  <global>
    <jsonout_output>yes</jsonout_output>
    <alerts_log>yes</alerts_log>
    <logall>no</logall>
    <logall_json>no</logall_json>
    <email_notification>yes</email_notification>
    <email_to>security@cyberinabox.net</email_to>
    <smtp_server>mail.cyberinabox.net</smtp_server>
    <email_from>wazuh@cyberinabox.net</email_from>
    <email_maxperhour>12</email_maxperhour>
  </global>

  <alerts>
    <log_alert_level>3</log_alert_level>
    <email_alert_level>10</email_alert_level>
  </alerts>

  <remote>
    <connection>secure</connection>
    <port>1514</port>
    <protocol>tcp</protocol>
    <queue_size>131072</queue_size>
  </remote>

  <ruleset>
    <!-- Default ruleset -->
    <decoder_dir>ruleset/decoders</decoder_dir>
    <rule_dir>ruleset/rules</rule_dir>
    <rule_exclude>0215-policy_rules.xml</rule_exclude>
    <list>etc/lists/audit-keys</list>

    <!-- User rules -->
    <rule_dir>etc/rules</rule_dir>
    <decoder_dir>etc/decoders</decoder_dir>
    <list>etc/lists/custom-list</list>
  </ruleset>

  <syscheck>
    <disabled>no</disabled>
    <scan_on_start>yes</scan_on_start>
    <frequency>43200</frequency>

    <!-- Directories to check -->
    <directories check_all="yes">/etc,/usr/bin,/usr/sbin</directories>
    <directories check_all="yes">/bin,/sbin,/boot</directories>

    <!-- Files/directories to ignore -->
    <ignore>/etc/mtab</ignore>
    <ignore>/etc/hosts.deny</ignore>
    <ignore>/etc/mail/statistics</ignore>
    <ignore>/etc/random-seed</ignore>
    <ignore>/etc/adjtime</ignore>
    <ignore>/etc/httpd/logs</ignore>
    <ignore>/etc/utmpx</ignore>
    <ignore>/etc/wtmpx</ignore>
    <ignore>/etc/cups/certs</ignore>
    <ignore>/etc/dumpdates</ignore>
  </syscheck>

  <rootcheck>
    <disabled>no</disabled>
    <check_files>yes</check_files>
    <check_trojans>yes</check_trojans>
    <check_dev>yes</check_dev>
    <check_sys>yes</check_sys>
    <check_pids>yes</check_pids>
    <check_ports>yes</check_ports>
    <check_if>yes</check_if>
    <frequency>43200</frequency>
  </rootcheck>

  <vulnerability-detector>
    <enabled>yes</enabled>
    <interval>5m</interval>
    <run_on_start>yes</run_on_start>
    <provider name="redhat">
      <enabled>yes</enabled>
      <update_interval>1h</update_interval>
    </provider>
  </vulnerability-detector>
</ossec_config>
```

### Custom Alert Rules

**Create Custom Rule:** `/var/ossec/etc/rules/local_rules.xml`

```xml
<group name="local,syslog,sshd,">
  <!-- Alert on multiple failed SSH logins -->
  <rule id="100001" level="10" frequency="5" timeframe="300">
    <if_matched_sid>5710</if_matched_sid>
    <same_source_ip />
    <description>Multiple failed SSH login attempts from same IP.</description>
    <mitre>
      <id>T1110</id>
    </mitre>
  </rule>

  <!-- Alert on successful login after failures -->
  <rule id="100002" level="12">
    <if_matched_sid>5715</if_matched_sid>
    <if_fts>
      <first_time_source_ip/>
    </if_fts>
    <same_source_ip />
    <description>Successful SSH login after previous failures.</description>
    <mitre>
      <id>T1078</id>
    </mitre>
  </rule>

  <!-- Alert on SUDO command execution -->
  <rule id="100003" level="5">
    <if_sid>5401</if_sid>
    <match>sudo: |command=/sbin/shutdown|/sbin/reboot</match>
    <description>System shutdown/reboot command executed via sudo.</description>
  </rule>
</group>
```

**Reload Wazuh Rules:**
```bash
ssh admin@wazuh.cyberinabox.net

# Test rule syntax
sudo /var/ossec/bin/wazuh-logtest

# Reload rules without restart
sudo /var/ossec/bin/wazuh-control reload
```

### Wazuh Agent Enrollment

**Enroll New Agent:**

```bash
# On Wazuh Manager (wazuh.cyberinabox.net)
ssh admin@wazuh.cyberinabox.net

# Add agent
sudo /var/ossec/bin/manage_agents

# Follow prompts:
# A) Add agent
# Agent name: newserver.cyberinabox.net
# IP address: 192.168.1.XX
# ID: [auto-generated]

# Extract key
sudo /var/ossec/bin/manage_agents -e agent-id

# Copy the key provided
```

**On Agent System:**

```bash
ssh admin@newserver.cyberinabox.net

# Install Wazuh agent
sudo dnf install wazuh-agent

# Import key
sudo /var/ossec/bin/manage_agents
# I) Import key
# Paste the key from manager

# Configure manager IP
sudo vi /var/ossec/etc/ossec.conf
# Update <server> section:
<client>
  <server>
    <address>wazuh.cyberinabox.net</address>
    <port>1514</port>
    <protocol>tcp</protocol>
  </server>
</client>

# Start agent
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

# Verify connection
sudo systemctl status wazuh-agent
```

## 28.5 Graylog Configuration

### Graylog Server Setup

**Location:** graylog.cyberinabox.net

**Server Configuration:** `/etc/graylog/server/server.conf`

```
# Essential settings
is_master = true
node_id_file = /etc/graylog/server/node-id
password_secret = [generated secret]
root_password_sha2 = [SHA256 of admin password]

# Web interface
http_bind_address = 0.0.0.0:9000
http_external_uri = https://graylog.cyberinabox.net/

# Elasticsearch
elasticsearch_hosts = http://localhost:9200

# MongoDB
mongodb_uri = mongodb://localhost:27017/graylog

# Email
transport_email_enabled = true
transport_email_hostname = mail.cyberinabox.net
transport_email_port = 587
transport_email_use_auth = true
transport_email_auth_username = graylog@cyberinabox.net
transport_email_auth_password = [smtp password]
transport_email_from_email = graylog@cyberinabox.net

# Message processing
processbuffer_processors = 5
outputbuffer_processors = 3
processor_wait_strategy = blocking
ring_size = 65536
inputbuffer_ring_size = 65536
inputbuffer_processors = 2
inputbuffer_wait_strategy = blocking
```

### Graylog Inputs

**Create Syslog Input (Web UI):**

```
1. Login to Graylog: https://graylog.cyberinabox.net
2. System → Inputs
3. Select input: "Syslog UDP"
4. Click "Launch new input"
5. Configure:
   Title: System Syslog
   Bind address: 0.0.0.0
   Port: 514
   Receive buffer: 262144
6. Save

# Repeat for Syslog TCP on port 1514
```

**Configure Systems to Send Logs:**

```bash
# On each system
ssh admin@system.cyberinabox.net

# Configure rsyslog
sudo vi /etc/rsyslog.d/graylog.conf

# Add:
*.* @graylog.cyberinabox.net:514;RSYSLOG_SyslogProtocol23Format

# Restart rsyslog
sudo systemctl restart rsyslog

# Test
logger "Test message from $(hostname)"

# Check Graylog for message
```

### Graylog Extractors

**Create Extractor for SSH Logs:**

```
1. Graylog → System → Inputs
2. Select "Syslog" input → More actions → Manage extractors
3. "Get started" or "Load message"
4. Select a sample SSH log message
5. Click "Try" to test extraction
6. Example for username extraction:
   Field: message
   Condition: Must match regular expression
   Regex: Failed password for (\\w+) from
   Extraction: $1
   Store as field: ssh_username
7. Save extractor

# Repeat for:
- source_ip: from ([\\d.]+)
- ssh_result: (Accepted|Failed)
- authentication_method: via (\\w+)
```

### Graylog Streams

**Create Security Stream:**

```
1. Streams → "Create Stream"
2. Title: Security Events
3. Description: All security-related logs
4. Index set: Default
5. Remove matches from default stream: No
6. Save

7. Edit Stream → Manage Rules → Add stream rule:
   Field: source
   Type: match exactly
   Value: wazuh
   OR
   Field: application_name
   Type: match regular expression
   Value: sshd|sudo|su

8. Start stream
```

## 28.6 Alert Configuration

### Grafana Alerts

**Create Alert in Grafana:**

```
1. Open dashboard panel
2. Edit panel
3. Alert tab
4. Create Alert
5. Conditions:
   WHEN avg() OF query(A, 5m, now) IS ABOVE 80
6. Notifications:
   Send to: Email (configure notification channel first)
7. Message:
   High CPU usage: {{ $value }}% on {{ $labels.instance }}
8. Save dashboard
```

**Notification Channels:**

```
1. Alerting → Notification channels
2. New channel
3. Type: Email
4. Settings:
   Name: Admin Email
   Email addresses: admin@cyberinabox.net
   Send on all alerts: No
   Include image: Yes
5. Test → Save
```

### Wazuh Email Alerts

**Already configured in ossec.conf:**

```xml
<email_alerts>
  <email_to>security@cyberinabox.net</email_to>
  <level>10</level>
  <do_not_delay />
</email_alerts>
```

**Customize Alert Levels:**

```bash
# Only email critical alerts (level 12+)
sudo vi /var/ossec/etc/ossec.conf

<global>
  <email_alert_level>12</email_alert_level>
</global>

# Restart Wazuh
sudo systemctl restart wazuh-manager
```

### Graylog Alerts

**Create Alert Condition:**

```
1. Streams → Select stream → Alerts
2. Add new condition
3. Condition type: Message count
4. Parameters:
   Grace Period: 5 minutes
   Threshold: > 10
   Time Range: 5 minutes
   Search Query: application_name:sshd AND "Failed password"
5. Title: Multiple SSH failures
6. Save

7. Manage notifications
8. Add notification
9. Type: Email
10. Recipients: security@cyberinabox.net
11. Subject: [ALERT] Multiple SSH login failures
12. Body: ${stream.title} triggered an alert
    ${alert_condition.title}
    ${backlog}
13. Save
```

---

**Monitoring Configuration Quick Reference:**

**Prometheus:**
- Config: `/etc/prometheus/prometheus.yml`
- Rules: `/etc/prometheus/rules/*.yml`
- Reload: `sudo systemctl reload prometheus`
- Validate: `promtool check config /etc/prometheus/prometheus.yml`

**Grafana:**
- Config: `/etc/grafana/grafana.ini`
- LDAP: `/etc/grafana/ldap.toml`
- Dashboards: `/var/lib/grafana/dashboards/`
- Restart: `sudo systemctl restart grafana-server`

**Wazuh:**
- Manager Config: `/var/ossec/etc/ossec.conf`
- Custom Rules: `/var/ossec/etc/rules/local_rules.xml`
- Agent Management: `/var/ossec/bin/manage_agents`
- Reload: `sudo /var/ossec/bin/wazuh-control reload`

**Graylog:**
- Server Config: `/etc/graylog/server/server.conf`
- Access: https://graylog.cyberinabox.net
- Restart: `sudo systemctl restart graylog-server`

**Common Tasks:**
```bash
# Add Prometheus target
sudo vi /etc/prometheus/prometheus.yml
sudo systemctl reload prometheus

# Create Prometheus alert
sudo vi /etc/prometheus/rules/alerts.yml
promtool check rules /etc/prometheus/rules/alerts.yml
sudo systemctl reload prometheus

# Enroll Wazuh agent
sudo /var/ossec/bin/manage_agents  # On manager
sudo /var/ossec/bin/manage_agents  # On agent (import key)
sudo systemctl start wazuh-agent   # On agent

# Configure syslog to Graylog
echo '*.* @graylog.cyberinabox.net:514;RSYSLOG_SyslogProtocol23Format' | \
  sudo tee /etc/rsyslog.d/graylog.conf
sudo systemctl restart rsyslog
```

---

**Related Chapters:**
- Chapter 17: Wazuh Security Monitoring
- Chapter 19: Grafana Dashboards
- Chapter 21: Graylog Log Analysis
- Chapter 31: Security Updates & Patching
- Appendix C: Command Reference
- Appendix D: Troubleshooting Guide

**For Help:**
- Prometheus Docs: https://prometheus.io/docs/
- Grafana Docs: https://grafana.com/docs/
- Wazuh Docs: https://documentation.wazuh.com/
- Graylog Docs: https://docs.graylog.org/
- Administrator: dshannon@cyberinabox.net
