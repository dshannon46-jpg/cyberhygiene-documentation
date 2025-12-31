# Suricata IDS/IPS Configuration Guide for pfSense
**Created:** December 11, 2025
**Device:** Netgate 2100 (192.168.1.1)
**Purpose:** Configure Suricata for NIST 800-171 Compliance (SI-4: System Monitoring)

## Overview

This guide configures Suricata on pfSense to provide network intrusion detection/prevention for the cyberinabox.net domain.

**NIST 800-171 Requirement:**
> **SI-4:** Monitor the information system to detect attacks and indicators of potential attacks.

---

## Step 1: Access pfSense Web Interface

### Login to pfSense
```
URL: https://192.168.1.1
Username: admin
Password: [Your pfSense admin password]
```

**Security Note:** If this is default credentials, change immediately!

---

## Step 2: Install Suricata Package

### Navigate to Package Manager
1. Click **System** → **Package Manager**
2. Click **Available Packages** tab
3. Search for: `Suricata`
4. Click **Install** button
5. Confirm installation
6. Wait for installation to complete (2-5 minutes)

### Verify Installation
1. Navigate to **Services** → **Suricata**
2. If menu item exists, installation successful

---

## Step 3: Initial Suricata Configuration

### Global Settings

Navigate to: **Services** → **Suricata** → **Global Settings**

#### Recommended Settings:

| Setting | Value | Reason |
|---------|-------|--------|
| **Enable Suricata** | ✅ Checked | Activate the service |
| **Enable Logging** | ✅ Checked | Required for auditing |
| **Enable Packet Logging** | ❌ Unchecked | Consumes disk space (enable only for forensics) |
| **Log to System Log** | ✅ Checked | Centralized logging |
| **Remove Blocked Hosts Interval** | 3600 | 1 hour (adjust as needed) |
| **Auto Update Rules** | ✅ Checked | Keep rules current |
| **Update Interval** | 12 hours | Balance between current rules and performance |

Click **Save**

---

## Step 4: Configure Rule Sets

### Add Rule Sources

Navigate to: **Services** → **Suricata** → **Global Settings** → **Rule Updates** tab

#### Recommended Rule Sets (Free):

1. **Emerging Threats Open (ET Open)** ⭐ Recommended
   - Type: Free
   - Coverage: Excellent general threat detection
   - Configuration:
     - ✅ Enable ET Open Ruleset
     - URL: Automatically configured

2. **Abuse.ch Rules** (Optional but recommended)
   - Type: Free
   - Coverage: Malware, botnet C2, ransomware
   - Configuration:
     - ✅ Enable Abuse.ch
     - ✅ Feodo Tracker
     - ✅ SSL Blacklist
     - ✅ URLhaus

3. **Snort VRT (Free Registered)** (Optional)
   - Type: Free (requires registration)
   - Coverage: Comprehensive commercial-grade rules (30-day delay)
   - Configuration:
     - Register at: https://www.snort.org/users/sign_up
     - Enter Oinkcode in pfSense
     - ✅ Enable Snort VRT Free Ruleset

### Rule Update Settings

| Setting | Value |
|---------|-------|
| **Update Interval** | 12 hours |
| **Update Start Time** | 00:00 (midnight) |
| **Hide Deprecated Rules** | ✅ Checked |

Click **Save** → Click **Update** to download rules now

**Note:** Initial rule download may take 5-15 minutes.

---

## Step 5: Configure Interface(s)

### Add WAN Interface (Primary)

Navigate to: **Services** → **Suricata** → **Interfaces** → Click **Add**

#### Interface Configuration:

**General Settings:**
- **Enable**: ✅ Checked
- **Interface**: WAN
- **Description**: "WAN - Internet Traffic Monitoring"
- **Alert Settings**: Block offenders

**Detection Settings:**
- **IPS Mode**: ✅ Enabled (if you want blocking)
  - ⚠️ **Caution**: Start with IDS-only (unchecked), enable IPS after testing
- **Promiscuous Mode**: ✅ Enabled
- **Block Offenders**: ✅ Checked (after testing period)
- **Kill States**: ✅ Checked

**Performance Settings:**
```
Max Pending Packets: 1024
Detect Engine Profile: Medium
App Layer Protocol: All
```

**Networks:**
- **Home Net**: `192.168.1.0/24` (your LAN)
- **External Net**: `!$HOME_NET` (everything else)

Click **Save**

### Optional: Add LAN Interface

If you want to monitor internal traffic (e.g., detect lateral movement):

1. Click **Add** again
2. **Interface**: LAN
3. **Description**: "LAN - Internal Traffic Monitoring"
4. **IPS Mode**: ❌ Disabled (IDS-only for internal)
5. Same settings as above

**Note:** Monitoring LAN can detect:
- Compromised workstations
- Data exfiltration attempts
- Lateral movement
- But adds processing overhead

---

## Step 6: Configure Rule Categories

### Enable Appropriate Rules

Navigate to: **Services** → **Suricata** → **WAN** (interface) → **WAN Categories** tab

#### Recommended Rule Categories for Small Business:

**Essential (Enable These):**
- ✅ **emerging-attack_response** - Confirmed attacks
- ✅ **emerging-malware** - Malware detection
- ✅ **emerging-exploit** - Exploit attempts
- ✅ **emerging-phishing** - Phishing attempts
- ✅ **emerging-scan** - Port scanning
- ✅ **emerging-trojan** - Trojan detection
- ✅ **emerging-botnet** - Botnet C2 traffic

**Important:**
- ✅ **emerging-web_server** - Web server attacks (if hosting websites)
- ✅ **emerging-sql** - SQL injection
- ✅ **emerging-rpc** - RPC exploits
- ✅ **emerging-dos** - Denial of Service

**Optional (May cause false positives):**
- ⚠️ **emerging-policy** - Policy violations (test carefully)
- ⚠️ **emerging-p2p** - Peer-to-peer traffic
- ⚠️ **emerging-worm** - Worm activity

**Disable (Too noisy for small networks):**
- ❌ emerging-icmp_info
- ❌ emerging-dns
- ❌ emerging-misc (unless needed)

Click **Save** after selecting categories

---

## Step 7: Configure Suppression Lists (Reduce False Positives)

### Create Suppression List

Navigate to: **Services** → **Suricata** → **Suppress**

Click **Add** to create suppression entries for known false positives.

**Common False Positives to Suppress:**

```
# Suppress DNS response over UDP (chatty)
suppress gen_id 1, sig_id 2100498

# Suppress SSH brute force for known admin IPs
suppress gen_id 1, sig_id 2001219, track by_src, ip 192.168.1.0/24

# Suppress FreeIPA Kerberos traffic
suppress gen_id 1, sig_id 2014297, track by_src, ip 192.168.1.10
suppress gen_id 1, sig_id 2014297, track by_dst, ip 192.168.1.10
```

**Add suppressions as needed after reviewing alerts.**

---

## Step 8: Configure Alerting and Logging

### Alert Settings

Navigate to: **Services** → **Suricata** → **WAN** → **Alert Settings** tab

**Recommended Configuration:**

| Setting | Value | Purpose |
|---------|-------|---------|
| **Log to System Log** | ✅ Checked | Centralized logging |
| **Send Alerts to System Log** | ✅ Checked | Alert visibility |
| **Block Offenders** | ⚠️ Test first | Start unchecked, enable after tuning |
| **Kill States on Drop** | ✅ Checked | Terminate malicious connections |
| **Which IP to Block** | SRC | Block attacking source IP |

### Email Alerting (Optional but Recommended)

Navigate to: **Services** → **Suricata** → **Global Settings** → **Alert Settings**

Configure email notifications for critical alerts:

```
Enable Email: ✅ Checked
Email Address: security@cyberinabox.net
Subject: [pfSense] Suricata Alert
Minimum Priority: 1 (High priority only)
```

---

## Step 9: Performance Tuning for Netgate 2100

### Hardware Specifications
- CPU: Dual-core ARM Cortex-A53
- RAM: 4GB
- Storage: 8GB eMMC

### Recommended Performance Settings

Navigate to: **Services** → **Suricata** → **WAN** → **Variables** tab

**Detection Engine Profile:** Medium
- Low: Faster but less thorough
- Medium: ⭐ Recommended balance
- High: Thorough but slower

**Stream Settings:**
```
Memcap: 64MB (increase if you have spare RAM)
Prealloc Sessions: 8192
```

**HTTP Settings:**
```
Memcap: 128MB
```

**Reassembly Settings:**
```
Memcap: 128MB
Depth: 0 (unlimited)
```

### Monitor Performance

Navigate to: **Diagnostics** → **System Activity**

**Watch for:**
- CPU usage >80% sustained = reduce rules or upgrade hardware
- Dropped packets = increase buffer sizes or reduce rules
- High memory usage = reduce memcap values

---

## Step 10: Start Suricata

### Enable and Start Service

1. Navigate to: **Services** → **Suricata** → **Interfaces**
2. Find WAN interface
3. Click **Start** icon (▶️)
4. Wait 30-60 seconds for initialization
5. Status should show: 🟢 **Running**

### Verify Operation

**Check Service Status:**
```
Services → Suricata → Interfaces
Status should be: Running (green icon)
```

**Check Logs:**
```
Status → System Logs → System
Look for: "Suricata started successfully"
```

---

## Step 11: Monitor and Tune

### View Alerts

Navigate to: **Services** → **Suricata** → **Alerts**

**Alert Tabs:**
- **Alerts**: All triggered alerts
- **Blocked**: Blocked connections (if IPS mode enabled)
- **Files**: Extracted files (if configured)

### Daily Monitoring Routine

**Daily (5 minutes):**
1. Check **Alerts** tab for critical events
2. Review top 10 alerts
3. Investigate unknown source IPs

**Weekly (15 minutes):**
1. Review alert trends
2. Add false positives to suppression list
3. Update rules manually if needed
4. Check performance metrics

**Monthly (30 minutes):**
1. Review blocked IPs
2. Update rule categories
3. Test IPS blocking
4. Export logs for compliance records

---

## Step 12: Enable IPS Mode (After Testing Period)

### Transition from IDS to IPS

**After 2-4 weeks of monitoring and tuning:**

1. Navigate to: **Services** → **Suricata** → **WAN**
2. Scroll to **Detection Performance Settings**
3. ✅ Enable **IPS Mode**
4. ✅ Enable **Block Offenders**
5. Click **Save**
6. Click **Restart** icon for WAN interface

**⚠️ WARNING:** Enabling IPS can block legitimate traffic if not properly tuned!

### Test IPS Blocking

**Test with safe exploit:**
```bash
# From external network, test with curl
curl "http://192.168.1.1/cgi-bin/../../../../etc/passwd"
```

This should trigger an alert and block (if IPS enabled).

---

## NIST 800-171 Compliance Configuration

### Required Settings for Compliance

**SI-4: System Monitoring**

✅ **Continuous Monitoring:**
- Suricata running 24/7
- Auto-update rules enabled
- Logging to system logs

✅ **Alert Generation:**
- Email alerts configured
- Critical alerts flagged
- All alerts logged

✅ **Response Actions:**
- Block offenders enabled (IPS mode)
- Kill malicious connections
- Log all actions

✅ **Log Retention:**
- Minimum 30 days (configure below)

### Configure Log Retention

Navigate to: **Status** → **System Logs** → **Settings**

**Settings:**
- **Log Size (Bytes)**: 524288 (512KB minimum)
- **Log Rotation**: ✅ Enabled
- **Days to Keep**: 30 (minimum for NIST 800-171)

### Compliance Checklist

- [ ] Suricata installed and running
- [ ] WAN interface monitored
- [ ] ET Open rules enabled and updating
- [ ] Email alerts configured
- [ ] Logs retained 30+ days
- [ ] Weekly log review documented
- [ ] IPS mode enabled (after tuning)
- [ ] False positives suppressed
- [ ] Performance acceptable (<80% CPU)

---

## Centralized Logging to FreeIPA Server (Optional)

### Send Suricata Logs to dc1.cyberinabox.net

**On pfSense:**

Navigate to: **Status** → **System Logs** → **Settings** → **Remote Logging**

**Configuration:**
```
Enable Remote Logging: ✅ Checked
Remote Log Servers: 192.168.1.10:514
Remote Syslog Contents: Everything
```

**On dc1.cyberinabox.net (if you want to receive logs):**

```bash
# Install rsyslog if not present
sudo dnf install rsyslog

# Configure to receive remote logs
sudo vi /etc/rsyslog.conf

# Uncomment these lines:
module(load="imudp")
input(type="imudp" port="514")

# Add custom rule for pfSense
echo '$template RemoteHost,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"' | sudo tee -a /etc/rsyslog.conf
echo '*.* ?RemoteHost' | sudo tee -a /etc/rsyslog.conf

# Restart rsyslog
sudo systemctl restart rsyslog

# Open firewall
sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --reload
```

**Verify:**
```bash
# Check logs arriving
sudo tail -f /var/log/remote/pfSense/suricata.log
```

---

## Troubleshooting

### Suricata Won't Start

**Check:**
1. System → Package Manager → Installed Packages
   - Verify Suricata is installed
2. Services → Suricata → Interfaces
   - Check for error messages
3. Status → System Logs → System
   - Look for Suricata errors

**Common Issues:**
- Insufficient memory → Reduce memcap values
- Interface conflicts → Ensure interface is UP
- Rule download failed → Check internet connectivity

### High CPU Usage

**Solutions:**
1. Reduce rule categories (disable noisy categories)
2. Change Detection Engine Profile to "Low"
3. Reduce memcap values
4. Disable packet logging
5. Monitor only WAN (not LAN)

### Too Many False Positives

**Solutions:**
1. Add suppressions for known-good traffic
2. Disable noisy rule categories (emerging-policy, emerging-dns)
3. Tune HOME_NET variable
4. Whitelist internal IPs
5. Review and disable specific SID numbers

### No Alerts Appearing

**Check:**
1. Rules downloaded? (Global Settings → Update Rules)
2. Categories enabled? (Interface → Categories tab)
3. Interface started? (Green icon in Interfaces list)
4. Traffic passing through? (Firewall → LAN/WAN rules)

---

## Maintenance Schedule

### Daily (Automated)
- ✅ Rule updates (auto at midnight)
- ✅ Alert generation
- ✅ Blocking (if IPS enabled)

### Daily (Manual - 5 min)
- Review critical alerts
- Check for blocked legitimate IPs
- Verify service is running

### Weekly (15 min)
- Review alert trends
- Update suppression list
- Verify performance metrics
- Document notable events

### Monthly (30 min)
- Export logs for compliance
- Review and update rule categories
- Test IPS blocking effectiveness
- Update pfSense and Suricata packages

### Quarterly (1 hour)
- Full rule review
- Performance optimization
- Compliance audit preparation
- Disaster recovery test

---

## Backup Configuration

### Export Suricata Configuration

1. Navigate to: **Diagnostics** → **Backup & Restore**
2. **Backup Configuration** tab
3. ✅ Select **Suricata** package
4. Click **Download Configuration**
5. Save to: `/home/dshannon/Documents/Claude/Backups/pfSense-suricata-config-YYYY-MM-DD.xml`

**Backup Schedule:** Monthly

---

## Security Best Practices

### Rule Management
- ✅ Auto-update enabled
- ✅ Review new rules monthly
- ✅ Disable unnecessary categories
- ✅ Test before enabling blocking

### Performance
- ✅ Monitor CPU/memory usage
- ✅ Tune memcap values
- ✅ Use appropriate detection profile
- ✅ Log rotation enabled

### Operational Security
- ✅ Weekly alert review
- ✅ Document all suppressions
- ✅ Maintain change log
- ✅ Test restoration procedures

### Compliance
- ✅ 30-day log retention minimum
- ✅ Email alerts for critical events
- ✅ Monthly compliance reports
- ✅ Quarterly audits

---

## Quick Reference Commands

### Check Suricata Status
```
Services → Suricata → Interfaces
Look for green "Running" status
```

### View Recent Alerts
```
Services → Suricata → Alerts
Filter by last 24 hours
```

### Update Rules Manually
```
Services → Suricata → Global Settings → Update Rules
Click "Update" button
```

### Restart Suricata
```
Services → Suricata → Interfaces
Click restart icon (🔄) next to interface
```

### Clear All Blocked IPs
```
Services → Suricata → Blocked
Click "Clear All" button
```

---

## Additional Resources

### Documentation
- pfSense Suricata Package: https://docs.netgate.com/pfsense/en/latest/packages/suricata/index.html
- Suricata User Guide: https://suricata.readthedocs.io/
- ET Open Rules: https://rules.emergingthreats.net/

### Rule Sources
- Emerging Threats: https://rules.emergingthreats.net/
- Abuse.ch: https://abuse.ch/
- Snort VRT: https://www.snort.org/downloads

### Community Support
- pfSense Forum: https://forum.netgate.com/
- Suricata Forum: https://forum.suricata.io/
- r/pfSense: https://reddit.com/r/PFSENSE

---

**Document Version:** 1.0
**Last Updated:** December 11, 2025
**Next Review:** Monthly during maintenance
**Compliance:** NIST 800-171 Rev 2 (SI-4)
