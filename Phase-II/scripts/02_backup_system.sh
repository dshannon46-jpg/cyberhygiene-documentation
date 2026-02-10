#!/bin/bash
#
# Module 02: Backup System State
# Create restore point before making changes
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="${BACKUP_DIR}/pre_install_${TIMESTAMP}"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [02-BACKUP] $*"
}

log "Creating system backup..."

# Create backup directory
mkdir -p "${BACKUP_PATH}"

log "Backup location: ${BACKUP_PATH}"

# Backup 1: Package list
log "Backing up package list..."
rpm -qa | sort > "${BACKUP_PATH}/packages.txt"
log "✓ Package list saved"

# Backup 2: System configuration files
log "Backing up system configuration..."
CONFIGS_TO_BACKUP=(
    "/etc/hostname"
    "/etc/hosts"
    "/etc/resolv.conf"
    "/etc/sysconfig/network-scripts"
    "/etc/firewalld"
    "/etc/selinux/config"
    "/etc/fstab"
    "/etc/cron* Tab"
)

for config in "${CONFIGS_TO_BACKUP[@]}"; do
    if [[ -e "${config}" ]]; then
        # Preserve directory structure
        config_dir=$(dirname "${config}")
        mkdir -p "${BACKUP_PATH}${config_dir}"
        cp -a "${config}" "${BACKUP_PATH}${config_dir}/" 2>/dev/null || true
        log "  - Backed up: ${config}"
    fi
done

# Backup 3: Network configuration
log "Backing up network configuration..."
ip addr show > "${BACKUP_PATH}/ip_addr.txt"
ip route show > "${BACKUP_PATH}/ip_route.txt"
log "✓ Network configuration saved"

# Backup 4: Firewall rules
log "Backing up firewall rules..."
if systemctl is-active --quiet firewalld; then
    firewall-cmd --list-all-zones > "${BACKUP_PATH}/firewall_zones.txt"
    log "✓ Firewall rules saved"
fi

# Backup 5: SELinux status
log "Backing up SELinux status..."
if command -v getenforce &> /dev/null; then
    getenforce > "${BACKUP_PATH}/selinux_status.txt"
    sestatus > "${BACKUP_PATH}/sestatus.txt"
    log "✓ SELinux status saved"
fi

# Backup 6: Current services status
log "Backing up services status..."
systemctl list-units --type=service --all > "${BACKUP_PATH}/services.txt"
log "✓ Services status saved"

# Backup 7: System information
log "Backing up system information..."
{
    echo "=== Hostname ==="
    hostname -f
    echo ""
    echo "=== OS Version ==="
    cat /etc/redhat-release
    echo ""
    echo "=== Kernel ==="
    uname -a
    echo ""
    echo "=== Memory ==="
    free -h
    echo ""
    echo "=== Disk Space ==="
    df -h
    echo ""
    echo "=== CPU Info ==="
    lscpu
} > "${BACKUP_PATH}/system_info.txt"
log "✓ System information saved"

# Backup 8: FIPS mode status
log "Backing up FIPS mode status..."
if command -v fips-mode-setup &> /dev/null; then
    fips-mode-setup --check > "${BACKUP_PATH}/fips_status.txt"
    log "✓ FIPS status saved"
fi

# Backup 9: Create tarball of key directories (if they exist)
log "Creating tarball of configuration directories..."
TAR_DIRS=()
[[ -d /etc/httpd ]] && TAR_DIRS+=("/etc/httpd")
[[ -d /etc/samba ]] && TAR_DIRS+=("/etc/samba")
[[ -d /etc/postfix ]] && TAR_DIRS+=("/etc/postfix")

if [[ ${#TAR_DIRS[@]} -gt 0 ]]; then
    tar -czf "${BACKUP_PATH}/etc_configs.tar.gz" "${TAR_DIRS[@]}" 2>/dev/null || true
    log "✓ Configuration directories archived"
fi

# Create manifest
log "Creating backup manifest..."
cat > "${BACKUP_PATH}/MANIFEST.txt" <<EOF
========================================
CyberHygiene Pre-Installation Backup
========================================
Created: $(date)
Hostname: $(hostname -f)
Backup Path: ${BACKUP_PATH}

========================================
BACKUP CONTENTS
========================================

1. Package List (packages.txt)
   - Complete list of installed RPM packages

2. System Configuration Files
   - Hostname, hosts, resolv.conf
   - Network scripts
   - Firewall configuration
   - SELinux configuration
   - Filesystem table

3. Network Configuration
   - IP addresses (ip_addr.txt)
   - Routing table (ip_route.txt)

4. Firewall Rules (firewall_zones.txt)
   - All firewalld zones and rules

5. SELinux Status
   - Current enforcement mode
   - Full sestatus output

6. Services Status (services.txt)
   - All systemd units and their states

7. System Information (system_info.txt)
   - Hostname, OS version, kernel
   - Memory, disk space, CPU details

8. FIPS Mode Status (fips_status.txt)
   - Current FIPS mode state

9. Configuration Archives (etc_configs.tar.gz)
   - Tarball of existing service configurations

========================================
RESTORATION NOTES
========================================

To restore from this backup:

1. Review individual files in this directory
2. Manually restore configuration files as needed
3. Reinstall packages from packages.txt if necessary
4. Use system_info.txt to verify hardware matches

This is a POINT-IN-TIME backup. Do not restore
over a working installation without careful review.

========================================
EOF

# Calculate backup size
BACKUP_SIZE=$(du -sh "${BACKUP_PATH}" | awk '{print $1}')

log "✓ Backup manifest created"

# Summary
echo ""
log "=========================================="
log "Backup Summary"
log "=========================================="
log "Backup completed successfully"
log "Location: ${BACKUP_PATH}"
log "Size: ${BACKUP_SIZE}"
log "Timestamp: ${TIMESTAMP}"
log ""
log "Backup includes:"
log "  - Package list"
log "  - System configuration files"
log "  - Network settings"
log "  - Firewall rules"
log "  - SELinux status"
log "  - Services status"
log "  - System information"
log ""
log "✓ System state preserved. Safe to proceed with installation."
log ""

exit 0
