# Chapter 16: Overview Dashboard (CPM)

## 16.1 CPM Dashboard Access

### What is the CPM Dashboard?

**CPM (CyberHygiene Project Management)** Dashboard is the **central overview dashboard** for the entire CyberHygiene Production Network.

**Purpose:**
- Single-pane view of system status
- Compliance monitoring at-a-glance
- Quick access to all dashboards and services
- Service health indicators
- Performance overview

**Who Should Use:**
- **Executives:** High-level status and compliance view
- **Managers:** Service availability and team performance
- **Administrators:** Quick health check before detailed diagnostics
- **Users:** Access point to other dashboards

### Accessing the Dashboard

**URL:** https://cpm.cyberinabox.net

**Login Procedure:**
1. Navigate to dashboard URL
2. Enter your username and password
3. Complete MFA challenge (if prompted)
4. Dashboard loads automatically

**Access Levels:**
- **Read-Only:** All users (default)
- **Dashboard Admin:** Administrators (can configure)
- **Full Admin:** System administrators (all features)

### Dashboard Layout

**Header Section:**
- CyberHygiene Project logo
- Current user (logged in as)
- Current date/time
- System status indicator
- Notifications icon

**Main Content Area:**
- System Overview (left panel)
- Compliance Status (center panel)
- Service Health (right panel)
- Quick Links (bottom section)

**Footer:**
- Version information
- Last updated timestamp
- Contact information
- Help/Support link

## 16.2 System Status Indicators

### Overall System Status

**Status Display:**
Located prominently at top of dashboard

**Status Levels:**

#### 🟢 **Green - Operational**
```
✅ All Systems Operational
Last checked: 2 minutes ago
```
**Meaning:**
- All services running normally
- No critical alerts
- All monitoring targets UP
- Performance within normal range

**Actions:**
- None required
- Continue normal operations

#### 🟡 **Yellow - Degraded**
```
⚠️ System Performance Degraded
Issue: High disk usage on dms.cyberinabox.net
Last checked: 1 minute ago
```
**Meaning:**
- One or more non-critical issues
- Services still functional
- Performance may be impacted
- Attention needed soon

**Actions:**
- Review issue details
- Plan remediation
- Monitor for escalation

#### 🔴 **Red - Critical**
```
🔴 Critical System Alert
Issue: Wazuh service down on wazuh.cyberinabox.net
Last checked: 30 seconds ago
```
**Meaning:**
- Critical service failure
- Security monitoring may be impaired
- Immediate attention required

**Actions:**
- Investigate immediately
- Follow incident response procedures
- Contact on-call administrator

#### ⚪ **Gray - Unknown**
```
❓ Status Unknown
Issue: Monitoring system unreachable
Last checked: 10 minutes ago
```
**Meaning:**
- Cannot determine system status
- Monitoring failure
- Possible network issue

**Actions:**
- Check network connectivity
- Verify monitoring system status
- Contact administrator if persistent

### Individual System Status

**System Health Grid:**

| System | Status | CPU | Memory | Disk | Network |
|--------|--------|-----|--------|------|---------|
| **dc1** | 🟢 UP | 23% | 41% | 36% | Normal |
| **dms** | 🟢 UP | 15% | 28% | 72% | Normal |
| **graylog** | 🟢 UP | 34% | 68% | 45% | Normal |
| **proxy** | 🟢 UP | 47% | 71% | 38% | High |
| **monitoring** | 🟢 UP | 19% | 39% | 42% | Normal |
| **wazuh** | 🟢 UP | 28% | 52% | 51% | Normal |

**Resource Thresholds:**
- ✅ **Green:** 0-70% utilization (normal)
- ⚠️ **Yellow:** 70-85% utilization (caution)
- 🔴 **Red:** 85-100% utilization (critical)

**Network Status:**
- **Normal:** Baseline traffic patterns
- **High:** Elevated traffic (not necessarily bad)
- **Alert:** Unusual patterns or errors

### Uptime Statistics

**Current Uptime:**
```
System Uptime: 47 days, 12 hours, 34 minutes
Monitoring Uptime: 99.98%
Service Availability: 99.95%
```

**Uptime Targets:**
- **Production Services:** 99.9% uptime (8.7 hours downtime/year)
- **Monitoring:** 99.95% uptime
- **Planned Maintenance:** Excluded from calculations

**Availability Over Time:**
- Last 24 hours: 100%
- Last 7 days: 99.99%
- Last 30 days: 99.95%
- Last 90 days: 99.92%

## 16.3 Compliance Metrics

### NIST 800-171 Compliance Status

**Overall Compliance:**
```
🎯 NIST 800-171 Compliance: 100%
110 of 110 controls implemented
POA&M Status: 100% Complete (29/29 items)
```

**Compliance Dashboard Visualization:**
- Progress bar showing percentage
- Control family breakdown
- Last assessment date
- Next assessment due date

### Control Family Status

**Control Implementation Summary:**

| Control Family | Total Controls | Implemented | Status |
|----------------|----------------|-------------|--------|
| Access Control (AC) | 22 | 22 | ✅ 100% |
| Awareness & Training (AT) | 3 | 3 | ✅ 100% |
| Audit & Accountability (AU) | 9 | 9 | ✅ 100% |
| Configuration Management (CM) | 9 | 9 | ✅ 100% |
| Identification & Auth (IA) | 11 | 11 | ✅ 100% |
| Incident Response (IR) | 4 | 4 | ✅ 100% |
| Maintenance (MA) | 6 | 6 | ✅ 100% |
| Media Protection (MP) | 8 | 8 | ✅ 100% |
| Physical Protection (PE) | 6 | 6 | ✅ 100% |
| Recovery (RE) | 5 | 5 | ✅ 100% |
| Risk Assessment (RA) | 3 | 3 | ✅ 100% |
| Security Assessment (CA) | 9 | 9 | ✅ 100% |
| System & Comm Protection (SC) | 21 | 21 | ✅ 100% |
| System & Info Integrity (SI) | 16 | 16 | ✅ 100% |

**Click any control family** to view:
- Detailed control implementations
- Evidence documentation
- Last verification date
- Responsible personnel

### POA&M Dashboard

**Plan of Action & Milestones:**
```
📋 POA&M Status
Total Items: 29
Completed: 29 (100%)
In Progress: 0
Not Started: 0
```

**Phase I Achievement:**
- All 29 POA&M items completed December 2025
- Zero outstanding items
- All controls implemented and verified

**Recent Completions:**
- POAM-029: Deploy monitoring dashboard (Grafana) - ✅ Completed 12/15/2025
- POAM-028: Enable FIPS mode system-wide - ✅ Completed 12/10/2025
- POAM-027: Implement file integrity monitoring - ✅ Completed 12/08/2025

### Audit Readiness

**Audit Preparation Status:**
```
🔍 Audit Readiness: READY
Evidence Collection: 100%
Documentation: Complete
Control Testing: Current
Last Assessment: December 2025
Next Assessment: March 2026
```

**Evidence Available:**
- ✅ Control implementation documentation
- ✅ System configuration baselines
- ✅ Security logs (12-month retention)
- ✅ Compliance monitoring reports
- ✅ User training records
- ✅ Incident response documentation

## 16.4 Service Health

### Core Service Status

**Infrastructure Services:**

```
🟢 FreeIPA (Identity Management)
   Status: Running
   Users: 23 active accounts
   Last sync: 2 minutes ago
   Next cert renewal: 45 days

🟢 Kerberos (Authentication)
   Status: Running
   Active tickets: 12
   KDC availability: 100%

🟢 DNS (Name Resolution)
   Status: Running
   Queries/sec: 45
   Response time: 2ms average

🟢 DHCP (Network Addressing)
   Status: Running
   Leases: 18/50
   Pool utilization: 36%
```

**Security Services:**

```
🟢 Wazuh (SIEM)
   Status: Running
   Agents: 6/6 connected
   Events/sec: 127
   Alerts: 2 (last hour)

🟢 Suricata (IDS/IPS)
   Status: Running
   Packets processed: 8.8M
   Alerts: 502 total
   Current throughput: 125 Mbps

🟢 YARA (Malware Detection)
   Status: Running
   Files scanned: 1.2M
   Detections: 0
   Rules loaded: 450

🟢 ClamAV (Antivirus)
   Status: Running
   Signatures: 8.6M
   Last update: 2 hours ago
```

**Monitoring Services:**

```
🟢 Prometheus (Metrics)
   Status: Running
   Targets: 7/7 UP
   Data retention: 15 days
   Storage: 245 GB used

🟢 Grafana (Dashboards)
   Status: Running
   Dashboards: 3 active
   Active users: 4
   Last refresh: 15 seconds ago

🟢 Graylog (Logs)
   Status: Running
   Messages/sec: 89
   Index size: 487 GB
   Retention: 90 days
```

### Service Dependencies

**Dependency Map:**

```
[FreeIPA] ← All services depend on this
   ↓
[DNS] ← Name resolution for all services
   ↓
[Kerberos] ← Authentication for all services
   ↓
[Individual Services] (Wazuh, Grafana, etc.)
```

**If FreeIPA is Down:**
- 🔴 All authentication fails
- 🔴 Services cannot verify users
- 🔴 Dashboards inaccessible
- **Critical Priority:** Restore immediately

**If Prometheus is Down:**
- ⚠️ No new metrics collected
- ⚠️ Grafana shows stale data
- ✅ Services continue operating
- **Priority:** Restore within 1 hour

## 16.5 Performance Overview

### System Performance Metrics

**Aggregate Performance:**

```
📊 Network Performance
Total Throughput: 347 Mbps
Peak: 892 Mbps (2:15 PM)
Average: 245 Mbps
Errors: 0.02%

💾 Storage Performance
Total Capacity: 5.2 TB
Used: 1.8 TB (35%)
Available: 3.4 TB (65%)
Growth Rate: 12 GB/week

🖥️ Compute Performance
Average CPU: 28%
Peak CPU: 64% (proxy system)
Memory: 47% average
Swap Usage: 0% (excellent)
```

### Performance Trends

**7-Day Performance Summary:**

**CPU Utilization:**
```
Mon: 25% avg (🟢 Normal)
Tue: 31% avg (🟢 Normal)
Wed: 28% avg (🟢 Normal)
Thu: 33% avg (🟢 Normal)
Fri: 42% avg (🟢 Normal - backup day)
Sat: 19% avg (🟢 Low - weekend)
Sun: 17% avg (🟢 Low - weekend)
```

**Network Traffic:**
```
Peak Hours: 9 AM - 5 PM (business hours)
Off-Peak: 6 PM - 8 AM (minimal traffic)
Weekend: 20% of weekday traffic
Baseline: 200-300 Mbps during business hours
```

**Storage Growth:**
```
Week 1: 1.73 TB
Week 2: 1.75 TB (+20 GB)
Week 3: 1.77 TB (+20 GB)
Week 4: 1.80 TB (+30 GB - log retention cleanup pending)
```

### Quick Action Buttons

**Dashboard Quick Links:**

```
[🔍 View Wazuh SIEM] → https://wazuh.cyberinabox.net
[📊 View Grafana Dashboards] → https://grafana.cyberinabox.net
[📝 View Graylog Logs] → https://graylog.cyberinabox.net
[👥 Manage Users (FreeIPA)] → https://dc1.cyberinabox.net
[🌐 Project Website] → https://cyberhygiene.cyberinabox.net
[📧 Email (Roundcube)] → https://mail.cyberinabox.net
```

**Administrative Actions:**
- [🔄 Restart Service] - Restart a specific service
- [🔍 View Logs] - Quick log viewer
- [📊 Generate Report] - Compliance/status report
- [⚙️ Configuration] - Dashboard settings
- [❓ Help/Support] - Documentation and support

---

**CPM Dashboard Summary:**

| Feature | Description | Update Frequency |
|---------|-------------|------------------|
| **System Status** | Overall health indicator | Real-time (30 sec) |
| **Compliance Metrics** | NIST 800-171, POA&M status | Daily |
| **Service Health** | Individual service status | Real-time (1 min) |
| **Performance** | Resource utilization trends | Real-time (15 sec) |
| **Quick Links** | Access to all dashboards | Static |

**Dashboard Refresh Rate:**
- System status: 30 seconds
- Service health: 1 minute
- Performance metrics: 15 seconds
- Compliance data: 24 hours
- Auto-refresh: Enabled by default

**Alerting from CPM:**
- Critical alerts: Email + dashboard notification
- Warning alerts: Dashboard notification only
- Info alerts: Logged, no notification
- Alert history: Last 30 days visible

---

**Related Chapters:**
- Chapter 17: Security Monitoring (Wazuh)
- Chapter 19: System Health (Grafana)
- Chapter 20: Compliance Status (POA&M)
- Chapter 21: Log Analysis (Graylog)
- Chapter 41: POA&M Status (detailed)

**For More Information:**
- CPM Dashboard: https://cpm.cyberinabox.net
- User documentation: Part II, Chapter 10 (Getting Help)
- Administrative guide: Part VI, Chapter 28 (Monitoring Configuration)
