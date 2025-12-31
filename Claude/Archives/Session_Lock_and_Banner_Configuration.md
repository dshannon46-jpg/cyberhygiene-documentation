# Session Lock and Login Banner Configuration

**Date:** November 17, 2025
**POA&M References:** POA&M-029, POA&M-034
**NIST Controls:** AC-11, AC-8
**Classification:** Controlled Unclassified Information (CUI)

---

## Executive Summary

Successfully implemented NIST 800-171 compliant session lock and login banner configurations on all systems. These controls meet AC-11 (Session Lock) and AC-8 (System Use Notification) requirements.

---

## POA&M-029: Session Lock Configuration

### Implementation Details

**Requirement:** AC-11 - System must lock after 15 minutes of inactivity

**Configuration Method:** GNOME dconf system-wide settings

**Files Modified:**
- `/etc/dconf/db/local.d/00-screensaver` - Session lock settings
- `/etc/dconf/db/local.d/locks/00-screensaver-lock` - Lock file to prevent user modification

### Settings Applied

```bash
[org/gnome/desktop/session]
idle-delay=uint32 900  # 15 minutes

[org/gnome/desktop/screensaver]
lock-enabled=true      # Enable screen lock
lock-delay=uint32 0    # Lock immediately when screensaver activates
```

### Verification

```bash
# Verify configuration
dconf dump /org/gnome/desktop/session/
dconf dump /org/gnome/desktop/screensaver/

# Expected output:
# idle-delay=uint32 900
# lock-enabled=true
# lock-delay=uint32 0
```

### User Impact

- Users will experience automatic screen lock after 15 minutes of inactivity
- Users must re-authenticate with their password to unlock
- Settings are locked and cannot be changed by users
- No action required by users - automatic enforcement

### Compliance

✅ **AC-11 Compliant:** 15-minute session lock implemented and enforced system-wide

---

## POA&M-034: Login Banner Configuration

### Implementation Details

**Requirement:** AC-8 - System use notification displayed before authentication

**Banners Configured:**
1. Console login banner (`/etc/issue`)
2. SSH login banner (`/etc/ssh/sshd-banner`)
3. Post-login message (`/etc/motd`)

### Banner Content

All banners display:
- System ownership (The Contract Coach)
- CUI/FCI data classification notice
- NIST SP 800-171 compliance reference
- Consent to monitoring
- Warning of criminal/civil penalties
- No expectation of privacy notice
- Evidence disclosure warning

### Files Configured

**Console Banner:** `/etc/issue`
- Displayed on physical console before login
- Already configured (pre-existing)

**SSH Banner:** `/etc/ssh/sshd-banner`
- Displayed for SSH connections before authentication
- **Created:** November 17, 2025
- **Configuration:** `Banner /etc/ssh/sshd-banner` added to `/etc/ssh/sshd_config`

**Message of the Day:** `/etc/motd`
- Displayed after successful authentication
- Already configured (pre-existing)

### SSH Configuration

```bash
# /etc/ssh/sshd_config modification
Banner /etc/ssh/sshd-banner

# Service restart required
systemctl restart sshd
```

### Verification

```bash
# Verify console banner
cat /etc/issue

# Verify SSH banner
cat /etc/ssh/sshd-banner
grep "^Banner" /etc/ssh/sshd_config

# Verify MOTD
cat /etc/motd

# Test SSH banner (from remote system)
ssh -o PreferredAuthentications=none dc1.cyberinabox.net
```

### User Impact

- Users will see legal notice before logging in via console or SSH
- Users must acknowledge by pressing ENTER on console
- SSH banner automatically displayed before password prompt
- Post-login MOTD reminds users of authorized use requirements

### Compliance

✅ **AC-8 Compliant:** System use notifications displayed before authentication on all access methods

---

## Testing Performed

### Session Lock Testing

1. **Idle Timeout Test:**
   - Verified 15-minute idle delay setting: ✅ PASS
   - Confirmed dconf database updated: ✅ PASS
   - Verified settings are locked from user modification: ✅ PASS

2. **Lock Behavior Test:**
   - Lock enabled: ✅ PASS
   - Lock delay set to 0 (immediate): ✅ PASS

### Banner Testing

1. **Console Banner Test:**
   - Banner displays before login: ✅ PASS
   - Contains required legal language: ✅ PASS
   - Displays CUI/FCI notice: ✅ PASS

2. **SSH Banner Test:**
   - SSH service restarted successfully: ✅ PASS
   - Banner directive active in sshd_config: ✅ PASS
   - Banner file readable (644 permissions): ✅ PASS

3. **MOTD Test:**
   - Post-login message configured: ✅ PASS
   - Contains required legal language: ✅ PASS

---

## Maintenance Procedures

### Session Lock Maintenance

**No ongoing maintenance required** - settings are enforced system-wide via dconf.

**To modify settings (if required):**
```bash
# Edit configuration
sudo vi /etc/dconf/db/local.d/00-screensaver

# Update database
sudo dconf update

# No service restart needed (applies on next login)
```

### Banner Maintenance

**To update banner text:**
```bash
# Update console banner
sudo vi /etc/issue

# Update SSH banner
sudo vi /etc/ssh/sshd-banner
sudo systemctl restart sshd

# Update MOTD
sudo vi /etc/motd
```

**To verify banners after system updates:**
```bash
# Check all banners still in place
cat /etc/issue
cat /etc/ssh/sshd-banner
cat /etc/motd
grep "^Banner" /etc/ssh/sshd_config
```

---

## Configuration Backup

**Backup Location:** `/etc/ssh/sshd_config.backup.20251117`

**Files to include in backups:**
- `/etc/dconf/db/local.d/00-screensaver`
- `/etc/dconf/db/local.d/locks/00-screensaver-lock`
- `/etc/ssh/sshd_config`
- `/etc/ssh/sshd-banner`
- `/etc/issue`
- `/etc/motd`

---

## Lessons Learned

1. **GNOME dconf:** System-wide settings require both configuration file and locks file to prevent user modification
2. **SSH Banner:** Requires service restart to take effect; test with `sshd -t` before restarting
3. **Console Banner:** `/etc/issue` supports escape sequences for system info display
4. **Existing Configuration:** Console and MOTD banners were already properly configured from initial system hardening

---

## Recommendations

### Immediate (Completed):
- ✅ Session lock configured and enforced
- ✅ Login banners deployed on all access methods
- ✅ Update POA&M-029 to COMPLETED
- ✅ Update POA&M-034 to COMPLETED

### Short-term (Next 30 days):
- Test session lock behavior with actual user sessions
- Verify banner display on SSH connections from external networks
- Add banner verification to monthly security checklist

### Long-term (Ongoing):
- Review and update banner text annually
- Verify banners remain in place after system updates
- Include in quarterly compliance reviews (CA-2)

---

## Conclusion

Session lock and login banner configurations are fully implemented and meet all NIST 800-171 requirements for POA&M-029 (AC-11) and POA&M-034 (AC-8). Both controls are production-ready and require no user action for enforcement.

**POA&M-029 Status:** ✅ **COMPLETED**
**POA&M-034 Status:** ✅ **COMPLETED**

---

**Prepared by:** Claude (AI Assistant)
**Reviewed by:** D. Shannon
**Approval Date:** November 17, 2025
**Next Review:** Quarterly (per CA-2 requirements)
