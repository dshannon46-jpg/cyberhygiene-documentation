# Chapter 23: Backup & Recovery

## 23.1 Backup Strategy

### Overview

The CyberHygiene Production Network implements a comprehensive backup strategy following the **3-2-1 rule**:
- **3** copies of data
- **2** different media types
- **1** copy offsite (encrypted)

**Backup Objectives:**

```
Recovery Time Objective (RTO):
  - Critical systems: < 4 hours
  - Standard systems: < 24 hours
  - Non-critical: < 72 hours

Recovery Point Objective (RPO):
  - Critical data: < 1 hour (last backup)
  - Standard data: < 24 hours (daily backup)
  - Archival: < 7 days (weekly backup)
```

### Backup Tiers

**Tier 1: Critical Systems (Hourly + Daily)**
```
Systems:
  - dc1.cyberinabox.net (FreeIPA, DNS, CA)
  - wazuh.cyberinabox.net (Security data)
  - graylog.cyberinabox.net (Log data - 90 days)

Frequency:
  - Incremental: Every 1 hour
  - Full: Daily at 2:00 AM
  - Retention: 30 days local, 90 days offsite

Data:
  - System configurations
  - FreeIPA database
  - Security logs
  - SIEM data
  - Certificates and keys (encrypted)
```

**Tier 2: Standard Systems (Daily)**
```
Systems:
  - dms.cyberinabox.net (File server)
  - monitoring.cyberinabox.net (Grafana, Prometheus)
  - proxy.cyberinabox.net (Proxy configuration)

Frequency:
  - Incremental: Daily at 3:00 AM
  - Full: Weekly (Sunday 1:00 AM)
  - Retention: 14 days local, 60 days offsite

Data:
  - User files
  - Application data
  - Database backups
  - Dashboards and configurations
```

**Tier 3: Archival (Weekly)**
```
Data Types:
  - Graylog archives (> 90 days)
  - Historical compliance reports
  - Audit logs
  - Documentation archives

Frequency:
  - Full: Weekly (Sunday 4:00 AM)
  - Retention: 7 years (compliance requirement)

Storage:
  - Compressed and encrypted
  - Offsite cloud storage
  - Immutable backups (ransomware protection)
```

## 23.2 What Gets Backed Up

### User Data

**Home Directories:**
```
Location: /home/username
Frequency: Daily
Retention: 14 days

What's Included:
  ✅ Documents and files
  ✅ Configuration files (.bashrc, .ssh/config, etc.)
  ✅ Scripts and projects
  ✅ Email (if using local mail client)

What's Excluded:
  ❌ Cache directories (.cache/)
  ❌ Temporary files (/tmp/)
  ❌ Browser cache
  ❌ Very large files (>10 GB - contact admin)
```

**Shared Directories:**
```
Location: /exports/shared, /exports/engineering
Frequency: Daily
Retention: 30 days

All files in shared workspaces are backed up automatically.
```

### System Configurations

**FreeIPA (Identity Management):**
```
Backed Up:
  ✅ User accounts and groups
  ✅ SUDO rules
  ✅ HBAC (Host-Based Access Control)
  ✅ Kerberos principals
  ✅ DNS records
  ✅ Certificates issued by internal CA

Frequency: Hourly + Daily full
Method: ipa-backup + database dump
```

**Services Configuration:**
```
Backed Up:
  ✅ Firewall rules (firewalld)
  ✅ SELinux policies
  ✅ SSH configuration
  ✅ Systemd service files
  ✅ Cron jobs
  ✅ Network configuration

Location: /etc/ directory tree
Frequency: Daily
```

**Monitoring & Security:**
```
Wazuh:
  ✅ Rules and decoders
  ✅ Agent configuration
  ✅ Alert history (90 days)
  ✅ Compliance reports

Grafana:
  ✅ Dashboards (JSON exports)
  ✅ Data sources
  ✅ Alert rules
  ✅ User preferences

Prometheus:
  ✅ Configuration files
  ✅ Metrics data (30 days)
  ✅ Alert rules

Graylog:
  ✅ Streams configuration
  ✅ Saved searches
  ✅ Dashboards
  ✅ Log indices (90 days hot, 1 year archive)
```

### Databases

**PostgreSQL (Wazuh, Grafana):**
```
Backup Method: pg_dump
Frequency: Daily at 2:00 AM
Retention: 30 days
Encryption: AES-256

Backup Command (automated):
pg_dump -Fc -f /backup/postgres_$(date +%Y%m%d).dump database_name
```

**Elasticsearch (Graylog):**
```
Backup Method: Snapshot API
Frequency: Daily at 2:30 AM
Retention: 90 days
Location: /datastore/backups/graylog-snapshots/

Automated via Graylog content packs
```

### Excluded from Backups

**Not Backed Up (by design):**
```
❌ /tmp/ - Temporary files
❌ /var/cache/ - Cache directories
❌ /proc/, /sys/ - Virtual filesystems
❌ /dev/ - Device files
❌ Swap files
❌ ISO images and installation media
❌ Log files older than retention period
❌ Prometheus metrics older than 30 days
```

**Why Excluded:**
- Temporary data (recreated automatically)
- No value in restoration
- Reduces backup storage requirements
- Speeds up backup/restore operations

## 23.3 Backup Verification

### Automated Verification

**Daily Backup Checks (Automated):**
```
Performed: Daily at 6:00 AM (after backups complete)

Checks:
  1. Backup completion status
  2. File count verification
  3. Size validation (within expected range)
  4. Checksum verification (SHA256)
  5. Encryption verification
  6. Offsite sync confirmation

Alerts:
  - Email to administrator if any check fails
  - Wazuh alert (severity level 10)
  - Dashboard indicator (CPM)
```

**Verification Script Output:**
```bash
# Example daily verification report
=== Backup Verification Report ===
Date: 2025-12-31 06:00:00

dc1.cyberinabox.net:
  ✅ Full backup completed: 23.4 GB
  ✅ Incremental backups: 24/24 successful
  ✅ Checksum verified: PASS
  ✅ Offsite sync: Complete
  ✅ Test restore: PASS (5 random files)

dms.cyberinabox.net:
  ✅ Daily backup completed: 487 GB
  ✅ File count: 1,245,633 (+234 from previous)
  ✅ Checksum verified: PASS
  ✅ Offsite sync: Complete

graylog.cyberinabox.net:
  ✅ Elasticsearch snapshot: Complete
  ✅ Index count: 94 indices
  ✅ Archive compression: 89% ratio
  ⚠️  Warning: Storage at 78% (cleanup scheduled)

Overall Status: ✅ ALL SYSTEMS BACKED UP
Next full backup: 2026-01-01 01:00:00
```

### Monthly Test Restores

**Scheduled Test Restore (First Monday):**

```
Purpose: Verify backups can actually be restored

Process:
  1. Select random files from each tier
  2. Perform test restore to isolated directory
  3. Verify file integrity (checksum comparison)
  4. Test file accessibility and permissions
  5. Document results

Test Scope:
  - 10 random user files
  - 5 configuration files
  - 1 database backup (restore to test instance)
  - 1 full system configuration

Results:
  - Logged in /var/log/backup-tests/
  - Reported in monthly compliance review
  - Failures escalated immediately
```

**Test Restore Example:**
```bash
# Monthly test restore log
=== Test Restore Report - January 2026 ===
Date: 2026-01-06 10:00:00

Test 1: User Home Directories
  Source: /backup/dms/daily/2026-01-05/
  Files tested: 10 random files
  Result: ✅ 10/10 restored successfully
  Integrity: ✅ All checksums match

Test 2: FreeIPA Configuration
  Source: /backup/dc1/hourly/2026-01-06_09/
  Restored to: dc1-test VM
  Result: ✅ FreeIPA service started successfully
  Users: ✅ All users authenticated
  Groups: ✅ All groups intact

Test 3: Graylog Logs
  Source: /backup/graylog/daily/2026-01-05/
  Date range: 2025-12-31 00:00 - 2026-01-01 00:00
  Result: ✅ Restored to test index
  Searchable: ✅ All queries functional

Overall: ✅ PASS - Backups verified restorable
Next test: 2026-02-03
```

## 23.4 Restore Procedures

### Requesting a Restore

**When to Request Restore:**

**Immediate (User Self-Service):**
```
Accidentally deleted file (within 24 hours):
  1. Check if file in Trash/Recycle Bin first
  2. Contact administrator with:
     - File path: /home/username/path/to/file.txt
     - Approximate deletion time
     - Last known modification date
  3. Administrator restores from last backup

Email: dshannon@cyberinabox.net
Subject: File Restore Request
Response Time: Same day (business hours)
```

**Standard Restore Request:**
```
To: dshannon@cyberinabox.net
Subject: Backup Restore Request

User: [your username]
System: [hostname if known]
Data Needed: [specific files/directories]
Timeframe: [when did you last have the data?]
Reason: [accidental deletion / system failure / corruption]
Urgency: [standard / urgent]

File Details:
- Path: /home/username/project/important.doc
- Last modified: Approximately 2025-12-28
- Purpose: [why you need this file]

Expected restoration time: 4-24 hours
```

### Restore Process (User Perspective)

**Small File Restore (<100 files):**
```
Timeline:
  1. Submit request (0 hours)
  2. Administrator locates backup (1-2 hours)
  3. Files restored to temporary location (1 hour)
  4. User notified of restore location (email)
  5. User verifies files (30 minutes)
  6. Files moved to original location or requested path

Total Time: 2-4 hours (business hours)

Restored Location:
/home/username/restored_YYYYMMDD/
```

**Large Data Restore (>100 files or directories):**
```
Timeline:
  1. Submit request with detailed file list
  2. Administrator assesses scope (2 hours)
  3. Restore scheduled (may be overnight)
  4. Data restored to staging area
  5. Verification performed
  6. User granted access to review
  7. Data moved to production after approval

Total Time: 24-48 hours

Note: Large restores scheduled during off-peak hours
```

**System Configuration Restore (Admin Only):**
```
Used For:
  - System failure
  - Configuration corruption
  - Disaster recovery

Process:
  1. Boot system from recovery media
  2. Restore system configuration from backup
  3. Restore data files
  4. Verify services start correctly
  5. Test functionality
  6. Return system to production

Estimated Time:
  - Critical systems: 2-4 hours
  - Standard systems: 4-8 hours
```

### Self-Service Restore (Limited)

**File Versioning (for shared drives):**

*Phase II Feature* - File versioning with user self-service restore planned.

Current: Contact administrator for all restores.

## 23.5 Disaster Recovery

### Disaster Scenarios

**Scenario 1: Single System Failure**
```
Example: dc1.cyberinabox.net hardware failure

Impact:
  - Domain authentication unavailable
  - DNS resolution affected
  - Certificate services down
  - High severity (P2)

Recovery Steps:
  1. Deploy replacement hardware or VM
  2. Install Rocky Linux 9 (FIPS mode)
  3. Restore system configuration from backup
  4. Restore FreeIPA database
  5. Verify DNS and Kerberos services
  6. Test user authentication
  7. Update monitoring

RTO: 4 hours (critical system)
RPO: 1 hour (last incremental backup)
```

**Scenario 2: Data Corruption**
```
Example: Ransomware encryption of /exports/shared

Impact:
  - User files encrypted
  - Work disruption
  - Critical severity (P1)

Recovery Steps:
  1. Isolate affected system from network
  2. Identify last clean backup (before encryption)
  3. Restore files from backup to clean system
  4. Verify file integrity (checksums)
  5. Scan restored files for malware
  6. Return system to production
  7. Investigate infection vector

RTO: 8 hours (data restore + verification)
RPO: 24 hours (last daily backup)
```

**Scenario 3: Complete Site Loss**
```
Example: Datacenter fire, flood, or complete infrastructure loss

Impact:
  - All systems down
  - Complete service outage
  - Critical severity (P1)

Recovery Steps:
  1. Activate disaster recovery plan
  2. Deploy new infrastructure (cloud or alternate site)
  3. Restore critical systems first (dc1, wazuh, monitoring)
  4. Restore standard systems (dms, graylog, proxy)
  5. Restore user data
  6. Verify all services operational
  7. Update DNS and network configuration
  8. Resume operations

RTO: 48-72 hours (full recovery)
RPO: 24 hours (last offsite backup sync)
```

### Disaster Recovery Plan Activation

**Activation Criteria:**

Activate DR plan if ANY of:
- 3+ critical systems down simultaneously
- Primary site inaccessible
- Data loss affecting multiple systems
- Estimated recovery time > 8 hours
- Ransomware affecting multiple systems

**Activation Authority:**
- System Administrator
- Security Team Lead
- Management (for cost approval)

**Notification:**
```
To: all-staff@cyberinabox.net
Subject: [DISASTER RECOVERY] Plan Activated

The Disaster Recovery plan has been activated due to:
[Brief description of disaster]

Current Status:
- Primary systems: [Offline/Affected]
- Estimated recovery time: [XX hours]
- Services affected: [List]

Actions:
- DR team assembled
- Recovery in progress
- Next update: [time]

Contact: security@cyberinabox.net
```

### Recovery Priority Order

**Phase 1: Critical Infrastructure (0-4 hours)**
```
Priority 1 - Authentication & Core Services:
  1. dc1.cyberinabox.net (FreeIPA, DNS, CA)
  2. Wazuh (security monitoring)
  3. Network infrastructure (proxy, firewall)

Goal: Restore authentication and security visibility
```

**Phase 2: Operational Services (4-12 hours)**
```
Priority 2 - Monitoring & Communication:
  4. monitoring.cyberinabox.net (Grafana, Prometheus)
  5. graylog.cyberinabox.net (log management)
  6. Email services

Goal: Restore monitoring and basic communication
```

**Phase 3: User Services (12-24 hours)**
```
Priority 3 - File Services & Applications:
  7. dms.cyberinabox.net (file shares)
  8. User home directories
  9. Web applications

Goal: Restore normal operations for users
```

**Phase 4: Full Recovery (24-48 hours)**
```
Priority 4 - Complete Restoration:
  10. Historical data restoration
  11. Optional services
  12. Full verification and testing
  13. Documentation updates

Goal: Return to full operational capacity
```

## 23.6 User Responsibilities

### What Users Should Do

**Regular Backup Verification:**
```
Recommended: Monthly

Steps:
  1. Verify your important files are in backed-up locations:
     ✅ /home/username/ (YES - backed up daily)
     ✅ /exports/shared/ (YES - backed up daily)
     ❌ /tmp/ (NO - not backed up)

  2. Check file sizes and locations:
     - Large files (>10 GB): May need special backup arrangement
     - Critical files: Keep in multiple locations if possible

  3. Test file restore (optional):
     - Request test restore of a non-critical file
     - Verify you can access and use restored file
```

**Maintain Local Copies (Critical Work):**
```
Best Practice: Important work-in-progress

Don't rely solely on server backups:
  - Keep local copy of critical documents
  - Use version control (git) for code
  - Export critical data periodically
  - Maintain working backups of active projects

Why:
  - Backups are point-in-time (24 hour RPO)
  - Faster access to local files if needed
  - Protection against accidental deletions
```

**Report Backup Concerns:**
```
Contact administrator if:
  - You have very large files (>10 GB) needing backup
  - You need longer retention than standard (14-30 days)
  - You discover missing or corrupt files
  - You need to restore files
  - You have sensitive data requiring special handling
```

### What Users Should NOT Do

**Don't:**
```
❌ Store important files in /tmp/ (not backed up)
❌ Rely only on server backups (keep local copies too)
❌ Assume backups are instantaneous (24-hour cycle)
❌ Delete backup files in /backup/ directory (if visible)
❌ Attempt to restore files yourself from backup directory
   (Contact administrator instead)
```

---

**Backup Quick Reference:**

**What's Backed Up:**
- ✅ Home directories: /home/username/ (Daily)
- ✅ Shared files: /exports/shared/ (Daily)
- ✅ System configs: /etc/ (Daily)
- ✅ Databases: PostgreSQL, Elasticsearch (Daily)
- ✅ Security data: Wazuh, Graylog logs (Hourly + Daily)
- ❌ Temp files: /tmp/ (Not backed up)

**Backup Schedule:**
- **Critical systems:** Hourly + Daily full
- **Standard systems:** Daily incremental, Weekly full
- **User data:** Daily (14-30 day retention)
- **Archives:** Weekly (7 year retention)

**Restore Request:**
```
Email: dshannon@cyberinabox.net
Subject: File Restore Request

Include:
- File path
- Approximate deletion/loss date
- Urgency (standard/urgent)
- Your contact info

Response Time:
- Small restores: 2-4 hours
- Large restores: 24-48 hours
```

**Disaster Recovery:**
- **RTO (Critical):** 4 hours
- **RTO (Standard):** 24 hours
- **RPO:** 1-24 hours depending on backup tier
- **Offsite backups:** Encrypted, 3-2-1 strategy

**User Best Practices:**
1. Keep important files in /home/username/ or /exports/shared/
2. Maintain local copies of critical work
3. Report large files (>10 GB) to administrator
4. Request test restore to verify your backups
5. Don't store important files in /tmp/

**For Help:**
- Restore request: dshannon@cyberinabox.net
- Backup questions: dshannon@cyberinabox.net
- Disaster recovery: security@cyberinabox.net
- Emergency: See Chapter 5

---

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 12: File Sharing & Collaboration
- Chapter 22: Incident Response
- Chapter 29: Backup Procedures (Administrator Guide)
- Chapter 32: Emergency Procedures

**Backup Monitoring:**
- CPM Dashboard: https://cpm.cyberinabox.net (backup status)
- Wazuh Alerts: https://wazuh.cyberinabox.net (backup failures)
- Email: Daily backup reports to administrator
