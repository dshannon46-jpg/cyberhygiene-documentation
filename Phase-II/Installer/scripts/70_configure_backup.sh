#!/bin/bash
#
# Module 70: Configure Backup System
# Automated encrypted backups
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [70-BACKUP] $*"
}

log "Configuring backup system..."

# Install backup tools
log "Installing backup tools..."
dnf install -y rsync tar gzip openssl

log "✓ Backup tools installed"

# Create backup directories
log "Creating backup directories..."
mkdir -p /backup/daily
mkdir -p /backup/weekly
mkdir -p /backup/monthly
chmod 700 /backup

log "✓ Backup directories created"

# Create backup script
log "Creating backup script..."
cat > /usr/local/bin/cyberhygiene-backup.sh <<'EOF'
#!/bin/bash
#
# CyberHygiene Automated Backup Script
#

set -euo pipefail

# Configuration
BACKUP_ROOT="/backup"
BACKUP_KEY="__BACKUP_KEY__"
DATE=$(date +%Y%m%d_%H%M%S)
DAY_OF_WEEK=$(date +%u)
DAY_OF_MONTH=$(date +%d)

# Determine backup type
if [[ "${DAY_OF_MONTH}" == "01" ]]; then
    BACKUP_TYPE="monthly"
    RETENTION_DAYS=90
elif [[ "${DAY_OF_WEEK}" == "7" ]]; then
    BACKUP_TYPE="weekly"
    RETENTION_DAYS=30
else
    BACKUP_TYPE="daily"
    RETENTION_DAYS=7
fi

BACKUP_DIR="${BACKUP_ROOT}/${BACKUP_TYPE}"
BACKUP_FILE="${BACKUP_DIR}/backup_${DATE}.tar.gz.enc"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [BACKUP] $*" | tee -a /var/log/cyberhygiene-backup.log
}

log "Starting ${BACKUP_TYPE} backup..."

# Create backup archive
log "Creating backup archive..."
TEMP_ARCHIVE="/tmp/backup_${DATE}.tar.gz"

tar -czf "${TEMP_ARCHIVE}" \
    --exclude='/tmp/*' \
    --exclude='/var/tmp/*' \
    --exclude='/backup/*' \
    /etc \
    /var/ossec/etc \
    /var/lib/ipa \
    /datastore \
    /root 2>/dev/null || true

log "✓ Archive created: $(du -h ${TEMP_ARCHIVE} | cut -f1)"

# Encrypt backup
log "Encrypting backup..."
openssl enc -aes-256-cbc -salt -pbkdf2 \
    -in "${TEMP_ARCHIVE}" \
    -out "${BACKUP_FILE}" \
    -pass pass:"${BACKUP_KEY}"

rm -f "${TEMP_ARCHIVE}"

log "✓ Backup encrypted: ${BACKUP_FILE}"
log "Size: $(du -h ${BACKUP_FILE} | cut -f1)"

# Clean old backups
log "Cleaning old backups (retention: ${RETENTION_DAYS} days)..."
find "${BACKUP_DIR}" -type f -name "backup_*.tar.gz.enc" -mtime +${RETENTION_DAYS} -delete
log "✓ Old backups cleaned"

# Verify backup
log "Verifying backup integrity..."
if openssl enc -aes-256-cbc -d -pbkdf2 \
    -in "${BACKUP_FILE}" \
    -pass pass:"${BACKUP_KEY}" | tar -tzf - > /dev/null 2>&1; then
    log "✓ Backup verification successful"
else
    log "ERROR: Backup verification failed!"
    exit 1
fi

log "${BACKUP_TYPE} backup complete: ${BACKUP_FILE}"
EOF

# Substitute backup key
sed -i "s/__BACKUP_KEY__/${BACKUP_KEY}/" /usr/local/bin/cyberhygiene-backup.sh
chmod 700 /usr/local/bin/cyberhygiene-backup.sh

log "✓ Backup script created"

# Create backup restoration script
log "Creating restore script..."
cat > /usr/local/bin/cyberhygiene-restore.sh <<'EOF'
#!/bin/bash
#
# CyberHygiene Backup Restore Script
#

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <backup_file.tar.gz.enc>"
    echo ""
    echo "Available backups:"
    find /backup -type f -name "backup_*.tar.gz.enc" -exec ls -lh {} \;
    exit 1
fi

BACKUP_FILE="$1"
BACKUP_KEY="__BACKUP_KEY__"

if [[ ! -f "${BACKUP_FILE}" ]]; then
    echo "ERROR: Backup file not found: ${BACKUP_FILE}"
    exit 1
fi

echo "WARNING: This will restore from backup and may overwrite current data!"
read -p "Are you sure? (yes/no): " CONFIRM

if [[ "${CONFIRM}" != "yes" ]]; then
    echo "Restore cancelled"
    exit 0
fi

echo "Decrypting and extracting backup..."
openssl enc -aes-256-cbc -d -pbkdf2 \
    -in "${BACKUP_FILE}" \
    -pass pass:"${BACKUP_KEY}" | tar -xzf - -C /

echo "✓ Restore complete"
echo "You may need to restart services:"
echo "  systemctl restart ipa"
echo "  systemctl restart wazuh-manager"
EOF

# Substitute backup key
sed -i "s/__BACKUP_KEY__/${BACKUP_KEY}/" /usr/local/bin/cyberhygiene-restore.sh
chmod 700 /usr/local/bin/cyberhygiene-restore.sh

log "✓ Restore script created"

# Create cron job for automated backups
log "Configuring automated backups..."
cat > /etc/cron.d/cyberhygiene-backup <<EOF
# CyberHygiene Automated Backups
# Runs daily at 2 AM

0 2 * * * root /usr/local/bin/cyberhygiene-backup.sh
EOF

chmod 644 /etc/cron.d/cyberhygiene-backup

log "✓ Cron job created (daily at 2 AM)"

# Run initial backup
log "Running initial backup..."
/usr/local/bin/cyberhygiene-backup.sh

echo ""
log "=========================================="
log "Backup System Configuration Summary"
log "=========================================="
log "✓ Backup system configured"
log "✓ Automated backups enabled"
log ""
log "Backup location: /backup/"
log "Backup types:"
log "  - Daily (7 day retention)"
log "  - Weekly (30 day retention)"
log "  - Monthly (90 day retention)"
log ""
log "Schedule: Daily at 2:00 AM"
log ""
log "Manual backup: /usr/local/bin/cyberhygiene-backup.sh"
log "Restore: /usr/local/bin/cyberhygiene-restore.sh <file>"
log ""
log "Backup encryption key: [Stored in CREDENTIALS file]"
log ""

exit 0
