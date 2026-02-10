#!/bin/bash
#
# Module 10: Install and Configure FreeIPA
# Domain Controller with DNS, Kerberos, CA, LDAP
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
if [[ ! -f "${SCRIPT_DIR}/install_vars.sh" ]]; then
    echo "ERROR: install_vars.sh not found. Run 01_generate_variables.sh first."
    exit 1
fi

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [10-FREEIPA] $*"
}

log "Starting FreeIPA installation..."
log "Domain: ${DOMAIN}"
log "Realm: ${REALM}"
log "Hostname: ${DC1_HOSTNAME}"

# Check if FreeIPA is already installed
if ipa --version &> /dev/null 2>&1; then
    log "FreeIPA is already installed"
    ipa --version
    log "Skipping installation. To reinstall, run: ipa-server-install --uninstall"
    exit 0
fi

# Step 1: Install FreeIPA packages
log "Step 1: Installing FreeIPA packages..."
log "This may take 5-10 minutes..."

# Enable IDM module stream
dnf module enable -y idm:DL1/{dns,client,server,common} 2>&1 | grep -v "^Last metadata"

# Install FreeIPA server with DNS support
dnf install -y ipa-server ipa-server-dns 2>&1 | grep -E "^Installing|^Complete"

log "✓ FreeIPA packages installed"

# Step 2: Verify hostname is correctly set
log "Step 2: Verifying hostname configuration..."
CURRENT_HOSTNAME=$(hostname -f)
if [[ "${CURRENT_HOSTNAME}" != "${DC1_HOSTNAME}" ]]; then
    log "Setting hostname to ${DC1_HOSTNAME}..."
    hostnamectl set-hostname "${DC1_HOSTNAME}"
    log "✓ Hostname set"
fi

# Verify hostname resolves
if ! getent hosts "${DC1_HOSTNAME}" | grep -q "${DC1_IP}"; then
    log "Adding hostname to /etc/hosts..."
    echo "${DC1_IP}    ${DC1_HOSTNAME} dc1" >> /etc/hosts
    log "✓ Hostname added to /etc/hosts"
fi

log "✓ Hostname configured: $(hostname -f)"

# Step 3: Configure firewall
log "Step 3: Configuring firewall for FreeIPA..."

firewall-cmd --permanent --add-service=freeipa-ldap
firewall-cmd --permanent --add-service=freeipa-ldaps
firewall-cmd --permanent --add-service=dns
firewall-cmd --permanent --add-service=ntp
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=kerberos
firewall-cmd --permanent --add-service=kpasswd

# Additional ports
firewall-cmd --permanent --add-port=88/tcp    # Kerberos
firewall-cmd --permanent --add-port=88/udp    # Kerberos
firewall-cmd --permanent --add-port=464/tcp   # Kpasswd
firewall-cmd --permanent --add-port=464/udp   # Kpasswd
firewall-cmd --permanent --add-port=389/tcp   # LDAP
firewall-cmd --permanent --add-port=636/tcp   # LDAPS
firewall-cmd --permanent --add-port=123/udp   # NTP

firewall-cmd --reload

log "✓ Firewall configured"

# Step 4: Prepare installation
log "Step 4: Preparing FreeIPA installation..."

# Create temporary file for passwords
DS_PASS_FILE=$(mktemp)
ADMIN_PASS_FILE=$(mktemp)
echo "${DS_PASSWORD}" > "${DS_PASS_FILE}"
echo "${ADMIN_PASSWORD}" > "${ADMIN_PASS_FILE}"

# Set proper permissions
chmod 600 "${DS_PASS_FILE}" "${ADMIN_PASS_FILE}"

log "✓ Installation preparation complete"

# Step 5: Run FreeIPA installation
log "Step 5: Running FreeIPA server installation..."
log "This will take 10-20 minutes. Please be patient..."
log ""
log "Configuration:"
log "  Domain: ${DOMAIN}"
log "  Realm: ${REALM}"
log "  Hostname: ${DC1_HOSTNAME}"
log "  DNS Forwarders: ${DNS_FORWARDERS}"
log ""

# Run installation
ipa-server-install \
    --domain="${DOMAIN}" \
    --realm="${REALM}" \
    --hostname="${DC1_HOSTNAME}" \
    --ds-password="${DS_PASSWORD}" \
    --admin-password="${ADMIN_PASSWORD}" \
    --mkhomedir \
    --setup-dns \
    --forwarder=$(echo "${DNS_FORWARDERS}" | cut -d',' -f1) \
    --forwarder=$(echo "${DNS_FORWARDERS}" | cut -d',' -f2) \
    --auto-reverse \
    --no-ntp \
    --no-dnssec-validation \
    --unattended

INSTALL_STATUS=$?

# Clean up password files
rm -f "${DS_PASS_FILE}" "${ADMIN_PASS_FILE}"

if [[ ${INSTALL_STATUS} -ne 0 ]]; then
    log "ERROR: FreeIPA installation failed with status ${INSTALL_STATUS}"
    log "Check /var/log/ipaserver-install.log for details"
    exit 1
fi

log "✓ FreeIPA installation completed successfully"

# Step 6: Verify installation
log "Step 6: Verifying FreeIPA installation..."

# Test Kerberos authentication
log "Testing Kerberos authentication..."
if echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
    log "✓ Kerberos authentication successful"
    klist | grep -i "default principal"
    kdestroy
else
    log "ERROR: Kerberos authentication failed"
    exit 1
fi

# Test IPA command
log "Testing IPA command..."
if echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
    IPA_VERSION=$(ipa --version)
    log "✓ IPA command works: ${IPA_VERSION}"

    # Show some basic info
    log "FreeIPA server status:"
    ipactl status || true

    kdestroy
fi

# Step 7: Configure DNS
log "Step 7: Configuring DNS settings..."

if echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
    # Set DNS global forwarders
    log "Setting DNS forwarders..."
    ipa dnsconfig-mod --forwarder=$(echo "${DNS_FORWARDERS}" | cut -d',' -f1) \
                      --forwarder=$(echo "${DNS_FORWARDERS}" | cut -d',' -f2) \
                      --forward-policy=first || true

    log "✓ DNS forwarders configured"

    kdestroy
fi

# Step 8: Create initial DNS records for other servers
log "Step 8: Creating DNS records for planned servers..."

if echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
    # Create A records for each server
    SERVERS=(
        "dms:${DMS_IP}"
        "graylog:${GRAYLOG_IP}"
        "proxy:${PROXY_IP}"
        "monitoring:${MONITORING_IP}"
        "wazuh:${WAZUH_IP}"
    )

    for server_entry in "${SERVERS[@]}"; do
        server_name=$(echo "${server_entry}" | cut -d':' -f1)
        server_ip=$(echo "${server_entry}" | cut -d':' -f2)

        log "Creating DNS record: ${server_name}.${DOMAIN} -> ${server_ip}"
        ipa dnsrecord-add "${DOMAIN}." "${server_name}" --a-ip-address="${server_ip}" 2>/dev/null || \
            log "  (Record may already exist)"
    done

    log "✓ DNS records created"

    kdestroy
fi

# Step 9: Configure sudoers
log "Step 9: Configuring sudo rules..."

if echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
    # Create admin sudo rule
    ipa sudorule-add --desc="Full sudo access for admins" admin_sudo 2>/dev/null || true
    ipa sudorule-mod admin_sudo --cmdcat=all 2>/dev/null || true
    ipa sudorule-mod admin_sudo --hostcat=all 2>/dev/null || true
    ipa sudorule-add-user admin_sudo --groups=admins 2>/dev/null || true

    log "✓ Sudo rules configured"

    kdestroy
fi

# Step 10: Configure password policies
log "Step 10: Configuring password policies..."

if echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
    # Set global password policy (NIST 800-171 compliant)
    ipa pwpolicy-mod --minlength=14 \
                     --minclasses=3 \
                     --maxlife=90 \
                     --minlife=1 \
                     --history=24 \
                     --maxfail=3 \
                     --failinterval=900 \
                     --lockouttime=1800 || true

    log "✓ Password policy configured"

    kdestroy
fi

# Step 11: Save installation details
log "Step 11: Saving installation details..."

INSTALL_LOG="${SCRIPT_DIR}/freeipa_installation_${INSTALL_DATE}.log"
cat > "${INSTALL_LOG}" <<EOF
========================================
FreeIPA Installation Complete
========================================
Date: $(date)
Domain: ${DOMAIN}
Realm: ${REALM}
Hostname: ${DC1_HOSTNAME}
IP Address: ${DC1_IP}

========================================
CREDENTIALS
========================================
Directory Manager Password: [See CREDENTIALS file]
Admin Password: [See CREDENTIALS file]

========================================
ACCESS INFORMATION
========================================
Web UI: https://${DC1_HOSTNAME}
Login: admin
Password: [See CREDENTIALS file]

Kerberos Login:
  kinit admin
  Password: [See CREDENTIALS file]

========================================
DNS CONFIGURATION
========================================
Primary DNS: ${DC1_IP}
Domain: ${DOMAIN}
Forwarders: ${DNS_FORWARDERS}

========================================
NEXT STEPS
========================================
1. Access web UI to verify installation
2. Create additional user accounts
3. Enroll client systems
4. Configure additional services (Samba, etc.)

========================================
VERIFICATION COMMANDS
========================================
# Check service status
ipactl status

# Test authentication
kinit admin

# View server configuration
ipa config-show

# View DNS configuration
ipa dnsconfig-show

========================================
EOF

chmod 600 "${INSTALL_LOG}"

log "✓ Installation log saved: ${INSTALL_LOG}"

# Summary
echo ""
log "=========================================="
log "FreeIPA Installation Summary"
log "=========================================="
log "✓ FreeIPA server installed successfully"
log ""
log "Domain: ${DOMAIN}"
log "Realm: ${REALM}"
log "Server: ${DC1_HOSTNAME} (${DC1_IP})"
log ""
log "Web Interface: https://${DC1_HOSTNAME}"
log "Username: admin"
log "Password: [See ${SCRIPT_DIR}/CREDENTIALS_${INSTALL_DATE}.txt]"
log ""
log "Services started:"
ipactl status | grep -E "Directory Service|KDC|Apache|DNS" || true
log ""
log "✓ Domain Controller is ready"
log ""

exit 0
