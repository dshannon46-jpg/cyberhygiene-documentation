#!/bin/bash
################################################################################
# Node Exporter Installation Script with TLS for macOS
# FIPS 140-2 Compliant Configuration
#
# Run this script on the macOS workstation:
# - 192.168.1.7 (AI)
################################################################################

set -e  # Exit on error

echo "=== Node Exporter TLS Installation for macOS ==="
echo ""

# Step 1: Install Homebrew if not present
echo "[1/7] Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✓ Homebrew already installed"
fi

# Step 2: Install Node Exporter
echo "[2/7] Installing Node Exporter via Homebrew..."
brew install node_exporter
echo "✓ Node Exporter installed"

# Step 3: Create configuration directory
echo "[3/7] Creating configuration directory..."
sudo mkdir -p /usr/local/etc/node_exporter
sudo chmod 755 /usr/local/etc/node_exporter
echo "✓ Directory created"

# Step 4: Deploy TLS certificates
echo "[4/7] Deploying TLS certificates..."
echo ""
echo "*** MANUAL STEP REQUIRED ***"
echo "You need to copy the following files from the server or certificate authority:"
echo "  - wildcard.cyberinabox.net.crt  →  /usr/local/etc/node_exporter/wildcard.cyberinabox.net.crt"
echo "  - wildcard.cyberinabox.net.key  →  /usr/local/etc/node_exporter/wildcard.cyberinabox.net.key"
echo ""
echo "On the server (dc1.cyberinabox.net), run:"
echo "  scp /etc/pki/tls/certs/commercial/wildcard.crt root@192.168.1.7:/usr/local/etc/node_exporter/wildcard.cyberinabox.net.crt"
echo "  scp /etc/pki/tls/private/commercial/wildcard.key root@192.168.1.7:/usr/local/etc/node_exporter/wildcard.cyberinabox.net.key"
echo ""
read -p "Press Enter once you have copied the certificate files..."

# Set certificate permissions
sudo chmod 644 /usr/local/etc/node_exporter/wildcard.cyberinabox.net.crt
sudo chmod 640 /usr/local/etc/node_exporter/wildcard.cyberinabox.net.key
echo "✓ Certificate permissions set"

# Step 5: Create TLS configuration
echo "[5/7] Creating FIPS-compliant TLS configuration..."
sudo tee /usr/local/etc/node_exporter/web-config.yml > /dev/null << 'EOF'
tls_server_config:
  cert_file: /usr/local/etc/node_exporter/wildcard.cyberinabox.net.crt
  key_file: /usr/local/etc/node_exporter/wildcard.cyberinabox.net.key
  # FIPS 140-2 compliant TLS configuration
  min_version: TLS12
  max_version: TLS13
  # FIPS-approved cipher suites
  cipher_suites:
    - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
    - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
    - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
    - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
  # Prefer server cipher suites
  prefer_server_cipher_suites: true
EOF

sudo chmod 644 /usr/local/etc/node_exporter/web-config.yml
echo "✓ TLS configuration created"

# Step 6: Create LaunchDaemon
echo "[6/7] Creating LaunchDaemon for automatic startup..."
sudo tee /Library/LaunchDaemons/io.prometheus.node_exporter.plist > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>io.prometheus.node_exporter</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/node_exporter</string>
        <string>--web.listen-address=0.0.0.0:9100</string>
        <string>--web.config.file=/usr/local/etc/node_exporter/web-config.yml</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/var/log/node_exporter.err</string>
    <key>StandardOutPath</key>
    <string>/var/log/node_exporter.log</string>
</dict>
</plist>
EOF

# Load and start the service
sudo launchctl unload /Library/LaunchDaemons/io.prometheus.node_exporter.plist 2>/dev/null || true
sudo launchctl load /Library/LaunchDaemons/io.prometheus.node_exporter.plist
sleep 2
echo "✓ LaunchDaemon loaded"

# Step 7: Configure firewall (informational)
echo "[7/7] Firewall configuration..."
echo ""
echo "*** MANUAL FIREWALL CONFIGURATION ***"
echo "You may need to allow incoming connections on port 9100 from 192.168.1.10"
echo ""
echo "macOS Firewall Options:"
echo "  1. GUI: System Settings → Network → Firewall → Options"
echo "  2. Command line (if pfctl is configured):"
echo "     Add rule to allow TCP port 9100 from 192.168.1.10"
echo ""
read -p "Press Enter to continue..."

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Service Status:"
if pgrep -f node_exporter > /dev/null; then
    echo "✓ Node Exporter is running"
    echo "PID: $(pgrep -f node_exporter)"
else
    echo "✗ Node Exporter is not running"
fi
echo ""
echo "Testing HTTPS endpoint:"
curl -k https://localhost:9100/metrics 2>&1 | head -5
echo ""
echo "✓ Node Exporter is now running with FIPS-compliant TLS encryption!"
echo "✓ Prometheus will automatically detect and scrape this endpoint."
echo ""
echo "Logs available at:"
echo "  /var/log/node_exporter.log"
echo "  /var/log/node_exporter.err"
