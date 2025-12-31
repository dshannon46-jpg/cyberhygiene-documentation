# Wazuh VirusTotal Integration Guide

**Date:** October 29, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Purpose:** Configure Wazuh malware detection with VirusTotal API integration
**Author:** Claude Code for Donald E. Shannon

---

## Overview

This guide configures Wazuh to automatically submit suspicious files to VirusTotal for analysis using 70+ antivirus engines. This provides interim malware detection while awaiting ClamAV 1.5.x FIPS support.

**Benefits:**
- Multi-engine detection (70+ AV engines)
- Zero software installation (uses existing Wazuh)
- FIPS-compatible (API calls over TLS)
- Automatic suspicious file submission
- Centralized alerting

**Limitations:**
- Requires internet access
- API rate limits (free: 500 requests/day)
- Reactive detection (file must exist first)
- File metadata shared with VirusTotal

---

## Prerequisites

- Wazuh Manager installed and running
- Wazuh File Integrity Monitoring (FIM) configured
- Internet access for VirusTotal API
- VirusTotal API key (free or paid)

---

## Step 1: Obtain VirusTotal API Key

### Option A: Free API Key (Recommended for Testing)

1. **Create VirusTotal Account:**
   - Visit: https://www.virustotal.com/gui/join-us
   - Sign up with email address
   - Verify email

2. **Get API Key:**
   - Login to VirusTotal
   - Navigate to: https://www.virustotal.com/gui/my-apikey
   - Copy your API key (64-character hex string)

**Free Tier Limits:**
- 500 requests per day
- 4 requests per minute
- Suitable for small environments (<15 users)

### Option B: Commercial API (For Production)

**Premium Tier (~$180/year):**
- 15,000 requests per day
- Higher rate limits
- Extended file retention
- Priority support

**Enterprise Tier (Custom pricing):**
- Unlimited requests
- Private scanning
- Advanced threat intelligence
- SLA guarantees

---

## Step 2: Configure Wazuh Integration

### Edit Wazuh Configuration

```bash
sudo vi /var/ossec/etc/ossec.conf
```

### Add VirusTotal Integration Section

Add the following **inside the `<ossec_config>` tag**, before the closing `</ossec_config>`:

```xml
<!-- VirusTotal Integration for Malware Detection -->
<integration>
  <name>virustotal</name>
  <api_key>YOUR_VIRUSTOTAL_API_KEY_HERE</api_key>
  <group>syscheck</group>
  <alert_format>json</alert_format>
</integration>
```

**Replace `YOUR_VIRUSTOTAL_API_KEY_HERE` with your actual API key.**

### Configuration Breakdown

- `<name>virustotal</name>`: Enables VirusTotal integration
- `<api_key>`: Your VirusTotal API key (keep secure!)
- `<group>syscheck</group>`: Triggers on File Integrity Monitoring events
- `<alert_format>json</alert_format>`: JSON output for parsing

---

## Step 3: Configure File Integrity Monitoring

### Review Existing FIM Configuration

Your October 28th report shows FIM already configured. Verify critical paths are monitored:

```bash
sudo grep -A 10 "<syscheck>" /var/ossec/etc/ossec.conf
```

### Enhance FIM for Malware Detection

Add or verify these directories are monitored:

```xml
<syscheck>
  <frequency>43200</frequency> <!-- Every 12 hours -->
  <scan_on_start>yes</scan_on_start>
  <alert_new_files>yes</alert_new_files>

  <!-- Critical system paths (already monitored per your report) -->
  <directories check_all="yes" realtime="yes" report_changes="yes">/etc</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes">/usr/bin</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes">/usr/sbin</directories>

  <!-- Common malware locations (ADD THESE for VirusTotal integration) -->
  <directories check_all="yes" realtime="yes" report_changes="yes">/tmp</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes">/var/tmp</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes">/dev/shm</directories>

  <!-- User directories -->
  <directories check_all="yes" realtime="yes" report_changes="yes">/home</directories>

  <!-- Samba file shares (CUI/FCI data) -->
  <directories check_all="yes" realtime="yes" report_changes="yes">/srv/samba</directories>

  <!-- Web server uploads (if applicable) -->
  <!-- <directories check_all="yes" realtime="yes" report_changes="yes">/var/www/html/uploads</directories> -->

  <!-- Ignore common false positives -->
  <ignore type="sregex">.log$|.swp$</ignore>
  <ignore>/etc/mtab</ignore>
  <ignore>/etc/hosts.deny</ignore>
  <ignore>/etc/mail/statistics</ignore>
  <ignore>/etc/random-seed</ignore>
  <ignore>/etc/random.seed</ignore>
  <ignore>/etc/adjtime</ignore>
  <ignore>/etc/httpd/logs</ignore>
  <ignore>/etc/utmp</ignore>
  <ignore>/etc/wtmp</ignore>
  <ignore>/etc/cups/certs</ignore>
  <ignore>/etc/dumpdates</ignore>
  <ignore>/etc/svc/volatile</ignore>

  <!-- Ignore Wazuh's own files -->
  <ignore>/var/ossec</ignore>
</syscheck>
```

---

## Step 4: Configure VirusTotal Rules

### Create Custom Rules for Malware Alerts

```bash
sudo vi /var/ossec/etc/rules/local_rules.xml
```

Add these rules:

```xml
<!-- VirusTotal Malware Detection Rules -->
<group name="virustotal,malware,">

  <!-- VirusTotal Positive Detection -->
  <rule id="100100" level="12">
    <if_sid>657</if_sid>
    <match>Successfully retrieved information from VirusTotal</match>
    <description>VirusTotal: File analyzed</description>
  </rule>

  <rule id="100101" level="15">
    <if_sid>100100</if_sid>
    <match>"positives": [1-9]</match>
    <description>VirusTotal: File flagged as malicious by $(virustotal.positives) engines</description>
    <options>no_email_alert</options>
    <group>malware,pci_dss_11.4,gdpr_IV_35.7.d,nist_800_53_SI.3,</group>
  </rule>

  <!-- High Confidence Malware (5+ engines) -->
  <rule id="100102" level="15">
    <if_sid>100100</if_sid>
    <regex>"positives": [5-9]|\d{2,}</regex>
    <description>VirusTotal: HIGH CONFIDENCE malware detected by $(virustotal.positives) engines</description>
    <group>malware,pci_dss_11.4,gdpr_IV_35.7.d,nist_800_53_SI.3,</group>
  </rule>

  <!-- Critical Malware (10+ engines) -->
  <rule id="100103" level="15">
    <if_sid>100100</if_sid>
    <regex>"positives": \d{2,}</regex>
    <description>VirusTotal: CRITICAL malware detected by $(virustotal.positives) engines - IMMEDIATE ACTION REQUIRED</description>
    <options>alert_by_email</options>
    <group>malware,pci_dss_11.4,gdpr_IV_35.7.d,nist_800_53_SI.3,</group>
  </rule>

  <!-- VirusTotal API Error -->
  <rule id="100104" level="5">
    <if_sid>657</if_sid>
    <match>Unable to query VirusTotal</match>
    <description>VirusTotal: API query failed</description>
  </rule>

  <!-- VirusTotal Rate Limit Exceeded -->
  <rule id="100105" level="7">
    <if_sid>100104</if_sid>
    <match>Rate limit exceeded</match>
    <description>VirusTotal: API rate limit exceeded - consider upgrading plan</description>
  </rule>

</group>
```

**Rule Severity Levels:**
- **Level 12:** File analyzed (informational)
- **Level 15:** Malware detected (high severity, generates alert)
- **Level 15 + email:** Critical malware (10+ engines)

---

## Step 5: Restart Wazuh Manager

```bash
# Validate configuration first
sudo /var/ossec/bin/wazuh-control check

# If validation passes, restart
sudo systemctl restart wazuh-manager

# Verify service started successfully
sudo systemctl status wazuh-manager

# Check logs for errors
sudo tail -f /var/ossec/logs/ossec.log
```

---

## Step 6: Testing

### Test 1: EICAR Test File

```bash
# Download EICAR test file to monitored directory
cd /tmp
wget https://secure.eicar.org/eicar.com.txt

# Wazuh FIM should detect new file
# VirusTotal integration should submit automatically
# Check alerts (wait 30-60 seconds for API call)

sudo tail -f /var/ossec/logs/alerts/alerts.log
```

**Expected Alert:**

```json
{
  "timestamp": "2025-10-29T...",
  "rule": {
    "level": 15,
    "id": "100102",
    "description": "VirusTotal: HIGH CONFIDENCE malware detected"
  },
  "data": {
    "virustotal": {
      "found": "1",
      "malicious": "1",
      "source": {
        "file": "/tmp/eicar.com.txt",
        "sha1": "3395856ce81f2b7382dee72602f798b642f14140"
      },
      "positives": "70",
      "total": "72"
    }
  }
}
```

### Test 2: Safe File

```bash
# Create benign file
echo "This is a safe test file" > /tmp/safe_test.txt

# Should trigger FIM event but VirusTotal returns 0 positives
sudo grep "safe_test.txt" /var/ossec/logs/alerts/alerts.log
```

### Test 3: Monitor API Usage

```bash
# Check VirusTotal integration logs
sudo grep -i virustotal /var/ossec/logs/ossec.log

# Monitor API calls
sudo grep "Successfully retrieved information from VirusTotal" \
    /var/ossec/logs/alerts/alerts.log | wc -l
```

---

## Step 7: Active Response (Optional)

### Automatically Quarantine Malicious Files

Add active response to move detected malware to quarantine:

```bash
sudo vi /var/ossec/etc/ossec.conf
```

Add **before** closing `</ossec_config>`:

```xml
<!-- Active Response: Quarantine Malware -->
<command>
  <name>quarantine-malware</name>
  <executable>quarantine.sh</executable>
  <timeout_allowed>no</timeout_allowed>
</command>

<active-response>
  <command>quarantine-malware</command>
  <location>local</location>
  <rules_id>100102,100103</rules_id>
</active-response>
```

### Create Quarantine Script

```bash
sudo vi /var/ossec/active-response/bin/quarantine.sh
```

```bash
#!/bin/bash
# Quarantine malware detected by VirusTotal

QUARANTINE_DIR="/var/ossec/quarantine"
LOG="/var/ossec/logs/active-responses.log"

# Read STDIN (Wazuh passes file path)
read INPUT_JSON
FILENAME=$(echo $INPUT_JSON | jq -r '.parameters.alert.syscheck.path' 2>/dev/null)

if [ -z "$FILENAME" ] || [ ! -f "$FILENAME" ]; then
    echo "$(date) - Invalid file: $FILENAME" >> $LOG
    exit 1
fi

# Create quarantine directory if not exists
mkdir -p "$QUARANTINE_DIR"
chmod 700 "$QUARANTINE_DIR"

# Move file to quarantine
BASENAME=$(basename "$FILENAME")
QUARANTINE_PATH="$QUARANTINE_DIR/${BASENAME}.$(date +%Y%m%d-%H%M%S)"

mv "$FILENAME" "$QUARANTINE_PATH" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "$(date) - Quarantined: $FILENAME -> $QUARANTINE_PATH" >> $LOG
    chmod 000 "$QUARANTINE_PATH"  # Remove all permissions
else
    echo "$(date) - Failed to quarantine: $FILENAME" >> $LOG
fi
```

```bash
# Make executable
sudo chmod 750 /var/ossec/active-response/bin/quarantine.sh
sudo chown root:wazuh /var/ossec/active-response/bin/quarantine.sh

# Restart Wazuh
sudo systemctl restart wazuh-manager
```

---

## Step 8: Monitoring and Maintenance

### Daily Checks

```bash
# Check VirusTotal API usage
sudo grep "virustotal" /var/ossec/logs/ossec.log | tail -20

# Review malware alerts
sudo grep -A 5 "VirusTotal.*malware" /var/ossec/logs/alerts/alerts.log

# Check quarantine directory
ls -lh /var/ossec/quarantine/
```

### Weekly Tasks

1. **Review API Usage:**
   ```bash
   # Count API calls in last 7 days
   sudo grep "Successfully retrieved information from VirusTotal" \
       /var/ossec/logs/alerts/alerts.log | \
       awk -v date="$(date -d '7 days ago' +%Y-%m-%d)" '$0 > date' | wc -l
   ```

2. **Analyze Quarantined Files:**
   ```bash
   # List quarantined files
   ls -lh /var/ossec/quarantine/

   # Review associated alerts
   sudo grep -B 10 "Quarantined:" /var/ossec/logs/active-responses.log
   ```

3. **Check for False Positives:**
   - Review files with 1-2 engine detections
   - Whitelist known safe files if needed

### API Rate Limit Management

**Free Tier (500/day):**
- Average: ~20 requests/hour
- Monitor usage to avoid hitting limits

**If Rate Limit Exceeded:**

```xml
<!-- Reduce FIM frequency -->
<syscheck>
  <frequency>86400</frequency> <!-- Daily instead of 12-hourly -->
  <!-- Or limit monitored directories -->
</syscheck>
```

**Or upgrade to paid tier** ($180/year for 15,000/day)

---

## Integration with NIST 800-171

### SI-3: Malicious Code Protection

**Control Implementation:**

This VirusTotal integration satisfies:
- **SI-3(a):** Detection mechanisms at entry/exit points (FIM monitors file creation)
- **SI-3(b):** Automatic updates (VirusTotal database updated continuously)
- **SI-3(c):** Real-time scanning (via FIM + API)
- **SI-3(d):** Quarantine capability (active response)
- **SI-3(e):** Alerts to administrators (Wazuh alerts)

**Documentation for SSP:**

```markdown
## 2.6 Antivirus and Malware Protection

**Wazuh + VirusTotal Integration**

CUI/FCI systems employ multi-engine malware detection through Wazuh File
Integrity Monitoring integrated with VirusTotal API. All file creations and
modifications on monitored systems trigger automatic submission to VirusTotal
for analysis by 70+ commercial antivirus engines.

**Detection Capabilities:**
- Real-time file monitoring via Wazuh FIM
- Automatic malware analysis (VirusTotal API)
- Multi-engine detection (70+ AV engines)
- Automatic quarantine of detected threats
- Centralized alerting and logging

**Compliance Mappings:**
- NIST 800-171 SI-3: Malicious Code Protection
- PCI DSS 11.4: Intrusion detection/prevention
- GDPR Article 32: Security of processing

**Future Enhancement:**
Transition to ClamAV 1.5.x when FIPS-compatible version available in EPEL
(POA&M-014, target Q1 2026).
```

---

## Troubleshooting

### VirusTotal Integration Not Working

**Check 1: Verify API Key**
```bash
# Test API key manually
curl -X GET "https://www.virustotal.com/api/v3/files/44d88612fea8a8f36de82e1278abb02f" \
  -H "x-apikey: YOUR_API_KEY"

# Should return JSON response, not authentication error
```

**Check 2: Review Wazuh Logs**
```bash
sudo grep -i virustotal /var/ossec/logs/ossec.log
```

**Check 3: Network Connectivity**
```bash
# Test HTTPS to VirusTotal
curl -I https://www.virustotal.com

# Check firewall allows outbound HTTPS
sudo firewall-cmd --list-all | grep https
```

### High False Positive Rate

**Reduce sensitivity by requiring multiple engines:**

```xml
<rule id="100101" level="15">
  <if_sid>100100</if_sid>
  <regex>"positives": [3-9]|\d{2,}</regex> <!-- Changed from [1-9] to [3-9] -->
  <description>VirusTotal: File flagged by 3+ engines</description>
</rule>
```

### Rate Limit Issues

**Solution 1: Reduce FIM frequency**
```xml
<frequency>86400</frequency> <!-- Once daily -->
```

**Solution 2: Monitor only critical paths**
```xml
<!-- Remove /tmp, /var/tmp monitoring on high-activity systems -->
```

**Solution 3: Upgrade to paid tier**
- Premium: $180/year (15,000 requests/day)

---

## Security Considerations

### API Key Protection

```bash
# Restrict ossec.conf permissions
sudo chmod 640 /var/ossec/etc/ossec.conf
sudo chown root:wazuh /var/ossec/etc/ossec.conf
```

### Data Privacy

**VirusTotal Submission Includes:**
- File hash (SHA256, SHA1, MD5)
- File size
- File metadata
- **File content** (uploaded to VirusTotal servers)

**IMPORTANT:** Files are submitted to VirusTotal servers and become part of their public database.

**For CUI/FCI environments:**
- Only monitor directories containing system files, not sensitive data
- Exclude `/srv/samba` (CUI data) from VirusTotal submission
- Use hash-only checking (not full file upload) if possible

**Alternative Configuration (Hash-Only):**
```xml
<!-- Coming in future Wazuh versions: hash-only queries -->
<!-- Currently, file content is uploaded -->
```

### Compliance Impact

**For NIST 800-171:**
- Ensure CUI data is NOT uploaded to third-party services
- Document data handling in Privacy Impact Assessment
- Consider on-premises alternatives for CUI paths

**Recommended Monitoring Strategy:**
1. **System Paths:** Full VirusTotal integration (safe to upload)
   - `/etc`, `/usr/bin`, `/usr/sbin`, `/tmp`, `/var/tmp`

2. **CUI/FCI Paths:** FIM only, NO VirusTotal submission
   - `/srv/samba` (disable VirusTotal for this path)

**Disable VirusTotal for Sensitive Paths:**

Currently not supported per-directory. Alternative: Use separate Wazuh agent with different configuration, or rely on ClamAV for CUI paths.

---

## Cost Analysis

### Free Tier
- **Cost:** $0
- **Limit:** 500 requests/day
- **Suitable for:** <15 users, low file activity

### Premium Tier
- **Cost:** ~$180/year
- **Limit:** 15,000 requests/day
- **Suitable for:** Production environments, high file activity

### Enterprise Tier
- **Cost:** Custom (contact VirusTotal)
- **Limit:** Unlimited
- **Features:** Private scanning, API SLA

---

## Next Steps

1. **Immediate:**
   - [ ] Obtain VirusTotal API key
   - [ ] Configure integration in `/var/ossec/etc/ossec.conf`
   - [ ] Add custom rules to `/var/ossec/etc/rules/local_rules.xml`
   - [ ] Restart Wazuh manager
   - [ ] Test with EICAR file

2. **This Week:**
   - [ ] Monitor API usage vs. limits
   - [ ] Review alerts for false positives
   - [ ] Configure active response quarantine
   - [ ] Document in SSP

3. **Ongoing:**
   - [ ] Weekly review of quarantined files
   - [ ] Monitor API usage trends
   - [ ] Evaluate upgrade to paid tier if needed

---

**Prepared by:** Claude Code
**Date:** October 29, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Reviewed for:** Donald E. Shannon, System Owner/ISSO
