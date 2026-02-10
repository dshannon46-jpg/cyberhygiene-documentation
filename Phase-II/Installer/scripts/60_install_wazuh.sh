#!/bin/bash
#
# Module 60: Install Wazuh
# Security monitoring, SIEM, and compliance
# NIST 800-171 Control: 3.3.1, 3.3.2, 3.14.6, 3.14.7
#
# Version: Wazuh 4.x
# Includes critical SELinux and fapolicyd fixes
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [60-WAZUH] $*"
}

log "Installing Wazuh security monitoring..."

# Step 1: Add Wazuh repository
log "Step 1: Adding Wazuh repository..."
rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH

cat > /etc/yum.repos.d/wazuh.repo <<'EOF'
[wazuh]
gpgcheck=1
gpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH
enabled=1
name=EL-$releasever - Wazuh
baseurl=https://packages.wazuh.com/4.x/yum/
protect=1
EOF

log "✓ Wazuh repository added"

# Step 2: Install Wazuh Indexer
log "Step 2: Installing Wazuh Indexer..."
dnf install -y wazuh-indexer

# Configure Wazuh Indexer
log "Configuring Wazuh Indexer..."
cat > /etc/wazuh-indexer/opensearch.yml <<EOF
# CyberHygiene Wazuh Indexer Configuration

network.host: "127.0.0.1"
node.name: "wazuh-indexer-1"
cluster.initial_master_nodes:
  - "wazuh-indexer-1"
cluster.name: "wazuh-cluster"

path.data: /var/lib/wazuh-indexer
path.logs: /var/log/wazuh-indexer

# Single node discovery
discovery.type: single-node

# Security disabled for local-only setup
plugins.security.disabled: true
EOF

# Start Wazuh Indexer
systemctl daemon-reload
systemctl enable wazuh-indexer
systemctl start wazuh-indexer

sleep 10

if systemctl is-active --quiet wazuh-indexer; then
    log "✓ Wazuh Indexer is running"
else
    log "ERROR: Wazuh Indexer failed to start"
    journalctl -u wazuh-indexer -n 20 --no-pager
    exit 1
fi

# Step 3: Install Wazuh Manager
log "Step 3: Installing Wazuh Manager..."
dnf install -y wazuh-manager

log "✓ Wazuh Manager installed"

# Configure Wazuh Manager
log "Configuring Wazuh Manager..."

# Enable and start Wazuh Manager
systemctl daemon-reload
systemctl enable wazuh-manager
systemctl start wazuh-manager

sleep 5

if systemctl is-active --quiet wazuh-manager; then
    log "✓ Wazuh Manager is running"
else
    log "ERROR: Wazuh Manager failed to start"
    systemctl status wazuh-manager
    exit 1
fi

# Step 4: Install Wazuh Dashboard
log "Step 4: Installing Wazuh Dashboard..."
dnf install -y wazuh-dashboard

# Configure Wazuh Dashboard
log "Configuring Wazuh Dashboard..."
cat > /etc/wazuh-dashboard/opensearch_dashboards.yml <<EOF
# CyberHygiene Wazuh Dashboard Configuration

server.host: 0.0.0.0
server.port: 5601
server.ssl.enabled: true
server.ssl.certificate: /etc/wazuh-dashboard/certs/dashboard.pem
server.ssl.key: /etc/wazuh-dashboard/certs/dashboard-key.pem

opensearch.hosts: ["https://127.0.0.1:9200"]
opensearch.ssl.verificationMode: none
opensearch.username: admin
opensearch.password: admin

# Wazuh app configuration
wazuh.monitoring.enabled: true
EOF

# Step 5: CRITICAL - Fix SELinux context for Node.js binaries
log "Step 5: Fixing SELinux context for Wazuh Dashboard..."

# The wazuh-dashboard service uses Node.js binaries that need bin_t SELinux context
# Without this fix, systemd cannot start the dashboard (entrypoint denial)
if [[ -d /usr/share/wazuh-dashboard/node ]]; then
    log "  Setting SELinux context for node binaries..."

    # Add permanent SELinux file context
    semanage fcontext -a -t bin_t "/usr/share/wazuh-dashboard/node(/.*)?/bin/node" 2>/dev/null || \
    semanage fcontext -m -t bin_t "/usr/share/wazuh-dashboard/node(/.*)?/bin/node" 2>/dev/null || true

    # Apply the context immediately
    chcon -t bin_t /usr/share/wazuh-dashboard/node/bin/node 2>/dev/null || true
    chcon -t bin_t /usr/share/wazuh-dashboard/node/fallback/bin/node 2>/dev/null || true

    # Restore context (in case of future relabeling)
    restorecon -Rv /usr/share/wazuh-dashboard/node/ 2>/dev/null || true

    log "✓ SELinux context configured"
fi

# Step 6: Configure fapolicyd trust for Node.js binaries
log "Step 6: Configuring fapolicyd trust (if installed)..."

if systemctl is-enabled fapolicyd 2>/dev/null; then
    log "  Adding Wazuh node binaries to fapolicyd trust..."

    # Add trust entries for node binaries
    if [[ -f /usr/share/wazuh-dashboard/node/bin/node ]]; then
        fapolicyd-cli --file add /usr/share/wazuh-dashboard/node/bin/node 2>/dev/null || true
    fi
    if [[ -f /usr/share/wazuh-dashboard/node/fallback/bin/node ]]; then
        fapolicyd-cli --file add /usr/share/wazuh-dashboard/node/fallback/bin/node 2>/dev/null || true
    fi

    # Update fapolicyd database
    fapolicyd-cli --update 2>/dev/null || true

    log "✓ fapolicyd trust configured"
else
    log "  fapolicyd not installed/enabled, skipping"
fi

# Step 7: Generate SSL certificates for dashboard
log "Step 7: Generating SSL certificates..."

mkdir -p /etc/wazuh-dashboard/certs

# Generate self-signed certificate for dashboard
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/wazuh-dashboard/certs/dashboard-key.pem \
    -out /etc/wazuh-dashboard/certs/dashboard.pem \
    -subj "/C=US/ST=State/L=City/O=${BUSINESS_NAME:-CyberHygiene}/CN=${DC1_HOSTNAME}" \
    2>/dev/null

chown -R wazuh-dashboard:wazuh-dashboard /etc/wazuh-dashboard/certs
chmod 600 /etc/wazuh-dashboard/certs/*.pem

log "✓ SSL certificates generated"

# Step 8: Start Wazuh Dashboard
log "Step 8: Starting Wazuh Dashboard..."

systemctl daemon-reload
systemctl enable wazuh-dashboard
systemctl start wazuh-dashboard

sleep 10

if systemctl is-active --quiet wazuh-dashboard; then
    log "✓ Wazuh Dashboard is running"
else
    log "ERROR: Wazuh Dashboard failed to start"
    log "Checking logs..."
    journalctl -u wazuh-dashboard -n 30 --no-pager

    # Check for common issues
    if journalctl -u wazuh-dashboard | grep -q "Permission denied"; then
        log "ERROR: Permission denied - SELinux or fapolicyd issue"
        log "Try: chcon -t bin_t /usr/share/wazuh-dashboard/node/*/bin/node"
    fi
    exit 1
fi

# Step 9: Configure firewall
log "Step 9: Configuring firewall..."
firewall-cmd --permanent --add-port=1514/tcp   # Agent enrollment (TCP)
firewall-cmd --permanent --add-port=1514/udp   # Agent enrollment (UDP)
firewall-cmd --permanent --add-port=1515/tcp   # Agent cluster
firewall-cmd --permanent --add-port=55000/tcp  # Wazuh API
firewall-cmd --permanent --add-port=9200/tcp   # Wazuh Indexer
firewall-cmd --permanent --add-port=5601/tcp   # Wazuh Dashboard
firewall-cmd --reload

log "✓ Firewall configured"

# Step 10: Verify all services
log "Step 10: Verifying Wazuh services..."

SERVICES=("wazuh-indexer" "wazuh-manager" "wazuh-dashboard")
ALL_RUNNING=true

for service in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "${service}"; then
        log "  ✓ ${service} is running"
    else
        log "  ✗ ${service} is NOT running"
        ALL_RUNNING=false
    fi
done

if [[ "${ALL_RUNNING}" != "true" ]]; then
    log "WARNING: Some Wazuh services are not running"
fi

# Summary
echo ""
log "=========================================="
log "Wazuh Installation Summary"
log "=========================================="
log "✓ Wazuh Manager installed"
log "✓ Wazuh Indexer installed"
log "✓ Wazuh Dashboard installed"
log "✓ SELinux context configured (CRITICAL)"
log "✓ SSL certificates generated"
log ""
log "Web Interface: https://${DC1_IP}:5601"
log "Username: admin"
log "Password: admin (change immediately!)"
log ""
log "Agent Enrollment:"
log "  Server: ${DC1_IP}"
log "  Port: 1514"
log ""
log "Ports:"
log "  - 5601/tcp  - Dashboard (HTTPS)"
log "  - 9200/tcp  - Indexer API"
log "  - 1514/tcp  - Agent connection"
log "  - 55000/tcp - Wazuh API"
log ""
log "NIST 800-171 Features:"
log "  - File Integrity Monitoring (FIM)"
log "  - Log Analysis & Correlation"
log "  - Vulnerability Detection"
log "  - Security Configuration Assessment"
log "  - Rootkit Detection"
log "  - Active Response"
log ""
log "IMPORTANT: Change the default admin password!"
log ""

exit 0
