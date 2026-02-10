#!/bin/bash
#
# Module 01: Generate Installation Variables
# Parse installation_info.md and create install_vars.sh
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_FILE="${SCRIPT_DIR}/installation_info.md"
OUTPUT_FILE="${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [01-VARS] $*"
}

log "Generating installation variables from ${SOURCE_FILE}..."

# Check if source file exists
if [[ ! -f "${SOURCE_FILE}" ]]; then
    log "ERROR: Installation info file not found: ${SOURCE_FILE}"
    exit 1
fi

# Extract value from markdown (handles various formats)
extract_value() {
    local label="$1"
    local default="${2:-}"

    # Try different patterns to extract the value
    local value

    # Pattern 1: "Label:** value" or "Label: value"
    value=$(grep -E "^[[:space:]]*[-*]*[[:space:]]*\*\*${label}[:\*]*.*:?\*\*[[:space:]]*" "${SOURCE_FILE}" | \
            sed -E "s/^[[:space:]]*[-*]*[[:space:]]*\*\*${label}[:\*]*.*:?\*\*[[:space:]]*//g" | \
            sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
            tr -d '_' | \
            head -1)

    # If empty, try another pattern: "- Label: value"
    if [[ -z "${value}" ]]; then
        value=$(grep -i "^[[:space:]]*-[[:space:]]*${label}:" "${SOURCE_FILE}" | \
                sed "s/^[[:space:]]*-[[:space:]]*${label}://i" | \
                sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
                tr -d '_' | \
                head -1)
    fi

    # If still empty, use default
    if [[ -z "${value}" ]]; then
        value="${default}"
    fi

    echo "${value}"
}

# Generate secure random password
generate_password() {
    openssl rand -base64 32 | tr -d '/+=' | cut -c1-32
}

log "Extracting values from installation form..."

# Business Information
BUSINESS_NAME=$(extract_value "Business Name \(Legal\)")
BUSINESS_DBA=$(extract_value "Business Name \(DBA\)" "${BUSINESS_NAME}")
ADDRESS=$(extract_value "Physical Address")
CITY=$(extract_value "City")
STATE=$(extract_value "State")
ZIP=$(extract_value "ZIP")
DUNS=$(extract_value "DUNS Number")
CAGE=$(extract_value "CAGE Code")

# Domain Configuration
DOMAIN=$(extract_value "Fully Qualified Domain Name \(FQDN\)")
REALM=$(echo "${DOMAIN}" | tr '[:lower:]' '[:upper:]')  # Kerberos realm is uppercase domain

# Network Configuration
EXTERNAL_IP=$(extract_value "Static IP Address \(External\)")
SUBNET=$(extract_value "Internal Network Subnet" "192.168.1")
GATEWAY=$(extract_value "Gateway/Router IP" "${SUBNET}.1")

# System Configuration
TIMEZONE=$(extract_value "Time Zone" "America/Denver")
ADMIN_EMAIL=$(extract_value "Admin Email" "admin@${DOMAIN}")

# Generate secure passwords
log "Generating secure passwords..."
DS_PASSWORD=$(generate_password)
ADMIN_PASSWORD=$(generate_password)
GRUB_PASSWORD=$(generate_password)
BACKUP_KEY=$(openssl rand -base64 32)

# Calculate server IPs based on subnet
DC1_IP="${SUBNET}.10"
DMS_IP="${SUBNET}.20"
GRAYLOG_IP="${SUBNET}.30"
PROXY_IP="${SUBNET}.40"
MONITORING_IP="${SUBNET}.50"
WAZUH_IP="${SUBNET}.60"

# Get installer information
INSTALLER_NAME=$(whoami)
INSTALL_DATE=$(date +%Y-%m-%d)

log "Creating variables file: ${OUTPUT_FILE}..."

# Create the install_vars.sh file
cat > "${OUTPUT_FILE}" <<EOF
#!/bin/bash
#
# CyberHygiene Phase II Installation Variables
# Auto-generated from installation_info.md
# Generated: $(date)
# Installer: ${INSTALLER_NAME}
#
# IMPORTANT: This file contains sensitive information. Protect accordingly.
#

# ==========================================
# BUSINESS INFORMATION
# ==========================================
export BUSINESS_NAME="${BUSINESS_NAME}"
export BUSINESS_DBA="${BUSINESS_DBA}"
export ADDRESS="${ADDRESS}"
export CITY="${CITY}"
export STATE="${STATE}"
export ZIP="${ZIP}"
export DUNS="${DUNS}"
export CAGE="${CAGE}"

# ==========================================
# DOMAIN CONFIGURATION
# ==========================================
export DOMAIN="${DOMAIN}"
export REALM="${REALM}"

# ==========================================
# NETWORK CONFIGURATION
# ==========================================
export SUBNET="${SUBNET}"
export GATEWAY="${GATEWAY}"
export EXTERNAL_IP="${EXTERNAL_IP}"
export DNS_FORWARDERS="8.8.8.8,8.8.4.4"

# ==========================================
# SERVER IP ASSIGNMENTS
# ==========================================
export DC1_IP="${DC1_IP}"
export DMS_IP="${DMS_IP}"
export GRAYLOG_IP="${GRAYLOG_IP}"
export PROXY_IP="${PROXY_IP}"
export MONITORING_IP="${MONITORING_IP}"
export WAZUH_IP="${WAZUH_IP}"

# ==========================================
# SYSTEM CONFIGURATION
# ==========================================
export TIMEZONE="${TIMEZONE}"
export ADMIN_EMAIL="${ADMIN_EMAIL}"

# ==========================================
# INSTALLATION SECRETS
# ==========================================
# These passwords are automatically generated
export DS_PASSWORD="${DS_PASSWORD}"
export ADMIN_PASSWORD="${ADMIN_PASSWORD}"
export GRUB_PASSWORD="${GRUB_PASSWORD}"
export BACKUP_KEY="${BACKUP_KEY}"

# ==========================================
# SSL CERTIFICATE PATHS
# ==========================================
export SSL_CERT_DIR="/root/ssl-certificates"
export SSL_CERT_PATH="\${SSL_CERT_DIR}/wildcard.crt"
export SSL_KEY_PATH="\${SSL_CERT_DIR}/wildcard.key"
export SSL_CHAIN_PATH="\${SSL_CERT_DIR}/ca-bundle.crt"

# ==========================================
# INSTALLATION METADATA
# ==========================================
export INSTALL_DATE="${INSTALL_DATE}"
export INSTALLER_NAME="${INSTALLER_NAME}"
export SCRIPT_DIR="${SCRIPT_DIR}"

# ==========================================
# DERIVED VALUES
# ==========================================
# Hostnames
export DC1_HOSTNAME="dc1.\${DOMAIN}"
export DMS_HOSTNAME="dms.\${DOMAIN}"
export GRAYLOG_HOSTNAME="graylog.\${DOMAIN}"
export PROXY_HOSTNAME="proxy.\${DOMAIN}"
export MONITORING_HOSTNAME="monitoring.\${DOMAIN}"
export WAZUH_HOSTNAME="wazuh.\${DOMAIN}"

# URLs
export CPM_URL="https://cpm.\${DOMAIN}"
export GRAFANA_URL="https://grafana.\${DOMAIN}"
export GRAYLOG_URL="https://graylog.\${DOMAIN}"
export WAZUH_URL="https://wazuh.\${DOMAIN}"
EOF

chmod 600 "${OUTPUT_FILE}"

log "✓ Variables file created: ${OUTPUT_FILE}"

# Source the file to validate
log "Validating variables file..."
# shellcheck disable=SC1090
source "${OUTPUT_FILE}"

# Validate required variables
REQUIRED_VARS=(
    "DOMAIN"
    "REALM"
    "BUSINESS_NAME"
    "SUBNET"
    "DS_PASSWORD"
    "ADMIN_PASSWORD"
)

VALIDATION_FAILED=false
for var in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        log "ERROR: Required variable ${var} is not set or empty"
        VALIDATION_FAILED=true
    fi
done

if [[ "${VALIDATION_FAILED}" == "true" ]]; then
    log "ERROR: Variable validation failed"
    log "ERROR: Check that installation_info.md is completely filled out"
    exit 1
fi

# Create a credentials file for the admin
CREDS_FILE="${SCRIPT_DIR}/CREDENTIALS_${INSTALL_DATE}.txt"
cat > "${CREDS_FILE}" <<EOF
========================================
CyberHygiene Installation Credentials
========================================
Generated: $(date)
Domain: ${DOMAIN}
Business: ${BUSINESS_NAME}

========================================
CRITICAL PASSWORDS - STORE SECURELY
========================================

FreeIPA Directory Manager Password:
${DS_PASSWORD}

FreeIPA Admin Password:
${ADMIN_PASSWORD}

GRUB Bootloader Password:
${GRUB_PASSWORD}

Backup Encryption Key:
${BACKUP_KEY}

========================================
SYSTEM INFORMATION
========================================

Domain: ${DOMAIN}
Kerberos Realm: ${REALM}
Network Subnet: ${SUBNET}.0/24
Gateway: ${GATEWAY}

Server IP Addresses:
- dc1.${DOMAIN}:        ${DC1_IP}
- dms.${DOMAIN}:        ${DMS_IP}
- graylog.${DOMAIN}:    ${GRAYLOG_IP}
- proxy.${DOMAIN}:      ${PROXY_IP}
- monitoring.${DOMAIN}: ${MONITORING_IP}
- wazuh.${DOMAIN}:      ${WAZUH_IP}

========================================
IMPORTANT NOTES
========================================

1. Store this file in a secure location
2. Do not commit to version control
3. Consider printing and storing in physical safe
4. Delete this file after securing passwords elsewhere

========================================
EOF

chmod 600 "${CREDS_FILE}"

log "✓ Credentials file created: ${CREDS_FILE}"

# Summary
echo ""
log "=========================================="
log "Variable Generation Summary"
log "=========================================="
log "Domain: ${DOMAIN}"
log "Realm: ${REALM}"
log "Business: ${BUSINESS_NAME}"
log "Subnet: ${SUBNET}.0/24"
log "Timezone: ${TIMEZONE}"
log ""
log "✓ All variables generated successfully"
log "✓ Passwords generated and stored"
log "✓ Ready for service installation"
log ""
log "IMPORTANT: Secure the credentials file:"
log "  ${CREDS_FILE}"
log ""

exit 0
