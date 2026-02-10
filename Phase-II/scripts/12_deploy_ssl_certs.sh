#!/bin/bash
#
# Module 12: Deploy SSL Certificates
# Install wildcard SSL certificate for domain
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [12-SSL] $*"
}

log "Deploying SSL certificates..."

# Create SSL certificate directory
mkdir -p "${SSL_CERT_DIR}"
chmod 700 "${SSL_CERT_DIR}"

# Check if certificates already exist
if [[ -f "${SSL_CERT_PATH}" ]] && [[ -f "${SSL_KEY_PATH}" ]]; then
    log "SSL certificates already exist in ${SSL_CERT_DIR}"
    log "Certificate: ${SSL_CERT_PATH}"
    log "Key: ${SSL_KEY_PATH}"

    # Verify certificate
    log "Verifying existing certificate..."
    openssl x509 -in "${SSL_CERT_PATH}" -noout -text | grep -E "Subject:|Issuer:|Not After"

    log "✓ Using existing certificates"
    exit 0
fi

# Check if certificates were provided by customer
CUSTOMER_CERT_DIR="${SCRIPT_DIR}/customer_ssl_certs"
if [[ -d "${CUSTOMER_CERT_DIR}" ]]; then
    log "Found customer SSL certificates directory"

    # Look for certificate files
    if [[ -f "${CUSTOMER_CERT_DIR}/wildcard.crt" ]] || [[ -f "${CUSTOMER_CERT_DIR}/cert.crt" ]]; then
        log "Copying customer SSL certificates..."

        cp "${CUSTOMER_CERT_DIR}"/*.crt "${SSL_CERT_DIR}/" 2>/dev/null || true
        cp "${CUSTOMER_CERT_DIR}"/*.key "${SSL_CERT_DIR}/" 2>/dev/null || true
        cp "${CUSTOMER_CERT_DIR}"/*.pem "${SSL_CERT_DIR}/" 2>/dev/null || true

        # Set proper permissions
        chmod 600 "${SSL_CERT_DIR}"/*.key 2>/dev/null || true
        chmod 644 "${SSL_CERT_DIR}"/*.crt 2>/dev/null || true
        chmod 644 "${SSL_CERT_DIR}"/*.pem 2>/dev/null || true

        log "✓ Customer certificates copied"
    fi
fi

# If still no certificates, offer to use FreeIPA CA
if [[ ! -f "${SSL_CERT_PATH}" ]]; then
    log "No SSL certificates found. Options:"
    log "1. Use FreeIPA internal CA (self-signed, suitable for internal use)"
    log "2. Use Let's Encrypt (requires internet and domain DNS configured)"
    log "3. Provide commercial certificate manually"
    echo ""

    if [[ -t 0 ]]; then
        read -p "Select option (1-3): " -n 1 -r CERT_OPTION
        echo ""
    else
        CERT_OPTION="1"  # Default to FreeIPA CA in non-interactive mode
    fi

    case "${CERT_OPTION}" in
        1)
            log "Using FreeIPA internal CA..."

            # Authenticate to FreeIPA
            if ! echo "${ADMIN_PASSWORD}" | kinit admin 2>/dev/null; then
                log "ERROR: Failed to authenticate to FreeIPA"
                exit 1
            fi

            # Request certificate for wildcard
            log "Requesting wildcard certificate from FreeIPA CA..."
            ipa-getcert request \
                -K "HTTP/${DC1_HOSTNAME}" \
                -D "*.${DOMAIN}" \
                -f "${SSL_CERT_PATH}" \
                -k "${SSL_KEY_PATH}" \
                -w || true

            # Wait for certificate to be issued
            sleep 5

            # If certificate request failed or didn't complete, create self-signed
            if [[ ! -f "${SSL_CERT_PATH}" ]]; then
                log "Creating self-signed wildcard certificate..."

                openssl req -new -x509 -days 3650 -nodes \
                    -subj "/C=US/ST=${STATE}/L=${CITY}/O=${BUSINESS_NAME}/CN=*.${DOMAIN}" \
                    -keyout "${SSL_KEY_PATH}" \
                    -out "${SSL_CERT_PATH}"

                log "✓ Self-signed certificate created (valid 10 years)"
            fi

            kdestroy
            ;;

        2)
            log "Let's Encrypt selected..."
            log "Installing certbot..."

            dnf install -y certbot python3-certbot-apache

            log "Requesting Let's Encrypt certificate..."
            log "Note: This requires your domain's DNS to point to this server"

            certbot certonly --standalone \
                --preferred-challenges http \
                --domain "*.${DOMAIN}" \
                --domain "${DOMAIN}" \
                --email "${ADMIN_EMAIL}" \
                --agree-tos \
                --non-interactive || {
                    log "ERROR: Let's Encrypt certificate request failed"
                    log "Falling back to self-signed certificate"

                    openssl req -new -x509 -days 365 -nodes \
                        -subj "/C=US/ST=${STATE}/L=${CITY}/O=${BUSINESS_NAME}/CN=*.${DOMAIN}" \
                        -keyout "${SSL_KEY_PATH}" \
                        -out "${SSL_CERT_PATH}"
                }

            # Copy Let's Encrypt certs to our standard location
            if [[ -d "/etc/letsencrypt/live/${DOMAIN}" ]]; then
                cp "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" "${SSL_CERT_PATH}"
                cp "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" "${SSL_KEY_PATH}"
                cp "/etc/letsencrypt/live/${DOMAIN}/chain.pem" "${SSL_CHAIN_PATH}"
            fi
            ;;

        3)
            log "Manual certificate installation selected"
            log ""
            log "Please copy your SSL certificate files to:"
            log "  ${SSL_CERT_DIR}/"
            log ""
            log "Required files:"
            log "  - wildcard.crt (certificate)"
            log "  - wildcard.key (private key)"
            log "  - ca-bundle.crt (certificate chain, if applicable)"
            log ""
            read -p "Press ENTER after copying files..."

            if [[ ! -f "${SSL_CERT_PATH}" ]] || [[ ! -f "${SSL_KEY_PATH}" ]]; then
                log "ERROR: Certificate files not found after manual copy"
                exit 1
            fi
            ;;

        *)
            log "ERROR: Invalid option"
            exit 1
            ;;
    esac
fi

# Verify certificate and key match
log "Verifying certificate and key..."
CERT_MODULUS=$(openssl x509 -noout -modulus -in "${SSL_CERT_PATH}" | openssl md5)
KEY_MODULUS=$(openssl rsa -noout -modulus -in "${SSL_KEY_PATH}" | openssl md5)

if [[ "${CERT_MODULUS}" != "${KEY_MODULUS}" ]]; then
    log "ERROR: Certificate and private key do not match!"
    log "Certificate modulus: ${CERT_MODULUS}"
    log "Key modulus: ${KEY_MODULUS}"
    exit 1
fi

log "✓ Certificate and key match"

# Display certificate information
log "Certificate information:"
openssl x509 -in "${SSL_CERT_PATH}" -noout -subject -issuer -dates

# Set proper permissions
chmod 644 "${SSL_CERT_PATH}"
chmod 600 "${SSL_KEY_PATH}"
[[ -f "${SSL_CHAIN_PATH}" ]] && chmod 644 "${SSL_CHAIN_PATH}"

# Copy to system-wide location
log "Installing certificates to system-wide location..."
cp "${SSL_CERT_PATH}" /etc/pki/tls/certs/
cp "${SSL_KEY_PATH}" /etc/pki/tls/private/
[[ -f "${SSL_CHAIN_PATH}" ]] && cp "${SSL_CHAIN_PATH}" /etc/pki/tls/certs/

log "✓ Certificates installed system-wide"

# Update CA trust (if we have a CA bundle)
if [[ -f "${SSL_CHAIN_PATH}" ]]; then
    log "Updating CA trust..."
    cp "${SSL_CHAIN_PATH}" /etc/pki/ca-trust/source/anchors/
    update-ca-trust
    log "✓ CA trust updated"
fi

echo ""
log "=========================================="
log "SSL Certificate Deployment Summary"
log "=========================================="
log "✓ Certificates deployed to: ${SSL_CERT_DIR}/"
log "✓ Certificate: ${SSL_CERT_PATH}"
log "✓ Private Key: ${SSL_KEY_PATH}"
if [[ -f "${SSL_CHAIN_PATH}" ]]; then
    log "✓ CA Bundle: ${SSL_CHAIN_PATH}"
fi
log "✓ Certificates verified and ready for use"
log ""

exit 0
