# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains documentation and configuration for a **NIST 800-171 compliant FreeIPA Domain Controller** running on Rocky Linux 9.6. The system is designed for small businesses (<15 users) handling Controlled Unclassified Information (CUI) and Federal Contract Information (FCI) under government contracts subject to FAR 52.204-21.

**Target Environment:**
- Domain: `cyberinabox.net`
- Primary Server: HP MicroServer Gen 10+ (`dc1.cyberinabox.net`, 192.168.1.10)
- Operating System: Rocky Linux 9.6 with FIPS mode enabled
- Network: pfSense (Netgate 2100) at 192.168.1.1 handling DNS/DHCP

## System Architecture

### Core Components

1. **FreeIPA Domain Controller** (dc1.cyberinabox.net)
   - LDAP directory services (389 Directory Server)
   - Kerberos authentication (MIT Kerberos)
   - Integrated CA for certificate management
   - User/group management and RBAC
   - Password policy enforcement for NIST compliance

2. **Samba File Server** (on same host)
   - RAID 5 array (3x 3TB HDDs) mounted at `/srv/samba`
   - LUKS encrypted file shares
   - Integrated with FreeIPA for authentication
   - VFS audit module for file access logging

3. **Email Server** (Postfix/Dovecot - planned)
   - SASL authentication via FreeIPA
   - TLS encryption enforced
   - SPF, DKIM, DMARC implementation

4. **Network Security**
   - pfSense firewall with Suricata IDS/IPS
   - VPN for remote access (OpenVPN/WireGuard)
   - Network segmentation via VLANs

### Storage Configuration

**Boot Drive:** 2TB SSD with security-hardened partitioning:
- `/boot/efi`: 1 GB (unencrypted)
- `/boot`: 8 GB (unencrypted)
- `/`: 96 GB (unencrypted)
- `/home`, `/var`, `/var/log`, `/var/log/audit`, `/tmp`, `/data`, `/backup`: LUKS encrypted

**RAID Array:** 3x 3TB HDDs in RAID 5:
- LUKS encrypted (`/dev/mapper/samba_data`)
- Mounted at `/srv/samba`
- Filesystem: XFS or ext4 with ACL support

## FIPS Mode and Security Hardening

**This system MUST operate in FIPS 140-2 mode at all times.**

### Verify FIPS Mode
```bash
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled  # Must return 1
cat /proc/cmdline | grep fips      # Must show fips=1
```

### Enable FIPS Mode (if needed)
```bash
sudo fips-mode-setup --enable
# Edit /etc/default/grub and add fips=1 to GRUB_CMDLINE_LINUX
sudo grub2-mkconfig -o /boot/efi/EFI/rocky/grub.cfg
sudo reboot
```

### Security Hardening
- Apply OpenSCAP CUI profile: `xccdf_org.ssgproject.content_profile_cui`
- SELinux must be in enforcing mode
- All partitions containing CUI/FCI data must be LUKS encrypted
- Automated security updates enabled via `dnf-automatic`

## FreeIPA Management

### Common Commands

**Get Kerberos Ticket:**
```bash
kinit admin
klist  # Verify ticket
```

**User Management:**
```bash
# Create user
ipa user-add jdoe --first=John --last=Doe \
    --email=jdoe@cyberinabox.net \
    --shell=/bin/bash --homedir=/home/jdoe

# Set/reset password
ipa passwd jdoe

# Show user details
ipa user-show jdoe

# Disable account
ipa user-disable jdoe
```

**Group Management:**
```bash
# Create group
ipa group-add developers --desc="Development Team"

# Add user to group
ipa group-add-member developers --users=jdoe

# Show group
ipa group-show developers
```

**Service Management:**
```bash
# Check all FreeIPA services
sudo ipactl status

# Restart all services
sudo ipactl restart

# Stop/start individual services
sudo ipactl stop
sudo ipactl start
```

### Password Policy (NIST 800-171 Compliant)

Current policy enforces:
- Minimum 14 characters
- 3 character classes (upper, lower, number, special)
- 90-day expiration
- 24 password history
- 5 failed attempts = 30-minute lockout

```bash
# View current policy
ipa pwpolicy-show

# Modify policy
ipa pwpolicy-mod --minlength=14 --minclasses=3 --maxlife=90 \
    --minlife=1 --history=24 --maxfail=5 \
    --failinterval=900 --lockouttime=1800
```

## User Role Structure

**Organizational Roles:**
- `executives`: Senior leadership (CEO, etc.)
- `management`: Department managers
- `engineering`: Engineering staff
- `operations`: Operations specialists
- `developers`: Software development team
- `contractors`: External consultants (limited access)

**Access Control Groups:**
- `admins`: Full administrative access (members of sudorule: admins_all)
- `security_team`: Security operations
- `backup_operators`: Backup management (sudorule: backup_ops)
- `cui_authorized`: Authorized to access CUI data
- `fci_authorized`: Authorized to access FCI data
- `remote_access`: VPN access permitted
- `vpn_users`: VPN authentication group

**File Share Access:**
- `file_share_rw`: Read/write access to shared files
- `file_share_ro`: Read-only access to shared files

## RAID Array Management

### Check RAID Status
```bash
sudo mdadm --detail /dev/md0
cat /proc/mdstat
```

### Monitor RAID Health
```bash
# Check for failed drives
sudo mdadm --detail /dev/md0 | grep -i state

# Verify encrypted volume
sudo cryptsetup status samba_data
```

### Unlock Encrypted RAID (if manual unlock required)
```bash
sudo cryptsetup luksOpen /dev/md0 samba_data
sudo mount /dev/mapper/samba_data /srv/samba
```

## Backup Procedures

**Backup Architecture:**
1. Workstation to Server: Daily incremental backups via Samba
2. Server to USB: Weekly full backups to external USB drive
3. Offsite Rotation: Monthly USB drive rotation to secure offsite location

**Critical Backups:**
- FreeIPA configuration: `/etc/ipa/`, `/etc/dirsrv/`, `/etc/krb5.conf`
- CA certificate: `/root/cacert.p12` (use Directory Manager password)
- RAID configuration: `/etc/mdadm.conf`
- LUKS headers and keys: `/root/samba-luks.key`

**FreeIPA Backup:**
```bash
# Full backup
sudo ipa-backup

# Restore from backup
sudo ipa-restore /var/lib/ipa/backup/ipa-full-YYYY-MM-DD-HH-MM-SS
```

## Audit and Logging

**Key Log Locations:**
- LDAP access: `/var/log/dirsrv/slapd-CYBERINABOX-NET/access`
- LDAP errors: `/var/log/dirsrv/slapd-CYBERINABOX-NET/errors`
- Kerberos auth: `/var/log/krb5kdc.log`
- Web interface: `/var/log/httpd/error_log`
- System audit: `/var/log/audit/audit.log`

**Audit Requirements:**
- Minimum 30 days of audit logs retained
- Weekly manual review of security logs
- Automated alerts at 75% log partition capacity

## Network Configuration

**Static IP Configuration:**
- IP: 192.168.1.10/24
- Gateway: 192.168.1.1 (pfSense)
- DNS: 192.168.1.1 (pfSense handles DNS)
- Hostname: `dc1.cyberinabox.net`

**Required Firewall Ports:**
- TCP: 80, 443 (HTTP/HTTPS)
- TCP: 389, 636 (LDAP/LDAPS)
- TCP/UDP: 88, 464 (Kerberos)
- UDP: 123 (NTP)
- TCP/UDP: 514 (Syslog - centralized logging)

**DNS Records Required on pfSense:**
```
dc1.cyberinabox.net        A      192.168.1.10
ipa.cyberinabox.net        A      192.168.1.10
10.1.168.192.in-addr.arpa  PTR    dc1.cyberinabox.net
```

**Required SRV Records:**
```
_kerberos._tcp.cyberinabox.net          SRV  0 100 88  dc1.cyberinabox.net
_kerberos._udp.cyberinabox.net          SRV  0 100 88  dc1.cyberinabox.net
_kerberos-master._tcp.cyberinabox.net   SRV  0 100 88  dc1.cyberinabox.net
_kerberos-master._udp.cyberinabox.net   SRV  0 100 88  dc1.cyberinabox.net
_kpasswd._tcp.cyberinabox.net           SRV  0 100 464 dc1.cyberinabox.net
_kpasswd._udp.cyberinabox.net           SRV  0 100 464 dc1.cyberinabox.net
_ldap._tcp.cyberinabox.net              SRV  0 100 389 dc1.cyberinabox.net
```

## Compliance Requirements (NIST 800-171)

This system must maintain compliance with:
- **AC-2:** Account Management (FreeIPA)
- **AC-3:** Access Enforcement (RBAC, SELinux)
- **AC-7:** Unsuccessful Logon Attempts (5 failed = lockout)
- **AC-17:** Remote Access (VPN with MFA)
- **AU-2/AU-3:** Audit Events (auditd, centralized logging)
- **IA-2:** Identification and Authentication (Kerberos)
- **IA-5:** Authenticator Management (password policies)
- **SC-8:** Transmission Confidentiality (TLS, VPN)
- **SC-13:** Cryptographic Protection (FIPS 140-2)
- **SC-28:** Protection of Information at Rest (LUKS encryption)
- **SI-2:** Flaw Remediation (automated security updates)
- **SI-3:** Malicious Code Protection (ClamAV)
- **SI-4:** System Monitoring (Suricata IDS/IPS)

### OpenSCAP Compliance Scanning
```bash
# Run compliance scan
sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --results /root/oscap-results-$(date +%Y%m%d).xml \
    --report /root/oscap-report-$(date +%Y%m%d).html \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# Generate remediation script
sudo oscap xccdf generate fix \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --output /root/remediation.sh \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

## Troubleshooting

### Web Form Login Not Working (ipa-pwd-extop Bug)

**Issue:** Web interface form-based login fails with "Password incorrect" despite correct password.

**Root Cause:** Known bug in FreeIPA 4.12.2 - ipa-pwd-extop plugin fails to synchronize passwords between Kerberos and LDAP.

**Symptoms:**
- `kinit admin` works correctly with password
- IPA CLI commands work after kinit
- Web form login fails: "401 Unauthorized: kinit: Password incorrect"
- Error in logs: Password sync between Kerberos and LDAP failed

**Workaround - Use Kerberos Authentication:**
```bash
# Get Kerberos ticket first
kinit admin
# Enter password: TestPass2025!

# Then access web interface at:
# https://dc1.cyberinabox.net
# Browser will use SPNEGO/Negotiate authentication
```

**Workaround - Use IPA CLI Instead:**
```bash
# Get Kerberos ticket
kinit admin

# Perform administrative tasks via CLI
ipa user-show admin
ipa user-add username --first=First --last=Last
ipa group-add groupname
```

**Status:** Known bug, no permanent fix available in FreeIPA 4.12.2. Consider upgrading to newer version when available.

### FreeIPA Services Won't Start
```bash
# Check disk space
df -h

# Check SELinux denials
sudo ausearch -m avc -ts recent
sudo sealert -a /var/log/audit/audit.log

# Check logs
sudo journalctl -xe -u ipa
sudo tail -f /var/log/ipaserver-install.log
```

### Kerberos Ticket Issues
```bash
# Check time synchronization (must be within 5 minutes)
chronyc sources
chronyc tracking

# Destroy old ticket and get new one
kdestroy
kinit admin
```

### RAID Array Not Assembling
```bash
# Manually assemble
sudo mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1

# Check mdadm.conf
cat /etc/mdadm.conf

# Regenerate configuration
sudo mdadm --detail --scan | sudo tee /etc/mdadm.conf
sudo dracut -f
```

### Forgotten Admin Password
```bash
# Reset using Directory Manager password
sudo ldappasswd -H ldapi://%2frun%2fslapd-CYBERINABOX-NET.socket \
    -D "cn=Directory Manager" -W \
    "uid=admin,cn=users,cn=accounts,dc=cyberinabox,dc=net"
```

## Development Workflow

When modifying this infrastructure:

1. **Always verify FIPS mode** before and after changes
2. **Test changes in non-production** environment first
3. **Document all configuration changes** in this repository
4. **Run OpenSCAP scans** after system modifications
5. **Backup critical files** before making changes
6. **Never disable SELinux** - fix denials with proper policies
7. **Maintain audit logs** for all administrative actions

## Important Security Notes

- **Directory Manager Password:** `8Bu_K_%;Nn{UU4VoN,@(BMb5Rb8R>zrVQ}^Zhj?_2` (Set: 2025-12-10)
  - Required for CA cert operations, LDAP administrative tasks
  - Cannot be easily reset - backup securely
- **IPA Admin Password:** `TestPass2025!` (Set: 2025-12-10)
  - ⚠️ **KNOWN ISSUE:** Web form login broken due to ipa-pwd-extop bug in FreeIPA 4.12.2
  - ✅ Kerberos authentication working: Use `kinit admin`
  - ✅ IPA CLI tools working after kinit
  - Workaround: Use SPNEGO/Negotiate authentication for web access
- **LUKS Passphrases:** If lost, data is unrecoverable - maintain secure backups
- **CA Certificate:** `/root/cacert.p12` must be backed up to secure offline location
- **Commercial SSL Certificate:** Installed 2025-12-10
  - Certificate: SSL.com wildcard (*.cyberinabox.net)
  - Expires: October 28, 2026
  - Location: `/home/dshannon/Documents/Claude/SSL_Certificate_Reference/`
- **No Shared Accounts:** Every user must have unique credentials
- **Contractor Access:** Review monthly, limited to file_share_ro group
- **Password Changes:** Cannot be changed more than once per day (minlife=1)

## Client Integration

### Join Rocky Linux Workstation to Domain
```bash
sudo dnf install ipa-client -y
sudo ipa-client-install \
    --domain=cyberinabox.net \
    --realm=CYBERINABOX.NET \
    --server=dc1.cyberinabox.net \
    --mkhomedir
```

### Test Client Authentication
```bash
# Test Kerberos
kinit username@CYBERINABOX.NET
klist

# Test SSH with Kerberos
ssh username@dc1.cyberinabox.net
```

## Maintenance Schedule

**Daily:**
- Review IDS/IPS alerts
- Monitor system logs
- Verify backup completion

**Weekly:**
- Review user access logs
- Full server backup to USB

**Monthly:**
- Apply security patches
- User account review
- Rotate offsite backup media

**Quarterly:**
- OpenSCAP compliance scan
- Disaster recovery testing

**Annually:**
- Security assessment/audit
- System Security Plan review
- Penetration testing
