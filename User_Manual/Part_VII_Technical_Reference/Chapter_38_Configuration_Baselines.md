# Chapter 38: Configuration Baselines

## 38.1 Security Baseline Overview

### NIST 800-171 Security Configuration

**System-Wide Security Baseline:**
```
Operating System: Rocky Linux 9.5
Security Profile: NIST 800-171 Rev 2
Compliance: 110/110 controls (100%)
FIPS Mode: Enabled (FIPS 140-2)
SELinux: Enforcing mode
Audit: Comprehensive logging enabled

Key Security Features:
  ✓ FIPS 140-2 validated cryptography
  ✓ Mandatory Access Control (SELinux)
  ✓ File integrity monitoring (AIDE)
  ✓ Audit logging (auditd)
  ✓ Firewall (firewalld - default deny)
  ✓ Intrusion detection (Wazuh + Suricata)
  ✓ Malware scanning (ClamAV + YARA)
  ✓ Centralized authentication (Kerberos/LDAP)
```

### Configuration Management

**Tools and Methods:**
```
Version Control: Git repository
Backup Frequency: Daily
Configuration Validation: Automated checks
Change Management: Documented in git commits
Rollback: Via backup restoration

Critical Configuration Locations:
  /etc/                     # System configuration
  /var/ossec/etc/           # Wazuh configuration
  /etc/prometheus/          # Monitoring configuration
  /etc/grafana/             # Grafana configuration
  /etc/httpd/               # Web server configuration
  /var/kerberos/krb5kdc/    # Kerberos configuration
```

## 38.2 Network Configuration Baseline

### Network Interface Configuration

**Standard Network Settings:**
```bash
# /etc/sysconfig/network-scripts/ifcfg-eth0 (typical)
TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.1.X        # System-specific
PREFIX=24
GATEWAY=192.168.1.1
DNS1=192.168.1.10         # dc1.cyberinabox.net
DOMAIN=cyberinabox.net
```

**Hostname Configuration:**
```bash
# /etc/hostname
dc1.cyberinabox.net       # System-specific

# /etc/hosts
127.0.0.1   localhost localhost.localdomain
::1         localhost localhost.localdomain
192.168.1.10   dc1.cyberinabox.net dc1
# Additional entries for all systems
```

### DNS Configuration

**Client DNS Settings:**
```bash
# /etc/resolv.conf (managed by NetworkManager)
search cyberinabox.net
nameserver 192.168.1.10    # dc1 primary DNS
options timeout:2
options attempts:3
```

**DNS Server Configuration (dc1):**
```bash
# /etc/named.conf
options {
    listen-on port 53 { 127.0.0.1; 192.168.1.10; };
    listen-on-v6 { none; };
    directory       "/var/named";
    dump-file       "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";

    recursion yes;
    allow-query { 192.168.1.0/24; localhost; };
    allow-transfer { none; };

    dnssec-enable yes;
    dnssec-validation yes;

    forwarders {
        8.8.8.8;    # Google DNS (when internet available)
        1.1.1.1;    # Cloudflare DNS
    };

    managed-keys-directory "/var/named/dynamic";
    pid-file "/run/named/named.pid";
    session-keyfile "/run/named/session.key";
};

zone "cyberinabox.net" IN {
    type master;
    file "data/cyberinabox.net.zone";
    allow-update { none; };
};

zone "1.168.192.in-addr.arpa" IN {
    type master;
    file "data/1.168.192.in-addr.arpa.zone";
    allow-update { none; };
};
```

### Firewall Configuration

**Standard Firewall Rules:**
```bash
# Default policy: Reject all incoming, allow established
firewall-cmd --set-default-zone=public
firewall-cmd --zone=public --set-target=REJECT

# Allow SSH (all systems)
firewall-cmd --permanent --add-service=ssh

# System-specific services
# dc1:
firewall-cmd --permanent --add-service=kerberos
firewall-cmd --permanent --add-service=ldaps
firewall-cmd --permanent --add-service=dns
firewall-cmd --permanent --add-service=https

# wazuh:
firewall-cmd --permanent --add-port=1514/tcp  # Agent communication
firewall-cmd --permanent --add-port=55000/tcp # Wazuh API

# monitoring:
firewall-cmd --permanent --add-port=9091/tcp  # Prometheus
firewall-cmd --permanent --add-port=3001/tcp  # Grafana

# All systems:
firewall-cmd --permanent --add-port=9100/tcp  # Node Exporter

# Reload
firewall-cmd --reload
```

### Time Synchronization

**Chrony Configuration:**
```bash
# /etc/chrony.conf
server pool.ntp.org iburst    # When internet available
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
logdir /var/log/chrony

# For time server (dc1)
allow 192.168.1.0/24
local stratum 10
```

## 38.3 Authentication Baseline

### Kerberos Configuration

**Client Configuration:**
```bash
# /etc/krb5.conf
[libdefaults]
    default_realm = CYBERINABOX.NET
    dns_lookup_realm = true
    dns_lookup_kdc = true
    rdns = false
    dns_canonicalize_hostname = false
    ticket_lifetime = 8h
    renew_lifetime = 7d
    forwardable = true
    udp_preference_limit = 0
    default_ccache_name = KEYRING:persistent:%{uid}

[realms]
    CYBERINABOX.NET = {
        kdc = dc1.cyberinabox.net:88
        master_kdc = dc1.cyberinabox.net:88
        admin_server = dc1.cyberinabox.net:749
        default_domain = cyberinabox.net
        pkinit_anchors = FILE:/etc/ipa/ca.crt
    }

[domain_realm]
    .cyberinabox.net = CYBERINABOX.NET
    cyberinabox.net = CYBERINABOX.NET
```

**KDC Configuration (dc1):**
```bash
# /var/kerberos/krb5kdc/kdc.conf
[kdcdefaults]
    kdc_ports = 88
    kdc_tcp_ports = 88

[realms]
    CYBERINABOX.NET = {
        master_key_type = aes256-cts
        acl_file = /var/kerberos/krb5kdc/kadm5.acl
        dict_file = /usr/share/dict/words
        admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
        max_life = 8h 0m 0s
        max_renewable_life = 7d 0h 0m 0s
        default_principal_flags = +preauth
        supported_enctypes = aes256-cts:normal aes128-cts:normal
    }
```

### SSSD Configuration

**System Security Services Daemon:**
```bash
# /etc/sssd/sssd.conf
[sssd]
config_file_version = 2
services = nss, sudo, pam, ssh
domains = cyberinabox.net

[domain/cyberinabox.net]
cache_credentials = True
krb5_store_password_if_offline = True
ipa_domain = cyberinabox.net
id_provider = ipa
auth_provider = ipa
access_provider = ipa
ipa_hostname = hostname.cyberinabox.net
chpass_provider = ipa
ipa_server = dc1.cyberinabox.net
ldap_tls_cacert = /etc/ipa/ca.crt
use_fully_qualified_names = False

[nss]
homedir_substring = /home

[pam]
offline_credentials_expiration = 7

[sudo]

[autofs]

[ssh]

[pac]
```

### PAM Configuration

**Password Authentication Modules:**
```bash
# /etc/pam.d/system-auth (standard)
auth        required      pam_env.so
auth        required      pam_faildelay.so delay=2000000
auth        required      pam_faillock.so preauth silent audit deny=5 unlock_time=900
auth        sufficient    pam_sss.so forward_pass
auth        required      pam_faillock.so authfail audit deny=5 unlock_time=900
auth        required      pam_deny.so

account     required      pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     [default=bad success=ok user_unknown=ignore] pam_sss.so
account     required      pam_permit.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_sss.so use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session    optional      pam_systemd.so
session     optional      pam_oddjob_mkhomedir.so umask=0077
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
session     optional      pam_sss.so
```

### Password Policy

**System Password Requirements:**
```bash
# /etc/security/pwquality.conf
minlen = 14
dcredit = -1      # At least 1 digit
ucredit = -1      # At least 1 uppercase
ocredit = -1      # At least 1 special char
lcredit = -1      # At least 1 lowercase
minclass = 4      # All character classes
maxrepeat = 3     # Max consecutive characters
maxsequence = 3   # Max sequential characters
gecoscheck = 1    # Check against GECOS field
dictcheck = 1     # Check against dictionary
usercheck = 1     # Check against username
enforcing = 1     # Enforce for root
retry = 3         # Retry attempts
```

**FreeIPA Password Policy:**
```bash
# View policy
ipa pwpolicy-show

# Global policy settings
Minimum password lifetime: 1 day
Maximum password lifetime: 90 days
Minimum length: 14 characters
Character classes: 4
Failure count interval: 60 seconds
Max failures: 6
Lockout duration: 15 minutes
History size: 24 passwords
```

## 38.4 Security Hardening Baseline

### SELinux Configuration

**SELinux Settings:**
```bash
# /etc/selinux/config
SELINUX=enforcing
SELINUXTYPE=targeted

# Verify status
sestatus

# Expected output:
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
```

**Common SELinux Contexts:**
```bash
# Web content
/var/www/html/                httpd_sys_content_t

# Configuration files
/etc/                         etc_t

# Log files
/var/log/                     var_log_t

# Home directories
/home/username/               user_home_dir_t

# Service-specific
/var/ossec/                   wazuh_var_t (custom)
/etc/prometheus/              prometheus_etc_t (custom)
```

### Audit Configuration

**Auditd Rules:**
```bash
# /etc/audit/rules.d/audit.rules

# Remove any existing rules
-D

# Buffer size
-b 8192

# Failure mode (0=silent, 1=printk, 2=panic)
-f 1

# NIST 800-171 Required Rules

# Monitor authentication files
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity

# Monitor authentication events
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins

# Monitor network environment
-a always,exit -F arch=b64 -S sethostname,setdomainname -k network_modifications
-w /etc/hosts -p wa -k network_modifications
-w /etc/sysconfig/network -p wa -k network_modifications
-w /etc/sysconfig/network-scripts/ -p wa -k network_modifications

# Monitor system access
-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time_change
-w /etc/localtime -p wa -k time_change

# Monitor user/group modifications
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/userdel -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/groupdel -p x -k group_modification
-w /usr/sbin/groupmod -p x -k group_modification

# Monitor sudo usage
-w /etc/sudoers -p wa -k sudoers_changes
-w /etc/sudoers.d/ -p wa -k sudoers_changes
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/sudo -k sudo_usage

# Monitor file operations
-a always,exit -F arch=b64 -S open,openat,openat2,creat,truncate,ftruncate -F exit=-EACCES -k access
-a always,exit -F arch=b64 -S open,openat,openat2,creat,truncate,ftruncate -F exit=-EPERM -k access

# Monitor privileged commands
-a always,exit -F path=/usr/bin/passwd -F perm=x -F auid>=1000 -F auid!=unset -k privileged_passwd
-a always,exit -F path=/usr/sbin/unix_chkpwd -F perm=x -F auid>=1000 -F auid!=unset -k privileged_passwd
-a always,exit -F path=/usr/bin/su -F perm=x -F auid>=1000 -F auid!=unset -k privileged_su
-a always,exit -F path=/usr/bin/chsh -F perm=x -F auid>=1000 -F auid!=unset -k privileged_chsh
-a always,exit -F path=/usr/bin/newgrp -F perm=x -F auid>=1000 -F auid!=unset -k privileged_newgrp

# Monitor file deletion
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=unset -k delete

# Monitor kernel module operations
-w /usr/sbin/insmod -p x -k modules
-w /usr/sbin/rmmod -p x -k modules
-w /usr/sbin/modprobe -p x -k modules
-a always,exit -F arch=b64 -S init_module,delete_module -k modules

# Monitor mounts
-a always,exit -F arch=b64 -S mount,umount2 -k mounts

# Make configuration immutable
-e 2
```

### File Integrity Monitoring

**AIDE Configuration:**
```bash
# /etc/aide.conf

# Database location
database=file:/var/lib/aide/aide.db.gz
database_out=file:/var/lib/aide/aide.db.new.gz

# Report settings
report_url=stdout
report_url=file:/var/log/aide/aide.log

# Rule definitions
PERMS = p+u+g+acl+selinux+xattrs
CONTENT = sha256+ftype
CONTENT_EX = sha256+ftype+p+u+g+n+acl+selinux+xattrs
DATAONLY = p+n+u+g+s+acl+selinux+xattrs

# Directories to monitor
/boot   CONTENT_EX
/bin    CONTENT_EX
/sbin   CONTENT_EX
/lib    CONTENT_EX
/lib64  CONTENT_EX
/usr/bin        CONTENT_EX
/usr/sbin       CONTENT_EX
/usr/lib        CONTENT_EX
/usr/lib64      CONTENT_EX

# Configuration directories
/etc    PERMS+CONTENT_EX

# Exclude volatile files
!/var/log/
!/var/spool/
!/var/cache/
!/var/tmp/
!/tmp/
!/proc/
!/sys/
!/dev/
!/run/
```

### SSH Hardening

**SSH Server Configuration:**
```bash
# /etc/ssh/sshd_config

# Protocol and encryption
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and MACs (FIPS compliant)
Ciphers aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256,hmac-sha2-512
KexAlgorithms ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256

# Authentication
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication yes
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
UsePAM yes

# Security options
X11Forwarding no
PrintMotd yes
PrintLastLog yes
TCPKeepAlive yes
UseDNS no
PermitUserEnvironment no
ClientAliveInterval 300
ClientAliveCountMax 0
Banner /etc/ssh/sshd_banner
MaxAuthTries 4
MaxSessions 10
LoginGraceTime 60

# Logging
SyslogFacility AUTHPRIV
LogLevel VERBOSE

# Subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server
```

## 38.5 Service-Specific Baselines

### Apache/HTTPD Configuration

**Standard HTTPD Security Settings:**
```bash
# /etc/httpd/conf/httpd.conf

ServerTokens Prod
ServerSignature Off
TraceEnable Off

# Timeout settings
Timeout 60
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5

# Security headers (in vhost configs)
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';"

# TLS Configuration
SSLProtocol -all +TLSv1.2 +TLSv1.3
SSLCipherSuite HIGH:!aNULL:!MD5:!3DES
SSLHonorCipherOrder on
SSLSessionTickets off
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/ssl_stapling(32768)"
```

### FreeIPA Configuration

**IPA Server Settings:**
```bash
# View IPA configuration
ipa config-show

# Expected baseline:
Maximum username length: 32
Maximum hostname length: 64
Home directory base: /home
Default shell: /bin/bash
Default user group: ipausers
Default e-mail domain: cyberinabox.net
Search time limit: 2
Search size limit: 100
User search fields: uid,givenname,sn,telephonenumber,ou,title
Group search fields: cn,description
Enable migration mode: FALSE
Certificate Subject base: O=CYBERINABOX.NET
Password Expiration Notification (days): 4
Password plugin features: AllowNThash, KDC:Disable Last Success
SELinux user map order: guest_u:s0$xguest_u:s0$user_u:s0$staff_u:s0-s0:c0.c1023$sysadm_u:s0-s0:c0.c1023$unconfined_u:s0-s0:c0.c1023
```

### Wazuh Configuration

**Manager Configuration Baseline:**
```xml
<!-- /var/ossec/etc/ossec.conf -->
<ossec_config>
  <global>
    <email_notification>yes</email_notification>
    <email_to>security@cyberinabox.net</email_to>
    <smtp_server>localhost</smtp_server>
    <email_from>wazuh@cyberinabox.net</email_from>
    <email_maxperhour>12</email_maxperhour>
    <email_log_source>alerts.log</email_log_source>
  </global>

  <alerts>
    <log_alert_level>3</log_alert_level>
    <email_alert_level>10</email_alert_level>
  </alerts>

  <remote>
    <connection>secure</connection>
    <port>1514</port>
    <protocol>tcp</protocol>
    <queue_size>131072</queue_size>
  </remote>

  <rootcheck>
    <disabled>no</disabled>
    <check_files>yes</check_files>
    <check_trojans>yes</check_trojans>
    <check_dev>yes</check_dev>
    <check_sys>yes</check_sys>
    <check_pids>yes</check_pids>
    <check_ports>yes</check_ports>
    <check_if>yes</check_if>
    <frequency>43200</frequency>
  </rootcheck>

  <vulnerability-detector>
    <enabled>yes</enabled>
    <interval>12h</interval>
    <run_on_start>yes</run_on_start>
    <provider name="redhat">
      <enabled>yes</enabled>
      <update_interval>1h</update_interval>
    </provider>
  </vulnerability-detector>

  <syscheck>
    <disabled>no</disabled>
    <frequency>43200</frequency>
    <scan_on_start>yes</scan_on_start>
    <auto_ignore frequency="10" timeframe="3600">no</auto_ignore>
    <alert_new_files>yes</alert_new_files>

    <directories check_all="yes" realtime="yes">/etc,/usr/bin,/usr/sbin</directories>
    <directories check_all="yes" realtime="yes">/bin,/sbin,/boot</directories>

    <ignore>/etc/mtab</ignore>
    <ignore>/etc/hosts.deny</ignore>
    <ignore>/etc/mail/statistics</ignore>
    <ignore>/etc/random-seed</ignore>
    <ignore>/etc/adjtime</ignore>
    <ignore>/etc/dnf/</ignore>
  </syscheck>
</ossec_config>
```

## 38.6 Backup Configuration Baseline

### Backup Schedule

**Daily Backup Configuration:**
```bash
# /etc/cron.d/system-backup
# Daily full backups at 2:00 AM
0 2 * * * root /usr/local/bin/backup-all-systems.sh >> /var/log/backup.log 2>&1

# Hourly database snapshots
0 * * * * root /usr/local/bin/backup-databases.sh >> /var/log/db-backup.log 2>&1

# Daily backup verification at 6:00 AM
0 6 * * * root /usr/local/bin/backup-verify.sh >> /var/log/backup-verify.log 2>&1

# Monthly restore test (first Sunday at 4:00 AM)
0 4 * * 0 root [ $(date +\%d) -le 7 ] && /usr/local/bin/backup-monthly-test.sh >> /var/log/backup-test.log 2>&1
```

### Retention Policy

**Backup Retention Configuration:**
```bash
# /etc/backup.conf (used by backup scripts)

# Retention periods
DAILY_RETENTION=30          # Keep daily backups for 30 days
WEEKLY_RETENTION=52         # Keep weekly backups for 52 weeks
MONTHLY_RETENTION=24        # Keep monthly backups for 24 months
YEARLY_RETENTION=7          # Keep yearly backups for 7 years

# Backup locations
BACKUP_ROOT="/datastore/backups"
ARCHIVE_ROOT="/datastore/archives"

# Systems to backup
SYSTEMS=(
    "dc1.cyberinabox.net"
    "dms.cyberinabox.net"
    "graylog.cyberinabox.net"
    "proxy.cyberinabox.net"
    "monitoring.cyberinabox.net"
    "wazuh.cyberinabox.net"
)

# Paths to backup per system
BACKUP_PATHS=(
    "/etc"
    "/var/ossec/etc"
    "/var/www"
    "/home"
    "/usr/local/bin"
    "/root"
)

# Databases to backup
DATABASES=(
    "postgresql:wazuh"
    "mongodb:graylog"
)
```

## 38.7 System Update Baseline

### Automatic Updates Configuration

**DNF Automatic Settings:**
```bash
# /etc/dnf/automatic.conf
[commands]
upgrade_type = security
random_sleep = 0
download_updates = yes
apply_updates = yes

[emitters]
emit_via = stdio,email
email_from = dnf-automatic@cyberinabox.net
email_to = admin@cyberinabox.net
email_host = localhost

[email]
email_from = dnf-automatic@cyberinabox.net
email_to = admin@cyberinabox.net
email_host = localhost

[base]
debuglevel = 1
```

**Update Schedule:**
```bash
# Automatic security updates: Weekly (Sunday 03:00)
# Manual updates: Monthly maintenance window
# Emergency updates: As needed (documented procedure)

# /etc/cron.d/dnf-automatic
0 3 * * 0 root /usr/bin/dnf-automatic
```

---

**Configuration Baseline Quick Reference:**

**Security:**
- SELinux: Enforcing mode
- FIPS: Enabled system-wide
- Auditd: Comprehensive NIST rules
- AIDE: Daily integrity checks
- Firewall: Default deny, explicit allow

**Authentication:**
- Kerberos: 8-hour tickets, 7-day renewal
- Password: 14 char min, 4 classes, 90-day expiry
- SSH: No root login, key + password auth
- MFA: Required for privileged accounts

**Network:**
- DNS: dc1 (192.168.1.10)
- NTP: Chrony (pool.ntp.org)
- Subnet: 192.168.1.0/24
- Gateway: 192.168.1.1

**Services:**
- Apache: TLS 1.2/1.3, security headers
- FreeIPA: Centralized IdM, PKI
- Wazuh: SIEM, level 10+ email alerts
- Prometheus: 15s scrape, 30-day retention

**Backups:**
- Daily: 2:00 AM (30-day retention)
- Weekly: Sunday (52-week retention)
- Monthly: First Sunday (24-month retention)
- Yearly: January 1 (7-year retention)

**Updates:**
- Security: Automatic (Sunday 03:00)
- All packages: Manual (monthly)
- Emergency: As needed with approval

**Files:**
- /etc/: System configuration
- /var/ossec/etc/: Wazuh config
- /etc/prometheus/: Monitoring config
- /etc/audit/rules.d/: Audit rules
- /etc/aide.conf: FIM configuration

---

**Related Chapters:**
- Chapter 4: Security Baseline
- Chapter 31: Security Updates & Patching
- Chapter 33: System Specifications
- Chapter 34: Network Topology
- Chapter 35: Software Inventory

**For Configuration Changes:**
- Review: Test in non-production first
- Document: Update this chapter
- Version control: Commit to git
- Validation: Run verification scripts
- Administrator: dshannon@cyberinabox.net
