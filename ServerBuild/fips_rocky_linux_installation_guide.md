# FIPS-Enabled Rocky Linux 9 Installation Guide
## CyberHygiene Phase II - NIST SP 800-171 Compliant

**Version:** 1.0
**Date:** 2026-01-01
**Target Hardware:** HP Proliant DL 20 Gen10 Plus (or equivalent)
**Operating System:** Rocky Linux 9.5 (or latest stable)

---

## Table of Contents

1. [Pre-Installation Preparation](#pre-installation-preparation)
2. [BIOS/UEFI Configuration](#biosuefi-configuration)
3. [Boot from Installation Media](#boot-from-installation-media)
4. [Installation Settings](#installation-settings)
5. [Disk Partitioning (NIST 800-171 Compliant)](#disk-partitioning)
6. [Security Profile Selection](#security-profile-selection)
7. [Software Selection](#software-selection)
8. [Network Configuration](#network-configuration)
9. [User Creation](#user-creation)
10. [Begin Installation](#begin-installation)
11. [Post-Installation: FIPS Mode Enablement](#post-installation-fips-mode)
12. [Post-Installation: GRUB Password Setup](#grub-password-setup)
13. [Post-Installation: OpenSCAP Remediation](#openscap-remediation)
14. [Verification](#verification)

---

## Pre-Installation Preparation

### Required Materials

- [ ] Rocky Linux 9.5 DVD ISO (minimal or boot)
- [ ] USB drive (8GB minimum) for bootable media
- [ ] `installation_info.md` form completed
- [ ] Wildcard SSL certificate files (or plan for Let's Encrypt)
- [ ] Network configuration details (IP, subnet, gateway)
- [ ] Server hardware specifications verified

### Create Bootable USB

**On Linux:**
```bash
dd if=Rocky-9.5-x86_64-minimal.iso of=/dev/sdX bs=4M status=progress
sync
```

**On macOS:**
```bash
dd if=Rocky-9.5-x86_64-minimal.iso of=/dev/rdiskX bs=1m
```

**On Windows:**
- Use Rufus or BalenaEtcher

---

## BIOS/UEFI Configuration

### Pre-Installation BIOS Settings

1. **Boot into BIOS/UEFI:**
   - Power on server
   - Press `F9` (HP) or appropriate key for BIOS setup

2. **Configure Boot Mode:**
   - Set boot mode to **UEFI** (required for FIPS)
   - Disable Legacy/CSM mode

3. **Secure Boot:**
   - **Disable Secure Boot** (can be enabled post-installation if desired)
   - Note: FIPS mode doesn't require Secure Boot, but they are compatible

4. **Virtualization:**
   - Enable Intel VT-x or AMD-V (if available)
   - Enable VT-d for IOMMU (optional but recommended)

5. **TPM (Trusted Platform Module):**
   - Enable TPM if available
   - Can be used for disk encryption keys

6. **Save and Exit**

---

## Boot from Installation Media

1. **Insert USB drive** into server

2. **Boot from USB:**
   - Power on and press `F11` (HP) for boot menu
   - Select USB device

3. **Rocky Linux Boot Menu:**
   - Select **"Install Rocky Linux 9"**
   - Wait for installer to load

---

## Installation Settings

### Language and Keyboard

1. **Language Selection:**
   - Select **English (United States)** or preferred language
   - Click **Continue**

2. **Installation Summary Screen:**
   - You'll see a dashboard with multiple configuration options
   - Configure each section as follows

---

## Disk Partitioning

### NIST 800-171 Compliant Partitioning Scheme

**Required:** Separate partitions for specific directories to enforce access controls

1. **Click "Installation Destination"**

2. **Select Disk:**
   - Select the 2TB SSD boot drive
   - Verify disk size and model

3. **Storage Configuration:**
   - Select **"Custom"** storage configuration
   - Click **"Done"**

4. **Partitioning Scheme:**
   - Select **"Standard Partition"** (not LVM - FIPS requirement)
   - Click **"Click here to create them automatically"** then modify

5. **Required Partitions (NIST 800-171 SC-7):**

| Mount Point | Size | Type | Encryption | Notes |
|-------------|------|------|------------|-------|
| `/boot/efi` | 600 MB | EFI System Partition | No | UEFI boot |
| `/boot` | 1 GB | xfs | No | Kernel and initramfs |
| `/` (root) | 100 GB | xfs | **Yes** | System files |
| `/tmp` | 10 GB | xfs | **Yes** | Temporary files (separate for AC-6) |
| `/var` | 50 GB | xfs | **Yes** | Variable data |
| `/var/log` | 50 GB | xfs | **Yes** | Audit logs (separate for AU-4) |
| `/var/log/audit` | 20 GB | xfs | **Yes** | Audit trail (AU-9) |
| `/var/tmp` | 10 GB | xfs | **Yes** | Temp variable files |
| `/home` | 50 GB | xfs | **Yes** | User home directories |
| swap | 16 GB | swap | **Yes** | Memory swap |
| `/datastore` | Remaining (~1.6TB) | xfs | **Yes** | Application data |

6. **Encryption Configuration:**
   - Check **"Encrypt my data"** for each partition (except `/boot/efi` and `/boot`)
   - Set encryption passphrase (minimum 20 characters)
   - **CRITICAL:** Store passphrase securely - system won't boot without it
   - Document in `/root/LUKS_PASSPHRASE.txt` (encrypted separately)

7. **Partition Options:**
   - For `/tmp` and `/var/tmp`: Add mount options
     - `nodev,nosuid,noexec` (NIST 800-171 AC-6)
   - For `/home`: Add mount options
     - `nodev,nosuid` (NIST 800-171 AC-6)

8. **Click "Done"** → **"Accept Changes"**

---

## Security Profile Selection

### OpenSCAP Security Profile

1. **Click "Security Policy"**

2. **Enable Security Profile:**
   - Toggle **"Apply security policy"** to **ON**

3. **Select Profile:**
   - Choose **"DISA STIG for Red Hat Enterprise Linux 9"** (most comprehensive)
   - Alternative: **"CIS Red Hat Enterprise Linux 9 Benchmark"**
   - Note: These profiles implement many NIST 800-171 controls automatically

4. **Review Changes:**
   - Scroll through selected rules
   - Note: Some rules may be modified post-installation

5. **Click "Done"**

**Important:** The security profile will:
- Configure password complexity requirements
- Enable audit logging
- Configure firewall
- Disable unnecessary services
- Set file permissions
- Configure SELinux

---

## Software Selection

### Minimal Install + Required Packages

1. **Click "Software Selection"**

2. **Base Environment:**
   - Select **"Minimal Install"**

3. **Additional Software (Select these):**
   - [ ] Standard
   - [ ] Security Tools
   - [ ] System Tools
   - [ ] Network Servers (if installing services during base install)

4. **Click "Done"**

**Note:** Additional software will be installed post-OS via automation scripts

---

## Network Configuration

### Configure Network Interface

1. **Click "Network & Host Name"**

2. **Set Hostname:**
   - Enter: `dc1.[DOMAIN]` (from installation_info.md)
   - Example: `dc1.acmecorp.com`

3. **Configure Network Interface:**
   - Select interface (usually `eno1` or `enp1s0`)
   - Click **"Configure"**

4. **IPv4 Settings:**
   - Method: **Manual**
   - Address: `[SUBNET].10` (e.g., `192.168.1.10`)
   - Netmask: `255.255.255.0` (or `/24`)
   - Gateway: `[GATEWAY]` (e.g., `192.168.1.1`)
   - DNS servers: `8.8.8.8,8.8.4.4` (temporary - will use local DNS post-FreeIPA)

5. **IPv6 Settings:**
   - Method: **Ignore** (unless specifically required)

6. **General Tab:**
   - Check **"Automatically connect to this network when available"**

7. **Click "Save"** → Toggle interface **ON** → **"Done"**

---

## User Creation

### Root Password

1. **Click "Root Password"**

2. **Set Root Password:**
   - Enter a strong password (minimum 20 characters)
   - Example format: `Correct-Horse-Battery-Staple-2026!`
   - **CRITICAL:** Document in secure location
   - Confirm password

3. **Click "Done"** (may need to click twice if password is simple)

### Create Admin User

1. **Click "User Creation"**

2. **Create Administrative User:**
   - Full name: `System Administrator` or actual admin name
   - Username: `admin` (standard for FreeIPA integration)
   - Password: Strong password (different from root)
   - Check **"Make this user administrator"**
   - Check **"Require a password to use this account"**

3. **Click "Done"**

---

## Time & Date

1. **Click "Time & Date"**

2. **Region:** Select from installation_info.md
   - Example: `Americas → Denver` or `Americas → New_York`

3. **Enable NTP:**
   - Toggle **"Network Time"** to **ON**
   - Will sync to internet NTP initially, then local NTP post-installation

4. **Click "Done"**

---

## Begin Installation

1. **Verify All Settings:**
   - Installation Destination: ✓
   - Network & Host Name: ✓
   - Time & Date: ✓
   - Security Policy: ✓
   - Software Selection: ✓
   - Root Password: ✓
   - User Creation: ✓

2. **Click "Begin Installation"**

3. **Installation Progress:**
   - Rocky Linux will install (15-30 minutes depending on hardware)
   - Installing packages
   - Writing configuration
   - Running post-installation scripts

4. **Reboot:**
   - When complete, click **"Reboot System"**
   - Remove USB installation media

---

## Post-Installation: FIPS Mode Enablement

### Enable FIPS 140-2 Cryptography

**CRITICAL:** FIPS mode must be enabled BEFORE installing any security services

1. **Log in as root** (or admin with sudo)

2. **Check Current FIPS Status:**
```bash
fips-mode-setup --check
# Expected output: FIPS mode is disabled.
```

3. **Enable FIPS Mode:**
```bash
sudo fips-mode-setup --enable
```

**Output:**
```
Setting system policy to FIPS
Note: System-wide crypto policies are applied on application start-up.
It is recommended to restart the system for the change of policies
to fully take place.
FIPS mode will be enabled.
Please reboot the system for the setting to take effect.
```

4. **Reboot System:**
```bash
sudo reboot
```

5. **After Reboot - Verify FIPS Mode:**
```bash
fips-mode-setup --check
```

**Expected Output:**
```
FIPS mode is enabled.
```

6. **Verify Kernel Boot Parameters:**
```bash
cat /proc/cmdline | grep fips
```

**Expected:** Should contain `fips=1`

7. **Verify Crypto Policy:**
```bash
update-crypto-policies --show
```

**Expected Output:**
```
FIPS
```

**⚠️ IMPORTANT:** Do NOT disable FIPS mode after enabling - it will break cryptographic keys

---

## Post-Installation: GRUB Password Setup

### Set Bootloader Password (NIST 800-171 AC-3)

**Purpose:** Prevent unauthorized modification of boot parameters

1. **Generate Password Hash:**
```bash
grub2-setpassword
```

2. **Enter Password:**
   - Enter a strong password (different from root password)
   - Confirm password
   - **Document this password** - required to edit GRUB at boot

3. **Verify Password File Created:**
```bash
cat /boot/grub2/user.cfg
```

**Output:**
```
GRUB2_PASSWORD=grub.pbkdf2.sha512.[hash]
```

4. **Test (OPTIONAL - requires reboot):**
   - Reboot system
   - At GRUB menu, press `e` to edit
   - Should prompt for username (`root`) and password

---

## Post-Installation: OpenSCAP Remediation

### Run Security Remediation

**Purpose:** Ensure all NIST 800-171 controls are properly configured

1. **Install OpenSCAP Tools:**
```bash
sudo dnf install -y openscap-scanner scap-security-guide
```

2. **Run Compliance Scan (Before Remediation):**
```bash
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_stig \
  --results /root/oscap-scan-pre.xml \
  --report /root/oscap-report-pre.html \
  /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

3. **Review Findings:**
```bash
# View report in browser or check summary
grep "fail" /root/oscap-scan-pre.xml | wc -l
# Note the number of failed controls
```

4. **Run Automated Remediation:**
```bash
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_stig \
  --remediate \
  --results /root/oscap-remediation.xml \
  --report /root/oscap-remediation.html \
  /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

**⚠️ WARNING:** This will make system-wide changes. Review the report before proceeding.

5. **Reboot After Remediation:**
```bash
sudo reboot
```

6. **Re-scan for Compliance:**
```bash
sudo oscap xccdf eval \
  --profile xccdf_org.ssgproject.content_profile_stig \
  --results /root/oscap-scan-post.xml \
  --report /root/oscap-report-post.html \
  /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

7. **Compare Results:**
```bash
# Count failures
grep "fail" /root/oscap-scan-post.xml | wc -l
# Should be significantly reduced
```

8. **Review Remaining Failures:**
   - Open `/root/oscap-report-post.html` in browser
   - Review failed controls
   - Document in POA&M if manual remediation required

---

## Verification

### Post-Installation Checklist

#### System Configuration
- [ ] FIPS mode enabled and verified
- [ ] GRUB password set
- [ ] Disk encryption active (LUKS)
- [ ] All partitions mounted correctly
- [ ] SELinux enabled (Enforcing mode)
- [ ] Firewall active (firewalld)

#### Network Configuration
- [ ] Static IP assigned
- [ ] Hostname set correctly
- [ ] DNS resolution working
- [ ] Internet connectivity verified
- [ ] NTP synchronized

#### Security Configuration
- [ ] OpenSCAP scan passed (or failures documented)
- [ ] Audit logging enabled (auditd)
- [ ] Password complexity enforced
- [ ] Account lockout configured
- [ ] Unnecessary services disabled

#### Verification Commands

**1. FIPS Mode:**
```bash
fips-mode-setup --check
# Expected: FIPS mode is enabled.
```

**2. Encryption:**
```bash
lsblk -f
# Should show crypto_LUKS for encrypted partitions
```

**3. SELinux:**
```bash
getenforce
# Expected: Enforcing
```

**4. Firewall:**
```bash
sudo firewall-cmd --state
# Expected: running
```

**5. Audit Daemon:**
```bash
sudo systemctl status auditd
# Expected: active (running)
```

**6. Partitions:**
```bash
df -h
mount | grep -E '/(tmp|var|home)'
# Verify all partitions present and mounted with correct options
```

**7. Network:**
```bash
ip addr show
ip route show
ping -c 3 8.8.8.8
```

**8. Hostname:**
```bash
hostnamectl
# Expected: Static hostname: dc1.[DOMAIN]
```

**9. Security Updates:**
```bash
sudo dnf update -y
sudo dnf install -y yum-utils
sudo needs-restarting -r
# If reboot needed, reboot now
```

---

## Next Steps After Base Installation

1. **Document Installation:**
   - Save all OpenSCAP reports
   - Document LUKS passphrase (encrypted)
   - Document GRUB password
   - Document root and admin passwords

2. **Create System Snapshot/Backup:**
   - Before installing services, create backup
   - Allows rollback if service installation fails

3. **Proceed to Service Installation:**
   - Run Phase II master installation script
   - Install FreeIPA (Domain Controller)
   - Install remaining services per CyberHygiene blueprint

4. **Configure Monitoring:**
   - Install and configure Wazuh agent
   - Install and configure node_exporter for Prometheus
   - Configure rsyslog for Graylog

---

## Troubleshooting

### Common Issues

**Issue 1: FIPS Mode Won't Enable**
- **Cause:** System not using UEFI boot
- **Solution:** Reinstall using UEFI mode (not Legacy/CSM)

**Issue 2: Disk Encryption Passphrase Lost**
- **Cause:** Passphrase forgotten or lost
- **Solution:** System is unrecoverable - must reinstall
- **Prevention:** Document passphrase in multiple secure locations

**Issue 3: OpenSCAP Remediation Breaks System**
- **Cause:** Aggressive remediation of certain controls
- **Solution:** Restore from snapshot or selectively remediate
- **Prevention:** Review remediation script before running

**Issue 4: Network Not Working After FIPS Enable**
- **Cause:** Network Manager using non-FIPS crypto
- **Solution:** Restart NetworkManager: `sudo systemctl restart NetworkManager`

**Issue 5: GRUB Password Forgotten**
- **Cause:** GRUB password lost, can't edit boot params
- **Solution:** Boot from installation media, chroot, remove `/boot/grub2/user.cfg`
- **Prevention:** Document password securely

---

## Reference Information

### NIST 800-171 Controls Addressed by This Installation

| Control | Description | Implementation |
|---------|-------------|----------------|
| AC-3 | Access Enforcement | GRUB password, SELinux |
| AC-6 | Least Privilege | Separate partitions with mount options |
| AU-4 | Audit Storage Capacity | Dedicated `/var/log/audit` partition |
| AU-9 | Protection of Audit Information | Encrypted audit partition |
| SC-7 | Boundary Protection | Separate partitions, firewall |
| SC-13 | Cryptographic Protection | FIPS 140-2 mode, LUKS encryption |
| SC-28 | Protection of Information at Rest | Full disk encryption |
| SI-7 | Software Integrity | OpenSCAP, SELinux |

### Useful Commands Reference

```bash
# FIPS Status
fips-mode-setup --check

# Encryption Status
cryptsetup status /dev/mapper/luks-*

# SELinux Status
sestatus

# Audit Logs
ausearch -m AVC -ts recent

# Security Updates
dnf check-update --security

# OpenSCAP Scan
oscap xccdf eval --profile stig /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# Firewall Status
firewall-cmd --list-all
```

---

## Additional Resources

- Rocky Linux Documentation: https://docs.rockylinux.org/
- NIST SP 800-171: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final
- OpenSCAP User Manual: https://www.open-scap.org/resources/documentation/
- DISA STIGs: https://public.cyber.mil/stigs/

---

**Document Version:** 1.0
**Last Updated:** 2026-01-01
**Author:** CyberHygiene Phase II Project
**File Location:** `/home/admin/Documents/Installer/fips_rocky_linux_installation_guide.md`
