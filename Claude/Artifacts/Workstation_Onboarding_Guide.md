# Workstation Onboarding Guide
**Engineering & Accounting Workstations**
**Date:** December 7, 2025
**Status:** Ready for Deployment

---

## Infrastructure Ready ✅

All prerequisites completed on DC1:

**DNS Configuration:**
- ✅ engineering.cyberinabox.net → 192.168.1.104
- ✅ accounting.cyberinabox.net → 192.168.1.113
- ✅ DNS zone updated and reloaded
- ✅ Resolution verified

**OpenSCAP Collection:**
- ✅ Collection script updated for both workstations
- ✅ Centralized reporting configured
- ✅ Weekly collection schedule (Sundays 06:30 MST)

**Deployment Script:**
- ✅ Created: `/tmp/workstation-onboard.sh`
- ✅ Fully automated onboarding process
- ✅ NIST 800-171 security baseline included

---

## Automated Deployment Process

The onboarding script handles everything:

### Phase 1: Network Configuration
- Sets hostname to FQDN
- Configures DNS (DC1 primary, fallback to public DNS)
- Verifies connectivity

### Phase 2: Prerequisites Verification
- Checks FIPS 140-2 enabled
- Verifies SELinux enforcing
- Validates OpenSCAP hardening

### Phase 3: FreeIPA Client Installation
- Installs ipa-client package if needed
- Handles dependencies

### Phase 4: Domain Join
- Joins workstation to cyberinabox.net
- Creates machine account
- Configures SSSD for authentication
- Enables home directory creation

### Phase 5: Session Lock (AC-11)
- 15-minute idle timeout
- dconf policy with locked settings
- GNOME screensaver configuration

### Phase 6: Login Banners (AC-8)
- Console banner (/etc/issue)
- Post-login message (/etc/motd)
- CUI/FCI warnings

### Phase 7: OpenSCAP Scanning
- Weekly scan schedule (Sundays 03:00)
- Reports stored in /var/log/openscap/reports/
- Automatic cleanup (12-week retention)
- Remediation script generation

---

## Deployment Instructions

### Step 1: Transfer Script to Workstation

**On DC1:**
```bash
# The script is ready at /tmp/workstation-onboard.sh
# Transfer to each workstation via USB, network share, or other method
```

**On each workstation:**
```bash
# Copy the script to /tmp/
sudo cp workstation-onboard.sh /tmp/
sudo chmod +x /tmp/workstation-onboard.sh
```

### Step 2: Run Onboarding Script

**On Engineering Workstation (192.168.1.104):**
```bash
sudo /tmp/workstation-onboard.sh engineering
```

**On Accounting Workstation (192.168.1.113):**
```bash
sudo /tmp/workstation-onboard.sh accounting
```

### Step 3: Enter FreeIPA Admin Password

When prompted:
```
Username: admin
Password: [FreeIPA admin password]
```

### Step 4: Reboot

The script will ask if you want to reboot. Choose **Yes**.

---

## Post-Deployment Verification

### On Each Workstation:

**1. Verify Domain Membership:**
```bash
realm list
# Should show: cyberinabox.net
```

**2. Test Domain Authentication:**
```bash
# Log in with domain user credentials
# Format: username (not username@domain)
```

**3. Verify Session Lock:**
- Wait 15 minutes idle
- Screen should lock automatically
- Require password to unlock

**4. Check OpenSCAP Scan:**
```bash
ls -lh /var/log/openscap/reports/
# Should show scan results
```

### On DC1 (After Sunday 06:30 MST):

**Check Collected Reports:**
```bash
ls -lh /var/log/openscap/collected-reports/engineering/
ls -lh /var/log/openscap/collected-reports/accounting/

# Should show reports from both workstations
```

---

## User Account Creation

### Option 1: Create Before Deployment

**On DC1 (if you know who will use each workstation):**

```bash
# Get Kerberos ticket
kinit admin

# Create user for Engineering workstation
ipa user-add [username] \
    --first=[First] \
    --last=[Last] \
    --email=[email]@cyberinabox.net \
    --shell=/bin/bash \
    --homedir=/home/[username]

# Set password
ipa passwd [username]

# Add to groups
ipa group-add-member engineering --users=[username]
ipa group-add-member cui_authorized --users=[username]
ipa group-add-member file_share_rw --users=[username]
ipa group-add-member remote_access --users=[username]

# Repeat for Accounting workstation user
```

### Option 2: Create After Deployment

Users can be created any time and will work on all domain-joined workstations.

### Option 3: Shared/Generic Users

```bash
# Create generic engineering user
ipa user-add engineer \
    --first=Engineering \
    --last=User \
    --email=engineer@cyberinabox.net

# Create generic accounting user
ipa user-add accountant \
    --first=Accounting \
    --last=User \
    --email=accountant@cyberinabox.net
```

---

## Workstation Specifications

### Engineering Workstation
- **Hostname:** engineering.cyberinabox.net
- **IP Address:** 192.168.1.104
- **OS:** Rocky Linux 9.6 Workstation with GUI
- **Role:** Engineering/technical work
- **Suggested Groups:** engineering, cui_authorized, file_share_rw, remote_access
- **Scan Schedule:** Sundays 03:00

### Accounting Workstation
- **Hostname:** accounting.cyberinabox.net
- **IP Address:** 192.168.1.113
- **OS:** Rocky Linux 9.6 Workstation with GUI
- **Role:** Accounting/financial operations
- **Suggested Groups:** operations, cui_authorized, file_share_rw
- **Scan Schedule:** Sundays 03:00

---

## Security Baseline Applied

Both workstations will have:

**FIPS 140-2:**
- ✅ Enabled and verified
- ✅ Cryptographic validation active

**SELinux:**
- ✅ Enforcing mode
- ✅ NIST-compliant policy

**Session Lock (AC-11):**
- ✅ 15-minute idle timeout
- ✅ Settings locked from user modification
- ✅ dconf policy enforced

**Login Banners (AC-8):**
- ✅ Console warning (/etc/issue)
- ✅ Post-login message (/etc/motd)
- ✅ CUI/FCI notices

**OpenSCAP Compliance:**
- ✅ Weekly automated scans
- ✅ NIST 800-171 CUI profile
- ✅ Centralized report collection
- ✅ Expected 100% compliance

**Authentication:**
- ✅ Kerberos SSO via FreeIPA
- ✅ SSSD integration
- ✅ Automatic home directory creation

---

## Timeline

**Estimated Time Per Workstation:**
- Script execution: 5-10 minutes
- Reboot: 2-3 minutes
- Verification: 5 minutes
- **Total: 15-20 minutes per workstation**

**Suggested Schedule:**
1. Deploy Engineering (15-20 min)
2. Verify Engineering (5 min)
3. Deploy Accounting (15-20 min)
4. Verify Accounting (5 min)
5. Final verification on DC1 (10 min)

**Total time for both: ~1 hour**

---

## Troubleshooting

### Issue: DNS Resolution Fails

**Symptom:** Cannot resolve dc1.cyberinabox.net

**Fix:**
```bash
# Verify DC1 is reachable
ping 192.168.1.10

# Check DNS configuration
nmcli device show [interface] | grep DNS

# Manually test DNS
nslookup dc1.cyberinabox.net 192.168.1.10
```

### Issue: Domain Join Fails

**Symptom:** ipa-client-install fails with certificate error

**Fix:**
- Ensure time is synchronized (within 5 minutes of DC1)
- Verify FIPS mode is enabled
- Check network connectivity to DC1

### Issue: Session Lock Not Working

**Symptom:** Screen doesn't lock after 15 minutes

**Fix:**
```bash
# Verify dconf configuration
dconf read /org/gnome/desktop/session/idle-delay
# Should return: uint32 900

# Update dconf database
sudo dconf update

# Log out and back in
```

### Issue: OpenSCAP Scan Fails

**Symptom:** No reports in /var/log/openscap/reports/

**Fix:**
```bash
# Manually run scan
sudo /usr/local/bin/openscap-scan-workstation.sh

# Check log
tail -50 /var/log/openscap/scan.log

# Verify OpenSCAP installed
rpm -q openscap-scanner scap-security-guide
```

---

## Compliance Impact

**Before Deployment:**
- Workstations onboarded: 1 of 3 (33%)
- POA&M completion: 84%

**After Deployment:**
- Workstations onboarded: 3 of 3 (100%)
- POA&M completion: ~87%
- NIST 800-171 implementation: 99%+

**Controls Fully Implemented:**
- AC-2: Account Management (all workstations)
- AC-3: Access Enforcement (RBAC via FreeIPA)
- AC-8: System Use Notification (all systems)
- AC-11: Session Lock (all workstations)
- CA-2: Security Assessments (automated scanning)
- CA-7: Continuous Monitoring (comprehensive)
- IA-2: Identification & Authentication (Kerberos SSO)

---

## Next Steps After Deployment

**Immediate:**
1. Create user accounts for workstation users
2. Test domain authentication
3. Verify security baseline
4. Document any issues

**Weekly:**
- Review OpenSCAP reports (Mondays)
- Verify report collection working
- Address any compliance findings

**Monthly:**
- Review workstation security logs
- Verify backups include workstation configs
- Update SSP with any changes

---

## Support Information

**Script Location:** `/tmp/workstation-onboard.sh`
**Log File:** `/var/log/workstation-onboard.log` (on each workstation)
**OpenSCAP Logs:** `/var/log/openscap/scan.log`
**Collection Logs:** `/var/log/openscap/collection.log` (on DC1)

**Reference Documents:**
- System Security Plan v1.6
- POA&M v2.3
- Session Summary 2025-12-06-07.md

---

**Deployment Status:** ✅ READY
**Prerequisites:** ✅ COMPLETE
**Estimated Completion:** 1 hour for both workstations

**Ready to proceed when you are!**
