# VNC Remote Desktop Setup - dc1.cyberinabox.net

**Date:** 2026-01-11
**Server:** dc1.cyberinabox.net (192.168.1.10)
**VNC Port:** 5900
**Security:** Local network only (192.168.1.0/24)

## Overview

Configured TigerVNC server on dc1 to allow remote desktop access from local network devices (Mac, Windows, Linux) using the VNC protocol on standard port 5900.

## Security Configuration (NIST 800-171 Compliant)

### Network Access Restrictions

**Firewall Rule:**
```bash
rule family="ipv4" source address="192.168.1.0/24" port port="5900" protocol="tcp" accept
```

**Security Features:**
- ✓ Access restricted to 192.168.1.0/24 network ONLY
- ✓ No external access allowed
- ✓ SELinux enforcing with VNC policy enabled
- ✓ Separate VNC password (not your Linux password)
- ✓ FIPS mode compatible

### NIST 800-171 Compliance Notes

**AC-17: Remote Access**
- VNC access restricted to internal network only (192.168.1.0/24)
- Firewall enforces access controls
- Separate authentication (VNC password)

**SC-8: Transmission Confidentiality**
- **Note:** VNC protocol itself is NOT encrypted
- **Mitigation:** Access restricted to trusted internal network only
- **Alternative:** Can use SSH tunnel for encryption if needed

**IA-2: Identification and Authentication**
- Requires VNC password authentication
- Password stored securely in ~/.vnc/passwd
- Separate from system credentials

## Installation Details

### Packages Installed
```
tigervnc-server-1.15.0-6.el9_7.x86_64
tigervnc-server-minimal-1.15.0-6.el9_7.x86_64
tigervnc-selinux-1.15.0-6.el9_7.noarch
tigervnc-license-1.15.0-6.el9_7.noarch
dbus-x11-1:1.12.20-8.el9.x86_64
```

### System Configuration

**Service:** xvnc.socket
- **Status:** Enabled and active (listening)
- **Listens on:** [::]:5900 (all interfaces, port 5900)
- **Type:** Socket-activated service
- **Description:** Spawns VNC session on-demand when client connects

**SELinux:**
- `xdm_bind_vnc_tcp_port` → on (enabled permanently)
- tigervnc-selinux policy installed and active

**VNC Configuration:** `/home/dshannon/.vnc/config`
```
# TigerVNC Configuration File
session=gnome
geometry=1920x1080
alwaysshared
```

## User Setup

### Setting VNC Password

**IMPORTANT:** Each user must set their own VNC password.

```bash
vncpasswd
```

This creates `/home/dshannon/.vnc/passwd` with encrypted password.

**Notes:**
- VNC password is separate from Linux password
- Recommended: 6-8 characters
- Password is stored encrypted in ~/.vnc/passwd
- Password is specific to VNC connections only

### VNC User Directory

Location: `/home/dshannon/.vnc/`

Files:
- `config` - VNC server configuration
- `passwd` - Encrypted VNC password (created by vncpasswd)
- `*.log` - Session logs (created when connecting)
- `*.pid` - Process ID files (created when connecting)

## Connecting from Client Devices

### From Mac

**Option 1: Screen Sharing (Built-in)**
1. Press `Command+K` in Finder
2. Enter: `vnc://192.168.1.10:5900`
3. Click Connect
4. Enter VNC password when prompted

**Option 2: Safari/Browser**
- Type in address bar: `vnc://192.168.1.10:5900`

**Option 3: VNC Viewer App**
- Download RealVNC Viewer or similar
- Server: `192.168.1.10:5900`
- Password: Your VNC password

### From Windows

**Download VNC Viewer:**
- RealVNC Viewer: https://www.realvnc.com/en/connect/download/viewer/
- TightVNC Viewer: https://www.tightvnc.com/download.php

**Connection:**
- Server: `192.168.1.10:5900`
- Password: Your VNC password

### From Linux

**Using Remmina:**
```bash
remmina -c vnc://192.168.1.10:5900
```

**Using vncviewer:**
```bash
vncviewer 192.168.1.10:5900
```

## Performance Comparison

### vs. iLO Remote Console

**iLO Advantages:**
- Works even if OS crashed
- Hardware-level access
- BIOS configuration

**VNC Advantages:**
- ✓ Much faster response time
- ✓ Better graphics performance
- ✓ Native desktop experience
- ✓ Lower latency

**Recommendation:** Use VNC for normal remote desktop work, iLO for emergency access or BIOS configuration.

## Technical Details

### Port Information

- **VNC Port:** 5900 (standard VNC display :0)
- **Protocol:** RFB (Remote Framebuffer)
- **Transport:** TCP
- **Encryption:** None (relies on network security)

### Display Configuration

- **Resolution:** 1920x1080 (configurable in ~/.vnc/config)
- **Desktop Environment:** GNOME
- **Shared Desktop:** Enabled (multiple viewers allowed)

## Firewall Configuration

### View Current Rule
```bash
sudo firewall-cmd --list-rich-rules | grep 5900
```

### Rule Details
```
rule family="ipv4" source address="192.168.1.0/24" port port="5900" protocol="tcp" accept
```

**Effect:**
- Accepts TCP connections on port 5900
- ONLY from 192.168.1.0/24 subnet
- Blocks all other sources

### Testing Firewall

**From allowed network (192.168.1.x):**
```bash
nc -zv 192.168.1.10 5900
# Should show: Connection succeeded
```

**From external network:**
- Connection will be blocked by firewall
- No response or timeout

## Service Management

### Check Service Status
```bash
systemctl status xvnc.socket
```

### Stop VNC Service
```bash
sudo systemctl stop xvnc.socket
```

### Start VNC Service
```bash
sudo systemctl start xvnc.socket
```

### Disable VNC Service
```bash
sudo systemctl disable xvnc.socket
sudo systemctl stop xvnc.socket
```

### View Active VNC Sessions
```bash
ps aux | grep Xvnc
```

### View VNC Logs
```bash
ls -la ~/.vnc/*.log
tail -f ~/.vnc/*.log
```

## Troubleshooting

### Cannot Connect

**Check 1: Service Running**
```bash
sudo systemctl status xvnc.socket
sudo netstat -tlnp | grep 5900
```

**Check 2: Firewall Rule**
```bash
sudo firewall-cmd --list-rich-rules | grep 5900
```

**Check 3: VNC Password Set**
```bash
ls -la ~/.vnc/passwd
```
If file doesn't exist, run `vncpasswd`

**Check 4: SELinux**
```bash
getsebool xdm_bind_vnc_tcp_port
# Should show: on
```

### Connection Refused

- Verify you're on 192.168.1.0/24 network
- Check if VNC password is set (`ls ~/.vnc/passwd`)
- Check service: `systemctl status xvnc.socket`

### Slow Performance

- Check network connection
- Reduce resolution in ~/.vnc/config
- Close unnecessary applications on dc1

### Black Screen or No Desktop

**Edit** `~/.vnc/config` and ensure:
```
session=gnome
```

Then reconnect.

## Security Recommendations

### Current Security Posture

✓ **Good:**
- Network restricted to local subnet only
- Firewall enforced
- SELinux enabled
- Separate VNC authentication

⚠ **Considerations:**
- VNC traffic is unencrypted
- Password transmitted in encoded (not encrypted) form

### Enhanced Security (Optional)

**Option 1: SSH Tunnel (Most Secure)**

For maximum security, use SSH tunnel to encrypt VNC:

**From Mac/Linux:**
```bash
ssh -L 5901:localhost:5900 dc1.cyberinabox.net
# Then connect VNC to: localhost:5901
```

**From Windows:**
- Use PuTTY to create SSH tunnel
- Local port: 5901
- Remote: localhost:5900
- Then connect VNC to localhost:5901

**Option 2: VPN Access**
- Configure WireGuard or OpenVPN
- Access only via VPN tunnel

### Password Management

- Store VNC password in KeePass
- Different from Linux password
- Rotate periodically (quarterly recommended)
- Use strong password (avoid dictionary words)

## Files and Directories

### System Files
- `/usr/lib/systemd/system/xvnc.socket` - Socket unit file
- `/usr/lib/systemd/system/xvnc@.service` - Service template
- `/usr/bin/Xvnc` - VNC server binary
- `/etc/tigervnc/vncserver.users` - User mapping (if used)

### User Files
- `~/.vnc/config` - User VNC configuration
- `~/.vnc/passwd` - Encrypted VNC password
- `~/.vnc/*.log` - Session logs
- `~/.vnc/*.pid` - Process ID files

## Monitoring and Logging

### View Active Connections
```bash
ss -tnp | grep :5900
```

### View Session Logs
```bash
tail -f ~/.vnc/*.log
```

### View System Logs
```bash
sudo journalctl -u xvnc.socket -f
sudo journalctl -u xvnc@* -f
```

## Integration with Other Systems

### FreeIPA
- VNC uses local Linux credentials for desktop session
- FreeIPA user (dshannon) can log in via VNC
- Kerberos SSO works after VNC authentication

### Wazuh Monitoring
- Can add Wazuh rules to monitor VNC connections
- Log file: `~/.vnc/*.log`
- Monitor for failed authentication attempts

## Backup and Recovery

### Backup VNC Configuration
```bash
cp ~/.vnc/config ~/Documents/vnc-config-backup.txt
```

### Recreate VNC Password
```bash
vncpasswd
```

## Uninstallation (If Needed)

```bash
# Stop and disable service
sudo systemctl stop xvnc.socket
sudo systemctl disable xvnc.socket

# Remove firewall rule
sudo firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="192.168.1.0/24" port port="5900" protocol="tcp" accept'
sudo firewall-cmd --reload

# Uninstall packages
sudo dnf remove tigervnc-server tigervnc-server-minimal

# Remove user configuration
rm -rf ~/.vnc/
```

## Related Documentation

- **Hardware Specifications:** `/home/dshannon/Documents/Technical_Documentation/Hardware_Specifications.md`
- **iLO Management:** `/home/dshannon/Documents/ilo-ip-address-update.md`
- **Website Inventory:** `/home/dshannon/Documents/dc1-hosted-websites.md`

## Change Log

### 2026-01-11 - Initial Setup
- Installed TigerVNC server 1.15.0
- Configured xvnc.socket on port 5900
- Enabled SELinux VNC policy
- Created firewall rule (192.168.1.0/24 only)
- Created VNC configuration for GNOME desktop
- Documented NIST 800-171 compliance considerations

## Support and Contact

**Administrator:** don@contract-coach.com
**Server:** dc1.cyberinabox.net
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)

---

**Status:** ✓ Configured and Ready
**Last Updated:** 2026-01-11
**VNC Server Version:** TigerVNC 1.15.0
**Security Level:** Internal Network Only (NIST 800-171 Compliant)
