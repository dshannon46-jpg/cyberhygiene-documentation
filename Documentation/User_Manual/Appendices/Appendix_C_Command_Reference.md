# Appendix C: Command Reference

## Authentication & Access

### Kerberos Commands

```bash
# Get a Kerberos ticket
kinit username@CYBERINABOX.NET
# Or just:
kinit username

# List current tickets
klist

# Detailed ticket information
klist -f

# Renew ticket before expiry
kinit -R

# Destroy all tickets (logout)
kdestroy

# Get ticket with specific lifetime (8 hours)
kinit -l 8h username

# Change Kerberos password
kpasswd
```

### Password Management

```bash
# Change your password
passwd

# Check password expiry
chage -l username

# View account status
passwd -S username

# Force password change on next login (admin only)
sudo passwd -e username
```

### SSH Commands

```bash
# Basic SSH connection
ssh username@hostname

# SSH with specific key
ssh -i ~/.ssh/id_ed25519 username@hostname

# SSH with verbose output (troubleshooting)
ssh -v username@hostname
# Very verbose:
ssh -vvv username@hostname

# Run single command via SSH
ssh username@hostname 'command here'

# SSH with port forwarding
ssh -L local_port:remote_host:remote_port username@hostname

# Copy SSH public key to server (manual)
cat ~/.ssh/id_ed25519.pub
# Then upload via FreeIPA web interface

# Generate new SSH key
ssh-keygen -t ed25519 -C "your_email@cyberinabox.net"

# Check SSH service status
systemctl status sshd
```

## File Operations

### File Transfer

```bash
# SCP: Copy file TO server
scp /local/file.txt username@host:/remote/path/

# SCP: Copy file FROM server
scp username@host:/remote/file.txt /local/path/

# SCP: Copy directory (recursive)
scp -r /local/directory username@host:/remote/path/

# SFTP: Interactive session
sftp username@hostname
# SFTP commands: ls, cd, get, put, quit

# Rsync: Sync directories
rsync -avz /local/dir/ username@host:/remote/dir/

# Rsync: Sync with progress
rsync -avz --progress /local/dir/ username@host:/remote/dir/
```

### File Permissions

```bash
# List file permissions
ls -l filename

# Change permissions (numeric)
chmod 644 file.txt     # rw-r--r--
chmod 755 script.sh    # rwxr-xr-x
chmod 600 private.key  # rw-------

# Change permissions (symbolic)
chmod u+x script.sh    # Add execute for user
chmod go-w file.txt    # Remove write for group/others

# Change ownership
sudo chown username:groupname file.txt

# Change ownership recursively
sudo chown -R username:groupname /directory/

# View file ACLs (extended permissions)
getfacl filename

# Set file ACLs
setfacl -m u:username:rwx filename
```

### File Search

```bash
# Find files by name
find /path -name "filename"

# Find files by type
find /path -type f         # Regular files
find /path -type d         # Directories

# Find files modified in last 7 days
find /path -mtime -7

# Find files larger than 100MB
find /path -size +100M

# Find and execute command
find /path -name "*.log" -exec rm {} \;

# Locate file in database (faster)
locate filename
```

## Network Operations

### Network Connectivity

```bash
# Ping host (test connectivity)
ping -c 4 hostname

# Trace route to host
traceroute hostname

# Check DNS resolution
nslookup hostname
dig hostname

# Check specific DNS server
dig @192.168.1.10 hostname

# Reverse DNS lookup
dig -x 192.168.1.10

# Test TCP port connectivity
telnet hostname port
# Or:
nc -zv hostname port

# Show network interfaces
ip addr show
# Or:
ifconfig

# Show routing table
ip route show
# Or:
netstat -rn
```

### File Sharing / Mounting

```bash
# Mount NFS share with Kerberos
sudo mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared

# Mount Samba share
sudo mount -t cifs //dms.cyberinabox.net/shared /mnt/shared -o credentials=/etc/samba/creds

# Unmount
sudo umount /mnt/shared

# Show mounted filesystems
mount | grep cyberinabox
# Or:
df -h

# Check NFS exports on server
showmount -e dms.cyberinabox.net
```

## System Monitoring

### System Information

```bash
# System uptime and load average
uptime

# System information
uname -a

# OS release information
cat /etc/os-release

# CPU information
lscpu

# Memory information
free -h

# Disk usage summary
df -h

# Disk usage for directory
du -sh /path/to/directory
du -h --max-depth=1 /path/

# Disk I/O statistics
iostat -x 1

# Network statistics
netstat -i
# Or:
ip -s link
```

### Process Management

```bash
# List all processes
ps aux

# List processes for current user
ps -u username

# Find process by name
ps aux | grep process_name
# Or:
pgrep process_name

# Interactive process viewer
top

# Improved process viewer
htop

# Kill process by PID
kill PID

# Force kill process
kill -9 PID

# Kill process by name
pkill process_name

# View process tree
pstree

# Show open files for process
lsof -p PID
```

### Service Management (systemd)

```bash
# Check service status
systemctl status service_name

# Start service
sudo systemctl start service_name

# Stop service
sudo systemctl stop service_name

# Restart service
sudo systemctl restart service_name

# Reload service configuration
sudo systemctl reload service_name

# Enable service (start at boot)
sudo systemctl enable service_name

# Disable service
sudo systemctl disable service_name

# List all services
systemctl list-units --type=service

# List failed services
systemctl --failed

# View service logs
journalctl -u service_name

# Follow service logs
journalctl -u service_name -f
```

## Log Management

### Viewing Logs

```bash
# View system log
sudo journalctl

# View last 50 lines
sudo journalctl -n 50

# View logs since boot
sudo journalctl -b

# View logs for specific service
sudo journalctl -u sshd

# Follow logs (real-time)
sudo journalctl -f

# View logs for specific user
sudo journalctl _UID=1000

# View logs in specific time range
sudo journalctl --since "2025-12-31 10:00" --until "2025-12-31 11:00"

# View auth logs
sudo tail -f /var/log/secure

# View all logs in /var/log
sudo ls -lht /var/log/

# Search logs with grep
sudo grep "error" /var/log/messages
```

### Log Analysis

```bash
# Count occurrences in log
sudo grep "failed" /var/log/secure | wc -l

# Extract unique IPs from log
sudo grep "Failed password" /var/log/secure | awk '{print $11}' | sort | uniq -c

# Find errors in last 100 lines
sudo tail -n 100 /var/log/messages | grep -i error

# Show only errors from journalctl
sudo journalctl -p err

# Export journalctl to file
sudo journalctl --since today > /tmp/today-logs.txt
```

## FreeIPA Management

### User Management

```bash
# Add user (requires admin)
ipa user-add username --first=First --last=Last --email=user@cyberinabox.net

# Delete user
ipa user-del username

# Modify user
ipa user-mod username --email=newemail@cyberinabox.net

# Show user details
ipa user-show username

# List all users
ipa user-find

# Disable user
ipa user-disable username

# Enable user
ipa user-enable username

# Reset user password
ipa user-mod username --password
```

### Group Management

```bash
# Create group
ipa group-add groupname --desc="Group description"

# Add user to group
ipa group-add-member groupname --users=username

# Remove user from group
ipa group-remove-member groupname --users=username

# Show group details
ipa group-show groupname

# List groups
ipa group-find
```

## Security & Compliance

### Firewall Management

```bash
# Check firewall status
sudo firewall-cmd --state

# List all rules
sudo firewall-cmd --list-all

# List allowed services
sudo firewall-cmd --list-services

# Add service (temporary)
sudo firewall-cmd --add-service=http

# Add service (permanent)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

# Add port
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Remove service
sudo firewall-cmd --permanent --remove-service=http
sudo firewall-cmd --reload

# Block IP address
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="203.0.113.45" reject'
sudo firewall-cmd --reload
```

### Account Lockout

```bash
# Check if user is locked
sudo faillock --user username

# Unlock user account
sudo faillock --user username --reset

# View all locked accounts
sudo faillock
```

### SELinux

```bash
# Check SELinux status
getenforce

# Set SELinux mode
sudo setenforce Enforcing
sudo setenforce Permissive

# View SELinux denials
sudo ausearch -m avc -ts recent

# View SELinux context
ls -Z filename

# Change SELinux context
sudo chcon -t httpd_sys_content_t /var/www/html/file.html

# Restore default context
sudo restorecon -v filename
```

### File Integrity

```bash
# Initialize AIDE database
sudo aide --init

# Check for changes
sudo aide --check

# Update database
sudo aide --update
```

## Backup & Recovery

### Backup Commands

```bash
# Create tar archive
tar -czf backup.tar.gz /path/to/directory

# Create tar archive with exclusions
tar -czf backup.tar.gz --exclude='*.tmp' /path/to/directory

# Extract tar archive
tar -xzf backup.tar.gz

# List contents of archive
tar -tzf backup.tar.gz

# Verify archive integrity
tar -tzf backup.tar.gz > /dev/null

# Create encrypted backup
tar -czf - /path/to/directory | gpg -c > backup.tar.gz.gpg

# Restore encrypted backup
gpg -d backup.tar.gz.gpg | tar -xzf -
```

### Rsync Backup

```bash
# Backup with rsync
rsync -avz --delete /source/ /backup/destination/

# Backup to remote server
rsync -avz /source/ username@backup-server:/backup/destination/

# Backup with exclusions
rsync -avz --exclude='*.tmp' --exclude='.cache' /source/ /backup/

# Dry run (test without changes)
rsync -avz --dry-run /source/ /backup/
```

## Performance Analysis

### CPU & Memory

```bash
# CPU usage (real-time)
top
# Press '1' to show all CPUs
# Press 'q' to quit

# Memory usage
free -h

# Detailed memory info
cat /proc/meminfo

# Check for memory leaks
ps aux --sort=-%mem | head -n 10

# CPU info
lscpu
cat /proc/cpuinfo
```

### Disk Performance

```bash
# Disk I/O stats
iostat -x 1 5

# I/O wait time
top
# Look at 'wa' in CPU stats

# Disk usage by directory
du -sh /* | sort -h

# Find large files
find / -type f -size +100M -exec ls -lh {} \;

# Check disk health
sudo smartctl -a /dev/sda
```

## Package Management (DNF)

```bash
# Update package cache
sudo dnf check-update

# Install package
sudo dnf install package_name

# Remove package
sudo dnf remove package_name

# Update all packages
sudo dnf update

# Search for package
dnf search keyword

# Show package info
dnf info package_name

# List installed packages
dnf list installed

# List available updates
dnf list updates

# Clean cache
sudo dnf clean all
```

## Quick Troubleshooting

### Connection Issues

```bash
# Diagnose SSH connection
ssh -vvv username@hostname 2>&1 | grep -i "debug\|error"

# Check if service is listening
sudo ss -tulpn | grep :22

# Test DNS resolution
nslookup hostname
host hostname

# Check firewall
sudo firewall-cmd --list-all | grep ssh
```

### Permission Issues

```bash
# Check file permissions
ls -l filename

# Check file ownership
ls -l filename

# Check SELinux context
ls -Z filename

# Check ACLs
getfacl filename

# Test file access
sudo -u username test -r filename && echo "Can read" || echo "Cannot read"
```

### Service Issues

```bash
# Check service status
systemctl status service_name

# View service logs
journalctl -u service_name -n 50

# Restart service
sudo systemctl restart service_name

# Check service dependencies
systemctl list-dependencies service_name
```

---

## Command Aliases

**Add to ~/.bashrc:**

```bash
# System info
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Disk usage
alias df='df -h'
alias du='du -h'
alias ducks='du -sh * | sort -h'

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Network
alias ports='sudo netstat -tulpn'
alias myip='curl -s ifconfig.me'

# Logs
alias syslog='sudo journalctl -f'
alias authlog='sudo tail -f /var/log/secure'

# CyberHygiene specific
alias ssh-dc='ssh username@dc1.cyberinabox.net'
alias ssh-dms='ssh username@dms.cyberinabox.net'
alias kget='kinit username@CYBERINABOX.NET'
alias kcheck='klist'
```

---

**Related Appendices:**
- Appendix A: Glossary of Terms
- Appendix B: Service URLs & Access Points
- Appendix D: Troubleshooting Guide

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 11: Accessing the Network
- Chapter 15: Working with AI Assistant

**For Command Help:**
- Manual pages: `man command_name`
- Command help: `command_name --help`
- Ask AI assistant: Run `llama` or `ai` and ask for command syntax
- Online resources: https://man7.org/ (Linux man pages)

**Remember:**
- Always test commands in safe environment first
- Use `sudo` with caution
- Read error messages carefully
- Ask for help if unsure: dshannon@cyberinabox.net
