#!/bin/bash
#
# Module 80: Deploy Security Policies
# NIST 800-171 compliant security policies
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [80-POLICIES] $*"
}

log "Deploying security policies..."

# Create policies directory
POLICIES_DIR="/opt/cyberhygiene/policies"
mkdir -p "${POLICIES_DIR}"

log "✓ Policies directory created"

# Create Acceptable Use Policy
log "Creating Acceptable Use Policy..."
cat > "${POLICIES_DIR}/acceptable_use_policy.txt" <<EOF
========================================
ACCEPTABLE USE POLICY
${BUSINESS_NAME}
========================================
Effective Date: ${INSTALL_DATE}

1. PURPOSE
This Acceptable Use Policy defines acceptable use of ${BUSINESS_NAME} information systems and technology resources.

2. SCOPE
This policy applies to all users who access ${BUSINESS_NAME} systems, including employees, contractors, and authorized third parties.

3. ACCEPTABLE USE
Users may access systems only for legitimate business purposes.
Users must protect their authentication credentials.
Users must report security incidents immediately.

4. PROHIBITED ACTIVITIES
- Unauthorized access to systems or data
- Installing unauthorized software
- Sharing passwords or access credentials
- Connecting unauthorized devices
- Attempting to bypass security controls

5. ENFORCEMENT
Violations may result in disciplinary action up to and including termination.

6. ACKNOWLEDGMENT
All users must acknowledge understanding of this policy.

Policy Owner: IT Administrator
Contact: ${ADMIN_EMAIL}
EOF

log "✓ Acceptable Use Policy created"

# Create Password Policy
log "Creating Password Policy..."
cat > "${POLICIES_DIR}/password_policy.txt" <<EOF
========================================
PASSWORD POLICY
${BUSINESS_NAME}
========================================
Effective Date: ${INSTALL_DATE}

1. PASSWORD REQUIREMENTS (NIST 800-171 IA-5)
- Minimum length: 14 characters
- Must contain at least 3 character classes (upper, lower, numbers, symbols)
- Cannot reuse last 24 passwords
- Maximum age: 90 days
- Minimum age: 1 day

2. ACCOUNT LOCKOUT
- Maximum failed attempts: 3
- Lockout duration: 30 minutes
- Lockout period: 15 minutes

3. MULTI-FACTOR AUTHENTICATION
- Required for all administrative access
- Recommended for all user access

4. PASSWORD STORAGE
- Passwords must never be written down in plain text
- Use approved password manager (KeePassXC)

5. PASSWORD CHANGES
- Users must change passwords every 90 days
- Forced password change on first login
- Immediate change required if compromise suspected

Enforced by: FreeIPA Directory Service
Policy Owner: IT Administrator
Contact: ${ADMIN_EMAIL}
EOF

log "✓ Password Policy created"

# Create Incident Response Policy
log "Creating Incident Response Policy..."
cat > "${POLICIES_DIR}/incident_response_policy.txt" <<EOF
========================================
INCIDENT RESPONSE POLICY
${BUSINESS_NAME}
========================================
Effective Date: ${INSTALL_DATE}

1. PURPOSE
Define procedures for detecting, responding to, and recovering from security incidents.

2. INCIDENT CLASSIFICATION
- Level 1 (Low): Minor policy violation
- Level 2 (Medium): Potential security compromise
- Level 3 (High): Confirmed security breach
- Level 4 (Critical): Active attack or data breach

3. REPORTING
All suspected security incidents must be reported immediately to:
  Email: ${ADMIN_EMAIL}
  System: Wazuh Security Dashboard (https://wazuh.${DOMAIN})

4. RESPONSE PROCEDURES
a) Detection: Automated via Wazuh, Suricata, manual reporting
b) Containment: Isolate affected systems
c) Eradication: Remove threat, patch vulnerabilities
d) Recovery: Restore from backups, verify integrity
e) Lessons Learned: Document incident, update procedures

5. EVIDENCE PRESERVATION
- Do not power off systems without authorization
- Preserve log files and system state
- Document all actions taken

Policy Owner: IT Administrator
Contact: ${ADMIN_EMAIL}
EOF

log "✓ Incident Response Policy created"

# Create Backup Policy
log "Creating Backup Policy..."
cat > "${POLICIES_DIR}/backup_policy.txt" <<EOF
========================================
BACKUP AND RECOVERY POLICY
${BUSINESS_NAME}
========================================
Effective Date: ${INSTALL_DATE}

1. BACKUP SCHEDULE
- Daily backups: 2:00 AM (7 day retention)
- Weekly backups: Sunday 2:00 AM (30 day retention)
- Monthly backups: 1st of month 2:00 AM (90 day retention)

2. BACKUP SCOPE
- System configurations (/etc)
- User data (/datastore)
- FreeIPA database
- Wazuh configuration
- Application data

3. BACKUP ENCRYPTION
All backups are encrypted with AES-256 encryption.
Encryption key stored securely offline.

4. BACKUP TESTING
- Monthly restore test required
- Document test results
- Verify backup integrity

5. RECOVERY PROCEDURES
Recovery script: /usr/local/bin/cyberhygiene-restore.sh
Recovery time objective (RTO): 4 hours
Recovery point objective (RPO): 24 hours

Backup Location: /backup/
Policy Owner: IT Administrator
Contact: ${ADMIN_EMAIL}
EOF

log "✓ Backup Policy created"

# Create System Access Control Policy
log "Creating Access Control Policy..."
cat > "${POLICIES_DIR}/access_control_policy.txt" <<EOF
========================================
ACCESS CONTROL POLICY
${BUSINESS_NAME}
========================================
Effective Date: ${INSTALL_DATE}

1. PURPOSE
Control access to information systems in accordance with NIST 800-171.

2. LEAST PRIVILEGE (AC-6)
Users granted minimum access necessary for job functions.
Administrative access limited to authorized personnel.

3. USER ACCOUNT MANAGEMENT
- Accounts created only for authorized users
- Accounts disabled within 24 hours of separation
- Periodic review of active accounts (quarterly)
- Shared accounts prohibited

4. AUTHENTICATION (IA-2, IA-5)
- Kerberos-based single sign-on
- Multi-factor authentication for privileged access
- Password requirements per Password Policy

5. SESSION MANAGEMENT
- Automatic logout after 8 hours of inactivity
- Session lock after 15 minutes of inactivity
- Re-authentication required after lock

6. REMOTE ACCESS
- VPN required for remote access (when configured)
- Same authentication requirements as local access
- Remote sessions logged and monitored

Enforcement: FreeIPA, SELinux, Firewall
Policy Owner: IT Administrator
Contact: ${ADMIN_EMAIL}
EOF

log "✓ Access Control Policy created"

# Set appropriate permissions
chmod 644 "${POLICIES_DIR}"/*.txt

# Create policy index
log "Creating policy index..."
cat > "${POLICIES_DIR}/README.txt" <<EOF
========================================
CYBERHYGIENE SECURITY POLICIES
${BUSINESS_NAME}
========================================
Generated: $(date)

This directory contains security policies for ${BUSINESS_NAME}
in compliance with NIST SP 800-171.

AVAILABLE POLICIES:
1. acceptable_use_policy.txt - Acceptable use of IT resources
2. password_policy.txt - Password requirements and management
3. incident_response_policy.txt - Security incident procedures
4. backup_policy.txt - Backup and recovery procedures
5. access_control_policy.txt - System access controls

POLICY REVIEW:
All policies must be reviewed annually and updated as needed.
Next review date: $(date -d "+1 year" +%Y-%m-%d)

POLICY OWNER:
IT Administrator
Email: ${ADMIN_EMAIL}

For questions about these policies, contact the IT Administrator.
EOF

log "✓ Policy index created"

# Create symlink for easy access
ln -sf "${POLICIES_DIR}" /root/policies 2>/dev/null || true

echo ""
log "=========================================="
log "Security Policies Deployment Summary"
log "=========================================="
log "✓ Security policies deployed"
log ""
log "Policies directory: ${POLICIES_DIR}"
log ""
log "Deployed policies:"
log "  1. Acceptable Use Policy"
log "  2. Password Policy (NIST 800-171 IA-5)"
log "  3. Incident Response Policy"
log "  4. Backup and Recovery Policy"
log "  5. Access Control Policy (NIST 800-171 AC-6)"
log ""
log "Next steps:"
log "  1. Review policies for organization-specific requirements"
log "  2. Train users on security policies"
log "  3. Obtain user acknowledgment of policies"
log "  4. Schedule annual policy review"
log ""

exit 0
