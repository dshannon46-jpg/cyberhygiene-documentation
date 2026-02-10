# Wazuh Operations and Alert Management Guide
**System:** dc1.cyberinabox.net
**Date:** October 28, 2025
**Version:** Wazuh v4.9.2

---

## Does Wazuh Require User Interaction?

### **NO - Wazuh is Fully Automated** ✓

Wazuh operates **completely autonomously** with zero user interaction required:

- ✅ **Automatic log collection** from all monitored sources (journald, syslog, application logs)
- ✅ **Real-time analysis** of all security events using correlation rules
- ✅ **Automatic alert generation** when suspicious activity is detected
- ✅ **Continuous vulnerability scanning** with hourly database updates
- ✅ **Automated file integrity checks** every 12 hours + real-time monitoring
- ✅ **Security configuration assessment** scanning against CIS benchmarks
- ✅ **Self-monitoring** - Wazuh monitors itself as Agent ID 000

**You can ignore Wazuh completely and it will continue protecting your system 24/7/365.**

---

## How Does Wazuh Report Security Issues?

Wazuh provides **multiple reporting methods** depending on your needs:

### 1. Log Files (Default - Currently Active) ✓

**Location:** `/var/ossec/logs/alerts/`

**Two Formats Available:**

#### Human-Readable Format: `alerts.log`
```
** Alert 1761696917.631769: - syslog,sudo,pci_dss_10.2.5,nist_800_53_AU.14
2025 Oct 28 18:15:17 dc1.cyberinabox.net->journald
Rule: 5402 (level 3) -> 'Successful sudo to ROOT executed.'
User: root
Oct 29 00:15:17 dc1.cyberinabox.net sudo[284025]: root : USER=root ; COMMAND=/bin/grep
```

**Good for:** Quick visual inspection, troubleshooting, ad-hoc queries

#### JSON Format: `alerts.json`
```json
{
  "timestamp":"2025-10-28T18:15:17.550-0600",
  "rule":{
    "level":3,
    "description":"Successful sudo to ROOT executed.",
    "id":"5402",
    "mitre":{"id":["T1548.003"],"tactic":["Privilege Escalation"]},
    "nist_800_53":["AU.14","AC.7","AC.6"]
  },
  "agent":{"id":"000","name":"dc1.cyberinabox.net"},
  "data":{
    "srcuser":"root",
    "command":"/bin/grep"
  }
}
```

**Good for:** Programmatic analysis, parsing scripts, integration with other tools

**View Alerts:**
```bash
# Real-time alert monitoring
sudo tail -f /var/ossec/logs/alerts/alerts.log

# View recent alerts (human-readable)
sudo tail -100 /var/ossec/logs/alerts/alerts.log

# View alerts in JSON format
sudo tail -100 /var/ossec/logs/alerts/alerts.json

# Search for specific alerts
sudo grep "level 10" /var/ossec/logs/alerts/alerts.log
sudo grep "Failed password" /var/ossec/logs/alerts/alerts.log
```

---

### 2. Email Notifications (Currently Disabled - Can Enable)

**Current Status:** ⚠️ DISABLED

**Current Configuration:**
```
Email Notifications: NO
Alert Level Threshold: 12 (only critical alerts would trigger email)
SMTP Server: smtp.example.wazuh.com (not configured)
```

**What This Means:**
- All alerts are logged to files (Level 3+)
- Only alerts Level 12+ would trigger emails IF email was enabled
- Currently: No emails are sent

**Alert Level Scale:**
- **Level 0-2:** Ignored (not logged)
- **Level 3-6:** Low priority (sudo commands, logins, file changes)
- **Level 7-10:** Medium priority (multiple failed logins, unusual activity)
- **Level 11-15:** High priority (attacks, policy violations)
- **Level 16+:** Critical (successful attacks, root compromise)

**To Enable Email Alerts:**

1. **After email server is deployed** (POA&M-002, Dec 20), edit `/var/ossec/etc/ossec.conf`:
```xml
<global>
  <email_notification>yes</email_notification>
  <smtp_server>mail.cyberinabox.net</smtp_server>
  <email_from>wazuh@cyberinabox.net</email_from>
  <email_to>don@contractcoach.com</email_to>
  <email_maxperhour>12</email_maxperhour>
  <email_alert_level>10</email_alert_level>  <!-- Change to 10 for medium+ alerts -->
</global>
```

2. Restart Wazuh Manager:
```bash
sudo systemctl restart wazuh-manager
```

---

### 3. Wazuh Indexer (Currently Active - Stores All Alerts)

**Status:** ✓ OPERATIONAL

The Wazuh Indexer (OpenSearch-based) **automatically stores all alerts** in a searchable database.

**Access Methods:**

#### A. API Queries (Advanced)
```bash
# Get recent alerts via API
curl -k -XGET "https://localhost:9200/wazuh-alerts-*/_search?size=10&sort=timestamp:desc" \
  -u "admin:PASSWORD" | jq .
```

#### B. Command-Line Queries
```bash
# Query the indexer for high-level alerts
sudo /var/ossec/bin/wazuh-db "agent 000 sql select * from fim_file limit 10"
```

**Storage:**
- Location: `/var/lib/wazuh-indexer/nodes/`
- Retention: Default 90 days (configurable)
- Format: Searchable JSON documents
- Size: Scales with alert volume

---

### 4. Wazuh API (Programmatic Access)

**Status:** ✓ OPERATIONAL

**Base URL:** `https://localhost:55000`

**Authentication Required:**
- Username: `wazuh` or `wazuh-wui`
- Password: See `/root/wazuh-credentials.txt`

**Example Usage:**

```bash
# Get authentication token
TOKEN=$(curl -k -u wazuh:PASSWORD -X POST \
  "https://localhost:55000/security/user/authenticate" \
  | jq -r .data.token)

# Get recent alerts
curl -k -X GET "https://localhost:55000/manager/alerts?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Get agent status
curl -k -X GET "https://localhost:55000/agents?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Get vulnerability scan results
curl -k -X GET "https://localhost:55000/vulnerability/000?pretty=true" \
  -H "Authorization: Bearer $TOKEN"
```

**API Documentation:** https://documentation.wazuh.com/current/user-manual/api/reference.html

---

## Current Alert Configuration

### Alert Thresholds
- **Log Alerts:** Level 3+ (all significant events)
- **Email Alerts:** Level 12+ (currently disabled, email not configured)

### What's Being Monitored Right Now

✅ **Authentication Events:**
- SSH logins (successful and failed)
- Sudo command execution
- PAM session events
- User account changes

✅ **System Events:**
- Service starts/stops
- System reboots
- Kernel messages
- Log file rotations

✅ **File Integrity:**
- `/etc` directory changes
- `/usr/bin`, `/usr/sbin` modifications
- `/bin`, `/sbin`, `/boot` changes
- Real-time monitoring active

✅ **Security Events:**
- Failed authentication attempts
- Privilege escalation attempts
- Policy violations
- Suspicious command execution

✅ **Vulnerability Detection:**
- CVE database updates hourly
- Package vulnerability scanning
- Continuous monitoring of installed software

✅ **Configuration Compliance:**
- CIS Rocky Linux 9 Benchmark
- NIST 800-53 controls
- PCI DSS requirements
- HIPAA compliance checks

### Compliance Mappings in Alerts

Every alert includes automatic compliance mappings:
- **NIST 800-53:** AU.14, AC.7, AC.6, etc.
- **PCI DSS:** 10.2.5, 10.2.2, etc.
- **HIPAA:** 164.312.b, etc.
- **GDPR:** IV_32.2, etc.
- **MITRE ATT&CK:** T1548.003 (Privilege Escalation), etc.

---

## How to Monitor Alerts Without Dashboard

Since we **cannot use the Wazuh Dashboard** (FIPS incompatibility), here are alternative methods:

### Method 1: Real-Time Log Monitoring (Easiest)

**Watch alerts as they happen:**
```bash
sudo tail -f /var/ossec/logs/alerts/alerts.log
```

**Filter for high-priority only:**
```bash
sudo tail -f /var/ossec/logs/alerts/alerts.log | grep "level [0-9][0-9]"
```

**Filter for specific events:**
```bash
sudo tail -f /var/ossec/logs/alerts/alerts.log | grep -i "failed\|attack\|exploit"
```

---

### Method 2: Daily Summary Script (Recommended)

Create a daily summary script to review alerts:

```bash
#!/bin/bash
# /usr/local/bin/wazuh-daily-summary.sh

echo "=== Wazuh Daily Security Summary ==="
echo "Date: $(date)"
echo ""

echo "High Priority Alerts (Level 10+):"
sudo grep -E "level (1[0-9]|[2-9][0-9])" /var/ossec/logs/alerts/alerts.log | tail -20
echo ""

echo "Failed Authentication Attempts:"
sudo grep -i "authentication failed\|failed password" /var/ossec/logs/alerts/alerts.log | wc -l
echo ""

echo "Sudo Command Executions:"
sudo grep "5402" /var/ossec/logs/alerts/alerts.log | wc -l
echo ""

echo "File Integrity Changes:"
sudo grep "syscheck" /var/ossec/logs/alerts/alerts.log | tail -10
echo ""

echo "New Vulnerabilities Detected:"
sudo grep "vulnerability" /var/ossec/logs/alerts/alerts.log | tail -10
```

**Make it executable and run daily:**
```bash
sudo chmod +x /usr/local/bin/wazuh-daily-summary.sh
sudo /usr/local/bin/wazuh-daily-summary.sh
```

**Add to cron for automatic daily email:**
```bash
0 8 * * * /usr/local/bin/wazuh-daily-summary.sh | mail -s "Wazuh Daily Summary" don@contractcoach.com
```

---

### Method 3: Critical Alert Monitoring (For Security Events)

**Check for critical security events daily:**

```bash
# Check for failed login attempts
sudo grep "authentication_failed" /var/ossec/logs/alerts/alerts.json | jq .

# Check for rootkit detection
sudo grep "rootcheck" /var/ossec/logs/alerts/alerts.log

# Check for file integrity violations
sudo grep "syscheck.*Modified" /var/ossec/logs/alerts/alerts.log

# Check for new vulnerabilities
sudo grep "vulnerability-detector" /var/ossec/logs/alerts/alerts.log

# Check for exploit attempts
sudo grep -E "exploit|attack|malware" /var/ossec/logs/alerts/alerts.log
```

---

### Method 4: Integration with Wazuh API (Advanced)

For custom dashboards or integration with other tools, use the Wazuh API to query alerts programmatically.

**Python Example:**
```python
import requests
from requests.auth import HTTPBasicAuth
import json

# Authenticate
auth_response = requests.post(
    'https://localhost:55000/security/user/authenticate',
    auth=HTTPBasicAuth('wazuh', 'PASSWORD'),
    verify=False
)
token = auth_response.json()['data']['token']

# Get recent alerts
headers = {'Authorization': f'Bearer {token}'}
alerts = requests.get(
    'https://localhost:55000/manager/alerts?limit=10',
    headers=headers,
    verify=False
)

print(json.dumps(alerts.json(), indent=2))
```

---

## Example Alert Scenarios

### Scenario 1: Failed SSH Login Attempt

**Wazuh automatically detects and logs:**
```
** Alert 1761697XXX.XXXXXX: - syslog,sshd,authentication_failed
Rule: 5710 (level 5) -> 'sshd: Attempt to login using a non-existent user'
Src IP: 203.0.113.42
Oct 28 19:30:15 dc1 sshd[12345]: Failed password for invalid user admin from 203.0.113.42
```

**What happens:**
1. ✅ Alert logged to `/var/ossec/logs/alerts/alerts.log`
2. ✅ Alert stored in Wazuh Indexer for historical analysis
3. ✅ Compliance tags added (NIST AU.14, PCI DSS 10.2.5)
4. ⚠️ Email NOT sent (level 5 < threshold of 12)

**How you'd discover it:**
- Daily log review
- Daily summary script
- Real-time monitoring if active
- API query for failed authentication events

---

### Scenario 2: Malware Detection (Future - Once ClamAV Active)

**Wazuh would automatically detect and log:**
```
** Alert XXXXXXXXX.XXXXXX: - virus,malware
Rule: 510 (level 12) -> 'ClamAV: Virus detected'
File: /home/user/Downloads/malware.exe
Virus: Trojan.Generic.12345
```

**What happens:**
1. ✅ Alert logged immediately
2. ✅ Email WOULD be sent (level 12 = threshold)
3. ✅ Stored in indexer with virus name
4. ✅ Compliance tags: NIST SI-3, PCI DSS 5.1

---

### Scenario 3: Unauthorized File Change

**Wazuh File Integrity Monitoring detects:**
```
** Alert XXXXXXXXX.XXXXXX: - syscheck,pci_dss_11.5
Rule: 550 (level 7) -> 'Integrity checksum changed.'
File: /etc/passwd
Changes: Modified
Size changed from: 2145 to 2189
```

**What happens:**
1. ✅ Alert logged with file details
2. ✅ SHA256 checksums recorded (before/after)
3. ✅ User who made change identified
4. ⚠️ Email NOT sent (level 7 < 12)
5. ✅ Compliance: NIST SI-7, PCI DSS 11.5

---

### Scenario 4: Critical Vulnerability Discovered

**Wazuh Vulnerability Scanner detects:**
```
** Alert XXXXXXXXX.XXXXXX: - vulnerability-detector
Rule: 23505 (level 10) -> 'CVE-YYYY-XXXXX (High) affects package: openssl'
Severity: High
CVSS Score: 7.5
Package: openssl-1.1.1k-7
CVE: CVE-YYYY-XXXXX
```

**What happens:**
1. ✅ Alert logged with CVE details
2. ✅ Severity and CVSS score included
3. ✅ Affected package identified
4. ⚠️ Email NOT sent (level 10 < 12, but close!)
5. ✅ Recommendation: Patch via dnf update

---

## Recommended Monitoring Strategy

### Daily (5 minutes)
```bash
# Quick check for high-priority alerts
sudo grep "level 1[0-9]" /var/ossec/logs/alerts/alerts.log | tail -20

# Check vulnerability scan results
sudo /var/ossec/bin/agent_control -i 000 | grep -i vulnerability
```

### Weekly (15 minutes)
```bash
# Review all alerts from past week
sudo grep "$(date -d '7 days ago' +%Y\ %b\ %d)" /var/ossec/logs/alerts/alerts.log | less

# Check File Integrity Monitoring summary
sudo grep "syscheck" /var/ossec/logs/alerts/alerts.log | wc -l

# Review Security Configuration Assessment results
sudo grep "sca:" /var/ossec/logs/ossec.log | tail -50
```

### Monthly (30 minutes)
```bash
# Full security review
sudo /usr/local/bin/wazuh-monthly-report.sh

# Update any custom rules or configurations
# Review and tune alert thresholds
# Check for Wazuh software updates
```

---

## Future Enhancements

### When Email Server is Deployed (Dec 20, 2025)

**Enable Email Alerts:**
- Configure SMTP settings in ossec.conf
- Lower email threshold from 12 to 10 (medium+ alerts)
- Receive immediate notification of security events
- Daily/weekly summary emails

### Optional: Wazuh Dashboard on Separate VM (Jan 2026)

**If you want graphical interface:**
- Deploy Rocky Linux 9 VM WITHOUT FIPS mode
- Install Wazuh Dashboard on that VM
- Point it to dc1's Wazuh Indexer (192.168.1.10:9200)
- Access via web browser for visual analysis

**Benefits:**
- Visual dashboards and graphs
- Click-through alert investigation
- Real-time event maps
- Compliance reporting

---

## Summary

### User Interaction Required: **NONE** ✓

Wazuh operates completely autonomously 24/7/365 with zero user interaction.

### How Security Issues Are Reported:

1. **✅ Automatic Logging** (Active Now)
   - All alerts logged to `/var/ossec/logs/alerts/`
   - Human-readable and JSON formats
   - View anytime with `tail` or `grep`

2. **⏳ Email Notifications** (Available After Email Server Deployed)
   - Currently disabled (no email server yet)
   - Can enable for critical alerts (level 12+)
   - Configurable thresholds

3. **✅ Wazuh Indexer** (Active Now)
   - All alerts stored in searchable database
   - 90-day retention (configurable)
   - Query via API or command-line

4. **✅ Wazuh API** (Active Now)
   - Programmatic access to all alerts
   - Integration with custom tools
   - Real-time and historical queries

### Recommended Approach:

**For now:** Daily/weekly log file review
**After Dec 20:** Enable email alerts for critical events
**Optional (Jan 2026):** Deploy dashboard on separate VM for visual interface

**You are protected 24/7 whether you check alerts or not. Wazuh is always watching.**

---

**Documentation:** https://documentation.wazuh.com
**Credentials:** `/root/wazuh-credentials.txt`
**Logs:** `/var/ossec/logs/`
**Configuration:** `/var/ossec/etc/ossec.conf`
