# Backup and Restore Procedures for dc1.cyberinabox.net

**Document Version:** 1.0
**Last Updated:** December 28, 2025
**System:** CyberHygiene Production Network

---

## Backup Configuration

### Backup Location
- **NAS:** Synology datastore.cyberinabox.net (192.168.1.118)
- **Share:** /volume1/NFSBackup
- **Mount Point:** /mnt/nas-backup
- **Protocol:** NFS v3

### Backup Schedule
- **Frequency:** Daily at 3:00 AM
- **Cron Job:** /etc/cron.d/nas-backup
- **Script:** /usr/local/bin/backup-to-nas-encrypted.sh (FIPS-compliant encrypted backups)
- **Legacy Script:** /usr/local/bin/backup-to-nas-nfs.sh (unencrypted, deprecated)
- **Log File:** /var/log/nas-backup-encrypted.log

### Backup Contents
- Source: `/backup/` directory
- Includes:
  - daily/ - Daily system snapshots
  - weekly/ - Weekly snapshots
  - logs/ - System logs
  - personnel-security/ - Personnel data
  - system-migration-* - Migration backups

### Encryption Configuration (FIPS-Compliant)
- **Encryption Method:** AES-256-CBC with PBKDF2 (100,000 iterations)
- **Encryption Key:** /root/.backup-encryption/backup.key (400 permissions, root-only access)
- **Backup Location:** /mnt/nas-backup/encrypted/
- **Naming Convention:** backup-YYYYMMDD-HHMMSS.tar.gz.enc
- **Checksum Files:** backup-YYYYMMDD-HHMMSS.tar.gz.enc.sha256
- **Compliance:** FIPS 140-2 validated cryptography for CUI data protection
- **NIST SP 800-171 Requirement:** 3.13.11 - Cryptographic protection of CUI at rest

**IMPORTANT:** The encryption key must be backed up securely and stored separately from the encrypted backups. Loss of the encryption key means permanent loss of access to all encrypted backups.

---

## Manual Backup Commands

### Run Immediate Encrypted Backup
```bash
sudo /usr/local/bin/backup-to-nas-encrypted.sh
```

### Check Backup Status
```bash
tail -f /var/log/nas-backup-encrypted.log
```

### Verify NFS Mount
```bash
df -h | grep nas-backup
mountpoint /mnt/nas-backup
```

### List Available Encrypted Backups
```bash
sudo /usr/local/bin/restore-encrypted-backup.sh -l
```

### Verify Encrypted Backup Integrity
```bash
sudo /usr/local/bin/restore-encrypted-backup.sh -v backup-YYYYMMDD-HHMMSS.tar.gz.enc
```

---

## Restore Procedures

### Encrypted Backup Restore (Current Method)

### 1. List Available Encrypted Backups
```bash
sudo /usr/local/bin/restore-encrypted-backup.sh -l
```

### 2. Verify Backup Integrity
```bash
sudo /usr/local/bin/restore-encrypted-backup.sh -v backup-YYYYMMDD-HHMMSS.tar.gz.enc
```

### 3. Restore Encrypted Backup
```bash
# Restore to default location (/root/restore-YYYYMMDD-HHMMSS)
sudo /usr/local/bin/restore-encrypted-backup.sh backup-YYYYMMDD-HHMMSS.tar.gz.enc

# Or restore to specific directory
sudo /usr/local/bin/restore-encrypted-backup.sh -d /root/my-restore backup-YYYYMMDD-HHMMSS.tar.gz.enc
```

### 4. Review Restored Files
```bash
cd /root/restore-YYYYMMDD-HHMMSS
ls -lh
```

### 5. Restore Specific Files/Directories
```bash
# Example: Restore IPA configuration
sudo cp -a /root/restore-YYYYMMDD-HHMMSS/daily/latest/ipa-config.tar.gz /root/
cd /root
tar -xzf ipa-config.tar.gz
# Review files before copying to /etc/ipa/
```

---

### Legacy Unencrypted Backup Restore (Deprecated)

### 1. List Available Backup Snapshots
```bash
ls -lh /mnt/nas-backup/daily/
```

### 2. View Backup Contents
```bash
ls -lh /mnt/nas-backup/daily/YYYYMMDD-HHMMSS/
cat /mnt/nas-backup/daily/YYYYMMDD-HHMMSS/MANIFEST.txt
```

### 3. Restore Single File/Directory
```bash
# Create restore directory
sudo mkdir -p /root/restore-YYYYMMDD

# Restore specific backup
sudo rsync -av /mnt/nas-backup/daily/YYYYMMDD-HHMMSS/ /root/restore-YYYYMMDD/

# Verify integrity
cd /root/restore-YYYYMMDD
sha256sum -c checksums.sha256
```

### 4. Restore System Configuration
```bash
# Extract configuration archives
cd /root/restore-YYYYMMDD
tar -xzf ipa-config.tar.gz -C /etc/ipa/
tar -xzf ssh-config.tar.gz -C /etc/ssh/
tar -xzf samba-config.tar.gz -C /etc/samba/
tar -xzf firewalld-config.tar.gz -C /etc/firewalld/
tar -xzf audit-config.tar.gz -C /etc/audit/

# Restart services
systemctl restart sshd
systemctl restart firewalld
systemctl restart auditd
```

### 5. Full System Restore
```bash
# Mount NFS if not already mounted
sudo mount /mnt/nas-backup

# Choose backup snapshot
BACKUP_DATE="YYYYMMDD-HHMMSS"

# Restore to temporary location first
sudo mkdir -p /root/full-restore
sudo rsync -av /mnt/nas-backup/daily/$BACKUP_DATE/ /root/full-restore/

# Verify checksums
cd /root/full-restore
sha256sum -c checksums.sha256

# Extract all configuration files (review MANIFEST.txt first)
# Then restore configurations manually to avoid system breakage
```

---

## Disaster Recovery

### Emergency NFS Mount (if auto-mount fails)
```bash
sudo mount -t nfs -o vers=3 192.168.1.118:/volume1/NFSBackup /mnt/nas-backup
```

### Restore from NAS Web Interface
1. Log into https://192.168.1.118:5001
2. Open File Station
3. Navigate to NFSBackup/daily/
4. Download required backup snapshot
5. Extract and restore manually

### Restore IPA Data
```bash
# Restore IPA configuration
cd /root/restore-YYYYMMDD
tar -xzf ipa-config.tar.gz
# Review extracted files before copying to /etc/ipa/

# Restore IPA users/groups using ipa-restore or manual import
# See ipa-users.txt and ipa-groups.txt for reference
```

---

## Verification

### Test Restore (Monthly Recommended)
```bash
# Create test restore directory
sudo mkdir -p /root/restore-test-$(date +%Y%m%d)
cd /root/restore-test-$(date +%Y%m%d)

# Get latest backup
LATEST=$(ls -1 /mnt/nas-backup/daily/ | tail -1)

# Restore latest backup
sudo rsync -av /mnt/nas-backup/daily/$LATEST/ ./

# Verify integrity
sha256sum -c checksums.sha256

# Review MANIFEST.txt
cat MANIFEST.txt

# Clean up
cd /root
sudo rm -rf restore-test-$(date +%Y%m%d)
```

### Monitor Backup Health
```bash
# Check last encrypted backup status
tail -50 /var/log/nas-backup-encrypted.log

# List encrypted backups
sudo /usr/local/bin/restore-encrypted-backup.sh -l

# Verify encrypted backup size growth
du -sh /mnt/nas-backup/encrypted/

# Check NAS disk space
df -h /mnt/nas-backup
```

---

## Troubleshooting

### NFS Mount Issues
```bash
# Check NFS service on NAS
rpcinfo -p 192.168.1.118 | grep nfs

# Check available exports
showmount -e 192.168.1.118

# Remount manually
sudo umount /mnt/nas-backup
sudo mount -t nfs -o vers=3 192.168.1.118:/volume1/NFSBackup /mnt/nas-backup
```

### Backup Script Failures
```bash
# Check script permissions
ls -l /usr/local/bin/backup-to-nas-nfs.sh

# Run in debug mode
sudo bash -x /usr/local/bin/backup-to-nas-nfs.sh

# Check cron logs
sudo journalctl -u crond | grep backup
```

### Network Connectivity
```bash
# Test NAS connectivity
ping -c 3 192.168.1.118

# Verify DNS resolution
host datastore.cyberinabox.net

# Check firewall
sudo firewall-cmd --list-all | grep nfs
```

---

## Best Practices

1. **CRITICAL: Backup the encryption key** - The encryption key at `/root/.backup-encryption/backup.key` must be backed up to a secure, separate location. Without this key, encrypted backups cannot be restored. Store the key:
   - On a secure USB drive in a physically secure location
   - In a password manager with strong encryption
   - In a separate secure system with appropriate access controls
   - NEVER store the key on the NAS with the encrypted backups

2. **Test encrypted restores monthly** to ensure backup integrity and verify the encryption key works
   ```bash
   sudo /usr/local/bin/restore-encrypted-backup.sh -v backup-YYYYMMDD-HHMMSS.tar.gz.enc
   ```

3. **Monitor encrypted backup logs** for failures
   ```bash
   tail -50 /var/log/nas-backup-encrypted.log
   ```

4. **Verify checksums** before and after each restore

5. **Keep multiple encrypted snapshots** (automated by daily backups)

6. **Rotate old encrypted backups** - Consider implementing a retention policy to manage storage:
   - Keep daily backups for 30 days
   - Keep weekly backups for 90 days
   - Keep monthly backups for 1 year

7. **Document any manual changes** to backup procedures

8. **Audit encryption key access** - Review who has access to the encryption key regularly

---

## Emergency Contacts

- **NAS Admin:** dshannon
- **System Owner:** Daniel Shannon
- **Documentation:** This file (/root/BACKUP_RESTORE_PROCEDURES.md)

---

**END OF DOCUMENT**
