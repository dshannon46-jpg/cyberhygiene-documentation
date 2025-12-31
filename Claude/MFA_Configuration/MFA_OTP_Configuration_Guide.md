# Multi-Factor Authentication (MFA) Configuration Guide
## FreeIPA OTP Implementation for NIST 800-171 Compliance

**Date:** November 13, 2025
**System:** CyberHygiene Project - cyberinabox.net
**POA&M:** POA&M-004
**NIST Controls:** IA-2(1), IA-2(2)
**Status:** Ready for Implementation

---

## Overview

This guide implements Time-based One-Time Password (TOTP) multi-factor authentication using FreeIPA's built-in OTP capabilities. This satisfies NIST 800-171 requirements for multi-factor authentication.

### What You'll Need

- FreeIPA Web UI access: https://dc1.cyberinabox.net/ipa/ui
- Admin credentials
- Smartphone with authenticator app (Google Authenticator, FreeOTP, Authy, Microsoft Authenticator)
- SSH access to test authentication

---

## Step 1: Enable OTP via FreeIPA Web UI

### Access the Web Interface

1. Open browser: **https://dc1.cyberinabox.net/ipa/ui**
2. Login as **admin**
3. Navigate to **IPA Server** → **Configuration**

### Configure Global OTP Settings

1. In the Configuration tab, scroll to **User options**
2. Look for **Default user authentication types**
3. Current setting should show: `password`
4. Click **Edit** button
5. Add **OTP** to the authentication types
6. Options to configure:
   - **Password + OTP** (both required - most secure)
   - **Password or OTP** (either one works)

**Recommended:** Use "Password + OTP" for maximum security

7. Click **Save**

---

## Step 2: Add OTP Token for Admin User

### Navigate to User

1. In FreeIPA Web UI, go to **Identity** → **Users**
2. Click on **admin** user
3. Go to **Actions** dropdown
4. Select **Add OTP Token**

### Configure Token

1. **Token Type:** TOTP (Time-based One-Time Password)
2. **Description:** Admin's Phone - Google Authenticator
3. **Algorithm:** SHA-256 (FIPS-compatible)
4. **Digits:** 6
5. **Time interval:** 30 seconds

6. Click **Add**

### Scan QR Code

1. FreeIPA will display a QR code
2. Open your authenticator app on your phone:
   - **Google Authenticator** (Android/iOS)
   - **FreeOTP** (Open source, Android/iOS)
   - **Authy** (Android/iOS)
   - **Microsoft Authenticator** (Android/iOS)

3. Scan the QR code with the app
4. The app will start generating 6-digit codes every 30 seconds

5. **IMPORTANT:** Write down the backup codes shown (if any)
6. Click **OK/Close**

---

## Step 3: Test OTP Authentication

### Web UI Login Test

1. **Logout** of FreeIPA Web UI
2. Navigate to: https://dc1.cyberinabox.net/ipa/ui
3. Enter username: **admin**
4. For password, enter: `your_password` + `OTP_code`
   - Example: If your password is "MyPass123" and OTP is "456789"
   - Enter: `MyPass123456789` (concatenated)
5. Click **Log In**

### SSH Login Test

SSH with OTP works differently depending on configuration:

**Method 1: Two-Factor Prompt (Recommended)**
```bash
ssh admin@dc1.cyberinabox.net
# First prompt: Enter password
# Second prompt: Enter OTP code
```

**Method 2: Combined (if configured)**
```bash
ssh admin@dc1.cyberinabox.net
# Password: your_password + OTP_code (concatenated)
```

---

## Step 4: Configure SSH for Proper OTP Support

### Enable Challenge-Response Authentication

On the FreeIPA server (dc1):

```bash
# Edit SSH daemon config
sudo vi /etc/ssh/sshd_config

# Ensure these settings are present:
ChallengeResponseAuthentication yes
AuthenticationMethods keyboard-interactive
UsePAM yes

# Restart SSH
sudo systemctl restart sshd
```

### Configure PAM for OTP

PAM should already be configured by FreeIPA, but verify:

```bash
# Check PAM SSH config
cat /etc/pam.d/sshd | grep -i otp
```

Should include lines referencing `pam_sss.so` which handles OTP.

---

## Step 5: Enroll Additional Users

### Via Web UI

1. Login to FreeIPA Web UI as admin
2. Go to **Identity** → **Users**
3. Select a user
4. **Actions** → **Add OTP Token**
5. Configure token and provide QR code to user

### Self-Service Enrollment

Users can enroll their own tokens:

1. User logs into FreeIPA Web UI
2. Click their name in upper right
3. Select **OTP Tokens**
4. Click **Add**
5. Scan QR code with their authenticator app

### Via Command Line (when SSL issue is resolved)

```bash
# Add OTP token for user
ipa otptoken-add --type=totp --owner=username --desc="User's Phone"

# Show QR code
ipa otptoken-show <token-id> --qrcode=/tmp/qrcode.png

# View token details
ipa otptoken-find --user=username
```

---

## Step 6: Testing and Validation

### Test Checklist

- [ ] Admin can login to Web UI with password + OTP
- [ ] Admin can SSH to dc1 with password + OTP
- [ ] Test user can enroll their own OTP token
- [ ] Failed login attempts are logged in /var/log/secure
- [ ] OTP codes expire after 30 seconds
- [ ] Old OTP codes cannot be reused

### Verification Commands

```bash
# Check authentication logs
sudo tail -f /var/log/secure | grep -i otp

# List all OTP tokens
sudo ldapsearch -Y EXTERNAL -H ldapi://%2Frun%2Fslapd-CYBERINABOX-NET.socket \
    -b "cn=otp,dc=cyberinabox,dc=net" "(objectClass=ipaToken)"

# Check user's authentication type
sudo ldapsearch -Y EXTERNAL -H ldapi://%2Frun%2Fslapd-CYBERINABOX-NET.socket \
    -b "uid=admin,cn=users,cn=accounts,dc=cyberinabox,dc=net" ipauserauthtype
```

---

## Step 7: Policy Configuration

### Set User Authentication Requirements

For users who MUST use MFA:

```bash
# Via Web UI:
# Identity → Users → Select User → Edit
# User authentication types: password, otp

# Via CLI (when SSL is fixed):
ipa user-mod username --user-auth-type=password --user-auth-type=otp
```

### Set Group-Based MFA Requirements

```bash
# Create MFA-required group
ipa group-add mfa_required --desc="Users required to use MFA"

# Add users to group
ipa group-add-member mfa_required --users=admin,user1,user2

# Configure authentication for group members
# (This requires custom HBAC rules - see below)
```

---

## Step 8: Troubleshooting

### Common Issues

**Issue:** "Invalid credentials" when using OTP
**Solution:** Check time synchronization on server and phone
```bash
# Check server time
chronyc sources
timedatectl

# Ensure NTP is syncing
sudo systemctl status chronyd
```

**Issue:** QR code doesn't scan
**Solution:** Manually enter secret key shown in token details

**Issue:** SSH doesn't prompt for OTP
**Solution:** Check SSH and PAM configuration
```bash
# Verify SSSD is running
sudo systemctl status sssd

# Check SSH config
grep -E "ChallengeResponse|AuthenticationMethods" /etc/ssh/sshd_config

# Restart services
sudo systemctl restart sssd
sudo systemctl restart sshd
```

**Issue:** OTP works for Web UI but not SSH
**Solution:** Configure SSH properly for challenge-response auth

### Log Locations

- **Authentication logs:** `/var/log/secure`
- **FreeIPA logs:** `/var/log/httpd/error_log`
- **Directory Server:** `/var/log/dirsrv/slapd-CYBERINABOX-NET/errors`
- **SSSD logs:** `/var/log/sssd/`

---

## Security Considerations

### Token Management

- **Backup Codes:** Generate and securely store backup codes for emergency access
- **Lost Token:** Admin can remove old token and issue new one
- **Token Expiration:** Set tokens to expire and require re-enrollment periodically
- **Token Types:**
  - TOTP (Time-based) - Recommended, works offline
  - HOTP (Counter-based) - Less common, requires server sync

### NIST 800-171 Compliance

This implementation satisfies:

- **IA-2(1):** Multi-factor authentication for network access to privileged accounts
- **IA-2(2):** Multi-factor authentication for network access to non-privileged accounts
- **IA-2(3):** Multi-factor authentication for local access to privileged accounts

### Audit Requirements

Document in System Security Plan:
- OTP token issuance procedures
- User enrollment process
- Token revocation procedures
- Emergency access procedures
- Annual review of MFA users

---

## Command Reference (Post-SSL Fix)

### OTP Token Management

```bash
# List all tokens
ipa otptoken-find

# Add TOTP token
ipa otptoken-add --type=totp --owner=username --desc="Description"

# Add HOTP token
ipa otptoken-add --type=hotp --owner=username --desc="Description"

# Disable token
ipa otptoken-disable <token-id>

# Remove token
ipa otptoken-del <token-id>

# Show token with QR code
ipa otptoken-show <token-id> --qrcode=/tmp/qr.png
```

### User Configuration

```bash
# Set user to require OTP
ipa user-mod username --user-auth-type=password --user-auth-type=otp

# Set user to use password OR OTP (not both)
ipa user-mod username --user-auth-type=password --user-auth-type=otp

# Remove OTP requirement
ipa user-mod username --user-auth-type=password

# Show user auth types
ipa user-show username --all | grep auth
```

### Global OTP Configuration

```bash
# Show OTP config
ipa otpconfig-show

# Modify OTP config
ipa otpconfig-mod --totp-auth-window=10 --totp-sync-window=30

# Show help
ipa otpconfig-mod --help
```

---

## Rollout Plan

### Phase 1: Pilot (Week 1)
- [ ] Configure admin account with OTP
- [ ] Test all authentication methods
- [ ] Document any issues
- [ ] Create user guide

### Phase 2: Admins (Week 2)
- [ ] Enroll all admin users
- [ ] Provide training
- [ ] Monitor for issues
- [ ] Collect feedback

### Phase 3: All Users (Week 3-4)
- [ ] Roll out to remaining users
- [ ] Provide self-service enrollment
- [ ] Monitor authentication logs
- [ ] Update SSP documentation

### Phase 4: Enforcement (Week 5)
- [ ] Make MFA mandatory for all users
- [ ] Remove password-only authentication
- [ ] Final compliance documentation
- [ ] Close POA&M-004

---

## Documentation Updates Required

After MFA implementation, update:

1. **System Security Plan (SSP)**
   - Section: Identification and Authentication (IA)
   - Add OTP implementation details
   - Document token lifecycle

2. **User Guide**
   - Add OTP enrollment procedures
   - Include troubleshooting steps
   - Provide authenticator app recommendations

3. **Incident Response Plan**
   - Add lost/stolen token procedures
   - Emergency access procedures
   - Token revocation process

4. **POA&M**
   - Mark POA&M-004 as COMPLETED
   - Update completion date
   - Add evidence: Screenshots, config exports

---

## Next Steps (Immediate)

1. **Resolve SSL Certificate Issue** for CLI access
2. **Access FreeIPA Web UI** and configure OTP
3. **Enroll admin user** with OTP token
4. **Test authentication** via Web UI and SSH
5. **Document results** and update this guide

---

## Success Criteria

MFA implementation is complete when:

- ✅ Admin user successfully uses OTP for login
- ✅ SSH authentication requires password + OTP
- ✅ Web UI authentication requires password + OTP
- ✅ All users enrolled with OTP tokens
- ✅ Authentication logs show OTP usage
- ✅ POA&M-004 closed with evidence
- ✅ SSP updated with MFA procedures
- ✅ Users trained on OTP usage

---

**Created:** November 13, 2025
**Author:** Claude (AI Assistant)
**Status:** Ready for Implementation
**Next Review:** After successful admin enrollment
