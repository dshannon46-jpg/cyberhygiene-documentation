# Appendix A: Glossary of Terms

## Security and Compliance Terms

**AIDE (Advanced Intrusion Detection Environment)**
File integrity monitoring tool that detects unauthorized file changes by comparing cryptographic checksums.

**Auditd**
Linux audit daemon that records system events for security monitoring and compliance.

**Authentication**
Process of verifying a user's identity (who you are) through credentials like passwords, SSH keys, or biometrics.

**Authorization**
Process of determining what an authenticated user is allowed to do (access control).

**CUI (Controlled Unclassified Information)**
Sensitive information that requires safeguarding but is not classified as Secret or Top Secret. Examples include personally identifiable information (PII), export-controlled data, and law enforcement sensitive information.

**Defense-in-Depth**
Security strategy employing multiple layers of controls so if one layer fails, others still provide protection.

**FIPS 140-2 (Federal Information Processing Standard 140-2)**
U.S. government standard for cryptographic modules, specifying approved encryption algorithms and security requirements.

**IDS/IPS (Intrusion Detection System / Intrusion Prevention System)**
Security tools that monitor network traffic for malicious activity. IDS detects and alerts; IPS can also block threats.

**Kerberos**
Network authentication protocol providing single sign-on (SSO) through encrypted ticket-based authentication.

**LDAP (Lightweight Directory Access Protocol)**
Protocol for accessing and maintaining directory information, used by FreeIPA for user and group management.

**Least Privilege**
Security principle of giving users only the minimum access rights needed to perform their jobs.

**MFA (Multi-Factor Authentication)**
Authentication requiring two or more verification factors (something you know + something you have + something you are).

**NIST 800-171**
National Institute of Standards and Technology publication defining security requirements for protecting CUI in non-federal systems.

**PKI (Public Key Infrastructure)**
Framework of roles, policies, and procedures for creating, managing, and revoking digital certificates.

**POA&M (Plan of Action and Milestones)**
Document describing tasks required to implement security controls, with timelines and assigned responsibilities.

**RBAC (Role-Based Access Control)**
Access control approach where permissions are assigned to roles, and users are assigned to roles.

**SELinux (Security-Enhanced Linux)**
Mandatory access control security mechanism providing fine-grained access controls beyond traditional Unix permissions.

**SIEM (Security Information and Event Management)**
Security solution providing real-time analysis of security alerts from applications and network hardware. Wazuh is our SIEM.

**SSO (Single Sign-On)**
Authentication scheme allowing users to log in once and access multiple services without re-authenticating.

**Zero Trust**
Security model based on the principle of "never trust, always verify" - all users and devices must be authenticated and authorized regardless of location.

## Technical Terms

**Agent**
Software component installed on monitored systems that collects and sends data to a central manager (e.g., Wazuh agent, Prometheus Node Exporter).

**API (Application Programming Interface)**
Set of protocols and tools for building software applications, allowing different programs to communicate.

**CLI (Command Line Interface)**
Text-based interface for interacting with computers by typing commands (e.g., SSH terminal).

**Daemon**
Background process that runs continuously, providing services (e.g., sshd, httpd).

**Dashboard**
Visual interface displaying system status, metrics, and data in an organized format (e.g., Grafana, Wazuh dashboards).

**DNS (Domain Name System)**
System that translates human-readable domain names (dc1.cyberinabox.net) into IP addresses (192.168.1.10).

**FQDN (Fully Qualified Domain Name)**
Complete domain name including hostname and domain (e.g., dc1.cyberinabox.net).

**GUI (Graphical User Interface)**
Visual interface using windows, icons, and menus for user interaction (opposite of CLI).

**Hash**
Fixed-size unique value generated from data using a cryptographic function (e.g., SHA-256). Used for integrity verification and password storage.

**IP Address**
Numerical label assigned to devices on a network (e.g., 192.168.1.10).

**JSON (JavaScript Object Notation)**
Lightweight data format for storing and exchanging data, commonly used in APIs and logs.

**Log**
Record of events, errors, and activities in a system. Stored in files like /var/log/messages.

**Metrics**
Quantitative measurements of system performance (CPU usage, memory, disk I/O, network traffic).

**Mount**
Action of making a filesystem or network share accessible at a specific directory path.

**NFS (Network File System)**
Protocol for sharing files across a network, allowing remote directories to appear local.

**Port**
Numerical identifier for a specific network service or process (e.g., 22 for SSH, 443 for HTTPS).

**Process**
Running instance of a program. Each process has a PID (Process ID).

**Prometheus**
Open-source monitoring and alerting toolkit that collects and stores time-series metrics.

**Protocol**
Set of rules defining how data is transmitted over a network (e.g., HTTP, SSH, TLS).

**Query**
Request for information from a database or search system.

**Repository (Repo)**
Storage location for software packages, allowing easy installation and updates.

**Root**
Superuser account with complete system access and control. Also refers to the top-level directory (/).

**Samba**
Software providing Windows-compatible file and print sharing on Linux systems.

**Service**
Long-running background program providing functionality (e.g., web server, database, SSH).

**Shell**
Command-line interpreter allowing users to execute commands (e.g., bash, zsh).

**SMTP (Simple Mail Transfer Protocol)**
Protocol for sending email between servers.

**Snapshot**
Point-in-time copy of a system or data, used for backups and recovery.

**SSH (Secure Shell)**
Cryptographic network protocol for secure remote access and file transfer.

**SSL/TLS (Secure Sockets Layer / Transport Layer Security)**
Cryptographic protocols providing secure communication over networks. TLS is the modern standard.

**Subnet**
Logical subdivision of an IP network (e.g., 192.168.1.0/24).

**Sudo**
Command allowing authorized users to execute commands with administrative privileges.

**Syslog**
Standard for message logging, allowing separation of software generating messages from systems storing them.

**TCP/IP (Transmission Control Protocol / Internet Protocol)**
Fundamental protocols of the internet, defining how data is transmitted.

**TOTP (Time-Based One-Time Password)**
Algorithm generating temporary passwords that change every 30 seconds, used for MFA.

**UID (User Identifier)**
Unique numerical ID assigned to each user account in Unix/Linux systems.

**URL (Uniform Resource Locator)**
Web address specifying the location of a resource (e.g., https://wazuh.cyberinabox.net).

**VPN (Virtual Private Network)**
Encrypted connection between a device and a network over the internet, enabling secure remote access.

**YAML (YAML Ain't Markup Language)**
Human-readable data serialization format commonly used for configuration files.

## CyberHygiene-Specific Terms

**Code Llama**
Local AI assistant running on Mac Mini M4 (192.168.1.7) for help, guidance, troubleshooting, and security alert analysis. Air-gapped and NIST 800-171 compliant. Access via llama/ai commands or web interface.

**CPM Dashboard**
CyberHygiene Project Management dashboard providing system overview and compliance status.

**CyberHygiene Production Network**
The complete NIST 800-171 compliant infrastructure consisting of 7 servers and associated services.

**FreeIPA**
Identity management solution providing centralized authentication, authorization, and user management for CyberHygiene.

**Grafana**
Visualization platform used for CyberHygiene system health and performance monitoring dashboards.

**Graylog**
Log management system providing centralized log collection, analysis, and search capabilities.

**Phase I**
Initial deployment phase of CyberHygiene project, achieving 100% POA&M completion and full NIST 800-171 compliance (completed December 2025).

**Phase II**
Planned next phase including VPN deployment, Windows domain integration, and additional features.

**POAM CyberInABox**
The specific Plan of Action and Milestones document tracking CyberHygiene security control implementation (29 items, 100% complete).

**Suricata**
Network IDS/IPS deployed on proxy system for real-time threat detection and prevention.

**Wazuh**
SIEM platform providing security monitoring, threat detection, and compliance monitoring across all CyberHygiene systems.

**YARA**
Malware detection tool using pattern-matching rules to identify malicious files.

## Service and Software Names

**Apache / httpd**
Web server software serving HTTP/HTTPS requests.

**Ansible**
Automation tool for configuration management and deployment.

**Authy**
Mobile app for generating TOTP codes for multi-factor authentication.

**Bitwarden**
Open-source password manager.

**ClamAV**
Open-source antivirus engine for detecting malware.

**Dogtag**
Certificate authority system integrated with FreeIPA.

**Elasticsearch**
Search and analytics engine, used by Graylog for log indexing.

**Firewalld**
Dynamic firewall manager for Linux systems.

**FreeOTP**
Open-source TOTP authenticator app recommended for MFA.

**Google Authenticator**
Mobile app for generating TOTP codes for multi-factor authentication.

**KeePassXC**
Open-source password manager with local encrypted database.

**Libreswan**
IPsec VPN implementation for Linux.

**LUKS (Linux Unified Key Setup)**
Disk encryption specification for Linux systems.

**MongoDB**
NoSQL database used by Graylog for metadata storage.

**Node Exporter**
Prometheus exporter for hardware and OS metrics, installed on all CyberHygiene systems.

**OpenSSH**
Secure Shell protocol implementation providing encrypted remote access.

**OpenSSL**
Cryptographic library providing TLS/SSL implementation and cryptographic functions.

**PuTTY**
SSH client for Windows.

**Rocky Linux**
Enterprise Linux distribution (RHEL-compatible) used on all CyberHygiene systems.

**Roundcube**
Web-based email client.

**Rsyslog**
System logging daemon for forwarding and processing log messages.

**Squid**
Web proxy and cache server.

**Systemd**
System and service manager for Linux.

**Termius**
Multi-platform SSH client.

**VirusTotal**
Online service for analyzing suspicious files and URLs.

## Acronyms Quick Reference

| Acronym | Full Name |
|---------|-----------|
| **AC** | Access Control |
| **AIDE** | Advanced Intrusion Detection Environment |
| **API** | Application Programming Interface |
| **AT** | Awareness and Training |
| **AU** | Audit and Accountability |
| **CA** | Certificate Authority / Certification and Accreditation |
| **CLI** | Command Line Interface |
| **CM** | Configuration Management |
| **CPM** | CyberHygiene Project Management |
| **CUI** | Controlled Unclassified Information |
| **DHCP** | Dynamic Host Configuration Protocol |
| **DNS** | Domain Name System |
| **FIPS** | Federal Information Processing Standards |
| **FQDN** | Fully Qualified Domain Name |
| **GUI** | Graphical User Interface |
| **IA** | Identification and Authentication |
| **IDS** | Intrusion Detection System |
| **IPS** | Intrusion Prevention System |
| **IR** | Incident Response |
| **KDC** | Key Distribution Center |
| **LDAP** | Lightweight Directory Access Protocol |
| **LUKS** | Linux Unified Key Setup |
| **MA** | Maintenance |
| **MFA** | Multi-Factor Authentication |
| **MP** | Media Protection |
| **NFS** | Network File System |
| **NIST** | National Institute of Standards and Technology |
| **OTP** | One-Time Password |
| **PE** | Physical Protection |
| **PID** | Process ID |
| **PII** | Personally Identifiable Information |
| **PKI** | Public Key Infrastructure |
| **POA&M** | Plan of Action and Milestones |
| **RA** | Risk Assessment |
| **RBAC** | Role-Based Access Control |
| **RE** | Recovery |
| **RHEL** | Red Hat Enterprise Linux |
| **SBOM** | Software Bill of Materials |
| **SC** | System and Communications Protection |
| **SCP** | Secure Copy Protocol |
| **SELinux** | Security-Enhanced Linux |
| **SFTP** | SSH File Transfer Protocol |
| **SI** | System and Information Integrity |
| **SIEM** | Security Information and Event Management |
| **SMTP** | Simple Mail Transfer Protocol |
| **SSH** | Secure Shell |
| **SSO** | Single Sign-On |
| **SSL** | Secure Sockets Layer |
| **SSP** | System Security Plan |
| **TCP** | Transmission Control Protocol |
| **TGT** | Ticket-Granting Ticket |
| **TLS** | Transport Layer Security |
| **TOTP** | Time-Based One-Time Password |
| **UDP** | User Datagram Protocol |
| **UID** | User Identifier |
| **URL** | Uniform Resource Locator |
| **VPN** | Virtual Private Network |
| **YAML** | YAML Ain't Markup Language |

## Common Commands

**cd** - Change directory
**chmod** - Change file permissions
**chown** - Change file ownership
**cp** - Copy files or directories
**df** - Display disk space usage
**du** - Display directory space usage
**grep** - Search text for patterns
**kinit** - Get Kerberos ticket
**klist** - List Kerberos tickets
**ls** - List directory contents
**mkdir** - Create directory
**mount** - Mount filesystem
**mv** - Move or rename files
**passwd** - Change password
**ping** - Test network connectivity
**ps** - Display running processes
**pwd** - Print working directory
**rm** - Remove files or directories
**scp** - Secure copy files
**sftp** - SSH file transfer
**ssh** - Secure shell remote access
**sudo** - Execute command as superuser
**systemctl** - Control systemd services
**tail** - Display end of file
**top** - Display system resource usage
**whoami** - Display current user

---

**Usage Tips:**

To search this glossary:
```bash
# From command line
grep -i "term" Appendix_A_Glossary.md

# Using less pager
less Appendix_A_Glossary.md
# Then type: /search_term
```

**Related Appendices:**
- Appendix B: Service URLs & Access Points
- Appendix C: Command Reference
- Appendix D: Troubleshooting Guide

**For More Detailed Information:**
- See relevant chapters in User Manual
- Ask AI assistant: `llama` or `ai` command
- Contact support: dshannon@cyberinabox.net
