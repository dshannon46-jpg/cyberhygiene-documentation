# BACKUP AND RECOVERY PROCEDURES
**Organization:** The Contract Coach (Donald E. Shannon LLC)
**System:** CyberHygiene Production Network (cyberinabox.net)
**Version:** 1.0
**Effective Date:** November 1, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)

**NIST Controls:** CP-9, CP-10, SC-28, MP-5, MP-6

---

## DOCUMENT CONTROL

| Name / Title | Role | Signature / Date |
|---|---|---|
| Donald E. Shannon<br>Owner/Principal | System Owner | _____________________<br>Date: _______________ |
| Donald E. Shannon<br>Owner/Principal | Backup Administrator | _____________________<br>Date: _______________ |

**Review Schedule:** Quarterly or upon significant changes
**Next Review Date:** February 1, 2026

---

## 1. PURPOSE AND SCOPE

### 1.1 Purpose
This document establishes standardized backup and recovery procedures for the CyberHygiene Production Network, ensuring business continuity, disaster recovery capability, and compliance with NIST SP 800-171 requirements for protecting Controlled Unclassified Information (CUI).

### 1.2 Scope
These procedures apply to:
- Production data on dc1.cyberinabox.net
- FreeIPA directory and configuration
- System configurations and security settings
- User home directories and shared files
- All CUI and FCI data

### 1.3 3-2-1 Backup Strategy

The organization implements industry best practice 3-2-1 backup strategy:

```
3 COPIES of all critical data:
  Copy 1: Production data on dc1 (LUKS-encrypted RAID + SSD)
  Copy 2: Network backup on DataStore Synology NAS (FIPS pre-encrypted)
  Copy 3: Offsite removable media (LUKS-encrypted USB drives)

2 DIFFERENT MEDIA TYPES:
  Media 1: On-premises storage (dc1 SSD/RAID + DataStore NAS)
  Media 2: Removable media (USB external drives)

1 COPY OFFSITE:
  Wells Fargo Bank safe deposit box (LUKS-encrypted USB drives)
```

---

## 2. BACKUP INFRASTRUCTURE

### 2.1 System Components

**Primary System (dc1.cyberinabox.net):**
- HP MicroServer Gen 10+
- Rocky Linux 9.6 with FIPS 140-2 mode enabled
- LUKS-encrypted storage (RAID 5 + SSD)
- IP: 192.168.1.10/24

**Network Backup Storage (DataStore):**
- Synology DS1821+ NAS
- DSM 7.2.2-72806 Update 4
- 20.9 TB total storage (19.3 TB available)
- IP: 192.168.1.118/24
- **Status:** OUTSIDE FIPS ACCREDITATION BOUNDARY
- **Purpose:** Stores FIPS pre-encrypted backup data only

**Offsite Storage:**
- 3x FIPS 140-2 compatible USB drives (minimum 2TB each)
- LUKS2 full-disk encryption
- Wells Fargo Bank safe deposit box
- Quarterly rotation schedule

### 2.2 Backup Scripts Location

All backup scripts are located in `/usr/local/bin/backups/`:

```
/usr/local/bin/backups/
├── daily-backup-to-datastore.sh         (Automated - Daily 02:00 AM)
├── weekly-rear-backup-to-datastore.sh   (Automated - Sunday 03:00 AM)
├── monthly-usb-offsite-backup.sh        (Manual - 1st business day)
└── setup-backup-automation.sh           (One-time setup)
```

### 2.3 Systemd Timers

Automated backups are managed by systemd timers:

```
/etc/systemd/system/
├── daily-backup-datastore.service
├── daily-backup-datastore.timer
├── weekly-rear-backup-datastore.service
└── weekly-rear-backup-datastore.timer
```

---

## 3. DAILY BACKUPS TO DATASTORE

### 3.1 Overview

**Purpose:** Daily incremental backup of critical files to DataStore NAS
**Frequency:** Daily at 02:00 AM (automated)
**Retention:** 30 days rolling
**Encryption:** OpenSSL AES-256-CBC with PBKDF2 (FIPS validated)
**Script:** `/usr/local/bin/backups/daily-backup-to-datastore.sh`

### 3.2 Backup Sources

The daily backup includes:
- `/data` - Primary data storage
- `/var/lib/ipa` - FreeIPA database and configuration
- `/etc` - System configuration files
- `/home` - User home directories

### 3.3 Automated Execution

Daily backups run automatically via systemd timer. No user intervention required.

**Check timer status:**
```bash
systemctl status daily-backup-datastore.timer
systemctl list-timers daily-backup-datastore.timer
```

**View recent backup logs:**
```bash
sudo tail -f /var/log/backups/daily-backup.log
sudo journalctl -u daily-backup-datastore.service -n 50
```

### 3.4 Manual Execution

To run a daily backup manually:

```bash
sudo /usr/local/bin/backups/daily-backup-to-datastore.sh
```

### 3.5 Backup Process Flow

1. **Verify FIPS mode** is enabled
2. **Create tar.gz archive** of all backup sources
3. **Encrypt with OpenSSL** using FIPS-validated AES-256-CBC
   - Key derivation: PBKDF2 with 100,000 iterations
   - Passphrase: `/root/.backup-passphrase`
4. **Transfer to DataStore** via rsync over SSH
   - SSH cipher: aes256-gcm@openssh.com (FIPS-approved)
5. **Verify backup** on remote system
6. **Clean up old backups** (local: 7 days, remote: 30 days)
7. **Log all operations** to `/var/log/backups/daily-backup.log`

### 3.6 Encryption Details

**Algorithm:** AES-256-CBC (FIPS 140-2 validated)
**Key Derivation:** PBKDF2 with 100,000 iterations
**Passphrase Storage:** `/root/.backup-passphrase` (600 permissions)
**Transport:** TLS via SSH with FIPS-approved ciphers

**IMPORTANT:** DataStore stores only pre-encrypted blobs. All encryption/decryption occurs on dc1 in FIPS mode.

### 3.7 Restoration from Daily Backup

```bash
# Retrieve encrypted backup from DataStore
sudo rsync -avz \
  synology@192.168.1.118:/volume1/backups/daily/daily-backup-YYYYMMDD-*.tar.gz.enc \
  /tmp/

# Decrypt on FIPS-validated system (dc1)
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -pass file:/root/.backup-passphrase \
  -in /tmp/daily-backup-*.tar.gz.enc | tar xzf - -C /restore/

# Files are now available in /restore/
```

---

## 4. WEEKLY DISASTER RECOVERY BACKUPS

### 4.1 Overview

**Purpose:** Weekly full system disaster recovery ISO creation
**Frequency:** Sunday at 03:00 AM (automated)
**Retention:** 12 weeks on DataStore, 4 weeks local
**Tool:** ReaR (Relax-and-Recover)
**Script:** `/usr/local/bin/backups/weekly-rear-backup-to-datastore.sh`

### 4.2 ReaR ISO Contents

The ReaR ISO contains:
- Bootable rescue system
- Complete system backup
- LUKS-encrypted partitions (FIPS validated)
- System configuration
- Partition layout and boot configuration

### 4.3 Automated Execution

Weekly backups run automatically every Sunday. No user intervention required.

**Check timer status:**
```bash
systemctl status weekly-rear-backup-datastore.timer
systemctl list-timers weekly-rear-backup-datastore.timer
```

**View recent backup logs:**
```bash
sudo tail -f /var/log/backups/weekly-rear-backup.log
sudo journalctl -u weekly-rear-backup-datastore.service -n 50
```

### 4.4 Manual Execution

To run a weekly backup manually:

```bash
sudo /usr/local/bin/backups/weekly-rear-backup-to-datastore.sh
```

### 4.5 Backup Process Flow

1. **Verify FIPS mode** is enabled
2. **Run ReaR** to create bootable ISO
   - Command: `rear -v mkbackup`
   - Output: `/var/lib/rear/output/rear-*.iso`
3. **Calculate SHA256 checksum** of ISO
4. **Transfer ISO to DataStore** via rsync over SSH
5. **Verify remote backup** and checksum
6. **Clean up old ISOs** (local: 28 days, remote: 84 days)
7. **Log all operations** to `/var/log/backups/weekly-rear-backup.log`

### 4.6 Disaster Recovery Procedure

**Scenario:** Complete system failure requiring full restoration

```bash
# 1. Boot from ReaR ISO (CD/DVD or USB)
#    - ISO available at: /var/lib/rear/output/rear-*.iso
#    - Or retrieve from DataStore

# 2. At ReaR prompt, run:
rear recover

# 3. ReaR will:
#    - Recreate partition layout
#    - Restore LUKS encryption
#    - Restore all system files
#    - Reinstall bootloader
#    - Prompt for LUKS passphrases

# 4. After completion:
reboot

# 5. System should boot normally
#    - Verify FIPS mode: fips-mode-setup --check
#    - Verify services: sudo ipactl status
#    - Test user authentication
```

### 4.7 ISO Verification

Before relying on a ReaR ISO for disaster recovery, test it:

```bash
# Verify ISO integrity
sha256sum -c /var/lib/rear/output/rear-*.iso.sha256

# Test ISO in VM (recommended quarterly)
# 1. Create test VM with similar hardware
# 2. Boot from ReaR ISO
# 3. Perform test recovery
# 4. Verify system functionality
# 5. Document results
```

---

## 5. MONTHLY OFFSITE USB BACKUPS

### 5.1 Overview

**Purpose:** Monthly full backup to encrypted USB drives for offsite storage
**Frequency:** 1st business day of each month (MANUAL)
**Retention:** 12 months minimum
**Encryption:** LUKS2 full-disk encryption (FIPS validated)
**Script:** `/usr/local/bin/backups/monthly-usb-offsite-backup.sh`
**Offsite Location:** Wells Fargo Bank safe deposit box

### 5.2 USB Drive Rotation Schedule

**3-Drive Quarterly Rotation:**

```
Drive A: January, April, July, October
Drive B: February, May, August, November
Drive C: March, June, September, December

Rotation Flow:
- Month N: Backup to Drive X → Transport to Wells Fargo
- Month N: Previous Drive Y returns to office for next backup
- Always 2 drives in Wells Fargo, 1 drive on-premises
```

**Example 2026 Schedule:**
```
January:   Backup to Drive A → Bank (Drive B returns)
February:  Backup to Drive B → Bank (Drive C returns)
March:     Backup to Drive C → Bank (Drive A returns)
April:     Backup to Drive A → Bank (Drive B returns)
[continues...]
```

### 5.3 Monthly Backup Procedure

**STEP 1: Preparation (Day before)**
- Retrieve appropriate USB drive from Wells Fargo Bank
- Verify drive label and physical condition
- Update chain of custody log

**STEP 2: Connect USB Drive**
```bash
# Connect USB drive to dc1
# Identify device (CAREFULLY - wrong device will be erased!)
lsblk -d -o NAME,SIZE,MODEL,SERIAL

# Example output:
# NAME  SIZE  MODEL            SERIAL
# sdc   2T    External_USB     ABC123XYZ

# Note the device path (e.g., /dev/sdc)
```

**STEP 3: Execute Backup Script**
```bash
# Run backup script with device path
sudo /usr/local/bin/backups/monthly-usb-offsite-backup.sh /dev/sdc

# Script will:
# 1. Verify FIPS mode enabled
# 2. Confirm device selection (type YES to proceed)
# 3. Create/open LUKS2 encrypted volume
# 4. Perform full rsync backup
# 5. Copy latest ReaR ISO
# 6. Create manifest and checksums
# 7. Verify backup integrity
# 8. Unmount and close encrypted volume
# 9. Display completion instructions
```

**STEP 4: Physical Labeling**
```
Apply label to USB drive:

┌────────────────────────────────────────┐
│ CUI - ENCRYPTED BACKUP                 │
│ Drive: [A/B/C]                         │
│ Month: [MONTH YEAR]                    │
│ Organization: The Contract Coach       │
│ DO NOT DISCARD - RETURN TO OWNER      │
└────────────────────────────────────────┘
```

**STEP 5: Chain of Custody**
Record in chain of custody log:
- Date and time of backup
- Drive identifier (A/B/C)
- Backup size and file count
- SHA256 checksum
- Person performing backup
- Destination (Wells Fargo Bank)

**STEP 6: Transport to Bank**
- Disconnect USB drive from dc1
- Transport to Wells Fargo Bank within 24 hours
- Store in safe deposit box
- Record date/time in log

**STEP 7: Retrieve Previous Drive**
- Retrieve previous month's drive from safe deposit box
- Bring to home office for next month's backup cycle
- Store in secure location until needed

### 5.4 USB Drive Encryption Details

**LUKS2 Configuration:**
```
Cipher:        aes-xts-plain64
Key Size:      512 bits
Hash:          sha256
PBKDF:         pbkdf2 with 100,000 iterations
Filesystem:    ext4
Label:         CUI_BACKUP_YYYYMM
```

**Passphrase Management:**
- Stored in: `/root/.monthly-backup-passphrase`
- Permissions: 600 (root only)
- Minimum length: 20 characters
- Backup copy: Stored in secure password manager

### 5.5 Restoration from USB Backup

```bash
# Connect USB drive to FIPS-validated system
lsblk  # Identify device (e.g., /dev/sdc)

# Open LUKS volume
sudo cryptsetup luksOpen /dev/sdc monthly_backup

# Mount filesystem
sudo mkdir -p /mnt/restore
sudo mount /dev/mapper/monthly_backup /mnt/restore

# Browse and restore files
ls -la /mnt/restore/
sudo rsync -avAX /mnt/restore/data/ /data/

# Verify checksums (optional)
cd /mnt/restore
sha256sum -c backup-checksums-*.sha256

# Cleanup
sudo umount /mnt/restore
sudo cryptsetup luksClose monthly_backup
```

### 5.6 Wells Fargo Bank Safe Deposit Box

**Security Features:**
- Bank-grade physical security
- Dual-key access control (bank key + customer key)
- 24/7 surveillance and alarm systems
- Fire and water protection
- Limited access (business hours only)
- Access log maintained by bank

**Access Procedures:**
- Authorized accessor: Donald E. Shannon only
- Photo ID required
- Bank signature card on file
- Both keys required (customer + bank vault)
- All access logged by bank security

---

## 6. BACKUP RETENTION POLICY

### 6.1 Retention Schedule

| Backup Type | Location | Retention Period | Purge Method |
|-------------|----------|------------------|--------------|
| Daily backups | DataStore | 30 days rolling | Automatic deletion |
| Daily backups (local) | dc1 /backup | 7 days rolling | Automatic deletion |
| Weekly ReaR ISOs | DataStore | 12 weeks | Automatic deletion |
| Weekly ReaR ISOs (local) | dc1 /var/lib/rear | 4 weeks | Automatic deletion |
| Monthly USB | Wells Fargo Bank | 12 months minimum | Manual review |
| Annual archives | TBD | Permanent | N/A |

### 6.2 Legal Hold Procedures

If backups must be retained beyond normal retention due to legal proceedings:

1. **Notification:** System owner notified of legal hold requirement
2. **Identification:** Identify specific backup periods to preserve
3. **Isolation:** Copy relevant backups to separate encrypted storage
4. **Documentation:** Record legal hold justification and duration
5. **Access Control:** Restrict access to authorized personnel only
6. **Release:** When legal hold lifted, follow normal retention/purge procedures

---

## 7. BACKUP MONITORING AND VERIFICATION

### 7.1 Daily Monitoring

**System Owner Responsibilities:**
- Check backup logs daily: `/var/log/backups/`
- Verify systemd timer execution: `systemctl list-timers`
- Review any error notifications (when email is configured)

**Automated Checks:**
```bash
# View last 24 hours of backup activity
sudo journalctl --since "24 hours ago" -u daily-backup-datastore.service

# Check timer status
systemctl status daily-backup-datastore.timer

# Verify DataStore connectivity
ssh -c aes256-gcm@openssh.com synology@192.168.1.118 "df -h /volume1/backups"
```

### 7.2 Weekly Verification

**Every Monday:**
- Verify Sunday ReaR backup completed successfully
- Check DataStore storage capacity (alert at 75% full)
- Review backup sizes for anomalies
- Test random file restoration

**Weekly Test Restoration:**
```bash
# Select random daily backup
BACKUP_FILE=$(ssh synology@192.168.1.118 \
  "ls -t /volume1/backups/daily/daily-backup-*.tar.gz.enc | head -1")

# Retrieve and decrypt small test
sudo rsync -avz synology@192.168.1.118:${BACKUP_FILE} /tmp/
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -pass file:/root/.backup-passphrase \
  -in /tmp/$(basename ${BACKUP_FILE}) | tar tzf - | head -20

# Verify files are listed correctly
```

### 7.3 Monthly Verification

**After each monthly USB backup:**
- Verify backup completed without errors
- Check chain of custody log completeness
- Confirm USB drive transported to Wells Fargo
- Review backup size trends
- Update backup tracking spreadsheet

### 7.4 Quarterly Testing

**Full Disaster Recovery Test (Quarterly):**

1. **Preparation:**
   - Schedule 4-hour maintenance window
   - Create test VM or use spare hardware
   - Retrieve latest ReaR ISO from DataStore

2. **Execution:**
   - Boot test system from ReaR ISO
   - Perform full recovery procedure
   - Verify system boots and operates
   - Test critical services (FreeIPA, etc.)

3. **Documentation:**
   - Record test date, personnel, results
   - Document any issues encountered
   - Update procedures based on lessons learned
   - File test report in compliance documentation

4. **Sign-off:**
   - System owner reviews and approves
   - Update SSP with test results

---

## 8. BACKUP SECURITY CONTROLS

### 8.1 Encryption Requirements

**All backups MUST be encrypted:**

| Backup Type | Encryption Method | Key Management |
|-------------|-------------------|----------------|
| Daily (DataStore) | OpenSSL AES-256-CBC FIPS | /root/.backup-passphrase (dc1) |
| Weekly ReaR ISOs | LUKS within ISO FIPS | System LUKS passphrases |
| Monthly USB | LUKS2 full-disk FIPS | /root/.monthly-backup-passphrase |

**FIPS 140-2 Compliance:**
- All encryption/decryption on FIPS-validated systems
- DataStore and USB drives NEVER decrypt CUI data
- Only store pre-encrypted blobs
- Transport via FIPS-approved TLS/SSH ciphers

### 8.2 Access Control

**Backup File Permissions:**
```bash
/backup/                              700 (root:root)
/backup/daily/                        700 (root:root)
/root/.backup-passphrase              600 (root:root)
/root/.monthly-backup-passphrase      600 (root:root)
/var/log/backups/                     755 (root:root)
/var/log/backups/*.log                644 (root:root)
```

**DataStore Access:**
- SSH key authentication only (no passwords)
- FIPS-approved ciphers required
- Source IP restriction (only dc1)
- Dedicated backup user account
- No shell access

**USB Drive Access:**
- Physical possession required
- LUKS passphrase required
- Dual-control for Wells Fargo safe deposit box
- Access logged

### 8.3 Audit Logging

All backup operations are logged:

**Local Logs:**
- `/var/log/backups/daily-backup.log`
- `/var/log/backups/weekly-rear-backup.log`
- `/var/log/backups/monthly-usb-backup.log`
- `journalctl -u daily-backup-datastore.service`
- `journalctl -u weekly-rear-backup-datastore.service`

**Logs Retained:** 90 days minimum

**Log Review:** Weekly by system owner

### 8.4 Chain of Custody

USB drives require chain of custody documentation:

**Chain of Custody Log Entry:**
```
Date/Time: ______________________
Drive ID: [A/B/C]
Activity: [Backup/Transport/Storage/Retrieval]
Location: [Home Office / Wells Fargo Bank]
Backup Size: _____ GB
File Count: _____
SHA256: ________________________________
Performed By: __________________________
Destination: ___________________________
Signature: _____________________________
```

Maintain log in: `/home/dshannon/Documents/Claude/Artifacts/Backup_Chain_of_Custody.xlsx`

---

## 9. TROUBLESHOOTING

### 9.1 Daily Backup Failures

**Symptom:** Daily backup fails to run

**Troubleshooting Steps:**
```bash
# 1. Check timer status
systemctl status daily-backup-datastore.timer

# 2. Check service status
systemctl status daily-backup-datastore.service

# 3. View detailed logs
sudo journalctl -xe -u daily-backup-datastore.service

# 4. Test SSH connectivity to DataStore
ssh -c aes256-gcm@openssh.com synology@192.168.1.118 "echo test"

# 5. Check DataStore storage space
ssh synology@192.168.1.118 "df -h /volume1/backups"

# 6. Verify FIPS mode
fips-mode-setup --check

# 7. Check backup passphrase file
ls -la /root/.backup-passphrase

# 8. Run backup manually with verbose output
sudo /usr/local/bin/backups/daily-backup-to-datastore.sh
```

**Common Issues:**
- **SSH key authentication failure:** Regenerate keys, update authorized_keys on DataStore
- **DataStore storage full:** Clean up old backups manually, increase retention
- **FIPS mode disabled:** Re-enable FIPS mode, reboot system
- **Network connectivity:** Check pfSense firewall rules, DataStore network settings

### 9.2 ReaR ISO Creation Failures

**Symptom:** Weekly ReaR backup fails

**Troubleshooting Steps:**
```bash
# 1. Check ReaR logs
sudo cat /var/log/rear/rear-*.log

# 2. Test ReaR manually
sudo rear -v mkbackup

# 3. Check disk space
df -h /var/lib/rear

# 4. Verify ReaR configuration
sudo cat /etc/rear/local.conf

# 5. Check LUKS encryption
sudo cryptsetup luksDump /dev/sda4
```

**Common Issues:**
- **Insufficient disk space:** Clean up old ISOs, increase /var/lib/rear partition
- **Missing dependencies:** Reinstall rear package
- **LUKS configuration:** Verify LUKS headers intact

### 9.3 USB Backup Issues

**Symptom:** Monthly USB backup fails

**Troubleshooting Steps:**
```bash
# 1. Verify USB device detected
lsblk
dmesg | tail -20

# 2. Check USB device health
sudo smartctl -a /dev/sdX

# 3. Test LUKS passphrase
sudo cryptsetup luksOpen --test-passphrase /dev/sdX

# 4. Verify LUKS header
sudo cryptsetup luksDump /dev/sdX

# 5. Check filesystem
sudo fsck /dev/mapper/monthly_backup

# 6. Run backup script in verbose mode
sudo bash -x /usr/local/bin/backups/monthly-usb-offsite-backup.sh /dev/sdX
```

**Common Issues:**
- **USB device not detected:** Check cable, try different USB port, check dmesg
- **LUKS passphrase incorrect:** Verify passphrase file, check for corruption
- **Filesystem corruption:** Run fsck, reformat if necessary (data loss)
- **Bad sectors:** Replace USB drive

### 9.4 Restoration Failures

**Symptom:** Cannot restore from backup

**Encrypted Backup Won't Decrypt:**
```bash
# Verify passphrase file integrity
ls -la /root/.backup-passphrase
cat /root/.backup-passphrase  # Should show passphrase

# Test OpenSSL decryption manually
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -pass file:/root/.backup-passphrase \
  -in backup-file.tar.gz.enc -out test.tar.gz

# If fails: Passphrase may be corrupted or wrong encryption method
```

**LUKS Volume Won't Open:**
```bash
# Verify LUKS header
sudo cryptsetup luksDump /dev/sdX

# Try with passphrase manually
sudo cryptsetup luksOpen /dev/sdX test
# Enter passphrase when prompted

# If fails: Drive may be corrupted, try backup header
sudo cryptsetup luksHeaderRestore /dev/sdX --header-backup-file luks-header-backup
```

---

## 10. DISASTER RECOVERY SCENARIOS

### 10.1 Scenario 1: Single File Deletion

**Situation:** User accidentally deletes important file

**Recovery Procedure:**
```bash
# 1. Identify file location and approximate deletion date
FILE="/data/important/document.docx"
DATE="20251115"

# 2. Retrieve most recent daily backup containing file
sudo rsync -avz \
  synology@192.168.1.118:/volume1/backups/daily/daily-backup-${DATE}-*.tar.gz.enc \
  /tmp/

# 3. Decrypt and extract
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -pass file:/root/.backup-passphrase \
  -in /tmp/daily-backup-*.tar.gz.enc | tar xzf - ./data/important/document.docx

# 4. Restore file
sudo cp ./data/important/document.docx /data/important/
sudo chown user:group /data/important/document.docx

# 5. Verify with user
```

**Recovery Time Objective (RTO):** 30 minutes
**Recovery Point Objective (RPO):** 24 hours (last daily backup)

### 10.2 Scenario 2: Directory Corruption

**Situation:** Malware encrypts /data directory (ransomware)

**Recovery Procedure:**
```bash
# 1. IMMEDIATELY DISCONNECT FROM NETWORK
ip link set eno1 down

# 2. Assess damage extent
find /data -type f -mtime -1  # Files modified in last 24 hours

# 3. Retrieve latest clean daily backup
sudo rsync -avz \
  synology@192.168.1.118:/volume1/backups/daily/daily-backup-$(date -d yesterday +%Y%m%d)-*.tar.gz.enc \
  /tmp/

# 4. Decrypt backup
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -pass file:/root/.backup-passphrase \
  -in /tmp/daily-backup-*.tar.gz.enc | tar xzf -

# 5. Compare with corrupted data
diff -r ./data /data  # Identify differences

# 6. Remove corrupted files
sudo rm -rf /data/*

# 7. Restore from backup
sudo rsync -avAX ./data/ /data/

# 8. Verify file integrity
sudo find /data -type f -exec file {} \;

# 9. Investigate malware source (see Incident Response Plan)

# 10. Reconnect to network after cleanup
ip link set eno1 up
```

**RTO:** 2-4 hours
**RPO:** 24 hours
**Follow-up:** Execute Incident Response Plan for ransomware

### 10.3 Scenario 3: Complete System Failure

**Situation:** Hardware failure requiring full system rebuild

**Recovery Procedure:**

**Phase 1: Hardware Preparation (Day 1)**
```bash
# 1. Obtain replacement hardware
#    - Similar specs to original (or better)
#    - Compatible with Rocky Linux 9.6

# 2. Retrieve latest ReaR ISO
#    From DataStore:
scp synology@192.168.1.118:/volume1/backups/disaster-recovery/rear-*.iso ~/

#    Or from USB offsite backup:
#    Retrieve from Wells Fargo Bank

# 3. Create bootable media
sudo dd if=rear-*.iso of=/dev/sdX bs=4M status=progress
sync
```

**Phase 2: System Recovery (Day 1-2)**
```bash
# 4. Boot replacement hardware from ReaR ISO

# 5. At ReaR prompt:
rear recover

# 6. ReaR will:
#    - Detect hardware differences
#    - Recreate partition layout
#    - Prompt for LUKS passphrases (have ready!)
#    - Restore all system files
#    - Reinstall bootloader

# 7. Provide LUKS passphrases when prompted
#    - Boot partition passphrase
#    - RAID array passphrase

# 8. Wait for restoration (may take several hours)

# 9. When complete:
reboot

# 10. System should boot normally
```

**Phase 3: Verification (Day 2)**
```bash
# 11. Verify FIPS mode
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled  # Should be 1

# 12. Verify services
sudo ipactl status  # All should be running
systemctl status wazuh-manager
systemctl status clamd@scan

# 13. Verify RAID array
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# 14. Verify LUKS encryption
sudo cryptsetup status samba_data

# 15. Test user authentication
kinit testuser
klist

# 16. Restore latest daily backup to get most recent files
#     (ReaR ISO may be up to 7 days old)
[Follow daily backup restoration procedure]

# 17. Verify network connectivity
ping -c 3 192.168.1.1
ping -c 3 8.8.8.8

# 18. Update SSP with recovery details
```

**Phase 4: Post-Recovery (Day 3-7)**
- Run full security scan (Wazuh, OpenSCAP)
- Verify all user accounts functional
- Test file shares, email, and other services
- Update all POA&M items related to incident
- Document lessons learned
- Update disaster recovery procedures if needed

**RTO:** 24-48 hours
**RPO:** 7 days (weekly ReaR) + daily files (24 hours)
**Hardware Lead Time:** Variable (order replacement immediately)

### 10.4 Scenario 4: Offsite Backup Needed

**Situation:** Home office destroyed (fire, flood, theft)

**Recovery Procedure:**

**Phase 1: Equipment Acquisition**
1. Obtain temporary workstation with FIPS capability
2. Install Rocky Linux 9.6 with FIPS mode
3. Configure network access

**Phase 2: Retrieve Offsite Backup**
1. Access Wells Fargo Bank safe deposit box
2. Retrieve most recent USB backup drive (Drive A/B/C)
3. Transport to temporary location

**Phase 3: Data Recovery**
```bash
# Connect USB drive to temporary system
sudo cryptsetup luksOpen /dev/sdX offsite_recovery
sudo mount /dev/mapper/offsite_recovery /mnt/recovery

# Copy critical business data
sudo rsync -avAX /mnt/recovery/data/ /tmp/recovered-data/

# Copy ReaR ISO for full recovery when hardware available
cp /mnt/recovery/rear-*.iso ~/

# Unmount and secure USB drive
sudo umount /mnt/recovery
sudo cryptsetup luksClose offsite_recovery
```

**Phase 4: Rebuild System**
- Follow Scenario 3 procedure using ReaR ISO from USB backup
- Restore data from USB backup as primary source
- Once operational, retrieve any newer data from DataStore (if accessible)

**RTO:** 3-7 days (depends on hardware acquisition)
**RPO:** Up to 31 days (monthly USB cycle)
**Note:** DataStore in same location as dc1, likely also destroyed

---

## 11. BACKUP TESTING SCHEDULE

### 11.1 Daily Tests (Automated)

- Backup script execution verification
- FIPS mode verification
- SSH connectivity test
- Encryption verification
- Transfer success confirmation

### 11.2 Weekly Tests (Manual)

**Every Monday:**
- Random file restoration test
- Backup log review
- DataStore capacity check
- Checksum verification

### 11.3 Monthly Tests (Manual)

**After each monthly USB backup:**
- USB drive health check (SMART data)
- Full backup restoration to test location
- Chain of custody log audit
- Backup size trend analysis

### 11.4 Quarterly Tests (Scheduled)

**Q1: January 31**
- Full disaster recovery test (ReaR ISO)
- USB drive rotation audit
- Backup procedures review
- Update documentation

**Q2: April 30**
- Offsite backup retrieval test
- Wells Fargo access verification
- Passphrase recovery test
- User training on restoration

**Q3: July 31**
- Full disaster recovery test (alternate hardware)
- Backup script review and update
- Performance optimization
- Capacity planning

**Q4: October 31**
- Annual backup strategy review
- Compliance assessment
- Update retention policies
- Budget planning for next year

---

## 12. BACKUP DOCUMENTATION

### 12.1 Required Documentation

Maintain current copies of:

1. **This Document:** Backup and Recovery Procedures
2. **Configuration Management Baseline** (includes backup configuration)
3. **Chain of Custody Log** (USB drive tracking)
4. **Backup Test Results** (quarterly DR tests)
5. **Incident Reports** (backup-related incidents)

### 12.2 Documentation Location

**Primary:** `/home/dshannon/Documents/Claude/Artifacts/`
**Backup:** DataStore (encrypted)
**Offsite:** USB monthly backups include all documentation

### 12.3 Annual Review

Review and update this document annually or when:
- Backup infrastructure changes
- NIST 800-171 requirements update
- Security incidents occur
- Disaster recovery tests reveal issues
- Technology improvements available

---

## APPENDIX A: QUICK REFERENCE COMMANDS

### Daily Backup Operations
```bash
# Manual daily backup
sudo /usr/local/bin/backups/daily-backup-to-datastore.sh

# Check daily backup status
systemctl status daily-backup-datastore.timer
sudo tail -f /var/log/backups/daily-backup.log

# Restore specific file
sudo rsync -avz synology@192.168.1.118:/volume1/backups/daily/daily-backup-YYYYMMDD-*.tar.gz.enc /tmp/
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -pass file:/root/.backup-passphrase -in /tmp/daily-backup-*.tar.gz.enc | tar xzf - ./path/to/file
```

### Weekly ReaR Operations
```bash
# Manual weekly backup
sudo /usr/local/bin/backups/weekly-rear-backup-to-datastore.sh

# Check weekly backup status
systemctl status weekly-rear-backup-datastore.timer
sudo tail -f /var/log/backups/weekly-rear-backup.log

# Create bootable USB from ReaR ISO
sudo dd if=/var/lib/rear/output/rear-*.iso of=/dev/sdX bs=4M status=progress
```

### Monthly USB Operations
```bash
# Connect USB and identify
lsblk -d -o NAME,SIZE,MODEL,SERIAL

# Run monthly backup
sudo /usr/local/bin/backups/monthly-usb-offsite-backup.sh /dev/sdX

# Mount existing USB backup
sudo cryptsetup luksOpen /dev/sdX monthly_backup
sudo mount /dev/mapper/monthly_backup /mnt/restore

# Unmount USB backup
sudo umount /mnt/restore
sudo cryptsetup luksClose monthly_backup
```

### Monitoring Commands
```bash
# Check all backup timers
systemctl list-timers daily-backup-datastore.timer weekly-rear-backup-datastore.timer

# View backup logs
sudo ls -lh /var/log/backups/
sudo journalctl -u daily-backup-datastore.service -n 50

# Check DataStore storage
ssh synology@192.168.1.118 "df -h /volume1/backups"
```

---

## APPENDIX B: CONTACT INFORMATION

### Emergency Contacts

**System Owner / Backup Administrator:**
- Name: Donald E. Shannon
- Title: Owner / Principal
- Organization: The Contract Coach (Donald E. Shannon LLC)
- Email: [Contact information]
- Phone: [Contact information]

**Wells Fargo Bank:**
- Branch: [Local branch information]
- Safe Deposit Box: [Box number]
- Phone: [Branch phone]
- Hours: [Business hours]

**Technical Support:**
- Rocky Linux: https://forums.rockylinux.org
- ReaR: https://relax-and-recover.org
- Synology: https://www.synology.com/support

---

**END OF DOCUMENT**

**Document Version:** 1.0
**Last Updated:** November 1, 2025
**Next Review:** February 1, 2026
