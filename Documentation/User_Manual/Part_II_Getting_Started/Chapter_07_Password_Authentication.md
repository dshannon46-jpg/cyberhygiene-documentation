# Chapter 7: Password & Authentication

## 7.1 Password Requirements

### Password Complexity Policy

To meet NIST 800-171 requirements and ensure strong security, all passwords must meet these criteria:

**Minimum Requirements:**
- **Length:** 15 characters minimum
- **Complexity:** Must include at least 3 of the following 4 categories:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Numbers (0-9)
  - Special characters (!@#$%^&*()_+-=[]{}|;:,.<>?)
- **No Common Patterns:** No dictionary words, keyboard patterns, repeated characters
- **No Personal Info:** No username, full name, email address, or birthdate

**Password Expiration:**
- Passwords expire every **90 days**
- Warning notifications at 14, 7, and 3 days before expiry
- Grace logins allowed (3) after expiry to change password
- Account locks after grace period expires

**Password History:**
- Cannot reuse last **24 passwords**
- System remembers password hashes
- Prevents password cycling

### Password Examples

**❌ Weak Passwords (Will Be Rejected):**
```
password123         - Too common, predictable
Summer2024!         - Too short (11 chars), seasonal pattern
qwerty12345         - Keyboard pattern
johndoe2024         - Contains username
```

**✅ Strong Passwords (Acceptable):**
```
My$ecurePa$$w0rd2024!CyberBox    - 32 chars, mixed complexity
C0mpl3x&S3cur3!Phr@s3            - 25 chars, mixed complexity
Tr0picalF!sh&C0ralR33f2024       - 30 chars, mixed complexity
```

**💡 Best Practice:**
Use a **passphrase** with at least 4 random words, numbers, and symbols:
```
Correct-Horse-Battery-Staple-2024!
Blue$Elephant&Green#Mountain42
Coffee@Laptop%Sunrise&Monday99
```

### Password Strength Meter

When changing passwords through FreeIPA:
- 🔴 **Weak:** Rejected, cannot use
- 🟡 **Fair:** Accepted but discouraged
- 🟢 **Good:** Recommended strength
- 🟢🟢 **Strong:** Excellent security

## 7.2 Password Management

### Initial Password Setup

**First-Time Login:**

1. You will receive a **temporary password** via email
2. SSH to the system or login to FreeIPA web interface
3. System will prompt for password change:
   ```
   WARNING: Your password has expired.
   You must change your password now and login again!
   Changing password for user jsmith.
   Current Password: [enter temporary password]
   New password: [enter new password meeting requirements]
   Retype new password: [confirm new password]
   ```
4. Password is changed immediately
5. Login again with new password

**Account Activation Checklist:**
- ✅ Received temporary password
- ✅ Changed password on first login
- ✅ New password meets complexity requirements
- ✅ Set up MFA (if required)
- ✅ Reviewed Acceptable Use Policy

### Changing Your Password

#### Method 1: Command Line (SSH)

```bash
# SSH to any system
ssh username@dc1.cyberinabox.net

# Run passwd command
passwd

# Follow prompts
Current password: [enter current password]
New password: [enter new password]
Retype new password: [confirm new password]

# Confirmation
passwd: all authentication tokens updated successfully.
```

#### Method 2: FreeIPA Web Interface

1. Navigate to https://dc1.cyberinabox.net
2. Login with current credentials
3. Click your username (top right corner)
4. Select "Change Password"
5. Enter current password
6. Enter new password (twice)
7. Click "Update"
8. Confirmation message appears

#### Method 3: Password Expiry Login

When your password expires, you can still login to change it:

```bash
ssh username@dc1.cyberinabox.net
# System displays:
# WARNING: Your password has expired.
# You must change your password now and login again!

# Follow password change prompts
# Then login again with new password
```

### Password Best Practices

**DO:**
- ✅ Use a password manager (KeePassXC, Bitwarden)
- ✅ Create unique passwords for each system
- ✅ Use passphrases (easier to remember, harder to crack)
- ✅ Change password if you suspect compromise
- ✅ Enable MFA for additional security
- ✅ Store backup codes securely

**DON'T:**
- ❌ Share your password with anyone (even IT staff)
- ❌ Write passwords on sticky notes or notebooks
- ❌ Use the same password on multiple systems
- ❌ Include your username in your password
- ❌ Use simple substitutions (@ for a, 3 for e)
- ❌ Email passwords (even to yourself)

### Password Storage

**Recommended Password Managers:**

**1. KeePassXC (Open Source)**
- Download: https://keepassxc.org/
- Encrypted local database
- No cloud sync (more secure)
- Cross-platform (Windows, macOS, Linux)

**2. Bitwarden (Open Source)**
- Website: https://bitwarden.com/
- Self-hosted or cloud option
- Browser integration
- Mobile apps available

**3. Enterprise Option:**
- Contact IT about enterprise password manager deployment

## 7.3 SSH Key Authentication

### SSH Key Overview

**What are SSH Keys?**
SSH keys provide **password-less authentication** using public-key cryptography:
- **Private Key:** Kept secret on your computer, never shared
- **Public Key:** Uploaded to FreeIPA, distributed to servers

**Benefits:**
- More secure than passwords
- Convenient (no password typing)
- Required for automation/scripts
- Resistant to brute-force attacks

### Generating SSH Keys

#### Linux/macOS:

```bash
# Generate RSA key (4096-bit)
ssh-keygen -t rsa -b 4096 -C "your_email@cyberinabox.net"

# Or generate Ed25519 key (modern, recommended)
ssh-keygen -t ed25519 -C "your_email@cyberinabox.net"

# Follow prompts:
# - Save location: [Press Enter for default ~/.ssh/id_rsa]
# - Passphrase: [Enter strong passphrase]
# - Confirm passphrase: [Re-enter passphrase]

# Your keys are created:
# Private key: ~/.ssh/id_rsa (or ~/.ssh/id_ed25519)
# Public key: ~/.ssh/id_rsa.pub (or ~/.ssh/id_ed25519.pub)
```

#### Windows (PowerShell):

```powershell
# Using built-in OpenSSH (Windows 10/11)
ssh-keygen -t ed25519 -C "your_email@cyberinabox.net"

# Or use PuTTYgen:
# 1. Download PuTTY from https://www.putty.org/
# 2. Run puttygen.exe
# 3. Select "EdDSA" or "RSA" (4096 bits)
# 4. Click "Generate"
# 5. Set passphrase
# 6. Save private key
# 7. Copy public key text
```

### Uploading SSH Keys to FreeIPA

#### Method 1: FreeIPA Web Interface

1. Login to https://dc1.cyberinabox.net
2. Navigate to Identity → Users → [Your username]
3. Scroll to "SSH public keys" section
4. Click "Add"
5. Copy your **public key**:
   ```bash
   # Display your public key
   cat ~/.ssh/id_rsa.pub
   # Or
   cat ~/.ssh/id_ed25519.pub
   ```
6. Paste the entire key (starts with `ssh-rsa` or `ssh-ed25519`)
7. Click "Add"
8. Key is immediately available on all systems

#### Method 2: Command Line

```bash
# Upload key using ipa command (requires Kerberos ticket)
kinit your_username
ipa user-mod your_username --sshpubkey="$(cat ~/.ssh/id_ed25519.pub)"
```

### Using SSH Keys

**First Login with Key:**

```bash
# SSH will automatically try your key
ssh username@dc1.cyberinabox.net

# If you set a passphrase, you'll be prompted once:
Enter passphrase for key '/home/username/.ssh/id_ed25519': [enter passphrase]

# Then you're logged in (no password needed)
```

**SSH Agent (Remember Passphrase):**

```bash
# Start SSH agent
eval $(ssh-agent)

# Add your key (enter passphrase once)
ssh-add ~/.ssh/id_ed25519

# Now SSH works without passphrase prompts (until reboot)
ssh username@dc1.cyberinabox.net
```

**Automatically Start SSH Agent:**

Add to `~/.bashrc` or `~/.zshrc`:
```bash
# Start SSH agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi
```

### SSH Key Security

**Protecting Your Private Key:**
- ❌ **Never share your private key**
- ✅ Always use a strong passphrase
- ✅ Store private key only on your workstation
- ✅ Set proper permissions: `chmod 600 ~/.ssh/id_rsa`
- ✅ Backup private key to encrypted storage

**Key Rotation:**
- Generate new keys annually
- Upload new public key to FreeIPA
- Delete old key after transition period

**If Key is Compromised:**
1. Immediately contact IT security
2. Remove public key from FreeIPA
3. Generate new key pair
4. Upload new public key

## 7.4 Kerberos Authentication

### What is Kerberos?

**Kerberos** is a network authentication protocol that provides:
- **Single Sign-On (SSO):** Login once, access all services
- **Mutual Authentication:** Both client and server verify identity
- **Encrypted Communications:** Credentials never sent in plaintext
- **Time-Limited Tickets:** Automatic expiration for security

**How It Works:**

```
User Login
   ↓
[FreeIPA/Kerberos KDC] -- Issues Ticket-Granting Ticket (TGT)
   ↓
User requests service (e.g., file share, web app)
   ↓
[KDC] -- Issues Service Ticket (ST)
   ↓
Service validates ticket, grants access
   ↓
User is authenticated (no password re-entry needed)
```

### Getting a Kerberos Ticket

**Initial Authentication:**

```bash
# Get a Kerberos ticket (TGT)
kinit your_username

# Enter password when prompted
Password for your_username@CYBERINABOX.NET: [enter password]

# Confirmation (silent if successful)
```

**Verify Your Ticket:**

```bash
# List your Kerberos tickets
klist

# Output:
Ticket cache: FILE:/tmp/krb5cc_1001
Default principal: jsmith@CYBERINABOX.NET

Valid starting       Expires              Service principal
12/31/2025 09:00:00  12/31/2025 17:00:00  krbtgt/CYBERINABOX.NET@CYBERINABOX.NET
```

**Ticket Details:**
- **Valid starting:** When ticket became active
- **Expires:** When ticket expires (default: 8 hours)
- **Service principal:** What this ticket is for

### Using Kerberos Tickets

**Automatic Service Access:**

Once you have a TGT, you can access Kerberos-enabled services without re-entering your password:

**File Shares:**
```bash
# Mount NFS share (Kerberos authenticated)
mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared

# Access Samba share (Kerberos SSO)
smbclient //dms.cyberinabox.net/shared -k
```

**SSH (with GSSAPI):**
```bash
# SSH with Kerberos (no password prompt)
ssh -K username@dc1.cyberinabox.net
```

**Web Applications:**
- Some web apps use SPNEGO (web Kerberos)
- Browser automatically authenticates using your ticket
- No username/password form needed

### Renewing and Destroying Tickets

**Renew Expired Ticket:**

```bash
# If ticket has expired
kinit -R

# Or get a new ticket
kinit your_username
```

**Destroy Ticket (Logout):**

```bash
# Remove Kerberos ticket (logout)
kdestroy

# Verify tickets are gone
klist
# Output: klist: No credentials cache found
```

**When to Destroy Tickets:**
- End of workday
- Stepping away from workstation
- Accessing from untrusted computer
- Before system reboot/shutdown

## 7.5 Session Management

### Session Timeout

**Kerberos Ticket Lifetime:**
- **Default:** 8 hours
- **Maximum Renewal:** 24 hours
- **Renewal Window:** Can renew ticket before expiry
- **After Expiry:** Must re-authenticate with password

**SSH Session Timeout:**
- **Idle Timeout:** 15 minutes of inactivity
- **Maximum Session:** 24 hours
- **Warning:** 2-minute warning before disconnect

**Web Session Timeout:**
- **Idle Timeout:** 30 minutes
- **Maximum Session:** 8 hours
- **Auto-Save:** Dashboards save state before timeout

### Active Session Management

**View Active Sessions:**

```bash
# View your logged-in sessions
who
# Output:
jsmith   pts/0   2025-12-31 09:15 (192.168.1.100)

# View all users logged in
w
# Output shows: user, terminal, login time, idle time, what they're doing
```

**Terminate Your Own Session:**

```bash
# Logout from SSH
exit
# or
logout
# or press Ctrl+D
```

**Security Best Practices:**

1. **Lock Screen:** Always lock when stepping away
   - Linux: `Ctrl+Alt+L`
   - macOS: `Cmd+Ctrl+Q`
   - Windows: `Windows+L`

2. **Logout:** Always logout at end of day
   ```bash
   kdestroy  # Destroy Kerberos ticket
   exit      # Logout from shell
   ```

3. **Monitor Sessions:** Check for unauthorized sessions
   ```bash
   # List your active sessions
   who | grep your_username
   ```

4. **Report Suspicious Activity:**
   - Unknown sessions
   - Unfamiliar locations
   - Unexpected access times

---

**Password & Authentication Summary:**

| Feature | Setting | Notes |
|---------|---------|-------|
| **Password Length** | 15 characters minimum | NIST 800-171 requirement |
| **Password Expiry** | 90 days | Warning at 14, 7, 3 days before |
| **Password History** | 24 passwords remembered | Prevents reuse |
| **Failed Login Lockout** | 5 attempts, 30-min lockout | Brute-force protection |
| **Kerberos Ticket** | 8 hours default lifetime | Single sign-on |
| **SSH Session Timeout** | 15 minutes idle | Security measure |
| **MFA Requirement** | Privileged users, remote | Multi-factor authentication |

**Authentication Methods Available:**

| Method | Security Level | Use Case |
|--------|----------------|----------|
| **Password** | Good | Basic authentication |
| **SSH Key** | Better | Password-less login, automation |
| **Kerberos** | Better | Single sign-on, encrypted |
| **MFA (Password + OTP)** | Best | Privileged access, remote login |
| **SSH Key + MFA** | Best | Highest security scenarios |

---

**Related Chapters:**
- Chapter 6: User Accounts & Access
- Chapter 8: Multi-Factor Authentication (MFA)
- Chapter 11: Accessing the Network
- Chapter 24: Password Management (Security Procedures)

**For Help:**
- Forgotten password: Contact System Administrator
- Locked account: `sudo faillock --user username --reset`
- SSH key issues: Re-upload public key to FreeIPA
- Kerberos problems: `kdestroy` then `kinit` to get fresh ticket
