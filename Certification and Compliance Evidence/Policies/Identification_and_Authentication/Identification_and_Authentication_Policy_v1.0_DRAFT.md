# Identification and Authentication Policy

**Document ID:** TCC-IAP-001
**Version:** 1.0 (DRAFT)
**Effective Date:** TBD (Pending Approval)
**Review Schedule:** Annually
**Next Review:** December 2026
**Owner:** Daniel Shannon, ISSO/System Owner
**Distribution:** Authorized personnel only
**Classification:** CUI

---

## 1. Purpose

This policy establishes The Contract Coach's requirements for user identification and authentication on the CyberHygiene Production Network (CPN). It ensures only authorized individuals access systems and Controlled Unclassified Information (CUI) in compliance with NIST SP 800-171 Rev 2 (IA-1 through IA-11) and CMMC Level 2.

---

## 2. Scope

This policy applies to:

- **All CPN Systems:**
  - dc1.cyberinabox.net - Domain Controller / FreeIPA
  - ai.cyberinabox.net - AI/ML Server
  - ws1, ws2, ws3.cyberinabox.net - Workstations
  - pfSense firewall - Network infrastructure
  - All services (email, file sharing, web applications)

- **All Users:**
  - Employees
  - Contractors and subcontractors
  - System and service accounts
  - Temporary and guest accounts (if authorized)

- **Authentication Methods:**
  - Password/passphrase
  - SSH keys
  - Multi-factor authentication (MFA)
  - Kerberos tickets

---

## 3. Policy Statements

### 3.1 User Identification and Authentication (IA-2)

**The organization shall:**

1. **Unique User Accounts:**
   - Every user assigned unique identifier (no shared accounts)
   - User IDs tied to individual identity (First.Last format preferred)
   - Generic accounts prohibited (e.g., "admin", "user", "test")

2. **Authentication Required:**
   - Users authenticate before accessing any CPN resource
   - Re-authentication required after session timeout (15 minutes idle)
   - No "remember me" or saved password features on production systems

3. **Multi-Factor Authentication (IA-2(1), IA-2(2)):**
   - **Required for:**
     - Privileged accounts (system administrators, ISSO)
     - Remote access (VPN)
     - Non-organizational users (contractors, vendors) - POA&M-SPRS-1

   - **MFA Methods:**
     - Hardware tokens (YubiKey - preferred)
     - Time-based One-Time Password (TOTP) via FreeIPA OTP
     - SMS/email (least preferred, emergency backup only)

   - **Implementation Timeline:**
     - Organizational users: Q4 2025
     - Contractors: Q1 2026 (POA&M-SPRS-1)

4. **Service Accounts:**
   - Dedicated service accounts for automated processes
   - No interactive login permitted
   - Kerberos keytab authentication (no passwords stored in scripts)
   - Annual review and re-authorization

### 3.2 Device Identification and Authentication (IA-3)

**The organization shall:**

1. **Network Device Authentication:**
   - Devices authenticate before network access
   - MAC address filtering on critical VLANs
   - 802.1X authentication (future enhancement)

2. **Hardware Token Authentication:**
   - YubiKeys for MFA
   - Device serial numbers tracked in asset inventory
   - Lost/stolen tokens immediately revoked

### 3.3 Identifier Management (IA-4, IA-5)

**User Account Creation (IA-4):**

1. **Account Request Process:**
   - Formal request submitted to ISSO
   - Business justification required
   - Role and access level specified
   - Supervisor/sponsor approval

2. **Account Provisioning:**
   - Unique username assigned (First.Last@cyberinabox.net)
   - Created in FreeIPA directory
   - Kerberos principal generated
   - Initial groups assigned (ipausers minimum)
   - Home directory created with proper permissions

3. **Account Lifecycle:**
   - **Active:** Regular review (quarterly for contractors, annually for employees)
   - **Disabled:** Immediate upon termination or extended leave (>30 days)
   - **Deleted:** 90 days after termination (after backup retention)

**Authenticator Management (IA-5):**

1. **Password Requirements (IA-5(1)):**
   - **Length:** 14 characters minimum (FreeIPA policy enforced)
   - **Complexity:** At least 3 character classes (upper, lower, number, special)
   - **Expiration:** 90 days (configurable per user role)
   - **History:** Cannot reuse last 24 passwords
   - **Lockout:** 5 failed attempts = 30-minute lockout
   - **Transmission:** Never transmitted in clear text (Kerberos/TLS only)

2. **Initial Password:**
   - System-generated temporary password (complexity enforced)
   - Must change on first login
   - Delivered out-of-band (phone call, encrypted email, in-person)
   - Expires in 24 hours if not changed

3. **Password Reset:**
   - User identity verified before reset (security questions, supervisor confirmation)
   - Reset performed by ISSO or System Administrator only
   - New temporary password provided out-of-band
   - Immediate change required

4. **SSH Key Management (IA-5(2)(c)):**
   - **Key Generation:**
     - RSA 3072-bit minimum or Ed25519
     - Generated on user's local system (private key never transmitted)
   - **Public Key Registration:** Uploaded to FreeIPA or added to `~/.ssh/authorized_keys`
   - **Private Key Protection:**
     - Encrypted with passphrase (required)
     - File permissions: 0600 (read/write owner only)
     - Stored on encrypted filesystem only
   - **Key Rotation:** Annual rotation recommended
   - **Revocation:** Immediate removal upon termination or compromise

### 3.4 Authenticator Feedback (IA-6)

**The organization shall:**

- Obscure password entry (display as asterisks or dots)
- No password display in logs or error messages
- SSH key fingerprints displayed (not full keys)
- Failed login attempts do not reveal username validity

### 3.5 Cryptographic Module Authentication (IA-7)

**The organization shall:**

- Use FIPS 140-2 validated cryptographic modules for authentication
- FIPS mode enabled on all Rocky Linux systems
- FileVault/LUKS encryption with FIPS-approved algorithms
- TLS 1.2+ for all network authentication protocols

### 3.6 Identification and Authentication (Non-Organizational Users) (IA-8)

**For contractors, vendors, and partners:**

1. **Account Requirements:**
   - Separate accounts from organizational users
   - Naming convention: contractor.firstname.lastname
   - Limited group membership (e.g., file_share_ro)
   - Explicit expiration date (contract end date)

2. **Multi-Factor Authentication (IA-8(1)):**
   - **Required:** MFA for all non-organizational users (POA&M-SPRS-1)
   - **Method:** YubiKey hardware tokens
   - **Enrollment:** Before system access granted
   - **Backup:** TOTP as fallback

3. **Enhanced Monitoring:**
   - All contractor activity logged
   - Weekly access review
   - Immediate revocation upon contract termination

### 3.7 Service Identification and Authentication (IA-9)

**The organization shall:**

1. **Service-to-Service Authentication:**
   - Kerberos service principals for automated processes
   - TLS client certificates for API authentication
   - API keys rotated annually minimum

2. **Service Account Security:**
   - No shared service accounts between systems
   - Least privilege principle applied
   - Dedicated Kerberos keytabs (not passwords)
   - Documented ownership and purpose

### 3.8 Adaptive Authentication (IA-10)

**The organization shall implement adaptive authentication based on:**

1. **Risk Factors:**
   - Login time (off-hours access triggers alert)
   - Geographic location (if remote access implemented)
   - Failed login attempt history
   - Account privilege level

2. **Adaptive Responses:**
   - Additional authentication challenges for high-risk logins
   - Account lockout after repeated failures
   - ISSO notification for suspicious patterns

### 3.9 Re-Authentication (IA-11)

**The organization shall require re-authentication:**

1. **Session Timeouts:**
   - Interactive sessions: 15 minutes idle timeout (AC-11)
   - Screen lock activates automatically
   - Re-authentication required to resume

2. **Privilege Escalation:**
   - sudo requires password re-entry (timeout: 15 minutes)
   - Root access logs separate session

3. **Sensitive Operations:**
   - Password changes require current password
   - Account modifications require ISSO approval
   - Critical system changes require multi-person authorization

---

## 4. Roles and Responsibilities

### 4.1 System Owner

- Approve identification and authentication policy
- Authorize privileged account creation
- Review quarterly access reports
- Ensure resource allocation for MFA implementation

### 4.2 Information System Security Officer (ISSO)

- Manage user account lifecycle
- Enforce password and authentication policies
- Configure FreeIPA password policies
- Approve contractor account requests
- Conduct quarterly account reviews
- Investigate authentication anomalies
- Maintain authenticator inventory (YubiKeys)

### 4.3 System Administrator

- Implement technical authentication controls
- Configure FreeIPA and Kerberos
- Provision and deprovision user accounts
- Monitor authentication logs
- Respond to account lockouts
- Maintain SSH key infrastructure

### 4.4 All Users

- Protect authentication credentials (passwords, SSH keys)
- Use strong, unique passwords (password managers recommended)
- Never share passwords or SSH private keys
- Report lost/stolen authentication tokens immediately
- Change passwords if compromise suspected
- Complete MFA enrollment when required

---

## 5. Implementation Details

### 5.1 FreeIPA Password Policy

**Global Policy:**
```
ipa pwpolicy-show
  Max lifetime (days): 90
  Min lifetime (hours): 1
  History size: 24
  Min character classes: 3
  Min length: 14
  Max failures: 5
  Failure reset interval: 30 minutes
  Lockout duration: 30 minutes
```

**Privileged User Policy:**
```
ipa pwpolicy-add --desc="Admin Policy" --maxlife=60 --minlife=1 \
  --history=24 --minclasses=4 --minlength=16 --maxfail=3 \
  --failinterval=30 --lockouttime=60 admins
```

### 5.2 SSH Configuration

**File:** `/etc/ssh/sshd_config`

**Key Settings:**
```
PermitRootLogin no
PasswordAuthentication no (key-based only)
PubkeyAuthentication yes
AuthorizedKeysCommand /usr/bin/sss_ssh_authorizedkeys (FreeIPA integration)
ChallengeResponseAuthentication yes (for OTP)
UsePAM yes
```

### 5.3 Account Naming Standards

**Format:**
- **Employees:** firstname.lastname (e.g., daniel.shannon)
- **Contractors:** contractor.firstname.lastname (e.g., contractor.john.doe)
- **Service Accounts:** svc-purpose (e.g., svc-backup, svc-wazuh)
- **System Accounts:** sys-hostname (e.g., sys-dc1)

**Restrictions:**
- No special characters except hyphen and period
- Lowercase only
- Maximum 32 characters
- No spaces

### 5.4 Multi-Factor Authentication Enrollment

**YubiKey Enrollment Process:**

1. **User receives YubiKey:**
   - Serial number recorded in asset inventory
   - User signs acknowledgment form

2. **Enrollment in FreeIPA:**
   ```bash
   ipa otptoken-add --type=totp --owner=username --desc="YubiKey SN:12345"
   ```

3. **User Tests MFA:**
   - SSH login with password + OTP
   - Web UI login with password + OTP

4. **Backup TOTP Configured:**
   - QR code generated for mobile app (Google Authenticator, Authy)
   - Backup codes printed and secured

### 5.5 Account Review Process

**Quarterly Review (Due: Last Friday of March, June, September, December):**

1. **Generate Account List:**
   ```bash
   ipa user-find --all --raw | grep uid:
   ```

2. **Review Checklist:**
   - [ ] Account still required (active employee/contractor)
   - [ ] Access level appropriate for role
   - [ ] Password changed within policy timeframe
   - [ ] No excessive failed login attempts
   - [ ] MFA enrolled (if required)
   - [ ] Last login within expected timeframe

3. **Actions:**
   - Disable inactive accounts (>90 days no login, non-critical)
   - Remove expired contractor accounts
   - Adjust permissions if role changed
   - Document review in `/var/log/account-reviews/YYYY-QN.log`

---

## 6. Compliance Mapping

| NIST SP 800-171 Control | Implementation |
|-------------------------|----------------|
| **IA-1** Policy and Procedures | This document |
| **IA-2** Identification and Authentication | Section 3.1 |
| **IA-2(1)** Network Access to Privileged Accounts - MFA | Section 3.1.3 |
| **IA-2(2)** Network Access to Non-Privileged Accounts - MFA | Section 3.1.3 |
| **IA-3** Device Identification and Authentication | Section 3.2 |
| **IA-4** Identifier Management | Section 3.3 |
| **IA-5** Authenticator Management | Section 3.3 |
| **IA-5(1)** Password-Based Authentication | Section 3.3.1 |
| **IA-5(2)(c)** PKI-Based Authentication (SSH keys) | Section 3.3.4 |
| **IA-6** Authenticator Feedback | Section 3.4 |
| **IA-7** Cryptographic Module Authentication | Section 3.5 |
| **IA-8** Identification and Authentication (Non-Org Users) | Section 3.6 |
| **IA-9** Service Identification and Authentication | Section 3.7 |
| **IA-10** Adaptive Identification and Authentication | Section 3.8 |
| **IA-11** Re-Authentication | Section 3.9 |

---

## 7. Enforcement and Penalties

Violations of this policy may result in:

1. **Password Policy Violations:**
   - Account lockout (automatic)
   - Password reset by ISSO
   - Security awareness re-training

2. **Shared Credentials:**
   - Immediate termination of both accounts
   - Written reprimand
   - Potential termination of employment/contract

3. **Lost/Stolen Tokens (Unreported):**
   - Written warning (first offense)
   - Suspension of access (subsequent offenses)

4. **Circumventing Authentication Controls:**
   - Immediate account termination
   - Incident investigation
   - Potential civil/criminal prosecution

---

## 8. Policy Review and Updates

- **Review Frequency:** Annually or upon security incidents involving authentication
- **Update Triggers:**
  - New NIST guidance on authentication
  - Successful authentication bypass incidents
  - MFA technology changes
  - Regulatory requirement updates

- **Approval Authority:** System Owner / ISSO

---

## 9. Related Documents

- System Security Plan (SSP) - Section IA (Identification and Authentication)
- Acceptable Use Policy (TCC-AUP-001)
- Access Control Policy (future)
- Personnel Security Policy (TCC-PSP-001)
- NIST SP 800-171 Rev 2
- NIST SP 800-63B (Digital Identity Guidelines - Authentication)

---

## 10. Definitions

- **Authenticator:** Means of confirming identity (password, token, biometric, SSH key)
- **FreeIPA:** Open-source identity management system (LDAP + Kerberos + DNS)
- **Kerberos:** Network authentication protocol using tickets
- **MFA (Multi-Factor Authentication):** Two or more authentication factors (something you know + something you have)
- **SSH Key:** Public-key cryptography for SSH authentication
- **TOTP:** Time-based One-Time Password (6-digit code rotates every 30 seconds)

---

## 11. Approval Signatures

**Prepared By:**
Name: Daniel Shannon, Information System Security Officer
Signature: _________________________________ Date: __________

**Reviewed By:**
Name: Daniel Shannon, System Administrator
Signature: _________________________________ Date: __________

**Approved By:**
Name: _______________________, System Owner
Signature: _________________________________ Date: __________

---

**CLASSIFICATION:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**DISTRIBUTION:** Official Use Only - Need to Know Basis
**STATUS:** DRAFT - Pending Review and Approval

---

**END OF DOCUMENT**
