# Graylog YARA Malware Detection Dashboard

## Executive Summary

**Created**: December 30, 2025
**Purpose**: Real-time monitoring and visualization of YARA malware detections
**Data Source**: Wazuh alerts from /var/log/yara.log
**Dashboard Components**: 13 widgets covering detections, trends, categories, and threat intelligence

This dashboard provides comprehensive visibility into YARA malware detections from both custom rules and VirusTotal community signatures.

## Dashboard Overview

### Widgets Included

1. **Total YARA Detections** (Counter) - 24-hour detection count with trend
2. **Detections Over Time** (Line Chart) - Hourly trend visualization
3. **Detections by Severity** (Pie Chart) - Breakdown by critical/high/medium/info
4. **Top Detected Rules** (Quick Values) - Most frequently triggered YARA rules
5. **Detections by Category** (Pie Chart) - Linux/webshells/crypto/exploits/APT breakdown
6. **Most Detected Files** (Table) - Files with multiple detection hits
7. **Recent Detections** (Message Table) - Last 50 YARA alerts with details
8. **Linux Malware Counter** - Specific count for Linux malware detections
9. **Webshell Counter** - Web application backdoor detections
10. **Crypto Miner Counter** - Cryptocurrency mining malware
11. **APT Group Counter** - Advanced persistent threat detections
12. **File Hashes** (Table) - SHA256 hashes for threat intelligence lookups

### Key Features

- **Real-time updates**: Dashboard refreshes automatically
- **Time range selection**: View last hour, 24 hours, 7 days, or custom range
- **Drill-down capability**: Click any widget to see detailed logs
- **Export functionality**: Download data as CSV for analysis
- **Alert integration**: Links to Wazuh alert details

## Installation

### Prerequisites

- Graylog 5.x or higher
- Wazuh manager with YARA integration
- YARA rules installed (custom + VirusTotal)
- Network connectivity: Wazuh → Graylog (port 12202/UDP)

### Step 1: Configure Wazuh to Send YARA Alerts to Graylog

The Wazuh integration forwards YARA detection alerts to Graylog via GELF UDP.

**Integration Files** (already created):
- `/var/ossec/integrations/graylog` - Shell wrapper script
- `/var/ossec/integrations/graylog.py` - Python GELF forwarder

**Wazuh Configuration** (`/var/ossec/etc/ossec.conf`):
```xml
<!-- Graylog Integration for YARA Alerts -->
<integration>
  <name>graylog</name>
  <hook_url>udp://127.0.0.1:12202</hook_url>
  <level>10</level>
  <rule_id>100110,100111,100102,100103,100104</rule_id>
  <alert_format>json</alert_format>
</integration>
```

**Rule IDs Explained**:
- `100110`: Generic YARA detection (level 10)
- `100111`: Critical YARA detection (level 12)
- `100102`: Medium severity (level 7)
- `100103`: High severity (level 10)
- `100104`: Critical severity (level 12)

**Apply Configuration**:
```bash
sudo systemctl restart wazuh-manager
sudo systemctl status wazuh-manager
```

### Step 2: Verify Graylog Input

Ensure Graylog has a GELF UDP input on port 12202:

**Check existing inputs**:
```bash
curl -s -X GET "http://localhost:9000/api/system/inputs" \
  -H "Accept: application/json" -u admin:admin | jq '.inputs[] | select(.attributes.port == 12202)'
```

**Expected output**:
```json
{
  "title": "Wazuh Security Alerts",
  "type": "org.graylog2.inputs.gelf.udp.GELFUDPInput",
  "global": true,
  "attributes": {
    "port": 12202,
    "bind_address": "0.0.0.0"
  }
}
```

If no input exists, create one via Graylog web UI:
1. Navigate to **System → Inputs**
2. Select **GELF UDP** from dropdown
3. Click **Launch new input**
4. Configure:
   - **Title**: "Wazuh YARA Alerts"
   - **Port**: 12202
   - **Bind address**: 0.0.0.0
5. Click **Save**

### Step 3: Create JSON Extractor for YARA Fields

The YARA logs contain JSON data that needs to be parsed into searchable fields.

**Via Graylog Web UI**:

1. Go to **System → Inputs**
2. Find "Wazuh Security Alerts" (port 12202)
3. Click **Manage extractors**
4. Click **Actions → Import extractors**
5. Upload `/tmp/graylog_yara_extractor.json`

**Or create manually**:

1. Go to **System → Inputs → Wazuh Security Alerts → Manage extractors**
2. Click **Get started**
3. Load a message containing "YARA_DETECTION"
4. Select message field
5. Choose **JSON** extractor type
6. Configure:
   - **Title**: "YARA Detection JSON Parser"
   - **Source field**: message
   - **Condition**: string contains "YARA_DETECTION"
   - **Key prefix**: yara_
7. Test and save

**Extracted Fields**:
- `yara_rule_name` - Name of triggered YARA rule
- `yara_rule_file` - Source file (e.g., virustotal/linux/MALW_LinuxMoose.yar)
- `yara_severity` - Severity level (info/medium/high/critical)
- `yara_file_path` - Path to detected file
- `yara_file_hash` - SHA256 hash
- `yara_description` - Rule description
- `yara_event_type` - Always "yara_detection"
- `yara_timestamp` - Detection timestamp

### Step 4: Import Dashboard

**Method 1: Via Web UI**:

1. Navigate to **Dashboards** in Graylog
2. Click **Create dashboard**
3. Title: "YARA Malware Detection"
4. Click **Import content** (gear icon)
5. Upload `/tmp/graylog_yara_dashboard.json`
6. Save dashboard

**Method 2: Via API**:

```bash
curl -X POST "http://localhost:9000/api/dashboards" \
  -H "Content-Type: application/json" \
  -H "X-Requested-By: cli" \
  -u admin:admin \
  -d @/tmp/graylog_yara_dashboard.json
```

### Step 5: Test Detection Flow

Create a test malware file and verify end-to-end detection:

```bash
# Create test file with YARA signatures
cat > /tmp/yara_test_detection.txt << 'EOF'
Test YARA malware detection
3AES
VERSONEX
Hacker
EOF

# Scan with YARA (triggers Wazuh alert)
sudo python3 /var/ossec/ruleset/yara/scripts/yara-integration.py /tmp/yara_test_detection.txt

# Check YARA log
sudo tail -3 /var/log/yara.log | grep YARA_DETECTION

# Check Wazuh alerts
sudo tail -20 /var/ossec/logs/alerts/alerts.log | grep "100110"

# Wait 5-10 seconds, then check Graylog
curl -s "http://localhost:9000/api/search/universal/relative?query=LinuxAESDDoS&range=300&limit=1" \
  -u admin:admin | jq '.total_results'

# Clean up
rm /tmp/yara_test_detection.txt
```

**Expected Flow**:
1. YARA scan detects malware → logs to /var/log/yara.log
2. Wazuh monitors log → generates alert (rule 100110)
3. Wazuh integration → forwards to Graylog (port 12202)
4. Graylog receives GELF message → parses JSON fields
5. Dashboard displays detection in real-time

## Using the Dashboard

### Accessing the Dashboard

1. Log into Graylog web interface
2. Navigate to **Dashboards**
3. Select **YARA Malware Detection**

### Time Range Selection

- **Quick ranges**: Last hour, 24 hours, 7 days, 30 days
- **Custom range**: Click clock icon to specify exact dates/times
- **Relative**: "Last 4 hours", "Last 30 minutes", etc.
- **Absolute**: "2025-12-30 00:00:00 to 2025-12-30 23:59:59"

### Widget Interactions

**Click any widget** to:
- Drill down into raw log messages
- Add fields to search
- Create custom visualizations
- Export data as CSV

**Hover over charts** to see:
- Exact values
- Timestamps
- Percentages

### Common Searches

#### Search for Specific Malware Family

```
yara_rule_name:LinuxMoose
```

#### High Severity Detections Only

```
yara_severity:(high OR critical) AND yara_event_type:yara_detection
```

#### Webshell Detections

```
yara_rule_file:*webshell* AND yara_event_type:yara_detection
```

#### Detections in Specific Directory

```
yara_file_path:/var/www/* AND yara_event_type:yara_detection
```

#### Multiple Detections of Same File

```
yara_event_type:yara_detection | stats count() by yara_file_hash | sort count desc
```

#### APT Group Activity

```
yara_rule_file:*apt* OR yara_rule_name:*APT*
```

#### Cryptocurrency Miners

```
yara_rule_file:*crypto* OR yara_rule_name:*miner*
```

### Threat Intelligence Integration

For each detected file, look up the SHA256 hash in threat intelligence databases:

**VirusTotal**:
```bash
HASH=$(echo "detected_hash_here")
echo "https://www.virustotal.com/gui/file/$HASH"
```

**Hybrid Analysis**:
```
https://www.hybrid-analysis.com/search?query=[hash]
```

**Any.run**:
```
https://any.run/submissions/?hash=[hash]
```

**MalwareBazaar**:
```
https://bazaar.abuse.ch/browse.php?search=sha256:[hash]
```

## Alert Configuration

### Create Graylog Alert for Critical Detections

1. Go to **Alerts → Event Definitions**
2. Click **Create Event Definition**
3. Configure:
   - **Title**: "Critical YARA Malware Detection"
   - **Priority**: High
   - **Condition Type**: Filter & Aggregation
   - **Search Query**: `yara_severity:critical AND yara_event_type:yara_detection`
   - **Search within**: Last 5 minutes
   - **Execute search every**: 1 minute
   - **Condition**: More than 0 messages
4. **Notifications**:
   - Email to: security@company.com
   - Slack/PagerDuty integration
   - HTTP callback for SOAR integration

### Alert Message Template

```
CRITICAL YARA MALWARE DETECTION

Malware: ${yara_rule_name}
File: ${yara_file_path}
Hash: ${yara_file_hash}
Severity: ${yara_severity}
Rule: ${yara_rule_file}
Description: ${yara_description}
Host: ${source}
Timestamp: ${timestamp}

Threat Intelligence:
https://www.virustotal.com/gui/file/${yara_file_hash}

Recommended Actions:
1. Quarantine the file immediately
2. Check for additional compromise indicators
3. Review process tree and network connections
4. Scan other systems for same hash
5. Update YARA rules if new variant detected
```

### Alert Severity Mapping

| YARA Severity | Alert Priority | Email | Slack | PagerDuty |
|---------------|----------------|-------|-------|-----------|
| critical      | Critical       | Yes   | Yes   | Yes       |
| high          | High           | Yes   | Yes   | No        |
| medium        | Medium         | No    | Yes   | No        |
| info          | Low            | No    | No    | No        |

## Dashboard Maintenance

### Weekly Tasks

1. **Review detection trends**
   - Are detections increasing? Investigate why
   - New malware families appearing?
   - Repeat detections on same files? (possible false positives)

2. **Update YARA rules**
   - Pull latest from VirusTotal repository
   - Add custom rules for organization-specific threats
   - Test rules for false positives

3. **Validate alerts**
   - Confirm critical alerts were investigated
   - Document false positives
   - Update whitelist as needed

### Monthly Tasks

1. **Dashboard optimization**
   - Remove unused widgets
   - Add new visualization based on emerging threats
   - Adjust time ranges based on data volume

2. **Integration health**
   - Verify Wazuh → Graylog connectivity
   - Check for dropped messages
   - Review integration logs for errors

3. **Threat intelligence**
   - Cross-reference detected hashes with threat feeds
   - Identify campaign patterns
   - Share IOCs with security community

### Quarterly Tasks

1. **Rule effectiveness review**
   - Which rules triggered most frequently?
   - Which rules never triggered? (remove or improve)
   - Detection rate vs false positive rate

2. **Dashboard performance**
   - Query response times acceptable?
   - Need to archive old data?
   - Index optimization required?

## Troubleshooting

### No Detections Appearing in Dashboard

**Check 1: YARA is detecting malware**
```bash
# Create test malware
echo -e "3AES\nVERSONEX" > /tmp/test.txt

# Scan manually
sudo python3 /var/ossec/ruleset/yara/scripts/yara-integration.py /tmp/test.txt

# Check log
sudo tail /var/log/yara.log | grep YARA_DETECTION
```

**Check 2: Wazuh is generating alerts**
```bash
sudo tail -50 /var/ossec/logs/alerts/alerts.log | grep "100110"
```

**Check 3: Integration is running**
```bash
sudo tail -50 /var/ossec/logs/integrations.log
# Look for "graylog" and error messages
```

**Check 4: Graylog is receiving messages**
```bash
# Search for recent YARA-related messages
curl -s "http://localhost:9000/api/search/universal/relative?query=YARA&range=3600&limit=1" \
  -u admin:admin | jq '.total_results'
```

**Check 5: JSON extractor is working**
```bash
# Search for extracted YARA fields
curl -s "http://localhost:9000/api/search/universal/relative?query=_exists_:yara_rule_name&range=3600" \
  -u admin:admin | jq '.total_results'
```

### Detections Appearing but Fields Not Extracted

**Problem**: Messages contain "YARA_DETECTION" but `yara_rule_name` field is empty

**Solution**:
1. Go to **System → Inputs → Wazuh Security Alerts**
2. Click **Manage extractors**
3. Find "YARA Detection JSON Parser"
4. Click **Edit**
5. Test with sample message
6. Verify "Key prefix" is set to `yara_`
7. Ensure extractor is **enabled**
8. Save and reload

### Dashboard Widgets Show "No Data"

**Check 1: Time range too narrow**
- Expand to "Last 7 days" to see if any historical data exists

**Check 2: Query syntax**
- Dashboard uses: `YARA_DETECTION OR yara_event_type:yara_detection`
- If fields aren't extracted, only `YARA_DETECTION` will match

**Check 3: Index permissions**
- Ensure user has read access to Graylog indices

### High False Positive Rate

**Problem**: Legitimate files triggering YARA rules

**Solution 1: Update whitelist**
```bash
# Get file hash
sha256sum /path/to/false/positive

# Add to YARA whitelist
sudo nano /var/ossec/ruleset/yara/rules/00_whitelist.yar
```

**Solution 2: Tune rule specificity**
- Increase threshold (e.g., 3 indicators instead of 2)
- Add more specific patterns
- Exclude system directories from FIM

**Solution 3: Adjust severity**
- Change rule metadata to lower severity
- Update Wazuh alert rules to filter noise

### Integration Script Errors

**Error**: "Wrong arguments"

**Fix**:
```bash
# Verify script accepts 2 arguments (host, port)
sudo /var/ossec/integrations/graylog.py 127.0.0.1 12202 < /tmp/test_alert.json

# Check permissions
ls -la /var/ossec/integrations/graylog*
# Should be: -rwxr-x--- root wazuh

# Test GELF connectivity
echo '{"version":"1.1","host":"test","short_message":"test"}' | gzip | nc -u 127.0.0.1 12202
```

## Performance Optimization

### High Message Volume

If YARA detections exceed 1000/hour:

**Option 1: Sampling**
- Configure Wazuh to sample alerts (send 1 in 10)
- Preserve critical/high severity, sample info/medium

**Option 2: Aggregation**
- Group detections by file hash
- Send summary instead of individual alerts

**Option 3: Separate Stream**
- Create dedicated Graylog stream for YARA
- Apply custom processing rules
- Store on faster disks

### Dashboard Loading Slow

**Optimization 1: Reduce time range**
- Default to "Last 24 hours" instead of "Last 7 days"
- Archive old data to separate index

**Optimization 2: Limit quick values**
- Reduce from 50 to 10-20 results
- Disable pie charts on high-cardinality fields

**Optimization 3: Use saved searches**
- Pre-compute expensive queries
- Cache results for 5 minutes

### Index Size Growing Rapidly

**Strategy 1: Index rotation**
```
# Rotate daily instead of weekly
# Keep last 30 days of YARA data
# Archive to S3/cold storage after 30 days
```

**Strategy 2: Field optimization**
- Don't index unused fields
- Use analyzed fields only where needed
- Store but don't index large descriptions

## Advanced Use Cases

### Correlation with Suricata IDS

Detect malware downloaded via network:

```
# Find IDS alerts for suspicious downloads
source:suricata AND event_type:fileinfo AND (fileinfo.filename:*.exe OR fileinfo.filename:*.sh)

# Cross-reference file hashes
fileinfo_sha256:[detected_yara_hash]
```

### Hunting for Unknown Malware

Find files with multiple YARA rule hits (possible sophisticated malware):

```
yara_event_type:yara_detection
| stats count() by yara_file_hash, yara_file_path
| where count > 3
| sort count desc
```

### Tracking Malware Campaigns

Group detections by time and similarity:

```
yara_rule_name:*
| timechart span=1h count() by yara_rule_name
```

### Automated Response Integration

Use Graylog HTTP callback to trigger SOAR platform:

```json
{
  "webhook_url": "https://soar.company.com/api/incident",
  "payload": {
    "title": "YARA Malware: ${yara_rule_name}",
    "severity": "${yara_severity}",
    "ioc": "${yara_file_hash}",
    "host": "${source}",
    "action": "quarantine_and_investigate"
  }
}
```

## Dashboard Customization

### Add New Widget

1. Click **Unlock/Edit**
2. Click **Create → Visualization**
3. Configure:
   - **Search query**: `yara_event_type:yara_detection`
   - **Visualization type**: Chart, table, or metric
   - **Field**: Select YARA field to visualize
   - **Aggregation**: Count, average, sum, etc.
4. Position widget on dashboard
5. Click **Save dashboard**

### Example Custom Widgets

**Top 10 Infected Hosts**:
- Type: Quick Values
- Field: `source`
- Query: `yara_severity:(high OR critical)`

**Detection Rate by Hour**:
- Type: Line Chart
- Interval: 1 hour
- Aggregation: Count

**Average File Size of Detected Malware**:
- Type: Number
- Field: `yara_file_size`
- Aggregation: Average

## Files Reference

### Dashboard Configuration Files

- `/tmp/graylog_yara_dashboard.json` - Dashboard import file
- `/tmp/graylog_yara_extractor.json` - JSON field extractor
- `/var/ossec/integrations/graylog` - Wazuh integration wrapper
- `/var/ossec/integrations/graylog.py` - GELF forwarder script
- `/var/ossec/etc/ossec.conf` - Wazuh configuration
- `/var/ossec/etc/rules/local_rules.xml` - YARA detection rules (100110-100111)

### Log Files

- `/var/log/yara.log` - YARA scan results
- `/var/ossec/logs/alerts/alerts.log` - Wazuh alerts
- `/var/ossec/logs/integrations.log` - Integration execution logs
- `/var/ossec/logs/ossec.log` - Wazuh manager logs

## Security Considerations

### Access Control

- **Dashboard access**: Restrict to security team only
- **Search permissions**: Limit who can see file hashes
- **Export controls**: Log all CSV exports for audit

### Data Retention

- **Compliance**: Check if PCI-DSS/HIPAA requires specific retention
- **GDPR**: File paths may contain user data - consider anonymization
- **Storage costs**: Balance retention vs. storage budget

### Sensitive Information

YARA logs may contain:
- **File paths**: May reveal user names, project names
- **File hashes**: Can be used to identify proprietary software
- **Descriptions**: May reference internal projects

**Recommendations**:
1. Encrypt Graylog indices at rest
2. Restrict API access with strong authentication
3. Redact sensitive file paths in alerts
4. Limit dashboard sharing outside security team

## Support and Resources

### Documentation

- **YARA Rules**: `/home/dshannon/VIRUSTOTAL_YARA_RULES.md`
- **False Positives**: `/home/dshannon/YARA_FALSE_POSITIVES_FIXED.md`
- **Wazuh Integration**: `/var/ossec/ruleset/yara/README.md`

### Useful Commands

```bash
# Restart all services
sudo systemctl restart wazuh-manager
sudo systemctl restart graylog-server

# Check service status
sudo systemctl status wazuh-manager graylog-server

# Test YARA detection manually
sudo python3 /var/ossec/ruleset/yara/scripts/yara-integration.py /path/to/file

# View live YARA log
sudo tail -f /var/log/yara.log

# View live Wazuh alerts
sudo tail -f /var/ossec/logs/alerts/alerts.log | grep "100110"

# Test Graylog API connectivity
curl -u admin:admin http://localhost:9000/api/system/cluster/nodes
```

### External Resources

- **Graylog Documentation**: https://docs.graylog.org/
- **Wazuh Integration**: https://documentation.wazuh.com/current/user-manual/manager/manual-integration.html
- **YARA Documentation**: https://yara.readthedocs.io/
- **VirusTotal YARA**: https://github.com/Yara-Rules/rules
- **GELF Format**: https://go2docs.graylog.org/5-0/getting_in_log_data/gelf.html

## Appendix: Sample Queries

### 1. Malware Detection Timeline

```
yara_event_type:yara_detection
| timechart span=1d count()
| eval trend=if(count>avg(count), "Increasing", "Decreasing")
```

### 2. Unique Malware Families Detected

```
yara_event_type:yara_detection
| dedup yara_rule_name
| table yara_rule_name, yara_description, yara_rule_file
```

### 3. Repeat Offenders (Same File, Multiple Detections)

```
yara_event_type:yara_detection
| stats count() by yara_file_hash, yara_file_path
| where count > 1
| sort -count
```

### 4. Detection by Directory

```
yara_event_type:yara_detection
| rex field=yara_file_path "^(?<directory>/[^/]+/[^/]+)"
| stats count() by directory
| sort -count
```

### 5. Zero-Day Detection Candidates

```
yara_event_type:yara_detection AND yara_rule_file:custom*
| where NOT [search yara_rule_file:virustotal*]
| table yara_file_hash, yara_file_path, yara_rule_name
```

---

**Document Version**: 1.0
**Last Updated**: December 30, 2025
**Author**: CyberInABox Security Team
**Review Date**: January 30, 2026
