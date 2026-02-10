#!/bin/bash
#
# Module 50: Install Prometheus
# Metrics collection and monitoring
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [50-PROMETHEUS] $*"
}

log "Installing Prometheus monitoring..."

# Install Prometheus
log "Installing Prometheus packages..."
dnf install -y prometheus2 golang-github-prometheus-node-exporter

log "✓ Prometheus packages installed"

# Configure Prometheus
log "Configuring Prometheus..."
cat > /etc/prometheus/prometheus.yml <<EOF
# CyberHygiene Prometheus Configuration
# Generated: $(date)

global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'cyberhygiene'
    environment: 'production'

scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporters (system metrics)
  - job_name: 'node-exporter'
    static_configs:
      - targets:
        - '${DC1_IP}:9100'
        labels:
          instance: 'dc1'
          role: 'domain-controller'

  # Suricata Exporter (if installed)
  - job_name: 'suricata'
    static_configs:
      - targets:
        - '${DC1_IP}:9922'
        labels:
          instance: 'dc1'
          service: 'ids-ips'
EOF

# Configure firewall
log "Configuring firewall..."
firewall-cmd --permanent --add-port=9090/tcp  # Prometheus web UI
firewall-cmd --permanent --add-port=9100/tcp  # Node exporter
firewall-cmd --reload

log "✓ Firewall configured"

# Create Prometheus user and directories
useradd -r -s /sbin/nologin prometheus 2>/dev/null || true
mkdir -p /var/lib/prometheus
chown -R prometheus:prometheus /var/lib/prometheus

# Enable and start services
log "Starting Prometheus services..."
systemctl enable --now prometheus
systemctl enable --now node_exporter

sleep 5

if systemctl is-active --quiet prometheus; then
    log "✓ Prometheus is running"
else
    log "ERROR: Prometheus failed to start"
    systemctl status prometheus
    exit 1
fi

if systemctl is-active --quiet node_exporter; then
    log "✓ Node Exporter is running"
else
    log "WARNING: Node Exporter failed to start"
fi

# Test Prometheus API
log "Testing Prometheus API..."
if curl -s http://localhost:9090/api/v1/status/config > /dev/null; then
    log "✓ Prometheus API responding"
else
    log "WARNING: Prometheus API not responding yet (may need more time)"
fi

echo ""
log "=========================================="
log "Prometheus Installation Summary"
log "=========================================="
log "✓ Prometheus server installed"
log "✓ Node Exporter installed"
log ""
log "Web Interface: http://${DC1_IP}:9090"
log "Metrics: http://${DC1_IP}:9100/metrics"
log ""
log "Targets configured:"
log "  - Prometheus (self-monitoring)"
log "  - Node Exporter (system metrics)"
log "  - Suricata Exporter (network security)"
log ""

exit 0
