# Multi-Factor Authentication (MFA) User Enrollment Guide

**Organization:** The Contract Coach
**System:** CyberHygiene Production Network (cyberinabox.net)
**Date:** December 7, 2025
**Version:** 1.0
**Classification:** Controlled Unclassified Information (CUI)

---

## Overview

Multi-Factor Authentication (MFA) is now required for all user accounts on the CyberHygiene Production Network. This guide will walk you through enrolling your smartphone authenticator app with FreeIPA.

**Required for Compliance:**
- NIST 800-171 Rev 2: IA-2(1), IA-2(2)
- Multi-factor authentication for privileged and non-privileged accounts

---

## What You'll Need

1. **Smartphone** with one of these authenticator apps installed:
   - **Google Authenticator** (iOS/Android)
   - **Microsoft Authenticator** (iOS/Android)
   - **Authy** (iOS/Android/Desktop)
   - **FreeOTP** (iOS/Android)
   - Any TOTP-compatible authenticator app

2. **Your FreeIPA username and password**

3. **Access to:** https://dc1.cyberinabox.net

---

## Step 1: Install an Authenticator App

If you don't already have an authenticator app on your phone:

**For iPhone:**
1. Open the App Store
2. Search for "Google Authenticator" or "Microsoft Authenticator"
3. Install the app

**For Android:**
1. Open the Google Play Store
2. Search for "Google Authenticator" or "Microsoft Authenticator"
3. Install the app

**Recommendation:** Microsoft Authenticator includes cloud backup, which makes it easier to recover if you lose your phone.

---

## Step 2: Access the FreeIPA Web Interface

1. Open a web browser on your computer
2. Navigate to: **https://dc1.cyberinabox.net**
3. You may see a certificate warning (this is expected for our internal CA)
   - Click "Advanced" or "Show Details"
   - Click "Proceed to dc1.cyberinabox.net" or "Accept the Risk"
4. Log in with your username and password

---

## Step 3: Add an OTP Token

Once logged into the FreeIPA web interface:

1. Click on your **username** in the top-right corner
2. In the user details page, click the **"OTP Tokens"** tab
3. Click the **"+ Add"** button
4. In the "Add OTP Token" dialog:
   - **Type:** TOTP (Time-based One-Time Password) - usually pre-selected
   - **Description:** Enter something like "My iPhone" or "My Android Phone"
   - Leave other fields at their default values
5. Click **"Add"**

---

## Step 4: Scan the QR Code

After adding the token, you'll see a QR code on the screen:

1. **Open your authenticator app** on your smartphone
2. **Tap the "+" or "Add"** button in the app
3. **Select "Scan QR Code"** or "Scan a barcode"
4. **Point your camera** at the QR code displayed in the FreeIPA web interface
5. The app will automatically add the entry

**Entry Details:**
- **Account:** Your username@CYBERINABOX.NET
- **Issuer:** cyberinabox.net or FreeIPA

**Can't Scan the QR Code?**
- Click "Show Configuration" in the FreeIPA interface
- Manually enter the secret key into your authenticator app

---

## Step 5: Test Your Configuration

Before logging out, verify your OTP token is working:

1. Open your authenticator app
2. Find the entry for **cyberinabox.net**
3. You'll see a 6-digit code that refreshes every 30 seconds
4. Note this code (you'll use it for login)

---

## How to Log In with MFA

### SSH/Terminal Login

When connecting via SSH or logging into a workstation:

```
login: yourusername
Password: [Your_Password][6-Digit_Code]
```

**Example:**
- Your password: `MySecurePass123!`
- Current OTP code: `845921`
- Type: `MySecurePass123!845921` (no space between password and code)

**Important:** Type your password and the 6-digit code together with NO SPACE in between.

### FreeIPA Web Interface Login

1. Navigate to https://dc1.cyberinabox.net
2. Username: `yourusername`
3. Password: `[Your_Password][6-Digit_Code]`
4. Click "Log In"

---

## Troubleshooting

### "Invalid credentials" error

**Possible causes:**
1. **OTP code expired** - The codes refresh every 30 seconds
   - Solution: Wait for a fresh code and try again immediately
2. **Wrong password** - Make sure you're typing your password correctly
   - Solution: Try typing just your password first (without OTP) to verify it's correct
3. **Time sync issue** - Your phone's time is not synchronized
   - Solution: Enable automatic time on your phone (Settings → Date & Time → Set Automatically)

### "Token not yet valid" or "Token expired"

**Cause:** Your phone's clock is not synchronized with the server.

**Solution:**
1. On iPhone: Settings → General → Date & Time → Set Automatically (ON)
2. On Android: Settings → System → Date & time → Set time automatically (ON)
3. Try again with a fresh code

### Lost Your Phone or Deleted the App

**Immediate Action:**
1. Contact the system administrator (Donald Shannon): Don@Contract-coach.com
2. Admin will temporarily disable OTP for your account
3. You can log in with just your password
4. Re-enroll a new OTP token following this guide

**Prevention:**
- Use Microsoft Authenticator with cloud backup enabled
- Or screenshot your QR code and save it securely offline

### Multiple Failed Login Attempts

After **5 failed login attempts**, your account will be locked for **30 minutes**.

**If locked out:**
1. Wait 30 minutes for automatic unlock, OR
2. Contact the system administrator for immediate unlock

---

## Security Best Practices

### DO:
- ✅ Keep your phone locked with a PIN/passcode/biometric
- ✅ Enable automatic time synchronization on your phone
- ✅ Use a unique, strong password for your FreeIPA account
- ✅ Report lost/stolen phones immediately to IT
- ✅ Save backup codes or use an app with cloud backup

### DON'T:
- ❌ Share your OTP codes with anyone (including IT staff)
- ❌ Screenshot and email your QR code (store offline only)
- ❌ Use the same password across multiple systems
- ❌ Share your authenticator app access with others
- ❌ Disable automatic time on your phone

---

## Supported Authenticator Apps

| App | iOS | Android | Cloud Backup | Cost |
|-----|-----|---------|--------------|------|
| Google Authenticator | ✅ | ✅ | ✅ (with Google account) | Free |
| Microsoft Authenticator | ✅ | ✅ | ✅ (with Microsoft account) | Free |
| Authy | ✅ | ✅ | ✅ (with Authy account) | Free |
| FreeOTP | ✅ | ✅ | ❌ | Free |
| 1Password | ✅ | ✅ | ✅ | Paid |
| Bitwarden | ✅ | ✅ | ✅ | Free/Paid |

**Recommendation:** Microsoft Authenticator or Authy for their cloud backup features.

---

## Administrator Contact

**System Administrator:** Donald E. Shannon, ISSO
**Email:** Don@Contract-coach.com
**Support Hours:** Monday-Friday, 8:00 AM - 5:00 PM MST

**Emergency Support:**
- Account lockouts: Email admin with username
- Lost device: Email admin immediately to disable OTP
- Technical issues: Provide error message and screenshot if possible

---

## Compliance Notes

**NIST 800-171 Requirements Met:**
- IA-2(1): Multi-factor authentication for privileged accounts
- IA-2(2): Multi-factor authentication for non-privileged accounts

**Authentication Factors:**
1. **Something you know:** Your password
2. **Something you have:** Your smartphone with authenticator app

**Account Lockout Policy:**
- Max failed attempts: 5
- Lockout duration: 30 minutes
- Automatically resets after lockout period

---

## Frequently Asked Questions

**Q: Do I need to enter the OTP code every time I log in?**
A: Yes, every login requires both your password and a current OTP code.

**Q: Can I use the same authenticator app for multiple accounts?**
A: Yes, authenticator apps support multiple accounts. Your cyberinabox.net entry will be one of many.

**Q: What if I have two phones?**
A: You can enroll OTP tokens on multiple devices. Add a second token following the same steps.

**Q: Can I use a desktop authenticator app?**
A: Yes, apps like Authy have desktop versions. However, mobile apps are more secure and convenient.

**Q: What if my phone dies during login?**
A: Without access to your OTP codes, you'll need to contact the administrator to temporarily disable OTP on your account.

**Q: How long are the OTP codes valid?**
A: Each code is valid for 30 seconds. Use a fresh code to avoid timing issues.

**Q: Can the administrator see my OTP codes?**
A: No, the OTP codes are generated by your device using a shared secret. Only you can see them.

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 12/07/2025 | D. Shannon | Initial user enrollment guide for MFA deployment |

---

*END OF DOCUMENT*
