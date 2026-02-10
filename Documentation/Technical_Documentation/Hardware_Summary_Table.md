# CyberHygiene Production Network - Hardware Summary
**Date:** October 28, 2025
**Domain:** cyberinabox.net

---

## System Inventory

| System | Hostname | Model | CPU | RAM | Boot Drive | Additional Storage | Management | IP Address |
|---|---|---|---|---|---|---|---|---|
| **Server** | dc1.cyberinabox.net | HP ProLiant MicroServer Gen10 Plus | 4 cores | 32 GB | 2 TB | 3×3TB RAID 5 (5.5TB usable) | iLO 5 | 192.168.1.10 |
| **Workstation** | labrat.cyberinabox.net | HP ProLiant MicroServer Gen10 Plus | 4 cores | 32 GB | 512 GB SSD | None | iLO 5 | 192.168.1.115 |
| **Workstation** | engineering.cyberinabox.net | HP EliteDesk Micro (i5) | 4 cores | 32 GB | 256 GB SSD | None | AMT/vPro | 192.168.1.104 |
| **Workstation** | accounting.cyberinabox.net | HP EliteDesk Micro (i5) | 4 cores | 32 GB | 256 GB SSD | None | AMT/vPro | 192.168.1.113 |

---

## Aggregate Statistics

**Total Systems:** 4 (1 server, 3 workstations)
**Total CPU Cores:** 16 cores
**Total RAM:** 128 GB (32GB per system)
**Total Storage Capacity:**
- Boot Drives: ~3.5 TB usable
- RAID Array: ~5.5 TB usable
- **Grand Total:** ~9 TB usable storage

---

## Security Compliance (All Systems)

| Security Feature | Status |
|---|---|
| **Operating System** | ✓ Rocky Linux 9.6 (Server/Workstation) |
| **OpenSCAP CUI Compliance** | ✓ 100% (105/105 checks passed) |
| **FIPS 140-2 Cryptography** | ✓ Enabled and validated |
| **Full Disk Encryption** | ✓ LUKS (AES-256-XTS) |
| **SELinux** | ✓ Enforcing |
| **Secure Boot** | ✓ Enabled (UEFI) |
| **FreeIPA Domain** | ✓ All systems joined |
| **Kerberos SSO** | ✓ Operational |

---

## Key Features

### dc1 (Domain Controller/Server)
- **Role:** FreeIPA server, Wazuh Manager, DNS, NTP, Certificate Authority
- **Storage:** 2TB boot + 5.5TB encrypted RAID 5 (Samba share)
- **Management:** iLO 5 out-of-band management
- **Services:** LDAP, Kerberos, DNS, DHCP, Samba, Wazuh, backup server

### LabRat (Engineering/Test Workstation)
- **Role:** Engineering and testing workstation
- **Storage:** 512GB SSD (encrypted)
- **Management:** iLO 5 out-of-band management
- **Desktop:** GNOME on Rocky Linux 9.6 Workstation

### Engineering (Production Workstation)
- **Role:** CAD/Engineering workstation
- **CPU:** Intel Core i5
- **Storage:** 256GB SSD (encrypted)
- **Management:** Intel AMT/vPro
- **Desktop:** GNOME on Rocky Linux 9.6 Workstation

### Accounting (Financial Workstation)
- **Role:** Accounting and financial operations
- **CPU:** Intel Core i5
- **Storage:** 256GB SSD (encrypted)
- **Management:** Intel AMT/vPro
- **Desktop:** GNOME on Rocky Linux 9.6 Workstation

---

## Network Configuration

**Network:** 192.168.1.0/24
**Gateway:** 192.168.1.1 (Netgate 2100 pfSense)
**DNS:** 192.168.1.10 (dc1 - FreeIPA)
**NTP:** 192.168.1.10 (dc1)

**All systems connected via 1 Gbps Ethernet**

---

## Management Capabilities

### iLO 5 (dc1, LabRat)
- ✓ Remote console (graphical and text)
- ✓ Remote power control
- ✓ Virtual media (ISO mounting)
- ✓ Hardware monitoring (temps, fans, voltages)
- ✓ Out-of-band management (dedicated port)
- ✓ HTTPS encrypted access

### Intel AMT/vPro (Engineering, Accounting)
- ✓ Remote management
- ✓ KVM access
- ✓ Power control
- ✓ Hardware monitoring
- ✓ Network-based management

---

## Storage Breakdown

### dc1 Server Storage (2TB Boot Drive)
```
/boot/efi      952 MB   - EFI System Partition
/boot          7.4 GB   - Boot partition
/              90 GB    - Root filesystem
/tmp           15 GB    - Temporary files
/var           30 GB    - Variable data
/var/log       15 GB    - System logs
/var/log/audit 15 GB    - Audit logs
/home          239 GB   - User home directories
/backup        931 GB   - Daily backup storage
/data          350 GB   - Application data
swap           29 GB    - Encrypted swap
```

### dc1 RAID 5 Array (3×3TB = 5.5TB usable)
```
/srv/samba     5.5 TB   - CUI data storage
                        - Weekly backup storage (ReaR ISOs)
                        - Samba file sharing
```

### Workstation Storage (256-512GB per system)
```
/boot/efi      ~500 MB  - EFI System Partition
/boot          ~1 GB    - Boot partition
/              ~50 GB   - Root filesystem
/tmp           ~5 GB    - Temporary files
/var           ~10 GB   - Variable data
/var/log       ~5 GB    - System logs
/var/log/audit ~5 GB    - Audit logs
/home          ~150+ GB - User data (largest partition)
swap           ~16 GB   - Encrypted swap
```

**All partitions use LVM on LUKS encryption**

---

## Backup Strategy

### Daily Backups (Automated)
**Target:** `/backup` on dc1 (931 GB capacity)
**Schedule:** 2:00 AM daily
**Retention:** 30 days
**Contents:**
- FreeIPA configuration
- SSL certificates
- LUKS encryption keys
- System configurations
- User data snapshots

### Weekly Backups (Automated)
**Target:** `/srv/samba/backups` on RAID 5 (5.5 TB capacity)
**Schedule:** Sunday 3:00 AM
**Retention:** 4 weeks
**Format:** Bootable ISO (~890MB) + full backup tar.gz
**Tool:** ReaR (Relax-and-Recover)
**Capability:** Bare-metal recovery

---

## Power Consumption (Estimated)

| System | Idle | Typical | Maximum |
|---|---|---|---|
| dc1 Server | ~50W | ~100W | ~200W |
| LabRat | ~30W | ~80W | ~150W |
| Engineering | ~15W | ~35W | ~65W |
| Accounting | ~15W | ~35W | ~65W |
| pfSense Firewall | ~15W | ~20W | ~30W |
| **Total** | **~125W** | **~270W** | **~510W** |

**Annual Energy Cost (at $0.12/kWh):**
- Idle: ~$130/year
- Typical: ~$284/year
- Maximum: ~$536/year

---

## Lifecycle and Warranty

| Component | Expected Life | Warranty |
|---|---|---|
| HP ProLiant Servers | 5-7 years | 3 years (extendable) |
| HP EliteDesk Workstations | 4-5 years | 3 years (extendable) |
| SSD Boot Drives | 5-7 years | 3-5 years |
| RAID HDDs (3TB) | 3-5 years | 3 years |
| Network Equipment | 5-10 years | 1-3 years |

**RAID 5 Rebuild Time:** 8-12 hours (for 3TB drives)

---

## NIST 800-171 Relevant Controls

### Physical Protection (PE)
- **PE-3:** Physical access controls (locked facility, out-of-band management)
- **PE-6:** Monitoring physical access (iLO/AMT chassis intrusion detection)
- **PE-16:** Delivery and removal (asset tracking via iLO/AMT)

### Media Protection (MP)
- **MP-5:** Media transport (encrypted drives, asset inventory)
- **MP-6:** Media sanitization (NIST SP 800-88 procedures available)
- **MP-7:** Media use (LUKS encryption on all storage media)

### System and Communications Protection (SC)
- **SC-8:** Transmission confidentiality (TLS, SSH, encrypted channels)
- **SC-13:** Cryptographic protection (FIPS 140-2 validated algorithms)
- **SC-28:** Protection at rest (LUKS full disk encryption, all systems)

### Contingency Planning (CP)
- **CP-6:** Alternate storage (RAID 5 for redundancy, 5.5TB capacity)
- **CP-9:** System backup (automated daily + weekly backups)
- **CP-10:** System recovery (ReaR bootable ISOs, bare-metal restore)

---

## Asset Values (For Insurance/Replacement)

| Asset | Quantity | Est. Value Each | Total Value |
|---|---|---|---|
| HP ProLiant Gen10+ (32GB, iLO5) | 2 | $800-1,200 | $1,600-2,400 |
| HP EliteDesk Micro (i5, 32GB) | 2 | $600-800 | $1,200-1,600 |
| 3TB HDDs | 3 | $100-150 | $300-450 |
| SSDs (various sizes) | 4 | $50-200 | $200-800 |
| Netgate 2100 pfSense | 1 | $400-500 | $400-500 |
| Network switch | 1 | $100-200 | $100-200 |
| **Total Hardware Value** | | | **$3,800-5,950** |

*Does not include software, licensing, configuration labor, or data value*

---

## Quick Reference

**Remote Management URLs:**
- dc1 iLO: https://192.168.1.129
- LabRat iLO: https://192.168.1.130

**System Access:**
- Domain: cyberinabox.net
- FreeIPA: https://dc1.cyberinabox.net
- All systems: SSH via FreeIPA credentials

**Backup Locations:**
- Daily: /backup on dc1
- Weekly: /srv/samba/backups on dc1
- Offsite: TBD (recommended for disaster recovery)

---

**Last Updated:** October 28, 2025
**Maintained By:** Donald E. Shannon, System Owner/ISSO
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
