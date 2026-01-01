# Encryption Key Backup Procedure

## ⚠️ CRITICAL - READ THIS FIRST

**The encryption key is the ONLY way to decrypt your encrypted backups.**

**If you lose this key:**
- ❌ ALL encrypted backups become permanently unrecoverable
- ❌ System restore from encrypted backups is IMPOSSIBLE
- ❌ Data loss is IRREVERSIBLE

**You MUST backup the encryption key immediately and store it securely.**

---

## Encryption Key Location

**Primary Key:** `/root/.backup-encryption/backup.key`

**Permissions:** 400 (read-only by root)
**Owner:** root:root
**Size:** 45 bytes (base64-encoded 256-bit key)

---

## Quick Backup Procedure

### Option 1: Backup to Secure USB Drive (Recommended)

```bash
# 1. Insert and mount a secure USB drive
sudo mkdir -p /media/backup-key
sudo mount /dev/sdX1 /media/backup-key  # Replace sdX1 with your USB device

# 2. Copy the encryption key with date stamp
sudo cp /root/.backup-encryption/backup.key \
    /media/backup-key/dc1-encryption-key-$(date +%Y%m%d).key

# 3. Verify the copy
echo "Original key:"
sudo sha256sum /root/.backup-encryption/backup.key
echo "Backup key:"
sudo sha256sum /media/backup-key/dc1-encryption-key-*.key

# 4. Create a README file with the backup
sudo tee /media/backup-key/README.txt <<EOF
DC1 Backup Encryption Key
System: dc1.cyberinabox.net
Created: $(date)
Purpose: Decrypt encrypted backups from /mnt/nas-backup/encrypted/

KEEP THIS USB DRIVE SECURE:
- Store in locked safe or secure facility
- Do not connect to untrusted systems
- Do not copy key to network shares
- Access restricted to authorized personnel only

To use this key for restore:
1. Copy key to /root/.backup-encryption/backup.key on dc1
2. Set permissions: chmod 400 /root/.backup-encryption/backup.key
3. Use restore script: /usr/local/bin/restore-encrypted-backup.sh
EOF

# 5. Set secure permissions on backup
sudo chmod 400 /media/backup-key/dc1-encryption-key-*.key
sudo chmod 444 /media/backup-key/README.txt

# 6. Unmount and physically secure the USB drive
sudo umount /media/backup-key
# IMPORTANT: Remove USB drive and store in secure location
```

### Option 2: Backup to Password Manager

```bash
# 1. Display the encryption key (copy to password manager)
sudo cat /root/.backup-encryption/backup.key

# 2. In your password manager:
#    - Create new entry: "DC1 Backup Encryption Key"
#    - Paste the key as the password
#    - Add notes:
#      * System: dc1.cyberinabox.net
#      * File location: /root/.backup-encryption/backup.key
#      * Purpose: Decrypt encrypted backups
#      * Restore script: /usr/local/bin/restore-encrypted-backup.sh

# 3. Verify the key was stored correctly by comparing checksums
#    (Copy key from password manager to temporary file for comparison)
```

### Option 3: Print to Paper (Secure Facility Storage)

```bash
# 1. Print the key to a file
sudo cat /root/.backup-encryption/backup.key > /tmp/key-to-print.txt
echo "" >> /tmp/key-to-print.txt
echo "DC1 Backup Encryption Key" >> /tmp/key-to-print.txt
echo "System: dc1.cyberinabox.net" >> /tmp/key-to-print.txt
echo "File: /root/.backup-encryption/backup.key" >> /tmp/key-to-print.txt
echo "Date: $(date)" >> /tmp/key-to-print.txt
echo "Checksum: $(sudo sha256sum /root/.backup-encryption/backup.key | cut -d' ' -f1)" >> /tmp/key-to-print.txt

# 2. Print the file (lpr command or transfer to a system with a printer)
cat /tmp/key-to-print.txt

# 3. After printing:
sudo shred -u /tmp/key-to-print.txt  # Securely delete the temporary file

# 4. Store printed key in:
#    - Locked safe
#    - Secure document storage
#    - Safety deposit box
```

---

## Verification Procedure

After backing up the key, verify it can be used for restore:

```bash
# 1. Copy your backup key to a test location
sudo cp /media/backup-key/dc1-encryption-key-*.key /tmp/test-key

# 2. Set correct permissions
sudo chmod 400 /tmp/test-key

# 3. Test decryption with backup key (this will NOT modify original backup)
sudo /usr/local/bin/restore-encrypted-backup.sh -v \
    -k /tmp/test-key \
    backup-YYYYMMDD-HHMMSS.tar.gz.enc

# 4. Clean up test key
sudo shred -u /tmp/test-key

# If verification fails, your backup key is invalid - repeat backup procedure!
```

---

## Key Recovery Procedure

If you need to restore the encryption key from backup:

```bash
# 1. Copy backup key to correct location
sudo cp /path/to/backup/dc1-encryption-key-*.key /root/.backup-encryption/backup.key

# 2. Set correct permissions
sudo chmod 400 /root/.backup-encryption/backup.key
sudo chown root:root /root/.backup-encryption/backup.key

# 3. Verify the key works
sudo /usr/local/bin/restore-encrypted-backup.sh -v backup-YYYYMMDD-HHMMSS.tar.gz.enc

# If verification passes, the key is restored correctly
```

---

## Security Best Practices

### ✅ DO:
- Store backup key in physically secure location
- Use strong password manager encryption
- Limit access to encryption key to authorized personnel only
- Test key backup annually
- Document key backup location in secure records
- Use multiple backup methods (defense in depth)

### ❌ DO NOT:
- Store key on the NAS with encrypted backups
- Email the encryption key
- Store key on network shares
- Share key via messaging apps
- Store key in plaintext files
- Upload key to cloud storage without encryption

---

## Backup Schedule

**Initial Backup:** Immediately after encryption implementation
**Regular Backups:** After any key rotation (recommended annually)
**Testing:** Verify backup key works at least annually

---

## Multiple Backup Copies Recommended

For critical systems, maintain multiple secure copies:

1. **Primary:** Secure USB drive in locked safe (on-site)
2. **Secondary:** Enterprise password manager
3. **Tertiary:** Secure USB drive in off-site secure facility
4. **Optional:** Printed copy in safety deposit box

---

## Key Rotation Policy

**Current Policy:** No automatic rotation
**Recommended:** Rotate encryption key annually

**Key Rotation Procedure (when needed):**
```bash
# 1. Generate new encryption key
sudo openssl rand -base64 32 > /root/.backup-encryption/backup.key.new

# 2. Set permissions
sudo chmod 400 /root/.backup-encryption/backup.key.new

# 3. Backup OLD key with label "DEPRECATED"
sudo cp /root/.backup-encryption/backup.key \
    /media/backup-key/dc1-encryption-key-DEPRECATED-$(date +%Y%m%d).key

# 4. Test new key with a backup
sudo /usr/local/bin/backup-to-nas-encrypted.sh

# 5. If successful, replace old key
sudo mv /root/.backup-encryption/backup.key /root/.backup-encryption/backup.key.old
sudo mv /root/.backup-encryption/backup.key.new /root/.backup-encryption/backup.key

# 6. Backup NEW key following this procedure

# 7. Keep OLD key for 90 days to decrypt legacy backups
```

---

## Emergency Contact

If encryption key is lost or compromised:

1. **Immediate Action:** Generate new encryption key
2. **Assessment:** Determine which backups are affected
3. **Notification:** Inform system owner and security team
4. **Documentation:** Update incident log

**Contact:** Daniel Shannon (dshannon)

---

## Audit Log

Document each key backup:

| Date | Method | Location | Verified | Personnel |
|------|--------|----------|----------|-----------|
| 2025-12-28 | Initial | TBD | ⏳ | dshannon |

---

**CRITICAL REMINDER: Complete this backup procedure TODAY. Set a calendar reminder to verify the backup annually.**

---

**END OF DOCUMENT**
