#!/bin/bash
#
# Module 20: Install and Configure Samba
# File sharing with Kerberos authentication
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [20-SAMBA] $*"
}

log "Installing Samba file sharing..."

# Install Samba packages
log "Installing Samba packages..."
dnf install -y samba samba-client samba-common samba-winbind-clients cifs-utils

log "✓ Samba packages installed"

# Configure firewall
log "Configuring firewall..."
firewall-cmd --permanent --add-service=samba
firewall-cmd --permanent --add-service=samba-client
firewall-cmd --reload

log "✓ Firewall configured"

# Create Samba configuration
log "Creating Samba configuration..."

# Backup original config
[[ -f /etc/samba/smb.conf ]] && cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Create new Samba config integrated with FreeIPA
cat > /etc/samba/smb.conf <<EOF
# CyberHygiene Samba Configuration
# Generated: $(date)
# Domain: ${DOMAIN}

[global]
    # Identification
    workgroup = $(echo "${REALM}" | cut -d'.' -f1)
    realm = ${REALM}
    netbios name = DMS
    server string = CyberHygiene File Server

    # Security and Authentication
    security = ads
    kerberos method = secrets and keytab
    dedicated keytab file = /etc/krb5.keytab
    create krb5 conf = no

    # ID Mapping (use FreeIPA)
    idmap config * : backend = autorid
    idmap config * : range = 10000-9999999

    # File and Directory Permissions
    map acl inherit = yes
    store dos attributes = yes
    vfs objects = acl_xattr
    inherit permissions = yes

    # Performance
    socket options = TCP_NODELAY IPTOS_LOWDELAY
    read raw = yes
    write raw = yes
    max xmit = 65535
    dead time = 15

    # Logging
    log level = 1
    log file = /var/log/samba/%m.log
    max log size = 50

    # Misc
    dns proxy = no
    wins support = no

[homes]
    comment = User Home Directories
    browseable = no
    writable = yes
    create mask = 0700
    directory mask = 0700
    valid users = %S

[shared]
    comment = Shared Files
    path = /datastore/shared
    browseable = yes
    writable = yes
    create mask = 0660
    directory mask = 0770
    valid users = @admins

[documents]
    comment = Company Documents
    path = /datastore/documents
    browseable = yes
    writable = yes
    create mask = 0664
    directory mask = 0775
    force group = users
EOF

log "✓ Samba configuration created"

# Create shared directories
log "Creating shared directories..."
mkdir -p /datastore/shared /datastore/documents
chmod 2770 /datastore/shared
chmod 2775 /datastore/documents

log "✓ Shared directories created"

# Join FreeIPA domain
log "Joining Samba to FreeIPA domain..."

if ! echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
    log "ERROR: Failed to authenticate to FreeIPA"
    exit 1
fi

# Create service principal for Samba
ipa service-add cifs/"${DC1_HOSTNAME}" 2>/dev/null || log "Service already exists"

# Get keytab
ipa-getkeytab -s "${DC1_HOSTNAME}" -p cifs/"${DC1_HOSTNAME}" -k /etc/krb5.keytab || true

kdestroy

log "✓ Samba joined to FreeIPA domain"

# Test configuration
log "Testing Samba configuration..."
testparm -s 2>&1 | grep -E "Loaded services|workgroup|realm" || true

# Enable and start Samba
log "Starting Samba services..."
systemctl enable smb nmb winbind
systemctl start smb nmb winbind

sleep 2

if systemctl is-active --quiet smb; then
    log "✓ Samba service is running"
else
    log "ERROR: Samba service failed to start"
    systemctl status smb
    exit 1
fi

echo ""
log "=========================================="
log "Samba Installation Summary"
log "=========================================="
log "✓ Samba installed and configured"
log "✓ Integrated with FreeIPA domain"
log "✓ Shares created:"
log "  - //$(hostname -f)/homes (user home directories)"
log "  - //$(hostname -f)/shared (shared files)"
log "  - //$(hostname -f)/documents (company documents)"
log ""
log "Access from Windows:"
log "  \\\\$(hostname -f)\\shared"
log ""

exit 0
