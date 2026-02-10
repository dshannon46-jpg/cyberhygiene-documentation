#!/bin/bash
#
# Module 90: Customize Documentation
# Update documentation with customer-specific information
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [90-DOCS] $*"
}

log "Customizing documentation for ${BUSINESS_NAME}..."

# Create documentation directory
DOCS_DIR="/opt/cyberhygiene/docs"
mkdir -p "${DOCS_DIR}"

log "✓ Documentation directory created"

# Create System Overview document
log "Creating System Overview..."
cat > "${DOCS_DIR}/system_overview.txt" <<EOF
========================================
CYBERHYGIENE SYSTEM OVERVIEW
${BUSINESS_NAME}
========================================
Installation Date: ${INSTALL_DATE}
Domain: ${DOMAIN}

========================================
SYSTEM INFORMATION
========================================

Business Name: ${BUSINESS_NAME}
Domain: ${DOMAIN}
Network: ${SUBNET}.0/24
Gateway: ${GATEWAY}

========================================
SERVERS AND SERVICES
========================================

Domain Controller (dc1.${DOMAIN})
  IP Address: ${DC1_IP}
  Services: FreeIPA, DNS, Kerberos, Certificate Authority
  Web Interface: https://${DC1_HOSTNAME}
  Purpose: Identity management, authentication, DNS

File Server (dms.${DOMAIN})
  IP Address: ${DMS_IP}
  Services: Samba file sharing
  Access: \\\\${DC1_HOSTNAME}\\shared
  Purpose: Centralized file storage

Log Management (graylog.${DOMAIN})
  IP Address: ${GRAYLOG_IP}
  Services: Graylog, Elasticsearch, MongoDB
  Web Interface: http://${DC1_IP}:9000
  Purpose: Centralized log collection and analysis

Web Proxy (proxy.${DOMAIN})
  IP Address: ${PROXY_IP}
  Services: Suricata IDS/IPS
  Purpose: Network security monitoring

Monitoring (monitoring.${DOMAIN})
  IP Address: ${MONITORING_IP}
  Services: Prometheus, Grafana
  Web Interface: http://${DC1_IP}:3000
  Purpose: System metrics and dashboards

Security Monitoring (wazuh.${DOMAIN})
  IP Address: ${WAZUH_IP}
  Services: Wazuh Manager, Wazuh Indexer, Wazuh Dashboard
  Web Interface: https://${DC1_IP}
  Purpose: SIEM, compliance monitoring, threat detection

========================================
USER ACCESS
========================================

Web Applications:
  - FreeIPA: https://${DC1_HOSTNAME}
  - Grafana: http://${DC1_IP}:3000
  - Graylog: http://${DC1_IP}:9000
  - Wazuh: https://${DC1_IP}

File Sharing:
  - Windows: \\\\${DC1_HOSTNAME}\\shared
  - Linux: smb://${DC1_HOSTNAME}/shared

Authentication:
  - Method: Kerberos (Single Sign-On)
  - Domain: ${REALM}
  - Password Policy: 14+ characters, 90-day expiration

========================================
ADMINISTRATOR CONTACTS
========================================

IT Administrator: ${ADMIN_EMAIL}
Installation Date: ${INSTALL_DATE}
Installer: ${INSTALLER_NAME}

========================================
COMPLIANCE
========================================

Security Framework: NIST SP 800-171
Encryption: FIPS 140-2 mode enabled
Audit Logging: Comprehensive audit trail maintained
Backup Schedule: Daily, Weekly, Monthly (encrypted)

========================================
SUPPORT RESOURCES
========================================

Documentation: ${DOCS_DIR}/
Policies: /opt/cyberhygiene/policies/
Backup Scripts: /usr/local/bin/cyberhygiene-*.sh
Log Files: /var/log/

========================================
EOF

log "✓ System Overview created"

# Create Quick Reference Guide
log "Creating Quick Reference Guide..."
cat > "${DOCS_DIR}/quick_reference.txt" <<EOF
========================================
CYBERHYGIENE QUICK REFERENCE
${BUSINESS_NAME}
========================================

COMMON TASKS
========================================

Log in to FreeIPA:
  https://${DC1_HOSTNAME}
  Username: admin
  Password: [From credentials file]

View Security Alerts:
  https://${DC1_IP} (Wazuh Dashboard)

View System Metrics:
  http://${DC1_IP}:3000 (Grafana)

Access File Shares:
  Windows: \\\\${DC1_HOSTNAME}\\shared
  macOS: smb://${DC1_HOSTNAME}/shared

COMMON COMMANDS
========================================

Check FreeIPA Status:
  sudo ipactl status

Restart FreeIPA:
  sudo ipactl restart

Check All Services:
  sudo systemctl list-units --type=service --state=running

View Logs:
  sudo journalctl -xe
  sudo tail -f /var/log/messages

Run Backup:
  sudo /usr/local/bin/cyberhygiene-backup.sh

Restore from Backup:
  sudo /usr/local/bin/cyberhygiene-restore.sh /backup/daily/backup_*.tar.gz.enc

USER MANAGEMENT
========================================

Create User (via FreeIPA web):
  1. Log in to https://${DC1_HOSTNAME}
  2. Identity → Users → Add
  3. Fill in user details
  4. Set initial password

Create User (command line):
  sudo ipa user-add jsmith --first=John --last=Smith --email=jsmith@${DOMAIN}
  sudo ipa passwd jsmith

Disable User:
  sudo ipa user-disable jsmith

TROUBLESHOOTING
========================================

DNS Not Working:
  sudo systemctl restart named-pkcs11

Authentication Failing:
  sudo ipactl restart
  sudo systemctl restart sssd

Services Not Starting:
  Check logs: sudo journalctl -u <service-name>
  Check firewall: sudo firewall-cmd --list-all

SECURITY
========================================

View Failed Login Attempts:
  sudo ausearch -m USER_LOGIN -sv no

View Wazuh Alerts:
  https://${DC1_IP}

View Suricata Alerts:
  sudo tail -f /var/log/suricata/fast.log

Check System Updates:
  sudo dnf check-update
  sudo dnf update --security

BACKUPS
========================================

Backup Location: /backup/
Daily: 7-day retention
Weekly: 30-day retention
Monthly: 90-day retention

List Available Backups:
  ls -lh /backup/*/backup_*.tar.gz.enc

SUPPORT
========================================

Administrator: ${ADMIN_EMAIL}
Documentation: ${DOCS_DIR}/
Policies: /opt/cyberhygiene/policies/

========================================
EOF

log "✓ Quick Reference Guide created"

# Create Troubleshooting Guide
log "Creating Troubleshooting Guide..."
cat > "${DOCS_DIR}/troubleshooting.txt" <<EOF
========================================
CYBERHYGIENE TROUBLESHOOTING GUIDE
${BUSINESS_NAME}
========================================

ISSUE: Cannot access FreeIPA web interface
SOLUTION:
  1. Check if service is running: sudo ipactl status
  2. Restart if needed: sudo ipactl restart
  3. Check firewall: sudo firewall-cmd --list-all
  4. Check logs: sudo journalctl -u ipa

ISSUE: Users cannot authenticate
SOLUTION:
  1. Check Kerberos: sudo systemctl status krb5kdc
  2. Check LDAP: sudo systemctl status dirsrv@${REALM//./-}
  3. Test authentication: kinit admin
  4. Restart FreeIPA: sudo ipactl restart

ISSUE: DNS not resolving
SOLUTION:
  1. Check DNS service: sudo systemctl status named-pkcs11
  2. Test resolution: host ${DC1_HOSTNAME}
  3. Check /etc/resolv.conf (should have nameserver ${DC1_IP})
  4. Restart DNS: sudo systemctl restart named-pkcs11

ISSUE: File shares not accessible
SOLUTION:
  1. Check Samba: sudo systemctl status smb nmb
  2. Test connection: smbclient -L ${DC1_HOSTNAME} -U admin
  3. Check firewall: sudo firewall-cmd --list-all | grep samba
  4. Restart Samba: sudo systemctl restart smb nmb

ISSUE: System running slow
SOLUTION:
  1. Check memory: free -h
  2. Check disk space: df -h
  3. Check CPU: top
  4. Review logs for errors: sudo journalctl -p err

ISSUE: Cannot connect to Wazuh dashboard
SOLUTION:
  1. Check Wazuh services:
     sudo systemctl status wazuh-manager
     sudo systemctl status wazuh-indexer
     sudo systemctl status wazuh-dashboard
  2. Check firewall: sudo firewall-cmd --list-all
  3. Access via IP: https://${DC1_IP}

ISSUE: Backups failing
SOLUTION:
  1. Check backup log: sudo tail /var/log/cyberhygiene-backup.log
  2. Check disk space: df -h /backup
  3. Test backup manually: sudo /usr/local/bin/cyberhygiene-backup.sh
  4. Verify cron job: sudo cat /etc/cron.d/cyberhygiene-backup

GETTING MORE HELP
========================================

Log Files:
  - System: /var/log/messages
  - Audit: /var/log/audit/audit.log
  - FreeIPA: /var/log/ipaserver-install.log
  - Wazuh: /var/ossec/logs/ossec.log
  - Suricata: /var/log/suricata/suricata.log

Useful Commands:
  - View all logs: sudo journalctl -xe
  - Follow system log: sudo tail -f /var/log/messages
  - List running services: sudo systemctl list-units --type=service

Contact Administrator: ${ADMIN_EMAIL}

========================================
EOF

log "✓ Troubleshooting Guide created"

# Set permissions
chmod 644 "${DOCS_DIR}"/*.txt

# Create symlink for easy access
ln -sf "${DOCS_DIR}" /root/docs 2>/dev/null || true

echo ""
log "=========================================="
log "Documentation Customization Summary"
log "=========================================="
log "✓ Documentation customized for ${BUSINESS_NAME}"
log ""
log "Documentation directory: ${DOCS_DIR}"
log ""
log "Created documents:"
log "  1. system_overview.txt - Complete system information"
log "  2. quick_reference.txt - Common tasks and commands"
log "  3. troubleshooting.txt - Problem resolution guide"
log ""
log "Access documentation:"
log "  cd ${DOCS_DIR}"
log "  cat system_overview.txt"
log ""
log "Symlink created: /root/docs -> ${DOCS_DIR}"
log ""

exit 0
