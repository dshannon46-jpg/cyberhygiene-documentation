# Chapter 11: Accessing the Network

## 11.1 Remote Access (SSH)

### SSH Overview

**Secure Shell (SSH)** is the primary method for remote command-line access to CyberHygiene systems.

**What is SSH?**
- Encrypted terminal access to servers
- Secure file transfer (SCP, SFTP)
- Port forwarding and tunneling
- Remote command execution

**Security Features:**
- All traffic encrypted (FIPS 140-2 compliant)
- Public key authentication supported
- MFA required for privileged users
- Failed attempt lockout protection
- Session logging for audit

### SSH Client Setup

#### Linux/macOS (Built-in OpenSSH)

**Already installed** on most systems. Verify:
```bash
# Check SSH client version
ssh -V

# Should show: OpenSSH 8.0 or newer
```

**Basic Configuration:**

Create/edit `~/.ssh/config`:
```bash
# CyberHygiene SSH Configuration
Host dc1
    HostName dc1.cyberinabox.net
    User your_username
    Port 22
    PreferredAuthentications publickey,keyboard-interactive

Host dms
    HostName dms.cyberinabox.net
    User your_username

Host *cyberinabox.net
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ForwardAgent no
    HashKnownHosts yes
```

**Usage with config:**
```bash
# Instead of: ssh username@dc1.cyberinabox.net
# Just type:
ssh dc1
```

#### Windows (Multiple Options)

**Option 1: Built-in OpenSSH (Windows 10/11)**

1. Open PowerShell
2. Check if installed:
   ```powershell
   ssh -V
   ```
3. If not installed:
   - Settings → Apps → Optional Features
   - Add "OpenSSH Client"

**Option 2: PuTTY (Traditional)**

1. Download from https://www.putty.org/
2. Install PuTTY
3. Run `putty.exe`
4. Configure:
   - Host Name: `dc1.cyberinabox.net`
   - Port: `22`
   - Connection Type: `SSH`
   - Save session as "CyberHygiene-DC1"

**Option 3: Windows Subsystem for Linux (WSL)**

1. Install WSL2
2. Install Ubuntu or Debian
3. Use Linux SSH client (same as Linux/macOS)

### Connecting via SSH

#### Basic Connection

**Password Authentication:**
```bash
# Connect to server
ssh username@dc1.cyberinabox.net

# First time connection - verify fingerprint
The authenticity of host 'dc1.cyberinabox.net (192.168.1.10)' can't be established.
ED25519 key fingerprint is SHA256:abcd1234...
Are you sure you want to continue connecting (yes/no)? yes

# Enter password
Password: [type your password]

# If MFA enabled:
Verification code: [6-digit OTP from authenticator]

# You're logged in
[username@dc1 ~]$
```

**SSH Key Authentication:**
```bash
# Connect with SSH key (no password prompt)
ssh username@dc1.cyberinabox.net

# If key has passphrase:
Enter passphrase for key '/home/username/.ssh/id_ed25519': [passphrase]

# You're logged in
[username@dc1 ~]$
```

#### Advanced Connection Options

**Specify SSH Key:**
```bash
ssh -i ~/.ssh/my_special_key username@dc1.cyberinabox.net
```

**Verbose Output (Troubleshooting):**
```bash
# Show connection details
ssh -v username@dc1.cyberinabox.net

# Very verbose (debug)
ssh -vvv username@dc1.cyberinabox.net
```

**Run Single Command:**
```bash
# Execute command and return to local shell
ssh username@dc1.cyberinabox.net 'ls -la /etc'

# Command output shown locally
# Then connection closes
```

**Port Forwarding:**
```bash
# Forward local port 8080 to remote port 80
ssh -L 8080:localhost:80 username@dc1.cyberinabox.net

# Access via: http://localhost:8080 in browser
```

### SSH File Transfer

#### SCP (Secure Copy)

**Copy File to Server:**
```bash
# Local file → Remote server
scp /path/to/local/file.txt username@dms.cyberinabox.net:/path/to/remote/

# Copy entire directory
scp -r /path/to/local/directory username@dms.cyberinabox.net:/path/to/remote/
```

**Copy File from Server:**
```bash
# Remote file → Local system
scp username@dms.cyberinabox.net:/path/to/remote/file.txt /path/to/local/

# Copy entire directory
scp -r username@dms.cyberinabox.net:/path/to/remote/dir /path/to/local/
```

#### SFTP (SSH File Transfer Protocol)

**Interactive Session:**
```bash
# Start SFTP session
sftp username@dms.cyberinabox.net

# SFTP commands:
sftp> ls                    # List remote files
sftp> lls                   # List local files
sftp> cd /datastore/shared  # Change remote directory
sftp> lcd ~/Downloads       # Change local directory
sftp> get remote_file.txt   # Download file
sftp> put local_file.txt    # Upload file
sftp> quit                  # Exit SFTP
```

**Batch Mode:**
```bash
# Create batch file
cat > sftp_commands.txt <<EOF
cd /datastore/shared
get important_file.txt
put my_upload.txt
bye
EOF

# Execute batch
sftp -b sftp_commands.txt username@dms.cyberinabox.net
```

### Troubleshooting SSH Issues

#### Issue 1: "Connection refused"

**Possible Causes:**
- Server is down
- SSH service not running
- Firewall blocking port 22
- Wrong hostname/IP

**Solutions:**
```bash
# Check if host is reachable
ping dc1.cyberinabox.net

# Check if port 22 is open
telnet dc1.cyberinabox.net 22
# Or
nc -zv dc1.cyberinabox.net 22

# Contact administrator if host unreachable
```

#### Issue 2: "Permission denied (publickey,password)"

**Possible Causes:**
- Wrong username
- Wrong password
- SSH key not uploaded
- Account locked

**Solutions:**
```bash
# Verify username
# Try password authentication explicitly
ssh -o PreferredAuthentications=password username@dc1.cyberinabox.net

# Check if account is locked (need admin)
sudo faillock --user username

# Upload SSH key to FreeIPA (see Chapter 7)
```

#### Issue 3: "Too many authentication failures"

**Cause:** SSH tries all keys, exceeds attempt limit

**Solution:**
```bash
# Specify which key to use
ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519 username@dc1.cyberinabox.net

# Or use password only
ssh -o PreferredAuthentications=password username@dc1.cyberinabox.net
```

#### Issue 4: "Host key verification failed"

**Cause:** Server's host key changed (possible man-in-the-middle attack)

**Solution:**
```bash
# If server was legitimately rebuilt:
ssh-keygen -R dc1.cyberinabox.net

# Then reconnect and accept new key
ssh username@dc1.cyberinabox.net

# If you didn't expect key change, contact security team!
```

## 11.2 VPN Access

### VPN Overview

**Status:** VPN deployment planned for Phase II

**Current Access Method:**
- SSH for command-line access (available now)
- HTTPS for dashboard access (available now)
- Direct connection required (must be on network)

**Future VPN Capabilities:**
- Remote access to internal network from anywhere
- Encrypted tunnel for all traffic
- Access to internal file shares remotely
- Full network services when traveling

**VPN Technology (Planned):**
- OpenVPN or WireGuard
- Certificate-based authentication
- MFA required
- Split tunneling option

**When Available:**
This section will be updated with:
- VPN client installation
- Configuration files
- Connection procedures
- Troubleshooting

**Interim Solution:**
- Use SSH for server access
- Use web dashboards (HTTPS)
- VPN to corporate network (if separate VPN available)

## 11.3 Web Portal Access

### Available Web Services

**Primary Dashboards:**

**1. CPM Dashboard**
```
URL: https://cpm.cyberinabox.net
Purpose: System overview and compliance
Access: All users (read-only)
Authentication: Username + Password + MFA
```

**2. Wazuh SIEM**
```
URL: https://wazuh.cyberinabox.net
Purpose: Security monitoring
Access: Security team, administrators
Authentication: Username + Password + MFA
```

**3. Grafana**
```
URL: https://grafana.cyberinabox.net
Purpose: System health metrics
Access: All users (read-only)
Authentication: Username + Password
```

**4. FreeIPA**
```
URL: https://dc1.cyberinabox.net
Purpose: Identity management, password changes
Access: All users (self-service)
Authentication: Username + Password
```

**5. Graylog**
```
URL: https://graylog.cyberinabox.net
Purpose: Log analysis
Access: Administrators, operations team
Authentication: Username + Password
```

**6. Project Website**
```
URL: https://cyberhygiene.cyberinabox.net
Purpose: Public information, documentation
Access: Public (no login required)
```

### Browser Requirements

**Recommended Browsers:**
- ✅ Mozilla Firefox (latest version)
- ✅ Google Chrome (latest version)
- ✅ Microsoft Edge (latest version)
- ✅ Safari (macOS/iOS, latest version)

**Browser Configuration:**

**Enable JavaScript:**
- Required for dashboards
- Settings → Privacy → Allow JavaScript

**Accept Cookies:**
- Required for session management
- Allow cookies from cyberinabox.net

**Certificate Trust:**
- Internal CA certificate should be trusted
- If you see certificate warnings, contact IT

**Private/Incognito Mode:**
- ⚠️ Use with caution
- Sessions won't persist
- May need to re-authenticate frequently

### Web Authentication

**Single Sign-On (Planned):**
Currently, each service requires separate login. Future enhancement:
- Kerberos SPNEGO for web SSO
- Login once, access all services
- Automatic ticket validation

**Current Login Process:**

**For Dashboards with MFA:**
1. Navigate to URL (e.g., https://wazuh.cyberinabox.net)
2. Enter username
3. Enter password
4. Enter 6-digit OTP code from authenticator app
5. Click "Sign In"

**Session Timeout:**
- Idle timeout: 30 minutes (web)
- Maximum session: 8 hours
- Auto-save: Work may be saved automatically

**Multi-Tab Behavior:**
- Can open multiple dashboards simultaneously
- Each dashboard maintains separate session
- Closing one tab doesn't log out others

### Accessing from Mobile Devices

**Mobile Browser Access:**
- ✅ All dashboards are mobile-responsive
- ✅ Works on phones and tablets
- ⚠️ Some features limited on small screens

**Recommended:**
- Tablet (iPad, Android tablet) for better experience
- Landscape orientation for dashboards
- WiFi connection (better performance than cellular)

**MFA on Mobile:**
- Authenticator app on same device
- Use backup codes if can't switch apps easily
- Or use second device for authenticator

## 11.4 Workstation Login

### Physical Workstation Access

**Workstations Joined to Domain:**
If your workstation is domain-joined:

**Login Screen:**
```
Username: [your_username] or CYBERINABOX\your_username
Password: [your password]
```

**Features:**
- Home directory automounted from DMS server
- Network shares available automatically
- Single sign-on to services
- Centralized policy enforcement

### Linux Desktop Environment

**GNOME/KDE Login:**
1. Select your username
2. Enter password
3. (If configured) Enter OTP token
4. Desktop loads with your profile

**Auto-mounting Network Shares:**
```bash
# Home directory
# Automatically mounted at /home/username

# Shared directories
# May need manual mount:
mount /mnt/shared  # If configured in /etc/fstab
```

**Kerberos Ticket:**
```bash
# Login automatically gets Kerberos ticket
klist

# Should show:
# Default principal: username@CYBERINABOX.NET
# Valid ticket
```

### Windows Workstation (If Applicable)

**Domain Join Status:**
- Full integration: Planned Phase II
- Current: Manual configuration

**Current Windows Access:**
1. Local login to Windows workstation
2. Use SSH client for server access
3. Use web browser for dashboards
4. Map network drives manually:

**Map Network Drive:**
```
Right-click "This PC" → "Map network drive"
Drive: Z:
Folder: \\dms.cyberinabox.net\shared
Reconnect at sign-in: ✓
Connect using different credentials: ✓
Username: CYBERINABOX\your_username
Password: [your password]
```

## 11.5 Mobile Device Access

### Mobile Access Policy

**Allowed Mobile Access:**
- ✅ Web dashboard viewing (read-only)
- ✅ Email access (Roundcube webmail)
- ✅ Emergency SSH access (with MFA)
- ⚠️ File access limited (no CUI on personal devices)

**Prohibited:**
- ❌ Storing CUI on personal mobile devices
- ❌ Forwarding work email to personal accounts
- ❌ Installing unauthorized apps for work access
- ❌ Taking screenshots of sensitive information

### Mobile Device Requirements

**If Using Personal Device:**
- Must have screen lock (PIN/biometric)
- Must have up-to-date OS
- Must have antivirus (if available)
- Must report if lost/stolen immediately

**Recommended Apps:**

**SSH Client (iOS):**
- Termius (free/paid)
- Prompt 3
- Blink Shell

**SSH Client (Android):**
- Termius (free/paid)
- JuiceSSH
- ConnectBot

**Authenticator App:**
- FreeOTP (open source, recommended)
- Google Authenticator
- Microsoft Authenticator
- Authy

### Mobile SSH Access

**Example: Termius on iOS/Android**

1. Install Termius from app store
2. Add new host:
   - Label: CyberHygiene DC1
   - Address: dc1.cyberinabox.net
   - Port: 22
   - Username: your_username
   - Authentication: Password + Keyboard Interactive

3. Connect:
   - Tap host entry
   - Enter password
   - Enter OTP code
   - Terminal opens

**Security Tips:**
- Don't save passwords in app
- Use biometric unlock for app
- Close connections when done
- Don't use on public WiFi without VPN

### Mobile Dashboard Access

**Mobile Browser:**
1. Open browser (Chrome, Safari, Firefox)
2. Navigate to dashboard URL
3. Login with credentials + MFA
4. Dashboard loads in mobile-optimized view

**Tips:**
- Use landscape mode for better view
- Pinch-to-zoom on graphs
- Some features may be limited
- Use desktop for complex tasks

**Data Usage:**
- Dashboards use moderate data
- Avoid streaming logs on cellular
- Use WiFi when possible

---

**Network Access Summary:**

| Access Method | Availability | MFA Required | Use Case |
|---------------|--------------|--------------|----------|
| **SSH** | Available now | Yes (privileged users) | Server administration |
| **Web Dashboards** | Available now | Yes (most dashboards) | Monitoring, management |
| **VPN** | Planned Phase II | Yes | Remote network access |
| **Workstation Login** | Domain-joined workstations | No (Kerberos SSO) | Desktop access |
| **Mobile Access** | Limited | Yes | Emergency access only |

**Port Reference:**

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| SSH | 22 | TCP | Remote shell access |
| HTTPS | 443 | TCP | Web dashboards |
| Kerberos | 88 | TCP/UDP | Authentication |
| LDAP | 636 | TCP | Directory (LDAPS) |
| NFS | 2049 | TCP | File sharing |
| SMB | 445 | TCP | File sharing (Samba) |

**Firewall Rules:**
- SSH: Allowed from internal network, rate-limited externally
- HTTPS: Allowed from anywhere
- Other services: Internal network only

---

**Related Chapters:**
- Chapter 7: Password & Authentication
- Chapter 8: Multi-Factor Authentication
- Chapter 12: File Sharing & Collaboration
- Chapter 14: Web Applications & Services
- Appendix C: Command Reference

**For Help:**
- SSH issues: Check Appendix D (Troubleshooting)
- Account locked: Contact administrator
- MFA problems: See Chapter 8, Section 8.5
- VPN (when available): Updated documentation will be provided

**Remember:**
- Always use encrypted connections (SSH, HTTPS)
- Never access sensitive data on public WiFi
- Lock your screen when away
- Report lost/stolen devices immediately
