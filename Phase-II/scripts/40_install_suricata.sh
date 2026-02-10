#!/bin/bash
#
# Module 40: Install Suricata IDS/IPS
# Network intrusion detection and prevention
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [40-SURICATA] $*"
}

log "Installing Suricata IDS/IPS..."

# Install Suricata
log "Installing Suricata packages..."
dnf install -y epel-release
dnf install -y suricata suricata-update

log "✓ Suricata packages installed"

# Get network interface
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
log "Detected network interface: ${INTERFACE}"

# Configure Suricata
log "Configuring Suricata..."
cat > /etc/suricata/suricata.yaml <<EOF
%YAML 1.1
---
vars:
  address-groups:
    HOME_NET: "[${SUBNET}.0/24]"
    EXTERNAL_NET: "!\\$HOME_NET"
  port-groups:
    HTTP_PORTS: "80"
    SHELLCODE_PORTS: "!80"
    ORACLE_PORTS: 1521
    SSH_PORTS: 22
    DNP3_PORTS: 20000
    MODBUS_PORTS: 502
    FILE_DATA_PORTS: "[\\\$HTTP_PORTS,110,143]"
    FTP_PORTS: 21

default-log-dir: /var/log/suricata/

af-packet:
  - interface: ${INTERFACE}
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    tpacket-v3: yes

outputs:
  - fast:
      enabled: yes
      filename: fast.log
      append: yes
  - eve-log:
      enabled: yes
      filetype: regular
      filename: eve.json
      types:
        - alert
        - http
        - dns
        - tls
        - files
        - smtp
        - ssh
        - stats
        - flow

logging:
  default-log-level: notice
  outputs:
    - console:
        enabled: yes
    - file:
        enabled: yes
        level: info
        filename: /var/log/suricata/suricata.log
    - syslog:
        enabled: yes
        facility: local5
        format: "[%i] <%d> -- "

rule-files:
  - suricata.rules

classification-file: /etc/suricata/classification.config
reference-config-file: /etc/suricata/reference.config
EOF

# Update Suricata rules
log "Updating Suricata rulesets..."
suricata-update || log "Warning: Rule update may have failed"

# Configure systemd service
log "Configuring Suricata service..."
cat > /etc/sysconfig/suricata <<EOF
OPTIONS="--af-packet=${INTERFACE} --user suricata"
EOF

# Create log directory
mkdir -p /var/log/suricata
chown -R suricata:suricata /var/log/suricata

# Configure firewall (Suricata monitors, doesn't need inbound ports)
log "Suricata runs in monitor mode, no firewall changes needed"

# Enable and start Suricata
log "Starting Suricata..."
systemctl enable --now suricata

sleep 5

if systemctl is-active --quiet suricata; then
    log "✓ Suricata is running"
else
    log "ERROR: Suricata failed to start"
    systemctl status suricata
    exit 1
fi

# Install Suricata exporter for Prometheus
log "Installing Suricata Prometheus exporter..."
dnf install -y python3-pip
pip3 install suricata-exporter || log "Warning: Exporter installation optional"

echo ""
log "=========================================="
log "Suricata Installation Summary"
log "=========================================="
log "✓ Suricata IDS/IPS installed"
log "✓ Monitoring interface: ${INTERFACE}"
log "✓ Network: ${SUBNET}.0/24"
log ""
log "Logs: /var/log/suricata/eve.json"
log "Fast alerts: /var/log/suricata/fast.log"
log ""
log "To view alerts:"
log "  tail -f /var/log/suricata/fast.log"
log ""

exit 0
