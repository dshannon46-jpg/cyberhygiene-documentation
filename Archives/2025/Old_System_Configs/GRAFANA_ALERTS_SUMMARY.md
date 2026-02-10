# Grafana Alerts for Suricata IDS/IPS - Configuration Summary

**Date Configured:** December 29, 2025
**Alert Recipient:** dshannon@cyberinabox.net
**Status:** ✅ Active and Monitoring

---

## Alert Rules Configured (5 Total)

### 1. High IDS Alert Rate
- **Rule ID:** suricata-high-alert-rate
- **Severity:** Warning
- **Condition:** More than 1 IDS alert per second (5-minute rate)
- **Evaluation:** Every 1 minute
- **Alert Duration:** Triggers after 2 minutes of sustained high rate
- **Description:** Indicates possible active attack or scanning activity

### 2. Sudden Spike in IDS Alerts
- **Rule ID:** suricata-alert-spike  
- **Severity:** Critical
- **Condition:** More than 50 new alerts in 5 minutes
- **Evaluation:** Every 1 minute
- **Alert Duration:** Triggers after 1 minute
- **Description:** Possible security incident in progress

### 3. High Rate of Failed Connections
- **Rule ID:** suricata-failed-connections
- **Severity:** Warning
- **Condition:** More than 10 failed TCP/UDP connections per second (5-minute rate)
- **Evaluation:** Every 1 minute
- **Alert Duration:** Triggers after 3 minutes
- **Description:** May indicate port scanning or connection issues

### 4. No Network Traffic Detected
- **Rule ID:** suricata-no-traffic
- **Severity:** Critical
- **Condition:** Packet processing rate less than 0.1 packets/second
- **Evaluation:** Every 1 minute
- **Alert Duration:** Triggers after 5 minutes
- **Description:** Suricata may not be monitoring traffic properly
- **Special:** Also alerts on No Data or Error states

### 5. High TLS Handshake Failure Rate
- **Rule ID:** suricata-tls-failures
- **Severity:** Warning
- **Condition:** More than 5 failed TCP connections per second (5-minute rate)
- **Evaluation:** Every 1 minute
- **Alert Duration:** Triggers after 3 minutes
- **Description:** May indicate SSL/TLS inspection issues or malicious activity

---

## Email Notification Configuration

**SMTP Settings:**
- **Server:** localhost:25 (Postfix)
- **From Address:** grafana@cyberinabox.net
- **From Name:** Grafana Alerts
- **To Address:** dshannon@cyberinabox.net

**Notification Policy:**
- **Critical Alerts:** Repeat every 4 hours if not resolved
- **Warning Alerts:** Repeat every 12 hours if not resolved
- **Group Wait:** 10-30 seconds (alerts are grouped before sending)
- **Group Interval:** 5 minutes (wait time for additional alerts)

---

## How to Access Alerts

### Via Grafana Web UI:
1. Go to https://grafana.cyberinabox.net/
2. Navigate to **Alerting** → **Alert rules**
3. View folder: **Security Monitoring**

### Via Email:
- Alerts are automatically sent to dshannon@cyberinabox.net
- Email subject includes alert name and severity
- Email body includes alert details and metric values

---

## Configuration Files

- **Alert Rules:** `/etc/grafana/provisioning/alerting/alerting-rules.yaml`
- **Contact Points:** `/etc/grafana/provisioning/alerting/alerting-contactpoints.yaml`
- **Notification Policies:** `/etc/grafana/provisioning/alerting/alerting-policies.yaml`
- **SMTP Configuration:** `/etc/grafana/grafana.ini` (lines 1090-1104)

---

## Testing Alerts

To test if alerts are working:

1. **View Current Alert State:**
   - Go to Grafana → Alerting → Alert rules
   - Check the current state of each rule (Normal, Pending, Alerting, Error)

2. **Trigger a Test Alert:**
   - Generate network activity: `curl http://testmynids.org/uid/index.html`
   - This should trigger IDS alerts and potentially the "High IDS Alert Rate" rule

3. **Check Email Delivery:**
   - Wait for the alert condition to be met
   - Check dshannon@cyberinabox.net for alert emails
   - Check mail logs: `sudo tail -f /var/log/maillog | grep grafana`

---

## Monitoring Alert Status

**Check Grafana Logs:**
```bash
sudo tail -f /var/log/grafana/grafana.log | grep -i "alert\|evaluat"
```

**Check Alert Scheduler Status:**
```bash
sudo systemctl status grafana-server | grep -i alert
```

**View Email Queue:**
```bash
sudo mailq
```

---

## Troubleshooting

**If alerts aren't triggering:**
1. Verify Prometheus is collecting Suricata metrics
2. Check Grafana can query Prometheus data source
3. Review alert rule thresholds (may need adjustment)

**If emails aren't sending:**
1. Check SMTP is enabled in grafana.ini: `enabled = true`
2. Verify Postfix is running: `systemctl status postfix`
3. Check mail logs: `tail -f /var/log/maillog`
4. Test email manually from Grafana → Alerting → Contact points → Test

**If alerts are in Error state:**
1. Check data source UID is correct (df8llkvhg7m68a)
2. Verify Prometheus is accessible at http://127.0.0.1:9091
3. Review Grafana logs for specific errors

---

## Alert Thresholds

Current thresholds may need tuning based on your network's normal behavior:

- **Alert Rate:** 1 alert/sec (may be too sensitive for busy networks)
- **Alert Spike:** 50 alerts in 5min (good for detecting sudden attacks)
- **Failed Connections:** 10/sec (adjust based on baseline)
- **Traffic Detection:** 0.1 packets/sec (very low threshold, good for detection)
- **TLS Failures:** 5/sec (may need adjustment based on SSL/TLS usage)

To modify thresholds, edit `/etc/grafana/provisioning/alerting/alerting-rules.yaml` and restart Grafana.

---

## Integration with Wazuh

Note: Suricata alerts are also being processed by Wazuh SIEM with its own email alerting:
- Wazuh email threshold: Level 7+
- Wazuh critical alerts: Level 12 (always emailed)
- You may receive emails from both Grafana and Wazuh for the same security events

**Grafana vs Wazuh Alerts:**
- **Grafana:** Focuses on metric thresholds and rates (good for trends)
- **Wazuh:** Focuses on individual IDS alerts and correlation (good for specific threats)
- Both systems complement each other for comprehensive monitoring

