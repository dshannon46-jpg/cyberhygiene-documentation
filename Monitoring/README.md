# Monitoring Configuration

This directory contains the monitoring system configuration files for the CyberHygiene Project.

## Contents

### Prometheus Configuration
- **prometheus.yml**: Main Prometheus configuration
  - 8 scrape targets configured (added OpenClaw Feb 2026)
  - Includes Suricata IDS metrics exporter (added Dec 31, 2025)
  - 15-second scrape interval
  - 15-day retention

### Grafana Datasources
- **prometheus.yaml**: Prometheus datasource configuration
  - URL: https://dc1.cyberinabox.net:9091
  - TLS skip verify enabled for self-signed certificates
  - 15-second time interval

### Grafana Dashboards
1. **node-exporter-dashboard.json**: System monitoring dashboard
   - CPU, memory, disk, network metrics
   - Monitors 6 systems (server + 5 workstations)

2. **suricata-ids.json**: Network security monitoring
   - Packet processing statistics
   - Alert tracking and analysis
   - Protocol-specific flows (HTTP, TLS, DNS, etc.)

3. **yara_malware_detection.json**: Malware detection dashboard
   - YARA rule match tracking
   - Threat analysis and visualization

### AI Security Monitoring (NEW - Feb 2026)
- **openclaw/**: OpenClaw AI Gateway monitoring configuration
  - `wazuh-rules.xml`: Wazuh alert rules for AI security events
  - `openclaw-monitoring.md`: AI-specific monitoring procedures

## Recent Changes (Feb 2, 2026)

### OpenClaw AI Integration
- Added AI security monitoring for OpenClaw gateway
- New Wazuh rules for Citadel Guard injection detection
- HITL approval workflow monitoring via sudo-proxy
- Audit log forwarding to Wazuh SIEM

### AI Monitoring Components
| Component | Log Location | Monitored Events |
|-----------|--------------|------------------|
| OpenClaw Gateway | `/opt/openclaw/logs/openclaw.log` | Injection detection, auth failures |
| Sudo Proxy | `/opt/sudo-proxy/logs/audit.log` | Approval requests, denials, timeouts |
| SysAdmin Agent | `/data/ai-workspace/sysadmin-agent/logs/agent_audit.log` | Command execution, blocks |

### AI Services Status
- openclaw.service (127.0.0.1:18789) - AI Gateway with Citadel Guard
- sudo-proxy.service (Unix socket) - HITL approval enforcement
- sysadmin-agent.service (127.0.0.1:8501) - AI dashboard
- cpm-dashboard.service (127.0.0.1:5000) - Approval UI

## Recent Changes (Dec 31, 2025)

### Dashboard Fixes
- Fixed datasource configuration on all dashboards
- Added Suricata metrics scrape job to Prometheus
- Enabled TLS certificate verification skip for self-signed certs
- All 3 dashboards now fully operational

### Monitoring Targets (7/7 UP)
- prometheus (self-monitoring)
- server-dc1 (dc1.cyberinabox.net)
- suricata (IDS/IPS metrics) ⭐ NEW
- workstation-accounting
- workstation-ai (macOS)
- workstation-engineering  
- workstation-labrat

## Deployment

Configuration files are deployed to:
- Prometheus: `/etc/prometheus/prometheus.yml`
- Grafana datasources: `/etc/grafana/provisioning/datasources/`
- Grafana dashboards: `/var/lib/grafana/dashboards/`

## Access

- Grafana UI: https://grafana.cyberinabox.net
- Prometheus UI: https://dc1.cyberinabox.net:9091
- Metrics Endpoint: https://dc1.cyberinabox.net:9100/metrics (Node Exporter)
- Suricata Metrics: http://localhost:9101/metrics

---
Last Updated: December 31, 2025
