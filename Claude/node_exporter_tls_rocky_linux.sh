#!/bin/bash
################################################################################
# Node Exporter Installation Script with TLS for Rocky Linux Workstations
# FIPS 140-2 Compliant Configuration
#
# Run this script as root on each Rocky Linux workstation:
# - 192.168.1.104 (Engineering)
# - 192.168.1.113 (Accounting)
# - 192.168.1.115 (Lab Rat)
################################################################################

set -e  # Exit on error

echo "=== Node Exporter TLS Installation for Rocky Linux ==="
echo ""

# Variables
NODE_EXPORTER_VERSION="1.7.0"
DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

# Step 1: Download and install Node Exporter
echo "[1/7] Downloading Node Exporter ${NODE_EXPORTER_VERSION}..."
cd /tmp
wget -q ${DOWNLOAD_URL}
tar xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
chmod +x /usr/local/bin/node_exporter
echo "✓ Node Exporter binary installed"

# Step 2: Create node_exporter user
echo "[2/7] Creating node_exporter user..."
useradd --no-create-home --shell /bin/false node_exporter 2>/dev/null || echo "User already exists"
echo "✓ User created"

# Step 3: Create configuration directory
echo "[3/7] Creating configuration directory..."
mkdir -p /etc/node_exporter
chmod 755 /etc/node_exporter
echo "✓ Directory created"

# Step 4: Deploy TLS certificates
echo "[4/7] Deploying TLS certificates..."
echo ""
echo "*** MANUAL STEP REQUIRED ***"
echo "You need to copy the following files from the server or certificate authority:"
echo "  - /etc/pki/tls/certs/commercial/wildcard.crt  →  /etc/node_exporter/wildcard.cyberinabox.net.crt"
echo "  - /etc/pki/tls/private/commercial/wildcard.key  →  /etc/node_exporter/wildcard.cyberinabox.net.key"
echo ""
echo "On the server (dc1.cyberinabox.net), run:"
echo "  scp /etc/pki/tls/certs/commercial/wildcard.crt root@$(hostname -I | awk '{print $1}'):/etc/node_exporter/wildcard.cyberinabox.net.crt"
echo "  scp /etc/pki/tls/private/commercial/wildcard.key root@$(hostname -I | awk '{print $1}'):/etc/node_exporter/wildcard.cyberinabox.net.key"
echo ""
read -p "Press Enter once you have copied the certificate files..."

# Set certificate permissions
chmod 644 /etc/node_exporter/wildcard.cyberinabox.net.crt
chmod 640 /etc/node_exporter/wildcard.cyberinabox.net.key
chown node_exporter:node_exporter /etc/node_exporter/wildcard.cyberinabox.net.*
echo "✓ Certificate permissions set"

# Step 5: Create TLS configuration
echo "[5/7] Creating FIPS-compliant TLS configuration..."
cat > /etc/node_exporter/web-config.yml << 'EOF'
tls_server_config:
  cert_file: /etc/node_exporter/wildcard.cyberinabox.net.crt
  key_file: /etc/node_exporter/wildcard.cyberinabox.net.key
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

chmod 644 /etc/node_exporter/web-config.yml
chown node_exporter:node_exporter /etc/node_exporter/web-config.yml
echo "✓ TLS configuration created"

# Step 6: Create systemd service
echo "[6/7] Creating systemd service..."
cat > /etc/systemd/system/node_exporter.service << 'EOF'
[Unit]
Description=Prometheus Node Exporter
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter \
  --web.listen-address=0.0.0.0:9100 \
  --web.config.file=/etc/node_exporter/web-config.yml

SyslogIdentifier=node_exporter
Restart=always
RestartSec=5

# Security settings
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# Start and enable service
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
sleep 2
echo "✓ Service started"

# Step 7: Configure firewall
echo "[7/7] Configuring firewall..."
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.10" port protocol="tcp" port="9100" accept'
firewall-cmd --reload
echo "✓ Firewall configured"

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Service Status:"
systemctl status node_exporter --no-pager | head -10
echo ""
echo "Testing HTTPS endpoint:"
curl -k https://localhost:9100/metrics 2>&1 | head -5
echo ""
echo "Firewall Status:"
firewall-cmd --list-ports | grep 9100
echo ""
echo "✓ Node Exporter is now running with FIPS-compliant TLS encryption!"
echo "✓ Prometheus will automatically detect and scrape this endpoint."
