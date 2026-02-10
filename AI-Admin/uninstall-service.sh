#!/bin/bash
# Uninstall CyberHygiene AI Dashboard systemd service

set -e

SERVICE_NAME="cyberhygiene-ai-dashboard"
SYSTEMD_DIR="/etc/systemd/system"

echo "=================================================="
echo "CyberHygiene AI Dashboard - Service Removal"
echo "=================================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)"
    exit 1
fi

# Stop the service
echo "1. Stopping the service..."
systemctl stop $SERVICE_NAME.service 2>/dev/null || true

# Disable the service
echo "2. Disabling the service..."
systemctl disable $SERVICE_NAME.service 2>/dev/null || true

# Remove service file
echo "3. Removing service file..."
rm -f "$SYSTEMD_DIR/$SERVICE_NAME.service"

# Reload systemd
echo "4. Reloading systemd daemon..."
systemctl daemon-reload

echo ""
echo "=================================================="
echo "Service Removed Successfully"
echo "=================================================="
echo ""
echo "The dashboard service has been uninstalled."
echo "You can still run it manually with: ./cyberai-web"
echo ""
