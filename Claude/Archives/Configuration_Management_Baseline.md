# CONFIGURATION MANAGEMENT BASELINE
**Organization:** The Contract Coach (Donald E. Shannon LLC)
**System:** CyberHygiene Production Network (cyberinabox.net)
**Version:** 1.0
**Effective Date:** November 1, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)

**NIST Controls:** CM-1, CM-2, CM-3, CM-4, CM-5, CM-6, CM-7, CM-8, CM-9

---

## DOCUMENT CONTROL

| Name / Title | Role | Signature / Date |
|---|---|---|
| Donald E. Shannon<br>Owner/Principal | System Owner | _____________________<br>Date: _______________ |
| Donald E. Shannon<br>Owner/Principal | Configuration Manager | _____________________<br>Date: _______________ |

**Review Schedule:** Quarterly or upon significant changes
**Next Review Date:** February 1, 2026

---

## 1. PURPOSE AND SCOPE

### 1.1 Purpose
This Configuration Management Baseline establishes the approved security configuration baseline for all systems within The Contract Coach's CyberHygiene Production Network. This document ensures compliance with NIST SP 800-171 configuration management requirements and provides a reference for system hardening, change control, and security verification.

### 1.2 Scope
This baseline applies to:
- Domain controller: dc1.cyberinabox.net
- Workstations: ws1, ws2, ws3.cyberinabox.net
- Network infrastructure: pfSense firewall/router
- External backup storage: DataStore (Synology NAS at 192.168.1.118) - **OUTSIDE ACCREDITATION BOUNDARY**
- All Rocky Linux 9.6 systems
- Configuration files and system settings

**Note:** DataStore is documented for inventory purposes but is not part of the FIPS-validated system boundary. It stores only pre-encrypted data created using FIPS 140-2 validated cryptographic modules.

### 1.3 Configuration Management Objectives
- Establish and maintain secure baseline configurations
- Control changes to baseline configurations
- Document all configuration changes
- Verify compliance with security requirements
- Enable rapid system recovery and deployment

---

## 2. BASELINE SYSTEM CONFIGURATION

### 2.1 Standard Hardware Configuration

#### Domain Controller (dc1.cyberinabox.net)
**Hardware:**
- System: HP MicroServer Gen 10+
- CPU: AMD Opteron X3421 (4 cores, 2.1-3.4 GHz)
- RAM: 32GB ECC DDR4
- Boot Drive: 2TB SSD (Samsung 870 EVO)
- RAID Array: 3x 3TB HDD (RAID 5 configuration, 5.5TB usable)
- Network: Dual Gigabit Ethernet
- IP Address: 192.168.1.10/24 (static)

**Boot Drive Partition Scheme:**
```
/dev/sda1    1GB      /boot/efi       (unencrypted, FAT32)
/dev/sda2    8GB      /boot           (unencrypted, XFS)
/dev/sda3    96GB     /               (unencrypted, XFS)
/dev/sda4    ~1.8TB   LUKS encrypted volume group
  - /home              64GB    (XFS)
  - /var               256GB   (XFS)
  - /var/log           64GB    (XFS)
  - /var/log/audit     64GB    (XFS)
  - /tmp               32GB    (XFS)
  - /data              512GB   (XFS)
  - /backup            512GB   (XFS)
  - swap               16GB
```

**RAID Array:**
```
/dev/md0     5.5TB    LUKS encrypted
  - /srv/samba         (XFS)
```

#### Workstations (ws1, ws2, ws3)
**Hardware:** Various configurations
**Common Requirements:**
- Minimum 8GB RAM
- SSD boot drives with full disk encryption (LUKS)
- Gigabit Ethernet
- DHCP IP assignment from pfSense

#### External Backup Storage (DataStore - OUTSIDE ACCREDITATION BOUNDARY)
**Hardware:**
- System: Synology DS1821+ (8-bay NAS)
- Device Name: DataStore
- Operating System: Synology DSM 7.2.2-72806 Update 4
- Processor: AMD Ryzen V1500B (4 cores)
- RAM: 32GB
- Storage: Volume 1 - 20.9 TB total capacity (19.3 TB available)
- IP Address: 192.168.1.118/24 (static)
- Network: Gigabit Ethernet
- Purpose: Network-attached backup storage for FIPS-encrypted data (2nd copy in 3-2-1 strategy)

**Physical Security:**
- Location: Same server rack as dc1.cyberinabox.net (home office)
- **Note:** NOT considered "offsite" per 3-2-1 backup principle
- Physical access controls: Locked server rack, home office access control
- Environmental: Shared HVAC, UPS, and fire suppression with dc1

**Security Status:**
- **NOT FIPS 140-2 Certified** (device outside accreditation boundary)
- Synology DSM AES-256 encryption: Enabled (supplementary defense-in-depth only)
- SSH access: Restricted to dc1 only
- No direct internet access (firewalled)

**Compliance Strategy:**
This device stores **ONLY** pre-encrypted data that has been encrypted using FIPS 140-2 validated cryptographic modules on dc1.cyberinabox.net prior to transmission. All CUI data is encrypted within the FIPS boundary before transfer to DataStore.

**Permitted Data Types:**
- ✓ LUKS-encrypted container files created on dc1
- ✓ ReaR disaster recovery ISOs (containing LUKS-encrypted partitions)
- ✓ OpenSSL-encrypted archive files (encrypted on dc1 in FIPS mode)
- ✗ PROHIBITED: Unencrypted CUI or data encrypted by Synology

**Data Protection Model:**
```
Layer 1 (Primary):   FIPS 140-2 encryption on dc1 (LUKS/OpenSSL)
Layer 2 (Transport): TLS 1.2+ from FIPS-validated libraries
Layer 3 (Storage):   Synology AES-256 (defense-in-depth, supplementary)
```

**Compensating Controls:**
- SC-28: All CUI encrypted with FIPS-validated tools before leaving dc1
- SC-13: FIPS 140-2 cryptography used for all CUI encryption/decryption
- MP-5/MP-6: Device treated as removable media for sanitization purposes
- PE-3: Physical security controls applied (home office access control)

**Restoration Process:**
Data restoration ONLY occurs on FIPS-validated systems (dc1 or workstations). Synology never decrypts CUI data - it only stores and returns encrypted blobs.

#### Offsite Removable Media Storage (3-2-1 Backup Strategy - 3rd Copy)
**Hardware:**
- Media Type: External USB hard drive(s) - FIPS 140-2 compatible
- Quantity: 3 drives (A, B, C) for quarterly rotation
- Encryption: LUKS2 full-disk encryption (FIPS-validated)
- Capacity: Minimum 2TB per drive (sufficient for monthly full backups)
- Format: Encrypted ext4 filesystem
- Labeling: "CUI - ENCRYPTED BACKUP - [DRIVE LETTER] - [MONTH/YEAR]"

**3-2-1 Backup Strategy Implementation:**
```
3 Copies:  1. Production data on dc1 (LUKS-encrypted RAID + SSD)
           2. Network backup on DataStore Synology NAS (FIPS pre-encrypted)
           3. Offsite removable media (LUKS-encrypted USB)

2 Media:   1. On-premises storage (dc1 SSD/RAID + DataStore)
           2. Removable media (USB drives)

1 Offsite: Monthly rotation of LUKS-encrypted USB drives to secure
           offsite location (separate from home office)
```

**Operational Procedures:**
- **Frequency:** Monthly (1st business day of each month)
- **Automation:** Manual execution of `/usr/local/bin/backups/monthly-usb-offsite-backup.sh`
- **Process:**
  1. Retrieve USB drive from Wells Fargo Bank safe deposit box (if not already on-premises)
  2. Connect LUKS-encrypted USB drive to dc1
  3. Execute backup script: `sudo /usr/local/bin/backups/monthly-usb-offsite-backup.sh /dev/sdX`
  4. Script automatically: unlocks volume, performs backup, verifies integrity, closes volume
  5. Disconnect USB drive
  6. Update physical label with current month/year
  7. Record in chain of custody log
  8. Transport to Wells Fargo Bank safe deposit box within 24 hours
  9. Rotate drives quarterly (3-month cycle per drive)

**Offsite Storage Location:**
- **Facility:** Wells Fargo Bank
- **Storage Type:** Safe deposit box
- **Security:** Bank-grade physical security with dual-key access
- **Access Control:** Only system owner (Donald E. Shannon) authorized
- **Location:** Separate from home office (meets "offsite" requirement)

**Security Requirements:**
- ✓ LUKS2 encryption created on dc1 in FIPS mode
- ✓ Strong passphrase (minimum 20 characters, stored separately from media)
- ✓ Passphrase stored in /root/.monthly-backup-passphrase (600 permissions)
- ✓ Media labeled: "CUI - ENCRYPTED BACKUP - [A/B/C] - [MONTH/YEAR]"
- ✓ Chain of custody log maintained for all transport operations
- ✓ Bank safe deposit box storage (dual-key access control)
- ✓ Media sanitization upon decommissioning (cryptographic erasure + physical destruction)

**Compensating Controls:**
- CP-9: System backup with offsite storage (Wells Fargo Bank)
- MP-5: Media transport with encryption and chain of custody
- MP-6: Media sanitization procedures
- SC-28: Protection of information at rest (LUKS2 FIPS encryption)
- PE-3: Physical protection (bank-grade security)

**Media Rotation Schedule (3-Drive Quarterly Rotation):**
```
Drive A: January, April, July, October     (Q1, Q2, Q3, Q4)
Drive B: February, May, August, November   (Month 2, 5, 8, 11)
Drive C: March, June, September, December  (Month 3, 6, 9, 12)

Each drive is used every 3 months, providing redundancy and extended media lifecycle.
```

**Rotation Example:**
```
Jan 2026: Backup to Drive A → Wells Fargo → (Drive B returns to office)
Feb 2026: Backup to Drive B → Wells Fargo → (Drive C returns to office)
Mar 2026: Backup to Drive C → Wells Fargo → (Drive A returns to office)
Apr 2026: Backup to Drive A → Wells Fargo → (Drive B returns to office)
... continues quarterly rotation
```

**Benefits of 3-Drive Rotation:**
- Each drive used only 4 times per year (reduced wear)
- 2 drives always in Wells Fargo (additional backup redundancy)
- 1 drive on-premises ready for next monthly backup
- 3-month recovery window per drive

### 2.2 Standard Software Configuration

#### Operating System Baseline
**Distribution:** Rocky Linux 9.6 (Blue Onyx)
**Kernel:** 5.14.0-427.x or later (FIPS-validated)
**Architecture:** x86_64

**Critical Settings:**
- FIPS 140-2 mode: **ENABLED** (required on all systems)
- SELinux: **Enforcing** (required)
- Firewalld: **Enabled** with restrictive rules
- Time synchronization: chronyd (NTP)
- Audit logging: auditd enabled

**Verification Commands:**
```bash
# FIPS mode verification
fips-mode-setup --check          # Must return "enabled"
cat /proc/sys/crypto/fips_enabled # Must return 1
cat /proc/cmdline | grep fips    # Must show "fips=1"

# SELinux verification
getenforce                       # Must return "Enforcing"
sestatus                         # Verify enabled and enforcing

# Audit logging
systemctl status auditd          # Must be active (running)
```

#### Security Hardening Baseline
**Applied Standard:** OpenSCAP CUI Profile
```bash
Profile: xccdf_org.ssgproject.content_profile_cui
Compliance Target: 100% (110/110 controls)
```

**Key Hardening Measures:**
- Login banners (GUI, console, SSH) displaying warning messages
- Password complexity requirements (PAM)
- Account lockout after 5 failed attempts
- Audit logging for all security events
- Firewall restricting all but necessary services
- Unnecessary services disabled
- File permission restrictions
- Kernel hardening parameters (sysctl)

#### Package Management Baseline
**Package Manager:** DNF (YUM successor)
**Update Policy:** Automatic security updates enabled (dnf-automatic)
```bash
# Configuration: /etc/dnf/automatic.conf
upgrade_type = security
apply_updates = yes
```

**Required Package Groups:**
- @Base
- @Core
- @Development Tools (for source compilation when needed)
- @Security Tools

**Required Packages (All Systems):**
```
audit
chrony
openscap-scanner
scap-security-guide
firewalld
rsyslog
aide (or FIM via Wazuh)
fail2ban
usbguard (to be deployed)
ipa-client (workstations)
```

**Required Packages (Domain Controller):**
```
ipa-server
bind
bind-dyndb-ldap
certbot
postfix (when email server deployed)
dovecot (when email server deployed)
clamav (antivirus)
wazuh-agent
wazuh-manager
wazuh-indexer
filebeat
```

---

## 3. SERVICE CONFIGURATION BASELINE

### 3.1 FreeIPA Domain Controller Configuration

**Service:** FreeIPA 4.11.x
**Realm:** CYBERINABOX.NET
**Domain:** cyberinabox.net
**Directory Manager:** Secure password (minimum 14 characters)
**Admin Account:** admin@CYBERINABOX.NET

**Components:**
- 389 Directory Server (LDAP)
- MIT Kerberos (KDC and kadmin)
- Dogtag Certificate System (CA)
- BIND with DNSSEC
- Apache (Web UI)
- SSSD (System Security Services Daemon)

**Configuration Files:**
```
/etc/ipa/default.conf
/etc/dirsrv/slapd-CYBERINABOX-NET/
/var/kerberos/krb5kdc/kdc.conf
/etc/krb5.conf
/etc/httpd/conf.d/ipa.conf
```

**Key Settings:**
- Password policy: 14 char minimum, 3 character classes, 90-day expiration
- Kerberos ticket lifetime: 24 hours
- TLS/SSL: Wildcard certificate from SSL.com (*.cyberinabox.net)
- LDAP: TLS encryption required
- Web UI: HTTPS only (port 443)

### 3.2 Wazuh Security Platform Configuration

**Components:**
- Wazuh Manager 4.9.2
- Wazuh Indexer 4.9.2
- Filebeat 7.10.2
- Wazuh Agent (on all systems)

**Key Features Enabled:**
- Vulnerability detection (hourly updates)
- File integrity monitoring (FIM)
- Security configuration assessment (CIS benchmarks)
- Malware detection (ClamAV, YARA)
- Active response rules
- Centralized log collection

**Configuration Files:**
```
/var/ossec/etc/ossec.conf
/var/ossec/etc/rules/local_rules.xml
/var/ossec/etc/decoders/local_decoder.xml
```

### 3.3 Firewall Configuration Baseline

**pfSense Configuration:**
- WAN interface: DHCP from ISP
- LAN interface: 192.168.1.1/24 (static)
- DHCP server: 192.168.1.100-192.168.1.200
- DNS: Forwarding to 1.1.1.1 (Cloudflare) and 8.8.8.8 (Google)
- NTP: Enabled

**Allowed Inbound Services (LAN → dc1):**
- TCP 22 (SSH) - restricted to workstations only
- TCP 80, 443 (HTTP/HTTPS) - FreeIPA Web UI
- TCP 389, 636 (LDAP/LDAPS)
- TCP/UDP 88, 464 (Kerberos)
- TCP/UDP 53 (DNS)
- UDP 123 (NTP)

**Outbound Services:**
- Allow all from LAN to WAN (NAT)
- Block direct WAN access to DMZ/internal

**Firewalld (Rocky Linux systems):**
```bash
# Default zone: drop
firewall-cmd --set-default-zone=drop

# Trusted zone for internal LAN
firewall-cmd --permanent --zone=trusted --add-source=192.168.1.0/24
firewall-cmd --permanent --zone=trusted --add-service={ssh,http,https,ldap,ldaps,kerberos,dns,ntp}
firewall-cmd --reload
```

### 3.4 SSH Configuration Baseline

**Configuration File:** /etc/ssh/sshd_config

**Required Settings:**
```
Protocol 2
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication yes (required for FreeIPA)
PermitEmptyPasswords no
UsePAM yes
X11Forwarding no
MaxAuthTries 5
ClientAliveInterval 300
ClientAliveCountMax 2
Banner /etc/issue.net
Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256
KexAlgorithms ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
```

**Verification:**
```bash
sudo sshd -T | grep -E "permitrootlogin|passwordauth|banner"
```

---

## 4. SECURITY CONFIGURATION SETTINGS (CM-6)

### 4.1 System Hardening Parameters

**Kernel Parameters (sysctl):**
File: /etc/sysctl.d/99-security.conf
```
# Network security
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Kernel security
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.yama.ptrace_scope = 1
fs.suid_dumpable = 0
```

**Apply and verify:**
```bash
sudo sysctl -p /etc/sysctl.d/99-security.conf
sudo sysctl -a | grep -E "rp_filter|accept_source_route|accept_redirects"
```

### 4.2 Password Policy Configuration

**PAM Configuration:** /etc/security/pwquality.conf
```
minlen = 14
minclass = 3
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
difok = 8
maxrepeat = 3
gecoscheck = 1
enforce_for_root
```

**Account Lockout:** /etc/security/faillock.conf
```
deny = 5
fail_interval = 900
unlock_time = 1800
audit
silent
```

**FreeIPA Password Policy:**
```bash
ipa pwpolicy-show
  Max lifetime (days): 90
  Min lifetime (hours): 24
  Min length: 14
  Character classes: 3
  History size: 24
  Max failures: 5
  Failure reset interval: 900
  Lockout duration: 1800
```

### 4.3 Audit Configuration

**Audit Rules:** /etc/audit/rules.d/audit.rules

**Key audit events:**
```
# Monitor authentication
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity

# Monitor privileged commands
-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=unset -k privileged
-a always,exit -F path=/usr/bin/su -F perm=x -F auid>=1000 -F auid!=unset -k privileged

# Monitor system calls
-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change

# Monitor file deletions
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=unset -k delete

# Monitor changes to kernel modules
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
```

**Reload audit rules:**
```bash
sudo augenrules --load
sudo systemctl restart auditd
```

---

## 5. CONFIGURATION CHANGE CONTROL (CM-3)

### 5.1 Change Control Process

**Change Categories:**

**Category 1: Emergency Changes**
- Security patches for critical vulnerabilities
- Response to active security incidents
- System failures requiring immediate recovery
- Approval: System Owner (immediately)
- Documentation: Within 24 hours

**Category 2: Standard Changes**
- Routine security updates
- Configuration adjustments
- Software updates
- Approval: System Owner (planned)
- Documentation: Before implementation

**Category 3: Major Changes**
- New system deployments
- Major software upgrades
- Infrastructure changes
- Approval: System Owner + testing
- Documentation: Change plan + results

### 5.2 Change Request Process

**Change Request Template:**
```
Change ID: CHG-YYYY-MM-DD-###
Requested By: [Name]
Date Requested: [Date]
Category: [Emergency/Standard/Major]

Description:
[What is being changed and why]

Systems Affected:
[ ] dc1 [ ] ws1 [ ] ws2 [ ] ws3 [ ] pfSense [ ] All

Risk Assessment:
Impact: [ ] Low [ ] Medium [ ] High
Risk: [ ] Low [ ] Medium [ ] High

Implementation Plan:
1. [Step-by-step procedure]
2.
3.

Backout Plan:
1. [How to reverse the change]
2.

Testing Plan:
[How change will be tested/verified]

Schedule:
Implementation Date: [Date/Time]
Expected Duration: [Hours]

Approval:
[ ] Approved [ ] Denied [ ] Deferred
Approved By: _____________ Date: _______

Results:
[ ] Successful [ ] Failed [ ] Partial
Notes: _________________________________
```

### 5.3 Change Documentation

**Change Log Location:** /root/change-log.txt or ~/Documents/Claude/

**Required Information:**
- Date and time of change
- Change ID and description
- Systems affected
- Person implementing change (always: D. Shannon)
- Approval documentation
- Configuration before/after (if applicable)
- Test results
- Any issues encountered

**Example Entry:**
```
Date: 2025-11-01 14:30
Change ID: CHG-2025-11-01-001
Type: Standard
Description: Updated Rocky Linux 9.6 security patches
Systems: dc1, ws1, ws2, ws3
Implemented By: D. Shannon
Approved By: D. Shannon
Packages Updated: kernel, openssl, gnutls, openssh
Testing: Verified FIPS mode still enabled, services operational
Status: Successful
Backout: Not needed
```

### 5.4 Configuration Backup Procedures

**Before Every Major Change:**
```bash
# FreeIPA backup
sudo ipa-backup --data --logs

# Configuration files backup
sudo tar -czf /backup/config-$(date +%Y%m%d-%H%M%S).tar.gz \
  /etc/ipa/ \
  /etc/ssh/ \
  /etc/audit/ \
  /etc/security/ \
  /var/ossec/etc/ \
  /etc/sysctl.d/

# Verification
sudo tar -tzf /backup/config-*.tar.gz | head
```

**Offsite Backup to DataStore (Synology NAS):**

All backups transferred to DataStore MUST be encrypted using FIPS 140-2 validated cryptographic modules on dc1 before transmission.

```bash
# Weekly Disaster Recovery ISO Backup (ReaR)
# ReaR ISOs already contain LUKS-encrypted partitions
sudo rear -v mkbackup
sudo rsync -avz --progress -e "ssh -c aes256-gcm@openssh.com" \
  /var/lib/rear/output/rear-*.iso \
  synology@192.168.1.118:/volume1/backups/disaster-recovery/

# Daily Critical Files - FIPS Encrypted Archive Method
sudo tar czf - /data /var/lib/ipa /etc | \
  openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt \
  -out /backup/daily-backup-$(date +%Y%m%d).tar.gz.enc

sudo rsync -avz --progress -e "ssh -c aes256-gcm@openssh.com" \
  /backup/daily-backup-*.tar.gz.enc \
  synology@192.168.1.118:/volume1/backups/daily/

# Alternative: LUKS Encrypted Container Method
sudo dd if=/dev/zero of=/backup/encrypted-backup.img bs=1M count=10240
sudo cryptsetup luksFormat --type luks2 /backup/encrypted-backup.img
sudo cryptsetup luksOpen /backup/encrypted-backup.img backup_container
sudo mkfs.ext4 /dev/mapper/backup_container
sudo mount /dev/mapper/backup_container /mnt/backup
sudo rsync -avz /data/ /mnt/backup/
sudo umount /mnt/backup
sudo cryptsetup luksClose backup_container

sudo rsync -avz --progress -e "ssh -c aes256-gcm@openssh.com" \
  /backup/encrypted-backup.img \
  synology@192.168.1.118:/volume1/backups/containers/
```

**Restoration from DataStore:**
```bash
# Retrieve encrypted backup from Synology
sudo rsync -avz synology@192.168.1.118:/volume1/backups/daily/daily-backup-*.tar.gz.enc \
  /tmp/

# Decrypt on FIPS-validated system (dc1)
openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 \
  -in /tmp/daily-backup-*.tar.gz.enc | tar xzf -

# Or restore LUKS container
sudo rsync -avz synology@192.168.1.118:/volume1/backups/containers/encrypted-backup.img \
  /tmp/
sudo cryptsetup luksOpen /tmp/encrypted-backup.img restored_backup
sudo mount /dev/mapper/restored_backup /mnt/restore
# Access files at /mnt/restore
```

**IMPORTANT SECURITY REQUIREMENTS:**
- ✓ All encryption/decryption operations MUST occur on FIPS-validated systems
- ✓ DataStore NEVER decrypts CUI data
- ✓ SSH connections use FIPS-approved ciphers (aes256-gcm@openssh.com)
- ✓ OpenSSL encryption uses FIPS mode with strong key derivation (PBKDF2)
- ✓ LUKS containers use LUKS2 format with FIPS-compatible settings
- ✓ Encryption keys/passphrases stored only on dc1, never on DataStore

**Monthly Offsite Backup to LUKS-Encrypted USB Drive:**

Complete 3-2-1 backup strategy requires monthly offsite backup rotation.

```bash
# Monthly Full Backup to Encrypted USB Drive (1st business day of month)

# Step 1: Connect USB drive to dc1 and identify device
lsblk
# Assume USB drive is /dev/sdc

# Step 2: Create LUKS2 encrypted volume (FIRST TIME ONLY)
sudo cryptsetup luksFormat --type luks2 \
  --cipher aes-xts-plain64 --key-size 512 --hash sha256 \
  --pbkdf pbkdf2 --pbkdf-force-iterations 100000 \
  /dev/sdc

# Step 3: Open encrypted volume
sudo cryptsetup luksOpen /dev/sdc monthly_backup

# Step 4: Create filesystem (FIRST TIME ONLY)
sudo mkfs.ext4 -L "CUI_BACKUP_$(date +%Y%m)" /dev/mapper/monthly_backup

# Step 5: Mount encrypted volume
sudo mkdir -p /mnt/monthly_backup
sudo mount /dev/mapper/monthly_backup /mnt/monthly_backup

# Step 6: Perform full backup
sudo rsync -avAX --delete --progress \
  /data/ \
  /var/lib/ipa/ \
  /etc/ \
  /home/ \
  /srv/samba/ \
  /mnt/monthly_backup/

# Step 7: Copy latest ReaR ISO
sudo cp /var/lib/rear/output/rear-*.iso /mnt/monthly_backup/

# Step 8: Create backup manifest
sudo find /mnt/monthly_backup -type f > /mnt/monthly_backup/backup-manifest-$(date +%Y%m%d).txt
sudo sha256sum /mnt/monthly_backup/rear-*.iso >> /mnt/monthly_backup/backup-manifest-$(date +%Y%m%d).txt

# Step 9: Verify backup
sudo df -h /mnt/monthly_backup
sudo ls -lah /mnt/monthly_backup/

# Step 10: Unmount and close encrypted volume
sudo umount /mnt/monthly_backup
sudo cryptsetup luksClose monthly_backup

# Step 11: Label and transport
# Physical label: "CUI - ENCRYPTED BACKUP - [MONTH/YEAR]"
# Transport to offsite location within 24 hours
# Maintain chain of custody log
```

**Restoration from Offsite USB:**
```bash
# Connect USB drive to dc1
sudo cryptsetup luksOpen /dev/sdc monthly_backup
sudo mount /dev/mapper/monthly_backup /mnt/restore
# Access files at /mnt/restore
# Restore specific files or full system as needed
sudo umount /mnt/restore
sudo cryptsetup luksClose monthly_backup
```

**3-2-1 Backup Summary:**
```
COPY 1 (Production):     dc1 LUKS-encrypted RAID + SSD
COPY 2 (Network/Daily):  DataStore Synology NAS (FIPS pre-encrypted)
COPY 3 (Offsite/Monthly): LUKS-encrypted USB drives (rotated monthly)

MEDIA 1 (On-premises):   dc1 + DataStore (same physical location)
MEDIA 2 (Removable):     USB external drives

OFFSITE 1:               Monthly USB rotation to secure location
```

**Backup Retention Policy:**
- **Daily backups (DataStore):** 30 days rolling
- **Weekly ReaR ISOs (DataStore):** 12 weeks rolling
- **Monthly offsite USB:** 12 months minimum (1 year retention)
- **Annual archives:** Permanent retention on separate encrypted media

---

## 6. SOFTWARE INVENTORY (CM-8)

### 6.1 Authorized Software List

**System Software (All Systems):**
- Rocky Linux 9.6 base packages
- OpenSCAP scanner and SCAP security guide
- Audit daemon (auditd)
- Chrony (NTP)
- Firewalld
- Fail2ban
- USBGuard (to be deployed)
- Rsyslog

**Security Software:**
- Wazuh agent 4.9.2
- ClamAV 1.0.x (FIPS version when available)
- YARA 4.5.2
- AIDE or Wazuh FIM

**Domain Controller Specific:**
- FreeIPA server 4.11.x
- 389 Directory Server
- MIT Kerberos
- Dogtag CA
- BIND DNS server
- Apache web server
- Postfix (email server - to be deployed)
- Dovecot (IMAP/POP3 - to be deployed)
- Wazuh manager and indexer
- Filebeat

**Backup and Recovery Software:**
- ReaR (Relax-and-Recover) - disaster recovery ISO creation
- Rsync - file synchronization and transfer
- OpenSSL (FIPS mode) - encryption for backup archives
- cryptsetup (LUKS) - encrypted container creation

**Workstation Specific:**
- FreeIPA client
- LibreOffice (document processing)
- Firefox (web browser)
- Thunderbird (email client - to be deployed)
- PDF viewers/editors

**Development Tools (as needed):**
- GCC compiler suite
- Python 3.9
- Git
- Text editors (vim, nano)

### 6.2 Prohibited Software

**Explicitly Prohibited:**
- Peer-to-peer file sharing applications
- Unauthorized cloud storage sync clients (Dropbox, etc.)
- Tor or anonymization software (unless authorized)
- Cryptocurrency mining software
- Game software
- Unlicensed commercial software
- Software with known security vulnerabilities

**Unauthorized Installation:**
All software installations require system owner approval. Users cannot install software with elevated privileges.

### 6.3 Software Inventory Verification

**Monthly Verification:**
```bash
# List installed packages
sudo dnf list installed > /root/package-inventory-$(date +%Y%m%d).txt

# Check for unauthorized packages
comm -13 <(cat /root/authorized-packages.txt | sort) \
         <(rpm -qa --qf '%{NAME}\n' | sort)

# Review running services
systemctl list-units --type=service --state=running
```

---

## 7. LEAST FUNCTIONALITY (CM-7)

### 7.1 Disabled Services

**Services Disabled on All Systems:**
```bash
sudo systemctl disable --now bluetooth
sudo systemctl disable --now cups (if not needed)
sudo systemctl disable --now avahi-daemon
sudo systemctl mask bluetooth cups avahi-daemon
```

**Verification:**
```bash
systemctl list-unit-files --state=enabled
systemctl list-unit-files --state=masked
```

### 7.2 Removed Packages

**Unnecessary packages removed:**
```bash
sudo dnf remove xorg-x11-server-Xorg (if GUI not needed)
sudo dnf remove telnet
sudo dnf remove rsh-server
sudo dnf remove ypbind
sudo dnf remove tftp-server
```

### 7.3 Network Services

**Allowed Services (dc1):**
- SSH (TCP 22)
- HTTP/HTTPS (TCP 80, 443)
- LDAP/LDAPS (TCP 389, 636)
- Kerberos (TCP/UDP 88, 464)
- DNS (TCP/UDP 53)
- NTP (UDP 123)
- Wazuh (TCP 1514, 1515, 55000)

**Allowed Services (Workstations):**
- SSH (TCP 22)
- Wazuh agent (TCP 1514)

**All Other Ports:** BLOCKED by firewalld

---

## 8. CONFIGURATION MONITORING AND VERIFICATION

### 8.1 Automated Compliance Scanning

**OpenSCAP Monthly Scans:**
```bash
# Run scan
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_cui \
  --results /root/oscap-$(date +%Y%m%d).xml \
  --report /root/oscap-$(date +%Y%m%d).html \
  /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# Review results
firefox /root/oscap-$(date +%Y%m%d).html
```

**Target:** 100% compliance (110/110 checks passed)

### 8.2 File Integrity Monitoring

**Wazuh FIM Configuration:**
Monitor critical configuration files for unauthorized changes:
- /etc/
- /usr/bin/, /usr/sbin/
- /boot/
- /root/.ssh/

**Alert on:**
- File modifications
- File deletions
- Permission changes
- Ownership changes

### 8.3 Configuration Drift Detection

**Quarterly Verification:**
1. Run OpenSCAP scan
2. Compare with baseline results
3. Investigate any failures or changes
4. Document deviations
5. Remediate or approve exceptions

**Drift Response:**
- Minor drift (1-2 settings): Document and remediate
- Major drift (>5 settings): Investigate root cause, may require system rebuild
- Approved exceptions: Document in SSP

---

## 9. BASELINE VERIFICATION PROCEDURES

### 9.1 New System Deployment Checklist

**For all new Rocky Linux systems:**
- [ ] Install Rocky Linux 9.6 from verified ISO
- [ ] Configure partitioning per baseline
- [ ] Enable FIPS mode during installation or immediately after
- [ ] Set SELinux to enforcing
- [ ] Apply all security updates
- [ ] Run OpenSCAP remediation
- [ ] Verify 100% OpenSCAP compliance
- [ ] Configure firewalld rules
- [ ] Enable auditd
- [ ] Configure chrony for time sync
- [ ] Apply kernel hardening parameters
- [ ] Configure PAM password policy
- [ ] Install and configure Wazuh agent
- [ ] Join to FreeIPA domain (workstations)
- [ ] Install required software per inventory
- [ ] Remove prohibited software
- [ ] Disable unnecessary services
- [ ] Configure backup jobs
- [ ] Document in inventory
- [ ] Final verification testing

### 9.2 Baseline Verification Script

**Location:** /root/verify-baseline.sh

```bash
#!/bin/bash
# Configuration Baseline Verification Script
# Version 1.0 - November 1, 2025

echo "=== Configuration Baseline Verification ==="
echo "System: $(hostname)"
echo "Date: $(date)"
echo ""

# FIPS Mode
echo "[1] Verifying FIPS mode..."
if [ $(cat /proc/sys/crypto/fips_enabled) -eq 1 ]; then
    echo "    PASS: FIPS mode enabled"
else
    echo "    FAIL: FIPS mode NOT enabled"
fi

# SELinux
echo "[2] Verifying SELinux..."
if [ $(getenforce) = "Enforcing" ]; then
    echo "    PASS: SELinux enforcing"
else
    echo "    FAIL: SELinux not enforcing"
fi

# Auditd
echo "[3] Verifying auditd..."
systemctl is-active --quiet auditd && echo "    PASS: auditd active" || echo "    FAIL: auditd not active"

# Firewalld
echo "[4] Verifying firewalld..."
systemctl is-active --quiet firewalld && echo "    PASS: firewalld active" || echo "    FAIL: firewalld not active"

# Chronyd
echo "[5] Verifying chronyd..."
systemctl is-active --quiet chronyd && echo "    PASS: chronyd active" || echo "    FAIL: chronyd not active"

# OpenSCAP compliance
echo "[6] Running OpenSCAP quick check..."
echo "    (Full scan results in /root/oscap-*.html)"

# Wazuh agent
echo "[7] Verifying Wazuh agent..."
systemctl is-active --quiet wazuh-agent && echo "    PASS: Wazuh agent active" || echo "    FAIL: Wazuh agent not active"

# Check for prohibited services
echo "[8] Checking for prohibited services..."
PROHIBITED="bluetooth cups avahi-daemon telnet"
for svc in $PROHIBITED; do
    systemctl is-active --quiet $svc && echo "    WARN: $svc is active (should be disabled)" || echo "    PASS: $svc disabled"
done

echo ""
echo "=== Verification Complete ==="
```

**Run monthly:**
```bash
sudo bash /root/verify-baseline.sh | tee /root/baseline-check-$(date +%Y%m%d).log
```

---

## 10. EXCEPTIONS AND DEVIATIONS

### 10.1 Approved Exceptions

**Current Exceptions:** None

**Exception Request Process:**
1. Document technical justification
2. Assess security risk
3. Identify compensating controls
4. Obtain System Owner approval
5. Document in this section
6. Review annually

### 10.2 Exception Template

```
Exception ID: EXC-YYYY-MM-DD-###
System: [Hostname]
Configuration Item: [Setting or requirement]
Baseline Requirement: [What baseline requires]
Actual Configuration: [Current setting]

Justification:
[Why deviation is necessary]

Risk Assessment:
Impact: [ ] Low [ ] Medium [ ] High
Likelihood: [ ] Low [ ] Medium [ ] High

Compensating Controls:
[How risk is mitigated]

Approved By: ______________ Date: _______
Review Date: _______________
Status: [ ] Active [ ] Closed
```

---

## 11. CONFIGURATION DOCUMENTATION

### 11.1 Required Documentation

**Maintained Documents:**
- This Configuration Management Baseline
- Change log (all configuration changes)
- System inventory (hardware and software)
- Network diagram
- OpenSCAP scan results (monthly)
- Baseline verification reports (monthly)
- Exception documentation (if any)

**Document Locations:**
- /root/ (system-specific configs)
- ~/Documents/Claude/ (general documentation)
- /var/ossec/etc/ (Wazuh configurations)
- /etc/ipa/ (FreeIPA configurations)

### 11.2 Configuration Backup Schedule

**Daily:**
- Automated backups of /etc/ (via backup script)
- FreeIPA data backup

**Weekly:**
- Full system backup (ReaR ISO)
- Configuration snapshot

**Before Major Changes:**
- Manual configuration backup
- FreeIPA backup

**Retention:**
- Daily: 30 days
- Weekly: 90 days
- Major change backups: 1 year

---

## 12. COMPLIANCE AND REVIEW

### 12.1 Quarterly Review Checklist

- [ ] Verify all systems meet baseline configuration
- [ ] Review OpenSCAP scan results (100% compliance target)
- [ ] Review change log for unauthorized changes
- [ ] Update software inventory
- [ ] Review and close completed exceptions
- [ ] Update baseline for approved changes
- [ ] Verify backup procedures working
- [ ] Test configuration restoration process
- [ ] Document review completion

**Next Review:** February 1, 2026

### 12.2 Baseline Update Process

**When to Update Baseline:**
- New security requirements identified
- Major software version updates
- New systems added to environment
- Significant configuration changes approved
- Annual review cycle

**Update Procedure:**
1. Document proposed changes
2. Assess security impact
3. Test changes in non-production (if possible)
4. Obtain System Owner approval
5. Update baseline document
6. Communicate changes
7. Implement across all applicable systems
8. Verify compliance

---

## APPENDIX A: QUICK REFERENCE COMMANDS

### System Information
```bash
# OS version
cat /etc/rocky-release

# Kernel version
uname -r

# Hostname
hostname -f

# IP address
ip addr show

# FIPS status
fips-mode-setup --check

# SELinux status
sestatus
```

### Security Verification
```bash
# Run full OpenSCAP scan
sudo oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_cui \
  --results ~/oscap-results.xml --report ~/oscap-report.html \
  /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# Check running services
systemctl list-units --type=service --state=running

# Check open ports
sudo ss -tulpn

# Check firewall rules
sudo firewall-cmd --list-all

# Check last logins
last -20

# Check failed login attempts
sudo faillock
```

### Configuration Backup
```bash
# Backup all configuration files
sudo tar -czf ~/config-backup-$(date +%Y%m%d).tar.gz \
  /etc/ipa /etc/ssh /etc/audit /etc/security \
  /var/ossec/etc /etc/sysctl.d /etc/pam.d

# Backup FreeIPA
sudo ipa-backup --data --logs

# Verify backup
tar -tzf ~/config-backup-*.tar.gz | less
```

---

**END OF CONFIGURATION MANAGEMENT BASELINE**
