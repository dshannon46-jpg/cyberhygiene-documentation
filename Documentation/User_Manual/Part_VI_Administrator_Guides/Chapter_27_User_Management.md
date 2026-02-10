# Chapter 27: User Management (FreeIPA)

## 27.1 FreeIPA Administration Overview

### Administrative Access

**Who Can Administer:**

```
Admin Roles:
  - Full Administrators: Complete FreeIPA control
  - User Administrators: User/group management only
  - Help Desk: Password resets, account unlocks
  - Read-Only Admins: View-only access

Access Requirements:
  ✓ Privileged account (admin username)
  ✓ Strong password (20+ characters)
  ✓ MFA/OTP required
  ✓ Logged and audited
```

**Accessing FreeIPA Admin Interface:**

```
URL: https://dc1.cyberinabox.net
Username: admin (or privileged account)
Password: [admin password]
OTP: [6-digit code from authenticator]

Alternative CLI Access:
ssh admin@dc1.cyberinabox.net
# All ipa commands available
```

### FreeIPA Architecture

**Core Components:**

```
389 Directory Server (LDAP):
  - User and group database
  - Organizational structure
  - LDAP port: 636 (LDAPS)
  - Base DN: dc=cyberinabox,dc=net

MIT Kerberos (KDC):
  - Authentication service
  - Single sign-on (SSO)
  - Realm: CYBERINABOX.NET
  - Ticket lifetime: 8 hours

DNS Server (BIND):
  - Internal name resolution
  - Service discovery (SRV records)
  - Dynamic updates
  - Zone: cyberinabox.net

Certificate Authority (Dogtag):
  - Internal PKI
  - SSL/TLS certificates
  - User certificates
  - Service certificates

SSSD (Client):
  - Local authentication caching
  - Offline support
  - Automatic ticket renewal
  - PAM integration
```

## 27.2 User Account Management

### Creating User Accounts

**Web Interface Method:**

```
1. Login to FreeIPA: https://dc1.cyberinabox.net

2. Navigate: Identity → Users

3. Click: "+ Add" button

4. Fill User Information:
   User login: jsmith
   First name: John
   Last name: Smith
   Class: Person (default)

5. Account Settings:
   Password: [Generate temporary password]
   □ Force password change on first login (recommended)
   UID: [auto-generated or specify]
   GID: [auto-generated or match group]
   Home directory: /home/jsmith
   Login shell: /bin/bash

6. Contact Information:
   Email: jsmith@cyberinabox.net
   Telephone: 555-1234 (optional)
   Mobile: 555-5678 (optional)

7. Employee Information (optional):
   Title: Senior Engineer
   Department: Engineering
   Manager: jdoe
   Employee Number: EMP-2025-001

8. Click: "Add"

9. Set Password:
   - Click user → Actions → "Set Password"
   - Enter temporary password (user will change on first login)
   - Or send OTP for self-enrollment
```

**CLI Method (Faster for batch operations):**

```bash
# SSH to dc1 as admin
ssh admin@dc1.cyberinabox.net

# Add user with ipa command
ipa user-add jsmith \
  --first=John \
  --last=Smith \
  --email=jsmith@cyberinabox.net \
  --homedir=/home/jsmith \
  --shell=/bin/bash \
  --gecos="John Smith - Engineering"

# Set temporary password
ipa passwd jsmith
# Enter temporary password (twice)

# Verify user created
ipa user-show jsmith

# Add to primary group
ipa group-add-member engineering --users=jsmith

# Output
----------------------------
Added user "jsmith"
----------------------------
  User login: jsmith
  First name: John
  Last name: Smith
  Full name: John Smith
  Home directory: /home/jsmith
  GECOS: John Smith - Engineering
  Login shell: /bin/bash
  Principal name: jsmith@CYBERINABOX.NET
  Email address: jsmith@cyberinabox.net
  UID: 1234567890
  GID: 1234567890
  Account disabled: False
  Password: True
  Member of groups: ipausers, engineering
  Kerberos keys available: True
```

### New User Onboarding Checklist

```
□ Create user account in FreeIPA
□ Set temporary password (force change on first login)
□ Add to appropriate groups:
  □ Primary group (engineering, operations, etc.)
  □ Secondary groups (sudo, admins, etc.)
  □ Mailing lists
□ Configure SUDO access (if needed)
□ Enable MFA/OTP (for privileged users)
□ Create home directory (auto-created on first login)
□ Provision SSH keys (user uploads)
□ Grant file share access
□ Add to monitoring (Wazuh agent, if workstation)
□ Provide welcome email with:
  □ Username
  □ Temporary password
  □ First login instructions
  □ SSH access details
  □ Dashboard URLs
  □ IT contact information
□ Schedule onboarding training
□ Update documentation (if special access)
```

### Modifying User Accounts

**Common Modifications:**

**Change User Details:**
```bash
# Update email
ipa user-mod jsmith --email=john.smith@cyberinabox.net

# Update phone
ipa user-mod jsmith --phone=555-9876

# Update title/department
ipa user-mod jsmith --title="Lead Engineer" --departmentnumber="Dept-001"

# Update manager
ipa user-mod jsmith --manager=jdoe

# Change login shell
ipa user-mod jsmith --shell=/bin/zsh

# Update GECOS (display name)
ipa user-mod jsmith --gecos="John Smith - Lead Engineer"
```

**Account Status:**
```bash
# Disable account (preserve data, revoke access)
ipa user-disable jsmith

# Enable account
ipa user-enable jsmith

# Check status
ipa user-show jsmith | grep "Account disabled"
```

**Password Management:**
```bash
# Force password reset
ipa passwd jsmith

# Set password expiration date
ipa user-mod jsmith --password-expiration=2026-01-31

# Remove password expiration (service accounts only)
ipa user-mod serviceaccount --password-expiration=

# Unlock account (after failed login attempts)
ipa user-unlock jsmith
```

### Deleting User Accounts

**User Offboarding Process:**

**Step 1: Disable Account (Immediate)**
```bash
# Don't delete immediately - disable first
ipa user-disable jsmith

# Verify disabled
ipa user-show jsmith

# Result: Account disabled: True
# User cannot login, but data preserved
```

**Step 2: Revoke Access (Within 1 hour)**
```bash
# Remove from groups (except ipausers)
ipa group-remove-member engineering --users=jsmith
ipa group-remove-member sudo --users=jsmith

# Remove SUDO rules
ipa sudorule-remove-user admin_sudo --users=jsmith

# Revoke certificates
ipa cert-revoke <serial> --revocation-reason=4

# List user's SSH keys (for documentation)
ipa user-show jsmith --all | grep -A 10 "SSH public key"
```

**Step 3: Archive Data (Within 24 hours)**
```bash
# Archive home directory
sudo tar -czf /backups/users/jsmith_$(date +%Y%m%d).tar.gz /home/jsmith/

# Archive email (if local)
sudo tar -czf /backups/mail/jsmith_$(date +%Y%m%d).tar.gz /var/mail/jsmith

# Document:
# - Services accessed
# - Data locations
# - Transfer ownership to manager
```

**Step 4: Delete Account (After 90 days retention)**
```bash
# Verify account still disabled
ipa user-show jsmith | grep "Account disabled"

# Delete user (permanent - cannot be undone)
ipa user-del jsmith

# Confirm deletion
# Are you sure you want to delete user jsmith? yes

# Verify deletion
ipa user-find jsmith
# Result: 0 users matched

# Clean up residual data
sudo rm -rf /home/jsmith/  # After archival complete
```

**Offboarding Checklist:**
```
□ Disable account immediately
□ Remove group memberships
□ Revoke SUDO access
□ Revoke certificates
□ Archive home directory
□ Archive email
□ Transfer file ownership to manager
□ Remove from mailing lists
□ Disable MFA/OTP tokens
□ Document services accessed
□ Remove from project documentation
□ Update contact lists
□ Delete account after 90-day retention
```

## 27.3 Group Management

### Understanding Groups

**Group Types:**

```
User Groups (POSIX):
  - Traditional Unix groups
  - File permissions
  - Group ID (GID)
  - Examples: engineering, operations

Role-Based Groups:
  - Administrative roles
  - Access control
  - SUDO rules
  - Examples: admins, sudoers

Functional Groups:
  - Mailing lists
  - Project teams
  - Resource access
  - Examples: project-alpha, readers
```

### Creating Groups

**Web Interface:**
```
1. Identity → Groups
2. "+ Add" button
3. Fill:
   Group name: project-alpha
   Description: Project Alpha development team
   GID: [auto or specify]
   Group type: POSIX group
4. Add Members:
   - Click "Add" in Members section
   - Select users
   - Click "Add"
5. Save
```

**CLI Method:**
```bash
# Create group
ipa group-add project-alpha \
  --desc="Project Alpha development team"

# Add users to group
ipa group-add-member project-alpha \
  --users=jsmith,jdoe,bwilson

# Verify group
ipa group-show project-alpha

# Output:
  Group name: project-alpha
  Description: Project Alpha development team
  GID: 1234500001
  Member users: jsmith, jdoe, bwilson
```

### Managing Group Membership

**Add/Remove Members:**
```bash
# Add single user
ipa group-add-member engineering --users=jsmith

# Add multiple users
ipa group-add-member engineering --users={jsmith,jdoe,bwilson}

# Add group to group (nested)
ipa group-add-member all-engineers --groups=engineering

# Remove user from group
ipa group-remove-member engineering --users=jsmith

# List group members
ipa group-show engineering
```

**Common Group Structures:**

```bash
# Department groups
ipa group-add engineering --desc="Engineering Department"
ipa group-add operations --desc="Operations Team"
ipa group-add security --desc="Security Team"

# Access level groups
ipa group-add sudo --desc="SUDO access privilege"
ipa group-add admins --desc="System administrators"
ipa group-add readers --desc="Read-only access"

# Project groups
ipa group-add project-alpha --desc="Project Alpha team"
ipa group-add project-beta --desc="Project Beta team"

# Mailing list groups
ipa group-add all-staff --desc="All staff mailing list"
ipa group-add engineering-team --desc="Engineering mailing list"

# File share groups
ipa group-add shared-engineering --desc="Engineering file share access"
ipa group-add shared-readonly --desc="Read-only file share access"
```

## 27.4 SUDO Access Management

### SUDO Rules

**Understanding SUDO in FreeIPA:**

```
Components:
  - User/Group: Who can run commands
  - Host/Hostgroup: Where they can run
  - Command/Command Group: What they can run
  - Run As: As which user (typically root)

Example SUDO Rule:
  Name: admin_sudo
  Users: admins group
  Hosts: all
  Commands: all
  Run As: root

  Meaning: Admins group can run any command as root on all hosts
```

### Creating SUDO Rules

**Basic SUDO Rule (Web Interface):**

```
1. Policy → SUDO → SUDO Rules
2. "+ Add" button
3. General:
   Rule name: engineering_restart_services
   Description: Allow engineers to restart services
4. Who:
   User Groups: + Add → Select "engineering"
5. Access this host:
   Host Groups: + Add → Select "all" or specific hostgroup
6. Run Commands:
   SUDO Commands: + Add → Select command group or specific commands
7. As Whom:
   RunAs Users: root
8. Save
```

**CLI Method:**

```bash
# Create SUDO rule
ipa sudorule-add engineering_restart_services \
  --desc="Allow engineers to restart services"

# Add user group
ipa sudorule-add-user engineering_restart_services \
  --groups=engineering

# Add host group (or specific hosts)
ipa sudorule-add-host engineering_restart_services \
  --hostgroups=servers

# Add allowed commands
ipa sudorule-add-allow-command engineering_restart_services \
  --sudocmds=/usr/bin/systemctl

# Set Run As user
ipa sudorule-mod engineering_restart_services \
  --runasusercat=root

# Verify rule
ipa sudorule-show engineering_restart_services
```

### SUDO Command Groups

**Creating Command Groups:**

```bash
# Create command group
ipa sudocmdgroup-add service_management \
  --desc="Service management commands"

# Add commands to group
ipa sudocmdgroup-add-member service_management \
  --sudocmds=/usr/bin/systemctl

ipa sudocmdgroup-add-member service_management \
  --sudocmds=/usr/bin/journalctl

# View command group
ipa sudocmdgroup-show service_management

# Use in SUDO rule
ipa sudorule-add-allow-command engineering_restart_services \
  --sudocmdgroups=service_management
```

**Common SUDO Patterns:**

```bash
# Full admin access (use sparingly)
ipa sudorule-add full_admin_access
ipa sudorule-add-user full_admin_access --groups=admins
ipa sudorule-add-host full_admin_access --hosts=all
ipa sudorule-mod full_admin_access --cmdcat=all
ipa sudorule-mod full_admin_access --runasusercat=root

# Limited service restart
ipa sudorule-add restart_services
ipa sudorule-add-user restart_services --groups=operations
ipa sudorule-add-host restart_services --hosts=all
ipa sudorule-add-allow-command restart_services \
  --sudocmds="/usr/bin/systemctl restart"

# Read-only monitoring
ipa sudorule-add view_logs
ipa sudorule-add-user view_logs --groups=operations
ipa sudorule-add-allow-command view_logs \
  --sudocmds=/usr/bin/journalctl
ipa sudorule-add-allow-command view_logs \
  --sudocmds="/usr/bin/tail -f /var/log/messages"
```

## 27.5 Host-Based Access Control (HBAC)

### Understanding HBAC

**Purpose:**

```
HBAC Rules control:
  - Who can access which hosts
  - What services they can use
  - When access is allowed

Without HBAC: Any user can SSH to any host
With HBAC: Fine-grained control per user/group/host
```

### Default HBAC Rules

**Critical Default Rules:**

```bash
# View default rules
ipa hbacrule-find

# Default rule: allow_all (should be disabled in production)
ipa hbacrule-show allow_all
  Rule name: allow_all
  Enabled: FALSE (should be disabled)
  Description: Allow all users to access any host
```

### Creating HBAC Rules

**Example: Engineers SSH Access:**

```bash
# Create HBAC rule
ipa hbacrule-add engineers_ssh_access \
  --desc="Allow engineers SSH access to dev/staging servers"

# Add user group
ipa hbacrule-add-user engineers_ssh_access \
  --groups=engineering

# Add host group
ipa hbacrule-add-host engineers_ssh_access \
  --hostgroups=dev_servers

# Add service (SSH)
ipa hbacrule-add-service engineers_ssh_access \
  --hbacsvcs=sshd

# Enable rule
ipa hbacrule-enable engineers_ssh_access

# Verify rule
ipa hbacrule-show engineers_ssh_access
```

**Testing HBAC Rules:**

```bash
# Test if user can access host/service
ipa hbactest \
  --user=jsmith \
  --host=dms.cyberinabox.net \
  --service=sshd

# Output:
Access granted: True
Matched rules: engineers_ssh_access

# Detailed output
ipa hbactest \
  --user=jsmith \
  --host=dc1.cyberinabox.net \
  --service=sshd \
  --detail

# Shows which rules matched and why
```

### Common HBAC Patterns

```bash
# Admin access to all hosts
ipa hbacrule-add admin_all_access
ipa hbacrule-add-user admin_all_access --groups=admins
ipa hbacrule-add-host admin_all_access --hosts=all
ipa hbacrule-add-service admin_all_access --hbacsvcs=sshd
ipa hbacrule-enable admin_all_access

# Operations team access to production
ipa hbacrule-add ops_prod_access
ipa hbacrule-add-user ops_prod_access --groups=operations
ipa hbacrule-add-host ops_prod_access --hostgroups=production_servers
ipa hbacrule-add-service ops_prod_access --hbacsvcs=sshd
ipa hbacrule-enable ops_prod_access

# Developers access to dev/staging only
ipa hbacrule-add dev_access
ipa hbacrule-add-user dev_access --groups=developers
ipa hbacrule-add-host dev_access --hostgroups=dev_servers,staging_servers
ipa hbacrule-add-service dev_access --hbacsvcs=sshd
ipa hbacrule-enable dev_access
```

## 27.6 Troubleshooting User Issues

### Common User Problems

**Problem: User Cannot Login**

```bash
# Check if account exists
ipa user-show jsmith

# Check if account is disabled
ipa user-show jsmith | grep "Account disabled"
# If "Account disabled: True" → Enable:
ipa user-enable jsmith

# Check if account is locked (failed logins)
ipa user-status jsmith
# If failures > 5:
ipa user-unlock jsmith

# Check password expiration
ipa user-show jsmith | grep "Password expiration"
# If expired:
ipa passwd jsmith  # Set new temporary password

# Check group memberships
ipa user-show jsmith | grep "Member of groups"
# Should see at least: ipausers

# Check HBAC rules allow access
ipa hbactest --user=jsmith --host=dc1.cyberinabox.net --service=sshd
# Should show: Access granted: True
```

**Problem: "Permission Denied" for File Access**

```bash
# Check user's groups
ipa user-show jsmith --all | grep "memberof"

# Verify group membership needed for file access
ipa group-show engineering

# Add user to group if missing
ipa group-add-member engineering --users=jsmith

# Verify on client system
ssh jsmith@dms.cyberinabox.net groups
# Should show new group (may need to logout/login)
```

**Problem: SUDO Not Working**

```bash
# Check SUDO rules for user
ipa sudorule-find --users=jsmith

# Check SUDO rules for user's groups
ipa sudorule-find --groups=engineering

# Verify SUDO rule details
ipa sudorule-show admin_sudo

# Test SUDO access
ssh jsmith@host
sudo -l  # List allowed commands

# Common issue: SSSD cache on client
ssh root@host
sss_cache -E  # Clear SSSD cache
systemctl restart sssd
```

**Problem: Password Reset Fails**

```bash
# As admin, reset user password
ipa passwd jsmith

# If error "Constraint violation: invalid password", check:
# - Password meets complexity requirements (15+ chars)
# - Password not in history (last 24)
# - Password not in common dictionaries

# Force password expiration (user must change)
ipa user-mod jsmith --password-expiration=$(date -d '+1 day' +%Y%m%d)

# User will be forced to change on next login
```

### Audit and Logging

**Viewing User Activity:**

```bash
# Recent user authentications
ipa user-status jsmith

# Check Kerberos ticket status
ssh jsmith@dc1.cyberinabox.net
klist

# View authentication logs (Graylog)
# https://graylog.cyberinabox.net
# Query: username:jsmith
# Time Range: Last 24 hours

# Check SUDO command history
# SSH to target host
sudo grep jsmith /var/log/secure | grep sudo

# FreeIPA audit log
ssh admin@dc1.cyberinabox.net
sudo tail -f /var/log/httpd/error_log
```

**User Account Audit Report:**

```bash
# All active users
ipa user-find --sizelimit=0 | grep "User login"

# Disabled accounts
ipa user-find --disabled=TRUE

# Users without password
ipa user-find | grep -B5 "Password: False"

# Users with password expiring soon
ipa user-find --all | grep -B10 "Password expiration" | \
  awk -v d=$(date -d '+14 days' +%Y%m%d) '$3 < d'

# Admin users (in admins group)
ipa group-show admins | grep "Member users"

# Generate CSV report
ipa user-find --sizelimit=0 --raw | \
  grep -E "uid:|givenName:|sn:|mail:" | \
  awk 'ORS=NR%4?",":"\n"' > users_report.csv
```

---

**User Management Quick Reference:**

**Create User:**
```bash
ipa user-add jsmith --first=John --last=Smith \
  --email=jsmith@cyberinabox.net --shell=/bin/bash
ipa passwd jsmith  # Set temporary password
ipa group-add-member engineering --users=jsmith
```

**Modify User:**
```bash
ipa user-mod jsmith --email=new@email.com
ipa user-mod jsmith --title="Senior Engineer"
ipa user-disable jsmith  # Disable account
ipa user-enable jsmith   # Enable account
ipa user-unlock jsmith   # Unlock after failed logins
```

**Delete User:**
```bash
ipa user-disable jsmith  # Disable first
# Archive data
ipa user-del jsmith  # Delete after 90 days
```

**Group Management:**
```bash
ipa group-add project-alpha --desc="Project team"
ipa group-add-member project-alpha --users=jsmith,jdoe
ipa group-remove-member project-alpha --users=jsmith
ipa group-show project-alpha
```

**SUDO Rules:**
```bash
ipa sudorule-add rule_name --desc="Description"
ipa sudorule-add-user rule_name --groups=engineering
ipa sudorule-add-host rule_name --hosts=all
ipa sudorule-add-allow-command rule_name --sudocmds=/usr/bin/systemctl
```

**HBAC Rules:**
```bash
ipa hbacrule-add rule_name --desc="Description"
ipa hbacrule-add-user rule_name --groups=engineering
ipa hbacrule-add-host rule_name --hostgroups=servers
ipa hbacrule-add-service rule_name --hbacsvcs=sshd
ipa hbactest --user=jsmith --host=dc1 --service=sshd
```

**Troubleshooting:**
```bash
ipa user-show jsmith  # View user details
ipa user-status jsmith  # Check login status
ipa user-unlock jsmith  # Unlock account
sss_cache -E  # Clear SSSD cache (on client)
```

**Useful Queries:**
```bash
ipa user-find  # List all users
ipa user-find --disabled=TRUE  # Disabled accounts
ipa group-find  # List all groups
ipa sudorule-find  # List SUDO rules
ipa hbacrule-find  # List HBAC rules
```

---

**Related Chapters:**
- Chapter 6: User Accounts
- Chapter 7: Password & Authentication
- Chapter 8: Multi-Factor Authentication
- Chapter 29: Backup Procedures
- Appendix C: Command Reference
- Appendix D: Troubleshooting Guide

**FreeIPA Web Interface:**
- URL: https://dc1.cyberinabox.net
- Requires admin credentials + MFA

**For Help:**
- Documentation: https://www.freeipa.org/page/Documentation
- Administrator: dshannon@cyberinabox.net
- AI Assistant: `claude` via SSH
