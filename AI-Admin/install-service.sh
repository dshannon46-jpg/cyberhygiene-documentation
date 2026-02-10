#!/bin/bash
# Install CyberHygiene AI Dashboard as a systemd service

set -e

SERVICE_NAME="cyberhygiene-ai-dashboard"
SERVICE_FILE="/home/dshannon/cyberhygiene-ai-admin/${SERVICE_NAME}.service"
SYSTEMD_DIR="/etc/systemd/system"

echo "=================================================="
echo "CyberHygiene AI Dashboard - Service Installation"
echo "=================================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root (use sudo)"
    exit 1
fi

# Stop any running test instances
echo "1. Stopping any running test instances..."
pkill -f "port=54787" 2>/dev/null || true
pkill -f "web.app" 2>/dev/null || true
sleep 2

# Install the service file
echo "2. Installing systemd service file..."
cp "$SERVICE_FILE" "$SYSTEMD_DIR/$SERVICE_NAME.service"
chmod 644 "$SYSTEMD_DIR/$SERVICE_NAME.service"

# Reload systemd
echo "3. Reloading systemd daemon..."
systemctl daemon-reload

# Enable the service
echo "4. Enabling service to start on boot..."
systemctl enable $SERVICE_NAME.service

# Start the service
echo "5. Starting the service..."
systemctl start $SERVICE_NAME.service

# Wait a moment for startup
sleep 3

# Check status
echo ""
echo "=================================================="
echo "Service Status:"
echo "=================================================="
systemctl status $SERVICE_NAME.service --no-pager -l

echo ""
echo "=================================================="
echo "Installation Complete!"
echo "=================================================="
echo ""
echo "Service is now running on: http://192.168.1.10:5500"
echo ""
echo "Management Commands:"
echo "  Start:   sudo systemctl start $SERVICE_NAME"
echo "  Stop:    sudo systemctl stop $SERVICE_NAME"
echo "  Restart: sudo systemctl restart $SERVICE_NAME"
echo "  Status:  sudo systemctl status $SERVICE_NAME"
echo "  Logs:    sudo journalctl -u $SERVICE_NAME -f"
echo ""
echo "The service will automatically start on system boot."
echo ""
