# Graylog Integration Summary

## Overview
Successfully configured rsyslog to forward both Suricata IDS/IPS logs and Wazuh security alerts to Graylog for centralized log management.

## Current Status: ✅ WORKING

### Message Counts (as of configuration)
- **Suricata IDS Logs:** 13,230+ messages received
- **Wazuh Security Alerts:** 69,294+ messages received

## Configuration Details

### Graylog Inputs Created

1. **Suricata IDS Logs**
   - Input Type: GELF UDP
   - Port: 12201
   - Bind Address: 0.0.0.0
   - Input ID: `6953205c16f04317796569c6`

2. **Wazuh Security Alerts**
   - Input Type: GELF UDP
   - Port: 12202
   - Bind Address: 0.0.0.0
   - Input ID: `6953205c16f04317796569cc`

### Rsyslog Configuration Files

1. **`/etc/rsyslog.d/00-global.conf`**
   - Sets max message size to 64KB to handle large JSON log entries
   - Required for Wazuh alerts which can exceed 11KB

2. **`/etc/rsyslog.d/30-suricata-graylog.conf`**
   - Monitors: `/var/log/suricata/eve.json`
   - Tag: `suricata`
   - Forwards to: `127.0.0.1:12201` (UDP)
   - Format: GELF JSON

3. **`/etc/rsyslog.d/31-wazuh-graylog.conf`**
   - Monitors: `/var/ossec/logs/alerts/alerts.json`
   - Tag: `wazuh`
   - Forwards to: `127.0.0.1:12202` (UDP)
   - Format: GELF JSON

### SELinux Configuration
Fixed SELinux context to allow rsyslog to read log files:
```bash
sudo semanage fcontext -a -t var_log_t '/var/log/suricata/eve.json'
sudo semanage fcontext -a -t var_log_t '/var/ossec/logs/alerts/alerts.json'
sudo restorecon -v /var/log/suricata/eve.json /var/ossec/logs/alerts/alerts.json
```

## Searching Logs in Graylog

### Search by Input Source

**Suricata logs:**
```
gl2_source_input:6953205c16f04317796569c6
```

**Wazuh logs:**
```
gl2_source_input:6953205c16f04317796569cc
```

### Search by Content

**Suricata event types:**
```
gl2_source_input:6953205c16f04317796569c6 AND event_type
```

**Wazuh security alerts:**
```
gl2_source_input:6953205c16f04317796569cc AND rule
```

**Example searches:**
- `gl2_source_input:6953205c16f04317796569c6 AND tls` - TLS events from Suricata
- `gl2_source_input:6953205c16f04317796569c6 AND alert` - IDS alerts from Suricata
- `gl2_source_input:6953205c16f04317796569cc AND level:7` - Critical Wazuh alerts

## Data Format

### Suricata Events
JSON events are stored in the `message` field. Example structure:
```json
{
  "timestamp": "2025-12-29T17:59:32.091889-0700",
  "event_type": "tls",
  "src_ip": "192.168.1.10",
  "dest_ip": "160.79.104.10",
  "src_port": 57768,
  "dest_port": 443,
  "proto": "TCP",
  "tls": {
    "sni": "example.com",
    "version": "TLS 1.3"
  }
}
```

### Wazuh Events
JSON alerts are stored in the `message` field. Example structure:
```json
{
  "timestamp": "2025-12-29T17:59:33.867-0700",
  "rule": {
    "description": "Auditd: SELinux permission check.",
    "level": 3,
    "id": "80730"
  },
  "agent": {
    "name": "dc1.cyberinabox.net"
  }
}
```

## Accessing Graylog

- **Web Interface:** http://127.0.0.1:9000 (or https://graylog.cyberinabox.net if configured)
- **Default Credentials:** admin / admin (change if default)
- **API Endpoint:** http://127.0.0.1:9000/api

## Verification Commands

### Check rsyslog is reading log files:
```bash
sudo lsof -p $(pgrep rsyslogd) | grep -E "eve\.json|alerts\.json"
```

### Check UDP traffic to Graylog:
```bash
sudo tcpdump -i lo -n udp port 12201 or udp port 12202 -c 10
```

### Check rsyslog logs:
```bash
sudo journalctl -u rsyslog -n 50 --no-pager
```

### Search Graylog via API:
```bash
# Suricata logs
curl -s -u "admin:admin" "http://127.0.0.1:9000/api/search/universal/relative?query=gl2_source_input:6953205c16f04317796569c6&range=300&limit=10" | jq .

# Wazuh logs
curl -s -u "admin:admin" "http://127.0.0.1:9000/api/search/universal/relative?query=gl2_source_input:6953205c16f04317796569cc&range=300&limit=10" | jq .
```

## Troubleshooting

### No logs appearing in Graylog

1. **Check rsyslog is running:**
   ```bash
   sudo systemctl status rsyslog
   ```

2. **Check for errors:**
   ```bash
   sudo journalctl -u rsyslog -n 100 | grep -i error
   ```

3. **Verify log files exist and are being written:**
   ```bash
   ls -lh /var/log/suricata/eve.json /var/ossec/logs/alerts/alerts.json
   tail -f /var/log/suricata/eve.json
   ```

4. **Check Graylog inputs are running:**
   ```bash
   curl -s -u "admin:admin" "http://127.0.0.1:9000/api/system/inputs" | jq '.inputs[] | {title, type, state: .state}'
   ```

### Message size errors

If you see "message too long" errors in rsyslog logs:
```bash
# Increase max message size in /etc/rsyslog.d/00-global.conf
$MaxMessageSize 128k

# Restart rsyslog
sudo systemctl restart rsyslog
```

## Future Enhancements

### Option 1: Create Graylog Extractors
Configure extractors to parse JSON fields and create indexed fields for better searching:
- Extract `event_type`, `src_ip`, `dest_ip` from Suricata logs
- Extract `rule.level`, `rule.description`, `agent.name` from Wazuh logs

### Option 2: Use Graylog Content Packs
Create and import content packs with:
- Pre-configured extractors
- Custom dashboards for Suricata and Wazuh
- Saved searches and alert conditions

### Option 3: Configure Graylog Streams
Create streams to automatically route:
- High-severity Wazuh alerts (level >= 7)
- Suricata IDS alerts
- TLS/DNS events for analysis

## Files Created

Configuration files:
- `/etc/rsyslog.d/00-global.conf` - Global rsyslog settings
- `/etc/rsyslog.d/30-suricata-graylog.conf` - Suricata log forwarding
- `/etc/rsyslog.d/31-wazuh-graylog.conf` - Wazuh log forwarding

Backup files (can be deleted):
- `/tmp/30-suricata-graylog.conf`
- `/tmp/31-wazuh-graylog.conf`
- `/tmp/create-graylog-inputs.sh`

Documentation:
- `/home/dshannon/GRAYLOG_INTEGRATION_SUMMARY.md` (this file)

## Integration Complete

Both Suricata and Wazuh logs are now being forwarded to Graylog in real-time. You can view, search, and analyze all security events through the Graylog web interface.
