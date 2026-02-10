# CyberHygiene Phase II Automated Installer

**Version:** 1.0
**Created:** January 1, 2026
**Purpose:** Automated deployment system for CyberHygiene security platform

[![Sponsor](https://img.shields.io/badge/Sponsor-%E2%9D%A4-ff69b4?logo=githubsponsors&logoColor=white)](https://github.com/sponsors/dshannon46-jpg)
---

## Quick Start

### Prerequisites
1. HP Proliant DL 20 Gen10 Plus (or equivalent) server
2. Rocky Linux 9.5 installed with FIPS mode enabled
3. Completed `installation_info.md` form
4. (Optional) SSL certificates for domain

### Installation Steps

```bash
# 1. Navigate to installer directory
cd "/home/admin/Documents/Installer"

# 2. Complete the installation information form
cp installation_info_template.md installation_info.md
nano installation_info.md
# Fill in all fields (replace all ___ placeholders)

# 3. Run the master installation script
sudo ./master_install.sh
```

That's it! The script will guide you through the rest.

---

## What Gets Installed

### Core Services
- **FreeIPA** - Identity management, DNS, Kerberos, Certificate Authority
- **Samba** - File sharing with Kerberos authentication
- **SSL Certificates** - Domain wildcard certificate deployment

### Installation Process
1. System prerequisites check
2. Variable generation from installation form
3. System state backup
4. FreeIPA domain controller installation
5. DNS configuration
6. SSL certificate deployment
7. Samba file sharing setup
8. Final system verification

---

## Directory Structure

```
Installer/
├── master_install.sh           # Main installation script
├── installation_info.md         # Customer data (YOU FILL THIS OUT)
├── installation_info_template.md# Blank template
├── install_vars.sh              # Generated variables (created automatically)
├── CREDENTIALS_*.txt            # Generated passwords (KEEP SECURE!)
├── scripts/                     # Installation modules
│   ├── 00_prerequisites_check.sh
│   ├── 01_generate_variables.sh
│   ├── 02_backup_system.sh
│   ├── 10_install_freeipa.sh
│   ├── 11_configure_dns.sh
│   ├── 12_deploy_ssl_certs.sh
│   ├── 20_install_samba.sh
│   └── 99_final_verification.sh
├── templates/                   # Configuration templates (future use)
├── logs/                        # Installation logs (created automatically)
└── backups/                     # System backups (created automatically)
```

---

## Command Line Options

### Dry Run (Test Mode)
Test the installation without making changes:
```bash
sudo ./master_install.sh --dry-run
```

### Install Specific Service
Install only one service (requires FreeIPA already installed):
```bash
sudo ./master_install.sh --service=samba
```

### Skip Backups
Skip system backup creation (not recommended):
```bash
sudo ./master_install.sh --skip-backups
```

---

## Installation Modules

### Module 00: Prerequisites Check
- Verifies system meets requirements
- Checks FIPS mode, SELinux, disk space, memory
- Validates installation form completion

### Module 01: Generate Variables
- Parses `installation_info.md`
- Creates `install_vars.sh` with all configuration
- Generates secure passwords
- Creates credentials file

### Module 02: Backup System
- Backs up current system state
- Saves package list, configurations
- Creates restore point

### Module 10: Install FreeIPA
- **Most critical component**
- Installs domain controller
- Configures DNS, Kerberos, LDAP, CA
- Creates initial DNS records
- Sets password policies

### Module 11: Configure DNS
- Additional DNS configuration
- Creates service records
- Sets up CNAME records
- Tests resolution

### Module 12: Deploy SSL Certificates
- Installs wildcard SSL certificate
- Options: Customer-provided, FreeIPA CA, Let's Encrypt
- Verifies certificate validity
- Installs to system-wide locations

### Module 20: Install Samba
- File sharing server
- Integrated with FreeIPA Kerberos
- Creates shared directories
- Enables Windows file sharing

### Module 99: Final Verification
- Tests all services
- Verifies DNS, authentication, firewall
- Generates verification report
- Confirms system ready

---

## Important Files Generated

### `install_vars.sh`
Contains all configuration variables extracted from installation form.
**Location:** `/home/admin/Documents/Installer/install_vars.sh`

**Key Variables:**
- `DOMAIN` - Customer domain name
- `REALM` - Kerberos realm
- `BUSINESS_NAME` - Company name
- `SUBNET` - Network subnet
- `DS_PASSWORD` - Directory Server password
- `ADMIN_PASSWORD` - FreeIPA admin password

### `CREDENTIALS_YYYYMMDD.txt`
Contains all generated passwords for the installation.
**⚠️ CRITICAL:** Store this securely! System cannot be recovered without these passwords.

**Contents:**
- FreeIPA Directory Manager password
- FreeIPA Admin password
- GRUB bootloader password
- Backup encryption key
- Server IP addresses
- Access URLs

### Verification Report
Generated after installation completes.
**Location:** `VERIFICATION_REPORT_YYYYMMDD.txt`

**Contains:**
- Test results (passed/failed)
- System information
- Service status
- Any failures detected
- Next steps

---

## Logs

All installation activity is logged to:
- **Main log:** `logs/installation_YYYYMMDD_HHMMSS.log`
- **Per-module logs:** `logs/YYYYMMDD_HHMMSS_[module_name].log`

Check logs if installation fails or you need to troubleshoot.

---

## Troubleshooting

### Installation fails at prerequisites check
**Solution:** Review the specific failure message and resolve before proceeding:
- FIPS mode: Run `fips-mode-setup --enable && reboot`
- Disk space: Free up space or use larger drive
- Missing partitions: Reinstall OS with correct partitioning

### FreeIPA installation fails
**Common causes:**
- Hostname not set correctly (must be FQDN)
- Firewall blocking ports
- Insufficient memory

**Solution:**
```bash
# Check hostname
hostname -f  # Must return FQDN like dc1.domain.com

# Verify firewall
firewall-cmd --list-all

# Check FreeIPA logs
tail -100 /var/log/ipaserver-install.log
```

### DNS not resolving
**Solution:**
```bash
# Test DNS
host dc1.domain.com 192.168.1.10

# Check DNS service
systemctl status named-pkcs11

# Restart if needed
systemctl restart ipa
```

### Can't authenticate
**Solution:**
```bash
# Test Kerberos
kinit admin
# Enter password from CREDENTIALS file

# Check ticket
klist

# If fails, check KDC
systemctl status krb5kdc
```

---

## Post-Installation Steps

### 1. Verify Installation
Review the verification report for any failures.

### 2. Access Web Interface
```
URL: https://dc1.yourdomain.com
Username: admin
Password: [from CREDENTIALS file]
```

### 3. Create User Accounts
```bash
# Authenticate
kinit admin

# Create user
ipa user-add jsmith --first=John --last=Smith --email=jsmith@domain.com

# Set initial password
ipa passwd jsmith
```

### 4. Test File Sharing
From Windows workstation:
```
\\dc1.yourdomain.com\shared
```

### 5. Secure Credentials File
```bash
# Print and store in physical safe
cat CREDENTIALS_*.txt | lpr

# Or copy to encrypted USB
cp CREDENTIALS_*.txt /path/to/encrypted/usb/

# Then delete from server
shred -u CREDENTIALS_*.txt
```

### 6. Schedule Backups
The system creates an initial backup, but you should configure automated backups.

---

## Security Notes

### Protecting Sensitive Files
These files contain sensitive information:
- `install_vars.sh`
- `CREDENTIALS_*.txt`
- `logs/*` (may contain passwords in debug output)

**Recommendations:**
- Set permissions to 600 (owner read/write only)
- Store credentials in password manager (KeePassXC)
- Delete temporary files after securing passwords
- Do not commit to version control

### Firewall
The installer configures firewall rules automatically. To review:
```bash
firewall-cmd --list-all
```

### SELinux
SELinux remains in Enforcing mode for security. If you encounter permission issues:
```bash
# Check for denials
ausearch -m AVC -ts recent

# DO NOT disable SELinux - fix the policy instead
```

---

## Uninstallation

To remove FreeIPA and start over:
```bash
# WARNING: This removes all configuration and data!
ipa-server-install --uninstall
```

To restore from backup:
```bash
# Review backup in backups/pre_install_YYYYMMDD_HHMMSS/
# Manually restore specific files as needed
```

---

## Support

### Log Review
Always check logs first:
```bash
# Main installation log
less logs/installation_*.log

# Specific module
less logs/*_10_install_freeipa.log

# System logs
journalctl -xe
```

### Common Commands
```bash
# FreeIPA status
ipactl status

# Restart all FreeIPA services
ipactl restart

# Test authentication
kinit admin

# View Kerberos tickets
klist

# DNS test
host dc1.domain.com

# Firewall status
firewall-cmd --list-all
```

---

## Development Notes

### Adding New Modules
To add a new installation module:

1. Create script in `scripts/` directory:
   ```bash
   nano scripts/30_install_myservice.sh
   ```

2. Follow the template:
   ```bash
   #!/bin/bash
   set -euo pipefail
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
   source "${SCRIPT_DIR}/install_vars.sh"

   log() {
       echo "[$(date '+%Y-%m-%d %H:%M:%S')] [30-MYSERVICE] $*"
   }

   log "Installing myservice..."
   # Your installation code here
   exit 0
   ```

3. Make executable:
   ```bash
   chmod +x scripts/30_install_myservice.sh
   ```

4. Add to master_install.sh modules array

### Testing
Always test in dry-run mode first:
```bash
sudo ./master_install.sh --dry-run
```

---

## License & Credits

**CyberHygiene Phase II Automated Installer**
Created: January 1, 2026
For: Small business NIST 800-171 compliance

**Open Source Components:**
- FreeIPA
- Samba
- Rocky Linux
- And many others

---

## Version History

**v1.0 - January 1, 2026**
- Initial release
- Core modules: Prerequisites, Variables, Backup, FreeIPA, DNS, SSL, Samba, Verification
- Automated installation framework
- Password generation and management
- Comprehensive logging and error handling

## Support This Project

Your help makes a real difference for small defense contractors facing CMMC/NIST hurdles.

- **In-kind contributions** (our top need): Ansible refactoring for the custom ISO, penetration testing, documentation, or testing on varied hardware → Open an Issue or PR!
- **Financial support**: Help offset development costs (hardware, time, presentation travel) via [GitHub Sponsors ❤️](https://github.com/sponsors/dshannon46-jpg)

Thank you to all current and future sponsors and contributors!---

**For questions or issues, refer to the installation logs and verification report.**
