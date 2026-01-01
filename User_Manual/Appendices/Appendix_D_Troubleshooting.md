# Appendix D: Troubleshooting Guide

## Authentication & Access Issues

### Cannot Login via SSH

**Symptom:** `ssh username@dc1.cyberinabox.net` fails

**Error: "Connection refused"**
```
Possible Causes:
□ Server is down
□ SSH service not running
□ Firewall blocking port 22
□ Wrong hostname/IP

Quick Fixes:
1. Check if server is reachable:
   ping dc1.cyberinabox.net

2. Try alternate server:
   ssh username@dms.cyberinabox.net

3. Check if port 22 is open:
   telnet dc1.cyberinabox.net 22

4. Contact administrator if all servers unreachable
```

**Error: "Permission denied (publickey,gssapi-keyex,gssapi-with-mic)"**
```
Possible Causes:
□ No valid Kerberos ticket
□ SSH key not uploaded
□ Wrong username
□ Account disabled

Quick Fixes:
1. Get Kerberos ticket:
   kinit your_username

2. Verify ticket exists:
   klist

3. Try password authentication:
   ssh -o PreferredAuthentications=password username@host

4. Check if account is locked:
   Contact administrator
```

**Error: "Too many authentication failures"**
```
Cause: SSH trying all your keys, exceeding attempt limit

Quick Fix:
ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519 username@host

Or use password only:
ssh -o PreferredAuthentications=password username@host
```

**Error: "Host key verification failed"**
```
Cause: Server's host key changed (possible security issue!)

If server was legitimately rebuilt:
ssh-keygen -R dc1.cyberinabox.net
ssh username@dc1.cyberinabox.net

⚠️ If you didn't expect key change, contact security team immediately!
```

### Account Locked

**Symptom:** "Account locked" or immediate disconnect after password

**Check if locked:**
```bash
# Contact admin, they can check:
sudo faillock --user your_username
```

**Common Causes:**
- 5 failed login attempts
- Expired password
- Account disabled by administrator

**Solution:**
```
Contact administrator:
Email: dshannon@cyberinabox.net
Subject: Account Locked - [your_username]

Include:
- When it started
- Error message
- Last successful login (if known)
```

**Self-Service Unlock (if available):**
```
Wait 30 minutes (automatic unlock)
Or contact administrator for immediate unlock
```

### Password Issues

**"Password has expired"**
```
Solution:
1. System will prompt you to change it immediately
2. Enter current password
3. Enter new password (15+ characters, complex)
4. Confirm new password
5. Re-login with new password
```

**"Password does not meet requirements"**
```
Requirements:
✓ Minimum 15 characters
✓ At least 3 of 4: uppercase, lowercase, numbers, symbols
✓ Cannot contain username
✓ Cannot reuse last 24 passwords
✓ No common words or patterns

Example strong password:
MyS3cur3P@ssw0rd!2025

Or use passphrase:
Correct-Horse-Battery-Staple-99!
```

**Forgot Password**
```
Cannot self-reset - contact administrator:
Email: dshannon@cyberinabox.net
Subject: Password Reset - [your_username]

Alternative contact (if email unavailable):
[Emergency contact number]
```

### MFA (Multi-Factor Authentication) Issues

**"Invalid verification code"**
```
Possible Causes:
□ Code expired (30-second window)
□ Phone time not synchronized
□ Typing error

Quick Fixes:
1. Wait for next code (30 seconds)
2. Check phone time settings:
   Settings → Date & Time → Set automatically: ON
3. Type carefully (6 digits, no spaces)
4. Use backup code if persistent
```

**Lost Phone / Authenticator App Deleted**
```
Immediate Action:
1. Use backup code to login
2. Login to FreeIPA: https://dc1.cyberinabox.net
3. Reset MFA:
   - Identity → Users → [your name]
   - Actions → Reset MFA
4. Re-enroll with new phone/app

No Backup Codes:
Contact administrator for manual reset
(Requires identity verification)
```

**"Too many failed attempts - account locked"**
```
Cause: 5+ failed OTP attempts

Solution:
Wait 30 minutes (automatic unlock)
Or contact administrator for immediate unlock
```

## Network & Connectivity Issues

### Cannot Access Dashboards

**Dashboard shows "Connection timed out"**
```
Troubleshooting Steps:

1. Check internet connection:
   ping google.com

2. Check if dashboard server is up:
   ping grafana.cyberinabox.net

3. Test specific port:
   telnet grafana.cyberinabox.net 3001

4. Try different browser:
   Chrome → Firefox → Edge

5. Clear browser cache:
   Ctrl+Shift+Delete → Clear cache

6. Try incognito mode:
   Ctrl+Shift+N (Chrome)
   Ctrl+Shift+P (Firefox)

If none work: Contact administrator
```

**Dashboard loads but shows "No Data"**
```
Possible Causes:
□ Service temporarily down
□ Data source connection lost
□ Time range set to period with no data

Quick Fixes:
1. Refresh page: F5 or Ctrl+R
2. Change time range: Try "Last 24 hours"
3. Check system status:
   https://cpm.cyberinabox.net
4. Wait 5 minutes and retry
5. Contact administrator if persistent
```

**"403 Forbidden" or "401 Unauthorized"**
```
Possible Causes:
□ Not logged in
□ Session expired
□ Insufficient permissions

Quick Fixes:
1. Re-login to dashboard
2. Check if you have access:
   Contact administrator if you should have access
3. Get valid Kerberos ticket:
   kinit your_username
```

**Certificate Error / "Not Secure" Warning**
```
Cause: Internal CA certificate not trusted

Solution:
Contact administrator to:
- Install internal CA certificate, OR
- Provide correct certificate

⚠️ Do NOT click "Proceed anyway" - contact IT instead
```

### File Share Access Issues

**"Permission denied" on network share**
```
Troubleshooting:

1. Check you're in required group:
   groups

2. Get Kerberos ticket (for NFS):
   kinit your_username
   klist  # Verify ticket valid

3. For Samba, try explicit credentials:
   Windows: Use "Connect using different credentials"
   Linux: mount with username/password

4. Check file permissions on server:
   ls -l /path/to/file

5. Request group membership:
   Email administrator with business justification
```

**Cannot mount NFS share**
```
Error: "mount.nfs: access denied"

Checklist:
□ Valid Kerberos ticket: klist
□ Mount point exists: ls /mnt/shared
□ Correct mount command:
  sudo mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared

□ Export is available:
  showmount -e dms.cyberinabox.net

If all correct: Contact administrator
```

**File share is slow**
```
Possible Causes:
□ Network congestion
□ Large file transfer in progress
□ Server load high

Temporary Workarounds:
- Use off-peak hours for large transfers
- Split large operations into smaller chunks
- Use rsync instead of GUI copy for large datasets

If persistent: Report to administrator
```

## Service Issues

### Email Problems

**Cannot send email**
```
Check:
□ Email server settings correct:
  SMTP: mail.cyberinabox.net
  Port: 587
  Security: STARTTLS

□ Authentication configured:
  Username: your_username
  Password: your_password

□ Attachment size < 25MB

□ Recipient address correct

Test:
Send email to yourself first
```

**Cannot receive email**
```
Check:
□ IMAP settings correct:
  Server: mail.cyberinabox.net
  Port: 993
  Security: SSL/TLS

□ Mailbox not full:
  Check quota in webmail

□ Email not in spam folder

□ Correct password

If problem persists: Contact administrator
```

**Webmail (Roundcube) not loading**
```
Quick Fixes:
1. Clear browser cache
2. Try different browser
3. Check https://mail.cyberinabox.net status
4. Verify credentials
5. Contact administrator if down
```

### Kerberos Ticket Issues

**"Credentials cache file not found"**
```
Cause: No Kerberos ticket

Solution:
kinit your_username
# Enter password when prompted

Verify:
klist
```

**"Ticket expired"**
```
Solution:
Renew ticket:
kinit -R

Or get new ticket:
kinit your_username
```

**"Clock skew too great"**
```
Cause: System time is wrong (>5 minutes off)

Solution:
1. Check system time:
   date

2. If wrong, sync time (admin required):
   sudo ntpdate -u pool.ntp.org

   Or:
   sudo timedatectl set-ntp true

3. Get new ticket:
   kdestroy
   kinit your_username
```

## Performance Issues

### System Running Slow

**SSH session is laggy**
```
Possible Causes:
□ Network latency
□ Server load high
□ Terminal buffer full

Quick Fixes:
1. Check network latency:
   ping dc1.cyberinabox.net

2. Clear terminal:
   clear
   Ctrl+L

3. Close unused SSH sessions:
   exit

4. Use screen/tmux to persist sessions:
   screen -S mysession

If server load high: Contact administrator
```

**Dashboard slow to load**
```
Quick Fixes:
1. Reduce time range: Use "Last 1 hour" instead of "Last 30 days"
2. Close unused dashboard tabs
3. Clear browser cache
4. Use lightweight view if available
5. Check internet speed: speedtest.net

If Grafana server is slow: Contact administrator
```

**File transfer is slow**
```
Expected Speeds:
- Internal network: 100+ MB/s
- Internet: Varies by connection

Troubleshooting:
1. Check if large backup/transfer running:
   Contact administrator

2. Use better transfer method:
   - Large files: rsync instead of scp
   - Many small files: tar + compress first

3. Transfer during off-peak hours:
   Early morning or late night

4. Check network utilization:
   Contact administrator for analysis
```

## Error Messages

### Common Error Messages and Solutions

**"bash: command not found"**
```
Causes:
□ Typo in command name
□ Command not installed
□ Not in PATH

Solutions:
1. Check spelling: histroy → history
2. Check if installed:
   which command_name
   rpm -qa | grep package_name
3. Request installation from administrator
```

**"No such file or directory"**
```
Causes:
□ Typo in path
□ File doesn't exist
□ Wrong directory

Solutions:
1. Check current directory:
   pwd

2. List files:
   ls -la

3. Use tab completion:
   Type first few letters, press Tab

4. Use absolute path:
   /full/path/to/file instead of relative
```

**"Operation not permitted"**
```
Cause: Insufficient permissions

Solutions:
1. Check file permissions:
   ls -l filename

2. If you should have access:
   - File: Request permission change from owner
   - System: Use sudo (if authorized)

3. Check SELinux:
   ls -Z filename
   If SELinux issue: Contact administrator
```

**"Disk quota exceeded"**
```
Cause: You've used your allocated disk space

Solutions:
1. Check quota:
   quota -s

2. Find large files:
   du -sh ~/* | sort -h | tail -10

3. Clean up:
   - Delete temporary files
   - Empty trash
   - Remove old downloads
   - Compress old files

4. Request quota increase:
   Contact administrator with business justification
```

**"Device or resource busy"**
```
Cause: File/directory in use

Solutions:
1. Check what's using it:
   sudo lsof /mount/point

2. Close applications using the resource

3. Wait a few minutes and retry

4. If unmounting: Stop services first
   sudo systemctl stop service_name
   sudo umount /mount/point
```

## Getting Help

### Before Contacting Support

**Gather This Information:**

```
1. What were you trying to do?
2. What command/action did you perform?
3. What error message appeared? (exact text)
4. When did it start happening?
5. Does it happen every time or intermittently?
6. What have you tried so far?
```

**Useful Diagnostic Commands:**

```bash
# System information
uname -a
cat /etc/os-release

# Your username and groups
whoami
groups
id

# Kerberos status
klist

# Network connectivity
ping dc1.cyberinabox.net
ip addr show

# Disk space
df -h
quota -s

# Recent logs (last 20 lines)
sudo journalctl -n 20

# Service status
systemctl status service_name
```

### Contact Methods

**Email Support (Non-Urgent):**
```
To: dshannon@cyberinabox.net
Subject: [HELP] Brief description

Include:
- What you were doing
- Error message (exact text)
- Steps to reproduce
- Your username
- System affected
- Diagnostics output (if available)

Response Time: 1 business day
```

**Security Issues (Urgent):**
```
To: security@cyberinabox.net
Subject: [SECURITY] Brief description

Do NOT:
- Delete files
- Shutdown systems
- Modify anything

DO:
- Document what you see
- Note the time
- Disconnect network if active attack
- Contact immediately

Response Time: 15 minutes
```

**Use AI Assistant:**
```bash
# SSH to any system
ssh username@dc1.cyberinabox.net

# Start Claude Code
claude

# Ask your question
You: I'm getting "Permission denied" when trying to access /mnt/shared

Claude: [Provides troubleshooting steps...]
```

---

## Quick Reference: Common Solutions

| Problem | Quick Fix |
|---------|-----------|
| **Cannot SSH** | Get Kerberos ticket: `kinit username` |
| **Permission denied** | Check groups: `groups`, get ticket: `kinit` |
| **Invalid OTP code** | Wait 30 seconds for new code |
| **Dashboard no data** | Refresh page, check time range |
| **File share unavailable** | Check mount, verify ticket: `klist` |
| **Slow performance** | Check during off-peak, contact admin |
| **Disk quota exceeded** | Clean up files: `du -sh ~/* \| sort -h` |
| **Service down** | Check status: `systemctl status service` |
| **Certificate error** | Contact administrator (don't bypass) |
| **Account locked** | Wait 30 min or contact admin |

---

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 10: Getting Help & Support
- Chapter 11: Accessing the Network
- Appendix C: Command Reference

**For More Help:**
- System Administrator: dshannon@cyberinabox.net
- Security Team: security@cyberinabox.net
- AI Assistant: Run `claude` via SSH
- Emergency: See Chapter 5 for emergency contacts
