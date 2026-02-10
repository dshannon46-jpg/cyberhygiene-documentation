# CyberHygiene Phase II Installation Information Form

**Version:** 1.0
**Date:** 2026-01-01
**Purpose:** Collect customer-specific information for CyberHygiene deployment

---

## 1. Business Information

### Company Details
- **Business Name (Legal):** _______________________________________________
- **Business Name (DBA):** _______________________________________________
- **Physical Address:** _______________________________________________
- **City, State, ZIP:** _______________________________________________
- **Phone Number:** _______________________________________________
- **Primary Contact:** _______________________________________________
- **Contact Email:** _______________________________________________

### Business Identifiers
- **DUNS Number:** _______________________________________________
- **CAGE Code:** _______________________________________________
- **Tax ID (EIN):** _______________________________________________
- **Industry Vertical:** _______________________________________________
- **Number of Employees:** _______________________________________________

---

## 2. Domain and Network Configuration

### Domain Name
- **Fully Qualified Domain Name (FQDN):** _______________________________________________
  - Example: `customer.com` or `cyberhygiene.customer.com`
  - Must be owned by customer and DNS managed

### Network Configuration
- **Static IP Address (External):** _______________________________________________
  - Public IP for incoming connections
  - Must be static (not DHCP)

- **Internal Network Subnet:** _______________________________________________
  - Default: `192.168.1.0/24`
  - Can be customized if conflicts exist

- **Gateway/Router IP:** _______________________________________________
  - Default: `192.168.1.1`

- **DNS Servers (External):** _______________________________________________
  - Primary: _______________
  - Secondary: _______________

### IP Address Assignments (Internal)
Based on subnet selected above:

| Server | Hostname | IP Address | Notes |
|--------|----------|------------|-------|
| Domain Controller | dc1.[DOMAIN] | .10 | Identity, DNS, CA |
| Document Server | dms.[DOMAIN] | .20 | File Sharing |
| Log Management | graylog.[DOMAIN] | .30 | Centralized Logging |
| Web Proxy | proxy.[DOMAIN] | .40 | Proxy, IDS/IPS |
| Monitoring | monitoring.[DOMAIN] | .50 | Metrics, Dashboards |
| Security | wazuh.[DOMAIN] | .60 | SIEM, Compliance |

---

## 3. SSL/TLS Certificate Information

### Wildcard Certificate Required
- **Certificate Type:** Wildcard SSL Certificate for *.[DOMAIN]
- **Certificate Provider:** _______________________________________________
  - Recommended: Let's Encrypt (free) or commercial CA

### Certificate Files Needed
- [ ] Private Key File (`.key`)
- [ ] Certificate File (`.crt` or `.pem`)
- [ ] CA Bundle/Intermediate Certificates (`.ca-bundle` or `.chain.pem`)
- [ ] Full Chain Certificate (`.fullchain.pem`)

**Storage Location:** `/root/ssl-certificates/` on installation media

### Certificate Details (if already obtained)
- **Issuer:** _______________________________________________
- **Expiration Date:** _______________________________________________
- **Key Size:** ☐ 2048-bit  ☐ 4096-bit  ☐ Other: ___________

---

## 4. User Accounts

### Administrator Account
- **Admin Username:** _______________________________________________
  - Default: `admin`
  - Used for FreeIPA domain administration

- **Admin Email:** _______________________________________________

### Initial User Accounts (minimum 1, maximum 10 for initial setup)

| # | Full Name | Username | Email Address | Department | Role |
|---|-----------|----------|---------------|------------|------|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |
| 4 | | | | | |
| 5 | | | | | |
| 6 | | | | | |
| 7 | | | | | |
| 8 | | | | | |
| 9 | | | | | |
| 10 | | | | | |

**Note:** Additional users can be added post-installation

---

## 5. System Configuration Preferences

### Time Zone
- **Time Zone:** _______________________________________________
  - Example: `America/New_York`, `America/Los_Angeles`
  - Default: `America/Denver`

### Email Configuration (Optional - for alerts)
- **SMTP Server:** _______________________________________________
- **SMTP Port:** _______________________________________________
  - Typical: 587 (TLS), 465 (SSL), 25 (unencrypted - not recommended)
- **SMTP Username:** _______________________________________________
- **SMTP Password:** _______________________________________________
- **From Email Address:** _______________________________________________

### Backup Configuration
- **Backup Destination:** ☐ USB Drive  ☐ NAS  ☐ Cloud (encrypted)  ☐ Other: ___________
- **Backup Schedule:** ☐ Daily  ☐ Weekly  ☐ Custom: ___________
- **Retention Period:** ☐ 7 days  ☐ 30 days  ☐ 90 days  ☐ Custom: ___________

---

## 6. Hardware Information

### Server Specifications
- **Server Model:** _______________________________________________
  - Recommended: HP Proliant DL 20 Gen10 Plus

- **Processor:** _______________________________________________
  - Minimum: Intel Xeon E-2334 (4 cores, 3.4 GHz)

- **Memory (RAM):** _______________________________________________
  - Minimum: 64 GB
  - Recommended: 128 GB for optimal performance

- **Storage - Boot Drive:** _______________________________________________
  - Minimum: 2 TB SSD
  - Recommended: NVMe SSD for performance

- **Storage - Data Drive (Optional):** _______________________________________________
  - For RAID array or additional storage

### Network Hardware
- **Firewall/Router:** _______________________________________________
  - Must support port forwarding and firewall rules

- **Network Switch:** _______________________________________________
  - Gigabit Ethernet minimum

---

## 7. Compliance and Security Requirements

### Compliance Framework
- **Primary Framework:** ☐ NIST SP 800-171  ☐ CMMC Level 1  ☐ CMMC Level 2  ☐ Other: ___________
- **Handles CUI/FCI:** ☐ Yes  ☐ No
  - If Yes, additional controls may be required

### Security Preferences
- **Multi-Factor Authentication (MFA):** ☐ Required for all users  ☐ Required for admins only  ☐ Optional
- **Password Complexity:** ☐ Standard (NIST)  ☐ Enhanced  ☐ Custom: ___________
- **Session Timeout:** ☐ 15 minutes  ☐ 30 minutes  ☐ 1 hour  ☐ 8 hours (default)

---

## 8. Installation Environment

### On-Site Contact
- **On-Site Contact Name:** _______________________________________________
- **Phone Number:** _______________________________________________
- **Email:** _______________________________________________
- **Available Hours:** _______________________________________________

### Facility Requirements
- **Installation Location:** _______________________________________________
  - Server room, closet, rack location

- **Power Requirements:** ☐ Standard 120V outlet  ☐ 208V/240V  ☐ UPS available  ☐ Generator backup

- **Cooling:** ☐ Climate controlled room  ☐ Standard office environment

- **Network Access:** ☐ Existing wiring  ☐ New installation required

### Internet Service Provider
- **ISP Name:** _______________________________________________
- **Connection Type:** ☐ Fiber  ☐ Cable  ☐ DSL  ☐ Other: ___________
- **Download Speed:** _______________________________________________
- **Upload Speed:** _______________________________________________
- **Static IP Included:** ☐ Yes  ☐ No

---

## 9. Post-Installation Support

### Training Requirements
- **Number of Users Needing Training:** _______________________________________________
- **Training Topics:** ☐ Basic Usage  ☐ Administration  ☐ Security Best Practices  ☐ All

### Support Contact Preferences
- **Preferred Contact Method:** ☐ Email  ☐ Phone  ☐ Remote Desktop  ☐ On-Site
- **Support Hours Needed:** ☐ Business hours (8-5)  ☐ Extended (7-7)  ☐ 24/7

---

## 10. Special Requirements

### Custom Configurations
List any special requirements not covered above:

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

### Third-Party Integrations
List any existing systems that need to integrate:

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

---

## 11. Pre-Installation Checklist

Before installation, ensure the following items are ready:

- [ ] Domain name registered and DNS accessible
- [ ] Wildcard SSL certificate obtained (or Let's Encrypt selected)
- [ ] Static IP address assigned by ISP
- [ ] Server hardware unboxed and tested
- [ ] Network cabling in place
- [ ] Power available (UPS recommended)
- [ ] On-site contact available during installation
- [ ] User account information collected
- [ ] Business information documented
- [ ] Installation information form completed and signed

---

## 12. Acknowledgment and Approval

**Customer Acknowledgment:**

I acknowledge that the information provided above is accurate and complete. I understand that this information will be used to configure the CyberHygiene security system for my business.

**Customer Signature:** _______________________________________________
**Print Name:** _______________________________________________
**Title:** _______________________________________________
**Date:** _______________________________________________

**Installer Acknowledgment:**

I have reviewed this installation information form and confirmed all required information is present.

**Installer Signature:** _______________________________________________
**Print Name:** _______________________________________________
**Date:** _______________________________________________

---

## 13. Installation Record

**Installation Date:** _______________________________________________
**Installation Completed By:** _______________________________________________
**Installation Duration:** _______________ hours
**System Commissioned:** ☐ Yes  ☐ No
**Customer Acceptance:** ☐ Yes  ☐ No

**Notes:**
_______________________________________________
_______________________________________________
_______________________________________________

---

**File Location:** `/home/admin/Documents/Installer/installation_info.md`
**Template Version:** 1.0
**Last Updated:** 2026-01-01
