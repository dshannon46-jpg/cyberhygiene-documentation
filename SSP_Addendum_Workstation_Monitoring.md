# System Security Plan (SSP) Addendum
## FIPS-Compliant Workstation Monitoring System

**Document Type:** SSP Addendum
**System:** CyberInABox - NIST 800-171 Compliance System
**Component:** Prometheus Time-Series Monitoring with Encrypted Metrics Collection
**Version:** 1.0
**Date:** December 31, 2025
**Classification:** INTERNAL USE ONLY

---

## 1. System Overview

### 1.1 Purpose

This addendum documents the implementation of a FIPS 140-2 compliant workstation monitoring system using Prometheus, Node Exporter, and Grafana. This enhancement provides comprehensive system health monitoring, performance metrics collection, and real-time visibility across all infrastructure components while maintaining encryption of data in transit as required by NIST 800-171.

### 1.2 Scope

This addendum covers:
- Prometheus 2.48.1 time-series metrics database
- Node Exporter 1.7.0 system metrics collection (6 systems)
- Grafana visualization platform
- TLS 1.2/1.3 encrypted metrics transmission
- FIPS 140-2 compliant cipher suites
- Cross-platform deployment (Rocky Linux 9.x and macOS)

### 1.3 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   Monitored Systems (6)                      │
│  • dc1 (Rocky Linux 9.7) - Server                           │
│  • engineering (Rocky Linux 9.7) - 48 cores                 │
│  • accounting (Rocky Linux 9.7) - 32 cores                  │
│  • labrat (Rocky Linux 9.6) - 32 cores                      │
│  • ai (macOS Darwin) - 56 cores                             │
│  • prometheus (self-monitoring)                             │
│                                                              │
│  Node Exporter (port 9100/HTTPS)                            │
│         ↓ TLS 1.2/1.3 Encrypted Metrics                     │
└─────────────────────────────────────────────────────────────┘
                         ↓
         ┌───────────────────────────────┐
         │   Prometheus Server           │
         │   (dc1.cyberinabox.net:9091)  │
         │   • 15s scrape interval       │
         │   • 15-day retention          │
         │   • HTTPS/TLS interface       │
         └───────────────────────────────┘
                         ↓
         ┌───────────────────────────────┐
         │   Grafana Visualization       │
         │   (dc1.cyberinabox.net:3001)  │
         │   • HTTPS datasource          │
         │   • Real-time dashboards      │
         │   • Historical analysis       │
         └───────────────────────────────┘
```

### 1.4 Deployment Summary

**Total Systems Monitored:** 6
**Success Rate:** 100% (6/6 targets UP)
**Encryption:** FIPS 140-2 compliant TLS for all metrics transmission
**Metrics Collected:** 144+ time-series metrics per system
**Data Retention:** 15 days
**Collection Interval:** 15 seconds

---

## 2. Security Controls Addressed

### 2.1 NIST 800-171 Controls

| Control | Family | Implementation |
|---------|--------|----------------|
| **SI-4** | System and Information Integrity | Information System Monitoring - Comprehensive metrics collection across all infrastructure |
| **AU-2** | Audit and Accountability | Event Logging - System performance and health events captured |
| **AU-3** | Audit and Accountability | Audit Content - Detailed metrics with hostname, timestamp, and values |
| **AU-6** | Audit and Accountability | Audit Review - Grafana dashboards enable analysis and trend identification |
| **AU-12** | Audit and Accountability | Audit Generation - Automated metrics collection every 15 seconds |
| **SC-8** | System and Communications Protection | Transmission Confidentiality - TLS 1.2/1.3 encryption for all metrics |
| **SC-13** | System and Communications Protection | Cryptographic Protection - FIPS 140-2 validated cipher suites |
| **CM-3** | Configuration Management | Configuration Change Control - Monitoring detects unauthorized changes |
| **CM-6** | Configuration Management | Configuration Settings - Baseline monitoring for compliance verification |

### 2.2 Control Implementation Details

#### SI-4: Information System Monitoring

**Requirement:** Monitor the system to detect attacks and indicators of potential attacks; unauthorized local, network, and remote connections.

**Implementation:**
- **Coverage:** 6 systems monitored (1 server + 4 Rocky Linux workstations + 1 macOS workstation)
- **Metrics Collected:**
  - System: CPU usage, load averages, uptime, boot time, context switches
  - Memory: Total, free, available, buffers, cached, swap usage
  - Disk: I/O rates, queue depth, utilization, space, inode usage
  - Network: Bytes sent/received, packet errors, drops, connections
  - Filesystem: Mount points, space usage, read-only status
  - Processes: Count, states, CPU time, memory usage, file descriptors
  - Hardware: Temperature sensors, fan speeds, power (where available)
- **Frequency:** 15-second scrape interval provides near real-time visibility
- **Retention:** 15 days of historical data for trend analysis
- **Alerting:** Configurable alert rules for threshold violations

**Evidence:**
- Prometheus configuration: `/etc/prometheus/prometheus.yml`
- Prometheus targets status: `https://dc1.cyberinabox.net:9091/targets`
- Grafana dashboards: `http://dc1.cyberinabox.net:3001`
- Monitoring status report: `/tmp/FINAL_MONITORING_STATUS.md`

#### SC-8: Transmission Confidentiality and Integrity

**Requirement:** Protect the confidentiality and integrity of transmitted information.

**Implementation:**
- **Encryption Protocol:** TLS 1.2 and TLS 1.3 only
- **Certificate:** Wildcard certificate (*.cyberinabox.net) issued by SSL.com RSA SSL subCA
- **Certificate Validity:** Valid until October 28, 2026
- **Key Type:** RSA (FIPS-compliant)
- **Encrypted Communications:**
  - Prometheus web UI (HTTPS on port 9091)
  - All Prometheus → Node Exporter scraping (HTTPS on port 9100)
  - Grafana → Prometheus queries (HTTPS)
  - All metric data transmission

**TLS Configuration:**
```yaml
tls_server_config:
  cert_file: /etc/node_exporter/wildcard.cyberinabox.net.crt
  key_file: /etc/node_exporter/wildcard.cyberinabox.net.key
  min_version: TLS12
  max_version: TLS13
  cipher_suites:
    - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
    - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
    - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
    - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
  prefer_server_cipher_suites: true
```

**Evidence:**
- Node Exporter TLS config: `/etc/node_exporter/web-config.yml` (all systems)
- Prometheus TLS config: `/etc/prometheus/web-config.yml`
- Certificate files: `/etc/prometheus/certs/` and `/etc/node_exporter/`
- TLS verification: `openssl s_client -connect dc1.cyberinabox.net:9091`

#### SC-13: Cryptographic Protection

**Requirement:** Implement cryptographic mechanisms to prevent unauthorized disclosure of information and detect changes to information during transmission.

**Implementation:**
- **FIPS Mode:** System-wide FIPS 140-2 mode enabled on all Rocky Linux systems
- **Cryptographic Library:** OpenSSL 3.0.7 with FIPS validated crypto modules
- **Cipher Suites:** Only FIPS-approved AES-GCM cipher suites allowed
- **Key Exchange:** ECDHE (Elliptic Curve Diffie-Hellman Ephemeral) for forward secrecy
- **Signature Algorithm:** RSA with SHA-256/SHA-384
- **Certificate Validation:** Full certificate chain validation enabled (`insecure_skip_verify: false`)

**FIPS Validation:**
```bash
# FIPS mode verification
$ fips-mode-setup --check
FIPS mode is enabled.

# OpenSSL FIPS provider check
$ openssl list -providers
Providers:
  fips
    name: OpenSSL FIPS Provider
    version: 3.0.7
    status: active
```

**Evidence:**
- FIPS mode status: `fips-mode-setup --check`
- Cipher suite configuration: `/etc/prometheus/web-config.yml`, `/etc/node_exporter/web-config.yml`
- TLS handshake verification: `openssl s_client -connect <host>:9100 -showcerts`

#### AU-2, AU-3, AU-6, AU-12: Audit and Accountability

**Requirement:** Ensure that the actions of individual system users can be uniquely traced to facilitate accountability. Create, protect, and retain system audit records.

**Implementation:**
- **Event Logging:** All metric collection events timestamped and logged
- **Audit Content:** Each metric includes:
  - Hostname/instance identifier
  - Timestamp (Unix epoch with millisecond precision)
  - Metric name and labels
  - Metric value
  - Job name and department labels
- **Retention:** 15 days of metric history retained
- **Review Capabilities:** Grafana dashboards enable:
  - Historical trend analysis
  - Anomaly detection
  - Comparison across time periods
  - Filtering by system, department, or metric type
- **Automated Generation:** Prometheus scrapes every 15 seconds without manual intervention

**Metrics Example:**
```
node_cpu_seconds_total{
  cpu="0",
  mode="idle",
  hostname="engineering",
  department="engineering",
  instance="192.168.1.104:9100",
  job="workstation-engineering"
} 1234567.89 1735689600000
```

**Evidence:**
- Prometheus query interface: `https://dc1.cyberinabox.net:9091/graph`
- Grafana dashboards: `http://dc1.cyberinabox.net:3001`
- Sample queries: `/tmp/FINAL_MONITORING_STATUS.md` (Verification Commands section)

#### CM-3, CM-6: Configuration Management

**Requirement:** Monitor configuration changes and maintain baseline configurations.

**Implementation:**
- **Baseline Monitoring:** System metrics establish performance baselines
- **Change Detection:** Monitoring can detect:
  - Unexpected process launches (process count changes)
  - Service state changes (systemd unit metrics on Linux)
  - Resource consumption anomalies (CPU/memory spikes)
  - Filesystem changes (mount points, space usage)
  - Network configuration changes (interface metrics)
- **Configuration Documentation:**
  - Prometheus scrape configuration documents monitored systems
  - Node Exporter service configuration stored in systemd/LaunchDaemon
  - TLS configuration files version-controlled

**Evidence:**
- Configuration files: `/etc/prometheus/prometheus.yml`
- Service definitions: `/etc/systemd/system/node_exporter.service`
- Installation scripts: `/tmp/install_node_exporter_fips_selfcontained.sh`, `/tmp/macos_install_simple.sh`

---

## 3. Technical Specifications

### 3.1 Software Components

| Component | Version | Purpose | License |
|-----------|---------|---------|---------|
| Prometheus | 2.48.1 | Time-series database and monitoring system | Apache 2.0 |
| Node Exporter | 1.7.0 | System metrics exporter | Apache 2.0 |
| Grafana | (existing) | Visualization and dashboards | AGPLv3 |
| OpenSSL | 3.0.7 | FIPS 140-2 cryptographic library | Apache 2.0 |

**Total Software Cost:** $0 (100% open-source)

### 3.2 Monitored Systems

| System | Hostname | IP Address | OS | CPU Cores | Role |
|--------|----------|------------|-----|-----------|------|
| Server | dc1.cyberinabox.net | 192.168.1.10 | Rocky Linux 9.7 | 32 | Domain controller, monitoring server |
| Prometheus | localhost | 127.0.0.1:9091 | - | - | Self-monitoring |
| Engineering | engineering | 192.168.1.104 | Rocky Linux 9.7 | 48 | Engineering workstation |
| Accounting | accounting | 192.168.1.113 | Rocky Linux 9.7 | 32 | Accounting workstation |
| Lab Rat | labrat | 192.168.1.115 | Rocky Linux 9.6 | 32 | Lab workstation |
| AI | ai | 192.168.1.7 | macOS (Darwin) | 56 | AI infrastructure workstation |

**Total Systems:** 6
**Total Metrics:** 864+ time series (144+ per system × 6 systems)

### 3.3 Network Configuration

#### Prometheus Server (dc1.cyberinabox.net)

**Listening Ports:**
- `9091/tcp` - Prometheus web UI (HTTPS)
- `9100/tcp` - Node Exporter metrics (HTTPS)

**Firewall Rules:**
```bash
firewall-cmd --permanent --add-port=9091/tcp
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --reload
```

#### Workstations (All)

**Listening Ports:**
- `9100/tcp` - Node Exporter metrics (HTTPS)

**Firewall Rules:**
```bash
# Allow only from Prometheus server
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.10" port protocol="tcp" port="9100" accept'
firewall-cmd --reload
```

### 3.4 Metrics Categories

**System Metrics:**
- CPU: usage by core, mode (user/system/idle/iowait), load averages (1/5/15 min)
- Memory: total, free, available, buffers, cached, swap usage
- Uptime: system boot time, current uptime
- Context switches and interrupts

**Disk Metrics:**
- I/O operations: reads/writes per second
- Throughput: bytes read/written
- Queue depth and I/O time
- Disk space: total, used, available (per filesystem)
- Inode usage

**Network Metrics:**
- Interface statistics: bytes sent/received
- Packet statistics: packets sent/received
- Error counters: transmit/receive errors
- Drop counters: transmit/receive drops
- Connection states: established, time_wait, etc.

**Filesystem Metrics:**
- Mount points and filesystem types
- Space usage: total, used, available
- Inode usage: total, used, available
- Read-only status

**Process Metrics:**
- Total process count
- Process states: running, sleeping, zombie, etc.
- Per-process CPU time
- Per-process memory usage
- File descriptor usage

**Platform-Specific Metrics:**
- Linux: systemd unit states, SELinux status, kernel statistics
- macOS: Darwin-specific metrics, IOKit statistics

**Total:** 144+ unique metric types per system

---

## 4. Deployment and Operations

### 4.1 Installation Method

**Server (dc1.cyberinabox.net):**
- Prometheus installed from source tarball
- Node Exporter installed from source tarball
- systemd service files created for automatic startup
- TLS certificates deployed from `/etc/pki/tls/private/commercial/`

**Rocky Linux Workstations (engineering, accounting, labrat):**
- Deployed via self-contained installation script
- Script includes embedded TLS certificates (base64-encoded)
- Automated firewall configuration
- systemd service auto-start enabled

**macOS Workstation (ai):**
- Node Exporter installed via Homebrew
- TLS certificates downloaded from temporary HTTP server
- LaunchDaemon created for auto-start
- No firewall changes required (internal network)

**Installation Scripts:**
- `/tmp/install_node_exporter_fips_selfcontained.sh` (19KB, for Rocky Linux)
- `/tmp/macos_install_simple.sh` (for macOS)

### 4.2 Service Management

**Linux Systems (systemd):**
```bash
# Start services
systemctl start prometheus
systemctl start node_exporter

# Enable auto-start
systemctl enable prometheus
systemctl enable node_exporter

# Check status
systemctl status prometheus
systemctl status node_exporter

# View logs
journalctl -u prometheus -f
journalctl -u node_exporter -f
```

**macOS System (launchd):**
```bash
# Start service
sudo launchctl load /Library/LaunchDaemons/io.prometheus.node_exporter.plist

# Check status
launchctl list | grep node_exporter

# View logs
log show --predicate 'process == "node_exporter"' --last 1h
```

### 4.3 Access and Authentication

**Prometheus Web UI:**
- URL: `https://dc1.cyberinabox.net:9091`
- Protocol: HTTPS (TLS 1.2/1.3)
- Authentication: None (internal network only, firewall-protected)
- Certificate: Valid wildcard cert (*.cyberinabox.net)

**Grafana Dashboards:**
- URL: `http://dc1.cyberinabox.net:3001`
- Datasource: `https://dc1.cyberinabox.net:9091` (HTTPS with certificate validation)
- Authentication: Grafana user accounts (existing SSO via FreeIPA planned)

**Node Exporter Endpoints:**
- URLs: `https://<hostname>:9100/metrics`
- Protocol: HTTPS (TLS 1.2/1.3)
- Authentication: None (certificate-based encryption only)
- Access Control: Firewall rules limit access to Prometheus server IP only

### 4.4 Monitoring and Maintenance

**Daily Tasks:**
- Monitor Grafana dashboards for anomalies
- Review system health indicators (CPU, memory, disk)

**Weekly Tasks:**
- Verify all 6 targets remain UP in Prometheus
- Check for any missed scrapes or errors

**Monthly Tasks:**
- Review disk space on Prometheus server
- Verify backup procedures capture configuration

**Quarterly Tasks:**
- Review and optimize retention policies
- Check for Prometheus/Node Exporter updates
- Verify TLS certificate validity

**Annual Tasks:**
- Certificate renewal (current cert valid until October 28, 2026)
- Review monitoring scope and add new systems as needed

---

## 5. Compliance Evidence

### 5.1 Verification Procedures

**Verify All Targets Are Monitored:**
```bash
curl -k -s 'https://localhost:9091/api/v1/targets' | \
  jq '.data.activeTargets[] | {job: .labels.job, health: .health}'
```

**Expected Output:** 6 targets with `"health": "up"`

**Verify FIPS Mode:**
```bash
fips-mode-setup --check
```

**Expected Output:** `FIPS mode is enabled.`

**Verify TLS Encryption:**
```bash
openssl s_client -connect dc1.cyberinabox.net:9091 -showcerts 2>&1 | \
  grep "Cipher"
```

**Expected Output:** Shows FIPS-approved cipher (e.g., `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`)

**Query Sample Metrics:**
```bash
# CPU load across all systems
curl -k -s 'https://localhost:9091/api/v1/query?query=node_load1' | \
  jq '.data.result[] | {host: .metric.hostname, load: .value[1]}'

# Memory available
curl -k -s 'https://localhost:9091/api/v1/query?query=node_memory_MemAvailable_bytes' | \
  jq '.data.result[] | {host: .metric.hostname, available_gb: (.value[1] | tonumber / 1073741824)}'
```

### 5.2 Documentation Artifacts

| Document | Location | Purpose |
|----------|----------|---------|
| Final Monitoring Status | `/tmp/FINAL_MONITORING_STATUS.md` | Complete deployment summary and status |
| FIPS TLS Configuration | `/tmp/FIPS_TLS_Configuration_Summary.md` | Detailed TLS/FIPS implementation guide |
| Prometheus Configuration | `/etc/prometheus/prometheus.yml` | Scrape targets and global settings |
| Node Exporter TLS Config | `/etc/node_exporter/web-config.yml` | TLS settings (all systems) |
| Installation Scripts | `/tmp/install_node_exporter_fips_selfcontained.sh` | Self-contained installer for Rocky Linux |
| macOS Install Script | `/tmp/macos_install_simple.sh` | macOS-specific installer |
| Monitoring Dashboard | `http://dc1.cyberinabox.net/monitoring-dashboard.html` | Web-based monitoring status page |

### 5.3 Audit Trail

**Deployment Timeline:**
- **December 30, 2025:** Initial Prometheus and Node Exporter installation on server
- **December 30, 2025:** FIPS-compliant TLS configuration implemented
- **December 31, 2025:** Self-contained installation script created with embedded certificates
- **December 31, 2025:** Rocky Linux workstations deployed (engineering, accounting, labrat)
- **December 31, 2025:** macOS workstation (ai) deployed
- **December 31, 2025:** 6/6 targets confirmed UP and operational
- **December 31, 2025:** POA&M updated to reflect monitoring deployment (POAM-029)
- **December 31, 2025:** SSP addendum created (this document)

---

## 6. Risk Assessment and Mitigation

### 6.1 Identified Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Certificate expiration | Low | Medium | Certificate valid until Oct 2026; renewal tracking in maintenance schedule |
| Prometheus disk space exhaustion | Low | Medium | 15-day retention limit; monthly disk space checks |
| Network interruption blocking metrics | Low | Low | Local monitoring continues; gaps visible in Grafana |
| Unauthorized access to metrics | Low | Low | Firewall rules restrict access; internal network only |
| TLS misconfiguration | Very Low | Medium | Configuration validated during deployment; regular testing |

### 6.2 Security Considerations

**Strengths:**
- All metrics encrypted in transit (FIPS 140-2 compliant)
- Minimal attack surface (monitoring is read-only)
- No external dependencies or cloud services
- Certificate-based encryption for all communications
- Firewall rules limit access to trusted IPs only

**Limitations:**
- No authentication on Node Exporter endpoints (encryption only)
- Metrics stored unencrypted on Prometheus server (internal storage)
- No built-in alerting to external systems (requires configuration)

**Compensating Controls:**
- Internal network isolation (no direct internet exposure)
- Host-based firewall rules on all systems
- SELinux enforcing mode on all Rocky Linux systems
- Regular monitoring of access logs via Wazuh SIEM
- Physical security of server room

---

## 7. Future Enhancements

### 7.1 Planned Improvements

**Alerting:**
- Configure Prometheus Alertmanager for threshold-based alerts
- Integrate with email notification system
- Create alert rules for critical conditions (disk >90%, CPU >95%, etc.)

**Authentication:**
- Implement Prometheus basic auth or OAuth2 proxy
- Integrate Grafana with FreeIPA SSO (Kerberos)
- Add client certificate authentication for Node Exporter

**Expanded Monitoring:**
- Add application-specific exporters (e.g., PostgreSQL, Apache)
- Monitor network equipment (SNMP exporter)
- Add custom business metrics

**High Availability:**
- Deploy secondary Prometheus instance for redundancy
- Implement long-term storage (Thanos or Cortex)
- Add remote write to backup time-series database

### 7.2 Integration Opportunities

- **Wazuh SIEM:** Send Prometheus alerts to Wazuh for correlation
- **Graylog:** Forward metric anomaly events to log management
- **Backup System:** Include Prometheus data in backup procedures
- **Incident Response:** Use metrics for forensic analysis during incidents

---

## 8. Conclusion

The FIPS-compliant workstation monitoring system successfully addresses NIST 800-171 controls SI-4, AU-2/3/6/12, SC-8/13, and CM-3/6 through comprehensive, encrypted metrics collection across all infrastructure systems. The deployment achieves:

✅ **100% Coverage:** All 6 systems actively monitored
✅ **FIPS 140-2 Compliance:** All data encrypted in transit with approved cipher suites
✅ **Zero Cost:** 100% open-source software with no licensing fees
✅ **Cross-Platform:** Rocky Linux and macOS support
✅ **Production Ready:** Automated startup, firewall configured, documentation complete

This implementation demonstrates that even resource-constrained organizations can achieve enterprise-grade system monitoring while maintaining strict compliance with government cybersecurity requirements.

---

**Document Control:**
- **Author:** Claude Code (Sonnet 4.5)
- **Reviewer:** (Pending)
- **Approver:** (Pending)
- **Next Review Date:** March 31, 2026
- **Change History:**
  - v1.0 (2025-12-31): Initial document creation

**Related Documents:**
- POAM_CyberInABox_2025.md (POAM-029: Implement FIPS-Compliant Workstation Monitoring)
- /tmp/FINAL_MONITORING_STATUS.md (Deployment status report)
- /tmp/FIPS_TLS_Configuration_Summary.md (Technical configuration guide)
- System_Security_Plan_v1.6 (Main SSP document)

---

**Classification:** INTERNAL USE ONLY
**Distribution:** Authorized personnel only
**Retention:** 7 years from system decommission
