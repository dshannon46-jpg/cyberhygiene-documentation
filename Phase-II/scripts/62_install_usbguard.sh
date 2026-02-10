#!/bin/bash
#
# Module 62: Install and Configure USBGuard
# USB device access control for data loss prevention
# NIST 800-171 Control: 3.1.21, 3.8.7
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [62-USBGUARD] $*"
}

log "Installing USBGuard (USB device access control)..."

# Step 1: Install USBGuard
log "Step 1: Installing USBGuard packages..."
dnf install -y usbguard usbguard-selinux

log "✓ USBGuard packages installed"

# Step 2: Generate initial policy from currently connected devices
log "Step 2: Generating initial device policy..."

# Generate policy for currently connected devices (allow them)
usbguard generate-policy > /etc/usbguard/rules.conf

log "✓ Initial policy generated from connected devices"

# Step 3: Configure USBGuard daemon
log "Step 3: Configuring USBGuard daemon..."

cat > /etc/usbguard/usbguard-daemon.conf <<'EOF'
# CyberHygiene USBGuard Configuration
# NIST 800-171 USB Device Access Control

# Rule file location
RuleFile=/etc/usbguard/rules.conf

# Implicit policy target for devices not matching any rule
# Options: allow, block, reject
ImplicitPolicyTarget=block

# How to handle devices present when daemon starts
# Options: allow, block, reject, keep, apply-policy
PresentDevicePolicy=apply-policy

# How to handle devices inserted while daemon is not running
# Options: allow, block, reject, keep, apply-policy
InsertedDevicePolicy=apply-policy

# Write changes to RuleFile
RestoreControllerDeviceState=false

# Device manager backend
DeviceManagerBackend=uevent

# IPC access control
IPCAllowedUsers=root
IPCAllowedGroups=wheel

# Logging settings
# Options: Audit, AuditClean, WithContentID
DeviceRulesWithPort=false
AuditBackend=FileAudit
AuditFilePath=/var/log/usbguard/usbguard-audit.log

# Hide PII (Personally Identifiable Information) in logs
HidePII=false
EOF

log "✓ USBGuard daemon configured"

# Step 4: Create audit log directory
log "Step 4: Setting up audit logging..."
mkdir -p /var/log/usbguard
chown root:root /var/log/usbguard
chmod 700 /var/log/usbguard

log "✓ Audit logging configured"

# Step 5: Add common keyboard and mouse rules
log "Step 5: Adding default rules for standard input devices..."

# Add rules for keyboards and mice (generally safe to allow)
cat >> /etc/usbguard/rules.conf <<'EOF'

# CyberHygiene Default Rules
# Allow standard HID devices (keyboards, mice)
allow with-interface one-of { 03:00:01 03:01:01 03:01:02 } if !allowed

# Block mass storage by default (can be unlocked by admin)
# block with-interface equals { 08:*:* }

# Allow authenticated users to temporarily authorize devices
# (requires IPCAllowedUsers/Groups configuration)
EOF

log "✓ Default rules added"

# Step 6: Enable and start USBGuard
log "Step 6: Enabling and starting USBGuard..."

systemctl daemon-reload
systemctl enable usbguard
systemctl start usbguard

sleep 2

if systemctl is-active --quiet usbguard; then
    log "✓ USBGuard is running"
else
    log "ERROR: USBGuard failed to start"
    systemctl status usbguard
    exit 1
fi

# Step 7: Display current policy
log "Step 7: Verifying device policy..."
echo ""
log "Current allowed devices:"
usbguard list-devices --allowed 2>/dev/null | head -10 || log "  (none or service not ready)"
echo ""

# Summary
echo ""
log "=========================================="
log "USBGuard Installation Summary"
log "=========================================="
log "✓ USBGuard installed and configured"
log "✓ Device access control enabled"
log "✓ Currently connected devices allowed"
log ""
log "Configuration: /etc/usbguard/usbguard-daemon.conf"
log "Rules: /etc/usbguard/rules.conf"
log "Audit log: /var/log/usbguard/usbguard-audit.log"
log ""
log "Management commands:"
log "  usbguard list-devices              # List all devices"
log "  usbguard list-devices --blocked    # List blocked devices"
log "  usbguard allow-device <id>         # Allow specific device"
log "  usbguard block-device <id>         # Block specific device"
log "  usbguard generate-policy           # Generate policy from connected"
log ""
log "IMPORTANT: New USB devices will be BLOCKED by default!"
log "Administrators can temporarily allow devices as needed."
log ""

exit 0
