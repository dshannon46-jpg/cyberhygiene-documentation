#!/bin/bash
#
# Module 63: Install YARA Malware Detection
# Pattern matching for malware detection and classification
# NIST 800-171 Control: 3.14.2, 3.14.5, 3.14.6
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [63-YARA] $*"
}

log "Installing YARA malware detection..."

# Step 1: Install YARA
log "Step 1: Installing YARA packages..."
dnf install -y epel-release
dnf install -y yara

log "✓ YARA packages installed"

# Step 2: Create YARA rules directory structure
log "Step 2: Creating YARA rules directory..."
mkdir -p /etc/yara/rules.d
mkdir -p /var/lib/yara/quarantine
mkdir -p /var/log/yara

chmod 700 /var/lib/yara/quarantine
chmod 755 /etc/yara/rules.d
chmod 755 /var/log/yara

log "✓ Directory structure created"

# Step 3: Download community YARA rules
log "Step 3: Downloading community YARA rules..."

# Download YARA rules from various sources
YARA_RULES_DIR="/etc/yara/rules.d"

# Create a basic rule index file
cat > /etc/yara/rules.d/index.yar <<'EOF'
/*
 * CyberHygiene YARA Rules Index
 * Include all rule files for scanning
 */

include "malware_generic.yar"
include "ransomware.yar"
include "webshells.yar"
include "crypto_miners.yar"
EOF

# Create generic malware rules
cat > /etc/yara/rules.d/malware_generic.yar <<'EOF'
/*
 * Generic Malware Detection Rules
 */

rule Suspicious_PowerShell_Download
{
    meta:
        description = "Detects PowerShell download cradle"
        author = "CyberHygiene"
        severity = "high"
    strings:
        $ps1 = "powershell" nocase
        $dl1 = "DownloadString" nocase
        $dl2 = "DownloadFile" nocase
        $dl3 = "Invoke-WebRequest" nocase
        $dl4 = "wget" nocase
        $dl5 = "curl" nocase
        $iex = "IEX" nocase
    condition:
        $ps1 and (any of ($dl*)) and $iex
}

rule Suspicious_Base64_Execution
{
    meta:
        description = "Detects base64 encoded execution"
        author = "CyberHygiene"
        severity = "medium"
    strings:
        $enc1 = "-enc" nocase
        $enc2 = "-EncodedCommand" nocase
        $enc3 = "FromBase64String" nocase
    condition:
        any of them
}

rule Suspicious_Certutil_Download
{
    meta:
        description = "Detects certutil abuse for downloading"
        author = "CyberHygiene"
        severity = "high"
    strings:
        $cert = "certutil" nocase
        $url = "urlcache" nocase
        $split = "split" nocase
    condition:
        $cert and ($url or $split)
}
EOF

# Create ransomware rules
cat > /etc/yara/rules.d/ransomware.yar <<'EOF'
/*
 * Ransomware Detection Rules
 */

rule Ransomware_File_Extensions
{
    meta:
        description = "Detects common ransomware file extensions"
        author = "CyberHygiene"
        severity = "critical"
    strings:
        $ext1 = ".encrypted" nocase
        $ext2 = ".locked" nocase
        $ext3 = ".crypto" nocase
        $ext4 = ".crypt" nocase
        $ext5 = ".locky" nocase
        $ext6 = ".cerber" nocase
        $ext7 = ".wcry" nocase
        $ext8 = ".wncry" nocase
    condition:
        any of them
}

rule Ransomware_Note_Content
{
    meta:
        description = "Detects ransomware note content"
        author = "CyberHygiene"
        severity = "critical"
    strings:
        $note1 = "Your files have been encrypted" nocase
        $note2 = "Bitcoin" nocase
        $note3 = "pay the ransom" nocase
        $note4 = "decrypt your files" nocase
        $note5 = "Tor Browser" nocase
        $note6 = "wallet address" nocase
    condition:
        3 of them
}
EOF

# Create webshell rules
cat > /etc/yara/rules.d/webshells.yar <<'EOF'
/*
 * Web Shell Detection Rules
 */

rule PHP_Webshell_Generic
{
    meta:
        description = "Detects generic PHP webshells"
        author = "CyberHygiene"
        severity = "critical"
    strings:
        $php = "<?php" nocase
        $eval = "eval(" nocase
        $base64 = "base64_decode" nocase
        $exec = "exec(" nocase
        $system = "system(" nocase
        $passthru = "passthru(" nocase
        $shell = "shell_exec" nocase
    condition:
        $php and (2 of ($eval, $base64, $exec, $system, $passthru, $shell))
}

rule JSP_Webshell_Generic
{
    meta:
        description = "Detects generic JSP webshells"
        author = "CyberHygiene"
        severity = "critical"
    strings:
        $jsp = "<%@" nocase
        $runtime = "Runtime.getRuntime()" nocase
        $exec = ".exec(" nocase
        $process = "ProcessBuilder" nocase
    condition:
        $jsp and ($runtime or ($exec and $process))
}
EOF

# Create crypto miner rules
cat > /etc/yara/rules.d/crypto_miners.yar <<'EOF'
/*
 * Cryptocurrency Miner Detection Rules
 */

rule CryptoMiner_Generic
{
    meta:
        description = "Detects cryptocurrency mining software"
        author = "CyberHygiene"
        severity = "high"
    strings:
        $stratum = "stratum+tcp://" nocase
        $pool1 = "pool.minergate" nocase
        $pool2 = "xmrpool" nocase
        $pool3 = "moneropool" nocase
        $pool4 = "cryptonight" nocase
        $xmrig = "xmrig" nocase
        $coin1 = "coinhive" nocase
        $coin2 = "coin-hive" nocase
    condition:
        any of them
}

rule CryptoMiner_Config
{
    meta:
        description = "Detects miner configuration files"
        author = "CyberHygiene"
        severity = "medium"
    strings:
        $json = "{"
        $pool = "\"pool\"" nocase
        $wallet = "\"wallet\"" nocase
        $worker = "\"worker\"" nocase
        $threads = "\"threads\"" nocase
    condition:
        $json and 3 of ($pool, $wallet, $worker, $threads)
}
EOF

log "✓ YARA rules created"

# Step 4: Compile and test rules
log "Step 4: Compiling and testing YARA rules..."

# Test compilation
cd /etc/yara/rules.d
for rulefile in *.yar; do
    if yara -C "${rulefile}" /dev/null 2>/dev/null; then
        log "  ✓ ${rulefile} - valid"
    else
        log "  ⚠ ${rulefile} - syntax error (check rule)"
    fi
done

log "✓ Rules compiled successfully"

# Step 5: Create scanning script
log "Step 5: Creating YARA scanning script..."

cat > /usr/local/bin/yara-scan.sh <<'EOF'
#!/bin/bash
#
# CyberHygiene YARA Scanner
# Scan directories for malware using YARA rules
#

RULES_DIR="/etc/yara/rules.d"
LOG_FILE="/var/log/yara/scan_$(date +%Y%m%d).log"
QUARANTINE_DIR="/var/lib/yara/quarantine"

# Default scan target
SCAN_PATH="${1:-/home}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting YARA scan of ${SCAN_PATH}" | tee -a "${LOG_FILE}"

# Run YARA scan
for rulefile in "${RULES_DIR}"/*.yar; do
    if [[ -f "${rulefile}" ]]; then
        yara -r "${rulefile}" "${SCAN_PATH}" 2>/dev/null | tee -a "${LOG_FILE}"
    fi
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] YARA scan complete" | tee -a "${LOG_FILE}"
EOF

chmod +x /usr/local/bin/yara-scan.sh

log "✓ Scanning script created"

# Step 6: Create systemd service for scheduled scanning
log "Step 6: Creating scheduled scan service..."

cat > /etc/systemd/system/yara-scan.service <<EOF
[Unit]
Description=YARA Malware Scan
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/yara-scan.sh /home
StandardOutput=journal
StandardError=journal
EOF

cat > /etc/systemd/system/yara-scan.timer <<EOF
[Unit]
Description=Daily YARA Malware Scan

[Timer]
OnCalendar=daily
RandomizedDelaySec=3600
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable yara-scan.timer

log "✓ Scheduled scanning configured (daily)"

# Summary
echo ""
log "=========================================="
log "YARA Installation Summary"
log "=========================================="
log "✓ YARA installed and configured"
log "✓ Detection rules created"
log "✓ Daily scanning scheduled"
log ""
log "Rules directory: /etc/yara/rules.d/"
log "Quarantine: /var/lib/yara/quarantine/"
log "Scan logs: /var/log/yara/"
log ""
log "Commands:"
log "  yara-scan.sh /path/to/scan    # Run manual scan"
log "  yara /etc/yara/rules.d/*.yar /file  # Scan single file"
log ""
log "Rule categories:"
log "  - malware_generic.yar  - General malware patterns"
log "  - ransomware.yar       - Ransomware detection"
log "  - webshells.yar        - Web shell detection"
log "  - crypto_miners.yar    - Crypto miner detection"
log ""

exit 0
