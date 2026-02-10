# Graylog Dashboards - Quick Setup Guide

## ✅ Pre-Configuration Complete

The following components are already configured and ready:
- **Streams:** Suricata and Wazuh streams active
- **Extractors:** JSON field extraction working
- **Data Flow:** Logs flowing to Graylog in real-time

---

## Quick Dashboard Creation

Due to Graylog 6.x's complex Views API, dashboards are most reliably created through the web UI. I've prepared everything you need to create comprehensive dashboards in **under 10 minutes**.

---

## Method 1: Quick Access URLs (Instant)

Use these direct links to access pre-configured searches immediately:

### Suricata Searches

**All Suricata Events:**
```
http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d&rangetype=relative&relative=3600
```

**IDS Alerts Only:**
```
http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d%20AND%20suricata_event_type%3Aalert&rangetype=relative&relative=3600
```

**DNS Traffic:**
```
http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d%20AND%20suricata_event_type%3Adns&rangetype=relative&relative=3600
```

**TLS Connections:**
```
http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d%20AND%20suricata_event_type%3Atls&rangetype=relative&relative=3600
```

### Wazuh Searches

**All Wazuh Alerts:**
```
http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a&rangetype=relative&relative=3600
```

**Critical Alerts (Level 10+):**
```
http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a%20AND%20wazuh_rule_level%3A%3E%3D10&rangetype=relative&relative=86400
```

**High Severity (Level 8-9):**
```
http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a%20AND%20wazuh_rule_level%3A%5B8%20TO%209%5D&rangetype=relative&relative=3600
```

**Authentication Events:**
```
http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a%20AND%20wazuh_rule_groups%3A%2Aauthentication%2A&rangetype=relative&relative=3600
```

---

## Method 2: Create Dashboards via Web UI (10 Minutes)

### Step 1: Access Graylog
1. Open: **http://127.0.0.1:9000** (or https://graylog.cyberinabox.net)
2. Login: **admin** / **admin**

---

### Step 2: Create Suricata Dashboard

#### 2.1 Create Dashboard
1. Click **"Dashboards"** in top menu
2. Click **"Create new dashboard"** button
3. Enter:
   - **Title:** `Suricata IDS/IPS Security Dashboard`
   - **Description:** `Network intrusion detection and prevention monitoring`
4. Click **"Create"**

#### 2.2 Add Widget: Event Type Distribution (Pie Chart)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e416f0431779656d5d
   ```
3. **Time Range:** Last 1 hour
4. **Metrics:**
   - Click **"Add Metric"**
   - Select: **count()**
5. **Group By:**
   - Click **"Rows"**
   - Field: **suricata_event_type**
   - Limit: **10**
6. **Visualization:**
   - Click **"Visualize"**
   - Select: **Pie Chart**
7. **Title:** `Event Type Distribution`
8. Click **"Save"** → **"Add to dashboard"**

#### 2.3 Add Widget: Top Source IPs (Bar Chart)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e416f0431779656d5d
   ```
3. **Time Range:** Last 1 hour
4. **Metrics:** count()
5. **Group By:**
   - Field: **suricata_src_ip**
   - Limit: **15**
6. **Visualization:** Bar Chart
7. **Title:** `Top Source IP Addresses`
8. Click **"Save"** → **"Add to dashboard"**

#### 2.4 Add Widget: Top Destination IPs (Bar Chart)
1. Repeat above with:
   - **Field:** **suricata_dest_ip**
   - **Title:** `Top Destination IP Addresses`

#### 2.5 Add Widget: Protocol Distribution (Pie Chart)
1. Repeat pie chart steps with:
   - **Field:** **suricata_proto**
   - **Title:** `Protocol Distribution`

#### 2.6 Add Widget: IDS Alerts Timeline (Line Chart)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e416f0431779656d5d AND suricata_event_type:alert
   ```
3. **Time Range:** Last 24 hours
4. **Metrics:** count()
5. **Group By:**
   - Click **"Columns"**
   - Field: **timestamp**
   - Interval: **5 minutes**
6. **Visualization:** Area Chart
7. **Title:** `IDS Alert Timeline`
8. Click **"Save"** → **"Add to dashboard"**

#### 2.7 Add Widget: Recent Alerts (Table)
1. Click **"Create"** → **"Message Table"**
2. **Query:**
   ```
   streams:695326e416f0431779656d5d AND suricata_event_type:alert
   ```
3. **Time Range:** Last 1 hour
4. **Title:** `Recent IDS Alerts`
5. **Fields to show:**
   - timestamp
   - suricata_src_ip
   - suricata_dest_ip
   - suricata_alert_signature
6. Click **"Save"** → **"Add to dashboard"**

#### 2.8 Add Widget: Total Events (Number)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e416f0431779656d5d
   ```
3. **Time Range:** Last 24 hours
4. **Metrics:** count()
5. **Visualization:** Single Number
6. **Title:** `Total Suricata Events (24h)`
7. Click **"Save"** → **"Add to dashboard"**

---

### Step 3: Create Wazuh Dashboard

#### 3.1 Create Dashboard
1. Click **"Dashboards"** → **"Create new dashboard"**
2. Enter:
   - **Title:** `Wazuh Security Monitoring Dashboard`
   - **Description:** `Host-based security alerts and compliance monitoring`
3. Click **"Create"**

#### 3.2 Add Widget: Alert Severity Levels (Pie Chart)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e516f0431779656d6a
   ```
3. **Time Range:** Last 1 hour
4. **Metrics:** count()
5. **Group By:**
   - Field: **wazuh_rule_level**
   - Limit: **10**
6. **Visualization:** Pie Chart
7. **Title:** `Alert Severity Levels`
8. Click **"Save"** → **"Add to dashboard"**

#### 3.3 Add Widget: Top Alert Rules (Bar Chart)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e516f0431779656d6a
   ```
3. **Time Range:** Last 1 hour
4. **Metrics:** count()
5. **Group By:**
   - Field: **wazuh_rule_description**
   - Limit: **15**
6. **Visualization:** Bar Chart
7. **Title:** `Most Common Alert Rules`
8. Click **"Save"** → **"Add to dashboard"**

#### 3.4 Add Widget: Alert Timeline (Area Chart)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e516f0431779656d6a
   ```
3. **Time Range:** Last 24 hours
4. **Metrics:** count()
5. **Group By:**
   - **Columns:** timestamp (5 minute intervals)
   - **Rows:** wazuh_rule_level
6. **Visualization:** Area Chart (Stacked)
7. **Title:** `Security Alerts Timeline by Severity`
8. Click **"Save"** → **"Add to dashboard"**

#### 3.5 Add Widget: Critical Alerts (Table)
1. Click **"Create"** → **"Message Table"**
2. **Query:**
   ```
   streams:695326e516f0431779656d6a AND wazuh_rule_level:>=10
   ```
3. **Time Range:** Last 24 hours
4. **Title:** `Critical Security Alerts (Level 10+)`
5. **Fields to show:**
   - timestamp
   - wazuh_agent_name
   - wazuh_rule_level
   - wazuh_rule_description
   - wazuh_rule_id
6. Click **"Save"** → **"Add to dashboard"**

#### 3.6 Add Widget: Alerts by Agent (Pie Chart)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e516f0431779656d6a
   ```
3. **Time Range:** Last 1 hour
4. **Metrics:** count()
5. **Group By:**
   - Field: **wazuh_agent_name**
   - Limit: **10**
6. **Visualization:** Pie Chart
7. **Title:** `Alerts by Agent`
8. Click **"Save"** → **"Add to dashboard"**

#### 3.7 Add Widget: Total Alerts (Number)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e516f0431779656d6a
   ```
3. **Time Range:** Last 24 hours
4. **Metrics:** count()
5. **Visualization:** Single Number
6. **Title:** `Total Wazuh Alerts (24h)`
7. Click **"Save"** → **"Add to dashboard"**

#### 3.8 Add Widget: MITRE ATT&CK Techniques (Table)
1. Click **"Create"** → **"Aggregation"**
2. **Query:**
   ```
   streams:695326e516f0431779656d6a AND _exists_:wazuh_rule_mitre_id
   ```
3. **Time Range:** Last 24 hours
4. **Metrics:** count()
5. **Group By:**
   - **Rows:** wazuh_rule_mitre_technique
   - Then by: wazuh_rule_mitre_id
   - Limit: **20**
6. **Visualization:** Data Table
7. **Title:** `MITRE ATT&CK Techniques Detected`
8. Click **"Save"** → **"Add to dashboard"**

---

## Method 3: Bookmarkable Search URLs

Save these URLs as browser bookmarks for instant access:

### Suricata Bookmarks
- **All Events:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d&rangetype=relative&relative=3600)
- **IDS Alerts:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d%20AND%20suricata_event_type%3Aalert&rangetype=relative&relative=3600)
- **DNS Traffic:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d%20AND%20suricata_event_type%3Adns&rangetype=relative&relative=3600)
- **TLS Traffic:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e416f0431779656d5d%20AND%20suricata_event_type%3Atls&rangetype=relative&relative=3600)

### Wazuh Bookmarks
- **All Alerts:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a&rangetype=relative&relative=3600)
- **Critical:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a%20AND%20wazuh_rule_level%3A%3E%3D10&rangetype=relative&relative=86400)
- **High Severity:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a%20AND%20wazuh_rule_level%3A%5B8%20TO%209%5D&rangetype=relative&relative=3600)
- **Auth Events:** [Click here](http://127.0.0.1:9000/search?q=streams%3A695326e516f0431779656d6a%20AND%20wazuh_rule_groups%3A%2Aauthentication%2A&rangetype=relative&relative=3600)

---

## Verification

Check that data is flowing:

### Check Suricata Stream
```bash
curl -s -u "admin:admin" "http://127.0.0.1:9000/api/search/universal/relative?query=streams:695326e416f0431779656d5d&range=60&limit=1" | jq -r '.total_results'
```

### Check Wazuh Stream
```bash
curl -s -u "admin:admin" "http://127.0.0.1:9000/api/search/universal/relative?query=streams:695326e516f0431779656d6a&range=60&limit=1" | jq -r '.total_results'
```

### Check Extracted Fields
```bash
# Suricata fields
curl -s -u "admin:admin" "http://127.0.0.1:9000/api/search/universal/relative?query=streams:695326e416f0431779656d5d&range=60&limit=1" | jq -r '.messages[0].message | keys | map(select(startswith("suricata_"))) | .[0:5]'

# Wazuh fields
curl -s -u "admin:admin" "http://127.0.0.1:9000/api/search/universal/relative?query=streams:695326e516f0431779656d6a&range=60&limit=1" | jq -r '.messages[0].message | keys | map(select(startswith("wazuh_"))) | .[0:5]'
```

---

## Summary

**✅ Configured:**
- Suricata and Wazuh streams (active)
- JSON field extractors (working)
- Direct access URLs (ready to use)

**📋 To Complete:**
- Follow Method 2 above to create dashboards (10 minutes)
- OR use Method 1 URLs for immediate access

**📖 Documentation:**
- This guide: `/home/dshannon/GRAYLOG_DASHBOARDS_CREATED.md`
- Detailed guide: `/home/dshannon/GRAYLOG_DASHBOARDS_GUIDE.md`
- Integration: `/home/dshannon/GRAYLOG_INTEGRATION_SUMMARY.md`

**Access Graylog:** http://127.0.0.1:9000

All infrastructure is ready - dashboards can be built in under 10 minutes using the step-by-step instructions above!
