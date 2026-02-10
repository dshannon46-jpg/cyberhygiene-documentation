# Wazuh Email Notification Configuration

## Summary

Wazuh email notifications have been configured to **only send emails for critical security events** (Level 10 and above). This will dramatically reduce email volume while ensuring you're immediately notified of severe security threats.

---

## Configuration Changes

### Before
- **Email Alert Level:** 7 (medium-high and above)
- **Max Emails Per Hour:** 50
- **Expected Volume:** 20-50+ emails per day

### After ✅
- **Email Alert Level:** 10 (critical only)
- **Max Emails Per Hour:** 20
- **Expected Volume:** 1-5 emails per day (or fewer)
- **Configuration Applied:** December 29, 2025 at 18:17 MST

---

## What Triggers Email Alerts Now

You will ONLY receive immediate email notifications for:

### Level 10 - Critical Events
- Multiple authentication failures from same source
- System file modifications (rootkit indicators)
- Critical system errors
- Successful brute force attacks

### Level 11 - Severe Events
- Integrity checksum changed (critical system files)
- Known attack patterns detected
- Active attack indicators

### Level 12 - High Severity
- High importance event
- Attack detected with high confidence
- Severe policy violations

### Level 13-15 - Critical/Emergency
- System compromise indicators
- Rootkit detected
- Active intrusion attempts
- Security breaches

---

## Example Critical Alerts (Level 10+)

Common alerts you'll receive emails for:

| Rule ID | Level | Description |
|---------|-------|-------------|
| 5712 | 10 | Multiple authentication failures followed by success |
| 5720 | 10 | Multiple password authentication failures |
| 5503 | 10 | User missed the password more than one time |
| 5551 | 10 | Integrity checksum changed |
| 5402 | 10 | Successful sudo to ROOT executed multiple times |
| 550 | 10 | Integrity checksum changed (critical files) |
| 18152 | 12 | Multiple Windows Logon Failures |
| 31151 | 12 | Syscheck integrity checksum changed |
| 100100 | 12 | First time user executed sudo |
| 510 | 12 | Host-based anomaly detection event (rootcheck) |

---

## What You Won't Get Emails For (Still Logged)

These events are still logged to Graylog and visible in Wazuh dashboard, but won't trigger immediate emails:

### Level 3-6 (Low)
- SELinux permission denials
- Informational events
- Low-priority audit events
- Service status changes

### Level 7-9 (Medium-High)
- Failed login attempts (single occurrence)
- File changes in monitored directories
- New processes or services
- Configuration changes
- Package installations/updates
- Standard security events

**All these events are still:**
- ✅ Logged to `/var/ossec/logs/alerts/alerts.json`
- ✅ Forwarded to Graylog for analysis
- ✅ Visible in Wazuh dashboard
- ✅ Included in compliance reports
- ❌ NOT sent as immediate emails

---

## Monitoring Non-Critical Events

### Via Graylog
Access your Graylog dashboard to monitor all security events:

**URL:** http://127.0.0.1:9000 or https://graylog.cyberinabox.net

**Search for all Wazuh alerts:**
```
streams:695326e516f0431779656d6a
```

**Search by severity:**
```
# Medium severity (level 5-7)
streams:695326e516f0431779656d6a AND wazuh_rule_level:[5 TO 7]

# High severity (level 8-9)
streams:695326e516f0431779656d6a AND wazuh_rule_level:[8 TO 9]

# Critical (level 10+) - what gets emailed
streams:695326e516f0431779656d6a AND wazuh_rule_level:>=10
```

### Via Wazuh Dashboard
If you have Wazuh dashboard configured:
- View all alerts in real-time
- Create custom visualizations
- Set up additional alert channels (Slack, PagerDuty, etc.)

---

## Optional: Daily Summary Reports

If you want a daily summary email of ALL alerts (in addition to critical alerts), you can enable Wazuh reports:

### Option 1: Via Wazuh API (Advanced)
```bash
# Create a daily report job
curl -X POST "http://localhost:55000/manager/reports" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Daily Security Summary",
    "description": "Daily summary of all security alerts",
    "type": "email",
    "frequency": "daily",
    "recipients": ["dshannon@cyberinabox.net"]
  }'
```

### Option 2: Via Cron Job (Simple)
Add a daily email summary via cron:

```bash
# Add to crontab
0 8 * * * /var/ossec/bin/wazuh-reportd daily-summary | mail -s "Wazuh Daily Summary" dshannon@cyberinabox.net
```

### Option 3: Use Graylog Scheduled Reports
Configure Graylog to send daily/weekly summary reports:
1. Go to Graylog → Enterprise → Reports
2. Create new report for Wazuh stream
3. Schedule daily/weekly delivery

---

## Configuration Files

### Main Configuration
**File:** `/var/ossec/etc/ossec.conf`

**Relevant section:**
```xml
<global>
  <email_notification>yes</email_notification>
  <smtp_server>localhost</smtp_server>
  <email_from>wazuh@cyberinabox.net</email_from>
  <email_to>dshannon@cyberinabox.net</email_to>
  <email_maxperhour>20</email_maxperhour>
</global>

<alerts>
  <log_alert_level>3</log_alert_level>
  <email_alert_level>10</email_alert_level>
</alerts>
```

### Backup
A backup of your previous configuration was created:
```bash
/var/ossec/etc/ossec.conf.backup-20251229-181735
```

To restore previous settings (level 7):
```bash
sudo cp /var/ossec/etc/ossec.conf.backup-20251229-181735 /var/ossec/etc/ossec.conf
sudo systemctl restart wazuh-manager
```

---

## Testing Email Notifications

### Method 1: Trigger a Test Alert (Safe)
```bash
# This will trigger a rule level 3 alert (won't send email, just logs)
logger "Wazuh test message - This is a test"

# To test email, you'd need to trigger a level 10+ event
# Example: Multiple failed sudo attempts
```

### Method 2: Send Test Email via Wazuh
```bash
# Use wazuh-maild to send a test email
echo "Test alert from Wazuh" | sudo /var/ossec/bin/wazuh-maild -t
```

### Check Email Queue
```bash
# Check if emails are queued
sudo /var/ossec/bin/wazuh-maild -f
```

---

## Adjusting Alert Levels

If you find you're getting too many or too few emails, you can adjust the threshold:

### More Emails (Lower Threshold)
```bash
# Change to level 8 (high severity and above)
sudo sed -i 's/<email_alert_level>10<\/email_alert_level>/<email_alert_level>8<\/email_alert_level>/' /var/ossec/etc/ossec.conf
sudo systemctl restart wazuh-manager
```

### Fewer Emails (Higher Threshold)
```bash
# Change to level 12 (severe only)
sudo sed -i 's/<email_alert_level>10<\/email_alert_level>/<email_alert_level>12<\/email_alert_level>/' /var/ossec/etc/ossec.conf
sudo systemctl restart wazuh-manager
```

### Disable Email Notifications
```bash
# Turn off all email notifications
sudo sed -i 's/<email_notification>yes<\/email_notification>/<email_notification>no<\/email_notification>/' /var/ossec/etc/ossec.conf
sudo systemctl restart wazuh-manager
```

---

## Custom Email Rules

You can create custom email rules for specific events regardless of level:

### Example: Email for Specific Rule IDs
Add to `/var/ossec/etc/ossec.conf` in the `<global>` section:

```xml
<!-- Custom email alerts for specific rules -->
<email_alerts>
  <email_to>dshannon@cyberinabox.net</email_to>
  <rule_id>5712,5720</rule_id>  <!-- Multiple auth failures -->
  <do_not_delay/>
</email_alerts>

<email_alerts>
  <email_to>dshannon@cyberinabox.net</email_to>
  <group>authentication_failed</group>  <!-- All auth failures -->
  <do_not_delay/>
</email_alerts>
```

### Example: Email for Specific Agents
```xml
<email_alerts>
  <email_to>dshannon@cyberinabox.net</email_to>
  <event_location>dc1.cyberinabox.net</event_location>
  <level>8</level>
</email_alerts>
```

---

## Monitoring Email Activity

### Check Recent Emails Sent
```bash
# View Wazuh mail log
sudo tail -50 /var/ossec/logs/alerts/alerts.log | grep -i "Rule: "

# Check system mail log
sudo tail -50 /var/log/maillog
```

### Count Emails Sent Today
```bash
# Count level 10+ alerts today
sudo grep "$(date +%Y\ %b\ %d)" /var/ossec/logs/alerts/alerts.log | grep -c "Rule:.*Level: 1[0-5]"
```

### View Email Alert History
```bash
# Last 10 critical alerts that triggered emails
sudo tail -100 /var/ossec/logs/alerts/alerts.log | grep -A5 "Level: 1[0-5]"
```

---

## Integration with Graylog

Your Wazuh alerts are already forwarded to Graylog. You can:

1. **Create Graylog Alert Conditions** for level 10+ events
2. **Set up Slack/Discord/PagerDuty** notifications in Graylog
3. **Build dashboards** showing critical alert trends
4. **Create scheduled reports** for weekly summaries

**Graylog Critical Alerts Search:**
```
streams:695326e516f0431779656d6a AND wazuh_rule_level:>=10
```

---

## Troubleshooting

### Not Receiving Emails

1. **Check Wazuh mail daemon is running:**
   ```bash
   ps aux | grep wazuh-maild
   ```

2. **Test SMTP connectivity:**
   ```bash
   telnet localhost 25
   ```

3. **Check Wazuh logs:**
   ```bash
   sudo tail -50 /var/ossec/logs/ossec.log | grep -i mail
   ```

4. **Verify email configuration:**
   ```bash
   sudo grep -A5 "email_notification" /var/ossec/etc/ossec.conf
   ```

### Too Many Emails Still

If you're still getting too many emails:

1. **Increase threshold to level 12:**
   ```bash
   sudo sed -i 's/<email_alert_level>10/<email_alert_level>12/' /var/ossec/etc/ossec.conf
   sudo systemctl restart wazuh-manager
   ```

2. **Reduce max emails per hour:**
   ```bash
   sudo sed -i 's/<email_maxperhour>20/<email_maxperhour>5/' /var/ossec/etc/ossec.conf
   sudo systemctl restart wazuh-manager
   ```

3. **Disable specific noisy rules** (see next section)

### Disable Noisy Alert Rules

If specific rules are generating too many emails:

```bash
# Find the rule ID from your emails
# Add to ossec.conf in <ruleset> section
<rule_exclude>rule_id_here.xml</rule_exclude>

# Or create a custom rule to override level
# Create /var/ossec/etc/rules/local_rules.xml
```

---

## Summary

✅ **Email alerts reduced from level 7+ to level 10+**
✅ **Max emails per hour reduced from 50 to 20**
✅ **Wazuh manager restarted and running**
✅ **All events still logged and sent to Graylog**
✅ **Backup configuration saved**

**Expected Result:**
Your inbox will now only receive critical security alerts (1-5 per day instead of 20-50+), while all security monitoring continues normally in Graylog and Wazuh logs.

**Files Modified:**
- `/var/ossec/etc/ossec.conf` - Email configuration updated
- Backup: `/var/ossec/etc/ossec.conf.backup-20251229-181735`

**Documentation:**
- `/home/dshannon/WAZUH_EMAIL_CONFIGURATION.md` (this file)
- `/home/dshannon/GRAYLOG_INTEGRATION_SUMMARY.md` (log forwarding)
- `/home/dshannon/GRAYLOG_DASHBOARDS_GUIDE.md` (dashboard creation)
