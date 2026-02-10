#!/bin/bash
#
# CyberHygiene Phase II - Quick Install Script
# Downloads and launches the installer from GitHub
#
# Usage: curl -sSL https://raw.githubusercontent.com/The-CyberHygiene-Project/Cyberinabox-phaseII/main/quick-install.sh | sudo bash
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub repository
REPO_URL="https://github.com/The-CyberHygiene-Project/Cyberinabox-phaseII.git"
INSTALL_DIR="/opt/cyberhygiene-installer"

# Logging
log() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use sudo)"
    exit 1
fi

# Display banner
echo ""
echo "=========================================="
echo " CyberHygiene Phase II Quick Installer"
echo "=========================================="
echo " NIST SP 800-171 Compliant Security Platform"
echo " Installation Time: ~90 minutes"
echo "=========================================="
echo ""

# Check prerequisites
log "Checking prerequisites..."

# Check OS
if [[ ! -f /etc/redhat-release ]]; then
    error "This installer requires Rocky Linux 9 (or RHEL 9)"
    exit 1
fi

if ! grep -q "Rocky.*9" /etc/redhat-release 2>/dev/null; then
    warn "OS may not be Rocky Linux 9. Proceeding anyway..."
fi

# Check FIPS mode
if command -v fips-mode-setup &> /dev/null; then
    if ! fips-mode-setup --check | grep -q "FIPS mode is enabled"; then
        warn "FIPS mode is NOT enabled"
        warn "For production use, enable FIPS mode first:"
        warn "  fips-mode-setup --enable && reboot"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Installation cancelled"
            exit 0
        fi
    else
        log "✓ FIPS mode is enabled"
    fi
fi

# Check git
if ! command -v git &> /dev/null; then
    log "Installing git..."
    dnf install -y git
fi

# Check internet connectivity
log "Checking internet connectivity..."
if ! ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    error "No internet connectivity. Cannot download installer."
    exit 1
fi

log "✓ Internet connectivity OK"

# Download installer
log "Downloading installer from GitHub..."

if [[ -d "${INSTALL_DIR}" ]]; then
    warn "Installation directory already exists: ${INSTALL_DIR}"
    read -p "Remove and re-download? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "${INSTALL_DIR}"
    else
        log "Using existing installation directory"
    fi
fi

if [[ ! -d "${INSTALL_DIR}" ]]; then
    git clone "${REPO_URL}" "${INSTALL_DIR}"
    log "✓ Installer downloaded to ${INSTALL_DIR}"
else
    cd "${INSTALL_DIR}"
    git pull
    log "✓ Installer updated"
fi

cd "${INSTALL_DIR}"

# Check if installation_info.md exists
if [[ -f "installation_info.md" ]]; then
    log "Found existing installation_info.md"
else
    log "Creating installation_info.md from template..."
    cp installation_info_template.md installation_info.md

    echo ""
    warn "=========================================="
    warn "IMPORTANT: Complete installation_info.md"
    warn "=========================================="
    warn ""
    warn "Before running the installer, you MUST fill out"
    warn "the installation information form:"
    warn ""
    warn "  nano ${INSTALL_DIR}/installation_info.md"
    warn ""
    warn "Fill in ALL fields (replace all ___ placeholders):"
    warn "  - Business name and address"
    warn "  - Domain name (FQDN)"
    warn "  - Network configuration"
    warn "  - User accounts"
    warn "  - etc."
    warn ""

    read -p "Open editor now? (Y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        ${EDITOR:-nano} installation_info.md
    fi
fi

# Check if form is filled out
if grep -q "_______________" installation_info.md; then
    error "=========================================="
    error "installation_info.md contains unfilled fields!"
    error "=========================================="
    error ""
    error "Please complete the form before continuing:"
    error "  ${EDITOR:-nano} ${INSTALL_DIR}/installation_info.md"
    error ""
    exit 1
fi

# Ready to install
echo ""
log "=========================================="
log "Pre-Installation Complete"
log "=========================================="
log ""
log "Installation directory: ${INSTALL_DIR}"
log "Installation form: Completed ✓"
log ""
log "To start installation:"
log "  cd ${INSTALL_DIR}"
log "  ./master_install.sh"
log ""
log "Installation will take approximately 90 minutes."
log ""

read -p "Start installation now? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Starting CyberHygiene installation..."
    echo ""
    ./master_install.sh
else
    log "Installation prepared but not started."
    log "When ready, run:"
    log "  cd ${INSTALL_DIR} && ./master_install.sh"
fi
