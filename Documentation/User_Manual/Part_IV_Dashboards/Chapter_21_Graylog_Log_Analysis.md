# Chapter 21: Log Analysis (Graylog)

## 21.1 Graylog Interface

### Accessing Graylog

**URL:** https://graylog.cyberinabox.net

**Login Process:**
1. Navigate to Graylog URL
2. Enter username and password
3. Click "Sign in"
4. Dashboard loads

**Access Levels:**
- **Reader:** View logs and dashboards (standard users)
- **Editor:** Create searches and dashboards
- **Admin:** Full system configuration

### Graylog Dashboard Overview

**Main Interface Layout:**

```
┌─────────────────────────────────────────────────────┐
│ [Graylog Logo]  Search  Streams  Dashboards  [User] │
├─────────────────────────────────────────────────────┤
│ Search: [_____________________________] [Search]     │
│ Time Range: [Last 5 minutes ▼]  [Auto-refresh ▼]   │
├─────────────────────────────────────────────────────┤
│ Message Count Over Time (Graph)                      │
│ ┌─────────────────────────────────────────────────┐ │
│ │     ▂▄█▆▃▂                                      │ │
│ └─────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────┤
│ Recent Messages                                      │
│ ┌───────────────────────────────────────────────┐   │
│ │ 2025-12-31 15:23:45 dc1 sshd: Accepted...    │   │
│ │ 2025-12-31 15:23:44 proxy suricata: Alert... │   │
│ │ 2025-12-31 15:23:43 wazuh ossec: File...     │   │
│ └───────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

**Key Components:**

**1. Search Bar (Top)**
- Enter search queries
- Time range selector
- Auto-refresh toggle
- Quick filters

**2. Message Timeline (Middle)**
- Histogram of log volume
- Visual spike detection
- Clickable time periods
- Color-coded severity

**3. Message List (Bottom)**
- Recent log messages
- Expandable details
- Field extraction
- Export options

**4. Sidebar (Left - when expanded)**
- Streams (log categories)
- Saved searches
- Dashboards
- System information

### Navigation

**Top Menu:**
```
Search      - Query logs, create searches
Streams     - Categorized log flows
Dashboards  - Saved visualizations
System      - Configuration (admin only)
```

**Quick Actions:**
- **Search:** Start searching immediately
- **Recent Searches:** Access saved queries
- **Dashboards:** View pre-built dashboards
- **Alerts:** Check active alerts

## 21.2 Log Search and Filtering

### Basic Search

**Simple Keyword Search:**
```
Failed

Results: All messages containing "Failed"
Example: "Failed password", "Connection failed", etc.
```

**Exact Phrase:**
```
"Failed password"

Results: Only messages with exact phrase
```

**Field Search:**
```
source:dc1

Results: All messages from dc1.cyberinabox.net
```

**Multiple Criteria:**
```
source:dc1 AND Failed

Results: Messages from dc1 containing "Failed"
```

### Advanced Search Syntax

**Logical Operators:**

```
AND - Both conditions must match
source:dc1 AND sshd

OR - Either condition matches
Failed OR Error

NOT - Exclude matches
source:dc1 NOT systemd

() - Group conditions
(Failed OR Error) AND source:dc1
```

**Wildcards:**

```
* - Multiple characters
auth*
Results: authentication, authorize, authorized, etc.

? - Single character
fail?d
Results: failed, failes, failid, etc.
```

**Field Existence:**

```
_exists_:username
Results: Messages with username field

NOT _exists_:error_code
Results: Messages without error_code field
```

**Numeric Comparisons:**

```
response_time:>1000
Results: Response time greater than 1000ms

status_code:[400 TO 499]
Results: HTTP 4xx errors

http_status:>=500
Results: HTTP 5xx server errors
```

### Common Search Examples

**Failed Login Attempts:**
```
Search: Failed password
Time Range: Last 24 hours
Fields: timestamp, source, username, source_ip

Example Results:
2025-12-31 14:23:45 dc1 Failed password for admin from 203.0.113.45
2025-12-31 14:23:30 dc1 Failed password for root from 203.0.113.45
```

**SSH Connections:**
```
Search: sshd AND Accepted
Time Range: Last 7 days
Fields: timestamp, source, username, source_ip

Results: All successful SSH logins
```

**Error Messages:**
```
Search: level:error OR level:critical
Time Range: Last 1 hour
Sort: Newest first

Results: All error and critical severity logs
```

**Specific User Activity:**
```
Search: username:jsmith
Time Range: Last 30 days
Fields: timestamp, source, action, details

Results: All actions by user jsmith
```

**Web Server Errors:**
```
Search: source:proxy AND status_code:>=500
Time Range: Last 24 hours
Fields: timestamp, status_code, url, response_time

Results: All 5xx server errors
```

**Security Events:**
```
Search: (alert OR warning) AND security
Time Range: Last 7 days
Sort: Newest first

Results: Security alerts and warnings
```

### Time Range Selection

**Preset Ranges:**
```
Last 5 minutes
Last 15 minutes
Last 1 hour
Last 24 hours
Last 7 days
Last 30 days
```

**Absolute Range:**
```
From: 2025-12-31 09:00:00
To:   2025-12-31 17:00:00

Use for: Specific time period investigation
```

**Relative Range:**
```
Last 2 hours
Last 3 days
Last 1 week

Use for: Recent activity analysis
```

**Keyword Time:**
```
yesterday
last week
last month

Use for: Quick time-based searches
```

### Field Extraction

**Common Fields:**

**System Fields:**
- `timestamp` - When event occurred
- `source` - System that generated log
- `message` - Full log message
- `level` - Severity (debug, info, warn, error)

**Application Fields:**
- `application` - Application name (sshd, httpd, etc.)
- `facility` - Syslog facility (auth, daemon, etc.)
- `process_id` - PID of process

**Custom Fields (Extracted):**
- `username` - User involved
- `source_ip` - Source IP address
- `action` - Action performed
- `status_code` - HTTP status code
- `response_time` - Request duration

**View Fields:**
1. Click any log message to expand
2. See all extracted fields
3. Click field name to:
   - Add to search
   - Show statistics
   - Create visualization

## 21.3 Common Queries

### Authentication Queries

**All Login Attempts:**
```
Query: sshd AND (Accepted OR Failed)
Fields: timestamp, username, source_ip, result
Time: Last 24 hours

Purpose: Monitor authentication activity
```

**Failed Logins by IP:**
```
Query: Failed password
Group By: source_ip
Sort: Count descending
Time: Last 7 days

Purpose: Identify brute force attempts
```

**Successful Logins After Failures:**
```
Query 1: Failed password AND source_ip:203.0.113.45
Query 2: Accepted AND source_ip:203.0.113.45
Time: Last 1 hour

Purpose: Detect potential compromise
```

**Account Lockouts:**
```
Query: faillock OR "account locked"
Fields: timestamp, username, source
Time: Last 24 hours

Purpose: Track locked accounts
```

### System Health Queries

**Service Restarts:**
```
Query: systemd AND (Started OR Stopped)
Fields: timestamp, source, service, action
Time: Last 7 days

Purpose: Track service stability
```

**Disk Space Warnings:**
```
Query: "disk space" OR "filesystem full"
Level: warning OR error
Time: Last 24 hours

Purpose: Prevent disk full issues
```

**High CPU/Memory:**
```
Query: (cpu OR memory) AND (high OR critical)
Source: monitoring
Time: Last 1 hour

Purpose: Performance troubleshooting
```

**System Errors:**
```
Query: level:error NOT (test OR expected)
Time: Last 24 hours
Sort: Count by source

Purpose: Identify problematic systems
```

### Security Queries

**Sudo Commands:**
```
Query: sudo AND COMMAND
Fields: timestamp, username, command, source
Time: Last 7 days

Purpose: Audit privileged actions
```

**File Changes (AIDE):**
```
Query: aide AND (added OR changed OR removed)
Fields: timestamp, file_path, change_type
Time: Last 24 hours

Purpose: File integrity monitoring
```

**Firewall Blocks:**
```
Query: firewalld AND (REJECT OR DROP)
Fields: timestamp, source_ip, port, protocol
Time: Last 1 hour

Purpose: Identify blocked attacks
```

**Wazuh Security Alerts:**
```
Query: wazuh AND alert_level:>=7
Fields: timestamp, rule_description, source, severity
Time: Last 24 hours

Purpose: High-priority security events
```

**Suricata IDS Alerts:**
```
Query: suricata AND event_type:alert
Fields: timestamp, alert_signature, src_ip, dest_ip
Time: Last 1 hour

Purpose: Network intrusion detection
```

### Application Queries

**Web Server Access:**
```
Query: application:httpd AND status_code:200
Fields: timestamp, client_ip, url, response_time
Time: Last 1 hour

Purpose: Monitor web traffic
```

**Database Queries:**
```
Query: application:postgresql AND duration:>1000
Fields: timestamp, query, duration, user
Time: Last 24 hours

Purpose: Identify slow queries
```

**API Errors:**
```
Query: api AND status_code:>=400
Fields: timestamp, endpoint, status_code, error
Time: Last 1 hour

Purpose: API troubleshooting
```

**Email Delivery:**
```
Query: postfix AND (sent OR bounced OR deferred)
Fields: timestamp, from, to, status
Time: Last 24 hours

Purpose: Email delivery monitoring
```

## 21.4 Alert Configuration

### Creating Alerts

**Alert Types:**

**1. Event Count Alert**
```
Condition: Count of messages
Threshold: > 10
Time Period: 5 minutes
Example: "Alert if more than 10 failed logins in 5 minutes"
```

**2. Field Value Alert**
```
Condition: Field contains value
Field: level
Value: error OR critical
Example: "Alert on any error or critical message"
```

**3. Statistical Alert**
```
Condition: Statistical anomaly
Metric: Response time
Threshold: > 2 standard deviations
Example: "Alert if response time is abnormally high"
```

**4. Correlation Alert**
```
Condition: Multiple events match pattern
Pattern: Failed login followed by successful login
Example: "Alert on potential brute force success"
```

### Alert Configuration Steps

**Step 1: Define Search**
```
1. Create search query
2. Test to verify it matches expected events
3. Note the query syntax
```

**Step 2: Set Conditions**
```
Condition Type: Message count
Threshold: More than 5
Time Range: Last 5 minutes
Grace Period: 1 minute (avoid alert spam)
```

**Step 3: Configure Notifications**
```
Notification Type: Email
Recipients: security@cyberinabox.net
Subject: [ALERT] Failed Login Attempts Detected
Body Template:
  Alert: ${alert.title}
  Condition: ${alert.condition}
  Triggered: ${alert.triggered_at}
  Search: ${alert.search_query}
  Message Count: ${alert.result.matching_messages}
```

**Step 4: Test and Enable**
```
1. Click "Test" to generate test alert
2. Verify notification received
3. Enable alert
4. Monitor for false positives
```

### Common Alert Examples

**High Failed Login Rate:**
```
Name: Brute Force Detection
Query: Failed password
Condition: More than 10 in 5 minutes
Grace Period: 5 minutes
Notification: Email to security team
```

**Service Down:**
```
Name: Critical Service Stopped
Query: systemd AND Stopped AND (sshd OR httpd OR postgresql)
Condition: Any match
Notification: Immediate email + SMS
```

**Disk Space Critical:**
```
Name: Disk Space Warning
Query: "filesystem.*90%" OR "disk.*full"
Condition: Any match
Grace Period: 1 hour (avoid spam)
Notification: Email to admins
```

**Security Alert:**
```
Name: High Severity Security Event
Query: (wazuh OR suricata) AND alert_level:>=12
Condition: Any match
Notification: Email to security team, create ticket
```

**Unusual Sudo Activity:**
```
Name: Unexpected Privileged Commands
Query: sudo AND NOT (systemctl OR journalctl)
Condition: More than 5 in 10 minutes
Notification: Email to security team
```

### Alert Management

**Alert Dashboard:**
- View all configured alerts
- See alert status (enabled/disabled)
- Check last trigger time
- Review alert history

**Alert Actions:**
- **Enable/Disable:** Temporarily turn off alerts
- **Modify:** Update conditions or notifications
- **Clone:** Create similar alert
- **Delete:** Remove alert

**Alert Tuning:**
```
Problem: Too many false positives
Solution:
  1. Increase threshold
  2. Add exclusions to query
  3. Increase grace period

Problem: Missed events
Solution:
  1. Decrease threshold
  2. Broaden query
  3. Reduce grace period
```

## 21.5 Log Retention

### Retention Policy

**Current Settings:**
```
Hot Storage (Elasticsearch):
  - Duration: 90 days
  - Purpose: Fast searching and analysis
  - Location: graylog.cyberinabox.net

Warm Storage (Archive):
  - Duration: 1 year
  - Purpose: Compliance and historical analysis
  - Location: /datastore/backups/graylog-archives/

Cold Storage (Backup):
  - Duration: 7 years
  - Purpose: Long-term audit trail
  - Location: Encrypted offsite backups
```

**Log Volume:**
```
Daily Ingestion: ~100 GB compressed
Monthly Storage: ~3 TB
Annual Storage: ~36 TB (before archive compression)
```

**Retention by Log Type:**

| Log Type | Hot | Warm | Cold | Reason |
|----------|-----|------|------|--------|
| **Security Logs** | 90 days | 1 year | 7 years | Audit compliance |
| **Access Logs** | 90 days | 1 year | 3 years | Forensic analysis |
| **System Logs** | 90 days | 6 months | 1 year | Troubleshooting |
| **Debug Logs** | 7 days | None | None | Development only |

### Searching Archived Logs

**Recent Logs (0-90 days):**
```
Standard search - Full-speed Elasticsearch
No special configuration needed
```

**Archived Logs (90 days - 1 year):**
```
1. Contact administrator
2. Specify date range needed
3. Admin restores archive to searchable index
4. Search as normal
5. Archive removed from hot storage after investigation
```

**Cold Storage (> 1 year):**
```
1. Submit formal request with justification
2. Requires management approval
3. Restoration may take 24-48 hours
4. Limited to specific time ranges
```

### Log Cleanup

**Automatic Cleanup:**
```
Daily Process (2:00 AM):
  1. Identify logs older than 90 days
  2. Compress and archive to warm storage
  3. Delete from Elasticsearch
  4. Verify archive integrity
  5. Free disk space
```

**Manual Cleanup (Emergency):**
```
Contact administrator if:
  - Disk space critically low
  - Need to free space immediately
  - Archive specific logs early
```

**Data Deletion:**
```
Permanent deletion only:
  - After retention period expires
  - With documented justification
  - Approved by management
  - Logged for audit trail
```

---

**Graylog Quick Reference:**

**Access:** https://graylog.cyberinabox.net

**Search Syntax:**
```
Keyword search:        Failed
Exact phrase:          "Failed password"
Field search:          source:dc1
AND:                   source:dc1 AND Failed
OR:                    Failed OR Error
NOT:                   Failed NOT test
Wildcards:             auth* OR fail?d
Field exists:          _exists_:username
Numeric:               response_time:>1000
Range:                 status_code:[400 TO 499]
```

**Time Ranges:**
- Last 5/15 minutes, 1/24 hours, 7/30 days
- Absolute: Specific date/time range
- Relative: yesterday, last week
- Keyword: today, last month

**Common Searches:**
```
Failed logins:         Failed password
SSH access:            sshd AND Accepted
Errors:                level:error
User activity:         username:jsmith
Security alerts:       alert_level:>=7
Service status:        systemd AND (Started OR Stopped)
```

**Alert Setup:**
1. Create search query
2. Set condition and threshold
3. Configure notification (email)
4. Test and enable

**Retention:**
- Hot (searchable): 90 days
- Warm (archive): 1 year
- Cold (backup): 7 years
- Security logs: Longest retention

**For Help:**
- Search syntax: Click "?" in search bar
- Log not appearing: Check time range
- Missing fields: Contact admin to configure extractors
- Archive access: Email dshannon@cyberinabox.net

---

**Related Chapters:**
- Chapter 16: CPM Dashboard Overview
- Chapter 17: Wazuh Security Monitoring
- Chapter 22: Incident Response
- Appendix D: Troubleshooting Guide

**External Resources:**
- Graylog Documentation: https://docs.graylog.org/
- Search Query Language: https://docs.graylog.org/docs/query-language
- Log Management: Contact administrator for advanced features
