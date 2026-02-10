# YARA Malware Detection - Grafana Dashboard

## Overview

This Grafana dashboard provides real-time visualization of YARA malware detections integrated with your existing Grafana monitoring system. The dashboard queries Elasticsearch (Graylog's backend) to display YARA detection metrics alongside your Suricata and system metrics.

**Dashboard File**: `/tmp/grafana_yara_dashboard.json`

**Dashboard Features**:
- 13 visualization panels
- Real-time malware detection metrics
- Threat categorization (Linux, webshells, crypto miners, APT groups)
- Recent detections table with VirusTotal integration
- Auto-refresh every 30 seconds
- 24-hour default time range

## Dashboard Panels

### Summary Metrics (Row 1)
1. **Total YARA Detections** - Count with trend graph
2. **Critical Detections** - High-priority malware count
3. **Unique Malware Families** - Distinct YARA rules triggered
4. **Infected Hosts** - Number of systems with detections

### Trend Analysis (Row 2)
5. **YARA Detections Over Time** - Time series line chart showing detection patterns

### Distribution Charts (Row 3)
6. **Detections by Severity** - Pie chart (critical/high/medium/info)
7. **Detections by Category** - Donut chart (rule file breakdown)
8. **Top 10 Detected Rules** - Horizontal bar gauge

### Details Table (Row 4)
9. **Recent YARA Detections** - Sortable table with:
   - Timestamp
   - Malware name
   - Severity (color-coded)
   - File path
   - SHA256 hash (clickable VirusTotal link)
   - Description
   - Host

### Category Counters (Row 5)
10. **Linux Malware** - Count of Linux-specific threats
11. **Webshells** - Web application backdoors
12. **Crypto Miners** - Cryptocurrency mining malware
13. **APT Groups** - Advanced persistent threat detections

## Installation

### Prerequisites

✓ Grafana installed and running
✓ Elasticsearch data source configured (Graylog backend)
✓ Wazuh YARA integration active
✓ YARA detections flowing to Graylog/Elasticsearch

### Step 1: Configure Elasticsearch Data Source

**Check if Elasticsearch data source exists**:

```bash
# Via Grafana UI
1. Go to Configuration → Data Sources
2. Look for "Elasticsearch" or "Graylog"

# Via API
curl -s http://localhost:3000/api/datasources \
  -u admin:admin | jq '.[] | select(.type=="elasticsearch")'
```

**If data source doesn't exist, create one**:

1. Navigate to **Configuration → Data Sources**
2. Click **Add data source**
3. Select **Elasticsearch**
4. Configure:
   - **Name**: `Elasticsearch` or `Graylog`
   - **URL**: `http://localhost:9200`
   - **Index name**: `graylog_*` (or your Graylog index pattern)
   - **Time field name**: `timestamp`
   - **Version**: 7.10+ (match your Elasticsearch version)
   - **Min interval**: `10s`
5. Click **Save & Test**

**Expected response**: "Index OK. Time field name OK."

### Step 2: Import Dashboard

**Method 1: Via Grafana Web UI** (Recommended)

1. Log into Grafana: `http://localhost:3000`
2. Click **+** (Create) → **Import**
3. Click **Upload JSON file**
4. Select `/tmp/grafana_yara_dashboard.json`
5. Configure:
   - **Name**: YARA Malware Detection (or keep default)
   - **Folder**: General (or create "Security" folder)
   - **Elasticsearch datasource**: Select your Elasticsearch data source
6. Click **Import**

**Method 2: Via Grafana API**

```bash
# Import dashboard
curl -X POST http://localhost:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d @/tmp/grafana_yara_dashboard.json

# Or using admin credentials
curl -X POST http://localhost:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -u admin:admin \
  -d @/tmp/grafana_yara_dashboard.json
```

**Method 3: Via File System** (if you have file system access)

```bash
# Copy to Grafana provisioning directory
sudo cp /tmp/grafana_yara_dashboard.json \
  /etc/grafana/provisioning/dashboards/

# Set permissions
sudo chown grafana:grafana \
  /etc/grafana/provisioning/dashboards/grafana_yara_dashboard.json

# Restart Grafana
sudo systemctl restart grafana-server

# Dashboard will auto-load on startup
```

### Step 3: Verify Data Flow

**Test that YARA data is queryable**:

```bash
# Check Elasticsearch for YARA data
curl -s "http://localhost:9200/graylog_*/_search?q=yara_rule_name:*&size=1" | jq '.hits.total'

# Should return: {"value": N, "relation": "eq"} where N > 0
```

**If no results**:
1. Verify Wazuh integration is sending to Graylog (see troubleshooting)
2. Check Graylog extractors are parsing JSON fields
3. Confirm index pattern matches Grafana data source

### Step 4: Create Test Detection

```bash
# Generate test malware detection
cat > /tmp/test_malware_grafana.txt << 'EOF'
# Test file for YARA/Grafana integration
3AES
VERSONEX
Hacker
EOF

# Trigger YARA scan
sudo python3 /var/ossec/ruleset/yara/scripts/yara-integration.py \
  /tmp/test_malware_grafana.txt

# Wait 30-60 seconds for data pipeline:
# YARA → Wazuh → Graylog → Elasticsearch

# Check dashboard
echo "Dashboard should now show +1 detection"
echo "http://localhost:3000/d/yara-malware-detection"

# Clean up
rm /tmp/test_malware_grafana.txt
```

**Expected Result in Grafana**:
- "Total YARA Detections" counter increases by 1
- New entry appears in "Recent YARA Detections" table
- "Linux Malware" counter increases by 1
- Time series graph shows spike

## Dashboard Usage

### Accessing the Dashboard

**Direct URL**:
```
http://localhost:3000/d/yara-malware-detection/yara-malware-detection
```

**Via Menu**:
1. Click **Dashboards** (four squares icon)
2. Select **YARA Malware Detection**

Or add to your home dashboard for quick access.

### Time Range Controls

**Quick Ranges** (top right):
- Last 5 minutes
- Last 15 minutes
- Last 30 minutes
- Last 1 hour
- **Last 24 hours** (default)
- Last 7 days
- Last 30 days

**Custom Range**:
- Click time range dropdown
- Select "Absolute time range"
- Set start and end dates
- Click "Apply time range"

**Zoom**:
- Click and drag on any time series chart to zoom into specific period
- Click "Zoom out" to return

### Auto-Refresh

**Enable auto-refresh** (top right):
- Click refresh icon dropdown
- Select interval: 5s, 10s, 30s, 1m, 5m, 15m, 30m, 1h
- **Default: 30s** for YARA dashboard

**Manual refresh**:
- Click refresh icon (circular arrow)

### Panel Interactions

**Click on panel title** → Options:
- **View** - Full-screen view
- **Edit** - Modify query, visualization
- **Share** - Get link, embed code
- **Explore** - Deep dive into raw data
- **Inspect** - See query, response data
- **More...** - Duplicate, copy link, export CSV

**Click on data point**:
- Drill down to specific time period
- Filter by value
- View raw logs in Explore view

**Hover over charts**:
- See exact values
- Compare multiple series
- View timestamps

### Threat Intelligence Lookups

**VirusTotal Integration**:

In the "Recent YARA Detections" table, the SHA256 Hash column is clickable:

1. Click any hash value
2. Opens VirusTotal in new tab
3. View:
   - Detection ratio (e.g., 45/70 vendors)
   - File metadata
   - Behavior analysis
   - Community comments
   - Related samples

**Other Lookups**:

Copy hash from table and search:
- **Hybrid Analysis**: https://www.hybrid-analysis.com/search?query=[hash]
- **Any.run**: https://any.run/submissions/?hash=[hash]
- **MalwareBazaar**: https://bazaar.abuse.ch/browse.php?search=sha256:[hash]

### Filtering Data

**Filter by severity**:
- Click on severity in pie chart
- Or use dashboard variable (if added)

**Filter by host**:
- Click on host name in table
- Shows only detections from that system

**Filter by malware type**:
- Click category in donut chart
- Shows detections from that rule category

**Clear filters**:
- Click "X" on filter tag (top of dashboard)
- Or refresh page

### Exporting Data

**Export panel as CSV**:
1. Click panel title → **Inspect**
2. Click **Data** tab
3. Click **Download CSV**
4. Opens in Excel/LibreOffice

**Export panel as PNG**:
1. Click panel title → **Share**
2. Click **Link** tab
3. Enable "Direct link rendered image"
4. Copy link or click "Copy"

**Export entire dashboard**:
1. Click settings icon (gear) → **JSON Model**
2. Copy JSON
3. Save to file
4. Can re-import later or share with team

## Integration with Existing Dashboards

### Option 1: Add to Existing Security Dashboard

If you have a "Security Overview" dashboard:

1. Open your security dashboard in **Edit mode**
2. Open YARA dashboard in another tab
3. On YARA dashboard, click panel title → **More... → Copy**
4. Switch to security dashboard tab
5. Click **Add panel** → **Paste panel**
6. Position and save

**Recommended panels to copy**:
- Total YARA Detections (stat)
- YARA Detections Over Time (time series)
- Recent YARA Detections (table)

### Option 2: Create Dashboard Row Link

Add a row in your main dashboard that links to YARA dashboard:

1. Edit your main dashboard
2. Click **Add panel** → **Row**
3. Set row title: "🛡️ Malware Detection (YARA)"
4. Click row settings → **Add panel**
5. Choose **Text** visualization
6. Content:
```markdown
## YARA Malware Detection

[Open YARA Dashboard →](/d/yara-malware-detection)

Recent activity: See full dashboard for details
```

### Option 3: Dashboard Playlist

Create a rotating display showing multiple dashboards:

1. Go to **Dashboards** → **Playlists**
2. Click **New Playlist**
3. Name: "Security Monitoring"
4. Add dashboards:
   - Suricata IDS (5 minutes)
   - YARA Malware Detection (5 minutes)
   - System Metrics (5 minutes)
5. Save and **Start playlist**

Perfect for NOC/SOC wall displays!

## Alerts Configuration

### Create Grafana Alert for Critical Malware

1. Edit "Critical Detections" panel
2. Click **Alert** tab
3. Click **Create Alert**
4. Configure:
   - **Name**: Critical YARA Malware Detected
   - **Evaluate every**: 1m
   - **For**: 0m (immediate)
   - **Condition**: WHEN count() OF query(A, 1m, now) IS ABOVE 0
5. **Notifications**:
   - Add notification channel (Email, Slack, PagerDuty)
   - **Message**:
```
CRITICAL: YARA detected ${__value.calc} malware sample(s)

Dashboard: http://localhost:3000/d/yara-malware-detection
Time: ${__time}
```

6. Click **Save** (disk icon top right)

### Alert Notification Channels

**Email Notifications**:

1. Go to **Alerting** → **Notification channels**
2. Click **New channel**
3. Configure:
   - **Name**: Security Team Email
   - **Type**: Email
   - **Addresses**: security@company.com
   - **Include image**: Yes (includes panel screenshot)
4. Click **Send Test**
5. Save

**Slack Integration**:

1. Create Slack webhook: https://api.slack.com/messaging/webhooks
2. In Grafana: **Alerting** → **Notification channels** → **New channel**
3. Configure:
   - **Type**: Slack
   - **Webhook URL**: [your webhook URL]
   - **Channel**: #security-alerts
   - **Mention**: @security-team
4. Test and save

**PagerDuty Integration**:

1. Get Integration Key from PagerDuty service
2. In Grafana: **Notification channels** → **New channel**
3. **Type**: PagerDuty
4. **Integration Key**: [your key]
5. **Severity**: critical
6. Test and save

### Alert Rules Examples

**Alert when malware detected on production servers**:
```
Query: yara_event_type:yara_detection AND source:prod*
Condition: count() IS ABOVE 0
For: 0m (immediate)
Severity: Critical
```

**Alert on APT group detection**:
```
Query: yara_rule_file:*apt* OR yara_rule_name:APT*
Condition: count() IS ABOVE 0
For: 0m
Severity: Critical
Notification: Email + PagerDuty
```

**Alert on unusual spike in detections**:
```
Query: yara_event_type:yara_detection
Condition: count() IS ABOVE 10 (in 5 minutes)
For: 5m
Severity: High
Notification: Slack
```

## Customization

### Add New Panel

1. Click **Add panel** (top right)
2. Select visualization type:
   - **Time series** - Line/bar charts over time
   - **Stat** - Single number with optional graph
   - **Table** - Tabular data
   - **Pie chart** - Distribution
   - **Bar gauge** - Horizontal bars
   - **Gauge** - Meter/dial
3. Configure query:
```json
{
  "query": "yara_event_type:yara_detection",
  "metrics": [{"type": "count"}],
  "bucketAggs": [
    {
      "type": "date_histogram",
      "field": "timestamp",
      "settings": {"interval": "auto"}
    }
  ]
}
```

4. Set panel title, description
5. Click **Apply**

### Modify Existing Panel

**Change time series to bar chart**:
1. Edit panel
2. Click **Visualization** dropdown
3. Select **Bar chart**
4. Adjust settings (orientation, grouping, etc.)
5. Apply

**Add threshold colors**:
1. Edit panel
2. **Field** tab → **Thresholds**
3. Click **Add threshold**
4. Set values and colors:
   - 0 = Green (no detections)
   - 1 = Yellow (warning)
   - 10 = Orange (concern)
   - 50 = Red (critical)

**Add data links**:
1. Edit panel
2. **Field** tab → **Data links**
3. Add link:
   - **Title**: "View in Graylog"
   - **URL**: `http://localhost:9000/search?q=yara_file_hash:${__data.fields.yara_file_hash}`
4. Apply

### Create Variables

**Host filter variable**:

1. **Dashboard settings** (gear icon) → **Variables**
2. Click **Add variable**
3. Configure:
   - **Name**: `host`
   - **Type**: Query
   - **Data source**: Elasticsearch
   - **Query**: `{"find": "terms", "field": "source.keyword"}`
   - **Multi-value**: Yes
   - **Include All option**: Yes
4. Save

**Use variable in panels**:
- Edit panel query
- Add filter: `AND source:$host`

### Dashboard Links

**Add link to Graylog**:

1. Dashboard settings → **Links**
2. Click **New**
3. Configure:
   - **Type**: Link
   - **Title**: "View Raw Logs in Graylog"
   - **URL**: `http://localhost:9000/search?q=yara_event_type:yara_detection&rangetype=relative&from=3600`
   - **Icon**: External link
4. Save

**Link appears in top navigation bar**

## Troubleshooting

### Dashboard Shows "No Data"

**Check 1: Elasticsearch data source connected**
```bash
# Test Elasticsearch connectivity
curl http://localhost:9200/_cluster/health

# Test from Grafana
# Go to Data Sources → Elasticsearch → Save & Test
# Should show: "Index OK. Time field name OK."
```

**Check 2: YARA data exists in Elasticsearch**
```bash
# Query for YARA documents
curl "http://localhost:9200/graylog_*/_search?q=yara_rule_name:*&size=1" \
  | jq '.hits.total.value'

# Should return number > 0
```

**Check 3: Index pattern matches**
```bash
# List Graylog indices
curl http://localhost:9200/_cat/indices/graylog_* | sort

# Verify Grafana data source uses correct pattern
# Should be: graylog_* or graylog_0, graylog_1, etc.
```

**Check 4: Time range contains data**
- Expand time range to "Last 7 days"
- Generate test detection (see Step 4 above)

### Panels Show "Time series fields not supported"

**Problem**: Elasticsearch mapping issue

**Solution**:
1. Go to **Data source settings**
2. Verify **Time field name** is `timestamp`
3. Not `@timestamp` or other field
4. Save & Test

### Query Returns "400 Bad Request"

**Problem**: Query syntax error

**Fix**:
1. Edit problematic panel
2. Click **Query inspector**
3. Check error message
4. Common issues:
   - Field name typo: `yara_rule_name.keyword` (not just `yara_rule_name`)
   - Missing quotes: `yara_severity:"critical"` (not `yara_severity:critical`)
   - Wrong wildcard: `yara_rule_file:*linux*` (correct) vs `yara_rule_file:linux` (won't match subdirectories)

### "SHA256 Hash" Links Not Working

**Problem**: Data links not configured

**Fix**:
1. Edit "Recent YARA Detections" panel
2. Go to **Field** tab
3. Find field override for SHA256 Hash
4. Verify link configuration:
```json
{
  "title": "VirusTotal Lookup",
  "url": "https://www.virustotal.com/gui/file/${__value.raw}"
}
```

5. Apply changes

### Performance Issues / Slow Loading

**Optimization 1: Reduce time range**
- Change default from 24h to 6h or 12h
- Edit dashboard settings → **Time options** → **Default**: "now-12h to now"

**Optimization 2: Limit table rows**
- Edit "Recent YARA Detections" panel
- Change query size from 50 to 20
- Apply

**Optimization 3: Increase refresh interval**
- Change from 30s to 1m or 5m
- Click refresh dropdown → Select longer interval

**Optimization 4: Use caching**
1. Dashboard settings → **General**
2. Enable **Cache timeout**: 60 seconds
3. Reduces Elasticsearch query load

## Advanced Queries

### Custom Elasticsearch Queries

**Find detections with multiple rule matches**:
```json
{
  "query": "yara_event_type:yara_detection",
  "metrics": [{"type": "count"}],
  "bucketAggs": [
    {
      "type": "terms",
      "field": "yara_file_hash.keyword",
      "settings": {"size": 10, "order": "desc"}
    }
  ]
}
```

**Detections in last hour by host**:
```json
{
  "query": "yara_event_type:yara_detection AND timestamp:[now-1h TO now]",
  "metrics": [{"type": "count"}],
  "bucketAggs": [
    {
      "type": "terms",
      "field": "source.keyword"
    }
  ]
}
```

**Critical malware trend (24 hours)**:
```json
{
  "query": "yara_severity:critical",
  "metrics": [{"type": "count"}],
  "bucketAggs": [
    {
      "type": "date_histogram",
      "field": "timestamp",
      "settings": {"interval": "1h"}
    }
  ]
}
```

## Maintenance

### Weekly Tasks

1. **Review dashboard for accuracy**
   - Verify detection counts match reality
   - Check for missing data gaps
   - Test alert notifications

2. **Check false positives**
   - Review "Recent Detections" table
   - Investigate suspicious patterns
   - Update whitelist if needed

3. **Performance check**
   - Dashboard load time < 3 seconds?
   - Elasticsearch query time < 1 second?
   - Optimize slow queries

### Monthly Tasks

1. **Update queries for new YARA rules**
   - If new rule categories added
   - Update category counters
   - Add new panels if needed

2. **Review alert thresholds**
   - Too many false alarms?
   - Missing critical events?
   - Adjust thresholds accordingly

3. **Archive old data**
   - Elasticsearch index growth
   - Rotate or delete old indices
   - Maintain 30-90 days of data

### Backup Dashboard

**Export dashboard JSON**:
```bash
# Via API
curl -H "Authorization: Bearer YOUR_API_KEY" \
  http://localhost:3000/api/dashboards/uid/yara-malware-detection \
  | jq '.dashboard' > yara_dashboard_backup_$(date +%Y%m%d).json

# Or use Grafana UI:
# Settings → JSON Model → Copy to clipboard → Save to file
```

**Store in version control**:
```bash
# Add to git repository
git add grafana_dashboards/yara_malware_detection.json
git commit -m "Update YARA dashboard - added APT panel"
git push
```

## Files and References

### Configuration Files

- `/tmp/grafana_yara_dashboard.json` - Dashboard import file
- `/etc/grafana/grafana.ini` - Grafana main configuration
- `/etc/grafana/provisioning/datasources/` - Data source configs
- `/var/lib/grafana/grafana.db` - Grafana database (includes dashboards)

### Related Documentation

- `/home/dshannon/VIRUSTOTAL_YARA_RULES.md` - YARA rules documentation
- `/home/dshannon/YARA_FALSE_POSITIVES_FIXED.md` - Whitelist configuration
- `/home/dshannon/GRAYLOG_YARA_DASHBOARD.md` - Graylog dashboard (alternative)

### External Resources

- **Grafana Docs**: https://grafana.com/docs/grafana/latest/
- **Elasticsearch Query DSL**: https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html
- **Grafana Dashboards**: https://grafana.com/grafana/dashboards/ (browse community dashboards)

### Support Commands

```bash
# Check Grafana service
sudo systemctl status grafana-server

# View Grafana logs
sudo journalctl -u grafana-server -f

# Restart Grafana
sudo systemctl restart grafana-server

# Test Elasticsearch from Grafana
curl http://localhost:9200/_cat/health

# Generate test YARA detection
sudo python3 /var/ossec/ruleset/yara/scripts/yara-integration.py /tmp/test_file

# Check YARA log
sudo tail -f /var/log/yara.log
```

## Summary

**Dashboard Capabilities**:
✓ Real-time malware detection monitoring
✓ Integration with existing Grafana dashboards
✓ 13 visualization panels covering all threat categories
✓ VirusTotal threat intelligence integration
✓ Customizable alerts and notifications
✓ Auto-refresh and time range controls
✓ Export capabilities (CSV, PNG, JSON)

**Data Flow**:
```
YARA Detection → /var/log/yara.log → Wazuh Alert →
Graylog/Elasticsearch → Grafana Dashboard
```

**Next Steps**:
1. Import dashboard to Grafana
2. Configure alerts for your environment
3. Customize panels based on your needs
4. Integrate with incident response workflows
5. Share dashboard with security team

---

**Document Version**: 1.0
**Created**: December 30, 2025
**Author**: CyberInABox Security Team
**Last Updated**: December 30, 2025
