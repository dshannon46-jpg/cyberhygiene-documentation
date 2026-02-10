#!/bin/bash
#
# Module 00: Prerequisites Check
# Verify system is ready for CyberHygiene installation
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [00-PREREQ] $*"
}

log "Starting prerequisites check..."

# Array to track failures
declare -a FAILURES=()

# Check 1: Root privileges
log "Checking root privileges..."
if [[ $EUID -ne 0 ]]; then
    FAILURES+=("Must be run as root")
else
    log "✓ Running as root"
fi

# Check 2: Operating System
log "Checking operating system..."
if [[ -f /etc/redhat-release ]]; then
    OS_VERSION=$(cat /etc/redhat-release)
    log "✓ Operating System: ${OS_VERSION}"

    if ! echo "${OS_VERSION}" | grep -qi "rocky.*9"; then
        FAILURES+=("OS must be Rocky Linux 9.x (found: ${OS_VERSION})")
    fi
else
    FAILURES+=("Not a Red Hat-based system")
fi

# Check 3: FIPS Mode
log "Checking FIPS mode..."
if command -v fips-mode-setup &> /dev/null; then
    if fips-mode-setup --check | grep -q "FIPS mode is enabled"; then
        log "✓ FIPS mode is enabled"
    else
        FAILURES+=("FIPS mode is not enabled (run: fips-mode-setup --enable && reboot)")
    fi
else
    FAILURES+=("fips-mode-setup command not found")
fi

# Check 4: SELinux
log "Checking SELinux..."
if command -v getenforce &> /dev/null; then
    SELINUX_STATUS=$(getenforce)
    if [[ "${SELINUX_STATUS}" == "Enforcing" ]]; then
        log "✓ SELinux is Enforcing"
    else
        FAILURES+=("SELinux must be Enforcing (currently: ${SELINUX_STATUS})")
    fi
else
    FAILURES+=("SELinux not found")
fi

# Check 5: Firewall
log "Checking firewall..."
if systemctl is-active --quiet firewalld; then
    log "✓ Firewalld is active"
else
    FAILURES+=("Firewalld must be active and running")
fi

# Check 6: Disk Space
log "Checking disk space..."
ROOT_SPACE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
if [[ ${ROOT_SPACE} -lt 50 ]]; then
    FAILURES+=("Insufficient disk space on / (need 50GB, have ${ROOT_SPACE}GB)")
else
    log "✓ Sufficient disk space: ${ROOT_SPACE}GB available"
fi

# Check 7: Memory
log "Checking memory..."
TOTAL_MEM=$(free -g | awk '/^Mem:/ {print $2}')
if [[ ${TOTAL_MEM} -lt 60 ]]; then
    FAILURES+=("Insufficient memory (need 64GB, have ${TOTAL_MEM}GB)")
else
    log "✓ Sufficient memory: ${TOTAL_MEM}GB"
fi

# Check 8: Network Connectivity
log "Checking network connectivity..."
if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    log "✓ Internet connectivity available"
else
    log "⚠ Warning: No internet connectivity (may be intentional for air-gapped install)"
fi

# Check 9: Required Partitions
log "Checking partition layout..."
REQUIRED_PARTITIONS=("/" "/boot" "/var" "/var/log" "/home" "/tmp")
for part in "${REQUIRED_PARTITIONS[@]}"; do
    if mountpoint -q "${part}"; then
        log "✓ Partition exists: ${part}"
    else
        FAILURES+=("Required partition not found: ${part}")
    fi
done

# Check 10: Hostname
log "Checking hostname..."
CURRENT_HOSTNAME=$(hostname -f)
if [[ "${CURRENT_HOSTNAME}" =~ ^[a-z0-9.-]+\.[a-z]{2,}$ ]]; then
    log "✓ Valid FQDN hostname: ${CURRENT_HOSTNAME}"
else
    FAILURES+=("Hostname must be a valid FQDN (currently: ${CURRENT_HOSTNAME})")
fi

# Check 11: Required Commands
log "Checking required commands..."
REQUIRED_COMMANDS=("systemctl" "dnf" "firewall-cmd" "openssl" "sed" "awk")
for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if command -v "${cmd}" &> /dev/null; then
        log "✓ Command available: ${cmd}"
    else
        FAILURES+=("Required command not found: ${cmd}")
    fi
done

# Check 12: Installation Info File
log "Checking installation information file..."
if [[ -f "${SCRIPT_DIR}/installation_info.md" ]]; then
    log "✓ Installation info file found"

    # Basic validation that form is filled out
    if grep -q "_______________" "${SCRIPT_DIR}/installation_info.md"; then
        FAILURES+=("Installation info form contains unfilled fields (look for ___ placeholders)")
    fi
else
    FAILURES+=("Installation info file not found: ${SCRIPT_DIR}/installation_info.md")
fi

# Check 13: OpenSCAP
log "Checking OpenSCAP tools..."
if rpm -q openscap-scanner &> /dev/null && rpm -q scap-security-guide &> /dev/null; then
    log "✓ OpenSCAP tools installed"
else
    log "⚠ Warning: OpenSCAP tools not installed (will install during setup)"
fi

# Check 14: Time Synchronization
log "Checking time synchronization..."
if timedatectl status | grep -q "synchronized: yes"; then
    log "✓ System time is synchronized"
elif timedatectl status | grep -q "NTP service: active"; then
    log "✓ NTP service is active"
else
    log "⚠ Warning: Time synchronization not configured (will configure during setup)"
fi

# Check 15: Available Entropy
log "Checking entropy pool..."
if [[ -f /proc/sys/kernel/random/entropy_avail ]]; then
    ENTROPY=$(cat /proc/sys/kernel/random/entropy_avail)
    if [[ ${ENTROPY} -gt 1000 ]]; then
        log "✓ Sufficient entropy: ${ENTROPY}"
    else
        log "⚠ Warning: Low entropy (${ENTROPY}). May slow cryptographic operations."
    fi
fi

# Summary
echo ""
log "=========================================="
log "Prerequisites Check Summary"
log "=========================================="

if [[ ${#FAILURES[@]} -eq 0 ]]; then
    log "✓ All prerequisites met!"
    log "System is ready for CyberHygiene installation"
    exit 0
else
    log "✗ Found ${#FAILURES[@]} issue(s):"
    for failure in "${FAILURES[@]}"; do
        log "  - ${failure}"
    done
    log ""
    log "Please resolve these issues before proceeding with installation"
    exit 1
fi
