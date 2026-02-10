# Chapter 8: Multi-Factor Authentication (MFA)

## 8.1 MFA Overview

### What is Multi-Factor Authentication?

**Multi-Factor Authentication (MFA)** requires two or more verification methods to prove your identity:

1. **Something you know:** Password
2. **Something you have:** OTP token (phone app)
3. **Something you are:** Biometric (future enhancement)

**Benefits:**
- ✅ Protects against password theft
- ✅ Prevents unauthorized access even if password is compromised
- ✅ Required for NIST 800-171 compliance
- ✅ Industry best practice

### When MFA is Required

**Mandatory MFA:**
- ✅ **Privileged user accounts** (administrators, operators)
- ✅ **Remote access** (SSH from external networks)
- ✅ **VPN connections** (when deployed)
- ✅ **Sensitive data access** (compliance dashboards, security tools)

**Optional MFA:**
- Standard user accounts (recommended but not required)
- Internal network access (can be enabled on request)

**MFA Exemptions:**
- Service accounts (use long random passwords + IP restrictions)
- Emergency break-glass account (physical access required)

### MFA Methods Supported

**1. Time-Based One-Time Password (TOTP)**
- Uses authenticator app on smartphone
- Generates 6-digit code every 30 seconds
- Works offline (no internet needed)
- **Primary method** for CyberHygiene network

**Supported Authenticator Apps:**
- Google Authenticator (Android, iOS)
- Microsoft Authenticator (Android, iOS)
- FreeOTP (Android, iOS) - Open source
- Authy (Android, iOS, desktop)
- 1Password (with TOTP feature)

**2. Backup Codes (Emergency)**
- One-time use codes
- Printed or stored securely
- Used when phone is unavailable
- **10 codes generated** at MFA setup

## 8.2 OTP Token Setup

### Initial MFA Enrollment

**Who Enrolls:**
- All privileged users (mandatory)
- Standard users (optional, on request)

**Enrollment Process:**

#### Step 1: Access FreeIPA

1. Navigate to https://dc1.cyberinabox.net
2. Login with username and password
3. You'll see: "MFA is required for your account. Please enroll now."

#### Step 2: Choose Authenticator App

**Download an authenticator app if you don't have one:**

**Recommended: FreeOTP (Open Source)**
- Android: https://play.google.com/store/apps/details?id=org.fedorahosted.freeotp
- iOS: https://apps.apple.com/us/app/freeotp-authenticator/id872559395

**Alternative: Google Authenticator**
- Android: https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2
- iOS: https://apps.apple.com/us/app/google-authenticator/id388497605

#### Step 3: Scan QR Code

1. Click "Set up Multi-Factor Authentication"
2. QR code is displayed
3. Open your authenticator app
4. Tap "Add account" or "+" button
5. Select "Scan QR code"
6. Point camera at QR code on screen
7. App adds account: "CyberHygiene (your_username)"

**If QR Code Doesn't Work:**
1. Click "Can't scan QR code?"
2. Copy the secret key (long string of letters/numbers)
3. In authenticator app, select "Manual entry"
4. Enter:
   - Account name: `CyberHygiene`
   - Your name: `your_username`
   - Secret key: [paste the key]
   - Time-based: Yes
   - Digits: 6
5. Save

#### Step 4: Verify Setup

1. Authenticator app now shows 6-digit code for CyberHygiene
2. Code changes every 30 seconds
3. Enter current code in FreeIPA
4. Click "Verify"
5. Success message: "MFA enrollment complete!"

#### Step 5: Save Backup Codes

1. After verification, 10 backup codes are displayed
2. **CRITICAL:** Save these codes securely
   - Print and store in safe location
   - Save to password manager
   - Write down and lock in drawer
3. Each code can be used **once**
4. Use backup codes if phone is lost/unavailable
5. Click "I have saved my backup codes"

**Example Backup Codes:**
```
1. 4829-3741
2. 7264-8192
3. 1847-5923
4. 9384-1627
5. 5719-4836
6. 2946-8173
7. 8164-2937
8. 3752-9481
9. 6285-3741
10. 9472-1638
```

### MFA Enrollment Complete

✅ Your account is now protected with MFA
✅ Next login will require password + OTP code
✅ Backup codes saved for emergencies

## 8.3 Using MFA

### Logging In with MFA

#### SSH Login with MFA

```bash
# SSH to server
ssh username@dc1.cyberinabox.net

# You are prompted for:
Password: [enter your password]

# Then prompted for OTP:
Verification code: [enter 6-digit code from app]

# You are logged in
```

**Important:**
- Enter password first
- Then check authenticator app for current code
- Code is valid for 30 seconds
- If code expires while typing, wait for next code

#### Web Login with MFA

1. Navigate to web service (e.g., https://wazuh.cyberinabox.net)
2. Enter username and password
3. Click "Sign In"
4. MFA prompt appears
5. Open authenticator app
6. Enter current 6-digit code
7. Click "Verify"
8. You are logged in

### OTP Code Timing

**Understanding the Timer:**
- OTP codes expire every 30 seconds
- Most apps show a countdown timer or progress bar
- Wait for new code if timer is almost expired (< 5 seconds)
- Codes are synchronized with server time

**If Code is Rejected:**
1. **Wait for next code:** Current code may have just expired
2. **Check time sync:** Ensure phone time is accurate
   - Settings → Date & Time → Set automatically
3. **Try again:** Server allows small time drift (±1 code window)
4. **Use backup code:** If repeated failures

## 8.4 Backup Codes

### When to Use Backup Codes

**Use a backup code when:**
- 📱 Phone is lost or stolen
- 🔋 Phone battery is dead
- 🌐 Authenticator app was uninstalled
- 📲 New phone, haven't transferred authenticator
- 🔄 Authenticator app not working

### Using a Backup Code

**SSH Login:**
```bash
ssh username@dc1.cyberinabox.net
Password: [enter your password]
Verification code: [enter one backup code: 4829-3741]

# You are logged in
# That backup code is now INVALID (one-time use)
```

**Web Login:**
1. Enter username and password
2. Click "Sign In"
3. MFA prompt: "Enter verification code"
4. Click "Use backup code"
5. Enter one backup code
6. Click "Verify"
7. You are logged in

**After Using Backup Code:**
- That code is consumed (cannot be reused)
- Remaining backup codes still valid
- Generate new backup codes when you have <3 left

### Regenerating Backup Codes

**When to Regenerate:**
- Used several backup codes
- Less than 3 codes remaining
- Codes were compromised or lost
- Annual security refresh

**How to Regenerate:**

1. Login to https://dc1.cyberinabox.net
2. Navigate to Identity → Users → [Your username]
3. Click "Actions" → "Reset MFA Backup Codes"
4. Confirm: "This will invalidate all existing backup codes"
5. New 10 backup codes are generated
6. **Save them securely** (print or password manager)
7. Old codes are now invalid

## 8.5 Troubleshooting MFA

### Common Issues and Solutions

#### Issue 1: "Invalid verification code"

**Possible Causes:**
- Code expired while typing
- Phone time not synchronized
- Typing error

**Solutions:**
1. Wait for next code (30 seconds)
2. Check phone time settings:
   - Settings → Date & Time
   - Enable "Set automatically"
3. Try again carefully
4. Use backup code if persistent

#### Issue 2: "Too many failed attempts - account locked"

**Cause:** More than 5 failed OTP attempts

**Solution:**
```bash
# Contact administrator to unlock
# Or wait 30 minutes for automatic unlock
```

**Administrator Unlock:**
```bash
sudo faillock --user username --reset
```

#### Issue 3: Lost Phone / Uninstalled App

**Immediate Action:**
1. Use backup code to login
2. Login to FreeIPA
3. Reset MFA:
   - Navigate to your user account
   - Click "Actions" → "Reset MFA"
   - Re-enroll with new phone/app

**If No Backup Codes:**
1. Contact System Administrator
2. Verify identity (in person or video call)
3. Administrator resets your MFA
4. Re-enroll immediately

#### Issue 4: New Phone - Need to Transfer

**Option A: Manual Re-enrollment**
1. Use backup code to login
2. Login to FreeIPA
3. Reset MFA and re-enroll on new phone

**Option B: Authenticator App Transfer** (if supported)
- Some apps (Authy, 1Password) support cloud sync
- Follow app's transfer instructions
- Test login after transfer

#### Issue 5: Time Sync Issues

**Symptoms:**
- OTP codes consistently rejected
- Works sometimes, fails other times

**Solution:**

**Android:**
1. Open Google Authenticator
2. Menu → Settings → Time correction for codes
3. Tap "Sync now"

**iOS:**
1. Settings → General → Date & Time
2. Enable "Set Automatically"
3. Restart authenticator app

**All Platforms:**
- Ensure phone has correct timezone
- Check server time is accurate: `date` command
- Contact administrator if server time is wrong

#### Issue 6: Accidentally Deleted Account from App

**Solution:**
1. Use backup code to login
2. Login to FreeIPA
3. Navigate to your user account
4. View QR code again (or get new one)
5. Re-scan in authenticator app

### Emergency MFA Reset

**If All Else Fails:**

1. **Contact System Administrator:**
   - Email: dshannon@cyberinabox.net
   - Subject: "MFA Reset Request - [Your Name]"

2. **Identity Verification Required:**
   - In-person verification (preferred)
   - Video call with photo ID
   - Manager confirmation

3. **Administrator Resets MFA:**
   ```bash
   ipa user-mod username --user-auth-type=password
   ```

4. **Re-enroll Immediately:**
   - Login with password only (temporary)
   - Complete MFA setup
   - Save new backup codes

### Best Practices

**DO:**
- ✅ Save backup codes in secure location (not on phone)
- ✅ Keep phone time synchronized
- ✅ Use a reputable authenticator app
- ✅ Test MFA login before you need it urgently
- ✅ Have backup codes accessible but secure
- ✅ Update your contact info in case of account recovery

**DON'T:**
- ❌ Share your OTP codes with anyone
- ❌ Save backup codes in email or cloud notes
- ❌ Screenshot QR code and leave on phone
- ❌ Use same authenticator account for work and personal
- ❌ Ignore "invalid code" errors (investigate cause)
- ❌ Delay MFA enrollment when required

---

**MFA Summary:**

| Item | Details |
|------|---------|
| **MFA Method** | Time-Based One-Time Password (TOTP) |
| **Code Length** | 6 digits |
| **Code Validity** | 30 seconds |
| **Backup Codes** | 10 codes, one-time use |
| **Required For** | Privileged users, remote access |
| **Supported Apps** | FreeOTP, Google Authenticator, Authy, Microsoft Authenticator |
| **Account Lockout** | 5 failed attempts, 30-minute lockout |
| **Emergency Reset** | Contact System Administrator |

**MFA Enrollment Status:**

| User Type | MFA Status | Enforcement |
|-----------|------------|-------------|
| **Privileged Users** | Required | Mandatory |
| **Remote Access** | Required | Mandatory |
| **Standard Users (Internal)** | Optional | Recommended |
| **Service Accounts** | Not Applicable | Long random passwords |

---

**Related Chapters:**
- Chapter 6: User Accounts & Access
- Chapter 7: Password & Authentication
- Chapter 11: Accessing the Network
- Chapter 25: Reporting Security Issues

**For Help:**
- MFA enrollment assistance: System Administrator
- Lost authenticator: Use backup codes, then re-enroll
- Account locked: Wait 30 minutes or contact administrator
- Emergency: Email dshannon@cyberinabox.net

**Recommended Authenticator Apps:**
- **FreeOTP:** https://freeotp.github.io/ (Open source, privacy-focused)
- **Google Authenticator:** https://support.google.com/accounts/answer/1066447
- **Microsoft Authenticator:** https://www.microsoft.com/en-us/security/mobile-authenticator-app
- **Authy:** https://authy.com/ (Cloud sync, multi-device)
