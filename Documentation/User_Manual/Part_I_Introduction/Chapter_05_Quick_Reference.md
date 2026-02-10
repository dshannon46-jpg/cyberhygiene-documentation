# Chapter 5: Quick Reference Card

## 5.1 System Access Points

### Primary Dashboards
| Service | URL | Purpose |
|---------|-----|---------|
| **CPM Dashboard** | https://cpm.cyberinabox.net | System overview and compliance status |
| **Wazuh SIEM** | https://wazuh.cyberinabox.net | Security monitoring and alerts |
| **Grafana** | https://grafana.cyberinabox.net | System health and performance metrics |
| **Project Website** | https://cyberhygiene.cyberinabox.net | Public project information |
| **Graylog** | https://graylog.cyberinabox.net | Log analysis and search |

### Administrative Interfaces
| Service | Access Method | Purpose |
|---------|---------------|---------|
| **FreeIPA** | https://dc1.cyberinabox.net | User and identity management |
| **Prometheus** | https://dc1.cyberinabox.net:9091 | Metrics collection backend |
| **Suricata** | Via Grafana dashboard | IDS/IPS monitoring |

### Server Access
```bash
# Main server (SSH)
ssh username@dc1.cyberinabox.net

# With MFA
ssh username@dc1.cyberinabox.net
# (Enter password + OTP token)
```

## 5.2 Emergency Contacts

### Primary Contacts
- **System Administrator:** dshannon@cyberinabox.net
- **Security Team:** security@cyberinabox.net
- **Emergency Hotline:** (See IT contact list)

### Escalation Path
1. **Level 1:** Report to direct supervisor
2. **Level 2:** Contact system administrator
3. **Level 3:** Security team notification
4. **Level 4:** Management escalation

### Incident Reporting
- **Email:** security@cyberinabox.net
- **Subject Line:** [SECURITY] Brief description
- **Include:** Date, time, system affected, description

## 5.3 Common Tasks

### User Tasks

**Login to Server:**
```bash
ssh your-username@dc1.cyberinabox.net
```

**Access File Shares:**
```bash
# Mount Samba share
sudo mount -t cifs //dc1.cyberinabox.net/shared /mnt/shared \
  -o credentials=/etc/samba/credentials
```

**Check Your Disk Quota:**
```bash
quota -s
```

**Change Your Password:**
```bash
passwd
# Follow prompts for current and new password
```

**View Security Alerts:**
1. Navigate to https://wazuh.cyberinabox.net
2. Login with your credentials + MFA
3. Review "Security Events" dashboard

### Administrator Tasks

**Check System Status:**
```bash
# View all monitoring targets
curl -k https://dc1.cyberinabox.net:9091/api/v1/targets | jq '.data.activeTargets[].health'

# Check service status
systemctl status prometheus grafana-server wazuh-manager
```

**View Recent Suricata Alerts:**
```bash
sudo tail -f /var/log/suricata/eve.json | grep alert
```

**Check Backup Status:**
```bash
sudo /usr/local/bin/check-last-backup.sh
```

**Add New User:**
```bash
# Via FreeIPA
ipa user-add username --first=FirstName --last=LastName --email=user@domain.com
```

## 5.4 Troubleshooting Quick Guide

### Cannot Login via SSH

**Symptoms:** Connection refused or authentication failure

**Quick Fixes:**
1. Verify password and MFA token
2. Check if account is locked: `sudo faillock --user username`
3. Unlock if needed: `sudo faillock --user username --reset`
4. Check SSH service: `sudo systemctl status sshd`

**See:** Chapter 11, Section 11.1 for detailed SSH troubleshooting

### Dashboard Shows "No Data"

**Symptoms:** Grafana dashboard displays "No Data" message

**Quick Fixes:**
1. Check if Prometheus is running: `systemctl status prometheus`
2. Verify targets are up: Navigate to Prometheus UI → Status → Targets
3. Check datasource in Grafana: Configuration → Data Sources → Test
4. Restart Grafana if needed: `sudo systemctl restart grafana-server`

**See:** Chapter 19, Section 19.5 for dashboard troubleshooting

### Security Alert Received

**Symptoms:** Email or dashboard alert about security event

**Immediate Actions:**
1. **Do Not Panic** - Most alerts are informational
2. Note the alert time, system, and description
3. Check Wazuh dashboard for details
4. If critical (Severity 1-2): Contact security team immediately
5. If informational: Review and document

**See:** Chapter 25 for complete security reporting procedures

### Cannot Access File Share

**Symptoms:** "Permission denied" or "Connection refused"

**Quick Fixes:**
1. Verify you're connected to network: `ping dc1.cyberinabox.net`
2. Check credentials: `klist` (for Kerberos tickets)
3. Renew ticket if expired: `kinit username`
4. Verify share permissions with administrator

**See:** Chapter 12 for file sharing procedures

## 5.5 Important Commands

### Monitoring Commands

```bash
# Check system load
uptime

# View real-time resource usage
top
# (Press 'q' to quit)

# Check disk space
df -h

# View memory usage
free -h

# Check network connectivity
ping -c 3 dc1.cyberinabox.net

# View recent system logs
sudo journalctl -n 50 --no-pager
```

### Security Commands

```bash
# List your Kerberos tickets
klist

# Get new Kerberos ticket
kinit username

# Check failed login attempts
sudo faillock --user username

# View Suricata stats
sudo suricatasc -c "dump-counters"

# Check firewall status
sudo firewall-cmd --list-all
```

### Backup Commands

```bash
# Check last backup
sudo /usr/local/bin/check-last-backup.sh

# List available backups
ls -lh /datastore/backups/

# Verify backup integrity (admin only)
sudo /usr/local/bin/verify-backup.sh <backup-file>
```

### Service Management

```bash
# Check service status
systemctl status <service-name>

# Restart a service (admin only)
sudo systemctl restart <service-name>

# View service logs
sudo journalctl -u <service-name> -f
```

## Quick Command Reference Table

| Task | Command |
|------|---------|
| Login to server | `ssh username@dc1.cyberinabox.net` |
| Change password | `passwd` |
| Check Kerberos ticket | `klist` |
| Get new ticket | `kinit username` |
| View system load | `uptime` |
| Check disk space | `df -h` |
| View recent logs | `sudo journalctl -n 50` |
| Check service status | `systemctl status <service>` |
| View security alerts | Navigate to Wazuh dashboard |
| Check monitoring | Navigate to Grafana dashboard |

---

## Print This Page!

📄 **This Quick Reference Card is designed to be printed and kept at your workstation for easy access.**

---

**Related Chapters:**
- Chapter 10: Getting Help & Support
- Chapter 11: Accessing the Network
- Appendix C: Complete Command Reference
- Appendix D: Troubleshooting Guide

