#!/bin/bash
#
# Module 30: Install Graylog
# Centralized log management with MongoDB and OpenSearch
# NIST 800-171 Control: 3.3.1, 3.3.2
#
# Versions: Graylog 6.x, MongoDB 7.x, OpenSearch 2.x
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [30-GRAYLOG] $*"
}

log "Installing Graylog log management system..."

# Version configuration
MONGODB_VERSION="7.0"
GRAYLOG_VERSION="6.1"

# Step 1: Install Java
log "Step 1: Installing Java (OpenJDK 17)..."
dnf install -y java-17-openjdk-headless

java -version 2>&1 | head -1
log "✓ Java installed"

# Step 2: Install MongoDB
log "Step 2: Installing MongoDB ${MONGODB_VERSION}..."

# Add MongoDB repository
cat > /etc/yum.repos.d/mongodb-org-${MONGODB_VERSION}.repo <<EOF
[mongodb-org-${MONGODB_VERSION}]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/${MONGODB_VERSION}/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-${MONGODB_VERSION}.asc
EOF

dnf install -y mongodb-org

# Configure MongoDB
log "Configuring MongoDB..."
cat > /etc/mongod.conf <<'EOF'
# CyberHygiene MongoDB Configuration for Graylog

# Where and how to store data
storage:
  dbPath: /var/lib/mongo
  journal:
    enabled: true

# Where to write logging data
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# Network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1

# Process management
processManagement:
  timeZoneInfo: /usr/share/zoneinfo
  fork: false

# Security (disable for local-only Graylog setup)
security:
  authorization: disabled
EOF

# Create data directories
mkdir -p /var/lib/mongo /var/log/mongodb
chown -R mongod:mongod /var/lib/mongo /var/log/mongodb

# Start MongoDB
systemctl daemon-reload
systemctl enable --now mongod

sleep 5

if systemctl is-active --quiet mongod; then
    log "✓ MongoDB is running"
else
    log "ERROR: MongoDB failed to start"
    systemctl status mongod
    exit 1
fi

# Step 3: Install OpenSearch
log "Step 3: Installing OpenSearch..."

# Add OpenSearch repository
cat > /etc/yum.repos.d/opensearch.repo <<'EOF'
[opensearch-2.x]
name=OpenSearch 2.x
baseurl=https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/yum
enabled=1
gpgcheck=1
gpgkey=https://artifacts.opensearch.org/publickeys/opensearch.pgp
autorefresh=1
type=rpm-md
EOF

dnf install -y opensearch

# Configure OpenSearch for Graylog
log "Configuring OpenSearch..."
cat > /etc/opensearch/opensearch.yml <<'EOF'
# CyberHygiene OpenSearch Configuration for Graylog

cluster.name: graylog
node.name: graylog-node-1

# Paths
path.data: /var/lib/opensearch
path.logs: /var/log/opensearch

# Network (bind to localhost only for Graylog)
network.host: 127.0.0.1
http.port: 9200

# Discovery (single node)
discovery.type: single-node

# Disable security plugins for local-only setup
plugins.security.disabled: true

# Graylog compatibility
action.auto_create_index: false
indices.query.bool.max_clause_count: 32768
EOF

# Set memory limits
mkdir -p /etc/opensearch/jvm.options.d
cat > /etc/opensearch/jvm.options.d/heap.options <<'EOF'
# Graylog recommended heap size
-Xms2g
-Xmx2g
EOF

# Fix permissions
chown -R opensearch:opensearch /etc/opensearch
chown -R opensearch:opensearch /var/lib/opensearch
chown -R opensearch:opensearch /var/log/opensearch

# Start OpenSearch
systemctl daemon-reload
systemctl enable --now opensearch

sleep 10

if systemctl is-active --quiet opensearch; then
    log "✓ OpenSearch is running"
else
    log "ERROR: OpenSearch failed to start"
    systemctl status opensearch
    journalctl -u opensearch -n 20 --no-pager
    exit 1
fi

# Verify OpenSearch is responding
if curl -s http://localhost:9200 > /dev/null; then
    log "✓ OpenSearch API responding"
else
    log "WARNING: OpenSearch API not responding yet"
fi

# Step 4: Install Graylog
log "Step 4: Installing Graylog ${GRAYLOG_VERSION}..."

# Add Graylog repository
rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-${GRAYLOG_VERSION}-repository_latest.rpm 2>/dev/null || true

dnf install -y graylog-server

log "✓ Graylog packages installed"

# Step 5: Configure Graylog
log "Step 5: Configuring Graylog..."

# Generate password secret
PASSWORD_SECRET=$(openssl rand -hex 48)
ADMIN_PASSWORD_SHA2=$(echo -n "${ADMIN_PASSWORD}" | sha256sum | cut -d" " -f1)

# Create data directory
mkdir -p /data/graylog
chown graylog:graylog /data/graylog

cat > /etc/graylog/server/server.conf <<EOF
# CyberHygiene Graylog Configuration
# Generated: $(date)

# Leader node configuration
is_leader = true
node_id_file = /etc/graylog/server/node-id

# Authentication
password_secret = ${PASSWORD_SECRET}
root_username = admin
root_password_sha2 = ${ADMIN_PASSWORD_SHA2}

# Paths
bin_dir = /usr/share/graylog-server/bin
data_dir = /data/graylog
plugin_dir = /usr/share/graylog-server/plugin

# Network
http_bind_address = 0.0.0.0:9000
http_external_uri = https://graylog.${DOMAIN}/

# Field types
stream_aware_field_types = false

# OpenSearch / Elasticsearch
elasticsearch_hosts = http://127.0.0.1:9200

# Retention
disabled_retention_strategies = none,close

# Search settings
allow_leading_wildcard_searches = false
allow_highlighting = false
field_value_suggestion_mode = on

# Output settings
output_batch_size = 500
output_flush_interval = 1
output_fault_count_threshold = 5
output_fault_penalty_seconds = 30

# Processing
processor_wait_strategy = blocking
ring_size = 65536
inputbuffer_ring_size = 65536
inputbuffer_wait_strategy = blocking

# Message journal
message_journal_enabled = true
message_journal_dir = /var/lib/graylog-server/journal

# Load balancer
lb_recognition_period_seconds = 3

# MongoDB
mongodb_uri = mongodb://localhost/graylog
mongodb_max_connections = 1000
EOF

chown graylog:graylog /etc/graylog/server/server.conf
chmod 640 /etc/graylog/server/server.conf

log "✓ Graylog configured"

# Step 6: Configure firewall
log "Step 6: Configuring firewall..."
firewall-cmd --permanent --add-port=9000/tcp   # Graylog web UI
firewall-cmd --permanent --add-port=514/tcp    # Syslog TCP
firewall-cmd --permanent --add-port=514/udp    # Syslog UDP
firewall-cmd --permanent --add-port=1514/tcp   # Graylog Beats input
firewall-cmd --permanent --add-port=5044/tcp   # Beats input
firewall-cmd --permanent --add-port=12201/tcp  # GELF TCP
firewall-cmd --permanent --add-port=12201/udp  # GELF UDP
firewall-cmd --reload

log "✓ Firewall configured"

# Step 7: Start Graylog
log "Step 7: Starting Graylog server..."

systemctl daemon-reload
systemctl enable graylog-server
systemctl start graylog-server

# Wait for Graylog to initialize
log "Waiting for Graylog to initialize (60-90 seconds)..."
for i in {1..30}; do
    if curl -s http://localhost:9000/api/system/lbstatus 2>/dev/null | grep -q "ALIVE"; then
        log "✓ Graylog is ready!"
        break
    fi
    sleep 3
done

if systemctl is-active --quiet graylog-server; then
    log "✓ Graylog server is running"
else
    log "ERROR: Graylog server failed to start"
    systemctl status graylog-server
    journalctl -u graylog-server -n 30 --no-pager
    exit 1
fi

# Step 8: Create default input (Syslog)
log "Step 8: Creating default inputs..."
log "Note: Additional inputs should be configured via web UI"

# Summary
echo ""
log "=========================================="
log "Graylog Installation Summary"
log "=========================================="
log "✓ MongoDB ${MONGODB_VERSION} installed"
log "✓ OpenSearch installed"
log "✓ Graylog ${GRAYLOG_VERSION} installed"
log ""
log "Web Interface: http://${DC1_IP}:9000"
log "Username: admin"
log "Password: [See CREDENTIALS file]"
log ""
log "Default Ports:"
log "  - 9000/tcp  - Web UI"
log "  - 514/tcp   - Syslog TCP"
log "  - 514/udp   - Syslog UDP"
log "  - 5044/tcp  - Beats input"
log "  - 12201/tcp - GELF TCP"
log "  - 12201/udp - GELF UDP"
log ""
log "Next Steps:"
log "  1. Access web UI and complete setup wizard"
log "  2. Create Syslog input (System > Inputs)"
log "  3. Configure clients to send logs"
log "  4. Create streams and alerts"
log ""
log "Service Commands:"
log "  systemctl status graylog-server"
log "  journalctl -u graylog-server -f"
log ""

exit 0
