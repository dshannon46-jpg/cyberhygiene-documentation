# Wazuh Quick Reference Card
**Last Updated:** October 28, 2025

---

## TL;DR - Quick Answers

### Does Wazuh require user interaction?
**NO** - Fully automated, zero interaction required. Set it and forget it.

### How does it report security issues?
**Logs** - All alerts written to `/var/ossec/logs/alerts/alerts.log` (check daily/weekly)

### Do I need to do anything?
**Optional** - Review logs periodically. Wazuh protects you 24/7 whether you check or not.

---

## Essential Commands

### Check Recent Alerts
```bash
# Last 50 alerts (quick scan)
sudo tail -50 /var/ossec/logs/alerts/alerts.log

# Watch alerts in real-time
sudo tail -f /var/ossec/logs/alerts/alerts.log

# High-priority alerts only (level 10+)
sudo grep "level 1[0-9]" /var/ossec/logs/alerts/alerts.log
```

### Check Wazuh Status
```bash
# All components status
sudo /var/ossec/bin/wazuh-control status

# Service status
sudo systemctl status wazuh-manager wazuh-indexer filebeat
```

### Daily Health Check (30 seconds)
```bash
# Quick daily review
sudo tail -100 /var/ossec/logs/alerts/alerts.log | grep -E "level (1[0-9]|[2-9][0-9])"
```

---

## Alert Levels (What They Mean)

| Level | Severity | Example | Action |
|---|---|---|---|
| 0-2 | Ignored | Normal operations | None - not logged |
| 3-6 | **Low** | Logins, sudo commands | Review weekly |
| 7-10 | **Medium** | Multiple failed logins | Review daily |
| 11-15 | **High** | Attacks, policy violations | **Review immediately** |
| 16+ | **Critical** | Root compromise | **Investigate NOW** |

**Current Settings:**
- All alerts level 3+ are logged
- Email alerts would trigger at level 12+ (currently disabled)

---

## What's Being Monitored Right Now

✅ Authentication (SSH, sudo, PAM)
✅ File changes (/etc, /bin, /usr/bin, /boot)
✅ Vulnerabilities (CVE database, hourly updates)
✅ Security config (CIS benchmarks)
✅ System events (service stops, reboots)
✅ Failed logins
✅ Privilege escalation attempts

---

## Common Alert Examples

### Normal Activity (Level 3-6)
```
Rule 5402: Successful sudo to ROOT executed
Rule 5501: PAM: Login session opened
Rule 591: Log file rotated
```
**Action:** No action needed - expected behavior

### Suspicious Activity (Level 7-10)
```
Rule 5710: Attempt to login using non-existent user
Rule 550: File integrity checksum changed
Rule 23505: High severity vulnerability detected
```
**Action:** Review and investigate

### Security Incident (Level 11+)
```
Rule 510: Virus detected
Rule 5712: Multiple authentication failures
Rule 40101: Network attack detected
```
**Action:** Immediate investigation required

---

## Files and Locations

| What | Where |
|---|---|
| **Alerts (human-readable)** | `/var/ossec/logs/alerts/alerts.log` |
| **Alerts (JSON)** | `/var/ossec/logs/alerts/alerts.json` |
| **Manager logs** | `/var/ossec/logs/ossec.log` |
| **Configuration** | `/var/ossec/etc/ossec.conf` |
| **Credentials** | `/root/wazuh-credentials.txt` |
| **Installation summary** | `~/Documents/Claude/Wazuh_Installation_Summary.md` |

---

## Daily Monitoring Routine (5 Minutes)

1. **Check for high-priority alerts:**
   ```bash
   sudo grep "level 1[0-9]" /var/ossec/logs/alerts/alerts.log | tail -20
   ```

2. **Check Wazuh is running:**
   ```bash
   sudo systemctl is-active wazuh-manager
   ```

3. **Done!**

---

## When to Pay Attention

### ⚠️ Review These:
- Multiple failed login attempts from same IP
- File changes in /etc/passwd or /etc/shadow
- New high-severity vulnerabilities (CVSS 7.0+)
- Service crashes or unexpected restarts
- Alerts level 10 or higher

### ✅ Ignore These (Normal):
- Successful sudo commands (level 3)
- Normal SSH logins (level 3)
- Log file rotations (level 3)
- Daily backup script execution
- Automatic package updates

---

## Troubleshooting

### Wazuh Manager Not Running
```bash
sudo systemctl status wazuh-manager
sudo journalctl -u wazuh-manager -n 50
sudo systemctl restart wazuh-manager
```

### No Recent Alerts
```bash
# Check if logging is working
sudo tail /var/ossec/logs/ossec.log

# Check agent status
sudo /var/ossec/bin/agent_control -l
```

### Too Many Alerts
```bash
# Adjust alert level threshold in /var/ossec/etc/ossec.conf
<log_alert_level>5</log_alert_level>  <!-- Increase to reduce noise -->
```

---

## Future: Email Notifications

**After email server deployed (Dec 20, 2025):**

Edit `/var/ossec/etc/ossec.conf`:
```xml
<email_notification>yes</email_notification>
<smtp_server>mail.cyberinabox.net</smtp_server>
<email_from>wazuh@cyberinabox.net</email_from>
<email_to>don@contractcoach.com</email_to>
<email_alert_level>10</email_alert_level>
```

Then restart:
```bash
sudo systemctl restart wazuh-manager
```

---

## API Quick Access

### Get Authentication Token
```bash
curl -k -u wazuh:PASSWORD -X POST \
  https://localhost:55000/security/user/authenticate
```

### Get Recent Alerts (requires token)
```bash
curl -k -X GET "https://localhost:55000/manager/alerts" \
  -H "Authorization: Bearer TOKEN"
```

**Password:** See `/root/wazuh-credentials.txt`

---

## Compliance Tags in Alerts

Every alert automatically includes:
- **NIST 800-53** controls
- **PCI DSS** requirements
- **HIPAA** regulations
- **GDPR** articles
- **MITRE ATT&CK** tactics

Example:
```
Rule: 5402
NIST: AU.14, AC.7, AC.6
PCI DSS: 10.2.5, 10.2.2
MITRE: T1548.003 (Privilege Escalation)
```

---

## Need More Help?

**Full Documentation:** `~/Documents/Claude/Wazuh_Operations_Guide.md`
**Installation Details:** `~/Documents/Claude/Wazuh_Installation_Summary.md`
**Official Docs:** https://documentation.wazuh.com

---

## Remember

🛡️ **Wazuh is protecting you 24/7 automatically**
📊 **No dashboard needed - logs work fine**
📧 **Email alerts coming when mail server deployed**
✅ **Just check logs daily/weekly - that's it!**

**You don't need to babysit Wazuh. It's working silently in the background, watching everything.**
