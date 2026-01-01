# Chapter 24: Password Management

## 24.1 Password Policy

### Policy Requirements

The CyberHygiene Production Network enforces strict password requirements aligned with NIST 800-171 standards.

**Minimum Password Requirements:**

```
Length:
  ✓ Minimum: 15 characters
  ✓ Recommended: 20+ characters
  ✓ Maximum: 128 characters

Complexity (must include 3 of 4):
  ✓ Uppercase letters (A-Z)
  ✓ Lowercase letters (a-z)
  ✓ Numbers (0-9)
  ✓ Special characters (!@#$%^&*()_+-=[]{}|;:,.<>?)

Prohibited:
  ✗ Username or parts of it
  ✗ Common words (password, admin, user, etc.)
  ✗ Sequential characters (abc, 123, qwerty)
  ✗ Repeated characters (aaa, 111)
  ✗ Previous 24 passwords
  ✗ Passwords from known breach databases
```

**Password Lifetime:**

```
Standard User Accounts:
  - Maximum age: 90 days
  - Warning: 14 days before expiration
  - Grace period: 3 days after expiration
  - Forced change: After grace period, account locked

Privileged Accounts (sudo access):
  - Maximum age: 60 days
  - Warning: 7 days before expiration
  - Grace period: 1 day
  - Forced change: More strict enforcement

Service Accounts:
  - Maximum age: 180 days
  - Managed by administrators only
  - Stored in encrypted vault
```

**Account Lockout Policy:**

```
Failed Login Attempts:
  - Threshold: 5 failed attempts
  - Lockout duration: 30 minutes (automatic unlock)
  - Reset counter: After successful login

Manual Unlock:
  - Contact: dshannon@cyberinabox.net
  - Verification: Identity confirmation required
  - Immediate unlock: For emergencies only
```

### Why These Requirements?

**15+ Character Minimum:**
```
Reason: Resistance to brute force attacks

Attack Time Estimates:
  8 characters (complex): Minutes to hours
  12 characters (complex): Years
  15+ characters (complex): Centuries

Example:
  "Pass123!" (8 chars) = Cracked instantly
  "MyS3cur3P@ssw0rd!2025" (22 chars) = Practically unbreakable
```

**Complexity Requirements:**
```
Reason: Prevent dictionary attacks

Without complexity: "passwordpassword" (16 chars)
  - All lowercase, dictionary word repeated
  - Cracked in seconds despite length

With complexity: "P@ssw0rd-P@ssw0rd" (17 chars)
  - Mixed case, symbols, numbers
  - Significantly more resistant
```

**No Password Reuse:**
```
Reason: Prevent credential stuffing attacks

Scenario:
  1. User reuses password across multiple sites
  2. External site gets breached (common)
  3. Attackers try those credentials here
  4. Account compromised

Solution: Unique passwords for every system
```

## 24.2 Creating Strong Passwords

### Methods for Strong Passwords

**Method 1: Passphrase (Recommended)**

Build from random words:

```
Example: "Correct-Horse-Battery-Staple-99!"

Advantages:
  ✓ Easy to remember
  ✓ Long (33 characters)
  ✓ Complex (symbols, numbers)
  ✓ Difficult to crack

Formula:
  [Word1]-[Word2]-[Word3]-[Word4]-[Number][Symbol]

Real Examples:
  "Blue-Mountain-Coffee-Table-2025!"
  "Sunset-Ocean-Breeze-Calm-777$"
  "Winter-Forest-Snow-Peaceful-42@"
```

**Method 2: Sentence-Based**

Use first letters of a memorable sentence:

```
Sentence: "I started working at CyberHygiene in January 2025!"
Password: "IswaCiJ2025!"

Length: 13 characters (add padding to reach 15)
Modified: "IswaCiJ2025!##"

Advantages:
  ✓ Easy to remember (sentence)
  ✓ Complex (mixed case, numbers, symbols)
  ✓ Unique to you

Examples:
  "My favorite book is The Great Gatsby from 1925"
  → "MfbiTGGf1925!"  → "MfbiTGGf1925!ABC"

  "I drink 3 cups of coffee every morning at 7am"
  → "Id3cocem@7am" → "Id3cocem@7am#XY"
```

**Method 3: Password Generator (Most Secure)**

Use password manager to generate random:

```
Generated Example:
  "J8$mK2#pL9@nV5^qW3&xT7*hR4"

Advantages:
  ✓ Maximum security
  ✓ Truly random
  ✓ Stored in password manager (no memory needed)

Disadvantages:
  ✗ Requires password manager
  ✗ Cannot be easily typed
  ✗ Good for stored passwords, not daily-use passwords
```

### Password Patterns to Avoid

**Bad Patterns:**

```
❌ Simple substitutions:
   "Password" → "P@ssw0rd"
   Still easily cracked with pattern matching

❌ Keyboard patterns:
   "qwerty123!@#"
   "asdfgh!@#$"
   Common patterns in cracking dictionaries

❌ Personal information:
   "JohnSmith1985"
   "Fido-Birthday-2020"
   Easy to guess from social media

❌ Common phrases:
   "LetMeIn123!"
   "Welcome2025"
   "Admin123!@#"
   In every password cracking wordlist

❌ Sequential padding:
   "password123456789"
   Long but still weak - simple pattern

❌ Year at end:
   "MyPassword2025!"
   Predictable pattern, easily guessed
```

**Good Patterns:**

```
✓ Random unrelated words:
   "Elephant-Guitar-Nebula-Cascade-88!"

✓ Modified phrase:
   "I Love Rocky Linux 9.5 FIPS" → "1LRL9.5F!2025_XYZ"

✓ Mixed language/numbers/symbols:
   "Fr3nch-B@gu3tt3-Oce@n-77$"

✓ True randomness (password manager):
   "vK8$mPq2#nLw9@xR5"
```

## 24.3 Password Managers

### Recommended Password Managers

**For CyberHygiene Passwords:**

**Option 1: KeePassXC (Recommended)**
```
Type: Offline password manager (local database)
Cost: Free and Open Source
Platforms: Linux, Windows, macOS

Advantages:
  ✓ Database stored locally (you control it)
  ✓ Encrypted with master password
  ✓ No cloud dependency
  ✓ Can store database on network share (backup)
  ✓ Browser integration available
  ✓ TOTP/OTP support (2FA codes)

Download: https://keepassxc.org/

Setup:
  1. Download and install KeePassXC
  2. Create new database: File → New Database
  3. Set strong master password (use passphrase method)
  4. Save database to: /home/username/keepass/passwords.kdbx
  5. Back up database to: /exports/shared/backups/keepass/
```

**Option 2: Bitwarden (Cloud-Based)**
```
Type: Cloud password manager
Cost: Free tier available, Premium $10/year
Platforms: All platforms + browser extensions

Advantages:
  ✓ Sync across all devices
  ✓ Browser integration (autofill)
  ✓ Mobile apps
  ✓ TOTP/OTP generator
  ✓ Password sharing (with trust)

Considerations:
  ⚠️ Cloud-based (data stored externally)
  ⚠️ Requires internet connection
  ⚠️ Request approval for enterprise use

Website: https://bitwarden.com/
```

**Option 3: Pass (Command Line)**
```
Type: Unix password manager
Cost: Free and Open Source
Platform: Linux, macOS

Advantages:
  ✓ Git integration for versioning
  ✓ GPG encryption
  ✓ Simple and scriptable
  ✓ Minimal interface

Perfect For: Linux users comfortable with command line

Install: sudo dnf install pass
```

### Using a Password Manager

**KeePassXC Workflow:**

**Adding CyberHygiene Password:**
```
1. Open KeePassXC database
2. Click "Add New Entry" (Ctrl+N)
3. Fill in details:

   Title: CyberHygiene SSH
   Username: jsmith
   Password: [Click generate or paste]
   URL: ssh://dc1.cyberinabox.net
   Notes: Main work account

4. Click "OK"
5. Save database (Ctrl+S)

Tip: Organize with groups:
  - Work / CyberHygiene
  - Personal
  - Banking
  - etc.
```

**Retrieving Password:**
```
1. Open KeePassXC (enter master password)
2. Search: Type "CyberHygiene" in search box
3. Double-click password field → copies to clipboard
4. Paste in login prompt (Ctrl+V)
5. Password auto-clears from clipboard after 10 seconds
```

**Generating Strong Password:**
```
In KeePassXC:
1. Click password generator icon (dice)
2. Configure:
   Length: 20 characters
   ✓ Upper case (A-Z)
   ✓ Lower case (a-z)
   ✓ Numbers (0-9)
   ✓ Special characters
   ✗ Look-alike characters (optional - easier to type)
3. Click "Generate"
4. Click "Accept"
```

### Password Manager Security

**Protecting Your Password Manager:**

```
Master Password:
  - Use longest passphrase you can remember
  - Example: "Blue-Mountain-Coffee-Table-Sunset-2025-XYZ!"
  - NEVER write down your master password
  - NEVER share with anyone
  - This is the "key to the kingdom"

Database Backup:
  - Back up .kdbx file regularly
  - Store in multiple locations:
    ✓ Local: /home/username/keepass/
    ✓ Backup: /exports/shared/backups/keepass/
    ✓ Offsite: USB drive at home (encrypted)

Access Control:
  - Lock when away from computer
  - Set auto-lock timeout (5 minutes)
  - Don't leave database open overnight
  - Close before leaving workstation

What If You Forget Master Password:
  ⚠️ Database is unrecoverable
  → Must reset all passwords manually
  → Prevention: Use memorable passphrase
```

## 24.4 Changing Your Password

### Regular Password Changes

**When to Change:**

```
Required Changes:
  - Every 90 days (standard accounts)
  - Every 60 days (privileged accounts)
  - Immediately if compromised
  - After security incident
  - After account sharing (never do this!)

Optional Changes:
  - When you suspect compromise
  - After leaving device unattended
  - Periodically for peace of mind
```

### How to Change Password

**Method 1: FreeIPA Web Interface (Recommended)**

```
1. Navigate to: https://dc1.cyberinabox.net
2. Login with current credentials
3. Click your name (top right)
4. Select "Change Password"
5. Enter:
   - Current password
   - New password (15+ chars, complex)
   - Confirm new password
6. Click "Change Password"
7. Confirmation message appears
8. Update password in password manager

Important: Password changes propagate immediately to all systems
```

**Method 2: Command Line (kpasswd)**

```bash
# SSH to any system
ssh username@dc1.cyberinabox.net

# Run password change command
kpasswd

# Follow prompts:
Password for username@CYBERINABOX.NET: [current password]
Enter new password: [new password]
Enter it again: [new password]

# Success message
Password changed.

# New password active immediately
```

**Method 3: SSH Login (First Time / Expired)**

```
If password expired, SSH will prompt automatically:

$ ssh username@dc1.cyberinabox.net
Password: [enter expired password]

WARNING: Your password has expired.
You must change your password now and login again!

Current Password: [enter expired password]
New password: [enter new password - 15+ chars]
Retype new password: [confirm new password]

passwd: all authentication tokens updated successfully.
Connection to dc1.cyberinabox.net closed.

# Now login with new password
$ ssh username@dc1.cyberinabox.net
Password: [new password]
[login successful]
```

### Password Change Checklist

```
After Changing Password:

✓ Update password manager database
✓ Update saved passwords in browser (if any)
✓ Update mobile device saved passwords
✓ Update email client (if using)
✓ Test new password (login again to verify)
✓ Delete old password from clipboard/memory
✓ Check MFA still works (OTP token unchanged)

If Any Login Fails:
  - Wait 2 minutes (propagation time)
  - Try again
  - If still fails: Contact administrator
```

## 24.5 Compromised Passwords

### Signs of Compromise

**Indicators Your Password May Be Compromised:**

```
□ Unexpected password change emails
□ Account locked without reason
□ Login attempts from unknown locations
□ Files accessed or modified without your action
□ Wazuh alerts for your account
□ Friends/colleagues report strange messages from you
□ Can't login with known-correct password
□ Account activity you don't recognize
```

### Immediate Actions

**If You Suspect Compromise:**

**Step 1: Change Password Immediately (within 5 minutes)**
```
1. Login to FreeIPA: https://dc1.cyberinabox.net
   (If you can't login, contact administrator immediately)

2. Change password:
   - Use completely new password (not variation of old)
   - Use password generator or new passphrase
   - Minimum 20 characters recommended

3. Verify change successful
```

**Step 2: Revoke Active Sessions**
```
In FreeIPA:
1. Identity → Users → [Your Name]
2. Actions → "Reset Password" (forces all sessions to logout)
3. All devices must re-login with new password
```

**Step 3: Check Account Activity**
```
Review Graylog for your account:

Access: https://graylog.cyberinabox.net
Query: username:your_username
Time Range: Last 24 hours

Look for:
  - Login times you don't recognize
  - Source IPs that aren't yours
  - Unusual commands or actions
  - Access to files you didn't touch

Screenshot any suspicious activity
```

**Step 4: Report to Security Team**
```
Email: security@cyberinabox.net
Subject: [SECURITY] Possible Account Compromise

User: [your username]
Discovery: [when did you notice]
Indicators: [what made you suspicious]

Actions Taken:
- ✓ Password changed at [time]
- ✓ Sessions revoked
- ✓ Account activity reviewed

Suspicious Activity Found:
[Describe or attach screenshots]

Contact: [your email/phone]
Availability: [when you're reachable]

Status: Monitoring for further suspicious activity
```

**Step 5: Monitor for 24 Hours**
```
For the next 24 hours, watch for:
  - Unexpected logins
  - Failed authentication attempts
  - Unusual alerts from Wazuh
  - Strange emails or messages

Report immediately if anything suspicious continues.
```

### If You Can't Login

**Password Not Working:**

```
Scenario: You try to login but your known password fails

Possible Causes:
1. Caps Lock is on (check keyboard)
2. Password recently changed and you're using old one
3. Account locked due to failed attempts
4. Password compromised and changed by attacker

Actions:
1. Verify Caps Lock off
2. Try password carefully (copy from password manager)
3. Wait 5 minutes, try once more
4. If fails again: STOP (don't lock yourself out)
5. Contact administrator immediately:

   Email: dshannon@cyberinabox.net
   Subject: [URGENT] Cannot Login - Possible Compromise

   Account: [username]
   Issue: Password not working, suspect compromise
   Last successful login: [if known]

   Request:
   - Account status check
   - Password reset
   - Review account activity
```

### Password Reset by Administrator

**Administrator-Initiated Reset:**

If administrator detects compromise:

```
You will receive email:

From: Security Team <security@cyberinabox.net>
Subject: [ACTION REQUIRED] Password Reset - Security Precaution

Your account password has been reset as a security precaution.

Reason: [Compromise suspected / Security incident / etc.]

Actions Taken:
- Temporary password issued
- All sessions terminated
- Account access logged

Next Steps:
1. Login with temporary password: [provided separately]
2. Immediately change to permanent password
3. Review account activity (link provided)
4. Contact security team with any questions

Temporary Password Valid: 24 hours

Do NOT ignore this message. Account will be locked if not reset.
```

**Your Response:**
```
1. Login with temporary password (within 24 hours)
2. System forces password change immediately
3. Set new strong password (15+ characters)
4. Update password manager
5. Test new password
6. Review account activity as instructed
7. Reply to security email confirming completion
```

## 24.6 Best Practices

### Do's and Don'ts

**DO:**
```
✓ Use unique passwords for every system
✓ Use password manager to store passwords
✓ Use passphrases (long, memorable)
✓ Change password immediately if compromised
✓ Enable MFA when available
✓ Lock screen when away from desk
✓ Logout when done
✓ Report suspicious activity
✓ Keep password manager database backed up
✓ Use password generator for random passwords
```

**DON'T:**
```
✗ Share your password with anyone (EVER)
✗ Write passwords on sticky notes
✗ Save passwords in plain text files
✗ Email passwords
✗ Reuse passwords across systems
✗ Use personal information in passwords
✗ Use common words or patterns
✗ Leave passwords visible on screen
✗ Save passwords in browser (on shared computers)
✗ Trust "remember password" on public computers
```

### Special Situations

**Temporary Password Sharing (Prohibited):**

```
Scenario: Colleague needs access to something

❌ WRONG: "Just use my password: Passw0rd123!"

✓ CORRECT:
  1. Request separate account for colleague
  2. Grant appropriate permissions to their account
  3. Maintain audit trail of who did what
  4. Revoke access when no longer needed

Reason:
  - Accountability: Can't tell who did what
  - Security: If compromised, both accounts affected
  - Compliance: Violates NIST 800-171
  - Policy: Grounds for account suspension
```

**Service Account Passwords:**

```
For applications/services (not personal use):

✓ Managed by administrator only
✓ Stored in encrypted vault
✓ Not shared with end users
✓ Rotated every 180 days
✓ Complex and random

If you need service account:
  - Email: dshannon@cyberinabox.net
  - Explain: What application needs it
  - Justification: Business requirement
  - Administrator creates and manages it
```

**Emergency Access:**

```
If administrator unavailable and you need access urgently:

There is NO emergency bypass.

Alternatives:
  - Check backup administrator contacts (Chapter 5)
  - Wait for administrator to return
  - Escalate to management if truly critical

Reason: Security over convenience
  - Backdoors compromise security
  - Emergency processes can be exploited
  - Plan ahead instead
```

---

**Password Management Quick Reference:**

**Password Requirements:**
- Minimum: 15 characters
- Complexity: 3 of 4 (upper, lower, numbers, symbols)
- Lifetime: 90 days (standard), 60 days (privileged)
- Cannot reuse: Last 24 passwords

**Strong Password Formula:**
```
Passphrase: [Word1]-[Word2]-[Word3]-[Word4]-[Number][Symbol]
Example: "Blue-Mountain-Coffee-Sunset-2025!"

Sentence: First letters of memorable sentence
Example: "I started working at CyberHygiene in January 2025!"
→ "IswaCiJ2025!ABC"
```

**Change Password:**
- Web: https://dc1.cyberinabox.net → Change Password
- CLI: `kpasswd` command
- Frequency: Every 90 days or immediately if compromised

**Password Manager (Recommended):**
- KeePassXC: https://keepassxc.org/ (Free, offline)
- Bitwarden: https://bitwarden.com/ (Free/Premium, cloud)
- Store master password in brain only (never write down)

**If Compromised:**
1. Change password immediately (within 5 minutes)
2. Revoke all active sessions
3. Review account activity (Graylog)
4. Report to: security@cyberinabox.net
5. Monitor for 24 hours

**DON'T:**
- ✗ Share password with anyone
- ✗ Write password down
- ✗ Reuse passwords
- ✗ Use personal information
- ✗ Save in plain text

**DO:**
- ✓ Use password manager
- ✓ Use unique passwords everywhere
- ✓ Change if compromised
- ✓ Lock screen when away
- ✓ Report suspicious activity

**For Help:**
- Password reset: dshannon@cyberinabox.net
- Compromise report: security@cyberinabox.net
- Account locked: dshannon@cyberinabox.net
- Emergency: See Chapter 5

---

**Related Chapters:**
- Chapter 7: Password & Authentication
- Chapter 8: Multi-Factor Authentication (MFA)
- Chapter 22: Incident Response
- Chapter 25: Reporting Security Issues
- Appendix D: Troubleshooting Guide

**Password Tools:**
- FreeIPA: https://dc1.cyberinabox.net
- Graylog (activity logs): https://graylog.cyberinabox.net
- KeePassXC: https://keepassxc.org/
- Have I Been Pwned: https://haveibeenpwned.com/ (check if email in breach)
