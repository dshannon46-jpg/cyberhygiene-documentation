# Chapter 29: Backup Procedures (Administrator Guide)

## 29.1 Backup Architecture

### Backup Infrastructure

**Backup Server:** dms.cyberinabox.net

**Storage Layout:**

```
/datastore/backups/
├── daily/               # Daily incremental backups
│   ├── dc1/
│   ├── dms/
│   ├── graylog/
│   ├── proxy/
│   ├── monitoring/
│   └── wazuh/
├── weekly/              # Weekly full backups
│   └── [same structure]
├── monthly/             # Monthly archives
│   └── [same structure]
├── graylog-archives/    # Graylog log archives
├── database/            # Database dumps
└── offsite-staging/     # Staging for offsite sync

Total Capacity: 10 TB
Current Usage: ~3.2 TB (32%)
Retention: 90 days hot, 1 year warm, 7 years cold
```

### Backup Schedule

**Automated Backup Times:**

```
Tier 1: Critical Systems (Hourly + Daily)
  dc1.cyberinabox.net:
    - Hourly incremental: :05 past each hour
    - Daily full: 02:00 AM
    - FreeIPA database: 02:15 AM
    - DNS zones: 02:20 AM
    - Certificates: 02:25 AM

  wazuh.cyberinabox.net:
    - Hourly incremental: :10 past each hour
    - Daily full: 02:30 AM
    - Security logs: 02:45 AM
    - Rules/decoders: 02:50 AM

  graylog.cyberinabox.net:
    - Hourly log rotation: :15 past each hour
    - Daily Elasticsearch snapshot: 02:30 AM
    - Archive creation: 03:00 AM
    - Compression: 03:30 AM

Tier 2: Standard Systems (Daily)
  dms.cyberinabox.net:
    - Daily incremental: 03:00 AM
    - Weekly full: Sunday 01:00 AM
    - User files: Continuous (rsync)

  monitoring.cyberinabox.net:
    - Daily incremental: 03:30 AM
    - Grafana dashboards: 03:35 AM
    - Prometheus data: 03:40 AM

  proxy.cyberinabox.net:
    - Daily incremental: 04:00 AM
    - Configuration: 04:05 AM

Verification:
  - Backup verification: 06:00 AM daily
  - Test restore: First Monday each month, 10:00 AM
  - Integrity checks: 06:30 AM daily

Offsite Sync:
  - Incremental sync: Every 6 hours (00:00, 06:00, 12:00, 18:00)
  - Full sync: Sunday 05:00 AM
```

## 29.2 Backup Scripts

### Master Backup Script

**Location:** `/usr/local/bin/backup-all-systems.sh`

```bash
#!/bin/bash
#
# Master backup script for CyberHygiene Production Network
# Runs daily via cron at 02:00 AM
#
# Author: System Administrator
# Last Modified: 2025-12-31

set -euo pipefail

# Configuration
BACKUP_ROOT="/datastore/backups"
LOG_DIR="/var/log/backups"
LOG_FILE="${LOG_DIR}/backup-$(date +%Y%m%d).log"
RETENTION_DAYS=90
EMAIL_ALERT="admin@cyberinabox.net"

# Ensure log directory exists
mkdir -p "${LOG_DIR}"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

# Error handling
error_exit() {
    log "ERROR: $1"
    echo "Backup failed: $1" | mail -s "[BACKUP FAILED] $(hostname)" "${EMAIL_ALERT}"
    exit 1
}

# Start backup
log "========== Starting backup for all systems =========="

# Check available space
AVAILABLE_SPACE=$(df -BG "${BACKUP_ROOT}" | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "${AVAILABLE_SPACE}" -lt 500 ]; then
    error_exit "Insufficient disk space: ${AVAILABLE_SPACE}GB available, need 500GB minimum"
fi

log "Available space: ${AVAILABLE_SPACE}GB"

# Backup each system
SYSTEMS=(
    "dc1.cyberinabox.net"
    "dms.cyberinabox.net"
    "graylog.cyberinabox.net"
    "proxy.cyberinabox.net"
    "monitoring.cyberinabox.net"
    "wazuh.cyberinabox.net"
)

for system in "${SYSTEMS[@]}"; do
    log "Backing up ${system}..."

    # Call system-specific backup script
    if ! /usr/local/bin/backup-system.sh "${system}"; then
        log "WARNING: Backup of ${system} failed"
        echo "Backup of ${system} failed. Check logs at ${LOG_FILE}" | \
            mail -s "[BACKUP WARNING] ${system}" "${EMAIL_ALERT}"
    else
        log "Backup of ${system} completed successfully"
    fi
done

# Run database backups
log "Running database backups..."
/usr/local/bin/backup-databases.sh || log "WARNING: Database backup had errors"

# Create checksums
log "Creating checksums for verification..."
find "${BACKUP_ROOT}/daily/" -type f -mtime -1 -exec sha256sum {} \; > \
    "${BACKUP_ROOT}/checksums/checksums-$(date +%Y%m%d).txt"

# Cleanup old backups
log "Cleaning up backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_ROOT}/daily/" -type f -mtime +${RETENTION_DAYS} -delete
find "${BACKUP_ROOT}/checksums/" -type f -mtime +${RETENTION_DAYS} -delete

# Sync to offsite
log "Syncing to offsite staging..."
/usr/local/bin/backup-offsite-sync.sh || log "WARNING: Offsite sync had errors"

# Generate report
BACKUP_SIZE=$(du -sh "${BACKUP_ROOT}/daily/$(date +%Y%m%d)" 2>/dev/null | awk '{print $1}')
log "Backup completed. Total size: ${BACKUP_SIZE}"

# Send success notification
cat <<EOF | mail -s "[BACKUP SUCCESS] All Systems" "${EMAIL_ALERT}"
Daily backup completed successfully.

Date: $(date)
Total Size: ${BACKUP_SIZE}
Systems Backed Up: ${#SYSTEMS[@]}
Log: ${LOG_FILE}

Next backup: Tomorrow 02:00 AM
EOF

log "========== Backup complete =========="
exit 0
```

### System-Specific Backup Script

**Location:** `/usr/local/bin/backup-system.sh`

```bash
#!/bin/bash
#
# Backup individual system
# Usage: backup-system.sh <hostname>

set -euo pipefail

HOSTNAME="$1"
BACKUP_ROOT="/datastore/backups"
DATE=$(date +%Y%m%d)
BACKUP_DIR="${BACKUP_ROOT}/daily/${HOSTNAME}/${DATE}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Determine backup method based on system
case "${HOSTNAME}" in
    dc1.cyberinabox.net)
        # FreeIPA backup
        ssh admin@"${HOSTNAME}" "sudo ipa-backup --data --online" || exit 1
        rsync -avz --delete admin@"${HOSTNAME}":/var/lib/ipa/backup/ipa-* \
            "${BACKUP_DIR}/ipa-backup/" || exit 1

        # Configuration files
        rsync -avz admin@"${HOSTNAME}":/etc/ "${BACKUP_DIR}/etc/" \
            --exclude="shadow*" --exclude="gshadow*" || exit 1
        ;;

    dms.cyberinabox.net)
        # User home directories
        rsync -avz --delete admin@"${HOSTNAME}":/home/ "${BACKUP_DIR}/home/" || exit 1

        # Shared exports
        rsync -avz --delete admin@"${HOSTNAME}":/exports/ "${BACKUP_DIR}/exports/" || exit 1

        # Configuration
        rsync -avz admin@"${HOSTNAME}":/etc/ "${BACKUP_DIR}/etc/" || exit 1
        ;;

    graylog.cyberinabox.net)
        # Elasticsearch snapshot (handled separately)
        # Just backup configuration here
        rsync -avz admin@"${HOSTNAME}":/etc/graylog/ "${BACKUP_DIR}/graylog-config/" || exit 1
        rsync -avz admin@"${HOSTNAME}":/etc/elasticsearch/ "${BACKUP_DIR}/elasticsearch-config/" || exit 1
        ;;

    wazuh.cyberinabox.net)
        # Wazuh data
        rsync -avz admin@"${HOSTNAME}":/var/ossec/etc/ "${BACKUP_DIR}/wazuh-etc/" || exit 1
        rsync -avz admin@"${HOSTNAME}":/var/ossec/rules/ "${BACKUP_DIR}/wazuh-rules/" || exit 1
        rsync -avz admin@"${HOSTNAME}":/var/ossec/logs/ "${BACKUP_DIR}/wazuh-logs/" \
            --exclude="*.log.*" || exit 1
        ;;

    monitoring.cyberinabox.net)
        # Grafana
        rsync -avz admin@"${HOSTNAME}":/var/lib/grafana/ "${BACKUP_DIR}/grafana/" || exit 1
        rsync -avz admin@"${HOSTNAME}":/etc/grafana/ "${BACKUP_DIR}/grafana-config/" || exit 1

        # Prometheus
        rsync -avz admin@"${HOSTNAME}":/etc/prometheus/ "${BACKUP_DIR}/prometheus-config/" || exit 1
        # Note: Prometheus data backed up separately due to size
        ;;

    proxy.cyberinabox.net)
        # Suricata configuration
        rsync -avz admin@"${HOSTNAME}":/etc/suricata/ "${BACKUP_DIR}/suricata/" || exit 1

        # Firewall rules
        ssh admin@"${HOSTNAME}" "sudo firewall-cmd --list-all-zones" > \
            "${BACKUP_DIR}/firewall-rules.txt" || exit 1
        ;;
esac

# Always backup system configuration
rsync -avz admin@"${HOSTNAME}":/etc/systemd/ "${BACKUP_DIR}/systemd/" || exit 1
rsync -avz admin@"${HOSTNAME}":/etc/cron* "${BACKUP_DIR}/cron/" || exit 1

# Create metadata file
cat > "${BACKUP_DIR}/metadata.txt" <<EOF
Hostname: ${HOSTNAME}
Backup Date: $(date)
Backup Type: Daily Incremental
Backup Size: $(du -sh "${BACKUP_DIR}" | awk '{print $1}')
File Count: $(find "${BACKUP_DIR}" -type f | wc -l)
EOF

echo "Backup of ${HOSTNAME} completed successfully"
exit 0
```

### Database Backup Script

**Location:** `/usr/local/bin/backup-databases.sh`

```bash
#!/bin/bash
#
# Backup all databases
#

set -euo pipefail

BACKUP_ROOT="/datastore/backups/database"
DATE=$(date +%Y%m%d)
RETENTION_DAYS=30

mkdir -p "${BACKUP_ROOT}"

# FreeIPA (389 Directory Server) - LDAP backup
echo "Backing up FreeIPA LDAP database..."
ssh admin@dc1.cyberinabox.net "sudo db2ldif -r -n userRoot" > \
    "${BACKUP_ROOT}/freeipa-ldap-${DATE}.ldif" || exit 1
gzip "${BACKUP_ROOT}/freeipa-ldap-${DATE}.ldif"

# Wazuh PostgreSQL databases
echo "Backing up Wazuh databases..."
ssh admin@wazuh.cyberinabox.net \
    "sudo -u postgres pg_dump wazuh" | gzip > \
    "${BACKUP_ROOT}/wazuh-db-${DATE}.sql.gz" || exit 1

# Grafana SQLite database
echo "Backing up Grafana database..."
rsync -avz admin@monitoring.cyberinabox.net:/var/lib/grafana/grafana.db \
    "${BACKUP_ROOT}/grafana-${DATE}.db" || exit 1
gzip "${BACKUP_ROOT}/grafana-${DATE}.db"

# Graylog MongoDB
echo "Backing up Graylog MongoDB..."
ssh admin@graylog.cyberinabox.net \
    "sudo mongodump --db graylog --archive" | gzip > \
    "${BACKUP_ROOT}/graylog-mongodb-${DATE}.archive.gz" || exit 1

# Cleanup old database backups
find "${BACKUP_ROOT}" -type f -mtime +${RETENTION_DAYS} -delete

# Create checksum
sha256sum "${BACKUP_ROOT}"/*-${DATE}* > "${BACKUP_ROOT}/checksums-${DATE}.txt"

echo "Database backups completed"
exit 0
```

### Graylog Elasticsearch Snapshot

**Location:** `/usr/local/bin/backup-graylog-elasticsearch.sh`

```bash
#!/bin/bash
#
# Create Elasticsearch snapshot for Graylog logs
#

set -euo pipefail

SNAPSHOT_REPO="/datastore/backups/graylog-archives"
DATE=$(date +%Y%m%d-%H%M%S)
SNAPSHOT_NAME="snapshot-${DATE}"

# Create snapshot via Elasticsearch API
curl -X PUT "http://graylog.cyberinabox.net:9200/_snapshot/backup/${SNAPSHOT_NAME}?wait_for_completion=true" \
    -H 'Content-Type: application/json' \
    -d '{
      "indices": "graylog_*",
      "ignore_unavailable": true,
      "include_global_state": false
    }' || exit 1

# Verify snapshot
STATUS=$(curl -s "http://graylog.cyberinabox.net:9200/_snapshot/backup/${SNAPSHOT_NAME}" | \
    jq -r '.snapshots[0].state')

if [ "${STATUS}" != "SUCCESS" ]; then
    echo "Snapshot failed with status: ${STATUS}"
    exit 1
fi

# Get snapshot size
SIZE=$(curl -s "http://graylog.cyberinabox.net:9200/_snapshot/backup/${SNAPSHOT_NAME}" | \
    jq -r '.snapshots[0].stats.total.size_in_bytes')
SIZE_GB=$((SIZE / 1024 / 1024 / 1024))

echo "Elasticsearch snapshot ${SNAPSHOT_NAME} created successfully (${SIZE_GB}GB)"

# Cleanup old snapshots (keep 90 days)
SNAPSHOTS=$(curl -s "http://graylog.cyberinabox.net:9200/_snapshot/backup/_all" | \
    jq -r '.snapshots[].snapshot')

for snapshot in ${SNAPSHOTS}; do
    # Extract date from snapshot name
    SNAP_DATE=$(echo "${snapshot}" | sed 's/snapshot-//' | cut -d'-' -f1)
    SNAP_AGE=$(( ($(date +%s) - $(date -d "${SNAP_DATE}" +%s)) / 86400 ))

    if [ ${SNAP_AGE} -gt 90 ]; then
        echo "Deleting old snapshot: ${snapshot} (${SNAP_AGE} days old)"
        curl -X DELETE "http://graylog.cyberinabox.net:9200/_snapshot/backup/${snapshot}"
    fi
done

exit 0
```

## 29.3 Backup Verification

### Daily Verification Script

**Location:** `/usr/local/bin/backup-verify.sh`

```bash
#!/bin/bash
#
# Verify backup integrity
# Runs daily at 06:00 AM
#

set -euo pipefail

BACKUP_ROOT="/datastore/backups"
DATE=$(date +%Y%m%d)
LOG_FILE="/var/log/backups/verify-${DATE}.log"
EMAIL_ALERT="admin@cyberinabox.net"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

log "========== Starting backup verification =========="

ERRORS=0

# Verify checksums
log "Verifying checksums..."
if [ -f "${BACKUP_ROOT}/checksums/checksums-${DATE}.txt" ]; then
    cd "${BACKUP_ROOT}/daily/${DATE}"
    if sha256sum -c "${BACKUP_ROOT}/checksums/checksums-${DATE}.txt" 2>&1 | tee -a "${LOG_FILE}"; then
        log "Checksum verification: PASSED"
    else
        log "ERROR: Checksum verification failed"
        ((ERRORS++))
    fi
else
    log "WARNING: No checksum file found for ${DATE}"
fi

# Verify backup sizes (should be within reasonable range)
for system in dc1 dms graylog proxy monitoring wazuh; do
    BACKUP_SIZE=$(du -s "${BACKUP_ROOT}/daily/${system}/${DATE}" 2>/dev/null | awk '{print $1}')
    if [ -z "${BACKUP_SIZE}" ] || [ "${BACKUP_SIZE}" -lt 1000 ]; then
        log "ERROR: Backup for ${system} is too small (${BACKUP_SIZE}KB)"
        ((ERRORS++))
    else
        log "Backup size for ${system}: ${BACKUP_SIZE}KB - OK"
    fi
done

# Test random file restore
log "Performing test restore of random files..."
SYSTEMS=(dc1 dms wazuh)
for system in "${SYSTEMS[@]}"; do
    # Find random file
    RANDOM_FILE=$(find "${BACKUP_ROOT}/daily/${system}/${DATE}" -type f | shuf -n 1)
    if [ -n "${RANDOM_FILE}" ]; then
        # Copy to temp location
        TEMP_RESTORE="/tmp/test-restore-$$"
        mkdir -p "${TEMP_RESTORE}"
        cp "${RANDOM_FILE}" "${TEMP_RESTORE}/" || {
            log "ERROR: Failed to restore ${RANDOM_FILE}"
            ((ERRORS++))
            continue
        }

        # Verify restored file
        if [ -f "${TEMP_RESTORE}/$(basename "${RANDOM_FILE}")" ]; then
            log "Test restore of ${RANDOM_FILE}: PASSED"
        else
            log "ERROR: Test restore verification failed"
            ((ERRORS++))
        fi

        rm -rf "${TEMP_RESTORE}"
    fi
done

# Generate report
log "========== Verification Summary =========="
log "Total errors: ${ERRORS}"

if [ ${ERRORS} -eq 0 ]; then
    log "All verification checks passed"
    cat <<EOF | mail -s "[BACKUP VERIFY SUCCESS] ${DATE}" "${EMAIL_ALERT}"
Backup verification completed successfully.

Date: $(date)
Errors: 0
Log: ${LOG_FILE}

All systems verified:
- Checksums: PASSED
- Backup sizes: OK
- Test restores: PASSED
EOF
else
    log "Verification completed with ${ERRORS} errors"
    cat <<EOF | mail -s "[BACKUP VERIFY FAILED] ${DATE}" "${EMAIL_ALERT}"
Backup verification completed with errors.

Date: $(date)
Errors: ${ERRORS}
Log: ${LOG_FILE}

Please review the log file for details.
EOF
    exit 1
fi

exit 0
```

### Monthly Test Restore

**Location:** `/usr/local/bin/backup-monthly-test.sh`

```bash
#!/bin/bash
#
# Monthly full restore test
# Runs first Monday of each month
#

set -euo pipefail

TEST_VM="restore-test.cyberinabox.net"
BACKUP_ROOT="/datastore/backups"
LOG_FILE="/var/log/backups/monthly-test-$(date +%Y%m).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

log "========== Starting monthly restore test =========="

# Test 1: FreeIPA Database Restore
log "Test 1: FreeIPA database restore to test VM"
LATEST_IPA_BACKUP=$(ls -t "${BACKUP_ROOT}/daily/dc1/*/ipa-backup" | head -1)
scp -r "${LATEST_IPA_BACKUP}" admin@"${TEST_VM}":/tmp/

ssh admin@"${TEST_VM}" "sudo ipa-restore /tmp/ipa-backup --data --online --password=testpass" || {
    log "ERROR: FreeIPA restore failed"
    exit 1
}
log "FreeIPA restore: PASSED"

# Test 2: User Home Directory Restore
log "Test 2: User home directory restore"
TEST_USER="testuser"
LATEST_HOME_BACKUP=$(ls -t "${BACKUP_ROOT}/daily/dms/*/home/${TEST_USER}/" | head -1)
ssh admin@"${TEST_VM}" "mkdir -p /home/${TEST_USER}"
rsync -avz "${LATEST_HOME_BACKUP}/" admin@"${TEST_VM}":/home/${TEST_USER}/ || {
    log "ERROR: Home directory restore failed"
    exit 1
}
log "Home directory restore: PASSED"

# Test 3: Configuration Restore
log "Test 3: System configuration restore"
for config in systemd cron; do
    LATEST_CONFIG=$(ls -t "${BACKUP_ROOT}/daily/proxy/*/${config}/" | head -1)
    rsync -avz "${LATEST_CONFIG}/" admin@"${TEST_VM}":/tmp/restore-test-${config}/ || {
        log "ERROR: ${config} restore failed"
        exit 1
    }
    log "${config} configuration restore: PASSED"
done

# Test 4: Database Restore
log "Test 4: Database restore test"
LATEST_DB=$(ls -t "${BACKUP_ROOT}/database/wazuh-db-*.sql.gz" | head -1)
gunzip -c "${LATEST_DB}" | ssh admin@"${TEST_VM}" \
    "sudo -u postgres psql wazuh_test" || {
    log "ERROR: Database restore failed"
    exit 1
}
log "Database restore: PASSED"

# Generate report
log "========== Monthly Test Summary =========="
log "All restore tests passed successfully"

cat <<EOF | mail -s "[MONTHLY RESTORE TEST] Passed" admin@cyberinabox.net
Monthly backup restore test completed successfully.

Date: $(date)
Test VM: ${TEST_VM}

Tests Passed:
1. FreeIPA database restore
2. User home directory restore
3. System configuration restore
4. Database restore

All backups verified restorable.
Next test: First Monday next month

Log: ${LOG_FILE}
EOF

# Cleanup test VM
ssh admin@"${TEST_VM}" "sudo rm -rf /tmp/ipa-backup /tmp/restore-test-* /home/${TEST_USER}"

log "========== Test complete =========="
exit 0
```

## 29.4 Restore Procedures

### Single File Restore

```bash
#!/bin/bash
#
# Restore single file for user
# Usage: restore-file.sh <username> <file_path> <restore_date>
#

USERNAME="$1"
FILE_PATH="$2"
RESTORE_DATE="${3:-$(date +%Y%m%d)}"  # Default to today if not specified

BACKUP_ROOT="/datastore/backups"
RESTORE_LOCATION="/tmp/restored-files/${USERNAME}"

# Create restore directory
mkdir -p "${RESTORE_LOCATION}"

# Find file in backup
BACKUP_FILE="${BACKUP_ROOT}/daily/dms/${RESTORE_DATE}/home/${USERNAME}${FILE_PATH}"

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "ERROR: File not found in backup from ${RESTORE_DATE}"
    echo "Searching previous backups..."

    # Search last 7 days
    for i in {1..7}; do
        PREV_DATE=$(date -d "${RESTORE_DATE} -${i} days" +%Y%m%d)
        BACKUP_FILE="${BACKUP_ROOT}/daily/dms/${PREV_DATE}/home/${USERNAME}${FILE_PATH}"

        if [ -f "${BACKUP_FILE}" ]; then
            echo "Found in backup from ${PREV_DATE}"
            RESTORE_DATE="${PREV_DATE}"
            break
        fi
    done
fi

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "ERROR: File not found in any recent backup"
    exit 1
fi

# Restore file
cp -p "${BACKUP_FILE}" "${RESTORE_LOCATION}/"
chown "${USERNAME}:${USERNAME}" "${RESTORE_LOCATION}/$(basename "${FILE_PATH}")"

echo "File restored to: ${RESTORE_LOCATION}/$(basename "${FILE_PATH}")"
echo "Original from: ${RESTORE_DATE}"
echo "User can copy from this location to desired destination"

# Notify user
mail -s "File Restore Complete" "${USERNAME}@cyberinabox.net" <<EOF
Your file has been restored from backup.

Original file: ${FILE_PATH}
Backup date: ${RESTORE_DATE}
Restored to: ${RESTORE_LOCATION}/$(basename "${FILE_PATH}")

Please copy this file to your desired location.
The restored file will be kept for 7 days, then automatically deleted.

If this is not the correct version, please contact the administrator
to restore from a different date.
EOF

exit 0
```

### Full System Restore

```bash
#!/bin/bash
#
# Full system restore from backup
# Usage: restore-system.sh <hostname> <restore_date>
#

HOSTNAME="$1"
RESTORE_DATE="${2:-$(date +%Y%m%d)}"
BACKUP_ROOT="/datastore/backups"
BACKUP_DIR="${BACKUP_ROOT}/daily/${HOSTNAME}/${RESTORE_DATE}"

if [ ! -d "${BACKUP_DIR}" ]; then
    echo "ERROR: No backup found for ${HOSTNAME} on ${RESTORE_DATE}"
    exit 1
fi

echo "WARNING: This will restore ${HOSTNAME} from backup dated ${RESTORE_DATE}"
echo "This operation will:"
echo "  - Overwrite current system configuration"
echo "  - Restore all files from backup"
echo "  - Require system reboot"
read -p "Are you sure? (yes/no): " CONFIRM

if [ "${CONFIRM}" != "yes" ]; then
    echo "Restore cancelled"
    exit 0
fi

echo "Starting restore of ${HOSTNAME}..."

case "${HOSTNAME}" in
    dc1.cyberinabox.net)
        echo "Restoring FreeIPA..."
        rsync -avz --delete "${BACKUP_DIR}/ipa-backup/" \
            admin@"${HOSTNAME}":/tmp/ipa-restore/
        ssh admin@"${HOSTNAME}" \
            "sudo ipa-restore /tmp/ipa-restore --data --online --password=IpaPassword"
        ;;

    dms.cyberinabox.net)
        echo "Restoring user files..."
        rsync -avz --delete "${BACKUP_DIR}/home/" \
            admin@"${HOSTNAME}":/home/
        rsync -avz --delete "${BACKUP_DIR}/exports/" \
            admin@"${HOSTNAME}":/exports/
        ;;

    # Add other systems as needed
esac

# Always restore configuration
echo "Restoring configuration files..."
rsync -avz "${BACKUP_DIR}/etc/" admin@"${HOSTNAME}":/etc/

echo "Restore complete. Rebooting ${HOSTNAME}..."
ssh admin@"${HOSTNAME}" "sudo reboot"

echo "System restore initiated. Monitor system status after reboot."
exit 0
```

## 29.5 Offsite Backup Configuration

### Offsite Sync Script

**Location:** `/usr/local/bin/backup-offsite-sync.sh`

```bash
#!/bin/bash
#
# Sync backups to offsite location
# Runs every 6 hours
#

set -euo pipefail

BACKUP_ROOT="/datastore/backups"
OFFSITE_STAGING="${BACKUP_ROOT}/offsite-staging"
OFFSITE_SERVER="backup.example.com"  # Replace with actual offsite server
OFFSITE_PATH="/backups/cyberhygiene/"
LOG_FILE="/var/log/backups/offsite-sync-$(date +%Y%m%d-%H%M).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

log "Starting offsite sync..."

# Stage recent backups for offsite
log "Staging recent backups..."
rsync -avz --delete \
    --include="*/$(date +%Y%m%d)*" \
    --include="*/$(date -d yesterday +%Y%m%d)*" \
    --exclude="*" \
    "${BACKUP_ROOT}/daily/" "${OFFSITE_STAGING}/" || exit 1

# Encrypt staged backups
log "Encrypting backups..."
for file in $(find "${OFFSITE_STAGING}" -type f -name "*.tar.gz"); do
    if [ ! -f "${file}.gpg" ]; then
        gpg --encrypt --recipient admin@cyberinabox.net "${file}" || exit 1
        rm "${file}"  # Remove unencrypted after encryption
    fi
done

# Sync to offsite server
log "Syncing to offsite location..."
rsync -avz --delete -e "ssh -i /root/.ssh/backup_key" \
    "${OFFSITE_STAGING}/" \
    backup-user@"${OFFSITE_SERVER}":"${OFFSITE_PATH}" || exit 1

# Verify sync
OFFSITE_COUNT=$(ssh -i /root/.ssh/backup_key backup-user@"${OFFSITE_SERVER}" \
    "find ${OFFSITE_PATH} -type f | wc -l")
LOCAL_COUNT=$(find "${OFFSITE_STAGING}" -type f | wc -l)

if [ "${OFFSITE_COUNT}" -ne "${LOCAL_COUNT}" ]; then
    log "WARNING: File count mismatch (Local: ${LOCAL_COUNT}, Offsite: ${OFFSITE_COUNT})"
    exit 1
fi

log "Offsite sync complete. Files synced: ${LOCAL_COUNT}"
exit 0
```

---

**Backup Procedures Quick Reference:**

**Backup Schedule:**
- Critical systems: Hourly + Daily (02:00 AM)
- Standard systems: Daily (03:00 AM)
- Databases: Daily (02:15 AM)
- Verification: Daily (06:00 AM)
- Offsite sync: Every 6 hours

**Manual Backup:**
```bash
# Backup single system
/usr/local/bin/backup-system.sh dc1.cyberinabox.net

# Backup all systems
/usr/local/bin/backup-all-systems.sh

# Backup databases only
/usr/local/bin/backup-databases.sh

# Verify backups
/usr/local/bin/backup-verify.sh
```

**Restore Operations:**
```bash
# Restore single file
/usr/local/bin/restore-file.sh username /path/to/file 20251231

# Restore full system
/usr/local/bin/restore-system.sh hostname 20251231

# List available backups
ls -lh /datastore/backups/daily/
```

**Monitoring:**
```bash
# Check backup logs
tail -f /var/log/backups/backup-$(date +%Y%m%d).log

# Check backup space
df -h /datastore/backups

# List recent backups
ls -lht /datastore/backups/daily/*/$(date +%Y%m%d)
```

**Cron Schedule:**
```bash
# View backup cron jobs
sudo crontab -l | grep backup

# Typical schedule:
# 0 2 * * * /usr/local/bin/backup-all-systems.sh
# 0 6 * * * /usr/local/bin/backup-verify.sh
# 0 */6 * * * /usr/local/bin/backup-offsite-sync.sh
# 0 10 * * 1 /usr/local/bin/backup-monthly-test.sh  # First Monday
```

---

**Related Chapters:**
- Chapter 23: Backup & Recovery (User Guide)
- Chapter 32: Emergency Procedures
- Appendix C: Command Reference
- Appendix D: Troubleshooting Guide

**For Help:**
- Backup issues: Check /var/log/backups/
- Space issues: df -h /datastore/backups
- Restore requests: dshannon@cyberinabox.net
- Emergency: See Chapter 32
