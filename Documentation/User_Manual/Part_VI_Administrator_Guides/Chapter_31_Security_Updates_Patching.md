# Chapter 31: Security Updates & Patching

## 31.1 Update Strategy

### Patch Management Philosophy

**CyberHygiene Update Approach:**

```
Security-First Patching:
  ✓ Security updates: Applied within 24-48 hours
  ✓ Critical vulnerabilities: Applied immediately (emergency maintenance)
  ✓ Standard updates: Monthly maintenance window
  ✓ Feature updates: Evaluated and scheduled
  ✓ Kernel updates: Quarterly or as needed (requires reboot)

Testing Strategy:
  1. Test in development/staging (if available)
  2. Apply to non-critical systems first
  3. Monitor for 24-48 hours
  4. Roll out to critical systems
  5. Document and verify

Rollback Plan:
  - Snapshot before major updates
  - Keep previous kernel bootable
  - Backup configurations before changes
  - Document rollback procedures
```

### Update Schedule

**Automated Security Updates:**

```
Daily (02:00 AM):
  - Check for security updates
  - Download but do not install
  - Email report of available updates

Weekly (Sunday 03:00 AM):
  - Install security-only updates automatically
  - Services: Auto-restart if needed
  - Kernel: Stage but do not apply (manual)

Monthly (First Tuesday, 22:00):
  - Scheduled maintenance window
  - All non-security updates
  - Kernel updates
  - System reboots (if needed)
  - Testing and verification

Emergency:
  - Critical CVE announced
  - Active exploit in the wild
  - Zero-day vulnerability
  - Apply immediately after testing
```

## 31.2 DNF Update Configuration

### DNF Automatic Updates

**Configuration File:** `/etc/dnf/automatic.conf`

```ini
[commands]
#  What kind of upgrade to perform:
# default                            = all available upgrades
# security                           = only security upgrades
upgrade_type = security

# Whether to download updates ahead of time
download_updates = yes

# Whether to apply updates
apply_updates = yes

# Maximum amount of time to randomly sleep, in minutes
random_sleep = 30

[emitters]
# Emit via: stdio, email, motd
emit_via = stdio,email

[email]
# The address to send email messages from
email_from = updates@cyberinabox.net

# List of addresses to send messages to
email_to = admin@cyberinabox.net

# Name of the host to connect to for sending messages
email_host = mail.cyberinabox.net

# Port to connect to for sending messages
email_port = 587

# Whether to use TLS
email_tls = yes

[base]
# Override DNF configuration options
debuglevel = 1
```

**Enable DNF Automatic:**

```bash
# Install dnf-automatic
sudo dnf install dnf-automatic

# Enable and start service
sudo systemctl enable --now dnf-automatic.timer

# Check status
sudo systemctl status dnf-automatic.timer

# View recent runs
sudo journalctl -u dnf-automatic.service -n 50

# Test manual run
sudo dnf-automatic
```

### Manual Update Process

**Check for Updates:**

```bash
# Check available updates
sudo dnf check-update

# List only security updates
sudo dnf updateinfo list security

# Get details on specific security update
sudo dnf updateinfo info <advisory-id>

# Example output:
===============================================================================
  RHSA-2025:0123 Important/Sec. kernel-5.14.0-611.16.1.el9_7.x86_64
===============================================================================
  Update ID: RHSA-2025:0123
  Type: security
  Updated: 2025-01-15
  Severity: Important
  Description: Security update for kernel
  CVE: CVE-2025-12345, CVE-2025-67890
```

**Apply Security Updates:**

```bash
# Apply only security updates
sudo dnf upgrade --security

# Apply specific advisory
sudo dnf upgrade --advisory=RHSA-2025:0123

# Apply all updates
sudo dnf upgrade

# Exclude specific packages
sudo dnf upgrade --exclude=kernel*

# Dry run (see what would be updated)
sudo dnf upgrade --assumeno
```

**Update Specific Package:**

```bash
# Update single package
sudo dnf upgrade package-name

# Downgrade if needed (rollback)
sudo dnf downgrade package-name

# View package update history
sudo dnf history

# Undo specific transaction
sudo dnf history undo <transaction-id>
```

## 31.3 System-Specific Update Procedures

### Critical Systems (dc1, wazuh)

**Pre-Update Checklist:**

```bash
#!/bin/bash
#
# Pre-update checklist for critical systems
#

echo "=== Pre-Update Checklist for $(hostname) ==="

# 1. Backup current system
echo "1. Creating backup..."
/usr/local/bin/backup-system.sh $(hostname)

# 2. Document current state
echo "2. Documenting system state..."
rpm -qa > /tmp/packages-before-update.txt
systemctl list-units --state=running > /tmp/services-before-update.txt
df -h > /tmp/disk-before-update.txt
free -h > /tmp/memory-before-update.txt

# 3. Check current kernel
echo "3. Current kernel:"
uname -r

# 4. Check if reboot required
if needs-restarting -r; then
    echo "4. Reboot required after update"
else
    echo "4. No reboot currently required"
fi

# 5. Check disk space
AVAILABLE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
if [ ${AVAILABLE} -lt 5 ]; then
    echo "5. WARNING: Low disk space (${AVAILABLE}GB available)"
    exit 1
else
    echo "5. Disk space OK (${AVAILABLE}GB available)"
fi

# 6. Check services
echo "6. Checking critical services..."
for service in sshd httpd ipa; do
    if systemctl is-active --quiet ${service}; then
        echo "   ${service}: running"
    else
        echo "   WARNING: ${service} not running"
    fi
done

echo "=== Pre-update checklist complete ==="
```

**Update Critical System:**

```bash
# Run pre-update checklist
sudo /usr/local/bin/pre-update-checklist.sh

# Download updates first (don't apply yet)
sudo dnf upgrade --downloadonly

# Create pre-update snapshot (if using LVM)
sudo lvcreate -L 10G -s -n root-snapshot /dev/mapper/rl-root

# Apply updates
sudo dnf upgrade -y

# Check what needs restart
sudo needs-restarting

# Check if services need restart
sudo needs-restarting -s

# Restart services (not full reboot yet)
sudo systemctl restart httpd
sudo systemctl restart ipa

# Verify services started correctly
sudo systemctl status httpd
sudo systemctl status ipa

# Test functionality
curl -k https://localhost/
kinit admin  # Test Kerberos

# Schedule reboot for kernel update (if needed)
sudo shutdown -r +60 "System reboot for kernel update in 60 minutes"

# Cancel if issues found
sudo shutdown -c
```

**Post-Update Verification:**

```bash
#!/bin/bash
#
# Post-update verification
#

echo "=== Post-Update Verification ==="

# Check new kernel
echo "1. Kernel version:"
uname -r

# Check critical services
echo "2. Service status:"
systemctl is-active sshd httpd ipa wazuh-manager

# Check disk space
echo "3. Disk space:"
df -h /

# Check for errors
echo "4. Recent errors in journal:"
sudo journalctl -p err -n 20

# Test authentication
echo "5. Testing Kerberos authentication..."
echo "password" | kinit admin && echo "Kerberos: OK" || echo "Kerberos: FAILED"

# Test web services
echo "6. Testing web services..."
curl -sk https://localhost/ > /dev/null && echo "HTTPS: OK" || echo "HTTPS: FAILED"

# Compare packages
echo "7. Packages updated:"
diff /tmp/packages-before-update.txt <(rpm -qa) | grep "^>" | wc -l

echo "=== Verification complete ==="
```

### Standard Systems

**Batch Update Script:**

**Location:** `/usr/local/bin/update-standard-systems.sh`

```bash
#!/bin/bash
#
# Update all standard systems
# Run during monthly maintenance window
#

SYSTEMS=(
    "dms.cyberinabox.net"
    "proxy.cyberinabox.net"
    "monitoring.cyberinabox.net"
)

LOG_DIR="/var/log/updates"
mkdir -p "${LOG_DIR}"
DATE=$(date +%Y%m%d-%H%M)

for system in "${SYSTEMS[@]}"; do
    echo "Updating ${system}..."

    # Run update via SSH
    ssh admin@"${system}" "
        sudo dnf upgrade -y 2>&1 | tee /tmp/update-${DATE}.log &&
        sudo needs-restarting -r || echo 'Reboot required'
    " | tee "${LOG_DIR}/${system}-${DATE}.log"

    # Check if reboot needed
    if ssh admin@"${system}" "sudo needs-restarting -r"; then
        echo "${system}: No reboot needed"
    else
        echo "${system}: Reboot required - scheduling"
        ssh admin@"${system}" "sudo shutdown -r +60 'System update reboot in 60 min'"
    fi
done

echo "All systems updated. Check logs in ${LOG_DIR}/"
```

## 31.4 Kernel Updates

### Kernel Update Process

**Check Available Kernel Updates:**

```bash
# List available kernels
sudo dnf list available kernel

# Check current kernel
uname -r

# Check installed kernels
rpm -q kernel

# Example output:
kernel-5.14.0-503.el9.x86_64
kernel-5.14.0-611.el9.x86_64  # Current
kernel-5.14.0-611.16.1.el9_7.x86_64  # New

# Check if running latest
LATEST_KERNEL=$(rpm -q kernel --last | head -1 | awk '{print $1}' | sed 's/kernel-//')
RUNNING_KERNEL=$(uname -r)

if [ "${LATEST_KERNEL}" = "${RUNNING_KERNEL}" ]; then
    echo "Running latest kernel"
else
    echo "Reboot required for kernel ${LATEST_KERNEL}"
fi
```

**Install Kernel Update:**

```bash
# Install new kernel (does not remove old)
sudo dnf upgrade kernel

# Verify new kernel installed
rpm -q kernel --last

# Check default boot kernel
sudo grubby --default-kernel

# Set default kernel (if needed)
sudo grubby --set-default /boot/vmlinuz-5.14.0-611.16.1.el9_7.x86_64

# View all boot entries
sudo grubby --info=ALL

# Schedule reboot
sudo shutdown -r +15 "Rebooting for kernel update in 15 minutes"

# Or immediate reboot
sudo systemctl reboot
```

**Post-Reboot Verification:**

```bash
# After reboot, verify new kernel
uname -r
# Should show: 5.14.0-611.16.1.el9_7.x86_64

# Check if all services started
sudo systemctl --failed

# Check system logs for errors
sudo journalctl -p err -b

# Verify FIPS mode still enabled
fips-mode-setup --check
# Should show: FIPS mode is enabled

# If new kernel has issues, boot to previous kernel:
# 1. Reboot system
# 2. In GRUB menu, select previous kernel
# 3. Once booted, set previous kernel as default:
sudo grubby --set-default /boot/vmlinuz-5.14.0-611.el9.x86_64

# Remove problematic kernel
sudo dnf remove kernel-5.14.0-611.16.1.el9_7
```

### Keeping Multiple Kernels

**Configure Kernel Retention:**

```bash
# Edit DNF config
sudo vi /etc/dnf/dnf.conf

# Set number of old kernels to keep
installonly_limit=3

# This keeps:
# - Current running kernel
# - Previous kernel (rollback option)
# - One more older kernel

# Manually clean old kernels
sudo dnf remove --oldinstallonly

# List installed kernels
rpm -q kernel | sort -V

# Remove specific old kernel
sudo dnf remove kernel-5.14.0-503.el9
```

## 31.5 Emergency Security Updates

### Critical Vulnerability Response

**Emergency Update Procedure:**

```bash
#!/bin/bash
#
# Emergency security update procedure
# Use when critical CVE requires immediate patching
#

set -euo pipefail

CVE_ID="$1"
AFFECTED_PACKAGE="$2"

echo "=== Emergency Security Update ==="
echo "CVE: ${CVE_ID}"
echo "Package: ${AFFECTED_PACKAGE}"
echo "Time: $(date)"

# 1. Verify CVE affects our systems
echo "1. Checking if system is affected..."
sudo dnf list installed "${AFFECTED_PACKAGE}" || {
    echo "Package not installed - system not affected"
    exit 0
}

# 2. Check for available update
echo "2. Checking for security update..."
sudo dnf updateinfo list security | grep "${AFFECTED_PACKAGE}" || {
    echo "No security update available yet"
    exit 1
}

# 3. Create backup
echo "3. Creating emergency backup..."
/usr/local/bin/backup-system.sh $(hostname)

# 4. Download update
echo "4. Downloading update..."
sudo dnf upgrade --downloadonly "${AFFECTED_PACKAGE}"

# 5. Apply update
echo "5. Applying security update..."
sudo dnf upgrade -y "${AFFECTED_PACKAGE}"

# 6. Restart affected services
echo "6. Restarting affected services..."
sudo needs-restarting -s | while read service; do
    echo "   Restarting ${service}..."
    sudo systemctl restart "${service}"
done

# 7. Verify update applied
echo "7. Verification:"
rpm -q "${AFFECTED_PACKAGE}"

# 8. Log emergency update
echo "${CVE_ID}: $(rpm -q "${AFFECTED_PACKAGE}") - $(date)" >> /var/log/emergency-updates.log

# 9. Notify
echo "Emergency security update complete" | \
    mail -s "[EMERGENCY UPDATE] ${CVE_ID} - ${AFFECTED_PACKAGE}" admin@cyberinabox.net

echo "=== Emergency update complete ==="
```

### Zero-Day Response

**Immediate Actions:**

```bash
# 1. Assess exposure
sudo dnf list installed <vulnerable-package>

# 2. Check if exploit is public
# Review:
# - NIST NVD: https://nvd.nist.gov/
# - Red Hat CVE: https://access.redhat.com/security/cve/
# - Vendor advisory

# 3. If critical and no patch available:

# Option A: Disable vulnerable service
sudo systemctl stop <service>
sudo systemctl disable <service>

# Option B: Apply workaround (if available)
# Follow vendor advisory for mitigation

# Option C: Block exploitation vector
# Example: Block network access to vulnerable service
sudo firewall-cmd --add-rich-rule='rule service name="<service>" reject'
sudo firewall-cmd --runtime-to-permanent

# 4. Monitor for patch availability
sudo dnf check-update <package>

# 5. Apply patch immediately when available
sudo dnf upgrade <package>
sudo systemctl start <service>
sudo firewall-cmd --reload

# 6. Document response
cat >> /var/log/zero-day-response.log <<EOF
Date: $(date)
CVE: CVE-YYYY-XXXXX
Package: <package>
Actions: [What was done]
Patch Applied: [Date/Time]
Services Restored: [Date/Time]
EOF
```

## 31.6 Update Monitoring and Reporting

### Update Status Dashboard

**Generate Update Report:**

```bash
#!/bin/bash
#
# Generate system update status report
#

REPORT_FILE="/tmp/update-status-$(date +%Y%m%d).txt"

{
    echo "=========================================="
    echo "System Update Status Report"
    echo "Generated: $(date)"
    echo "=========================================="
    echo ""

    # Check each system
    for system in dc1 dms graylog proxy monitoring wazuh; do
        echo "=== ${system}.cyberinabox.net ==="

        ssh admin@${system}.cyberinabox.net "
            echo 'Current Kernel:' \$(uname -r)
            echo 'Available Security Updates:'
            sudo dnf updateinfo list security | wc -l
            echo 'Reboot Required:'
            sudo needs-restarting -r && echo 'No' || echo 'Yes'
            echo 'Last Update:'
            sudo dnf history | grep -m 1 'upgrade' | awk '{print \$3, \$4, \$5}'
            echo ''
        "
    done

    echo "=========================================="
    echo "Summary"
    echo "=========================================="

    # Total pending updates
    TOTAL_UPDATES=0
    for system in dc1 dms graylog proxy monitoring wazuh; do
        COUNT=$(ssh admin@${system}.cyberinabox.net "sudo dnf check-update | grep -v 'Last metadata' | wc -l")
        TOTAL_UPDATES=$((TOTAL_UPDATES + COUNT))
    done

    echo "Total pending updates across all systems: ${TOTAL_UPDATES}"

    # Systems needing reboot
    echo ""
    echo "Systems requiring reboot:"
    for system in dc1 dms graylog proxy monitoring wazuh; do
        ssh admin@${system}.cyberinabox.net "sudo needs-restarting -r" || echo "  - ${system}.cyberinabox.net"
    done

} > "${REPORT_FILE}"

# Email report
cat "${REPORT_FILE}" | mail -s "Weekly Update Status Report" admin@cyberinabox.net

echo "Report generated: ${REPORT_FILE}"
cat "${REPORT_FILE}"
```

**Schedule Weekly Report:**

```bash
# Add to cron
sudo crontab -e

# Run every Monday at 8 AM
0 8 * * 1 /usr/local/bin/generate-update-report.sh
```

### Update Notifications

**Configure Update Alerts:**

```bash
# Install yum-cron (if not using dnf-automatic)
sudo dnf install dnf-automatic

# Configure email notifications
sudo vi /etc/dnf/automatic.conf

[emitters]
emit_via = email

[email]
email_to = admin@cyberinabox.net
email_from = updates@cyberinabox.net

# Enable service
sudo systemctl enable --now dnf-automatic-notifyonly.timer

# This will email when updates are available (but not install)
```

---

**Security Updates Quick Reference:**

**Check for Updates:**
```bash
# Security updates only
sudo dnf updateinfo list security

# All updates
sudo dnf check-update

# Specific package
sudo dnf list updates kernel
```

**Apply Updates:**
```bash
# Security only (automatic weekly)
sudo dnf upgrade --security

# All updates (manual/monthly)
sudo dnf upgrade

# Specific package
sudo dnf upgrade package-name

# Emergency critical update
sudo dnf upgrade --advisory=RHSA-2025:XXXX
```

**Check Reboot Requirement:**
```bash
# Check if reboot needed
sudo needs-restarting -r

# List services needing restart
sudo needs-restarting -s

# Restart services without reboot
sudo systemctl restart $(sudo needs-restarting -s)
```

**Kernel Updates:**
```bash
# Install new kernel
sudo dnf upgrade kernel

# Check current kernel
uname -r

# Schedule reboot
sudo shutdown -r +15 "Kernel update reboot in 15 min"

# Boot to previous kernel if issues
# (Select in GRUB menu at boot)
```

**Emergency Response:**
```bash
# Critical CVE response
/usr/local/bin/emergency-update.sh CVE-2025-XXXXX package-name

# Zero-day mitigation
sudo systemctl stop vulnerable-service
sudo firewall-cmd --add-rich-rule='rule service name="service" reject'
```

**Update Monitoring:**
```bash
# Weekly report
/usr/local/bin/generate-update-report.sh

# Daily check
sudo systemctl status dnf-automatic.timer

# View update history
sudo dnf history
```

**Rollback:**
```bash
# View history
sudo dnf history

# Undo last update
sudo dnf history undo last

# Downgrade specific package
sudo dnf downgrade package-name
```

---

**Related Chapters:**
- Chapter 4: Security Baseline
- Chapter 28: System Monitoring Configuration
- Chapter 29: Backup Procedures
- Chapter 32: Emergency Procedures
- Appendix C: Command Reference
- Appendix D: Troubleshooting Guide

**For Help:**
- Red Hat Advisories: https://access.redhat.com/security/security-updates/
- NIST NVD: https://nvd.nist.gov/
- CVE Database: https://cve.mitre.org/
- Administrator: dshannon@cyberinabox.net
