# Chapter 6: User Accounts & Access

## 6.1 Account Provisioning

### Account Request Process

**Who Can Request Accounts:**
- Employees (new hires)
- Contractors (with valid contracts)
- Partners (with business justification)
- Service accounts (for applications)

**Request Procedure:**

1. **Submit Request**
   - Email: System Administrator (dshannon@cyberinabox.net)
   - Subject: "New Account Request: [Name]"
   - Include:
     - Full name
     - Job title/role
     - Department
     - Required access level
     - Manager approval
     - Start date

2. **Approval**
   - Manager approval required
   - Security team review (for elevated access)
   - Compliance check (background verification)

3. **Account Creation**
   - Processed within 1 business day
   - Account created in FreeIPA
   - Temporary password generated
   - Welcome email sent

4. **Initial Login**
   - User receives credentials
   - Must change password on first login
   - MFA setup required (if applicable)
   - Review Acceptable Use Policy

### Account Activation Timeline

```
Day 0: Request submitted
    ↓
Day 1: Approval received
    ↓
Day 1-2: Account created
    ↓
Day 2: Welcome email sent
    ↓
User: First login, password change, MFA setup
```

**Typical Processing Time:** 1-2 business days

## 6.2 FreeIPA Identity Management

### What is FreeIPA?

**FreeIPA** (Free Identity, Policy, and Audit) is the centralized identity management system for the CyberHygiene network.

**Functions:**
- User account management
- Group management
- Authentication (Kerberos)
- Authorization (LDAP)
- Certificate management (PKI)
- Host-based access control
- Sudo rule management
- SSH key distribution

### FreeIPA Web Interface

**Access:** https://dc1.cyberinabox.net

**Login Process:**
1. Navigate to FreeIPA URL
2. Enter username and password
3. Complete MFA challenge (if required)
4. Click "Log In"

**Self-Service Features:**

**Change Your Password:**
1. Login to FreeIPA web interface
2. Click your username (top right)
3. Select "Change Password"
4. Enter current password
5. Enter new password (must meet complexity requirements)
6. Confirm new password
7. Click "Update"

**Manage SSH Keys:**
1. Login to FreeIPA
2. Navigate to Identity → Users → [Your username]
3. Scroll to "SSH public keys"
4. Click "Add" to add new key
5. Paste your public key (from `~/.ssh/id_rsa.pub`)
6. Click "Add"

**View Your Groups:**
1. Login to FreeIPA
2. Navigate to Identity → Users → [Your username]
3. Click "Member of groups" tab
4. View all groups you belong to

**Reset OTP Token (MFA):**
1. Login to FreeIPA
2. Navigate to Identity → Users → [Your username]
3. Click "Actions" → "Reset OTP"
4. Scan new QR code with authenticator app

### FreeIPA User Attributes

**Standard Attributes:**
- Username (login name)
- Full name (first, last)
- Email address
- Employee ID/number
- Manager
- Department
- Job title
- Phone number
- Office location

**System Attributes:**
- UID (user ID number)
- GID (primary group ID)
- Home directory path
- Login shell
- Account status (enabled/disabled)
- Password expiry date
- Last login timestamp

## 6.3 Account Types and Roles

### User Account Types

#### 1. Standard User Accounts

**Purpose:** Regular employees and contractors
**Access Level:** Basic network services
**Default Groups:** `users`, department-specific groups

**Capabilities:**
- ✅ SSH access to permitted systems
- ✅ File share access (Samba/NFS)
- ✅ Email (Roundcube webmail)
- ✅ Web applications (read-only dashboards)
- ❌ Administrative functions
- ❌ System configuration changes

**Example:**
```
Username: jsmith
Full Name: John Smith
Groups: users, engineering
Access: SSH, file shares, email
Dashboards: Grafana (read-only), CPM (read-only)
```

#### 2. Privileged User Accounts

**Purpose:** IT staff, system administrators
**Access Level:** Administrative access via sudo
**Default Groups:** `admins`, `wheel`

**Capabilities:**
- ✅ All standard user capabilities
- ✅ Sudo access (elevated privileges)
- ✅ Dashboard administration
- ✅ User management (if authorized)
- ✅ System configuration
- ✅ Service management

**Example:**
```
Username: dshannon
Full Name: David Shannon
Groups: users, admins, wheel
Access: Full administrative access
Dashboards: All dashboards (admin access)
```

#### 3. Service Accounts

**Purpose:** Application and service authentication
**Access Level:** Limited to specific service needs
**Naming Convention:** `svc_[application]`

**Characteristics:**
- No interactive login
- Long, random passwords
- Limited sudo access (if any)
- Specific file/directory permissions
- Audited activity

**Examples:**
```
svc_backup - Backup service account
svc_monitoring - Prometheus monitoring
svc_web - Web application service
```

#### 4. Emergency/Break-Glass Accounts

**Purpose:** Emergency access if primary auth fails
**Access Level:** Full administrative
**Security:** Offline password storage, audit logging

**Characteristics:**
- Used only in emergencies
- Every use is investigated
- Password changed after each use
- Physical access required (console)

### Role-Based Groups

**Engineering Group:**
- Members: Engineering team
- Access: Development systems, code repositories
- File shares: /datastore/engineering

**Operations Group:**
- Members: IT operations staff
- Access: Monitoring dashboards, log analysis
- File shares: /datastore/operations

**Administrators Group:**
- Members: System administrators
- Access: Full system access, sudo privileges
- File shares: All shares

**Security Group:**
- Members: Security team
- Access: SIEM, IDS/IPS, security tools
- File shares: /datastore/security

## 6.4 Access Request Process

### Requesting Additional Access

**When to Request:**
- Need access to restricted file shares
- Require sudo privileges for specific tasks
- Need access to additional systems
- Job role change
- Project requirements

**Request Procedure:**

**Step 1: Submit Request**
```
To: dshannon@cyberinabox.net
Subject: Access Request: [Resource Name]

User: [Your username]
Resource: [System/share/group name]
Business Justification: [Why you need access]
Duration: [Permanent or temporary with end date]
Manager Approval: [CC your manager]
```

**Step 2: Approval Process**
1. Manager reviews and approves
2. Security team reviews (for elevated access)
3. Access granted or denied with reason
4. Notification sent to requestor

**Step 3: Access Provisioned**
- Group membership added
- Permissions configured
- Confirmation email sent
- Effective immediately (or at scheduled time)

**Step 4: Periodic Review**
- All access reviewed quarterly
- Unused access removed
- Re-certification required annually

### Access Revocation

**Automatic Revocation:**
- Account termination (employee departure)
- End of contract (contractors)
- Project completion (temporary access)
- Inactivity (90 days)

**Process:**
1. HR notifies IT of termination
2. Account disabled immediately
3. Kerberos tickets invalidated
4. Active sessions terminated
5. File access removed
6. Manager receives confirmation

## 6.5 Account Lifecycle

### Account Stages

#### 1. Provisioning (Days 1-2)
- Request submitted and approved
- Account created in FreeIPA
- Groups assigned
- Home directory created
- SSH keys configured (if provided)
- Welcome email sent

#### 2. Active Use (Ongoing)
- User logs in regularly
- Access resources as permitted
- Password changes (90-day expiry)
- MFA token refreshes
- Quarterly access reviews

#### 3. Modification (As Needed)
- Role changes
- Group membership updates
- Access level adjustments
- Department transfers
- Manager changes

#### 4. Suspension (Temporary)
- Extended leave (medical, personal)
- Investigation (security incident)
- Contract pause
- Account disabled, data retained
- Re-activation available

#### 5. Termination (Permanent)
- Employee departure
- Contract end
- Policy violation
- Account disabled
- Data archived (30 days)
- Resources reclaimed

### Account Maintenance

**User Responsibilities:**
- Keep password secure
- Update contact information
- Report security issues
- Follow Acceptable Use Policy
- Maintain MFA device

**Administrator Responsibilities:**
- Review accounts quarterly
- Disable inactive accounts (90 days)
- Update user attributes
- Process access requests
- Investigate anomalous activity

**Automated Processes:**
- Password expiry warnings (14, 7, 3 days before)
- Account lockout (failed login attempts)
- Inactive account reports
- Access certification reminders
- Audit log collection

---

**Account Summary:**

| Account Type | Count | Purpose | Sudo Access |
|--------------|-------|---------|-------------|
| Standard Users | ~20 | Regular employees | No |
| Privileged Users | ~3 | System administrators | Yes |
| Service Accounts | ~10 | Application services | Limited |
| Emergency Accounts | 1 | Break-glass access | Yes |

**Account Policies:**

| Policy | Setting |
|--------|---------|
| Password Complexity | 15 characters minimum, mixed case, numbers, symbols |
| Password Expiry | 90 days |
| Failed Login Lockout | 5 attempts, 30-minute lockout |
| Inactivity Timeout | 90 days (account disabled) |
| MFA Requirement | Privileged users, remote access |
| Session Timeout | 8 hours (Kerberos tickets) |

---

**Related Chapters:**
- Chapter 7: Password & Authentication
- Chapter 8: Multi-Factor Authentication (MFA)
- Chapter 27: User Management (FreeIPA) - Administrator Guide
- Appendix E: Contact Information

**For More Information:**
- FreeIPA documentation: https://www.freeipa.org/page/Documentation
- Account request email: dshannon@cyberinabox.net
