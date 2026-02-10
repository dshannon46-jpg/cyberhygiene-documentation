# Chapter 32: Emergency Procedures

## 32.1 Emergency Contacts

### Primary Contacts

**System Administrator:**
```
Name: David Shannon
Email: dshannon@cyberinabox.net
Phone: [Contact information from Chapter 5]
Role: Primary technical contact
Availability: 24/7 for critical incidents
Response Time: <15 minutes for P1 incidents
```

**Security Team:**
```
Email: security@cyberinabox.net
Role: Security incident response
Availability: 24/7 for security events
Response Time: <15 minutes for critical security incidents
```

**Escalation Chain:**
```
Level 1: System Administrator
Level 2: Security Team
Level 3: Management
Level 4: Vendor Support (Red Hat, etc.)
```

### Emergency Classification

**Priority 1 (Critical - Immediate Response):**
```
- Complete system outage
- Active security breach
- Ransomware attack
- Data loss event
- Multiple system failures
- Authentication system down (FreeIPA)
- Critical vulnerability exploitation

Response Time: Immediate (< 15 minutes)
Notification: Phone + Email + SMS
Actions: All hands on deck
```

**Priority 2 (High - Urgent Response):**
```
- Single critical system down
- Service degradation
- Security alert level 12+
- Failed backup verification
- Certificate expiration
- Network connectivity issues

Response Time: < 1 hour
Notification: Email + Phone
Actions: Immediate investigation
```

**Priority 3 (Medium - Standard Response):**
```
- Non-critical service failure
- Performance degradation
- Security alerts level 7-11
- Disk space warning
- Update failures

Response Time: < 4 hours (business hours)
Notification: Email
Actions: Standard troubleshooting
```

## 32.2 System Recovery Procedures

### Complete System Failure

**Scenario: dc1.cyberinabox.net (FreeIPA) Down**

**Immediate Actions (0-15 minutes):**

```bash
# 1. Verify system is actually down
ping dc1.cyberinabox.net

# 2. Attempt SSH access
ssh admin@dc1.cyberinabox.net

# 3. If no response, access console
# - Physical access to server room, OR
# - Remote management (iLO/IPMI)

# 4. Check system status via console
# Look for:
# - Kernel panic
# - Filesystem corruption
# - Hardware failure
# - Service failures

# 5. Attempt reboot
sudo systemctl reboot

# Or from console:
# Ctrl+Alt+Del (soft reboot)
# If hung: Hard power cycle
```

**Recovery Steps (15-60 minutes):**

```bash
# If system boots but services don't start:

# 1. Check systemd status
sudo systemctl --failed

# 2. Check critical services
sudo systemctl status ipa
sudo systemctl status krb5kdc
sudo systemctl status named
sudo systemctl status httpd

# 3. Review logs
sudo journalctl -xe -p err

# 4. Attempt service restart
sudo ipactl restart

# If successful:
sudo ipactl status

# If fails, check specific service
sudo journalctl -u ipa -n 100
```

**Full System Restore (1-4 hours):**

```bash
# If system cannot be recovered, restore from backup

# 1. Boot from rescue media
# Boot system from Rocky Linux rescue ISO

# 2. Activate LVM volumes (if using LVM)
lvm vgscan
lvm vgchange -ay

# 3. Mount filesystems
mount /dev/mapper/rl-root /mnt
mount /dev/sda1 /mnt/boot

# 4. Restore from backup
rsync -avz /datastore/backups/daily/dc1/[latest]/ /mnt/

# 5. Restore FreeIPA database
# Copy IPA backup to /mnt/tmp/
ipa-restore /tmp/ipa-backup-[date] --data --online

# 6. Unmount and reboot
umount /mnt/boot /mnt
reboot

# 7. Verify after boot
sudo ipactl status
kinit admin
ipa user-show admin
```

### Authentication Failure Recovery

**Scenario: Cannot authenticate any users**

```bash
# Emergency Actions:

# 1. Verify FreeIPA is running
ssh root@dc1.cyberinabox.net  # Use root local access
sudo ipactl status

# 2. If IPA down, restart
sudo ipactl restart

# 3. Check Kerberos KDC
sudo systemctl status krb5kdc
sudo journalctl -u krb5kdc -n 50

# 4. Verify LDAP
ldapsearch -x -H ldaps://dc1.cyberinabox.net \
  -D "cn=Directory Manager" -W \
  -b "dc=cyberinabox,dc=net" "(uid=admin)"

# 5. Check client systems
# On client:
systemctl status sssd
sss_cache -E  # Clear cache
systemctl restart sssd

# 6. Emergency admin access
# If all else fails, use local root accounts on each system
# Never disable local root as emergency backup
```

### Data Loss Recovery

**Scenario: Critical data deleted or corrupted**

```bash
# Immediate Actions:

# 1. STOP - Don't make it worse
# - Don't continue using the system
# - Don't try to "fix" corrupted files
# - Don't run filesystem repair without backup

# 2. Identify scope of loss
# What was deleted?
ls -la /path/to/missing/data/

# When was it deleted?
sudo journalctl -S "2025-12-30" | grep deleted_file

# 3. Check if files in trash/tmp
find /tmp -name "deleted_file*"
find ~/.local/share/Trash -name "deleted_file*"

# 4. Restore from backup
/usr/local/bin/restore-file.sh username /path/to/file [date]

# 5. If not in backup, attempt recovery
# Stop writing to filesystem immediately
sudo systemctl stop application

# Use extundelete or testdisk (if XFS/ext4)
sudo extundelete /dev/sda1 --restore-file path/to/file

# 6. Verify restored data
diff restored_file original_backup

# 7. Put restored data in place
sudo cp restored_file /path/to/destination/
sudo chown user:group /path/to/destination/file
```

## 32.3 Security Incident Response

### Active Breach Response

**Scenario: Unauthorized access detected**

```bash
# IMMEDIATE ACTIONS (Do not delay)

# 1. CONTAIN
# Isolate compromised system(s)
sudo ip link set eth0 down  # Disconnect network

# Or via firewall:
sudo firewall-cmd --panic-on  # Block all network traffic

# 2. PRESERVE EVIDENCE
# Do NOT:
# - Delete files
# - Shutdown system (loses RAM contents)
# - Modify logs
# - Run antivirus scans yet

# DO:
# - Document everything with timestamps
# - Take screenshots
# - Create memory dump:
sudo dd if=/dev/mem of=/tmp/memory-dump-$(date +%Y%m%d-%H%M%S).img

# - Capture network connections:
sudo ss -tupn > /tmp/connections-$(date +%Y%m%d-%H%M%S).txt

# - List running processes:
ps auxf > /tmp/processes-$(date +%Y%m%d-%H%M%S).txt

# 3. NOTIFY
echo "Active security breach on $(hostname). System isolated. Awaiting forensics." | \
  mail -s "[CRITICAL] Security Breach - $(hostname)" security@cyberinabox.net

# 4. ASSESS
# Review logs for:
# - Unauthorized logins
# - Privilege escalation
# - Data access
# - Data exfiltration

sudo journalctl -S "2 hours ago" | grep -i "session opened"
sudo grep "sudo" /var/log/secure
sudo tail -1000 /var/log/audit/audit.log | grep AVC

# 5. WAIT FOR INSTRUCTIONS
# Do not proceed with cleanup until:
# - Security team approves
# - Forensics complete
# - Evidence preserved
```

### Ransomware Response

**Scenario: Ransomware encryption detected**

```bash
# CRITICAL - EVERY SECOND COUNTS

# 1. IMMEDIATE ISOLATION (30 seconds)
# Disconnect from network IMMEDIATELY
sudo ip link set eth0 down

# Shutdown other systems to prevent spread
for host in dc1 dms graylog proxy monitoring wazuh; do
  ssh admin@${host}.cyberinabox.net "sudo systemctl poweroff" &
done

# 2. IDENTIFY SCOPE (2 minutes)
# Which systems are affected?
# How many files encrypted?
find /home -name "*.encrypted" -o -name "*.locked" | wc -l

# Check ransom note
find / -name "README*" -o -name "*DECRYPT*" -o -name "*RANSOM*"

# 3. DO NOT PAY RANSOM
# Document ransom note but do not pay
# Paying does not guarantee decryption
# Paying funds criminal activity

# 4. NOTIFY (Immediate)
cat <<EOF | mail -s "[CRITICAL] RANSOMWARE ATTACK" security@cyberinabox.net
RANSOMWARE ATTACK DETECTED

Time: $(date)
System: $(hostname)
Encrypted Files: [count]
Ransom Note: [file path]

All systems isolated.
Beginning recovery procedures.

DO NOT PAY RANSOM.
EOF

# 5. RESTORE FROM BACKUP
# Use most recent clean backup (before encryption)

# Verify backup integrity first
sha256sum /datastore/backups/daily/dc1/[date]/checksum.txt

# Restore from backup
/usr/local/bin/restore-system.sh $(hostname) [last-clean-date]

# 6. POST-RECOVERY ACTIONS
# - Reset all passwords
# - Revoke all certificates
# - Review how ransomware entered
# - Update defenses
# - File incident report
```

### DDoS Attack Response

**Scenario: Network under attack**

```bash
# 1. IDENTIFY ATTACK
# Symptoms:
# - Extreme network traffic
# - Service unavailability
# - Slow response times

# Verify DDoS
sudo tcpdump -nn -c 1000 | awk '{print $3}' | sort | uniq -c | sort -nr | head -20

# 2. ENABLE FIREWALL PROTECTION
# Block source IPs
for ip in 203.0.113.45 203.0.113.46 203.0.113.47; do
  sudo firewall-cmd --add-rich-rule="rule family='ipv4' source address='${ip}' reject"
done

# Rate limit connections
sudo firewall-cmd --add-rich-rule='rule family="ipv4" service name="http" \
  limit value="100/m" accept'

# 3. CONTACT ISP/UPSTREAM
# Request upstream filtering if attack too large
# Provide:
# - Attack source IPs
# - Attack type (SYN flood, UDP flood, etc.)
# - Target services

# 4. ENABLE SURICATA IPS MODE
# Suricata can drop malicious packets
sudo sed -i 's/mode: ids/mode: ips/' /etc/suricata/suricata.yaml
sudo systemctl restart suricata

# 5. MONITOR AND ADJUST
sudo tail -f /var/log/suricata/fast.log
```

## 32.4 Disaster Recovery

### Site Loss Scenario

**Complete datacenter loss (fire, flood, power outage)**

```bash
# DISASTER RECOVERY ACTIVATION

# Phase 1: Assessment (0-1 hour)
# - Verify scope of disaster
# - Confirm primary site inaccessible
# - Assemble DR team
# - Activate offsite backup location

# Phase 2: Communication (1-2 hours)
# - Notify all users of outage
# - Provide estimated recovery time
# - Set up war room/communication channel

# Phase 3: Restore Critical Systems (2-6 hours)
# Priority order:
# 1. dc1 (FreeIPA, DNS, CA) - Authentication
# 2. wazuh (Security monitoring)
# 3. monitoring (Observability)
# 4. dms (File services)
# 5. graylog (Logging)
# 6. proxy (Network services)

# Phase 4: Restore Data (6-24 hours)
# - Pull from offsite backups
# - Verify data integrity
# - Restore to new infrastructure

# Phase 5: Testing (24-48 hours)
# - Verify all services operational
# - Test user authentication
# - Confirm data accessible
# - Performance testing

# Phase 6: Return to Production (48-72 hours)
# - Gradual user migration
# - Monitor for issues
# - Update documentation
# - Post-mortem analysis
```

**Detailed DR Restoration:**

```bash
#!/bin/bash
#
# Disaster Recovery - Restore all systems
# Run from DR location with access to offsite backups
#

set -euo pipefail

DR_LOCATION="/mnt/offsite-backups"
NEW_DC1_IP="192.168.2.10"  # DR network

echo "=== DISASTER RECOVERY ACTIVATION ==="
echo "Start Time: $(date)"

# 1. Restore dc1 (FreeIPA) - CRITICAL
echo "1. Restoring dc1 (FreeIPA)..."
# Deploy new dc1 VM/server at DR site
# Install minimal Rocky Linux 9

ssh root@${NEW_DC1_IP} "
  # Update system
  dnf upgrade -y

  # Install IPA server
  dnf install ipa-server ipa-server-dns -y

  # Restore IPA from backup
  ipa-restore ${DR_LOCATION}/dc1/ipa-backup-[latest] --data --online

  # Update IP addresses for DR network
  ipa dnsrecord-mod cyberinabox.net @ --a-rec=192.168.2.10
"

# 2. Verify IPA operational
echo "2. Verifying FreeIPA..."
kinit admin
ipa user-show admin || exit 1

# 3. Restore remaining systems
for system in wazuh monitoring dms graylog proxy; do
  echo "3. Restoring ${system}..."
  # Similar process for each system
  # rsync from backups, reconfigure for DR network
done

# 4. Update DNS for DR
echo "4. Updating DNS records..."
ipa dnsrecord-mod cyberinabox.net dc1 --a-rec=192.168.2.10
ipa dnsrecord-mod cyberinabox.net dms --a-rec=192.168.2.20
# ... etc for all systems

# 5. Notify users
echo "5. Notifying users of DR activation..."
cat <<EOF | mail -s "[DR ACTIVATED] Systems Restored" all-staff@cyberinabox.net
Disaster Recovery has been activated.

Primary site: UNAVAILABLE
DR site: ACTIVE
Services: Restored and operational

Access points:
- FreeIPA: https://dc1.cyberinabox.net (now at DR site)
- All services operational at DR location

Please report any issues to: dshannon@cyberinabox.net

DR activation time: $(date)
EOF

echo "=== DR ACTIVATION COMPLETE ==="
echo "End Time: $(date)"
```

## 32.5 Emergency Procedures Checklist

### Quick Reference Cards

**Emergency Response Card - System Down:**

```
┌─────────────────────────────────────────────┐
│ EMERGENCY: SYSTEM DOWN                      │
├─────────────────────────────────────────────┤
│ 1. Verify system actually down:             │
│    ping dc1.cyberinabox.net                 │
│                                              │
│ 2. Attempt access:                          │
│    ssh admin@dc1.cyberinabox.net            │
│                                              │
│ 3. Check console (if accessible)            │
│                                              │
│ 4. Attempt reboot:                          │
│    sudo systemctl reboot                    │
│                                              │
│ 5. If no response - Notify:                 │
│    security@cyberinabox.net                 │
│    Subject: [P1] System Down - [hostname]   │
│                                              │
│ 6. Check backup availability:               │
│    ls /datastore/backups/daily/dc1/         │
│                                              │
│ 7. Restore if needed:                       │
│    /usr/local/bin/restore-system.sh dc1     │
└─────────────────────────────────────────────┘
```

**Emergency Response Card - Security Breach:**

```
┌─────────────────────────────────────────────┐
│ EMERGENCY: SECURITY BREACH                  │
├─────────────────────────────────────────────┤
│ 1. ISOLATE system immediately:              │
│    sudo ip link set eth0 down               │
│                                              │
│ 2. PRESERVE evidence:                       │
│    DO NOT delete files                      │
│    DO NOT shutdown yet                      │
│    Take screenshots                         │
│                                              │
│ 3. CAPTURE state:                           │
│    ps auxf > /tmp/processes.txt             │
│    ss -tupn > /tmp/connections.txt          │
│                                              │
│ 4. NOTIFY immediately:                      │
│    security@cyberinabox.net                 │
│    Subject: [CRITICAL] Security Breach      │
│                                              │
│ 5. DOCUMENT everything:                     │
│    What you saw                             │
│    When you saw it                          │
│    What you did                             │
│                                              │
│ 6. WAIT for security team                  │
│    Do not clean up until approved           │
└─────────────────────────────────────────────┘
```

**Emergency Response Card - Ransomware:**

```
┌─────────────────────────────────────────────┐
│ EMERGENCY: RANSOMWARE                       │
├─────────────────────────────────────────────┤
│ EVERY SECOND COUNTS                         │
│                                              │
│ 1. DISCONNECT network NOW:                  │
│    sudo ip link set eth0 down               │
│                                              │
│ 2. SHUTDOWN other systems:                  │
│    Prevent spread to other machines         │
│                                              │
│ 3. DO NOT PAY RANSOM                        │
│                                              │
│ 4. NOTIFY:                                  │
│    security@cyberinabox.net                 │
│    Subject: [CRITICAL] RANSOMWARE           │
│                                              │
│ 5. RESTORE from last clean backup:          │
│    /usr/local/bin/restore-system.sh dc1 \   │
│      [date-before-infection]                │
│                                              │
│ 6. RESET all passwords after restore        │
│                                              │
│ 7. INVESTIGATE how ransomware entered       │
└─────────────────────────────────────────────┘
```

### Emergency Toolkit

**Essential Commands for Emergency:**

```bash
# System Status
systemctl --failed                    # Failed services
journalctl -xe -p err                 # Recent errors
df -h                                  # Disk space
free -h                                # Memory
uptime                                 # Load average

# Network
ip addr show                           # IP addresses
ss -tulpn                              # Listening ports
ping dc1.cyberinabox.net              # Connectivity
dig dc1.cyberinabox.net               # DNS resolution

# Authentication
kinit admin                            # Get Kerberos ticket
klist                                  # View tickets
sudo ipactl status                     # FreeIPA status

# Services
sudo systemctl restart httpd           # Restart service
sudo systemctl status ipa              # Service status
sudo journalctl -u ipa -f              # Follow service logs

# Emergency Isolation
sudo ip link set eth0 down             # Disconnect network
sudo firewall-cmd --panic-on           # Block all traffic
sudo systemctl poweroff                # Shutdown

# Recovery
/usr/local/bin/restore-system.sh dc1 [date]
/usr/local/bin/restore-file.sh user /path/to/file
```

---

**Emergency Procedures Quick Reference:**

**Emergency Contacts:**
- Administrator: dshannon@cyberinabox.net
- Security Team: security@cyberinabox.net
- Emergency Phone: [Chapter 5]

**Priority Levels:**
- **P1 (Critical):** < 15 min response - System outage, security breach
- **P2 (High):** < 1 hour - Service degradation, alerts
- **P3 (Medium):** < 4 hours - Non-critical issues

**System Down:**
```bash
1. ping [hostname]
2. ssh admin@[hostname]
3. Check console
4. sudo systemctl reboot
5. Notify security@cyberinabox.net
6. Restore if needed: /usr/local/bin/restore-system.sh [hostname]
```

**Security Breach:**
```bash
1. sudo ip link set eth0 down
2. Preserve evidence (don't delete anything)
3. ps auxf > /tmp/processes.txt
4. ss -tupn > /tmp/connections.txt
5. Email security@cyberinabox.net immediately
6. Wait for security team
```

**Ransomware:**
```bash
1. sudo ip link set eth0 down (IMMEDIATE)
2. Shutdown other systems
3. DO NOT PAY RANSOM
4. Email security@cyberinabox.net
5. Restore from clean backup
6. Reset all passwords
```

**Disaster Recovery:**
```bash
1. Assess scope
2. Activate DR plan
3. Restore dc1 (FreeIPA) first
4. Restore remaining systems
5. Update DNS for DR network
6. Notify users
7. Test everything
```

**Emergency Isolation:**
```bash
# Disconnect single system
sudo ip link set eth0 down

# Block all network traffic
sudo firewall-cmd --panic-on

# Shutdown system
sudo systemctl poweroff
```

**Emergency Recovery:**
```bash
# Restore full system
/usr/local/bin/restore-system.sh [hostname] [date]

# Restore single file
/usr/local/bin/restore-file.sh [user] [file] [date]

# Restart critical services
sudo ipactl restart
sudo systemctl restart wazuh-manager
```

---

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 22: Incident Response
- Chapter 23: Backup & Recovery
- Chapter 29: Backup Procedures (Admin)
- Chapter 31: Security Updates & Patching
- Appendix D: Troubleshooting Guide

**Emergency Resources:**
- Backup Location: /datastore/backups/
- Offsite Backups: [Location TBD]
- Recovery Scripts: /usr/local/bin/
- Emergency Logs: /var/log/emergency/
- DR Documentation: [To be created in Phase II]

**For Help:**
- System Issues: dshannon@cyberinabox.net
- Security Issues: security@cyberinabox.net
- Emergency: See Chapter 5 for contact info
