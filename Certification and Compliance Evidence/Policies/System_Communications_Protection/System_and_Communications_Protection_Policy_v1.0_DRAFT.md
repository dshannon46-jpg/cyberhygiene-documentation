# System and Communications Protection Policy

**Document ID:** TCC-SCP-001
**Version:** 1.0 (DRAFT)
**Effective Date:** TBD (Pending Approval)
**Review Schedule:** Annually
**Next Review:** December 2026
**Owner:** Daniel Shannon, ISSO/System Owner
**Distribution:** Authorized personnel only
**Classification:** CUI

---

## 1. Purpose

This policy establishes The Contract Coach's requirements for protecting system boundaries and communications on the CyberHygiene Production Network (CPN). It ensures confidentiality, integrity, and availability of Controlled Unclassified Information (CUI) during storage and transmission in compliance with NIST SP 800-171 Rev 2 (SC-1 through SC-28) and CMMC Level 2.

---

## 2. Scope

This policy applies to:

- **All CPN Systems:**
  - dc1.cyberinabox.net (192.168.1.10) - Domain Controller
  - ai.cyberinabox.net (192.168.1.7) - AI/ML Server
  - ws1, ws2, ws3.cyberinabox.net (192.168.1.21-23) - Workstations
  - pfSense firewall (192.168.1.1) - Network perimeter

- **All Communications:**
  - Network traffic (internal and external)
  - Email communications
  - File transfers
  - Remote access connections
  - Voice/video communications
  - Administrative sessions

- **All Data States:**
  - Data in transit (network communications)
  - Data at rest (stored on systems)
  - Data in use (active processing)

---

## 3. Policy Statements

### 3.1 Application Partitioning (SC-2)

**The organization shall:**

1. **Separate User Functionality from Management Functionality:**
   - Administrative interfaces separated from user interfaces
   - Management traffic on dedicated network segments where feasible
   - Web-based admin interfaces on non-standard ports with restricted access

2. **Service Isolation:**
   - Each major service runs on dedicated system or container
   - File server (Samba) separate from domain controller functions
   - AI/ML workloads isolated on dedicated hardware (ai.cyberinabox.net)

### 3.2 Security Function Isolation (SC-3)

**The organization shall:**

1. **Security Functions Isolated:**
   - SELinux mandatory access control enforces isolation
   - Wazuh SIEM operates on domain controller with dedicated resources
   - Firewall/IDS functions on separate hardware (pfSense appliance)

2. **Least Privilege for Security Components:**
   - Security services run with minimal required permissions
   - Dedicated service accounts for security tools
   - No direct user access to security component internals

### 3.3 Information in Shared Resources (SC-4)

**The organization shall:**

1. **Prevent Unauthorized Information Transfer:**
   - Memory sanitization on process termination
   - Temporary files securely deleted (shred, wipe)
   - No residual CUI data in RAM or storage after access

2. **Shared Resource Protections:**
   - SELinux type enforcement prevents cross-process information leakage
   - File system permissions restrict access to user-owned files only
   - Virtualization not used (dedicated hardware reduces shared resource risks)

### 3.4 Denial of Service Protection (SC-5)

**The organization shall protect against denial of service attacks:**

1. **Network-Level Protections:**
   - pfSense firewall with state table limits
   - Syn flood protection enabled
   - Connection rate limiting per source IP
   - Geographic IP blocking for high-risk countries

2. **Application-Level Protections:**
   - Apache MaxRequestWorkers limit (prevent resource exhaustion)
   - Email rate limiting (Postfix: 10 messages/hour from single source)
   - Failed authentication rate limiting (5 attempts = 30-minute lockout)

3. **Resource Management:**
   - System resource limits (ulimit) configured per user
   - CPU and memory limits on services via systemd
   - Disk quotas considered for future implementation

### 3.5 Resource Availability (SC-6)

**The organization shall:**

1. **Protect Availability of Resources:**
   - Critical services configured for automatic restart (systemd watchdog)
   - Monitoring alerts on resource exhaustion (Wazuh)
   - Storage capacity monitoring (alert at 75%, critical at 90%)

2. **Priority Resource Allocation:**
   - Critical services (FreeIPA, Wazuh) have elevated priority
   - Nice values adjusted to prioritize security services
   - QoS on network for VoIP/video if implemented

### 3.6 Boundary Protection (SC-7)

**The organization shall:**

1. **Managed Interfaces (SC-7):**
   - pfSense firewall controls all external connections
   - Default-deny firewall policy
   - Explicit allow rules for required services only
   - DMZ not required (no externally-facing services)

2. **External Telecommunications Services (SC-7(3)):**
   - Internet connectivity via commercial ISP
   - No direct external access to CPN resources
   - All external connections routed through pfSense
   - Future: VPN with MFA for authorized remote access (POA&M-028)

3. **Access Points (SC-7(7)):**
   - Single internet connection point (pfSense WAN interface)
   - All wireless access points disabled or removed
   - Physical network ports in server room secured

4. **Firewall Configuration:**
   - Stateful packet inspection enabled
   - Outbound connections allowed (workstations only)
   - Inbound connections blocked by default
   - Allowed inbound: None (air-gapped from external access)
   - Internal zone: 192.168.1.0/24 (trusted)

### 3.7 Split Tunneling Prevention (SC-7(4))

**The organization shall prevent:**

- Remote users from simultaneously connecting to CPN and untrusted networks
- VPN split tunneling prohibited when implemented (POA&M-028)
- All traffic routed through VPN tunnel (no local breakout)

### 3.8 Transmission Confidentiality and Integrity (SC-8, SC-8(1))

**The organization shall:**

1. **Encrypt CUI in Transit (SC-8(1)):**
   - **TLS 1.2 or higher** for all network communications
   - **SSH (OpenSSH 8.x+)** for administrative access
   - **Kerberos** for authentication (encrypted tickets)
   - **HTTPS** for all web-based services
   - **SMTPS/IMAPS** for email (TLS required)
   - **SMB3** with encryption for file sharing

2. **Prohibited Clear-Text Protocols:**
   - ❌ HTTP (redirect to HTTPS)
   - ❌ Telnet (SSH only)
   - ❌ FTP (SFTP only)
   - ❌ SMTP without TLS
   - ❌ POP3/IMAP without TLS

3. **Cryptographic Standards:**
   - FIPS 140-2 validated algorithms
   - AES-256 for symmetric encryption
   - RSA 3072-bit or ECDSA P-384 for asymmetric
   - SHA-256 or stronger for hashing
   - Perfect Forward Secrecy (PFS) enabled

### 3.9 Network Disconnect (SC-10)

**The organization shall:**

- Terminate network sessions after 15 minutes of inactivity
- SSH session timeout: ClientAliveInterval 300, ClientAliveCountMax 0
- Web session timeout: 15 minutes (application-specific)
- Kerberos ticket lifetime: 10 hours, renewable for 7 days

### 3.10 Cryptographic Key Establishment and Management (SC-12, SC-13)

**The organization shall:**

1. **FIPS 140-2 Cryptographic Protection (SC-13):**
   - FIPS mode enabled on all Rocky Linux systems
   - Only FIPS-approved algorithms permitted
   - Verification: `fips-mode-setup --check`

2. **Key Management (SC-12):**
   - **SSH Host Keys:**
     - Generated on first boot (automated)
     - RSA 3072-bit or Ed25519
     - Stored in `/etc/ssh/` with 0600 permissions
     - Backed up securely

   - **SSL/TLS Certificates:**
     - Commercial certificate from SSL.com (wildcard)
     - Private key: 2048-bit RSA minimum
     - Stored in `/etc/pki/tls/private/` with 0400 permissions
     - Annual renewal

   - **LUKS Encryption Keys:**
     - AES-256-XTS
     - Passphrase-based key derivation (PBKDF2)
     - Master key stored in LUKS header
     - Backup passphrase stored in secure location (physical safe)

   - **Kerberos Keys:**
     - Managed by FreeIPA
     - AES-256 encryption
     - Key rotation on password change

### 3.11 Cryptographic Protection (SC-13)

**Mandatory Cryptographic Use:**

| Data State | Protection Method | Algorithm |
|------------|-------------------|-----------|
| Data at Rest (disks) | LUKS full-disk encryption | AES-256-XTS |
| Data at Rest (macOS) | FileVault + T2/M4 Secure Enclave | AES-256-XTS |
| Data in Transit (web) | TLS 1.2+ | AES-256-GCM, ECDHE |
| Data in Transit (SSH) | OpenSSH | AES-256-CTR, Ed25519 |
| Data in Transit (email) | STARTTLS | AES-256-GCM |
| Data in Transit (files) | SMB3 encryption | AES-128-GCM |
| Authentication | Kerberos | AES-256-CTS-HMAC-SHA1-96 |
| VPN (future) | OpenVPN/WireGuard | AES-256-GCM / ChaCha20-Poly1305 |

### 3.12 Collaborative Computing Devices (SC-15)

**The organization shall:**

1. **Videoconferencing Security:**
   - Prohibit CUI discussion on unapproved platforms
   - Virtual backgrounds required to hide CUI in workspace
   - Microphone/camera muted when not actively speaking
   - Screen sharing limited to approved content only

2. **Approved Platforms:**
   - Zoom (enterprise account with encryption)
   - Microsoft Teams (with data residency in US)
   - Google Meet (enterprise only)

3. **Prohibited Platforms:**
   - Consumer-grade videoconferencing
   - Peer-to-peer video services
   - Platforms with foreign hosting/data storage

### 3.13 Protection of Information at Rest (SC-28, SC-28(1))

**The organization shall:**

1. **Full-Disk Encryption (SC-28(1)):**
   - **Rocky Linux systems:** LUKS AES-256-XTS
   - **macOS system (AI server):** FileVault with T2/M4 Secure Enclave
   - Encryption status verified monthly via OpenSCAP

2. **Encrypted Partitions:**
   - `/` root filesystem (LUKS)
   - `/home` user data (LUKS)
   - `/var` system logs and data (LUKS)
   - `/srv` file shares and services (LUKS)
   - `/data` CUI storage (LUKS)
   - `/backup` backup storage (LUKS - separate passphrase)

3. **Removable Media:**
   - USB drives encrypted with VeraCrypt or LUKS
   - CD/DVD burning prohibited (no optical drives)
   - External drives encrypted before CUI storage

4. **Backup Media Protection:**
   - Backup media encrypted (LUKS container)
   - Stored in locked, fireproof safe
   - Offsite backups transported in locked container
   - Annual backup restoration test

### 3.14 Mobile Code (SC-18)

**The organization shall:**

1. **Acceptable Mobile Code:**
   - JavaScript (web browsers, sandboxed)
   - Java (OpenJDK, from trusted repos only)
   - Python scripts (reviewed before execution)

2. **Prohibited Mobile Code:**
   - ActiveX controls
   - Flash/Shockwave
   - Unsigned Java applets
   - PowerShell scripts from untrusted sources

3. **Mobile Code Controls:**
   - Browser JavaScript enabled but restricted (NoScript extension considered)
   - Java applets blocked unless explicitly allowed
   - Code signing verification required for executables

### 3.15 Voice over Internet Protocol (SC-19)

**If VoIP is implemented:**

1. **VoIP Security Requirements:**
   - SIP/RTP encryption (SRTP)
   - Separate VLAN for voice traffic
   - Quality of Service (QoS) configured
   - VoIP provider must be US-based with encryption

2. **Current Status:** VoIP not implemented (traditional phone service used)

### 3.16 Secure Name/Address Resolution (SC-20, SC-21)

**The organization shall:**

1. **DNS Security (SC-20, SC-21):**
   - FreeIPA provides authoritative DNS for cyberinabox.net
   - DNSSEC enabled for external queries
   - DNS queries authenticated via TSIG (zone transfers)
   - Recursive queries restricted to internal network only

2. **DNS Configuration:**
   - Internal DNS: dc1.cyberinabox.net (192.168.1.10)
   - External forwarders: 1.1.1.1 (Cloudflare), 8.8.8.8 (Google)
   - DNS over TLS (DoT) for external queries (future enhancement)

### 3.17 Architecture and Provisioning for Name/Address Resolution (SC-22)

**The organization shall:**

- Provide authoritative DNS within CPN (FreeIPA integrated DNS)
- Fault-tolerant: Secondary DNS on future backup domain controller
- DNS records signed with DNSSEC

### 3.18 Session Authenticity (SC-23)

**The organization shall:**

1. **Protect Session Authenticity:**
   - Kerberos tickets authenticated and encrypted
   - TLS session IDs randomized
   - SSH session keys unique per connection
   - HTTP cookies marked Secure and HttpOnly

2. **Session Hijacking Protections:**
   - TCP sequence number randomization
   - Strong session token generation (cryptographically random)
   - Session binding to IP address (where feasible)
   - Automatic logout on session timeout

### 3.19 Fail in Known State (SC-24)

**The organization shall:**

- Systems fail to secure state on failure
- SELinux enforces deny-by-default on errors
- Firewall defaults to block on rule processing errors
- Services disabled if critical dependencies fail (systemd dependencies)

### 3.20 Thin Nodes (SC-25)

**Not applicable:** CPN does not use thin clients or zero clients.

### 3.21 Honeypots (SC-26)

**Not implemented:** Honeypots not deployed. Deception technology not required for current risk profile.

### 3.22 Platform-Independent Applications (SC-27)

**The organization shall prioritize:**

- Cross-platform tools where feasible (Python, Java)
- Open standards and protocols
- Avoid vendor lock-in to proprietary systems

### 3.23 Protection of Information at Rest (SC-28)

**Addressed in Section 3.13 (SC-28, SC-28(1))**

---

## 4. Roles and Responsibilities

### 4.1 System Owner

- Approve encryption and boundary protection policies
- Ensure adequate resources for security infrastructure
- Review and approve firewall rule changes
- Authorize VPN and remote access implementations

### 4.2 Information System Security Officer (ISSO)

- Define security architecture and boundary protections
- Configure and maintain firewall rules
- Manage cryptographic key lifecycle
- Monitor network security controls (IDS/IPS)
- Approve encryption implementations
- Conduct annual security architecture review

### 4.3 System Administrator

- Implement and maintain encryption (LUKS, TLS, SSH)
- Configure network security devices (pfSense, Suricata)
- Monitor security logs for boundary violations
- Maintain TLS certificates (renewal, deployment)
- Configure secure communication protocols
- Implement session timeout and termination controls

### 4.4 All Users

- Use encrypted communication channels for CUI
- Verify TLS certificate validity (green padlock)
- Report unencrypted CUI transmission
- Comply with session timeout policies
- Do not disable security features (TLS, encryption)

---

## 5. Implementation Details

### 5.1 pfSense Firewall Configuration

**Interfaces:**
- WAN: Internet-facing (DHCP from ISP)
- LAN: 192.168.1.0/24 (static 192.168.1.1)

**Default Rules:**
- WAN inbound: BLOCK ALL (default deny)
- LAN outbound: ALLOW (workstations need internet for updates)
- LAN to LAN: ALLOW (internal communication)

**Suricata IDS/IPS:**
- Emerging Threats Open ruleset
- Daily automatic updates
- IPS mode: Block and alert on threats
- Logs sent to Wazuh SIEM

**Advanced Settings:**
- SYN flood protection: enabled
- State table optimization: aggressive
- Bogon networks blocked
- RFC1918 WAN blocking: enabled

### 5.2 TLS/SSL Configuration

**Apache HTTPS Configuration:**

```apache
SSLEngine on
SSLProtocol -all +TLSv1.2 +TLSv1.3
SSLCipherSuite HIGH:!aNULL:!MD5:!3DES
SSLHonorCipherOrder on
SSLCompression off
SSLSessionTickets off
Header always set Strict-Transport-Security "max-age=31536000"
```

**Certificate Locations:**
- Certificate: `/etc/pki/tls/certs/wildcard.cyberinabox.net.crt`
- Private Key: `/etc/pki/tls/private/wildcard.cyberinabox.net.key`
- CA Chain: `/etc/pki/tls/certs/ca-bundle.crt`

### 5.3 SSH Hardening

**File:** `/etc/ssh/sshd_config`

```
Port 22
Protocol 2
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
ChallengeResponseAuthentication yes
UsePAM yes
X11Forwarding no
Ciphers aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512,hmac-sha2-256
KexAlgorithms ecdh-sha2-nistp384,ecdh-sha2-nistp256
ClientAliveInterval 300
ClientAliveCountMax 0
```

### 5.4 Email Encryption

**Postfix TLS Configuration:**

```
# Outbound TLS
smtp_tls_security_level = may
smtp_tls_loglevel = 1
smtp_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1

# Inbound TLS
smtpd_tls_security_level = may
smtpd_tls_auth_only = yes
smtpd_tls_cert_file = /etc/pki/tls/certs/wildcard.cyberinabox.net.crt
smtpd_tls_key_file = /etc/pki/tls/private/wildcard.cyberinabox.net.key
smtpd_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1
```

### 5.5 LUKS Encryption Verification

**Monthly Verification Script:**

```bash
#!/bin/bash
# Check LUKS encryption status on all partitions

for dev in $(lsblk -ln -o NAME,TYPE | awk '$2=="crypt" {print $1}'); do
    echo "Checking /dev/mapper/$dev"
    cryptsetup status $dev
    cryptsetup luksDump /dev/$(readlink -f /dev/mapper/$dev | sed 's|/dev/mapper/||')
done
```

**Expected Output:**
- Type: LUKS2
- Cipher: aes-xts-plain64
- Key size: 512 bits (AES-256)

### 5.6 Network Segmentation (Future)

**Planned VLANs (if implemented):**
- VLAN 10: Management (192.168.10.0/24)
- VLAN 20: User workstations (192.168.20.0/24)
- VLAN 30: Servers (192.168.30.0/24)
- VLAN 40: Guest (192.168.40.0/24 - isolated)

**Current State:** Single flat network (192.168.1.0/24)

---

## 6. Compliance Mapping

| NIST SP 800-171 Control | Implementation |
|-------------------------|----------------|
| **SC-1** Policy and Procedures | This document |
| **SC-2** Application Partitioning | Section 3.1 |
| **SC-3** Security Function Isolation | Section 3.2 |
| **SC-4** Information in Shared Resources | Section 3.3 |
| **SC-5** Denial of Service Protection | Section 3.4 |
| **SC-6** Resource Availability | Section 3.5 |
| **SC-7** Boundary Protection | Section 3.6 |
| **SC-7(3)** Access Points | Section 3.6.3 |
| **SC-7(4)** External Telecommunications | Section 3.7 |
| **SC-7(5)** Deny by Default / Allow by Exception | Section 3.6 firewall rules |
| **SC-8** Transmission Confidentiality/Integrity | Section 3.8 |
| **SC-8(1)** Cryptographic Protection | Section 3.8.1 |
| **SC-10** Network Disconnect | Section 3.9 |
| **SC-12** Cryptographic Key Management | Section 3.10 |
| **SC-13** Cryptographic Protection | Section 3.11 |
| **SC-15** Collaborative Computing Devices | Section 3.12 |
| **SC-17** Public Key Infrastructure | Section 3.10 (SSL certs) |
| **SC-18** Mobile Code | Section 3.14 |
| **SC-19** Voice over IP | Section 3.15 |
| **SC-20** Secure Name Resolution (authoritative) | Section 3.16 |
| **SC-21** Secure Name Resolution (recursive) | Section 3.16 |
| **SC-22** Architecture for Name Resolution | Section 3.17 |
| **SC-23** Session Authenticity | Section 3.18 |
| **SC-28** Protection of Information at Rest | Section 3.13 |
| **SC-28(1)** Cryptographic Protection (at rest) | Section 3.13.1 |

---

## 7. Prohibited Activities

**Users shall NOT:**

1. Disable or bypass encryption (LUKS, TLS, SSH)
2. Transmit CUI over unencrypted channels
3. Disable firewall or security services
4. Install unauthorized VPN or remote access software
5. Use split tunneling if VPN access granted
6. Modify cryptographic configurations
7. Share cryptographic keys or passphrases
8. Store CUI on unencrypted media
9. Use prohibited protocols (Telnet, FTP, HTTP for CUI)
10. Disable SELinux or FIPS mode

**Violations may result in:**
- Immediate account suspension
- Security incident investigation
- Termination of employment/contract
- Civil or criminal prosecution

---

## 8. Encryption Key Recovery

**In case of lost/forgotten encryption passphrase:**

1. **LUKS Backup Passphrase:**
   - Secondary passphrase stored in physical safe
   - Accessible only to System Owner and ISSO
   - Used to add new passphrase slot if primary lost

2. **Recovery Procedure:**
   - User contacts ISSO immediately
   - ISSO retrieves backup passphrase from safe
   - Temporary passphrase added to LUKS key slot
   - User sets new primary passphrase
   - Temporary slot removed

3. **If No Recovery Possible:**
   - Data is PERMANENTLY INACCESSIBLE (by design)
   - System restore from backups required
   - Incident documented and reported

---

## 9. Monitoring and Validation

**Monthly Security Checks:**

| Check | Command | Expected Result |
|-------|---------|----------------|
| FIPS mode | `fips-mode-setup --check` | FIPS mode is enabled |
| Encryption status | `lsblk -f` | crypto_LUKS on all partitions |
| Firewall status | `sudo firewall-cmd --state` | running |
| TLS certificate | `openssl s_client -connect localhost:443` | Valid cert, TLS 1.2+ |
| SSH config | `sudo sshd -T \| grep -i password` | PasswordAuthentication no |
| SELinux | `getenforce` | Enforcing |
| Suricata IDS | `sudo systemctl status suricata` | active (running) |

**Annual Security Assessment:**
- Penetration testing (internal or external)
- Firewall rule review and cleanup
- Encryption algorithm review (NIST updates)
- Certificate expiration tracking

---

## 10. Policy Review and Updates

- **Review Frequency:** Annually or upon significant security incidents
- **Update Triggers:**
  - New NIST cryptographic guidance
  - TLS/SSL vulnerabilities (Heartbleed, POODLE, etc.)
  - Firewall breach or attempted intrusion
  - Regulatory requirement changes
  - Technology refresh (VPN implementation, network segmentation)

- **Approval Authority:** System Owner / ISSO

---

## 11. Related Documents

- System Security Plan (SSP) - Section SC (System and Communications Protection)
- Configuration Management Policy (TCC-CMP-001)
- Incident Response Policy (TCC-IRP-001)
- Risk Acceptance Memo: ClamAV FIPS Incompatibility
- NIST SP 800-171 Rev 2
- NIST SP 800-52 Rev 2 (TLS Guidelines)
- NIST SP 800-77 Rev 1 (IPsec VPN Guide)

---

## 12. Definitions

- **Boundary Protection:** Monitoring and control of communications at external boundaries and key internal boundaries
- **Cryptographic Key:** Value used to control cryptographic operations (encryption, authentication)
- **FIPS 140-2:** Federal Information Processing Standard for cryptographic module validation
- **LUKS:** Linux Unified Key Setup - disk encryption specification
- **Session Hijacking:** Exploitation of a valid session to gain unauthorized access
- **Split Tunneling:** Simultaneous connection to secure and unsecure networks (prohibited)
- **TLS:** Transport Layer Security - cryptographic protocol for secure communications

---

## 13. Approval Signatures

**Prepared By:**
Name: Daniel Shannon, System Administrator
Signature: _________________________________ Date: __________

**Reviewed By:**
Name: Daniel Shannon, Information System Security Officer
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
