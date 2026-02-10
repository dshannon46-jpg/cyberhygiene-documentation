# Chapter 42: Audit & Accountability

## 42.1 Audit Framework Overview

### Purpose and Scope

**Audit and Accountability Program:**
```
Purpose:
  - Create audit records to enable monitoring and investigation
  - Ensure actions can be traced to specific individuals
  - Detect unauthorized or suspicious activities
  - Support incident investigation and forensics
  - Demonstrate compliance with security requirements
  - Provide evidence for accountability

Scope:
  - All systems in the CyberHygiene network (6 servers)
  - All user accounts and activities
  - All administrative actions
  - All security-relevant events
  - Network traffic and connections
  - Application-level events
  - System changes and configurations

Regulatory Basis:
  - NIST 800-171 family 3.3 (Audit and Accountability)
  - FISMA audit requirements
  - DFARS compliance
  - Industry best practices
```

### NIST 800-171 Audit Requirements

**Control Family 3.3: Audit and Accountability**
```
3.3.1: Create and retain system audit logs
  Status: ✓ Implemented
  Implementation: Auditd, rsyslog, centralized to Graylog

3.3.2: Ensure actions can be traced to individuals
  Status: ✓ Implemented
  Implementation: User authentication, unique identifiers

3.3.3: Review and update logged events
  Status: ✓ Implemented
  Implementation: Monthly rule reviews, continuous improvement

3.3.4: Alert on audit logging process failures
  Status: ✓ Implemented
  Implementation: Wazuh monitoring, disk space alerts

3.3.5: Correlate audit records across systems
  Status: ✓ Implemented
  Implementation: Graylog centralized correlation

3.3.6: Provide audit reduction and report generation
  Status: ✓ Implemented
  Implementation: Graylog dashboards, search, and filters

3.3.8: Protect audit information and tools
  Status: ✓ Implemented
  Implementation: Access controls, encryption, SELinux

3.3.9: Limit audit log management to authorized personnel
  Status: ✓ Implemented
  Implementation: Admin-only access, RBAC enforcement
```

## 42.2 Audit Logging Implementation

### System-Level Auditing (Auditd)

**Linux Audit Daemon Configuration:**
```bash
# /etc/audit/auditd.conf
log_file = /var/log/audit/audit.log
log_format = ENRICHED
log_group = root
priority_boost = 4
flush = INCREMENTAL_ASYNC
freq = 50
num_logs = 5
max_log_file = 100
max_log_file_action = ROTATE
space_left = 500
space_left_action = EMAIL
admin_space_left = 100
admin_space_left_action = SINGLE
disk_full_action = SUSPEND
disk_error_action = SUSPEND
tcp_listen_queue = 5
tcp_max_per_addr = 1
use_libwrap = yes
##tcp_client_ports = 1024-65535
tcp_client_max_idle = 0
enable_krb5 = no
krb5_principal = auditd
name_format = HOSTNAME
```

**Key Audit Rules:**
```bash
# Authentication events
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /var/log/lastlog -p wa -k logins

# Network configuration changes
-a always,exit -F arch=b64 -S sethostname,setdomainname -k network
-w /etc/hosts -p wa -k network
-w /etc/sysconfig/network-scripts/ -p wa -k network

# Time changes
-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time_change
-w /etc/localtime -p wa -k time_change

# User/group management
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/userdel -p x -k user_modification

# Sudo usage
-w /etc/sudoers -p wa -k sudoers
-w /etc/sudoers.d/ -p wa -k sudoers
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/sudo -k sudo_usage

# File access attempts (permission denied)
-a always,exit -F arch=b64 -S open,openat -F exit=-EACCES -k access
-a always,exit -F arch=b64 -S open,openat -F exit=-EPERM -k access

# Privileged commands
-a always,exit -F path=/usr/bin/passwd -F perm=x -F auid>=1000 -F auid!=unset -k privileged
-a always,exit -F path=/usr/bin/su -F perm=x -F auid>=1000 -F auid!=unset -k privileged
-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=unset -k privileged

# File deletions
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=unset -k delete

# Kernel module operations
-w /usr/sbin/insmod -p x -k modules
-w /usr/sbin/rmmod -p x -k modules
-w /usr/sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module,delete_module -k modules

# Mount operations
-a always,exit -F arch=b64 -S mount,umount2 -k mounts
```

**Audit Log Format:**
```
Example Audit Record:
type=SYSCALL msg=audit(1735689600.123:456789): arch=c000003e syscall=257 success=yes exit=3 a0=ffffff9c a1=7fffc8b12345 a2=0 a3=0 items=1 ppid=12345 pid=12346 auid=1001 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=123 comm="cat" exe="/usr/bin/cat" key="access"

Fields Explained:
  - type: Event type (SYSCALL, USER_AUTH, etc.)
  - msg: Timestamp and sequence number
  - auid: Audit user ID (original login user)
  - uid/gid: Current user/group ID
  - ppid/pid: Parent and process IDs
  - comm/exe: Command name and executable path
  - key: Audit rule key for filtering
  - success: yes/no (operation result)
```

### Application Logging

**Service-Specific Logging:**
```
SSH (sshd):
  Location: /var/log/secure
  Events: Login attempts, key usage, sessions
  Format: Syslog
  Destination: Local + Graylog

FreeIPA (httpd, dirsrv, krb5kdc):
  Locations:
    - /var/log/httpd/ (web access and errors)
    - /var/log/dirsrv/ (LDAP operations)
    - /var/log/krb5kdc.log (Kerberos authentication)
    - /var/log/kadmin.log (Kerberos administration)
    - /var/log/ipaserver-install.log (installation)
  Events: Authentication, authorization, admin actions
  Destination: Local + Graylog

Wazuh:
  Locations:
    - /var/ossec/logs/ossec.log (manager log)
    - /var/ossec/logs/alerts/alerts.log (security alerts)
    - /var/ossec/logs/archives/ (all events)
  Events: Agent connections, rule matches, alerts
  Destination: Local + Graylog + Wazuh Dashboard

Graylog:
  Locations:
    - /var/log/graylog-server/server.log
    - /var/log/elasticsearch/ (index operations)
    - /var/log/mongodb/ (metadata operations)
  Events: Log ingestion, searches, user actions
  Destination: Local (self-referential)

Prometheus/Grafana:
  Locations:
    - /var/log/prometheus/prometheus.log
    - /var/log/grafana/grafana.log
  Events: Metric scrapes, queries, dashboard access
  Destination: Local + Graylog

Apache/Nginx:
  Locations:
    - /var/log/httpd/access_log (HTTP requests)
    - /var/log/httpd/error_log (HTTP errors)
    - /var/log/httpd/ssl_access_log (HTTPS requests)
    - /var/log/nginx/access.log
    - /var/log/nginx/error.log
  Format: Combined log format
  Destination: Local + Graylog

Suricata:
  Locations:
    - /var/log/suricata/fast.log (alerts)
    - /var/log/suricata/eve.json (detailed events)
    - /var/log/suricata/stats.log (statistics)
  Events: Network threats, anomalies, traffic analysis
  Destination: Local + Graylog + Wazuh
```

### Centralized Log Collection

**Graylog Architecture:**
```
Input Methods:
  1. Syslog UDP (port 514)
     - Default syslog receiver
     - Unreliable but low overhead
     - Used for non-critical logs

  2. Syslog TCP (port 1514)
     - Reliable delivery
     - Used for security-critical logs
     - Guaranteed message delivery

  3. GELF (port 12201)
     - Graylog Extended Log Format
     - Structured JSON messages
     - Rich metadata support

Log Flow:
  System → rsyslog → Graylog input → Processing → Elasticsearch → Dashboard

Rsyslog Configuration:
  # /etc/rsyslog.d/graylog.conf

  # Send all logs to Graylog via TCP
  *.* @@graylog.cyberinabox.net:1514;RSYSLOG_SyslogProtocol23Format

  # Local logging still enabled
  *.info;mail.none;authpriv.none;cron.none /var/log/messages
  authpriv.* /var/log/secure
  mail.* /var/log/maillog
  cron.* /var/log/cron

Processing Pipeline:
  1. Input stage: Receive log message
  2. Extractors: Parse fields from message
  3. Pipeline rules: Enrich, transform, route
  4. Stream routing: Categorize by type
  5. Index: Store in Elasticsearch
  6. Alert conditions: Check for alerts
  7. Output: Forward if needed
```

## 42.3 Log Review and Analysis

### Daily Log Review

**Daily Security Review Procedures:**
```
Performed By: System Administrator
Frequency: Daily (morning)
Time Required: 15-30 minutes

Review Steps:
  1. Check Grafana CPM Dashboard
     - System health status
     - Alert summary (last 24 hours)
     - Unusual metric spikes

  2. Review Wazuh Dashboard
     - New security alerts (level 7+)
     - Agent status (all green?)
     - Compliance status
     - Vulnerability detections

  3. Check Graylog
     - SSH authentication failures
     - Sudo usage (unauthorized?)
     - System errors and warnings
     - Unusual network activity

  4. Review Suricata Alerts
     - IDS alerts from last 24 hours
     - Blocked connections
     - Signature matches
     - False positive assessment

  5. Check Backup Status
     - Last backup completion
     - Any backup failures
     - Disk space for backups

Items to Investigate:
  - Repeated authentication failures (>5 attempts)
  - Unexpected sudo usage
  - New user/group creation
  - Configuration file changes
  - Unusual network connections
  - High severity Wazuh alerts
  - Service failures or restarts
  - Disk space warnings (<20%)
  - Certificate expiration warnings (<30 days)

Documentation:
  - Log review completion noted
  - Any findings documented
  - Actions taken recorded
  - Escalation if needed
```

### Weekly Analysis

**Weekly Security Analysis:**
```
Performed By: Security Officer
Frequency: Weekly (Friday afternoon)
Time Required: 1-2 hours

Analysis Tasks:
  1. Trend Analysis
     - Authentication failure trends
     - Alert volume trends
     - System performance trends
     - Network traffic patterns

  2. User Activity Review
     - New user accounts created
     - Privilege changes
     - Unusual access patterns
     - Failed access attempts

  3. Configuration Changes
     - System configuration changes (git log)
     - Service configuration updates
     - Firewall rule changes
     - AIDE integrity findings

  4. Compliance Status
     - Audit log collection rate (should be 100%)
     - Security patch status
     - Backup success rate (should be >99%)
     - Certificate status

  5. Incident Review
     - Any incidents occurred
     - Response effectiveness
     - Lessons learned
     - Process improvements

Deliverables:
  - Weekly security summary email
  - Metrics dashboard screenshot
  - Action items identified
  - Trend graphs for management

Tools Used:
  - Graylog saved searches
  - Grafana dashboard exports
  - Wazuh reporting module
  - Custom analysis scripts
```

### Monthly Compliance Review

**Monthly Compliance Assessment:**
```
Performed By: Security Officer + Management
Frequency: Monthly (first week of month)
Time Required: 2-4 hours

Review Agenda:
  1. NIST 800-171 Compliance Status
     - All 110 controls status
     - Any new POA&M items
     - Existing POA&M progress
     - Compliance percentage

  2. Security Metrics
     - Vulnerability count and severity
     - Patch compliance percentage
     - Incident count and MTTR
     - Authentication failure rate
     - Backup success rate
     - System availability

  3. Audit Log Review
     - Log collection completeness
     - Log retention compliance
     - Storage utilization
     - Archival procedures

  4. Access Control Review
     - Active user accounts
     - Privileged account usage
     - Dormant accounts (>90 days)
     - Access violations

  5. Risk Assessment Update
     - New threats identified
     - Vulnerability trends
     - Risk posture changes
     - Mitigation status

  6. Policy Compliance
     - Policy violations
     - Training completion
     - Acceptable use compliance
     - Password policy adherence

Deliverables:
  - Monthly compliance report
  - Metrics dashboard
  - Management briefing
  - Action plan for next month

Documentation:
  - Meeting minutes
  - Decisions and approvals
  - Compliance evidence collected
  - Retained in /datastore/compliance/
```

## 42.4 Log Retention and Protection

### Retention Requirements

**Log Retention Policy:**
```
Retention Periods:

Hot Storage (Graylog/Elasticsearch):
  - Duration: 90 days
  - Location: /var/lib/elasticsearch/
  - Format: Indexed, searchable
  - Performance: Fast queries
  - Size: ~3 TB (100 GB/day compressed)

Warm Storage (Compressed Archives):
  - Duration: 1 year total (includes hot)
  - Location: /datastore/archives/logs/
  - Format: Compressed archives (.tar.gz)
  - Performance: Slower access, must restore
  - Size: ~1 TB (90% compression)

Cold Storage (Long-Term Archives):
  - Duration: 7 years total
  - Location: /datastore/archives/logs/YYYY/
  - Format: Highly compressed (.xz)
  - Performance: Manual restore required
  - Size: ~2 TB total
  - Offsite: Backup to secure location

Specific Log Retention:

Audit Logs (auditd):
  - Retention: 7 years (regulatory requirement)
  - Location: Graylog + archives
  - Protection: Encrypted, access controlled

Authentication Logs (/var/log/secure):
  - Retention: 7 years
  - Includes: All login attempts, SSH sessions
  - Critical for forensics

Security Event Logs (Wazuh):
  - Alerts: 90 days hot, 7 years archive
  - Archives: 30 days, then to cold storage
  - Database: 90 days

Application Logs:
  - Standard: 90 days hot, 1 year warm
  - Security-relevant: 7 years cold
  - Debug logs: 30 days only

Compliance Logs:
  - FIM (AIDE): 7 years
  - Vulnerability scans: 7 years
  - Compliance assessments: 7 years
  - Access reviews: 7 years
```

### Log Protection

**Security Controls for Audit Logs:**
```
Access Control:
  - Audit log directories: 0700 (root only)
  - Audit log files: 0600 (root only)
  - Graylog access: Admin role required
  - Elasticsearch: Localhost only binding
  - No user access to raw logs

Encryption:
  - Disk encryption: LUKS/dm-crypt (all volumes)
  - Backup encryption: AES-256
  - Transport encryption: TLS 1.2+ (syslog, GELF)
  - At-rest: Full-disk encryption

Integrity Protection:
  - File permissions enforced
  - SELinux contexts prevent modification
  - AIDE monitoring of log directories
  - Immutable flag on archived logs (chattr +i)
  - Hash verification for archives

Tamper Detection:
  - AIDE daily checks on /var/log/
  - Wazuh file integrity monitoring
  - Syslog-ng hash chains (planned)
  - Centralized logging (prevents local tampering)
  - Alert on log file deletions

Backup Protection:
  - Daily backups include all logs
  - Encrypted backup storage
  - Offsite backup copies
  - Versioned retention (can restore previous versions)
  - Monthly restore testing
```

### Log Storage Management

**Storage Capacity Planning:**
```
Current Log Volume:
  - Daily ingestion: ~100 GB compressed
  - Hot storage (90d): ~9 TB theoretical
  - Actual (with cleanup): ~3 TB
  - Compression ratio: ~10:1

Storage Allocation:
  Graylog server (graylog.cyberinabox.net):
    - Total capacity: 10 TB
    - Elasticsearch data: 4 TB
    - Archive storage: 3 TB
    - Free space: 3 TB
    - Monitoring threshold: 80% (8 TB)

  DMS server (long-term archives):
    - Archive location: /datastore/archives/
    - Capacity: 12 TB
    - Current usage: 2 TB
    - Growth rate: ~50 GB/month

Automated Cleanup:
  # Graylog index rotation
  Index rotation: Daily (new index per day)
  Index retention: 90 indices (90 days)
  Old indices: Deleted automatically

  # Archive rotation
  Warm → Cold: Automated after 1 year
  Cold cleanup: After 7 years (manual review)

  # Disk space monitoring
  Alert threshold: 80% capacity
  Critical threshold: 90% capacity
  Action: Email alert to admin

Capacity Monitoring:
  - Prometheus disk space metrics
  - Grafana dashboard alerts
  - Daily automated checks
  - Weekly trend analysis
  - Quarterly capacity planning review
```

## 42.5 Audit Tools and Queries

### Useful Graylog Searches

**Common Audit Queries:**
```
Authentication Failures:
  source:dc1 AND (failed OR failure OR denied)
  Time: Last 24 hours
  Purpose: Detect brute force attempts

Sudo Usage:
  message:"sudo:" OR message:"COMMAND="
  Time: Last 7 days
  Purpose: Review privileged command execution

User Account Changes:
  message:(useradd OR usermod OR userdel OR groupadd OR groupmod)
  Time: Last 30 days
  Purpose: Track account lifecycle events

SSH Logins:
  sshd AND (Accepted OR session opened)
  Time: Last 24 hours
  Purpose: Monitor SSH access

Failed SSH:
  sshd AND (Failed password OR authentication failure)
  Time: Last 24 hours
  Purpose: Detect unauthorized access attempts

File Changes (AIDE):
  aide OR file_integrity
  Time: Last 7 days
  Purpose: Review unauthorized file modifications

Security Alerts:
  level:[10 TO 15] OR severity:high OR severity:critical
  Time: Last 24 hours
  Purpose: Review high-priority security events

Firewall Blocks:
  firewalld AND (REJECT OR DROP)
  Time: Last 24 hours
  Purpose: Review blocked connection attempts

Certificate Operations:
  certmonger OR certificate OR openssl
  Time: Last 30 days
  Purpose: Track certificate lifecycle

System Reboots:
  message:"systemd: Started" OR message:"kernel: Linux version"
  Time: Last 90 days
  Purpose: Track system availability events
```

### Audit Report Generation

**Automated Report Scripts:**
```bash
#!/bin/bash
# generate-audit-report.sh
# Generate monthly audit summary report

REPORT_DATE=$(date +%Y-%m)
REPORT_FILE="/var/reports/audit-${REPORT_DATE}.txt"
GRAYLOG_API="https://graylog.cyberinabox.net/api"
AUTH="admin:password"

echo "Audit Report for ${REPORT_DATE}" > ${REPORT_FILE}
echo "======================================" >> ${REPORT_FILE}
echo "" >> ${REPORT_FILE}

# Authentication summary
echo "Authentication Events:" >> ${REPORT_FILE}
echo "---------------------" >> ${REPORT_FILE}
SSH_SUCCESS=$(grep -c "Accepted" /var/log/secure)
SSH_FAILED=$(grep -c "Failed password" /var/log/secure)
echo "  SSH Successful logins: ${SSH_SUCCESS}" >> ${REPORT_FILE}
echo "  SSH Failed attempts: ${SSH_FAILED}" >> ${REPORT_FILE}
echo "" >> ${REPORT_FILE}

# Privileged command usage
echo "Privileged Command Usage:" >> ${REPORT_FILE}
echo "------------------------" >> ${REPORT_FILE}
SUDO_COUNT=$(grep -c "sudo:" /var/log/secure)
echo "  Total sudo commands: ${SUDO_COUNT}" >> ${REPORT_FILE}
echo "  Top users:" >> ${REPORT_FILE}
grep "sudo:" /var/log/secure | awk '{print $5}' | sort | uniq -c | sort -rn | head -5 >> ${REPORT_FILE}
echo "" >> ${REPORT_FILE}

# File integrity
echo "File Integrity (AIDE):" >> ${REPORT_FILE}
echo "---------------------" >> ${REPORT_FILE}
AIDE_CHANGES=$(grep -c "changed:" /var/log/aide/aide.log)
echo "  Files changed: ${AIDE_CHANGES}" >> ${REPORT_FILE}
echo "" >> ${REPORT_FILE}

# Security alerts
echo "Security Alerts (Wazuh):" >> ${REPORT_FILE}
echo "-----------------------" >> ${REPORT_FILE}
CRITICAL=$(grep -c "level.*1[0-5]" /var/ossec/logs/alerts/alerts.log)
echo "  Critical/High alerts: ${CRITICAL}" >> ${REPORT_FILE}
echo "" >> ${REPORT_FILE}

# System changes
echo "System Modifications:" >> ${REPORT_FILE}
echo "--------------------" >> ${REPORT_FILE}
USER_ADDS=$(grep -c "useradd" /var/log/secure)
USER_DELS=$(grep -c "userdel" /var/log/secure)
echo "  Users added: ${USER_ADDS}" >> ${REPORT_FILE}
echo "  Users deleted: ${USER_DELS}" >> ${REPORT_FILE}
echo "" >> ${REPORT_FILE}

# Send report
mail -s "Monthly Audit Report - ${REPORT_DATE}" admin@cyberinabox.net < ${REPORT_FILE}
```

## 42.6 Accountability Enforcement

### User Attribution

**Ensuring Accountability:**
```
Individual Identification:
  ✓ Unique user accounts (no shared accounts)
  ✓ FreeIPA centralized identity
  ✓ UID/username in all logs
  ✓ Audit UID (auid) preserved through sudo
  ✓ Original login user traceable

Session Tracking:
  ✓ SSH session IDs in logs
  ✓ Terminal (tty) identification
  ✓ Login time and duration
  ✓ Source IP address logged
  ✓ Session correlation across logs

Command Attribution:
  ✓ Bash history (per user, append-only)
  ✓ Sudo command logging
  ✓ Audit syscall tracing
  ✓ Process tree (ppid/pid)
  ✓ Working directory context

Non-Repudiation:
  ✓ Centralized logging (can't delete locally)
  ✓ Immutable log storage
  ✓ Audit log integrity monitoring
  ✓ Timestamp synchronization (NTP)
  ✓ Log retention (7 years)
```

### Investigating User Actions

**Forensic Investigation Process:**
```
Investigation Scenario: Unauthorized file deletion

Step 1: Identify the Event
  - User reports missing file
  - AIDE detects file deletion
  - Wazuh alerts on suspicious activity

Step 2: Determine When
  - Check file modification time (if known)
  - Review AIDE logs for detection time
  - Graylog timestamp correlation

Step 3: Find Audit Records
  # ausearch for file deletion
  ausearch -k delete -ts recent

  # grep audit.log for file name
  grep "/path/to/file" /var/log/audit/audit.log

  # Graylog search
  message:"/path/to/file" AND (unlink OR delete OR rm)

Step 4: Identify User
  From audit record:
    auid=1005  # Original login user
    uid=0      # Effective user (if sudo)

  # Lookup user
  getent passwd 1005
  Output: jsmith:x:1005:1005:John Smith:/home/jsmith:/bin/bash

Step 5: Trace Actions
  # Find all actions by that user in timeframe
  ausearch -ua 1005 -ts 12/31/2025 00:00:00 -te 12/31/2025 23:59:59

  # Sudo usage
  grep "auid=1005.*sudo" /var/log/audit/audit.log

  # Commands executed
  grep "auid=1005.*EXECVE" /var/log/audit/audit.log

Step 6: Context and Intent
  - Review bash history: /home/jsmith/.bash_history
  - Check working directory at time
  - Review surrounding commands
  - Determine if intentional or accidental

Step 7: Document Findings
  - Timeline of events
  - User actions identified
  - Evidence collected
  - Determine policy violation
  - Recommend corrective action

Step 8: Response
  - User interview if needed
  - Disciplinary action per policy
  - Technical controls to prevent recurrence
  - Update procedures if needed
```

---

**Audit & Accountability Quick Reference:**

**Logging Infrastructure:**
- Auditd: System call auditing
- Rsyslog: Log forwarding
- Graylog: Centralized collection
- Wazuh: Security event correlation
- Elasticsearch: Log indexing

**Log Sources:**
- Authentication: /var/log/secure
- Audit: /var/log/audit/audit.log
- System: /var/log/messages
- Application: Service-specific
- Security: Wazuh, Suricata, AIDE

**Retention:**
- Hot storage: 90 days (searchable)
- Warm storage: 1 year (compressed)
- Cold storage: 7 years (archived)
- Audit logs: 7 years (compliance)

**Daily Reviews:**
- Grafana dashboard check
- Wazuh alert review
- Graylog failure search
- Backup status
- Time: 15-30 min/day

**Protection:**
- Access: Admin-only
- Encryption: LUKS + TLS
- Integrity: AIDE monitoring
- Backup: Daily encrypted backups
- Centralized: Cannot be tampered locally

**Key Metrics:**
- Log collection: 100% of systems
- Retention compliance: 100%
- Storage utilization: < 80%
- Review completion: Daily
- Incident response: < 1 hour

**Accountability:**
- Unique user accounts
- No shared credentials
- Actions traceable to individuals
- Audit UID preserved
- 7-year evidence retention

---

**Related Chapters:**
- Chapter 21: Graylog Log Analysis
- Chapter 28: System Monitoring Configuration
- Chapter 39: NIST 800-171 Overview
- Chapter 40: Security Policies Index
- Chapter 22: Incident Response

**For Audit Questions:**
- Log access: Graylog web interface
- Audit reports: /var/reports/
- Investigation support: dshannon@cyberinabox.net
- Evidence retention: /datastore/compliance/
