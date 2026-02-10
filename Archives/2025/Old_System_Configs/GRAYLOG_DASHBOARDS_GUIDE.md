# Graylog Dashboards Guide for Suricata and Wazuh

## Overview

This guide provides step-by-step instructions for creating comprehensive security dashboards in Graylog for monitoring Suricata IDS/IPS events and Wazuh security alerts.

## Configuration Complete ✅

The following components have been automatically configured:

### 1. JSON Extractors
- **Suricata Extractor** (ID: 5f550de0-e51c-11f0-81fd-9440c9eff4b0)
  - Extracts fields with prefix: `suricata_`
  - Key fields: event_type, src_ip, dest_ip, proto, alert

- **Wazuh Extractor** (ID: 5f9d6180-e51c-11f0-81fd-9440c9eff4b0)
  - Extracts fields with prefix: `wazuh_`
  - Key fields: rule, agent, level, description

### 2. Streams
- **Suricata IDS/IPS Events** (ID: 695326e416f0431779656d5d)
  - Status: Active ✅
  - Collecting network security events

- **Wazuh Security Alerts** (ID: 695326e516f0431779656d6a)
  - Status: Active ✅
  - Collecting security alerts

---

## Creating Dashboards in Graylog UI

### Access Graylog
1. Navigate to: http://127.0.0.1:9000 (or https://graylog.cyberinabox.net)
2. Login with credentials: admin / admin

---

## Suricata IDS/IPS Dashboard

### Step 1: Create the Dashboard

1. **Click "Dashboards"** in the top menu
2. **Click "Create Dashboard"** button
3. **Enter details:**
   - Title: `Suricata IDS/IPS Security Dashboard`
   - Description: `Network intrusion detection and prevention monitoring`
4. **Click "Create"**

### Step 2: Add Widgets

#### Widget 1: Event Type Distribution (Pie Chart)

**Purpose:** Visualize distribution of different Suricata event types

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Pie Chart
   - **Title:** Event Type Distribution
   - **Search Query:** `streams:695326e416f0431779656d5d`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `suricata_event_type`
     - Limit: 10
3. **Click "Add to Dashboard"**

**Expected Results:** Shows distribution of event types (alert, dns, tls, http, flow, etc.)

#### Widget 2: Alert Timeline (Line Chart)

**Purpose:** Track IDS alerts over time

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Line Chart
   - **Title:** IDS Alert Timeline
   - **Search Query:** `streams:695326e416f0431779656d5d AND suricata_event_type:alert`
   - **Time Range:** Last 24 hours
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `timestamp`
     - Interval: 5 minutes
3. **Click "Add to Dashboard"**

**Expected Results:** Timeline showing alert frequency

#### Widget 3: Top Source IPs (Bar Chart)

**Purpose:** Identify most active source IP addresses

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Bar Chart
   - **Title:** Top Source IP Addresses
   - **Search Query:** `streams:695326e416f0431779656d5d`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `suricata_src_ip`
     - Limit: 15
   - **Sort:** Count descending
3. **Click "Add to Dashboard"**

**Expected Results:** Bar chart of most active source IPs

#### Widget 4: Top Destination IPs (Bar Chart)

**Purpose:** Identify most targeted destination addresses

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Bar Chart
   - **Title:** Top Destination IP Addresses
   - **Search Query:** `streams:695326e416f0431779656d5d`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `suricata_dest_ip`
     - Limit: 15
3. **Click "Add to Dashboard"**

#### Widget 5: Protocol Distribution (Pie Chart)

**Purpose:** Visualize network protocol usage

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Pie Chart
   - **Title:** Protocol Distribution
   - **Search Query:** `streams:695326e416f0431779656d5d`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `suricata_proto`
     - Limit: 10
3. **Click "Add to Dashboard"**

#### Widget 6: Alert Signatures (Table)

**Purpose:** List specific IDS alert signatures

1. Click **"Create" → "Message List"**
2. **Configure:**
   - **Title:** Recent IDS Alerts
   - **Search Query:** `streams:695326e416f0431779656d5d AND suricata_event_type:alert`
   - **Time Range:** Last 1 hour
   - **Fields to show:**
     - `timestamp`
     - `suricata_src_ip`
     - `suricata_dest_ip`
     - `suricata_alert_signature`
     - `suricata_alert_severity`
   - **Limit:** 50 messages
3. **Click "Add to Dashboard"**

#### Widget 7: Total Events Counter (Numeric)

**Purpose:** Display total event count

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Single Number
   - **Title:** Total Suricata Events
   - **Search Query:** `streams:695326e416f0431779656d5d`
   - **Time Range:** Last 24 hours
   - **Metrics:**
     - Function: `count()`
3. **Click "Add to Dashboard"**

#### Widget 8: TLS Traffic Analysis (Table)

**Purpose:** Monitor TLS/SSL connections

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Data Table
   - **Title:** Top TLS Domains
   - **Search Query:** `streams:695326e416f0431779656d5d AND suricata_event_type:tls`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `suricata_tls_sni`
     - Limit: 20
3. **Click "Add to Dashboard"**

---

## Wazuh Security Alerts Dashboard

### Step 1: Create the Dashboard

1. **Click "Dashboards"** in the top menu
2. **Click "Create Dashboard"** button
3. **Enter details:**
   - Title: `Wazuh Security Monitoring Dashboard`
   - Description: `Host-based security alerts and compliance monitoring`
4. **Click "Create"**

### Step 2: Add Widgets

#### Widget 1: Alert Severity Distribution (Pie Chart)

**Purpose:** Visualize alert severity levels

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Pie Chart
   - **Title:** Alert Severity Levels
   - **Search Query:** `streams:695326e516f0431779656d6a`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `wazuh_rule_level`
     - Limit: 10
3. **Click "Add to Dashboard"**

**Expected Results:** Pie chart showing alert levels (3=low, 5=medium, 7=high, etc.)

#### Widget 2: Alert Timeline (Area Chart)

**Purpose:** Track security alerts over time

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Area Chart
   - **Title:** Security Alerts Timeline
   - **Search Query:** `streams:695326e516f0431779656d6a`
   - **Time Range:** Last 24 hours
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `timestamp`
     - Interval: 5 minutes
     - Then by: `wazuh_rule_level`
3. **Click "Add to Dashboard"**

**Expected Results:** Stacked area chart showing alerts by severity over time

#### Widget 3: Top Alert Rules (Bar Chart)

**Purpose:** Identify most frequently triggered rules

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Bar Chart
   - **Title:** Most Common Alert Rules
   - **Search Query:** `streams:695326e516f0431779656d6a`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `wazuh_rule_description`
     - Limit: 15
3. **Click "Add to Dashboard"**

#### Widget 4: Critical Alerts (Table)

**Purpose:** Monitor high-severity security events

1. Click **"Create" → "Message List"**
2. **Configure:**
   - **Title:** Critical Security Alerts (Level ≥7)
   - **Search Query:** `streams:695326e516f0431779656d6a AND wazuh_rule_level:>=7`
   - **Time Range:** Last 24 hours
   - **Fields to show:**
     - `timestamp`
     - `wazuh_agent_name`
     - `wazuh_rule_level`
     - `wazuh_rule_description`
     - `wazuh_rule_id`
   - **Limit:** 100 messages
   - **Sort:** timestamp descending
3. **Click "Add to Dashboard"**

#### Widget 5: Agents Reporting (Pie Chart)

**Purpose:** Show which agents are generating alerts

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Pie Chart
   - **Title:** Alerts by Agent
   - **Search Query:** `streams:695326e516f0431779656d6a`
   - **Time Range:** Last 1 hour
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `wazuh_agent_name`
     - Limit: 10
3. **Click "Add to Dashboard"**

#### Widget 6: MITRE ATT&CK Techniques (Table)

**Purpose:** Track attack techniques detected

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Data Table
   - **Title:** MITRE ATT&CK Techniques Detected
   - **Search Query:** `streams:695326e516f0431779656d6a AND _exists_:wazuh_rule_mitre_id`
   - **Time Range:** Last 24 hours
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - First by: `wazuh_rule_mitre_technique`
     - Then by: `wazuh_rule_mitre_id`
     - Limit: 20
3. **Click "Add to Dashboard"**

#### Widget 7: Total Alerts Counter (Numeric)

**Purpose:** Display total alert count

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Single Number
   - **Title:** Total Wazuh Alerts
   - **Search Query:** `streams:695326e516f0431779656d6a`
   - **Time Range:** Last 24 hours
   - **Metrics:**
     - Function: `count()`
3. **Click "Add to Dashboard"**

#### Widget 8: Compliance Frameworks (Table)

**Purpose:** Track compliance-related alerts

1. Click **"Create" → "Aggregation"**
2. **Configure:**
   - **Visualization:** Data Table
   - **Title:** Compliance Alerts (PCI DSS, HIPAA, GDPR)
   - **Search Query:** `streams:695326e516f0431779656d6a AND (_exists_:wazuh_rule_pci_dss OR _exists_:wazuh_rule_hipaa OR _exists_:wazuh_rule_gdpr)`
   - **Time Range:** Last 24 hours
   - **Metrics:**
     - Function: `count()`
   - **Grouping:**
     - Field: `wazuh_rule_description`
     - Limit: 20
3. **Click "Add to Dashboard"**

---

## Useful Search Queries

### Suricata Queries

```
# All IDS alerts
streams:695326e416f0431779656d5d AND suricata_event_type:alert

# High severity alerts (priority 1 or 2)
streams:695326e416f0431779656d5d AND suricata_alert_severity:[1 TO 2]

# DNS queries
streams:695326e416f0431779656d5d AND suricata_event_type:dns

# TLS/SSL connections
streams:695326e416f0431779656d5d AND suricata_event_type:tls

# HTTP traffic
streams:695326e416f0431779656d5d AND suricata_event_type:http

# Traffic from specific IP
streams:695326e416f0431779656d5d AND suricata_src_ip:"192.168.1.10"

# Traffic to specific port
streams:695326e416f0431779656d5d AND suricata_dest_port:443

# TCP RST packets (connection resets)
streams:695326e416f0431779656d5d AND suricata_event_type:flow AND suricata_flow_state:*rst*

# Failed TLS handshakes
streams:695326e416f0431779656d5d AND suricata_event_type:tls AND NOT _exists_:suricata_tls_version
```

### Wazuh Queries

```
# All alerts
streams:695326e516f0431779656d6a

# Critical alerts (level 10+)
streams:695326e516f0431779656d6a AND wazuh_rule_level:>=10

# High severity (level 7-9)
streams:695326e516f0431779656d6a AND wazuh_rule_level:[7 TO 9]

# Authentication failures
streams:695326e516f0431779656d6a AND wazuh_rule_description:*authentication*failed*

# Successful sudo commands
streams:695326e516f0431779656d6a AND wazuh_rule_description:*sudo*

# File integrity monitoring alerts
streams:695326e516f0431779656d6a AND wazuh_rule_groups:*syscheck*

# Rootkit detection
streams:695326e516f0431779656d6a AND wazuh_rule_groups:*rootcheck*

# Vulnerability detection
streams:695326e516f0431779656d6a AND wazuh_rule_groups:*vulnerability*

# PCI DSS compliance alerts
streams:695326e516f0431779656d6a AND _exists_:wazuh_rule_pci_dss

# MITRE ATT&CK - Privilege Escalation
streams:695326e516f0431779656d6a AND wazuh_rule_mitre_tactic:*"Privilege Escalation"*

# Specific agent alerts
streams:695326e516f0431779656d6a AND wazuh_agent_name:"dc1.cyberinabox.net"

# SELinux denials
streams:695326e516f0431779656d6a AND wazuh_rule_description:*SELinux*
```

---

## Stream IDs Reference

Use these stream IDs in your queries:

- **Suricata Stream:** `695326e416f0431779656d5d`
- **Wazuh Stream:** `695326e516f0431779656d6a`

**Query Format:**
```
streams:<stream_id> AND <additional_filters>
```

---

## Available Fields Reference

### Suricata Fields (prefix: suricata_)

Common fields extracted from Suricata events:

- `suricata_timestamp` - Event timestamp
- `suricata_event_type` - Type of event (alert, dns, tls, http, flow, etc.)
- `suricata_src_ip` - Source IP address
- `suricata_src_port` - Source port
- `suricata_dest_ip` - Destination IP address
- `suricata_dest_port` - Destination port
- `suricata_proto` - Protocol (TCP, UDP, ICMP)
- `suricata_flow_id` - Unique flow identifier
- `suricata_in_iface` - Network interface

**Alert-specific fields:**
- `suricata_alert_signature` - Alert rule signature
- `suricata_alert_severity` - Alert priority (1=high, 3=low)
- `suricata_alert_category` - Attack category
- `suricata_alert_signature_id` - Rule ID

**DNS fields:**
- `suricata_dns_rrname` - DNS query name
- `suricata_dns_rrtype` - DNS record type
- `suricata_dns_rcode` - DNS response code

**TLS fields:**
- `suricata_tls_sni` - Server Name Indication (domain)
- `suricata_tls_version` - TLS version
- `suricata_tls_subject` - Certificate subject
- `suricata_tls_issuerdn` - Certificate issuer

**HTTP fields:**
- `suricata_http_hostname` - HTTP host
- `suricata_http_url` - Request URL
- `suricata_http_http_method` - HTTP method (GET, POST, etc.)
- `suricata_http_status` - HTTP status code

### Wazuh Fields (prefix: wazuh_)

Common fields extracted from Wazuh alerts:

- `wazuh_timestamp` - Alert timestamp
- `wazuh_rule_id` - Rule ID
- `wazuh_rule_level` - Severity level (0-15)
- `wazuh_rule_description` - Rule description
- `wazuh_rule_groups` - Rule categories

**Agent fields:**
- `wazuh_agent_id` - Agent ID
- `wazuh_agent_name` - Agent hostname

**MITRE ATT&CK fields:**
- `wazuh_rule_mitre_id` - MITRE technique ID (e.g., T1548.003)
- `wazuh_rule_mitre_tactic` - MITRE tactic name
- `wazuh_rule_mitre_technique` - MITRE technique name

**Compliance fields:**
- `wazuh_rule_pci_dss` - PCI DSS requirements
- `wazuh_rule_hipaa` - HIPAA requirements
- `wazuh_rule_gdpr` - GDPR articles
- `wazuh_rule_nist_800_53` - NIST controls

**Event data:**
- `wazuh_full_log` - Original log message
- `wazuh_location` - Log source location
- `wazuh_decoder_name` - Decoder used

---

## Dashboard Best Practices

### 1. Time Range Selection
- Use **relative time ranges** (Last 1 hour, Last 24 hours) for live monitoring
- Dashboards auto-refresh by default
- Click the refresh icon to set custom refresh intervals (30s, 1m, 5m)

### 2. Widget Organization
- Place most important metrics at the top
- Use single number widgets for KPIs
- Group related visualizations together
- Use consistent time ranges across related widgets

### 3. Color Coding
- Configure alert severity colors:
  - Red: Critical (level 10+)
  - Orange: High (level 7-9)
  - Yellow: Medium (level 5-6)
  - Blue: Low (level 0-4)

### 4. Saved Searches
- Save frequently used queries as "Saved Searches"
- Use saved searches as dashboard widget sources
- Share searches with team members

### 5. Alerting
Create alert conditions for critical events:
- Suricata high-severity alerts spike
- Wazuh critical alerts (level ≥10)
- Authentication failure patterns
- Unusual traffic patterns

---

## Troubleshooting

### No Data in Widgets

1. **Check stream is active:**
   ```bash
   curl -s -u "admin:admin" "http://127.0.0.1:9000/api/streams" | jq '.streams[] | {title, disabled}'
   ```

2. **Verify extractors are running:**
   ```bash
   curl -s -u "admin:admin" "http://127.0.0.1:9000/api/system/inputs/6953205c16f04317796569c6/extractors" | jq '.extractors[] | {title, extractor_id}'
   ```

3. **Check field extraction:**
   - Go to "Search" page
   - Search: `streams:695326e416f0431779656d5d`
   - Click on a message
   - Verify `suricata_*` fields are present

### Widget Shows Error

- Verify field names are correct (case-sensitive)
- Check time range includes data
- Ensure query syntax is valid
- Look for typos in stream IDs

### Extractors Not Working

Extractors only process **new messages**. Historical messages won't have extracted fields.

**Solution:**
- Wait for new log data to arrive
- Extractors will automatically process incoming messages
- After 5-10 minutes, you should see extracted fields

---

## Performance Optimization

### Index Tuning
For high-volume logging:
1. **Increase shard count** for better parallel processing
2. **Configure index retention** to manage disk space
3. **Set up index rotation** (daily, weekly)

### Stream Processing
- Minimize complex stream rules
- Use specific field matching instead of regex
- Monitor stream throughput in System → Overview

### Widget Performance
- Limit table widget rows (50-100 max)
- Use appropriate time ranges
- Avoid overly complex aggregations

---

## Accessing Dashboards

### Via Web UI
1. Navigate to http://127.0.0.1:9000 or https://graylog.cyberinabox.net
2. Click "Dashboards" in top menu
3. Select your dashboard

### Direct URLs (after creation)
Dashboards will have URLs like:
- `http://127.0.0.1:9000/dashboards/<dashboard-id>`

### Export/Import
To share dashboards:
1. Click dashboard settings (gear icon)
2. Select "Export"
3. Save JSON file
4. Import on other Graylog instances

---

## Next Steps

### 1. Configure Alerts
Set up email/Slack notifications for critical events:
- Suricata high-priority alerts
- Wazuh authentication failures
- Compliance violations

### 2. Create Custom Extractors
Add extractors for specific fields:
- User names from logs
- File paths from FIM alerts
- Process names from audit logs

### 3. Enrich Data
- Add GeoIP lookup for IP addresses
- Create lookup tables for asset inventory
- Tag traffic by network zone

### 4. Build Correlation Searches
Combine Suricata and Wazuh data:
- Network connections + host alerts
- DNS queries + file changes
- TLS connections + authentication events

---

## Summary

**Configured Components:**
- ✅ JSON extractors for Suricata and Wazuh
- ✅ Active streams for filtering and routing
- ✅ Field extraction with prefixes (suricata_, wazuh_)

**Ready to Build:**
- Suricata IDS/IPS Dashboard (8 widgets)
- Wazuh Security Dashboard (8 widgets)

**Data Flow:**
```
Rsyslog → Graylog Input → JSON Extractor → Stream → Dashboard Widgets
```

Follow the widget creation steps above to build comprehensive security dashboards for monitoring your network and host-based security posture.
