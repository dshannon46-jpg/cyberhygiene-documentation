# Kingston IronKey D500S Off-Site Backup Procedure

**Date:** 2025-11-04
**System:** dc1.cyberinabox.net
**Device:** Kingston IronKey D500S FIPS 140-3 Level 3 Certified USB Drive
**Purpose:** Secure off-site storage of system backups
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)

---

## 1. Executive Summary

This document provides step-by-step procedures for securely transferring system backups to a Kingston IronKey D500S hardware-encrypted USB drive for off-site storage. The IronKey D500S provides military-grade security with FIPS 140-3 Level 3 validation, hardware XTS-AES 256-bit encryption, and physical tamper resistance.

**Backup Contents:**
- **Bootable Rescue ISO:** 889 MB (rear-dc1.iso)
- **Full System Data Archive:** 6.9 GB (backup.tar.gz)
- **Total Backup Size:** 7.8 GB

**Security Features:**
- FIPS 140-3 Level 3 certified
- Hardware-based XTS-AES 256-bit encryption
- BadUSB protection
- Brute-force attack protection (10 failed attempts = data wipe)
- IP67 water/dust resistance
- Tamper-evident epoxy-sealed construction

---

## 2. Kingston IronKey D500S Specifications

### Hardware Encryption
- **Encryption:** XTS-AES 256-bit (hardware-based, no software required)
- **FIPS Certification:** FIPS 140-3 Level 3 validated
- **Processor:** Dedicated cryptographic processor on-device
- **Authentication:** Multi-PIN option with Complex Password Mode

### Physical Security
- **Housing:** Zinc-coated, epoxy-sealed steel casing
- **Water/Dust Rating:** IP67 certified
- **Tamper Resistance:** Physical intrusion protection
- **Dimensions:** 77.9mm x 18.6mm x 9.3mm

### Capacities Available
- 8GB, 16GB, 32GB, 64GB, 128GB, 256GB, 512GB
- **Recommended for this backup:** 16GB minimum (current backup: 7.8GB)

### Data Protection
- **Brute Force Protection:** 10 consecutive failed PIN attempts = cryptographic key deletion (data wipe)
- **BadUSB Protection:** Digitally signed firmware prevents malicious reprogramming
- **Dual-Partition Support:** Admin and User partitions with Hidden File Store capability

---

## 3. Initial Setup Requirements

### CRITICAL: Windows/macOS Required for Initialization

The Kingston IronKey D500S **MUST** be initialized on Windows or macOS before it can be used on Linux systems.

**Steps (Perform on Windows/macOS first):**

1. **Download IronKey Software**
   - Visit: https://www.kingston.com/support
   - Download IronKey D500S Management Software for Windows/macOS

2. **Insert IronKey D500S**
   - Connect device to Windows/macOS computer
   - Device will be detected as removable storage

3. **Run Initial Setup**
   - Launch IronKey initialization software
   - Set **Administrator PIN** (8-16 characters, complex mode recommended)
     - Must contain: uppercase, lowercase, numbers, special characters
     - Example format: `Abc123!@#XYZ789`
   - Set **User PIN** (optional, can be same as admin)
   - Choose partition configuration:
     - **Option A:** Single partition (recommended for backups)
     - **Option B:** Dual partition (Admin + User)

4. **Record PINs Securely**
   - Store in password manager or encrypted vault
   - **WARNING:** 10 failed attempts = permanent data loss
   - No recovery mechanism exists if PIN is forgotten

5. **Verify Initialization**
   - Eject and reinsert device
   - Enter PIN to unlock
   - Confirm device mounts successfully

---

## 4. Linux (Rocky 9) Usage After Initialization

Once initialized on Windows/macOS, the IronKey D500S can be used on Rocky Linux 9.

### 4.1 Detect IronKey D500S

```bash
# Insert IronKey and check detection
lsusb | grep -i kingston

# Check kernel messages
sudo dmesg | tail -20

# Expected output:
# usb 2-1: New USB device found, idVendor=0951, idProduct=16df
# usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
# usb 2-1: Product: IronKey D500S
```

### 4.2 Identify Device Path

```bash
# List block devices
lsblk -f

# Expected output (example):
# sde
# └─sde1   vfat   FAT32   IRONKEY_D500S   XXXX-XXXX

# Check device by ID
ls -l /dev/disk/by-id/ | grep -i kingston
```

### 4.3 Mount IronKey D500S

The device may auto-mount in GNOME/KDE desktop environments. If not:

```bash
# Create mount point
sudo mkdir -p /mnt/ironkey

# Unlock device (may require PIN entry via IronKey software)
# Some models require running: sudo ironkey unlock /dev/sdX

# Mount device
sudo mount /dev/sde1 /mnt/ironkey

# Verify mount
df -h | grep ironkey
# /dev/sde1        15G  0  15G   0% /mnt/ironkey
```

**Alternative (User-space mount):**
```bash
# Use udisksctl for automatic handling
udisksctl mount -b /dev/sde1
```

---

## 5. Secure Backup Transfer Procedure

### 5.1 Pre-Transfer Checklist

- [ ] IronKey D500S initialized with strong PIN
- [ ] Device detected in `lsblk` output
- [ ] Sufficient free space (minimum 8GB for current backup)
- [ ] Backup checksums verified (SHA256SUMS file)
- [ ] Working in secure physical environment

### 5.2 Transfer Backups to IronKey

```bash
# Navigate to backup directory
cd /srv/samba/backups/dc1/

# Verify backup integrity BEFORE transfer
sha256sum -c SHA256SUMS
# Expected output:
# rear-dc1.iso: OK
# backup.tar.gz: OK

# Mount IronKey (if not already mounted)
sudo mkdir -p /mnt/ironkey
sudo mount /dev/sde1 /mnt/ironkey

# Create backup directory on IronKey
sudo mkdir -p /mnt/ironkey/dc1_backups_2025-11-04

# Copy files with verification
sudo rsync -avh --progress --checksum \
  /srv/samba/backups/dc1/rear-dc1.iso \
  /srv/samba/backups/dc1/backup.tar.gz \
  /srv/samba/backups/dc1/backup.tar.gz.md5 \
  /srv/samba/backups/dc1/SHA256SUMS \
  /srv/samba/backups/dc1/README \
  /srv/samba/backups/dc1/VERSION \
  /mnt/ironkey/dc1_backups_2025-11-04/

# Alternative: Simple copy (if rsync not available)
sudo cp -v /srv/samba/backups/dc1/{rear-dc1.iso,backup.tar.gz,*.md5,SHA256SUMS,README,VERSION} \
  /mnt/ironkey/dc1_backups_2025-11-04/
```

### 5.3 Verify Transfer Integrity

```bash
# Navigate to IronKey backup directory
cd /mnt/ironkey/dc1_backups_2025-11-04/

# Verify checksums on IronKey
sha256sum -c SHA256SUMS
# Expected output:
# rear-dc1.iso: OK
# backup.tar.gz: OK

# Compare file sizes
ls -lh
# -rw-r--r--. 1 root root 889M Nov  4 15:13 rear-dc1.iso
# -rw-r--r--. 1 root root 6.9G Nov  4 15:23 backup.tar.gz

# Test ISO bootability (optional - read-only check)
sudo isoinfo -d -i /mnt/ironkey/dc1_backups_2025-11-04/rear-dc1.iso
```

### 5.4 Create Transfer Manifest

```bash
# Create manifest on IronKey
cat > /mnt/ironkey/dc1_backups_2025-11-04/TRANSFER_MANIFEST.txt << 'EOF'
BACKUP TRANSFER MANIFEST
========================
Date: 2025-11-04
Source System: dc1.cyberinabox.net
Transfer Method: rsync with checksum verification
Storage Device: Kingston IronKey D500S FIPS 140-3 Level 3

FILES TRANSFERRED:
==================
rear-dc1.iso         889M   Bootable rescue/recovery ISO
backup.tar.gz        6.9G   Full system data archive
backup.tar.gz.md5     48B   MD5 checksum
SHA256SUMS           165B   SHA256 checksums for verification
README               202B   ReaR backup information
VERSION              283B   ReaR version information

VERIFICATION:
=============
All checksums verified: YES
Transfer completed: $(date)
Transferred by: root@dc1.cyberinabox.net

RESTORE INSTRUCTIONS:
=====================
1. Boot from rear-dc1.iso
2. Follow ReaR recovery prompts
3. When prompted, restore from backup.tar.gz
4. Verify system functionality post-restore

SECURITY NOTES:
===============
- IronKey encrypted with FIPS 140-3 Level 3 hardware encryption
- XTS-AES 256-bit encryption active
- PIN required to unlock device
- 10 failed PIN attempts = permanent data wipe
- Store in secure off-site location
- Verify PIN before storing to prevent lockout

COMPLIANCE:
===========
- NIST 800-171 CP-9: System Backup
- NIST 800-171 CP-10: System Recovery and Reconstitution
- NIST 800-171 MP-4: Media Storage (off-site)
- NIST 800-171 SC-28: Protection of Information at Rest

EOF

# Set read-only to prevent accidental modification
sudo chmod 444 /mnt/ironkey/dc1_backups_2025-11-04/TRANSFER_MANIFEST.txt
```

### 5.5 Sync and Safely Unmount

```bash
# Ensure all data is written to device
sudo sync

# Flush filesystem buffers
sudo sync ; sudo sync ; sudo sync

# Unmount IronKey
sudo umount /mnt/ironkey

# OR use udisksctl
udisksctl unmount -b /dev/sde1

# Verify unmount
mount | grep sde
# (should return nothing)

# Safe to remove device
echo "IronKey D500S can now be safely removed"
```

---

## 6. Off-Site Storage Procedures

### 6.1 Physical Security Requirements

**Storage Location Options:**
1. **Bank Safe Deposit Box** (recommended)
   - Climate-controlled
   - Fire and water protection
   - Access logging
   - Geographic separation from primary site

2. **Secondary Facility**
   - Locked security cabinet
   - Climate-controlled environment
   - Access control and monitoring
   - Minimum 100 miles from primary data center

3. **Trusted Third-Party Storage**
   - NIST 800-171 compliant facility
   - Physical access controls
   - Environmental monitoring

### 6.2 Storage Best Practices

- **Temperature:** Store at 0°C to 60°C (32°F to 140°F)
- **Humidity:** 5% to 90% non-condensing
- **Container:** Anti-static bag + protective case
- **Labeling:** Mark as "ENCRYPTED BACKUP - CUI"
- **Inventory:** Log storage location and retrieval dates
- **Testing:** Verify backups quarterly (retrieve, test, return)

### 6.3 Chain of Custody

```bash
# Create custody log
cat > /home/dshannon/Documents/IronKey_Custody_Log.txt << 'EOF'
IRONKEY D500S CUSTODY LOG
==========================

Device: Kingston IronKey D500S
Serial Number: [Record from device label]
Capacity: [Record capacity]

CUSTODY EVENTS:
===============
Date         | Time  | Action      | Location         | Custodian
-------------|-------|-------------|------------------|------------------
2025-11-04   | 15:30 | Created     | dc1.cyberinabox  | dshannon
2025-11-04   | 16:00 | Transferred | [Off-site]       | dshannon
[Future]     |       | Retrieved   | [Off-site]       | [Name]
[Future]     |       | Returned    | [Off-site]       | [Name]

NOTES:
======
- PIN stored separately in password manager
- Device contains full system backup dated 2025-11-04
- Backup includes FreeIPA, Wazuh, and all system configurations
- Next scheduled verification: [Date + 90 days]

EOF
```

---

## 7. Restore Procedures

### 7.1 Emergency Restoration from IronKey

**Scenario:** Primary system failure requiring bare-metal recovery

1. **Boot from IronKey ISO**
   ```bash
   # Connect IronKey to failed system
   # Enter BIOS/UEFI (F2/F12/DEL - varies by manufacturer)
   # Set boot order: USB first
   # Save and reboot
   # Boot from "rear-dc1.iso" on IronKey
   ```

2. **ReaR Automatic Recovery**
   ```bash
   # ReaR will boot into recovery environment
   # At prompt, select "Automatic Recover"
   # ReaR will:
   #   - Detect hardware
   #   - Recreate disk layout (partitions, LVM, LUKS)
   #   - Format filesystems
   #   - Prompt for LUKS encryption passwords
   ```

3. **Enter LUKS Passwords**
   ```
   # You will be prompted for encryption passwords for:
   # - rl_ds1-home
   # - rl_ds1-var
   # - rl_ds1-var_log
   # - rl_ds1-var_log_audit
   # - rl_ds1-data
   # - rl_ds1-backup
   # - rl_ds1-tmp
   # - rl_ds1-svr_tmp
   # - samba_data (RAID array)
   ```

4. **Restore System Data**
   ```bash
   # ReaR will automatically detect backup.tar.gz on IronKey
   # Confirm restore location: /mnt/ironkey/dc1_backups_2025-11-04/backup.tar.gz
   # ReaR will extract all system data
   # This process takes approximately 15-30 minutes
   ```

5. **Post-Restore Verification**
   ```bash
   # After restoration completes, reboot
   # Remove IronKey
   # Boot from restored system disk

   # Verify critical services
   sudo systemctl status wazuh-manager
   sudo systemctl status ipa
   sudo systemctl status httpd

   # Verify FreeIPA
   kinit admin
   ipa user-list

   # Verify Wazuh
   sudo /var/ossec/bin/wazuh-control status

   # Verify network connectivity
   ping -c 4 8.8.8.8
   ```

### 7.2 Selective File Restore (Non-Emergency)

If you only need to restore specific files:

```bash
# Mount IronKey
sudo mount /dev/sde1 /mnt/ironkey

# Extract specific files from backup
cd /tmp
sudo tar -xzf /mnt/ironkey/dc1_backups_2025-11-04/backup.tar.gz \
  --wildcards 'var/ossec/etc/*' \
  --wildcards 'etc/ipa/*'

# Copy restored files to desired location
sudo cp -a /tmp/var/ossec/etc/ossec.conf /var/ossec/etc/
sudo chown root:wazuh /var/ossec/etc/ossec.conf
sudo chmod 640 /var/ossec/etc/ossec.conf

# Unmount IronKey
sudo umount /mnt/ironkey
```

---

## 8. Troubleshooting

### 8.1 IronKey Not Detected

**Symptom:** Device not appearing in `lsblk` or `lsusb`

**Solutions:**
```bash
# 1. Check USB connection
lsusb
# If not listed, try different USB port

# 2. Check kernel messages
sudo dmesg | tail -30
# Look for USB errors or device detection messages

# 3. Verify USB subsystem
ls -l /sys/bus/usb/devices/

# 4. Force USB rescan
echo '1-0:1.0' | sudo tee /sys/bus/usb/drivers/usb/unbind
echo '1-0:1.0' | sudo tee /sys/bus/usb/drivers/usb/bind
```

### 8.2 Device Detected But Not Mountable

**Symptom:** `lsusb` shows device, but `lsblk` does not show partitions

**Cause:** Device may require PIN unlock first

**Solutions:**
```bash
# 1. Check if device requires PIN unlock
# Some IronKey models have Linux unlock utility
# Check for /mnt/usb-Kingston_Ironkey_D500S_[serial]-0:0/

# 2. Try mounting read-only first
sudo mount -o ro /dev/sde1 /mnt/ironkey

# 3. Check filesystem type
sudo blkid /dev/sde1
# Output: /dev/sde1: TYPE="vfat" UUID="XXXX-XXXX" LABEL="IRONKEY_D500S"

# 4. Mount with explicit filesystem type
sudo mount -t vfat /dev/sde1 /mnt/ironkey
```

### 8.3 PIN Forgotten or Unknown

**CRITICAL WARNING:** There is NO recovery mechanism for forgotten PINs.

**Options:**
1. **If within 10 attempts:** Try all known passwords methodically
2. **If exceeded 10 attempts:** Device is permanently wiped - data lost
3. **Prevention:** Store PIN in multiple secure locations:
   - Password manager (KeePassXC, 1Password, etc.)
   - Encrypted text file on separate encrypted drive
   - Secure physical document in safe

### 8.4 Checksum Verification Failures

**Symptom:** `sha256sum -c SHA256SUMS` reports mismatches

**Cause:** Data corruption during transfer or storage

**Solutions:**
```bash
# 1. Re-copy affected files
sudo rsync -avh --checksum /srv/samba/backups/dc1/rear-dc1.iso /mnt/ironkey/dc1_backups_2025-11-04/

# 2. Verify source files are intact
cd /srv/samba/backups/dc1/
sha256sum -c SHA256SUMS

# 3. Test IronKey for errors
sudo badblocks -sv /dev/sde1

# 4. If repeated failures: IronKey may be defective - use replacement
```

### 8.5 Insufficient Space on IronKey

**Symptom:** `No space left on device` during copy

**Solutions:**
```bash
# 1. Check available space
df -h /mnt/ironkey

# 2. Remove old backups if present
sudo ls -lh /mnt/ironkey/
sudo rm -rf /mnt/ironkey/old_backups_*

# 3. Consider compression (already gzipped, minimal gain)
# 4. Use larger capacity IronKey (32GB or 64GB recommended)
```

---

## 9. Security Considerations

### 9.1 PIN Security

- **Strength:** Use maximum length (16 characters) with complexity
- **Uniqueness:** Do NOT reuse existing passwords
- **Storage:** Store in encrypted password manager
- **Sharing:** NEVER share PIN via email, chat, or phone
- **Testing:** Verify PIN works BEFORE storing off-site

### 9.2 Physical Security

- **Tamper Evidence:** Inspect device for physical damage before use
- **Serial Number:** Record device serial number for inventory
- **Access Logging:** Maintain custody log for compliance
- **Environmental Protection:** Use anti-static bag + protective case

### 9.3 Data Lifecycle

- **Backup Rotation:** Update IronKey backups monthly
- **Verification Testing:** Test restore quarterly
- **Retirement:** When replacing device, crypto-shred old IronKey:
  ```bash
  # Before disposal
  sudo shred -vfz -n 3 /dev/sde
  # Then physically destroy device
  ```

### 9.4 Compliance Mappings

**NIST 800-171 Controls Satisfied:**

- **CP-9 (System Backup):**
  - CP-9.a: Conduct backups of system-level information
  - CP-9.b: Conduct backups of user-level information
  - CP-9.c: Conduct backups of system documentation
  - CP-9.d: Protect confidentiality, integrity, and availability of backup information

- **CP-10 (System Recovery and Reconstitution):**
  - CP-10.a: Provide for recovery and reconstitution of system to known state

- **MP-4 (Media Storage):**
  - MP-4.a: Physically control and securely store media
  - MP-4.b: Protect media until destroyed or sanitized

- **MP-5 (Media Transport):**
  - MP-5.a: Protect and control media during transport
  - MP-5.b: Maintain accountability for media during transport

- **SC-28 (Protection of Information at Rest):**
  - SC-28.a: Protect confidentiality and integrity of information at rest
  - SC-28.1: Cryptographic protection (FIPS 140-3 Level 3)

---

## 10. Backup File Inventory

### Current Backup (2025-11-04)

**Location:** `/srv/samba/backups/dc1/`

| File | Size | Description | SHA256 Checksum |
|------|------|-------------|-----------------|
| rear-dc1.iso | 889M | Bootable rescue ISO (UEFI) | 82ef3a193d6c5052002323cf2ae7db2ba98ff3c02cee700d80f8b82c22cd735c |
| backup.tar.gz | 6.9G | Full system data archive | 703e4eaf4b0abb3a2d2cfadcd74d25320227f1d74278f1980ad4faf93c78b8d3 |
| backup.tar.gz.md5 | 48B | MD5 checksum | (internal verification) |
| backup.log | 20M | ReaR backup operation log | (informational) |
| README | 202B | ReaR backup information | (metadata) |
| VERSION | 283B | ReaR version info | (metadata) |
| SHA256SUMS | 165B | Master checksum file | (verification) |

**Total Size:** 7.8 GB
**Excluded from backup:** `/srv/samba` (per ReaR configuration)

### What's Included in Backup

**System Partitions:**
- `/` (root) - 90GB volume, 9.5GB used
- `/boot` - 8GB volume, 500MB used
- `/boot/efi` - 1GB volume, 10MB used
- `/home` - 239GB volume, 2.2GB used
- `/var` - 30GB volume, 9.9GB used
- `/var/log` - 15GB volume, 300MB used
- `/var/log/audit` - 15GB volume, 100MB used
- `/tmp` - 15GB volume, 600MB used
- `/data` - 350GB volume, 3GB used
- `/backup` - 950GB volume, 12GB used

**Critical Configurations:**
- FreeIPA: `/etc/ipa/`, `/var/lib/ipa/`, `/var/log/ipa*/`
- Wazuh: `/var/ossec/etc/`, `/var/ossec/logs/`, `/var/ossec/rules/`
- Web Servers: `/etc/httpd/`, `/etc/nginx/`, `/var/log/httpd/`
- System: `/etc/sysconfig/`, `/etc/systemd/`, `/etc/ssh/`, `/etc/pki/`
- Network: `/etc/hosts`, `/etc/resolv.conf`, `/etc/firewalld/`
- Encryption: `/etc/crypttab` (LUKS device mappings)

**Credentials Backed Up:**
- FreeIPA admin credentials
- LUKS encryption key mappings (not keys themselves - stored in TPM/manual entry)
- SSL/TLS certificates
- SSH host keys
- Wazuh manager keys

---

## 11. Recommended IronKey Model

For this backup (7.8GB total), minimum requirements:

**Minimum Capacity:** 16GB IronKey D500S
**Recommended Capacity:** 32GB or 64GB (allows for backup growth)

**Model Numbers:**
- `IKD500S/16GB` - 16GB ($89-$119 MSRP)
- `IKD500S/32GB` - 32GB ($139-$169 MSRP)
- `IKD500S/64GB` - 64GB ($229-$279 MSRP)

**Purchase Considerations:**
- Buy from authorized Kingston reseller
- Verify TAA compliance if required for government use
- Confirm FIPS 140-3 Level 3 certification on packaging
- Test device thoroughly before deploying for production backups

---

## 12. Automation (Optional)

### 12.1 Automated Backup Transfer Script

```bash
#!/bin/bash
# File: /usr/local/bin/ironkey-backup.sh
# Purpose: Automated IronKey backup transfer with verification
# Author: System Administrator
# Date: 2025-11-04

set -e  # Exit on error

# Configuration
SOURCE_DIR="/srv/samba/backups/dc1"
IRONKEY_MOUNT="/mnt/ironkey"
IRONKEY_DEVICE="/dev/sde1"
BACKUP_DATE=$(date +%Y-%m-%d)
DEST_DIR="${IRONKEY_MOUNT}/dc1_backups_${BACKUP_DATE}"
LOG_FILE="/var/log/ironkey-backup.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Error handler
error_exit() {
    log "ERROR: $1"
    exit 1
}

# Start backup
log "=== IronKey Backup Transfer Started ==="

# Check if IronKey is connected
if ! lsblk | grep -q "$IRONKEY_DEVICE"; then
    error_exit "IronKey device not detected: $IRONKEY_DEVICE"
fi

# Mount IronKey
log "Mounting IronKey..."
mkdir -p "$IRONKEY_MOUNT"
mount "$IRONKEY_DEVICE" "$IRONKEY_MOUNT" || error_exit "Failed to mount IronKey"

# Check available space
AVAIL_SPACE=$(df -BG "$IRONKEY_MOUNT" | awk 'NR==2 {print $4}' | sed 's/G//')
REQUIRED_SPACE=8
if [ "$AVAIL_SPACE" -lt "$REQUIRED_SPACE" ]; then
    error_exit "Insufficient space on IronKey: ${AVAIL_SPACE}G available, ${REQUIRED_SPACE}G required"
fi

# Create destination directory
log "Creating backup directory: $DEST_DIR"
mkdir -p "$DEST_DIR"

# Transfer files
log "Transferring backup files..."
rsync -avh --progress --checksum \
    "$SOURCE_DIR/rear-dc1.iso" \
    "$SOURCE_DIR/backup.tar.gz" \
    "$SOURCE_DIR/backup.tar.gz.md5" \
    "$SOURCE_DIR/SHA256SUMS" \
    "$SOURCE_DIR/README" \
    "$SOURCE_DIR/VERSION" \
    "$DEST_DIR/" || error_exit "File transfer failed"

# Verify checksums
log "Verifying checksums..."
cd "$DEST_DIR"
sha256sum -c SHA256SUMS || error_exit "Checksum verification failed"

# Create manifest
log "Creating transfer manifest..."
cat > "$DEST_DIR/TRANSFER_MANIFEST.txt" << EOF
Backup Transfer Manifest
========================
Date: $BACKUP_DATE
Source: dc1.cyberinabox.net
Method: rsync with checksum verification
Device: Kingston IronKey D500S FIPS 140-3 Level 3

Files Transferred:
- rear-dc1.iso
- backup.tar.gz
- backup.tar.gz.md5
- SHA256SUMS
- README
- VERSION

Verification: PASSED
Transfer completed: $(date)
EOF

# Sync and unmount
log "Syncing filesystem..."
sync; sync; sync
sleep 2

log "Unmounting IronKey..."
umount "$IRONKEY_MOUNT" || error_exit "Failed to unmount IronKey"

log "=== IronKey Backup Transfer Completed Successfully ==="
log "Total size: $(du -sh $DEST_DIR 2>/dev/null | awk '{print $1}')"
log "IronKey can now be safely removed and stored off-site"

exit 0
```

**Usage:**
```bash
# Make script executable
sudo chmod +x /usr/local/bin/ironkey-backup.sh

# Run manually
sudo /usr/local/bin/ironkey-backup.sh

# View log
sudo tail -f /var/log/ironkey-backup.log
```

---

## 13. Contacts and Support

**Kingston Support:**
- **Website:** https://www.kingston.com/support
- **Phone (USA):** 1-800-435-0640
- **Email:** https://www.kingston.com/en/support/contact-support

**Internal Contacts:**
- **System Administrator:** dshannon
- **Backup Location:** [Record off-site storage location]
- **Emergency Retrieval Contact:** [Record contact for off-site access]

---

## 14. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-04 | dshannon | Initial document creation |
|  |  |  | |

---

## 15. Appendices

### Appendix A: Quick Reference Card

```
IRONKEY D500S QUICK REFERENCE
==============================

MOUNT:
  sudo mount /dev/sde1 /mnt/ironkey

COPY BACKUPS:
  sudo rsync -avh --checksum /srv/samba/backups/dc1/* /mnt/ironkey/

VERIFY:
  cd /mnt/ironkey
  sha256sum -c SHA256SUMS

UNMOUNT:
  sudo sync; sync; sync
  sudo umount /mnt/ironkey

SECURITY:
  - 10 failed PINs = permanent wipe
  - FIPS 140-3 Level 3 encryption
  - Store PIN separately from device
  - Test quarterly, rotate monthly

EMERGENCY RESTORE:
  1. Boot from rear-dc1.iso
  2. Enter LUKS passwords
  3. Restore from backup.tar.gz
  4. Reboot and verify
```

### Appendix B: LUKS Encryption Passwords

**CRITICAL:** These passwords are required during system restore.

Store separately from IronKey in encrypted password manager.

```
LUKS Volume                  Purpose              Password Location
=======================      ===================  =====================
rl_ds1-home                  /home                KeePassXC: LUKS/home
rl_ds1-var                   /var                 KeePassXC: LUKS/var
rl_ds1-var_log              /var/log             KeePassXC: LUKS/var_log
rl_ds1-var_log_audit        /var/log/audit       KeePassXC: LUKS/var_log_audit
rl_ds1-data                  /data                KeePassXC: LUKS/data
rl_ds1-backup                /backup              KeePassXC: LUKS/backup
rl_ds1-tmp                   /tmp                 KeePassXC: LUKS/tmp
rl_ds1-svr_tmp              /svr/tmp             KeePassXC: LUKS/svr_tmp
samba_data                   /srv/samba           KeePassXC: LUKS/samba_data
```

### Appendix C: Compliance Checklist

**NIST 800-171 CP-9 Compliance:**

- [ ] Backups conducted of system-level information (contained in backup.tar.gz)
- [ ] Backups conducted of user-level information (contained in backup.tar.gz)
- [ ] Backups conducted of system documentation (README, VERSION, manifests)
- [ ] Backup information protected with FIPS 140-3 Level 3 encryption
- [ ] Backups tested quarterly for restoration capability
- [ ] Backup storage location is separate from operational system (off-site)
- [ ] Backups stored securely with access controls (encrypted IronKey with PIN)

**Signature:**

Administrator: __________________ Date: __________

---

**END OF DOCUMENT**
