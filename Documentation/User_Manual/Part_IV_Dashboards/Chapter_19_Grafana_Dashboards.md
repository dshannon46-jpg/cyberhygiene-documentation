# Chapter 19: System Health Dashboards (Grafana)

## 19.1 Grafana Dashboard Access

### Accessing Grafana

**URL:** https://grafana.cyberinabox.net

**Login:**
1. Navigate to the Grafana URL
2. Enter your username and password
3. Complete MFA challenge if prompted
4. Click "Sign In"

**Dashboard Overview:**
Grafana provides real-time and historical system health metrics across all monitored systems.

**Available Dashboards:**
- Node Exporter Full - System resources (CPU, memory, disk, network)
- Suricata IDS/IPS - Network security metrics
- YARA Malware Detection - Malware detection events

### Navigation

**Main Menu** (left sidebar):
- Home - Dashboard list
- Explore - Ad-hoc queries
- Alerting - Alert rules and notifications  
- Configuration - Data sources and settings

**Time Range Selector** (top right):
- Last 5 minutes
- Last 15 minutes  
- Last 1 hour
- Last 24 hours
- Custom range

**Refresh** (top right):
- Auto-refresh intervals (5s, 10s, 30s, 1m, 5m)
- Manual refresh button

## 19.2 Node Exporter Dashboard

**Purpose:** Monitor system health for all 6 systems in the network

**Access:** Grafana Home → "Node Exporter Full"

### CPU and Memory Metrics

**CPU Usage:**
- Shows current CPU utilization per core
- Historical trends over selected time range
- Alerts when CPU exceeds 80%

**What to Look For:**
- ✅ Normal: 0-60% average load
- ⚠️ Caution: 60-80% sustained load
- 🔴 Critical: >80% sustained load

**Memory Usage:**
- Total memory available
- Used vs. free memory
- Cache and buffer usage
- Swap utilization

**What to Look For:**
- ✅ Normal: <70% memory used
- ⚠️ Caution: 70-85% memory used
- 🔴 Critical: >85% memory used or swap in use

**Example Interpretation:**
```
System: dc1.cyberinabox.net
CPU: 45% (4 cores, load average: 3.3)
Memory: 57% used (8GB total, 3.4GB free)
Status: ✅ Normal operation
```

### Disk Usage and I/O

**Disk Space Metrics:**
- Filesystem capacity per mount point
- Used vs. available space
- Growth trends

**What to Look For:**
- ✅ Normal: <70% disk used
- ⚠️ Caution: 70-85% disk used
- 🔴 Critical: >85% disk used

**Disk I/O Metrics:**
- Read/write operations per second
- I/O wait time
- Disk throughput (MB/s)

**Example:**
```
Filesystem: / (root)
Capacity: 500GB
Used: 180GB (36%)
Available: 320GB
Status: ✅ Healthy
```

### Network Statistics

**Network Interface Metrics:**
- Bandwidth usage (inbound/outbound)
- Packet rates
- Error rates
- Interface status

**What to Monitor:**
- Sustained high bandwidth (may indicate attack or large transfer)
- Packet errors (hardware issues)
- Unusual traffic patterns

**Example:**
```
Interface: eno1
RX: 125 Mbps (normal web traffic)
TX: 45 Mbps (outbound responses)
Errors: 0
Status: ✅ Normal
```

### System Performance

**Load Average:**
- 1-minute, 5-minute, 15-minute averages
- Number of processes waiting for CPU

**Rule of Thumb:**
- Load should be < number of CPU cores
- Example: 4-core system, load of 3.5 is normal
- Load of 8.0 on 4-core system = overloaded

**Process Metrics:**
- Total processes
- Running processes
- Blocked processes
- Zombie processes (should be 0)

## 19.3 Suricata Metrics Dashboard

**Purpose:** Monitor network intrusion detection/prevention system

**Access:** Grafana Home → "Suricata IDS/IPS Security Monitoring"

### Packet Processing Statistics

**Total Packets Processed:**
- Running total of packets analyzed by Suricata
- Current: ~8.8 million packets
- Indicates system uptime and traffic volume

**Packet Processing Rate:**
- Packets per second being analyzed
- Should match network traffic volume
- Drops indicate performance issues

**Bytes Processed:**
- Total data volume analyzed
- Current: ~4.8 GB
- Useful for capacity planning

### Protocol Analysis

**Protocol Distribution:**
- HTTP flows
- TLS/SSL flows
- DNS queries (UDP and TCP)
- SSH connections
- Other protocols

**Current Statistics:**
```
TLS Flows: 56,274 (encrypted web traffic)
DNS Queries: 104,233 (name resolution)
HTTP Flows: 92 (unencrypted web)
SSH: 58 (remote connections)
```

**What This Tells Us:**
- High TLS = Encrypted web traffic (good!)
- Low HTTP = Most traffic encrypted (secure)
- DNS volume = Normal name lookups

### Alert Statistics

**Total Alerts:**
- Running count of security alerts
- Current: 502 alerts detected

**Alert Severity Breakdown:**
1. High (Severity 1): Critical threats
2. Medium (Severity 2): Moderate threats  
3. Low (Severity 3): Informational

**Alert Rate:**
- Alerts per hour/day
- Trend analysis
- Spike detection

**What to Look For:**
- ⚠️ Sudden spike in alerts (possible attack)
- ✅ Steady low rate (normal operations)
- 🔴 High severity alerts (investigate immediately)

### Flow Statistics

**Application Layer Flows:**
Shows protocol-specific connection stats

**Failed Connections:**
- TCP connections that failed to establish
- UDP connections that failed
- May indicate scanning or misconfiguration

**Example:**
```
Failed TCP Flows: 27,036
Failed UDP Flows: 3,710
Reason: Port scanning attempts blocked
Action: Automatically blocked by firewall
```

### Kernel Statistics

**Capture Performance:**
- Packets received by kernel
- Packets dropped by kernel
- Current: 8,834,006 received, 2,577 dropped (0.03%)

**What to Look For:**
- <1% packet drops = Normal
- >5% packet drops = Performance issue
- Investigate if drops increase

## 19.4 YARA Malware Detection Dashboard

**Purpose:** Monitor malware detection events

**Access:** Grafana Home → "YARA Malware Detection"

### Detection Events

**Detections Over Time:**
- Timeline of malware detections
- Currently: 0 detections (✅ Clean system!)

**What "0 Detections" Means:**
- ✅ No malware found in scanned files
- ✅ System is clean
- ✅ YARA rules are active and scanning

### Malware Signatures

**Active YARA Rules:**
- Number of malware signatures loaded
- Rule update timestamp
- Coverage (file types scanned)

**Detection by Type:**
When detections occur, shows:
- Malware family
- File location
- Detection timestamp
- Remediation status

### Scan Results

**Files Scanned:**
- Total files checked
- Scan frequency
- File types analyzed

**Scan Performance:**
- Scan duration
- Files per second
- Resource usage

### Alert Workflow

**If Detection Occurs:**
1. 🔴 Immediate alert to security dashboard
2. 📧 Email notification to security team
3. 🔒 Automatic file quarantine
4. 📝 Incident ticket created
5. 🔍 Forensic analysis initiated

**Your Actions:**
1. Do not access the detected file
2. Do not delete any files
3. Contact security team immediately
4. Document what you were doing when detected
5. Follow security team instructions

## 19.5 Custom Dashboards

### Creating Custom Views

**For Administrators:**
1. Navigate to Grafana → Create → Dashboard
2. Add Panel
3. Select data source (Prometheus)
4. Build query using PromQL
5. Configure visualization
6. Save dashboard

**Useful Custom Queries:**

**CPU by System:**
```promql
100 - (avg by (hostname) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Memory Available:**
```promql
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100
```

**Disk Free Space:**
```promql
(node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100
```

### Sharing Dashboards

**Export Dashboard:**
1. Open dashboard
2. Click share icon (top right)
3. Select "Export"
4. Save JSON file

**Import Dashboard:**
1. Grafana → Create → Import
2. Upload JSON file
3. Select data source
4. Import

### Alerting

**Configure Alerts:**
1. Edit dashboard panel
2. Alert tab
3. Create alert rule
4. Set thresholds
5. Configure notifications

**Example Alert:**
```
Alert: High CPU Usage
Condition: CPU > 80% for 5 minutes
Notify: Email to admins
Action: Investigation required
```

---

**Related Chapters:**
- Chapter 16: CPM Dashboard Overview
- Chapter 17: Wazuh Security Monitoring
- Chapter 18: Suricata Network Security
- Appendix B: Service URLs

**For More Information:**
- Grafana documentation: https://grafana.com/docs/
- Prometheus query language: https://prometheus.io/docs/prometheus/latest/querying/basics/

