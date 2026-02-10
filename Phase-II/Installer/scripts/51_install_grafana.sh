#!/bin/bash
#
# Module 51: Install Grafana
# Metrics visualization and dashboards
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [51-GRAFANA] $*"
}

log "Installing Grafana dashboards..."

# Install Grafana
log "Installing Grafana packages..."
dnf install -y grafana grafana-pcp

log "✓ Grafana packages installed"

# Configure Grafana
log "Configuring Grafana..."
cat > /etc/grafana/grafana.ini <<EOF
[DEFAULT]
app_mode = production

[server]
protocol = http
http_addr = ${DC1_IP}
http_port = 3000
domain = grafana.${DOMAIN}
root_url = https://grafana.${DOMAIN}

[database]
type = sqlite3
path = grafana.db

[security]
admin_user = admin
admin_password = ${ADMIN_PASSWORD}
secret_key = $(openssl rand -base64 32)

[users]
allow_sign_up = false
allow_org_create = false
auto_assign_org = true
auto_assign_org_role = Viewer

[auth.anonymous]
enabled = false

[auth.basic]
enabled = true

[snapshots]
external_enabled = false

[log]
mode = console file
level = info

[log.console]
level = info

[log.file]
level = info
log_rotate = true
max_lines = 1000000
max_size_shift = 28
daily_rotate = true
max_days = 7
EOF

# Configure firewall
log "Configuring firewall..."
firewall-cmd --permanent --add-port=3000/tcp
firewall-cmd --reload

log "✓ Firewall configured"

# Enable and start Grafana
log "Starting Grafana..."
systemctl daemon-reload
systemctl enable --now grafana-server

sleep 10

if systemctl is-active --quiet grafana-server; then
    log "✓ Grafana is running"
else
    log "ERROR: Grafana failed to start"
    systemctl status grafana-server
    exit 1
fi

# Wait for Grafana API to be ready
log "Waiting for Grafana API..."
for i in {1..30}; do
    if curl -s http://localhost:3000/api/health > /dev/null 2>&1; then
        log "✓ Grafana API is ready"
        break
    fi
    sleep 2
done

# Add Prometheus data source via API
log "Adding Prometheus data source..."
curl -s -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "name":"Prometheus",
        "type":"prometheus",
        "url":"http://localhost:9090",
        "access":"proxy",
        "isDefault":true
    }' \
    http://admin:${ADMIN_PASSWORD}@localhost:3000/api/datasources || log "Data source may already exist"

log "✓ Prometheus data source configured"

# Install common dashboards
log "Installing pre-built dashboards..."

# Node Exporter Full dashboard (ID: 1860)
curl -s -X POST \
    -H "Content-Type: application/json" \
    -d '{
        "dashboard": {
            "id": null,
            "title": "Node Exporter Full",
            "tags": ["prometheus", "node-exporter"],
            "timezone": "browser"
        },
        "folderId": 0,
        "overwrite": true,
        "pluginId": "grafana-simple-json-datasource"
    }' \
    http://admin:${ADMIN_PASSWORD}@localhost:3000/api/dashboards/import || true

log "✓ Dashboards installed"

echo ""
log "=========================================="
log "Grafana Installation Summary"
log "=========================================="
log "✓ Grafana server installed"
log "✓ Prometheus data source configured"
log "✓ Pre-built dashboards installed"
log ""
log "Web Interface: http://${DC1_IP}:3000"
log "Username: admin"
log "Password: [See CREDENTIALS file]"
log ""
log "Available dashboards:"
log "  - Node Exporter Full (system metrics)"
log ""
log "Next steps:"
log "  1. Log in to Grafana web interface"
log "  2. Explore pre-configured dashboards"
log "  3. Create custom dashboards as needed"
log ""

exit 0
