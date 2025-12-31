# System Backup and User Migration Plan
## Comprehensive Backup Before dshannon FreeIPA Account Creation

**Date:** November 13, 2025
**System:** dc1.cyberinabox.net
**Purpose:** Full system backup before migrating local dshannon account to FreeIPA
**Risk Level:** MEDIUM - Account migration can cause authentication issues if not done carefully
**Rollback Strategy:** Full system restore from USB backup

---

## Overview

### Objective
Create a comprehensive backup of the entire system to external FIPS-secured USB drive before:
1. Creating a FreeIPA user account named "dshannon"
2. Migrating home directory and permissions from local account
3. Ensuring no conflicts between local and FreeIPA authentication

### Why This Is Important
- Local system user "dshannon" (UID likely 1000) exists from initial OS installation
- FreeIPA will assign different UID (likely 60xxxx range) to new dshannon user
- Potential for authentication conflicts if not handled properly
- Risk of lockout if migration goes wrong
- Need rollback capability for safety

---

## Pre-Backup Assessment

### Current System State

**Local User Account:**
```bash
# Check current dshannon user
id dshannon
# Expected: uid=1000(dshannon) gid=1000(dshannon) groups=1000(dshannon),10(wheel)

# Check home directory
ls -la /home/dshannon/

# Check sudo access
sudo -l -U dshannon
```

**FreeIPA State:**
```bash
# Verify FreeIPA services running
sudo ipactl status

# Check existing users
sudo ldapsearch -Y EXTERNAL -H ldapi://%2Frun%2Fslapd-CYBERINABOX-NET.socket \
    -b "cn=users,cn=accounts,dc=cyberinabox,dc=net" "(uid=*)" uid | grep "^uid:"
```

**Critical Services:**
- FreeIPA (Directory Server, KDC, Apache, CA)
- Wazuh Agent
- Apache (Web services)
- Postfix/Dovecot (Email)
- Chronyd (NTP)
- RAID array (/dev/md0)

---

## Backup Scope

### What Will Be Backed Up

1. **FreeIPA Complete Backup**
   - LDAP database
   - Kerberos database
   - CA certificates and keys
   - Configuration files

2. **System Configuration**
   - /etc/ (all configuration files)
   - /var/lib/ (application data)
   - /var/log/ (audit logs)
   - /root/ (root user files)

3. **User Data**
   - /home/dshannon/ (all user files)
   - SSH keys
   - Application configurations

4. **Critical System Files**
   - /boot/ (kernel, initramfs)
   - /boot/efi/ (EFI boot files)
   - Package list for reinstallation
   - RAID configuration

5. **Web Services**
   - /var/www/ (all websites and dashboards)
   - Apache configurations

### What Will NOT Be Backed Up
- Operating system files (can be reinstalled)
- /tmp/ and /var/tmp/ (temporary files)
- RAID array data (too large, backed up separately)
- Swap partitions

---

## Backup Procedure

### Step 1: Prepare USB Drive

**FIPS-Secured USB Drive Requirements:**
- Minimum 128GB capacity recommended
- Hardware encrypted USB drive
- Supports FIPS 140-2 validated encryption

**Connect and Identify Drive:**
```bash
# Plug in USB drive and wait 10 seconds

# Identify the device
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,LABEL
sudo fdisk -l | grep -A 5 "Disk /dev/sd"

# Should appear as /dev/sde or similar (after sda-sdd which are system drives)
```

**Unlock FIPS USB Drive:**
```bash
# Follow manufacturer's unlock procedure
# Usually involves entering PIN or using manufacturer's software
# Drive should then appear as unlocked block device

# Verify drive is unlocked and visible
lsblk | grep sd[e-z]
```

### Step 2: Format and Mount USB Drive (If Needed)

**Check if already formatted:**
```bash
sudo blkid /dev/sde1  # Replace sde with actual device
```

**If needs formatting:**
```bash
# Create partition (if needed)
sudo parted /dev/sde mklabel gpt
sudo parted /dev/sde mkpart primary ext4 0% 100%

# Format with ext4
sudo mkfs.ext4 -L "SYSTEM_BACKUP_$(date +%Y%m%d)" /dev/sde1

# Create mount point
sudo mkdir -p /mnt/backup

# Mount drive
sudo mount /dev/sde1 /mnt/backup

# Verify mount
df -h /mnt/backup
```

### Step 3: FreeIPA Full Backup

**Create FreeIPA backup:**
```bash
# Stop FreeIPA services temporarily
sudo ipactl stop

# Create full backup
sudo ipa-backup --data --logs --online

# Backup will be created in:
# /var/lib/ipa/backup/ipa-full-YYYY-MM-DD-HH-MM-SS

# Start FreeIPA services
sudo ipactl start

# Verify services restarted
sudo ipactl status

# Copy backup to USB
BACKUP_DIR=$(ls -td /var/lib/ipa/backup/ipa-full-* | head -1)
sudo cp -av "$BACKUP_DIR" /mnt/backup/
```

**Backup CA certificates:**
```bash
# Export CA certificate
sudo cp /root/cacert.p12 /mnt/backup/ 2>/dev/null || echo "CA cert not in /root"
sudo cp /etc/ipa/ca.crt /mnt/backup/

# Backup FreeIPA configuration
sudo tar -czf /mnt/backup/ipa-config-$(date +%Y%m%d).tar.gz \
    /etc/ipa/ \
    /etc/dirsrv/ \
    /etc/krb5.conf \
    /etc/sssd/ \
    /etc/httpd/conf.d/ipa*.conf
```

### Step 4: System Configuration Backup

```bash
# Backup entire /etc directory
sudo tar --exclude='/etc/selinux/targeted' \
    -czf /mnt/backup/etc-backup-$(date +%Y%m%d).tar.gz \
    /etc/

# Backup critical system files
sudo tar -czf /mnt/backup/system-critical-$(date +%Y%m%d).tar.gz \
    /root/ \
    /var/lib/wazuh-agent/ \
    /var/ossec/ \
    /var/log/audit/ \
    /var/log/secure* \
    /var/log/messages* \
    /var/log/httpd/

# Backup web services
sudo tar -czf /mnt/backup/web-services-$(date +%Y%m%d).tar.gz \
    /var/www/
```

### Step 5: User Home Directory Backup

```bash
# Backup dshannon home directory
sudo tar -czf /mnt/backup/home-dshannon-$(date +%Y%m%d).tar.gz \
    /home/dshannon/

# Verify backup created
ls -lh /mnt/backup/home-dshannon-*.tar.gz
```

### Step 6: Package List and System Info

```bash
# Create package list for recovery
rpm -qa | sort > /mnt/backup/installed-packages-$(date +%Y%m%d).txt

# Save system information
cat > /mnt/backup/system-info-$(date +%Y%m%d).txt << 'EOF'
SYSTEM BACKUP INFORMATION
=========================
Hostname: $(hostname)
Date: $(date)
OS Version: $(cat /etc/rocky-release)
Kernel: $(uname -r)
FIPS Mode: $(cat /proc/sys/crypto/fips_enabled)

FreeIPA Version:
$(rpm -q ipa-server)

Current Users:
$(id dshannon)

FreeIPA Users:
$(sudo ldapsearch -Y EXTERNAL -H ldapi://%2Frun%2Fslapd-CYBERINABOX-NET.socket -b "cn=users,cn=accounts,dc=cyberinabox,dc=net" "(uid=*)" uid 2>/dev/null | grep "^uid:")

RAID Status:
$(cat /proc/mdstat)

Disk Usage:
$(df -h)

LVM Volumes:
$(sudo lvs)
EOF

# Save partition table
sudo sfdisk -d /dev/sda > /mnt/backup/sda-partition-table.txt
```

### Step 7: Boot Configuration Backup

```bash
# Backup /boot and /boot/efi
sudo tar -czf /mnt/backup/boot-backup-$(date +%Y%m%d).tar.gz \
    /boot/ \
    --exclude='/boot/lost+found'

# Save GRUB configuration
sudo cp /boot/efi/EFI/rocky/grub.cfg /mnt/backup/grub.cfg.backup
```

### Step 8: RAID and LVM Configuration

```bash
# Backup RAID configuration
sudo cp /etc/mdadm.conf /mnt/backup/

# Save LUKS header backup (CRITICAL!)
sudo cryptsetup luksHeaderBackup /dev/md0 \
    --header-backup-file /mnt/backup/luks-samba-header-backup-$(date +%Y%m%d).img

# Save LVM configuration
sudo vgcfgbackup -f /mnt/backup/vg-backup-$(date +%Y%m%d) rl

# Document LVM structure
sudo lvs -o +devices > /mnt/backup/lvm-structure.txt
```

### Step 9: Create Backup Manifest

```bash
# Create checksum file
cd /mnt/backup
sudo sha256sum *.tar.gz *.txt *.img *.p12 *.crt 2>/dev/null \
    > /mnt/backup/CHECKSUMS-$(date +%Y%m%d).txt

# Create backup inventory
cat > /mnt/backup/BACKUP_MANIFEST.txt << 'EOF'
SYSTEM BACKUP MANIFEST
======================
Backup Date: $(date)
System: dc1.cyberinabox.net
Operator: dshannon

BACKUP CONTENTS:
1. FreeIPA full backup (ipa-full-*)
2. System configuration (/etc)
3. User home directory (/home/dshannon)
4. Web services (/var/www)
5. Critical logs and audit files
6. Boot configuration
7. RAID/LVM configuration
8. LUKS header backup
9. Package list
10. System information

RESTORE PRIORITY:
Priority 1: FreeIPA backup (required for authentication)
Priority 2: User home directory
Priority 3: System configuration
Priority 4: Web services
Priority 5: Logs (for reference)

BACKUP VERIFICATION:
- All checksums validated: $(test -f CHECKSUMS-*.txt && echo "YES" || echo "NO")
- FreeIPA backup present: $(test -d ipa-full-* && echo "YES" || echo "NO")
- LUKS header backup: $(test -f luks-samba-header-backup-*.img && echo "YES" || echo "NO")

EMERGENCY RESTORE PROCEDURE:
1. Boot from Rocky Linux installation media
2. Restore partition table: sfdisk /dev/sda < sda-partition-table.txt
3. Restore LUKS header: cryptsetup luksHeaderRestore /dev/md0 --header-backup-file luks-samba-header-backup-*.img
4. Restore LVM: vgcfgrestore -f vg-backup-* rl
5. Mount filesystems
6. Extract system config: tar -xzf etc-backup-*.tar.gz -C /mnt/sysroot
7. Restore FreeIPA: ipa-restore /path/to/ipa-full-*
8. Restore home directory: tar -xzf home-dshannon-*.tar.gz -C /mnt/sysroot
EOF

# List all backup files
ls -lh /mnt/backup/ > /mnt/backup/FILE_LIST.txt
```

### Step 10: Verify Backup

```bash
# Check all critical files present
echo "=== BACKUP VERIFICATION ==="
echo "FreeIPA backup:"
ls -lh /mnt/backup/ipa-full-* 2>/dev/null || echo "MISSING!"

echo "System config backup:"
ls -lh /mnt/backup/etc-backup-*.tar.gz

echo "Home directory backup:"
ls -lh /mnt/backup/home-dshannon-*.tar.gz

echo "LUKS header backup:"
ls -lh /mnt/backup/luks-samba-header-backup-*.img

echo "Web services backup:"
ls -lh /mnt/backup/web-services-*.tar.gz

echo "Total backup size:"
du -sh /mnt/backup/

# Verify checksums
cd /mnt/backup
sha256sum -c CHECKSUMS-*.txt
```

### Step 11: Finalize and Unmount

```bash
# Sync all data to disk
sudo sync

# Unmount USB drive
sudo umount /mnt/backup

# Physically remove USB drive and label it:
# "SYSTEM BACKUP - $(date +%Y-%m-%d) - BEFORE DSHANNON MIGRATION"
```

---

## Post-Backup: User Migration Plan

### Phase 1: Create FreeIPA User

```bash
# Get Kerberos ticket as admin
kinit admin

# Create dshannon user in FreeIPA
ipa user-add dshannon \
    --first="Donald" \
    --last="Shannon" \
    --email="Don@Contract-coach.com" \
    --shell=/bin/bash \
    --homedir=/home/dshannon

# Set initial password
ipa passwd dshannon

# Add to admins group
ipa group-add-member admins --users=dshannon

# Verify user created
ipa user-show dshannon
```

### Phase 2: Handle UID/GID Conflicts

**Check UIDs:**
```bash
# Local dshannon UID
id dshannon
# Likely: uid=1000

# FreeIPA dshannon UID
getent passwd dshannon
# Likely: uid=60xxxx (FreeIPA default range)
```

**Options:**
1. **Keep separate** - Rename local user to "dshannon-local"
2. **Override UID** - Force FreeIPA to use UID 1000 (NOT recommended)
3. **Migrate ownership** - Change all files from old UID to new UID

**Recommended: Option 3 (Migrate ownership)**
```bash
# Find current UID
OLD_UID=$(id -u dshannon)
echo "Old UID: $OLD_UID"

# Get new FreeIPA UID
NEW_UID=$(getent passwd dshannon | cut -d: -f3)
echo "New UID: $NEW_UID"

# Find all files owned by old UID
sudo find / -uid $OLD_UID -ls > /tmp/old-uid-files.txt

# Change ownership (DO THIS CAREFULLY!)
# First test with echo
find /home/dshannon -uid $OLD_UID -exec echo sudo chown $NEW_UID:$NEW_UID {} \;

# If looks good, execute
find /home/dshannon -uid $OLD_UID -exec sudo chown $NEW_UID:$NEW_UID {} \;
```

### Phase 3: Test Authentication

```bash
# Test SSH login
ssh dshannon@localhost

# Test sudo
sudo -l

# Verify home directory
ls -la ~/

# Check file ownership
ls -ln /home/dshannon/ | head
```

### Phase 4: Handle Local User

**Option A: Disable local user**
```bash
sudo usermod -L dshannon-local  # Lock account
sudo usermod -s /sbin/nologin dshannon-local  # Disable shell
```

**Option B: Remove local user** (AFTER TESTING!)
```bash
# Only after confirming FreeIPA user works!
sudo userdel dshannon-local  # Does NOT delete home directory
```

---

## Rollback Procedure (If Something Goes Wrong)

### Emergency Restore

If authentication breaks or system becomes unusable:

1. **Boot into rescue mode**
   - Reboot system
   - At GRUB, add `init=/bin/bash` to kernel line

2. **Mount filesystems**
   ```bash
   mount -o remount,rw /
   mount /boot
   mount /boot/efi
   ```

3. **Restore from USB**
   ```bash
   # Connect USB drive
   mkdir /mnt/backup
   mount /dev/sde1 /mnt/backup

   # Restore critical configs
   cd /
   tar -xzf /mnt/backup/etc-backup-*.tar.gz

   # Restore home directory
   tar -xzf /mnt/backup/home-dshannon-*.tar.gz

   # Restore FreeIPA (if needed)
   ipa-restore /mnt/backup/ipa-full-*
   ```

4. **Reboot**
   ```bash
   sync
   reboot -f
   ```

---

## Success Criteria

Backup is complete when:
- ✅ USB drive has at least 20GB of backup data
- ✅ FreeIPA backup directory exists (ipa-full-*)
- ✅ All checksums validate
- ✅ LUKS header backup file exists
- ✅ Home directory backup exists
- ✅ System config backup exists
- ✅ BACKUP_MANIFEST.txt is complete
- ✅ USB drive safely ejected and labeled

Migration is complete when:
- ✅ dshannon FreeIPA user exists
- ✅ Can login with FreeIPA credentials
- ✅ sudo access works
- ✅ All files accessible
- ✅ No authentication errors in logs
- ✅ Local user conflict resolved

---

## Timeline

**Estimated Duration:**
- Backup: 30-60 minutes (depending on USB speed)
- User creation: 5 minutes
- Testing: 15 minutes
- Migration: 30 minutes
- Verification: 15 minutes

**Total: 2-3 hours** (including safety checks)

---

**Created:** November 13, 2025
**Status:** Ready for execution
**Next Step:** Connect FIPS-secured USB drive and verify detection
