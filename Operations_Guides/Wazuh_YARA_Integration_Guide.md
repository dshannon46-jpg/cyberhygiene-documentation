# Wazuh YARA Integration Guide

**Date:** October 29, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Purpose:** Deploy custom YARA rules for malware detection in Wazuh
**Author:** Claude Code for Donald E. Shannon

---

## Overview

YARA is a pattern-matching engine for malware detection. This guide integrates YARA with Wazuh to detect malware based on custom signatures, providing an additional layer of defense alongside VirusTotal integration.

**Benefits:**
- Custom malware signatures
- No external dependencies (runs locally)
- FIPS-compatible (pattern matching, no crypto)
- Fast, low resource usage
- Detects known malware families
- Works offline

---

## Prerequisites

- Wazuh Manager or Agent installed
- Python 3.6+ (included in Rocky Linux 9.6)
- YARA Python library
- Wazuh FIM configured

---

## Step 1: Install YARA

### Install YARA and Python Bindings

```bash
# Install YARA from EPEL
sudo dnf install -y epel-release
sudo dnf install -y yara yara-devel python3-yara

# Verify installation
yara --version
python3 -c "import yara; print(yara.__version__)"
```

**Expected output:**
```
4.x.x
4.x.x
```

---

## Step 2: Create YARA Rules Directory

```bash
# Create rules directory
sudo mkdir -p /var/ossec/ruleset/yara/rules
sudo mkdir -p /var/ossec/ruleset/yara/scripts
sudo chown -R wazuh:wazuh /var/ossec/ruleset/yara
sudo chmod -R 750 /var/ossec/ruleset/yara
```

---

## Step 3: Deploy YARA Rules

### Common Malware Families

Create comprehensive YARA rules for detecting common threats:

```bash
sudo vi /var/ossec/ruleset/yara/rules/malware_common.yar
```

```yara
/*
    Common Malware Detection Rules
    Purpose: Detect widespread malware families
    Classification: CUI
    Date: October 29, 2025
*/

// EICAR Test File
rule EICAR_Test_File {
    meta:
        description = "EICAR antivirus test file"
        author = "Standard EICAR signature"
        reference = "https://www.eicar.org/"
        severity = "low"

    strings:
        $eicar = "X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"

    condition:
        $eicar
}

// Generic Web Shell Detection
rule WebShell_Generic {
    meta:
        description = "Generic web shell indicators"
        author = "Claude Code"
        severity = "high"

    strings:
        $php1 = "system($_GET"
        $php2 = "shell_exec($_POST"
        $php3 = "eval(base64_decode("
        $php4 = "passthru($_REQUEST"
        $php5 = "exec($_COOKIE"
        $php6 = "<?php @eval("
        $asp1 = "execute request"
        $asp2 = "eval(Request.Form"

    condition:
        any of them
}

// Suspicious PowerShell Commands
rule Suspicious_PowerShell {
    meta:
        description = "Suspicious PowerShell command patterns"
        author = "Claude Code"
        severity = "medium"

    strings:
        $enc1 = "powershell" nocase
        $enc2 = "-enc" nocase
        $enc3 = "-encodedcommand" nocase
        $bypass = "Set-ExecutionPolicy Bypass" nocase
        $download = "DownloadString" nocase
        $invoke = "Invoke-Expression" nocase
        $iex = "IEX(" nocase

    condition:
        ($enc1 and ($enc2 or $enc3)) or
        ($bypass and ($download or $invoke or $iex))
}

// Linux Rootkit Indicators
rule Linux_Rootkit_Indicators {
    meta:
        description = "Common Linux rootkit signatures"
        author = "Claude Code"
        severity = "critical"

    strings:
        $lkm1 = "init_module"
        $lkm2 = "cleanup_module"
        $hide1 = "hide_proc"
        $hide2 = "hide_file"
        $hide3 = "hide_tcp"
        $preload = "LD_PRELOAD"

    condition:
        (($lkm1 or $lkm2) and any of ($hide*)) or
        $preload
}

// SSH Backdoor Detection
rule SSH_Backdoor {
    meta:
        description = "SSH backdoor or credential stealer"
        author = "Claude Code"
        severity = "critical"

    strings:
        $ssh1 = "SSH-" ascii
        $pass1 = "password:" nocase
        $pass2 = "pwd=" nocase
        $log1 = "/tmp/." ascii
        $log2 = "/var/tmp/." ascii

    condition:
        $ssh1 and any of ($pass*) and any of ($log*)
}

// Cryptocurrency Miner Detection
rule CryptoMiner_Generic {
    meta:
        description = "Generic cryptocurrency miner indicators"
        author = "Claude Code"
        severity = "high"

    strings:
        $xmrig = "xmrig" nocase
        $stratum = "stratum+tcp://" nocase
        $donate = "donate-level" nocase
        $pool1 = "pool.minexmr.com"
        $pool2 = "pool.supportxmr.com"
        $pool3 = "monero.crypto-pool.fr"
        $wallet = /[48][0-9AB][1-9A-HJ-NP-Za-km-z]{93}/

    condition:
        $xmrig or
        ($stratum and ($donate or any of ($pool*))) or
        $wallet
}

// Ransomware Indicators
rule Ransomware_Generic {
    meta:
        description = "Generic ransomware behavior indicators"
        author = "Claude Code"
        severity = "critical"

    strings:
        $ext1 = ".encrypted" nocase
        $ext2 = ".locked" nocase
        $ext3 = ".crypted" nocase
        $readme = "README" nocase
        $bitcoin = /[13][a-km-zA-HJ-NP-Z1-9]{25,34}/
        $ransom1 = "your files have been encrypted" nocase
        $ransom2 = "send bitcoin" nocase
        $ransom3 = "decryption key" nocase

    condition:
        (any of ($ext*) and $readme) or
        ($bitcoin and any of ($ransom*))
}

// Reverse Shell Detection
rule Reverse_Shell {
    meta:
        description = "Reverse shell connection patterns"
        author = "Claude Code"
        severity = "high"

    strings:
        $bash1 = "/bin/bash -i"
        $bash2 = "bash -c"
        $nc1 = "nc -e /bin/sh"
        $nc2 = "nc -e /bin/bash"
        $py1 = "socket.socket"
        $py2 = "subprocess.call(['/bin/sh'])"
        $perl1 = "use Socket"
        $perl2 = "exec{\"/bin/sh\"}"

    condition:
        any of them
}
```

### Linux Specific Threats

```bash
sudo vi /var/ossec/ruleset/yara/rules/linux_malware.yar
```

```yara
/*
    Linux-Specific Malware Detection
    Purpose: Detect Linux malware and trojans
    Classification: CUI
    Date: October 29, 2025
*/

// Suspicious ELF Binary
rule Suspicious_ELF_Binary {
    meta:
        description = "ELF binary with suspicious characteristics"
        author = "Claude Code"
        severity = "medium"

    strings:
        $elf = { 7F 45 4C 46 }  // ELF magic bytes
        $upx1 = "UPX!"           // UPX packer
        $upx2 = {55505821}
        $tmp1 = "/tmp/." ascii
        $tmp2 = "/var/tmp/." ascii
        $dev_shm = "/dev/shm/" ascii

    condition:
        $elf at 0 and
        (any of ($upx*) or any of ($tmp*) or $dev_shm)
}

// Mirai Botnet
rule Mirai_Botnet {
    meta:
        description = "Mirai IoT botnet malware"
        author = "Claude Code"
        reference = "https://www.malware-traffic-analysis.net/mirai.html"
        severity = "critical"

    strings:
        $str1 = "TSource Engine Query" ascii
        $str2 = "/bin/busybox" ascii
        $str3 = "HTTPFLOOD" ascii
        $str4 = "LOLNOGTFO" ascii
        $str5 = "MIRAI" ascii wide

    condition:
        3 of them
}

// Linux Tsunami/Kaiten
rule Linux_Tsunami_Kaiten {
    meta:
        description = "Linux Tsunami/Kaiten DDoS malware"
        author = "Claude Code"
        severity = "critical"

    strings:
        $str1 = "PING" ascii
        $str2 = "TSUNAMI" ascii
        $str3 = "KAITEN" ascii
        $str4 = "spoofing" ascii
        $flood = "FLOOD" ascii

    condition:
        ($str2 or $str3) and ($str1 or $str4 or $flood)
}

// SSH Brute Force Script
rule SSH_BruteForce_Script {
    meta:
        description = "SSH brute force attack script"
        author = "Claude Code"
        severity = "high"

    strings:
        $shebang = "#!/" ascii
        $ssh = "ssh " ascii
        $user1 = "root@" ascii
        $user2 = "admin@" ascii
        $pass = "password" nocase
        $loop = "for " ascii
        $wordlist = "wordlist" nocase

    condition:
        $shebang at 0 and
        $ssh and
        ($user1 or $user2) and
        ($pass or $wordlist or $loop)
}
```

### Windows Malware (for Samba shares)

```bash
sudo vi /var/ossec/ruleset/yara/rules/windows_malware.yar
```

```yara
/*
    Windows Malware Detection for Samba Shares
    Purpose: Detect Windows malware in shared files
    Classification: CUI
    Date: October 29, 2025
*/

// PE File with Suspicious Imports
rule Suspicious_PE_Imports {
    meta:
        description = "PE file with suspicious API imports"
        author = "Claude Code"
        severity = "medium"

    strings:
        $mz = { 4D 5A }  // MZ header
        $pe = { 50 45 00 00 }  // PE signature
        $api1 = "CreateRemoteThread" ascii
        $api2 = "VirtualAllocEx" ascii
        $api3 = "WriteProcessMemory" ascii
        $api4 = "LoadLibraryA" ascii
        $api5 = "GetProcAddress" ascii
        $api6 = "WinExec" ascii
        $api7 = "ShellExecuteA" ascii

    condition:
        $mz at 0 and $pe and
        3 of ($api*)
}

// Macro Malware (Office Documents)
rule Office_Macro_Suspicious {
    meta:
        description = "Office document with suspicious VBA macro"
        author = "Claude Code"
        severity = "high"

    strings:
        $zip = { 50 4B 03 04 }  // ZIP header (modern Office)
        $ole = { D0 CF 11 E0 }  // OLE header (old Office)
        $vba1 = "AutoOpen" nocase
        $vba2 = "Auto_Open" nocase
        $vba3 = "Workbook_Open" nocase
        $vba4 = "Document_Open" nocase
        $shell = "Shell" nocase
        $download = "URLDownloadToFile" nocase
        $wscript = "WScript.Shell" nocase
        $powershell = "powershell" nocase

    condition:
        ($zip at 0 or $ole at 0) and
        any of ($vba*) and
        ($shell or $download or $wscript or $powershell)
}

// Windows Ransomware
rule Windows_Ransomware {
    meta:
        description = "Windows ransomware indicators"
        author = "Claude Code"
        severity = "critical"

    strings:
        $mz = { 4D 5A }
        $api1 = "CryptEncrypt" ascii
        $api2 = "CryptDecrypt" ascii
        $api3 = "CryptAcquireContext" ascii
        $ext1 = ".encrypted"
        $ext2 = ".locked"
        $ext3 = ".cryptolocker"
        $readme = "README.txt"
        $bitcoin = "bitcoin" nocase

    condition:
        $mz at 0 and
        2 of ($api*) and
        (any of ($ext*) or $readme or $bitcoin)
}
```

---

## Step 4: Create YARA Integration Script

```bash
sudo vi /var/ossec/ruleset/yara/scripts/yara-integration.py
```

```python
#!/usr/bin/env python3
"""
Wazuh YARA Integration Script
Scans files using YARA rules and generates Wazuh alerts
Classification: CUI
Date: October 29, 2025
"""

import os
import sys
import json
import yara
import hashlib
from datetime import datetime

# Configuration
RULES_DIR = "/var/ossec/ruleset/yara/rules"
LOG_FILE = "/var/ossec/logs/yara.log"
MAX_FILE_SIZE = 50 * 1024 * 1024  # 50 MB

def log_message(message):
    """Write to log file"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"[{timestamp}] {message}\n")

def get_file_hash(filepath):
    """Calculate SHA256 hash of file"""
    try:
        sha256 = hashlib.sha256()
        with open(filepath, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                sha256.update(chunk)
        return sha256.hexdigest()
    except Exception as e:
        log_message(f"Error calculating hash for {filepath}: {e}")
        return None

def scan_file(filepath, rules):
    """Scan file with YARA rules"""
    try:
        # Check file size
        file_size = os.path.getsize(filepath)
        if file_size > MAX_FILE_SIZE:
            log_message(f"Skipping {filepath}: file too large ({file_size} bytes)")
            return None

        # Scan file
        matches = rules.match(filepath)

        if matches:
            return matches
        return None

    except Exception as e:
        log_message(f"Error scanning {filepath}: {e}")
        return None

def generate_alert(filepath, matches):
    """Generate Wazuh-compatible JSON alert"""
    alert = {
        "yara": {
            "file": filepath,
            "sha256": get_file_hash(filepath),
            "matches": []
        }
    }

    for match in matches:
        match_data = {
            "rule": match.rule,
            "namespace": match.namespace if match.namespace else "default",
            "tags": match.tags,
            "meta": match.meta
        }
        alert["yara"]["matches"].append(match_data)

    return json.dumps(alert)

def main():
    """Main execution"""

    # Check if file path provided
    if len(sys.argv) < 2:
        log_message("ERROR: No file path provided")
        sys.exit(1)

    filepath = sys.argv[1]

    # Verify file exists
    if not os.path.isfile(filepath):
        log_message(f"ERROR: File not found: {filepath}")
        sys.exit(1)

    # Skip directories we don't want to scan
    skip_dirs = ['/var/ossec', '/proc', '/sys', '/dev']
    if any(filepath.startswith(d) for d in skip_dirs):
        sys.exit(0)

    # Skip certain file extensions
    skip_extensions = ['.log', '.txt', '.md', '.pdf', '.jpg', '.png', '.gif']
    if any(filepath.endswith(ext) for ext in skip_extensions):
        sys.exit(0)

    # Load YARA rules
    try:
        rule_files = {}
        for rule_file in os.listdir(RULES_DIR):
            if rule_file.endswith('.yar') or rule_file.endswith('.yara'):
                rule_path = os.path.join(RULES_DIR, rule_file)
                rule_files[rule_file] = rule_path

        if not rule_files:
            log_message("ERROR: No YARA rules found")
            sys.exit(1)

        rules = yara.compile(filepaths=rule_files)

    except Exception as e:
        log_message(f"ERROR loading YARA rules: {e}")
        sys.exit(1)

    # Scan file
    matches = scan_file(filepath, rules)

    if matches:
        # Generate alert
        alert = generate_alert(filepath, matches)
        print(alert)
        log_message(f"MATCH: {filepath} - {len(matches)} rule(s) matched")

    sys.exit(0)

if __name__ == "__main__":
    main()
```

```bash
# Make executable
sudo chmod 750 /var/ossec/ruleset/yara/scripts/yara-integration.py
sudo chown wazuh:wazuh /var/ossec/ruleset/yara/scripts/yara-integration.py

# Create log file
sudo touch /var/log/yara.log
sudo chown wazuh:wazuh /var/log/yara.log
sudo chmod 640 /var/log/yara.log
```

---

## Step 5: Configure Wazuh to Use YARA

### Edit Wazuh Configuration

```bash
sudo vi /var/ossec/etc/ossec.conf
```

Add the following **inside `<syscheck>` section**:

```xml
<syscheck>
  <!-- Existing FIM configuration -->

  <!-- YARA Integration -->
  <yara_rules>/var/ossec/ruleset/yara/rules</yara_rules>

  <directories check_all="yes" realtime="yes" report_changes="yes"
               yara="/var/ossec/ruleset/yara/scripts/yara-integration.py">/tmp</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes"
               yara="/var/ossec/ruleset/yara/scripts/yara-integration.py">/var/tmp</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes"
               yara="/var/ossec/ruleset/yara/scripts/yara-integration.py">/dev/shm</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes"
               yara="/var/ossec/ruleset/yara/scripts/yara-integration.py">/home</directories>
  <directories check_all="yes" realtime="yes" report_changes="yes"
               yara="/var/ossec/ruleset/yara/scripts/yara-integration.py">/srv/samba</directories>

</syscheck>
```

**Note:** YARA integration in Wazuh requires version 4.3+. If your version doesn't support native YARA integration, use the active-response method below.

### Alternative: Active Response Method (All Wazuh Versions)

```xml
<!-- Command to run YARA scan -->
<command>
  <name>yara-scan</name>
  <executable>yara-scan.sh</executable>
  <timeout_allowed>no</timeout_allowed>
</command>

<!-- Active response trigger -->
<active-response>
  <command>yara-scan</command>
  <location>local</location>
  <rules_id>550,554</rules_id> <!-- FIM new file, file modified -->
</active-response>
```

Create active response script:

```bash
sudo vi /var/ossec/active-response/bin/yara-scan.sh
```

```bash
#!/bin/bash
# YARA Active Response Script

LOG="/var/ossec/logs/yara.log"
ALERT_FILE="/var/ossec/logs/alerts/alerts.json"

# Read alert from stdin
read INPUT_JSON

# Extract file path
FILEPATH=$(echo $INPUT_JSON | jq -r '.parameters.alert.syscheck.path' 2>/dev/null)

if [ -z "$FILEPATH" ] || [ ! -f "$FILEPATH" ]; then
    exit 0
fi

# Run YARA scan
RESULT=$(/var/ossec/ruleset/yara/scripts/yara-integration.py "$FILEPATH")

if [ -n "$RESULT" ]; then
    # Malware detected, write to alerts
    echo "$RESULT" >> "$ALERT_FILE"
    echo "$(date) - YARA match: $FILEPATH" >> "$LOG"
fi
```

```bash
sudo chmod 750 /var/ossec/active-response/bin/yara-scan.sh
sudo chown root:wazuh /var/ossec/active-response/bin/yara-scan.sh
```

---

## Step 6: Create Wazuh Rules for YARA Alerts

```bash
sudo vi /var/ossec/etc/rules/local_rules.xml
```

Add YARA rules:

```xml
<!-- YARA Malware Detection Rules -->
<group name="yara,malware,">

  <!-- YARA Scan Completed -->
  <rule id="100200" level="5">
    <decoded_as>json</decoded_as>
    <field name="yara.matches">\.+</field>
    <description>YARA: Malware pattern detected</description>
  </rule>

  <!-- Medium Severity Malware -->
  <rule id="100201" level="10">
    <if_sid>100200</if_sid>
    <field name="yara.matches.meta.severity">medium</field>
    <description>YARA: Medium severity malware detected - $(yara.matches.rule)</description>
    <group>malware,pci_dss_11.4,gdpr_IV_35.7.d,nist_800_53_SI.3,</group>
  </rule>

  <!-- High Severity Malware -->
  <rule id>100202" level="12">
    <if_sid>100200</if_sid>
    <field name="yara.matches.meta.severity">high</field>
    <description>YARA: High severity malware detected - $(yara.matches.rule)</description>
    <group>malware,pci_dss_11.4,gdpr_IV_35.7.d,nist_800_53_SI.3,</group>
  </rule>

  <!-- Critical Malware -->
  <rule id="100203" level="15">
    <if_sid>100200</if_sid>
    <field name="yara.matches.meta.severity">critical</field>
    <description>YARA: CRITICAL malware detected - $(yara.matches.rule) - IMMEDIATE ACTION REQUIRED</description>
    <options>alert_by_email</options>
    <group>malware,pci_dss_11.4,gdpr_IV_35.7.d,nist_800_53_SI.3,</group>
  </rule>

  <!-- Specific Malware Families -->
  <rule id="100204" level="15">
    <if_sid>100200</if_sid>
    <field name="yara.matches.rule">Ransomware</field>
    <description>YARA: RANSOMWARE detected - $(yara.file) - ISOLATE SYSTEM IMMEDIATELY</description>
    <options>alert_by_email</options>
    <group>ransomware,malware,</group>
  </rule>

  <rule id="100205" level="14">
    <if_sid>100200</if_sid>
    <field name="yara.matches.rule">CryptoMiner</field>
    <description>YARA: Cryptocurrency miner detected - $(yara.file)</description>
    <group>cryptominer,malware,</group>
  </rule>

  <rule id="100206" level="14">
    <if_sid>100200</if_sid>
    <field name="yara.matches.rule">WebShell</field>
    <description>YARA: Web shell detected - $(yara.file)</description>
    <group>webshell,malware,</group>
  </rule>

</group>
```

---

## Step 7: Restart and Test

```bash
# Validate configuration
sudo /var/ossec/bin/wazuh-control check

# Restart Wazuh
sudo systemctl restart wazuh-manager

# Check logs
sudo tail -f /var/ossec/logs/ossec.log
```

### Test with EICAR

```bash
# Create EICAR file
cd /tmp
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > eicar.com

# Check YARA log
sudo tail -f /var/log/yara.log

# Check Wazuh alerts
sudo tail -f /var/ossec/logs/alerts/alerts.log | grep -i yara
```

---

## Step 8: Maintenance

### Update YARA Rules

```bash
# Add new rules to existing .yar files or create new ones
sudo vi /var/ossec/ruleset/yara/rules/custom_threats.yar

# Restart Wazuh to reload rules
sudo systemctl restart wazuh-manager
```

### Monitor YARA Performance

```bash
# Check scan statistics
sudo grep "YARA" /var/log/yara.log | tail -20

# Monitor resource usage
ps aux | grep yara
```

---

## Additional YARA Rule Sources

### Download Community Rules

```bash
# Awesome YARA Rules Collection
cd /tmp
git clone https://github.com/Yara-Rules/rules.git yara-community-rules

# Review and copy relevant rules
sudo cp /tmp/yara-community-rules/malware/*.yar \
    /var/ossec/ruleset/yara/rules/

# Restart Wazuh
sudo systemctl restart wazuh-manager
```

**Warning:** Review community rules before deploying to avoid false positives.

---

## Troubleshooting

### YARA Not Scanning Files

**Check 1: Verify YARA installed**
```bash
yara --version
python3 -c "import yara"
```

**Check 2: Check permissions**
```bash
ls -lh /var/ossec/ruleset/yara/scripts/yara-integration.py
sudo -u wazuh /var/ossec/ruleset/yara/scripts/yara-integration.py /tmp/eicar.com
```

**Check 3: Review logs**
```bash
sudo cat /var/log/yara.log
sudo grep -i yara /var/ossec/logs/ossec.log
```

### High False Positive Rate

- Review and refine YARA rules
- Add file type/extension filters in integration script
- Increase rule specificity

---

**Prepared by:** Claude Code
**Date:** October 29, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
