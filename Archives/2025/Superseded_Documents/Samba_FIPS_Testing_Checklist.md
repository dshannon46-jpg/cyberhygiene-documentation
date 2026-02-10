# SAMBA FIPS COMPATIBILITY TESTING CHECKLIST
**Organization:** The Contract Coach (Donald E. Shannon LLC)
**System:** CyberHygiene Production Network (cyberinabox.net)
**Test Date:** November 3-6, 2025
**Purpose:** Verify Samba file sharing compatibility with FIPS 140-2 mode
**Decision:** Keep Samba or migrate to NextCloud/NFS

---

## TEST OVERVIEW

**Objective:** Determine if Samba 4.21.3 functions properly in FIPS mode for:
1. File sharing across domain-joined workstations
2. Centralized workstation backup storage
3. Kerberos/LDAP authentication integration

**Success Criteria:**
- ✅ Workstations can mount Samba shares using Kerberos credentials
- ✅ File read/write operations work without errors
- ✅ No FIPS-related errors in logs
- ✅ Workstation backups can write to share
- ✅ Performance is acceptable
- ✅ SMB3 encryption functions properly

**Failure Indicators:**
- ❌ Connection failures with FIPS-related errors
- ❌ Authentication failures despite valid Kerberos tickets
- ❌ File operation errors or corruption
- ❌ System logs show FIPS violations

---

## PRE-TEST VERIFICATION

### 1. Verify FIPS Mode Enabled
```bash
# On dc1:
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled  # Must return 1

# On each workstation (ws1, ws2, ws3):
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled  # Must return 1
```

**Result:** [ ] PASS [ ] FAIL
**Notes:** ___________________________________________

### 2. Verify Samba Service Status
```bash
systemctl status smb nmb
smbstatus
```

**Result:** [ ] PASS [ ] FAIL
**Samba Version:** ___________
**Notes:** ___________________________________________

### 3. Verify Samba Configuration
```bash
testparm -s
```

**Check for:**
- [ ] `realm = CYBERINABOX.NET`
- [ ] `security = USER`
- [ ] `kerberos method = secrets and keytab`
- [ ] `server min protocol = SMB2` (or SMB3)

**Result:** [ ] PASS [ ] FAIL
**Notes:** ___________________________________________

### 4. Verify Samba Shares Configured
```bash
smbclient -L dc1.cyberinabox.net -k
```

**Expected Shares:**
- [ ] backups
- [ ] (other shares as configured)

**Result:** [ ] PASS [ ] FAIL
**Notes:** ___________________________________________

### 5. Verify RAID Array Mounted
```bash
df -h /srv/samba
cat /proc/mdstat
```

**Result:** [ ] PASS [ ] FAIL
**Available Space:** ___________
**Notes:** ___________________________________________

---

## TEST 1: KERBEROS AUTHENTICATION

### From dc1 (as admin):
```bash
# Get Kerberos ticket
kinit admin

# List available shares
smbclient -L dc1.cyberinabox.net -k

# Connect to share
smbclient //dc1.cyberinabox.net/backups -k
```

**Commands to run in smbclient:**
```
ls
mkdir test_fips
cd test_fips
put /etc/hosts hosts.txt
get hosts.txt /tmp/hosts_test.txt
ls
rm hosts.txt
cd ..
rmdir test_fips
quit
```

**Result:** [ ] PASS [ ] FAIL
**Errors Encountered:** ___________________________________________
**FIPS-related messages:** [ ] YES [ ] NO
**Details:** ___________________________________________

---

## TEST 2: WORKSTATION FILE SHARE MOUNT

### From workstation (ws1, ws2, or ws3):

**Step 1: Get Kerberos Ticket**
```bash
kinit username@CYBERINABOX.NET
klist
```

**Result:** [ ] PASS [ ] FAIL

**Step 2: Create Mount Point**
```bash
sudo mkdir -p /mnt/shared
```

**Step 3: Mount Samba Share**
```bash
# Try Kerberos-based mount:
sudo mount -t cifs //dc1.cyberinabox.net/backups /mnt/shared \
  -o sec=krb5,vers=3.0,seal
```

**Result:** [ ] PASS [ ] FAIL
**Error Messages:** ___________________________________________
**FIPS Violations:** [ ] YES [ ] NO

**Step 4: Test File Operations**
```bash
# Write test
echo "FIPS test $(date)" | sudo tee /mnt/shared/fips_test.txt

# Read test
cat /mnt/shared/fips_test.txt

# Create directory
sudo mkdir /mnt/shared/workstation_backups

# Large file test
sudo dd if=/dev/zero of=/mnt/shared/test_10mb.dat bs=1M count=10

# Verify
ls -lh /mnt/shared/

# Cleanup
sudo rm /mnt/shared/test_10mb.dat
sudo rm /mnt/shared/fips_test.txt
```

**Result:** [ ] PASS [ ] FAIL
**Performance Notes:** ___________________________________________
**Errors:** ___________________________________________

**Step 5: Unmount**
```bash
sudo umount /mnt/shared
```

**Result:** [ ] PASS [ ] FAIL

---

## TEST 3: WORKSTATION BACKUP SIMULATION

### Create Test Backup Script on Workstation:

```bash
cat > /tmp/test_backup.sh << 'EOF'
#!/bin/bash
# Test workstation backup to Samba share

BACKUP_DATE=$(date +%Y%m%d)
WORKSTATION=$(hostname)
MOUNT_POINT="/mnt/backup"
SHARE="//dc1.cyberinabox.net/backups"

# Create mount point
sudo mkdir -p ${MOUNT_POINT}

# Mount share with Kerberos
sudo mount -t cifs ${SHARE} ${MOUNT_POINT} \
  -o sec=krb5,vers=3.0,seal

if [ $? -ne 0 ]; then
  echo "ERROR: Failed to mount share"
  exit 1
fi

# Create backup directory
sudo mkdir -p ${MOUNT_POINT}/workstation_backups/${WORKSTATION}

# Backup /etc directory (test)
sudo tar czf ${MOUNT_POINT}/workstation_backups/${WORKSTATION}/etc-${BACKUP_DATE}.tar.gz /etc

# Verify backup created
ls -lh ${MOUNT_POINT}/workstation_backups/${WORKSTATION}/

# Unmount
sudo umount ${MOUNT_POINT}

echo "Backup test completed successfully"
EOF

chmod +x /tmp/test_backup.sh
```

**Execute Test Backup:**
```bash
sudo /tmp/test_backup.sh
```

**Result:** [ ] PASS [ ] FAIL
**Backup Size:** ___________
**Time Taken:** ___________
**Errors:** ___________________________________________
**FIPS Issues:** [ ] YES [ ] NO

---

## TEST 4: LOG ANALYSIS

### Check for FIPS-related errors on dc1:

```bash
# Samba logs
sudo grep -i fips /var/log/samba/log.*
sudo grep -i "md5\|md4\|des\|rc4" /var/log/samba/log.* | head -20

# System logs
sudo journalctl -u smb -u nmb --since "1 hour ago" | grep -i fips

# Audit logs
sudo ausearch -m avc -ts recent | grep -i samba

# Kernel messages
dmesg | grep -i "fips\|crypto" | tail -20
```

**FIPS Violations Found:** [ ] YES [ ] NO
**Details:** ___________________________________________
___________________________________________
___________________________________________

### Check logs on workstation:

```bash
sudo journalctl --since "1 hour ago" | grep -i "cifs\|smb\|fips"
dmesg | grep -i "cifs\|fips" | tail -20
```

**FIPS Violations Found:** [ ] YES [ ] NO
**Details:** ___________________________________________
___________________________________________

---

## TEST 5: SMB ENCRYPTION VERIFICATION

### Verify SMB3 Encryption is Active:

```bash
# On dc1, check active connections:
sudo smbstatus --encryption

# Should show encryption status for connections
```

**Encryption Active:** [ ] YES [ ] NO
**Encryption Type:** ___________________________________________

### Test with forced encryption:

```bash
# From workstation:
sudo mount -t cifs //dc1.cyberinabox.net/backups /mnt/shared \
  -o sec=krb5,vers=3.0,seal,encrypt

# Verify mount
mount | grep cifs

# Test file operations
sudo touch /mnt/shared/encryption_test.txt
sudo rm /mnt/shared/encryption_test.txt

sudo umount /mnt/shared
```

**Result:** [ ] PASS [ ] FAIL
**Notes:** ___________________________________________

---

## TEST 6: MULTI-WORKSTATION CONCURRENT ACCESS

### From all 3 workstations simultaneously:

**ws1:**
```bash
sudo mkdir -p /mnt/shared
sudo mount -t cifs //dc1.cyberinabox.net/backups /mnt/shared -o sec=krb5,vers=3.0,seal
echo "ws1 test" | sudo tee /mnt/shared/ws1_test.txt
```

**ws2:**
```bash
sudo mkdir -p /mnt/shared
sudo mount -t cifs //dc1.cyberinabox.net/backups /mnt/shared -o sec=krb5,vers=3.0,seal
echo "ws2 test" | sudo tee /mnt/shared/ws2_test.txt
```

**ws3:**
```bash
sudo mkdir -p /mnt/shared
sudo mount -t cifs //dc1.cyberinabox.net/backups /mnt/shared -o sec=krb5,vers=3.0,seal
echo "ws3 test" | sudo tee /mnt/shared/ws3_test.txt
```

**Verify all can read each other's files:**
```bash
# On ws1:
ls -l /mnt/shared/
cat /mnt/shared/ws2_test.txt
cat /mnt/shared/ws3_test.txt
```

**Result:** [ ] PASS [ ] FAIL
**Locking Issues:** [ ] YES [ ] NO
**Permission Issues:** [ ] YES [ ] NO
**Notes:** ___________________________________________

**Cleanup:**
```bash
# On each workstation:
sudo rm /mnt/shared/ws*_test.txt
sudo umount /mnt/shared
```

---

## TEST 7: AUTOMATIC MOUNT AT BOOT (OPTIONAL)

### Configure /etc/fstab entry:

```bash
# On workstation:
echo "//dc1.cyberinabox.net/backups  /mnt/shared  cifs  sec=krb5,vers=3.0,seal,noauto,x-systemd.automount  0  0" | sudo tee -a /etc/fstab
```

### Test automount:
```bash
sudo systemctl daemon-reload
ls /mnt/shared  # Should trigger automount
```

**Result:** [ ] PASS [ ] FAIL (or SKIP)
**Notes:** ___________________________________________

---

## DECISION MATRIX

### Overall Test Results:

| Test | Result | Critical? | Notes |
|------|--------|-----------|-------|
| 1. Kerberos Auth | [ ] PASS [ ] FAIL | YES | |
| 2. Workstation Mount | [ ] PASS [ ] FAIL | YES | |
| 3. Backup Simulation | [ ] PASS [ ] FAIL | YES | |
| 4. Log Analysis | [ ] PASS [ ] FAIL | YES | |
| 5. SMB Encryption | [ ] PASS [ ] FAIL | YES | |
| 6. Concurrent Access | [ ] PASS [ ] FAIL | NO | |
| 7. Automount | [ ] PASS [ ] FAIL | NO | |

### FIPS Compliance Assessment:

**Total Critical Tests Passed:** _____ / 5

**FIPS Violations Detected:** [ ] YES [ ] NO

**If YES, describe:**
___________________________________________
___________________________________________
___________________________________________

---

## FINAL DECISION

**Date:** ___________
**Decision Maker:** Donald E. Shannon

### Option A: KEEP SAMBA ✅
**Select if:**
- All critical tests passed
- No FIPS violations detected
- Performance acceptable
- Workstation backups function properly

**Action Items:**
- [ ] Document FIPS compatibility testing results
- [ ] Update SSP with Samba FIPS validation
- [ ] Mark POA&M-001 COMPLETE
- [ ] Configure automated workstation backups
- [ ] Document Samba share mounting procedures

**POA&M-001 Status:** COMPLETE
**Completion Date:** ___________

---

### Option B: MIGRATE TO NEXTCLOUD 🔄
**Select if:**
- Critical test failures
- FIPS violations detected
- Authentication or encryption issues
- Unacceptable performance

**Action Items:**
- [ ] Plan NextCloud deployment (target: Nov 10-15)
- [ ] Install NextCloud on dc1 or separate container
- [ ] Configure LDAP authentication
- [ ] Migrate existing Samba shares
- [ ] Test workstation backup workflows
- [ ] Disable Samba services
- [ ] Update POA&M-001 with NextCloud completion

**POA&M-001 Status:** IN PROGRESS
**New Target Date:** December 1, 2025

---

### Option C: MIGRATE TO NFS 🔄
**Select if:**
- Samba fails FIPS testing
- NextCloud deemed too complex
- Native Linux file sharing preferred

**Action Items:**
- [ ] Configure NFS server on dc1
- [ ] Set up Kerberos authentication (sec=krb5p)
- [ ] Export /srv/samba via NFS
- [ ] Test workstation NFS mounts
- [ ] Configure workstation backup scripts
- [ ] Disable Samba services
- [ ] Update POA&M-001 with NFS completion

**POA&M-001 Status:** IN PROGRESS
**New Target Date:** November 20, 2025

---

## RECOMMENDATION

**Based on test results, recommended action:**

[ ] OPTION A: Keep Samba (fully FIPS compatible)
[ ] OPTION B: Migrate to NextCloud (preferred alternative)
[ ] OPTION C: Migrate to NFS (simple alternative)

**Justification:**
___________________________________________
___________________________________________
___________________________________________
___________________________________________

**Approved By:** Donald E. Shannon
**Date:** ___________
**Signature:** ___________________________

---

## NOTES AND OBSERVATIONS

___________________________________________
___________________________________________
___________________________________________
___________________________________________
___________________________________________
___________________________________________

---

**END OF TESTING CHECKLIST**
