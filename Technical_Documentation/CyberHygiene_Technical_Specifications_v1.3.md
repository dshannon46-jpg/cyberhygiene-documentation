# CyberHygiene Production Network
# Technical Specifications Document

**Organization:** Donald E. Shannon LLC dba The Contract Coach
**System Name:** CyberHygiene Production Network
**Domain:** cyberinabox.net
**Version:** 1.3
**Date:** December 25, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Status:** 96% Implementation Complete

---

## DOCUMENT CONTROL

**Document Status:** DRAFT - Implementation Phase
**Security Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Distribution:** Limited to authorized personnel only

| Name / Title | Role | Signature / Date |
|---|---|---|
| Donald E. Shannon<br>Owner/Principal | System Owner | _____________________<br>Date: _______________ |
| Donald E. Shannon<br>Owner/Principal | ISSO | _____________________<br>Date: _______________ |

**Review Schedule:** Quarterly or upon significant system changes
**Next Review Date:** March 31, 2026

### Document Revision History

| Version | Date | Author | Description |
|---|---|---|---|
| 1.0 | 10/26/2025 | D. Shannon | Initial technical specifications |
| 1.1 | 10/28/2025 | D. Shannon | RAID 5, LUKS, Samba, ClamAV updates |
| 1.2 | 10/28/2025 | D. Shannon | Wazuh SIEM/XDR deployment, automated backups, complete software stack documentation |
| **1.3** | **12/25/2025** | **D. Shannon** | **AI server deployment, CyberHygiene AI Dashboard with network scanning, Ollama LLM integration, enhanced system automation** |

---

## EXECUTIVE SUMMARY

### Purpose

This document provides comprehensive technical specifications for The Contract Coach's production network infrastructure. This system is designed to process, store, and transmit Controlled Unclassified Information (CUI) and Federal Contract Information (FCI) in compliance with NIST SP 800-171 Rev 2 requirements and CMMC Level 2 certification criteria.

### System Overview

**System Name:** CyberHygiene Production Network (cyberinabox.net)
**Implementation Status:** 96% Complete (as of December 25, 2025)
**Target Completion:** December 31, 2025
**Compliance:** NIST 800-171 Rev 2, FIPS 140-2, CMMC Level 2 Ready

### Infrastructure Summary

| Component | Count | Specification |
|---|---|---|
| **Total Systems** | 5 | 2 servers, 3 workstations |
| **Total CPU Cores** | 28 | 4-12 cores per system (mix of x86 and ARM) |
| **Total RAM** | 192 GB | 32 GB (4 systems) + 64 GB (AI server) |
| **Total Storage** | ~13 TB usable | 7.5 TB boot + 5.5 TB RAID 5 |
| **Network Speed** | 1-10 Gbps | Gigabit Ethernet + 10GbE on AI server |
| **Security Compliance** | 100% | OpenSCAP CUI profile verified |
| **Encryption** | 100% | LUKS + Apple hardware encryption |

### What's New in Version 1.3

**AI/ML Infrastructure:**
- **Dedicated AI server:** Apple Mac Mini M4 Pro with 12-core CPU
- **High-performance memory:** 64 GB unified memory (LPDDR5X)
- **Neural Engine:** 16-core dedicated ML acceleration
- **Ollama platform:** Optimized for Apple Silicon
- **Code Llama 7B model:** Hardware-accelerated inference
- **CMMC-compliant:** HTTPS proxy for secure AI communications
- **Fully air-gapped:** No external API dependencies
- **Performance:** 40-60 tokens/second inference speed
- **Power efficient:** 3-5x more efficient than x86 equivalents

**Enhanced Administration Tools:**
- CyberHygiene AI System Administration Dashboard with conversational AI assistant
- Interactive log analysis (Wazuh, SSH, Apache, System Journal)
- Automated network device discovery using nmap
- Real-time system troubleshooting assistance
- AI-powered security alert analysis
- Multi-mode AI assistant (General, Security, Linux Admin, Programming)

**Security Enhancements:**
- SELinux policies for AI infrastructure (on dc1)
- Secure sudo configuration for automated network scanning
- HTTPS-only communication for all AI services
- Integration with existing Wazuh SIEM for AI activity monitoring
- Apple hardware security (T2/M4 Secure Enclave)
- FileVault encryption on macOS AI server


### Key Capabilities

- ✓ FIPS 140-2 validated cryptography on all systems
- ✓ 100% OpenSCAP CUI compliance (105/105 checks passed)
- ✓ Enterprise identity management (FreeIPA/Kerberos/LDAP)
- ✓ Security Information and Event Management (Wazuh SIEM/XDR)
- ✓ **NEW: Local AI/ML infrastructure (Ollama with Code Llama 7B)**
- ✓ **NEW: CyberHygiene AI System Administration Dashboard**
- ✓ **NEW: Automated network device discovery and scanning**
- ✓ Automated vulnerability scanning and patching
- ✓ File Integrity Monitoring (real-time and scheduled)
- ✓ Automated daily and weekly backup with bare-metal recovery
- ✓ Encrypted RAID 5 storage (5.5 TB usable capacity)
- ✓ Out-of-band management (iLO 5 on critical systems)
- ✓ Network security (pfSense firewall with IDS/IPS capability)

### What's New in Version 1.3

**AI/ML Infrastructure:**
- Dedicated AI server (ai.cyberinabox.net) with 12-core Apple M4 Pro and 64GB unified memory
- Ollama platform for local large language model hosting
- Code Llama 7B model for system administration assistance
- CMMC-compliant HTTPS proxy for secure AI communications
- No external API dependencies - fully air-gapped AI capability

**Enhanced Administration Tools:**
- CyberHygiene AI System Administration Dashboard with conversational AI assistant
- Interactive log analysis (Wazuh, SSH, Apache, System Journal)
- Automated network device discovery using nmap
- Real-time system troubleshooting assistance
- AI-powered security alert analysis

**Security Enhancements:**
- SELinux policies for AI infrastructure
- Secure sudo configuration for automated network scanning
- HTTPS-only communication for all AI services
- Integration with existing Wazuh SIEM for AI activity monitoring


---

# SECTION 1: HARDWARE SPECIFICATIONS

## 1.1 System Inventory

### Domain Controller (dc1.cyberinabox.net)

**System Information**
- **Hostname:** dc1.cyberinabox.net
- **IP Address:** 192.168.1.10/24
- **Role:** Domain Controller, FreeIPA Server, Wazuh Manager, File Server
- **OS:** Rocky Linux 9.6 Server

**Hardware Platform**
- **Model:** HP ProLiant MicroServer Gen10 Plus
- **Form Factor:** Tower Server
- **Management:** iLO 5 (Integrated Lights-Out) expansion card

**Processor**
- **CPU Cores:** 4
- **Architecture:** x86_64
- **Virtualization:** Enabled

**Memory**
- **Total RAM:** 32 GB
- **Configuration:** ECC (Error-Correcting Code)
- **Type:** DDR4

**Storage Configuration**

*Boot Drive (2 TB):*
- `/boot/efi` - 952 MB (EFI System Partition)
- `/boot` - 7.4 GB
- `/` (root) - 90 GB (LVM on LUKS encrypted)
- `/tmp` - 15 GB (LVM on LUKS encrypted)
- `/var` - 30 GB (LVM on LUKS encrypted)
- `/var/log` - 15 GB (LVM on LUKS encrypted)
- `/var/log/audit` - 15 GB (LVM on LUKS encrypted)
- `/home` - 239 GB (LVM on LUKS encrypted)
- `/backup` - 931 GB (LVM on LUKS encrypted, daily backups)
- `/data` - 350 GB (LVM on LUKS encrypted, application data)
- Swap - 29 GB (encrypted)

*RAID Array (3 × 3 TB SATA HDDs):*
- **Configuration:** RAID 5 (striping with distributed parity)
- **Usable Capacity:** ~5.5 TB (after RAID 5 parity)
- **Device:** `/dev/mapper/samba_data`
- **Mount Point:** `/srv/samba`
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Purpose:** CUI data storage, Samba file sharing, weekly backup storage (ReaR ISOs)
- **Fault Tolerance:** Single drive failure
- **Rebuild Time:** 8-12 hours (estimated)

**Network Interfaces**
- **Primary Interface:** eno1 (1 Gbps Ethernet, UP)
  - IP: 192.168.1.10/24
  - Gateway: 192.168.1.1
- **Additional Interfaces:** eno2, eno3, eno4 (DOWN, available for expansion)
- **iLO 5 Management:** Dedicated out-of-band management port

**Management Features**
- ✓ Remote console (graphical and text)
- ✓ Remote power control
- ✓ Virtual media (ISO mounting)
- ✓ Hardware monitoring (temps, fans, voltages)
- ✓ HTTPS encrypted access
- ✓ Chassis intrusion detection

---

### LabRat Workstation (labrat.cyberinabox.net)

**System Information**
- **Hostname:** labrat.cyberinabox.net
- **IP Address:** 192.168.1.115/24
- **Role:** Engineering/Testing Workstation
- **OS:** Rocky Linux 9.6 Workstation

**Hardware Platform**
- **Model:** HP ProLiant MicroServer Gen10 Plus
- **Form Factor:** Tower/Desktop
- **Management:** iLO 5 (Integrated Lights-Out) expansion card

**Processor**
- **CPU Cores:** 4
- **Architecture:** x86_64
- **Virtualization:** Enabled

**Memory**
- **Total RAM:** 32 GB
- **Configuration:** ECC (Error-Correcting Code)
- **Type:** DDR4

**Storage Configuration**
- **Boot Drive:** 512 GB SSD (NVMe/SATA)
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Partitioning:** LVM on LUKS with separate /var/log and /var/log/audit
- **No Additional Storage:** Single boot drive configuration

**Network Interfaces**
- **Primary Interface:** eno1 (1 Gbps Ethernet, UP)
  - IP: 192.168.1.115/24
  - Gateway: 192.168.1.1
- **iLO 5 Management:** Dedicated out-of-band management port

**Display and Graphics**
- **Desktop Environment:** GNOME (Rocky Linux 9 Workstation default)
- **Graphics:** Integrated or discrete GPU
- **Multi-monitor:** Supported

---

### Engineering Workstation (engineering.cyberinabox.net)

**System Information**
- **Hostname:** engineering.cyberinabox.net
- **IP Address:** 192.168.1.104/24
- **Role:** Engineering/CAD Workstation
- **OS:** Rocky Linux 9.6 Workstation
- **Security Status:** ✓ Fully hardened (OpenSCAP 100% CUI compliant)

**Hardware Platform**
- **Model:** HP EliteDesk Microcomputer
- **Form Factor:** Ultra Small Form Factor (USFF) Desktop
- **Management:** Intel AMT/vPro

**Processor**
- **CPU:** Intel Core i5
- **CPU Cores:** 4
- **Architecture:** x86_64
- **Virtualization:** Enabled (Intel VT-x)

**Memory**
- **Total RAM:** 32 GB
- **Type:** DDR4
- **Configuration:** SO-DIMM slots

**Storage Configuration**
- **Boot Drive:** 256 GB SSD (SATA M.2 or 2.5")
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Partitioning:** LVM on LUKS with separate /var/log and /var/log/audit

**Security Posture**
- ✓ OpenSCAP CUI Profile: 100% Compliant (105/105 checks passed)
- ✓ FIPS 140-2: Enabled and validated
- ✓ SELinux: Enforcing
- ✓ Full Disk Encryption: LUKS with FIPS-compliant cryptography

**Network**
- **Network Interface:** Intel Gigabit Ethernet
- **IP:** 192.168.1.104/24
- **Status:** Domain-joined (FreeIPA)
- **Authentication:** Kerberos SSO

**Display**
- **Graphics:** Intel HD Graphics (integrated)
- **Display Ports:** DisplayPort, HDMI
- **Multi-monitor:** Supported

---

### Accounting Workstation (accounting.cyberinabox.net)

**System Information**
- **Hostname:** accounting.cyberinabox.net
- **IP Address:** 192.168.1.113/24
- **Role:** Accounting/Financial Workstation
- **OS:** Rocky Linux 9.6 Workstation
- **Security Status:** ✓ Fully hardened (OpenSCAP 100% CUI compliant)

**Hardware Platform**
- **Model:** HP EliteDesk Microcomputer
- **Form Factor:** Ultra Small Form Factor (USFF) Desktop
- **Management:** Intel AMT/vPro

**Processor**
- **CPU:** Intel Core i5
- **CPU Cores:** 4
- **Architecture:** x86_64
- **Virtualization:** Enabled (Intel VT-x)

**Memory**
- **Total RAM:** 32 GB
- **Type:** DDR4
- **Configuration:** SO-DIMM slots

**Storage Configuration**
- **Boot Drive:** 256 GB SSD (SATA M.2 or 2.5")
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Partitioning:** LVM on LUKS with separate /var/log and /var/log/audit

**Security Posture**
- ✓ OpenSCAP CUI Profile: 100% Compliant (105/105 checks passed)
- ✓ FIPS 140-2: Enabled and validated
- ✓ SELinux: Enforcing
- ✓ Full Disk Encryption: LUKS with FIPS-compliant cryptography

**Network**
- **Network Interface:** Intel Gigabit Ethernet
- **IP:** 192.168.1.113/24
- **Status:** Domain-joined (FreeIPA)
- **Authentication:** Kerberos SSO

**Display**
- **Graphics:** Intel HD Graphics (integrated)
- **Display Ports:** DisplayPort, HDMI
- **Multi-monitor:** Supported

---


### AI Server (ai.cyberinabox.net)

**System Information**
- **Hostname:** ai.cyberinabox.net
- **IP Address:** 192.168.1.7/24
- **Role:** AI/ML Infrastructure Server, Local LLM Hosting
- **OS:** macOS Sequoia (or Linux if dual-boot)
- **Security Status:** ✓ Hardened with appropriate access controls

**Hardware Platform**
- **Model:** Apple Mac Mini (2024)
- **Chip:** Apple M4 Pro
- **Form Factor:** Ultra-compact desktop (7.7" × 7.7" × 2")
- **Management:** macOS native management tools / SSH

**Processor**
- **Chip:** Apple M4 Pro System on Chip (SoC)
- **CPU Cores:** 12-core CPU (8 performance cores + 4 efficiency cores)
- **GPU Cores:** 16-core GPU (integrated)
- **Neural Engine:** 16-core Neural Engine for ML acceleration
- **Architecture:** ARM64 (Apple Silicon)
- **Process Technology:** 3nm (second generation)
- **AI/ML Optimizations:** 
  - Dedicated Neural Engine for ML inference
  - Unified memory architecture for efficient model loading
  - Hardware-accelerated matrix multiplication
  - Optimized for LLM inference workloads

**Memory**
- **Total RAM:** 64 GB
- **Configuration:** Unified Memory Architecture (shared between CPU/GPU)
- **Type:** LPDDR5X
- **Memory Bandwidth:** ~273 GB/s
- **Allocation:** Dedicated to LLM model loading and inference operations
- **Advantage:** Entire model loaded in unified memory for fastest inference

**Storage Configuration**

*Internal SSD:*
- **Capacity:** 512 GB - 2 TB (PCIe 4.0 NVMe SSD)
- **Encryption:** Apple T2/M4 integrated encryption (hardware-level)
- **File System:** APFS (Apple File System) with encryption enabled
- **Performance:** Up to 5.3 GB/s read speeds
- **Partitioning:**
  - macOS System volume
  - Data volume for Ollama models and application data
  - Secure enclave for encryption keys

**Network Interfaces**
- **Primary Interface:** Ethernet (10 Gbps capable) or Wi-Fi 6E
  - IP: 192.168.1.7/24
  - Gateway: 192.168.1.1
- **Secondary:** Wi-Fi 6E (for fallback/management)
- **Bluetooth:** Bluetooth 5.3
- **Purpose:** AI service delivery via HTTPS proxy from dc1

**AI/ML Capabilities**
- ✓ Local large language model hosting (no internet dependency)
- ✓ Ollama platform optimized for Apple Silicon
- ✓ Code Llama 7B model (3.8GB model size)
- ✓ HTTP API on port 11434 (localhost only)
- ✓ Proxied through dc1 Apache server via HTTPS for CMMC compliance
- ✓ Response generation capability for system administration tasks
- ✓ Support for multiple AI modes (general, security, Linux admin, programming)
- ✓ Hardware-accelerated inference via Neural Engine
- ✓ Significantly faster inference than x86 equivalents due to unified memory

**Performance Characteristics**
- **Model Load Time:** ~2-3 seconds (vs 5-10 seconds on x86)
- **Average Inference Speed:** 40-60 tokens/second (Code Llama 7B)
- **Memory Efficiency:** 64GB allows loading larger models (up to 34B parameters)
- **Power Consumption:** ~5-15W idle, ~30-50W under load (highly efficient)
- **Thermal Management:** Fanless or quiet fan operation
- **Concurrent Requests:** Handled efficiently due to unified memory architecture

**Security Features**
- ✓ No external network access (air-gapped from internet)
- ✓ All communications proxied through HTTPS on dc1
- ✓ Apple T2/M4 security chip with Secure Enclave
- ✓ Hardware-level encryption (no LUKS needed)
- ✓ FileVault full-disk encryption enabled
- ✓ Firewall configured to block all inbound except from dc1
- ✓ Integrated with Wazuh SIEM for activity monitoring (if agent available for macOS)
- ✓ Audit logging of all AI interactions
- ✓ No data exfiltration - all processing local
- ✓ System Integrity Protection (SIP) enabled

**Power and Environmental**
- **Power Supply:** Internal, 100-240V AC (auto-switching)
- **Power Consumption:** 
  - Idle: ~5W
  - Active (LLM inference): 30-50W
  - Maximum: ~150W
- **Operating Temperature:** 50°F to 95°F (10°C to 35°C)
- **Operating Humidity:** 5% to 95% (non-condensing)
- **Cooling:** Fanless or intelligent fan control (nearly silent)

**Service Architecture**
```
User Browser (HTTPS)
    ↓
dc1.cyberinabox.net:443 (Apache HTTPS Proxy)
    ↓ (Internal HTTP)
ai.cyberinabox.net:11434 (Ollama API)
    ↓
Code Llama 7B Model (Apple Silicon Optimized)
    ↓
Apple M4 Pro Neural Engine (Hardware Acceleration)
```

**Advantages of Apple Silicon for AI Workloads:**
- **Unified Memory:** CPU, GPU, and Neural Engine share 64GB pool
- **Low Latency:** No data copying between CPU/GPU memory
- **Power Efficiency:** 3-5x more efficient than x86 for ML workloads
- **Hardware Acceleration:** Dedicated ML acceleration via Neural Engine
- **Scalability:** Can easily upgrade to larger models (13B, 34B parameters)
- **Silent Operation:** Minimal noise even under load
- **Small Footprint:** 7.7" × 7.7" × 2" - fits anywhere

**Operating System Options:**
- **Primary:** macOS Sequoia (native Ollama support)
- **Alternative:** Asahi Linux (ARM64 Linux for Apple Silicon)
- **Current:** macOS (recommended for optimal performance)

---

---

### LabRat Workstation (labrat.cyberinabox.net)

**System Information**
- **Hostname:** labrat.cyberinabox.net
- **IP Address:** 192.168.1.115/24
- **Role:** Engineering/Testing Workstation
- **OS:** Rocky Linux 9.6 Workstation

**Hardware Platform**
- **Model:** HP ProLiant MicroServer Gen10 Plus
- **Form Factor:** Tower/Desktop
- **Management:** iLO 5 (Integrated Lights-Out) expansion card

**Processor**
- **CPU Cores:** 4
- **Architecture:** x86_64
- **Virtualization:** Enabled

**Memory**
- **Total RAM:** 32 GB
- **Configuration:** ECC (Error-Correcting Code)
- **Type:** DDR4

**Storage Configuration**
- **Boot Drive:** 512 GB SSD (NVMe/SATA)
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Partitioning:** LVM on LUKS with separate /var/log and /var/log/audit
- **No Additional Storage:** Single boot drive configuration

**Network Interfaces**
- **Primary Interface:** eno1 (1 Gbps Ethernet, UP)
  - IP: 192.168.1.115/24
  - Gateway: 192.168.1.1
- **iLO 5 Management:** Dedicated out-of-band management port

**Display and Graphics**
- **Desktop Environment:** GNOME (Rocky Linux 9 Workstation default)
- **Graphics:** Integrated or discrete GPU
- **Multi-monitor:** Supported

---

### Engineering Workstation (engineering.cyberinabox.net)

**System Information**
- **Hostname:** engineering.cyberinabox.net
- **IP Address:** 192.168.1.104/24
- **Role:** Engineering/CAD Workstation
- **OS:** Rocky Linux 9.6 Workstation
- **Security Status:** ✓ Fully hardened (OpenSCAP 100% CUI compliant)

**Hardware Platform**
- **Model:** HP EliteDesk Microcomputer
- **Form Factor:** Ultra Small Form Factor (USFF) Desktop
- **Management:** Intel AMT/vPro

**Processor**
- **CPU:** Intel Core i5
- **CPU Cores:** 4
- **Architecture:** x86_64
- **Virtualization:** Enabled (Intel VT-x)

**Memory**
- **Total RAM:** 32 GB
- **Type:** DDR4
- **Configuration:** SO-DIMM slots

**Storage Configuration**
- **Boot Drive:** 256 GB SSD (SATA M.2 or 2.5")
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Partitioning:** LVM on LUKS with separate /var/log and /var/log/audit

**Security Posture**
- ✓ OpenSCAP CUI Profile: 100% Compliant (105/105 checks passed)
- ✓ FIPS 140-2: Enabled and validated
- ✓ SELinux: Enforcing
- ✓ Full Disk Encryption: LUKS with FIPS-compliant cryptography

**Network**
- **Network Interface:** Intel Gigabit Ethernet
- **IP:** 192.168.1.104/24
- **Status:** Domain-joined (FreeIPA)
- **Authentication:** Kerberos SSO

**Display**
- **Graphics:** Intel HD Graphics (integrated)
- **Display Ports:** DisplayPort, HDMI
- **Multi-monitor:** Supported

---

### Accounting Workstation (accounting.cyberinabox.net)

**System Information**
- **Hostname:** accounting.cyberinabox.net
- **IP Address:** 192.168.1.113/24
- **Role:** Accounting/Financial Workstation
- **OS:** Rocky Linux 9.6 Workstation
- **Security Status:** ✓ Fully hardened (OpenSCAP 100% CUI compliant)

**Hardware Platform**
- **Model:** HP EliteDesk Microcomputer
- **Form Factor:** Ultra Small Form Factor (USFF) Desktop
- **Management:** Intel AMT/vPro

**Processor**
- **CPU:** Intel Core i5
- **CPU Cores:** 4
- **Architecture:** x86_64
- **Virtualization:** Enabled (Intel VT-x)

**Memory**
- **Total RAM:** 32 GB
- **Type:** DDR4
- **Configuration:** SO-DIMM slots

**Storage Configuration**
- **Boot Drive:** 256 GB SSD (SATA M.2 or 2.5")
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Partitioning:** LVM on LUKS with separate /var/log and /var/log/audit

**Security Posture**
- ✓ OpenSCAP CUI Profile: 100% Compliant (105/105 checks passed)
- ✓ FIPS 140-2: Enabled and validated
- ✓ SELinux: Enforcing
- ✓ Full Disk Encryption: LUKS with FIPS-compliant cryptography

**Network**
- **Network Interface:** Intel Gigabit Ethernet
- **IP:** 192.168.1.113/24
- **Status:** Domain-joined (FreeIPA)
- **Authentication:** Kerberos SSO

**Display**
- **Graphics:** Intel HD Graphics (integrated)
- **Display Ports:** DisplayPort, HDMI
- **Multi-monitor:** Supported

---


### AI Server (ai.cyberinabox.net)

**System Information**
- **Hostname:** ai.cyberinabox.net
- **IP Address:** 192.168.1.7/24
- **Role:** AI/ML Infrastructure Server, Local LLM Hosting
- **OS:** Rocky Linux 9.6 Server
- **Security Status:** ✓ Hardened (SELinux enforcing with custom policies)

**Hardware Platform**
- **Model:** Custom Server Build / Commercial Workstation
- **Form Factor:** Tower/Rack Server
- **Management:** Standard IPMI or equivalent

**Processor**
- **CPU Cores:** 8 (physical or logical)
- **Architecture:** x86_64
- **Virtualization:** Enabled
- **AI/ML Optimizations:** AVX2 instruction set support for accelerated inference

**Memory**
- **Total RAM:** 32 GB
- **Configuration:** Non-ECC or ECC (depending on platform)
- **Type:** DDR4
- **Allocation:** Dedicated to LLM model loading and inference operations

**Storage Configuration**

*Boot/System Drive:*
- **Capacity:** 2 TB (SSD recommended for performance)
- **Encryption:** LUKS (FIPS 140-2 compliant)
- **Partitioning:** LVM on LUKS
  - `/boot/efi` - 952 MB (EFI System Partition, unencrypted)
  - `/boot` - 7.4 GB (unencrypted)
  - `/` (root) - 100 GB (encrypted)
  - `/var` - 50 GB (encrypted, for logs and Ollama data)
  - `/home` - Remaining space (encrypted)
  - swap - 32 GB (encrypted)

**Network Interfaces**
- **Primary Interface:** eno1 or eth0 (1 Gbps Ethernet, UP)
  - IP: 192.168.1.7/24
  - Gateway: 192.168.1.1
- **Purpose:** AI service delivery via HTTPS proxy from dc1

**AI/ML Capabilities**
- ✓ Local large language model hosting (no internet dependency)
- ✓ Ollama platform for model management
- ✓ Code Llama 7B model (3.8GB model size)
- ✓ HTTP API on port 11434 (localhost only)
- ✓ Proxied through dc1 Apache server via HTTPS for CMMC compliance
- ✓ Response generation capability for system administration tasks
- ✓ Support for multiple AI modes (general, security, Linux admin, programming)

**Security Features**
- ✓ No external network access (air-gapped from internet)
- ✓ All communications proxied through HTTPS on dc1
- ✓ SELinux enforcing mode with custom policies
- ✓ Firewall configured to block all inbound except from dc1
- ✓ Integrated with Wazuh SIEM for activity monitoring
- ✓ Audit logging of all AI interactions
- ✓ No data exfiltration - all processing local

**Service Architecture**
```
User Browser (HTTPS)
    ↓
dc1.cyberinabox.net:443 (Apache HTTPS Proxy)
    ↓ (Internal HTTP)
ai.cyberinabox.net:11434 (Ollama API)
    ↓
Code Llama 7B Model (Local Inference)
```

---
## 1.2 Network Infrastructure

### Firewall/Router (192.168.1.1)

**Model:** Netgate 2100 pfSense Appliance
**OS:** pfSense (FreeBSD-based)
**WAN:** 96.72.6.225 (public IP)
**LAN:** 192.168.1.1/24

**Specifications:**
- **CPU:** ARM Cortex-A53 Quad-Core @ 1.2 GHz
- **RAM:** 2-4 GB DDR4
- **Storage:** 8-16 GB eMMC
- **Network:** 2× Gigabit Ethernet ports
- **Features:** Firewall, VPN, IDS/IPS (Suricata capable), NAT, DHCP

### Network Switch

**Type:** Gigabit Ethernet Switch
**Ports:** 8-24 ports
**Speed:** 1 Gbps per port
**Function:** LAN connectivity for all devices

---

## 1.3 Storage Summary

### Total Storage Capacity

**Raw Storage:**
- dc1 boot drive: 2 TB
- dc1 RAID 5 array: 9 TB raw (3 × 3 TB)
- LabRat boot drive: 512 GB
- Engineering boot drive: 256 GB
- Accounting boot drive: 256 GB
- **Total Raw:** ~12 TB

**Usable Storage (After RAID/Encryption):**
- dc1 system partitions: ~1.7 TB usable
- dc1 RAID 5 (after parity): ~5.5 TB usable
- LabRat: ~450 GB usable
- Engineering: ~220 GB usable
- Accounting: ~220 GB usable
- **Total Usable:** ~8-9 TB

### Storage Allocation by Function

**Operating Systems and Applications:** ~800 GB
**User Data (/home directories):** ~1.5 TB allocated
**Logs and Auditing:** ~90 GB allocated (all systems)
**Daily Backups:** ~931 GB (/backup on dc1)
**Weekly Backups:** ~5.5 TB (RAID 5 array, ReaR ISOs)
**CUI Data Storage:** ~5.5 TB available (Samba share on RAID 5)

---

## 1.4 Performance Characteristics

### dc1 Server Performance
- **Boot Time:** ~2-3 minutes (with LUKS encryption)
- **RAID 5 Read Speed:** ~400-500 MB/s (sequential)
- **RAID 5 Write Speed:** ~200-300 MB/s (with parity calculation)
- **Network Throughput:** Up to 1 Gbps
- **Concurrent Users:** 20-50 (FreeIPA/Samba)

### Workstation Performance
- **Boot Time:** ~30-60 seconds (with LUKS encryption)
- **Disk Read Speed:** ~500-3500 MB/s (SSD/NVMe)
- **Disk Write Speed:** ~500-2000 MB/s (SSD/NVMe)
- **Network Throughput:** Up to 1 Gbps

---

## 1.5 Power and Environmental

### Power Consumption (Estimated)

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

### Environmental Requirements

**Operating Temperature:** 10°C to 35°C (50°F to 95°F)
**Operating Humidity:** 10% to 80% (non-condensing)
**Storage Temperature:** -40°C to 60°C
**Altitude:** Up to 3,000m (10,000 ft)

---

## 1.6 Warranty and Lifecycle

### Warranty and Support

**HP ProLiant (dc1, LabRat):**
- Standard: 3-year warranty
- Extended: Available
- Support: HP Enterprise support

**HP EliteDesk (Engineering, Accounting):**
- Standard: 3-year warranty
- Extended: Available
- Support: HP Business support

### Expected Lifecycle

**Servers:** 5-7 years
**Workstations:** 4-5 years
**Storage Drives:** 3-5 years (HDDs), 5-7 years (SSDs)
**RAID Rebuild Time:** 8-12 hours (3TB drives)

### Upgrade Paths

**dc1 Server:**
- Memory: Expandable to 64 GB
- Storage: Additional SATA ports available
- Network: PCIe expansion available

**LabRat Workstation:**
- Memory: Expandable to 64 GB
- Storage: M.2 expansion slot available
- Network: PCIe expansion available

**EliteDesk Workstations:**
- Memory: Expandable (model-dependent)
- Storage: M.2 or 2.5" expansion
- Network: USB 3.0 adapters available

---


# SECTION 2: SOFTWARE STACK

## 2.1 Operating System

### Rocky Linux 9.6 (Blue Onyx)

**Distribution:** Rocky Linux (RHEL binary compatible)
**Version:** 9.6 (released October 2025)
**Kernel:** Linux 5.14.0-570.x.x.el9_6.x86_64
**Architecture:** x86_64
**License:** Open Source (GPL)

**Deployment:**
- dc1: Rocky Linux 9.6 Server (minimal + FreeIPA packages)
- LabRat: Rocky Linux 9.6 Workstation (GNOME desktop)
- Engineering: Rocky Linux 9.6 Workstation (GNOME desktop)
- Accounting: Rocky Linux 9.6 Workstation (GNOME desktop)

**Security Features:**
- ✓ FIPS 140-2 mode enabled (cryptographic validation)
- ✓ SELinux enforcing mode
- ✓ Kernel hardening (sysctl configurations)
- ✓ Secure Boot enabled (UEFI)
- ✓ TPM 2.0 support

**Package Management:**
- **Package Manager:** DNF (Dandified YUM)
- **Repositories:** Rocky Base, AppStream, Extras, PowerTools, EPEL
- **Update Schedule:** Automatic security updates enabled
- **Update Tool:** dnf-automatic configured for security updates

---

## 2.2 Identity and Access Management

### FreeIPA 4.11.x

**Purpose:** Enterprise identity management, authentication, and authorization
**Components:**
- 389 Directory Server (LDAP)
- MIT Kerberos (KDC and authentication)
- Dogtag Certificate System (PKI/CA)
- BIND DNS with DNSSEC
- NTP time synchronization
- SSSD (System Security Services Daemon)

**Deployment:**
- **Server:** dc1.cyberinabox.net (192.168.1.10)
- **Realm:** CYBERINABOX.NET
- **Domain:** cyberinabox.net
- **CA Subject:** CN=Certificate Authority,O=CYBERINABOX.NET

**Capabilities:**
- ✓ Centralized user and group management
- ✓ Kerberos single sign-on (SSO)
- ✓ Host-based access control (HBAC)
- ✓ Sudo rule management
- ✓ SSH key distribution
- ✓ Internal certificate authority
- ✓ DNS management with DNSSEC
- ✓ Password policies (complexity, expiration, history)
- ✓ Two-factor authentication ready (OTP support)

**Client Integration:**
- All workstations (LabRat, Engineering, Accounting) joined to FreeIPA domain
- SSSD configured for cached authentication
- Kerberos tickets issued on login
- Home directories auto-created on first login

---

## 2.3 Security Information and Event Management (SIEM)

### Wazuh v4.9.2

**Purpose:** Security monitoring, threat detection, vulnerability management, compliance
**Deployment Date:** October 28, 2025
**Architecture:** Manager + Indexer (Dashboard skipped for FIPS compliance)

**Components Deployed:**

#### Wazuh Manager (dc1.cyberinabox.net)
- **Service:** wazuh-manager
- **Port:** 1514 (agent communication), 1515 (cluster), 55000 (API)
- **Purpose:** Log collection, analysis, correlation, alerting
- **Log Location:** `/var/ossec/logs/`
- **Configuration:** `/var/ossec/etc/ossec.conf`

**Capabilities:**
- ✓ Real-time log analysis
- ✓ Security event correlation
- ✓ Rule-based alerting (3000+ built-in rules)
- ✓ File Integrity Monitoring (FIM)
- ✓ Rootkit detection
- ✓ Active response (automatic threat mitigation)
- ✓ Compliance mapping (NIST, PCI DSS, HIPAA, GDPR, MITRE ATT&CK)

#### Wazuh Indexer (dc1.cyberinabox.net)
- **Service:** wazuh-indexer
- **Port:** 9200 (HTTP), 9300 (cluster communication)
- **Purpose:** Alert storage, search, and retrieval
- **Technology:** OpenSearch (Elasticsearch fork)
- **Storage Location:** `/var/lib/wazuh-indexer/`
- **Retention:** 90 days (default, configurable)

**Capabilities:**
- ✓ Searchable alert database
- ✓ Historical event analysis
- ✓ JSON document storage
- ✓ RESTful API access
- ✓ Data retention policies

#### Filebeat (dc1.cyberinabox.net)
- **Service:** filebeat
- **Purpose:** Log shipping from Manager to Indexer
- **Configuration:** `/etc/filebeat/filebeat.yml`

#### Wazuh Agent (Agent ID 000 - Self-Monitoring)
- **Installation:** Local agent on dc1 monitoring the Wazuh Manager itself
- **Purpose:** Self-monitoring, compliance checking, vulnerability scanning

**Active Modules:**

1. **Vulnerability Detection**
   - Hourly CVE database updates
   - Package vulnerability scanning
   - CVSS scoring and severity classification
   - Automated patch recommendations

2. **File Integrity Monitoring (FIM)**
   - Real-time monitoring: `/etc`, `/usr/bin`, `/usr/sbin`, `/bin`, `/sbin`, `/boot`
   - Scheduled scans: Every 12 hours
   - SHA256 checksums
   - Attribute monitoring (permissions, ownership, timestamps)

3. **Security Configuration Assessment (SCA)**
   - CIS Rocky Linux 9 Benchmark compliance checking
   - Automated policy scanning
   - Remediation guidance
   - Compliance scoring

4. **Log Collection and Analysis**
   - Journald integration
   - Syslog collection
   - Authentication events (SSH, sudo, PAM)
   - System events (service starts/stops, reboots)

**Alert Configuration:**
- **Log Level:** 3+ (all significant events logged)
- **Email Alerts:** Disabled (will enable after email server deployment)
- **Email Threshold:** Level 12+ (critical alerts)
- **Alert Formats:** Human-readable (`alerts.log`) and JSON (`alerts.json`)
- **Alert Location:** `/var/ossec/logs/alerts/`

**Compliance Mappings (Automatic):**
- NIST SP 800-53
- NIST SP 800-171
- PCI DSS
- HIPAA
- GDPR
- MITRE ATT&CK

**API Access:**
- **Endpoint:** https://localhost:55000
- **Authentication:** Bearer token (username/password)
- **Credentials:** `/root/wazuh-credentials.txt`

---

## 2.4 Backup and Disaster Recovery

### ReaR (Relax-and-Recover) 2.7

**Purpose:** Bare-metal disaster recovery and system backup
**Deployment:** Installed on dc1.cyberinabox.net
**Configuration:** `/etc/rear/local.conf`

**Capabilities:**
- ✓ Bootable ISO creation (~890 MB)
- ✓ Full system backup (tar.gz archives)
- ✓ Bare-metal recovery
- ✓ LUKS encryption support
- ✓ LVM layout recreation
- ✓ Automated scheduling via cron

**Backup Schedule:**

**Weekly Full System Backup:**
- **Schedule:** Sunday 3:00 AM
- **Target:** `/srv/samba/backups/` (RAID 5 array)
- **Retention:** 4 weeks
- **Format:** Bootable ISO + full backup tar.gz
- **Cron Job:** `/etc/cron.d/rear-weekly-backup`

**Daily Critical Files Backup:**
- **Schedule:** 2:00 AM daily
- **Target:** `/backup` (931 GB partition on dc1)
- **Retention:** 30 days
- **Contents:**
  - FreeIPA configuration and database
  - SSL certificates
  - LUKS encryption keys
  - System configurations (/etc)
  - Wazuh configurations
  - User data snapshots

**Recovery Process:**
1. Boot from ReaR ISO (via USB or iLO virtual media)
2. Automatic hardware detection
3. Disk layout recreation (including LUKS and LVM)
4. System restoration from tar.gz archive
5. Bootloader installation
6. Reboot to restored system

**Testing Status:**
- ✓ Backup creation tested and successful
- ✓ ISO boots successfully
- ✓ Restoration tested (dry-run verified)

---

## 2.5 Storage and File Sharing

### Samba 4.19.x

**Purpose:** SMB/CIFS file sharing for CUI data
**Deployment:** dc1.cyberinabox.net
**Service:** smb.service, nmb.service

**Configuration:**
- **Config File:** `/etc/samba/smb.conf`
- **Share:** `/srv/samba` (5.5 TB RAID 5 array)
- **Encryption:** SMB3 encryption enforced
- **Authentication:** Integrated with FreeIPA/Kerberos
- **Permissions:** POSIX ACLs

**Security Features:**
- ✓ SMB3 protocol (minimum version enforced)
- ✓ SMB encryption in transit
- ✓ Kerberos authentication
- ✓ LUKS encryption at rest
- ✓ Audit logging enabled

**Access Control:**
- User authentication via FreeIPA credentials
- Group-based permissions
- SELinux contexts applied
- CUI data markings required

---

## 2.6 Antivirus and Malware Protection

### ClamAV 1.0.x / ClamD

**Purpose:** Antivirus scanning and malware detection
**Deployment:** dc1.cyberinabox.net
**Service:** clamd@scan.service

**Components:**
- **ClamD:** Daemon for on-access and on-demand scanning
- **Freshclam:** Automatic virus definition updates
- **ClamScan:** Command-line scanning tool
- **ClamAV-Milter:** Email scanning (for future Postfix integration)

**Configuration:**
- **Config File:** `/etc/clamd.d/scan.conf`
- **Database Location:** `/var/lib/clamav/`
- **Update Schedule:** Hourly checks for new definitions
- **Current Signatures:** 27,673+ virus definitions

**Scanning Capabilities:**
- ✓ On-demand file scanning
- ✓ Scheduled directory scans
- ✓ Email attachment scanning (when mail server deployed)
- ✓ Archive extraction and scanning (.zip, .tar, .gz, etc.)
- ✓ Malware signature detection
- ✓ Heuristic analysis

**Wazuh Integration:**
- ✓ ClamAV logs monitored by Wazuh
- ✓ Virus detection alerts (Rule 510, Level 12)
- ✓ Automatic incident response triggers

**Current Status:**
- Database: ✓ Updated (October 28, 2025 - 07:34 AM)
- Service: ⚠️ On cooldown (restart scheduled after 18:32 PM)

---

## 2.7 Security Compliance and Hardening

### OpenSCAP 1.3.x

**Purpose:** Security compliance scanning and validation
**Deployment:** All systems (dc1, LabRat, Engineering, Accounting)
**Profiles:** CUI (Controlled Unclassified Information)

**Compliance Status:**
- ✓ **dc1:** 100% compliant (105/105 checks passed)
- ✓ **LabRat:** 100% compliant (105/105 checks passed)
- ✓ **Engineering:** 100% compliant (105/105 checks passed)
- ✓ **Accounting:** 100% compliant (105/105 checks passed)

**Scanned Controls:**
- AC (Access Control)
- AU (Audit and Accountability)
- CM (Configuration Management)
- IA (Identification and Authentication)
- SC (System and Communications Protection)
- SI (System and Information Integrity)

**Scanning Schedule:**
- Initial scan: Completed
- Recurring scans: Monthly (via cron)
- Remediation: Automated where possible
- Reports: Stored in `/var/log/scap/`

---

## 2.8 Encryption and Cryptography

### LUKS (Linux Unified Key Setup) 2.x

**Purpose:** Full disk encryption on all systems
**Technology:** dm-crypt with LUKS2 format
**Algorithm:** AES-256-XTS
**FIPS Mode:** ✓ Enabled (FIPS 140-2 validated cryptography)

**Deployment:**
- ✓ All boot drives encrypted (dc1, LabRat, Engineering, Accounting)
- ✓ RAID 5 array encrypted (dc1: `/srv/samba`)
- ✓ Swap partitions encrypted
- ✓ All LVM volumes on LUKS

**Key Management:**
- Keys stored in TPM 2.0 (where available)
- Passphrase authentication at boot
- Emergency key backup stored securely
- Daily backup of LUKS headers

**FIPS 140-2 Validation:**
- Cryptographic modules: kernel crypto API
- Algorithms: AES-256-XTS, SHA-256, HMAC-SHA-256
- Validation: CMVP Certificate (in process)
- Verification: `fips-mode-setup --check` (all systems pass)

---

## 2.9 Network Services

### DNS (BIND 9.16.x)

**Purpose:** Domain Name System services
**Deployment:** dc1.cyberinabox.net (integrated with FreeIPA)
**Zones:** cyberinabox.net (forward and reverse)

**Features:**
- ✓ DNSSEC enabled and validated
- ✓ Dynamic DNS updates (for FreeIPA hosts)
- ✓ Forward and reverse zones
- ✓ Integrated with FreeIPA for automatic record creation

**Forwarders:**
- Cloudflare DNS: 1.1.1.1, 1.0.0.1
- Google DNS: 8.8.8.8, 8.8.4.4 (backup)

### NTP (Chrony)

**Purpose:** Network Time Protocol synchronization
**Deployment:** All systems
**NTP Server:** dc1.cyberinabox.net (192.168.1.10)

**Configuration:**
- dc1 syncs to: pool.ntp.org (public NTP pool)
- Workstations sync to: dc1.cyberinabox.net
- Stratum: dc1 = Stratum 3, workstations = Stratum 4

**Time Accuracy:**
- Typical offset: < 10 milliseconds
- Required for: Kerberos authentication, audit logging, certificate validation

### DHCP (ISC DHCP Server) - Optional

**Purpose:** Dynamic IP address assignment
**Current Status:** Static IP assignments used
**Alternative:** pfSense DHCP server (192.168.1.1)

---

## 2.10 Certificate Management

### Dogtag PKI (Certificate Authority)

**Purpose:** Internal certificate authority for SSL/TLS certificates
**Deployment:** Integrated with FreeIPA on dc1.cyberinabox.net
**CA Subject:** CN=Certificate Authority,O=CYBERINABOX.NET

**Capabilities:**
- ✓ SSL/TLS certificate issuance
- ✓ User certificates for S/MIME email
- ✓ Host certificates for service authentication
- ✓ Certificate revocation (CRL and OCSP)
- ✓ Automatic renewal

**Issued Certificates:**
- FreeIPA web UI (dc1.cyberinabox.net)
- LDAP services (389-ds)
- Kerberos KDC
- HTTP services (Apache)
- Host certificates (all domain-joined systems)

### External SSL Certificate

**Provider:** SSL.com
**Type:** Domain Validation (DV) certificate
**Coverage:** *.cyberinabox.net (wildcard)
**Validity:** 1 year
**Algorithm:** RSA 2048-bit
**Current Status:** Installed (needs reissue for proper SANs)

**Deployed On:**
- FreeIPA web UI
- Apache web server
- Future email server (Postfix/Dovecot)

---

## 2.11 Web Services

### Apache HTTP Server 2.4.x

**Purpose:** Web server for FreeIPA UI and future applications
**Deployment:** dc1.cyberinabox.net
**Service:** httpd.service

**Configuration:**
- **HTTP Port:** 80 (redirects to HTTPS)
- **HTTPS Port:** 443
- **SSL/TLS:** TLS 1.2+ only (FIPS-compliant ciphers)
- **Document Root:** `/usr/share/ipa/ui/` (FreeIPA)

**Security Features:**
- ✓ HTTPS enforced (HTTP redirects)
- ✓ FIPS 140-2 compliant cipher suites
- ✓ HTTP Strict Transport Security (HSTS)
- ✓ Kerberos authentication integration
- ✓ SELinux contexts enforced

---

## 2.12 System Management and Monitoring

### Systemd

**Purpose:** System and service management
**Version:** systemd 252 (Rocky Linux 9.6)

**Key Features:**
- ✓ Service management (start, stop, restart, enable, disable)
- ✓ Journald centralized logging
- ✓ Timer units (cron replacement)
- ✓ Resource management (cgroups)
- ✓ Boot performance analysis

**Critical Services Managed:**
- wazuh-manager, wazuh-indexer, filebeat (SIEM)
- ipa (FreeIPA server)
- smb, nmb (Samba)
- httpd (Apache)
- named (BIND DNS)
- chronyd (NTP)
- clamd@scan (ClamAV)

### Journald (System Logging)

**Purpose:** Centralized system and service logging
**Storage:** `/var/log/journal/`
**Retention:** 30 days (automatic rotation)

**Integration:**
- ✓ All systemd services log to journald
- ✓ Wazuh monitors journald for security events
- ✓ Persistent storage enabled
- ✓ SELinux-aware logging

**Query Tools:**
- `journalctl -u service-name` (view service logs)
- `journalctl -p err` (view error-level events)
- `journalctl --since "2 hours ago"` (time-based filtering)

### Auditd (Linux Audit Framework)

**Purpose:** Security audit logging for compliance
**Configuration:** `/etc/audit/rules.d/audit.rules`
**Log Location:** `/var/log/audit/audit.log`
**Partition:** Dedicated `/var/log/audit` (15 GB)

**Monitored Events:**
- ✓ User authentication and authorization
- ✓ File access (read, write, execute)
- ✓ Privilege escalation (sudo)
- ✓ System calls (security-relevant syscalls)
- ✓ Configuration changes
- ✓ User and group modifications

**Compliance:**
- NIST 800-171 AU family controls
- PCI DSS 10.x requirements
- CMMC Level 2 logging requirements

**Wazuh Integration:**
- ✓ Audit logs monitored by Wazuh
- ✓ Real-time alerting on security events
- ✓ Compliance mapping (NIST, PCI DSS)

---

## 2.13 Planned Software Components

### Email Server (Planned - POA&M-002)

**Target Deployment:** December 20, 2025
**Components:**
- **Postfix** (SMTP server with TLS encryption)
- **Dovecot** (IMAP/POP3 server with encryption)
- **Rspamd** (spam and malware filtering)
- **ClamAV-Milter** (antivirus scanning)

**Security Features:**
- ✓ TLS encryption in transit (SMTP TLS, IMAPS, POP3S)
- ✓ SPF, DKIM, DMARC email authentication
- ✓ Certificate-based authentication
- ✓ Integration with FreeIPA for user accounts
- ✓ ClamAV malware scanning
- ✓ Rspamd spam filtering

### Multi-Factor Authentication (Planned - POA&M-004)

**Target Deployment:** December 22, 2025
**Options:**
- **FreeIPA OTP** (one-time passwords, TOTP/HOTP)
- **RADIUS integration** (for hardware tokens)
- **PIV/CAC support** (smartcard authentication)

**Scope:**
- All user logins (workstations, SSH, web UI)
- Administrative access (privileged operations)
- Remote access (future VPN deployment)

---

## 2.14 Software Update and Patch Management

### DNF Automatic (dnf-automatic)

**Purpose:** Automatic security updates
**Configuration:** `/etc/dnf/automatic.conf`
**Schedule:** Daily at 2:00 AM

**Update Policy:**
- ✓ Security updates: Applied automatically
- ✓ Bugfix updates: Applied automatically
- ✓ Enhancement updates: Manual approval
- ✓ Kernel updates: Automatic with reboot notification

**Notification:**
- Email notification: Configured (after email server)
- Log location: `/var/log/dnf.log`
- Wazuh monitoring: ✓ Enabled

**Pre-Update Actions:**
- Snapshot of critical configurations
- Backup of LUKS headers
- ReaR backup verification

**Post-Update Actions:**
- System health check
- Service restart (if required)
- Wazuh vulnerability rescan

---


## 2.8 AI/ML Infrastructure

### Ollama v0.3.x (ai.cyberinabox.net)

**Purpose:** Local large language model hosting platform for AI-powered system administration assistance

**Installation Location:** ai.cyberinabox.net
**Service Port:** 11434 (HTTP, localhost only)
**Data Directory:** `/usr/share/ollama/.ollama`
**Model Storage:** `/usr/share/ollama/.ollama/models`

**Configuration:**
- **Systemd Service:** `ollama.service`
- **Service User:** `ollama`
- **Auto-start:** Enabled
- **Resource Limits:** Configured for 32GB RAM system
- **Network Binding:** localhost only (127.0.0.1:11434)

**Deployed Models:**

*Code Llama 7B (codellama:7b)*
- **Purpose:** System administration, security analysis, log interpretation
- **Model Size:** 3.8 GB
- **Parameters:** 7 billion
- **Quantization:** Q4_0 (4-bit quantization for efficiency)
- **Context Window:** 4096 tokens
- **Use Cases:**
  - Interactive system troubleshooting
  - Security log analysis
  - Configuration assistance
  - Compliance guidance
  - Network diagnostics

**API Endpoints:**
- `POST /api/generate` - Generate completions
- `POST /api/chat` - Conversational interface
- `GET /api/tags` - List available models
- `GET /api/show` - Model information

**HTTPS Proxy Configuration (dc1.cyberinabox.net):**
```apache
ProxyPass /ai-api http://ai.cyberinabox.net:11434
ProxyPassReverse /ai-api http://ai.cyberinabox.net:11434

<Location /ai-api>
    Require all granted
    ProxyPreserveHost Off
    RequestHeader unset Origin
    
    # CORS headers
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Accept, Origin"
    
    # No caching
    Header set Cache-Control "no-cache, no-store, must-revalidate"
</Location>
```

**Security Controls:**
- ✓ Air-gapped operation (no internet access required)
- ✓ All requests proxied through HTTPS
- ✓ No external API dependencies
- ✓ Local inference only - no data transmission
- ✓ SELinux policies for service isolation
- ✓ Firewall rules restricting access
- ✓ Audit logging enabled

**Performance Characteristics:**
- **Model Load Time:** ~5-10 seconds
- **Average Response Time:** 2-5 seconds (depending on query complexity)
- **Concurrent Requests:** Single-threaded (queue-based)
- **Memory Usage:** ~4-6 GB (when model loaded)
- **CPU Utilization:** Scales with request complexity

---

## 2.9 CyberHygiene AI System Administration Dashboard

### Web-Based AI Assistant (cyberinabox.net)

**Purpose:** Interactive AI-powered system administration dashboard providing conversational assistance, log analysis, and network discovery capabilities

**Access URL:** https://cyberinabox.net/ai-dashboard.html
**Platform:** HTML5/JavaScript Single-Page Application
**Backend Integration:** Ollama API via HTTPS proxy

**Core Features:**

*1. Interactive AI Assistant*
- **Conversational Interface:** Natural language interaction with AI
- **Multiple AI Modes:**
  - General Assistant (system administration guidance)
  - Security Expert (NIST 800-171, CMMC compliance)
  - Linux Admin Expert (detailed command examples)
  - Programming Expert (code review, debugging)
- **Context-Aware:** Maintains conversation history
- **Real-Time Response:** Streaming or immediate response generation

*2. Quick Access Functions*

**Security Analysis:**
- Analyze Wazuh Alerts (last 20 security events)
- Analyze SSH Logs (`/var/log/secure` analysis)
- Analyze Audit Logs (suspicious activity detection)
- Security Expert Mode (NIST 800-171 focus)

**System Log Analysis:**
- Analyze `/var/log/messages` (last 100 lines)
- Analyze Apache Logs (HTTP error detection)
- Analyze System Journal (systemd events)
- Custom Log Analysis (user-specified log files)

**System Management:**
- Troubleshoot High CPU (diagnostic steps)
- Troubleshoot Disk Space (identify large files)
- Troubleshoot Memory Issues (memory leak detection)
- Linux Admin Expert Mode

**Quick Commands:**
- FreeIPA Troubleshooting
- Add FreeIPA User
- Configure Firewall (firewalld rules)
- DNS Troubleshooting
- **NEW: Scan Network Devices (192.168.1.0/24)**

*3. Network Device Scanning*

**Feature:** Automated network device discovery and inventory

**Backend Components:**
- **Scan Script:** `/usr/local/bin/network-scan.sh`
- **API Endpoint:** `/scan-network.php`
- **Scanning Tool:** nmap (ping scan mode)
- **Sudo Configuration:** Passwordless execution for apache user

**Scan Capabilities:**
- Network range: 192.168.1.0/24 (configurable)
- Device detection via ARP and ICMP
- MAC address identification
- Vendor identification (OUI lookup)
- Hostname resolution
- JSON-formatted results

**Security Implementation:**
- SELinux policies allowing httpd packet socket access
- Sudo configuration in `/etc/sudoers.d/apache-nmap`:
  ```
  Defaults:apache !requiretty
  apache ALL=(root) NOPASSWD: /usr/local/bin/network-scan.sh *
  ```
- Network scan wrapper script with input validation
- Results returned via secure HTTPS connection

**Example Scan Output:**
```json
{
  "success": true,
  "network": "192.168.1.0/24",
  "devices": [
    {
      "ip": "192.168.1.1",
      "hostname": "_gateway",
      "mac": "90:EC:77:8E:8C:84",
      "vendor": "silicom"
    },
    {
      "ip": "192.168.1.10",
      "hostname": "dc1.cyberinabox.net",
      "mac": "",
      "vendor": ""
    }
  ],
  "count": 6
}
```

**User Interface Elements:**
- Status bar showing AI server connectivity
- Model information display
- Chat message history with role indicators
- Quick action buttons for common tasks
- Network scan results table
- Loading indicators
- Error handling and user feedback

**Technical Stack:**
- **Frontend:** Vanilla JavaScript (ES6+)
- **Styling:** CSS3 with responsive design
- **Backend:** PHP 8.1 for network scanning
- **Communication:** Fetch API for async requests
- **Security:** HTTPS-only, HSTS enabled, XSS protection headers

**CMMC Compliance Features:**
- No external dependencies (self-contained)
- All AI processing local (no cloud services)
- Encrypted communications (HTTPS)
- Access control via Apache authentication
- Audit logging of all interactions
- No sensitive data in browser storage

**File Locations:**
- Dashboard HTML: `/var/www/cyberhygiene/ai-dashboard.html`
- Network Scan API: `/var/www/cyberhygiene/scan-network.php`
- Scan Wrapper: `/usr/local/bin/network-scan.sh`
- Apache Config: `/etc/httpd/conf.d/cyberhygiene.conf`

---
# SECTION 3: NETWORK ARCHITECTURE

## 3.1 Network Topology

### Physical Network

**Network Segment:** 192.168.1.0/24
**Gateway:** 192.168.1.1 (pfSense firewall)
**Subnet Mask:** 255.255.255.0
**DHCP Range:** 192.168.1.100-192.168.1.200 (pfSense DHCP server)
**DNS Server:** 192.168.1.10 (dc1 - FreeIPA BIND)
**NTP Server:** 192.168.1.10 (dc1 - Chrony)

### IP Address Assignments

| System | Hostname | IP Address | MAC Address | Interface |
|---|---|---|---|---|
| **Firewall** | pfSense | 192.168.1.1 | (Various) | LAN |
| **Domain Controller** | dc1.cyberinabox.net | 192.168.1.10 | (Static) | eno1 |
| **Engineering WS** | engineering.cyberinabox.net | 192.168.1.104 | (Static) | eth0 |
| **Accounting WS** | accounting.cyberinabox.net | 192.168.1.113 | (Static) | eth0 |
| **LabRat WS** | labrat.cyberinabox.net | 192.168.1.115 | (Static) | eno1 |

**Static Assignments:** All production systems use static IP addresses
**DNS Resolution:** All systems resolve via dc1 (FreeIPA BIND)

### WAN Connection

**Public IP:** 96.72.6.225
**ISP:** (ISP details)
**Bandwidth:** (Connection speed)
**NAT:** Configured on pfSense (192.168.1.1)

---

## 3.2 Network Services

### Services by System

**dc1.cyberinabox.net (192.168.1.10):**
- Port 53/TCP, 53/UDP: DNS (BIND)
- Port 88/TCP, 88/UDP: Kerberos KDC
- Port 123/UDP: NTP (Chrony)
- Port 389/TCP: LDAP (389-ds)
- Port 443/TCP: HTTPS (FreeIPA web UI, Apache)
- Port 636/TCP: LDAPS (389-ds)
- Port 445/TCP: SMB (Samba file sharing)
- Port 464/TCP, 464/UDP: Kerberos password change
- Port 1514/TCP: Wazuh agent communication
- Port 9200/TCP: Wazuh Indexer (internal)
- Port 55000/TCP: Wazuh API

**pfSense (192.168.1.1):**
- Port 22/TCP: SSH (admin access)
- Port 80/TCP: HTTP (web UI redirect)
- Port 443/TCP: HTTPS (web UI)
- Port 67/UDP: DHCP server
- Port 53/UDP: DNS forwarder (optional)

**Workstations:**
- Port 22/TCP: SSH (remote administration)
- Ephemeral ports for outbound connections

### Firewall Rules

**pfSense Default Policy:**
- LAN to WAN: ALLOW (with NAT)
- WAN to LAN: DENY (except established connections)
- Inbound to dc1: RESTRICTED (SSH, HTTPS for management only)

**Service-Specific Rules:**
- Allow LAN → dc1:53 (DNS)
- Allow LAN → dc1:88 (Kerberos)
- Allow LAN → dc1:123 (NTP)
- Allow LAN → dc1:389, 636 (LDAP/LDAPS)
- Allow LAN → dc1:443 (HTTPS web UI)
- Allow LAN → dc1:445 (Samba)
- Block all WAN → dc1 (except via VPN, future)

**Logging:**
- ✓ All firewall events logged
- ✓ Logs forwarded to dc1 (Wazuh SIEM)
- ✓ Blocked connection attempts monitored

---

## 3.3 Network Security

### Encryption in Transit

**All network traffic is encrypted:**
- ✓ HTTPS (TLS 1.2+) for web services
- ✓ SSH (OpenSSH 8.7+) for remote administration
- ✓ LDAPS (LDAP over TLS) for directory queries
- ✓ Kerberos (encrypted tickets)
- ✓ SMB3 encryption for file sharing
- ✓ DNSSEC for DNS integrity

**Cipher Suites:**
- FIPS 140-2 compliant ciphers only
- TLS 1.2 minimum (TLS 1.3 preferred)
- Strong key exchange (ECDHE, DHE)
- AES-256-GCM, AES-128-GCM encryption

### Network Segmentation (Future)

**Planned VLANs:**
- VLAN 10: Management (iLO, AMT)
- VLAN 20: Production (user workstations)
- VLAN 30: Servers (dc1, mail server)
- VLAN 40: Guest (isolated)

**Current Status:** Single LAN segment (192.168.1.0/24)
**Future Enhancement:** VLAN segmentation when managed switch deployed

---

# SECTION 4: SECURITY ARCHITECTURE

## 4.1 Defense in Depth

The CyberHygiene Production Network implements multiple layers of security controls:

### Layer 1: Physical Security
- ✓ Locked server room (restricted access)
- ✓ Chassis intrusion detection (iLO-equipped systems)
- ✓ Cable locks on workstations
- ✓ Facility alarm system
- ✓ Surveillance cameras (facility-wide)

### Layer 2: Network Security
- ✓ pfSense firewall with stateful packet inspection
- ✓ IDS/IPS capability (Suricata available)
- ✓ Network segmentation (current: single LAN; planned: VLANs)
- ✓ NAT and port forwarding restrictions
- ✓ Firewall logging and monitoring

### Layer 3: Host Security
- ✓ FIPS 140-2 cryptographic validation
- ✓ SELinux enforcing mode
- ✓ LUKS full disk encryption (AES-256-XTS)
- ✓ Secure Boot (UEFI)
- ✓ TPM 2.0 for key storage
- ✓ Automatic security patching

### Layer 4: Application Security
- ✓ TLS encryption for all network services
- ✓ Strong authentication (Kerberos SSO)
- ✓ Role-based access control (RBAC)
- ✓ Principle of least privilege
- ✓ Input validation and sanitization
- ✓ Secure coding practices

### Layer 5: Data Security
- ✓ Encryption at rest (LUKS on all drives)
- ✓ Encryption in transit (TLS, SSH, SMB3)
- ✓ CUI data markings
- ✓ Access logging and monitoring
- ✓ Data backup and recovery
- ✓ Secure data disposal (NIST SP 800-88)

### Layer 6: Monitoring and Detection
- ✓ Wazuh SIEM/XDR for threat detection
- ✓ File Integrity Monitoring (real-time)
- ✓ Vulnerability scanning (hourly updates)
- ✓ Security Configuration Assessment (CIS benchmarks)
- ✓ Centralized logging (journald + Wazuh)
- ✓ Audit trail (auditd)

### Layer 7: Incident Response
- ✓ Automated alerting (Wazuh)
- ✓ Active response capabilities
- ✓ Backup and recovery procedures
- ✓ Incident response plan (in development)
- ✓ Forensic logging

---

## 4.2 Access Control

### Authentication Methods

**Primary Authentication:**
- Kerberos SSO (FreeIPA)
- Password policy: 14+ characters, complexity requirements
- Password expiration: 90 days
- Password history: 12 passwords remembered
- Account lockout: 5 failed attempts, 30-minute lockout

**Administrative Access:**
- SSH key-based authentication (password disabled for root)
- Sudo with authentication required
- Privileged operations logged (auditd + Wazuh)

**Future Enhancement:**
- Multi-factor authentication (OTP, PIV/CAC)

### Authorization

**Role-Based Access Control (RBAC):**
- FreeIPA user groups
- Sudo rules by group
- Host-based access control (HBAC)
- SELinux role-based separation

**Principle of Least Privilege:**
- Users have minimum necessary permissions
- Administrative access granted only when needed
- Temporary privilege escalation via sudo
- Regular access reviews

---

## 4.3 Audit and Accountability

### Logging Architecture

**Centralized Logging:**
- All systems log to journald (local)
- Critical logs forwarded to Wazuh (dc1)
- Audit logs stored on dedicated partition (/var/log/audit)

**Log Sources:**
- System logs (journald)
- Authentication logs (SSH, sudo, PAM)
- Audit logs (auditd)
- Application logs (FreeIPA, Samba, Apache, Wazuh)
- Network logs (pfSense firewall)

**Log Retention:**
- Journald: 30 days (local)
- Auditd: 90 days (dedicated partition)
- Wazuh Indexer: 90 days (searchable database)
- Backup: 1 year (daily/weekly backups)

**Log Protection:**
- ✓ Append-only logs (immutable flag)
- ✓ Separate encrypted partition
- ✓ Wazuh FIM monitoring log files
- ✓ Backup of logs included in daily backups
- ✓ SELinux protection of log files

### Monitoring and Alerting

**Real-Time Monitoring:**
- Wazuh SIEM monitors all security events
- Alert level 3+: Logged to file
- Alert level 12+: Email notification (after mail server)

**Security Events Monitored:**
- Failed authentication attempts
- Privilege escalation (sudo)
- File changes (FIM)
- New vulnerabilities detected
- Service failures
- System reboots
- Configuration changes
- Suspicious command execution

**Compliance Monitoring:**
- OpenSCAP automated scanning
- Security Configuration Assessment (SCA)
- Vulnerability scanning
- Compliance reporting (NIST, PCI DSS, HIPAA)

---

## 4.4 Data Protection

### Encryption

**At Rest:**
- LUKS (AES-256-XTS) on all drives
- FIPS 140-2 validated cryptography
- Encrypted swap partitions
- Key storage in TPM 2.0

**In Transit:**
- TLS 1.2+ for HTTPS
- SSH for remote administration
- LDAPS for directory queries
- SMB3 encryption for file sharing
- Kerberos ticket encryption

**Email (Future):**
- TLS for SMTP connections
- S/MIME for message encryption
- PGP support (optional)

### Data Classification

**CUI (Controlled Unclassified Information):**
- Stored on encrypted RAID 5 array (`/srv/samba`)
- Access controlled via FreeIPA groups
- CUI markings required
- Audit logging of all access
- Backup with encryption

**System Data:**
- Configuration files: `/etc` (FIM monitored)
- Application data: `/data` (encrypted)
- User home directories: `/home` (encrypted)
- Logs and audit: `/var/log` (dedicated partition)

**Backup Data:**
- Daily backups: `/backup` (encrypted)
- Weekly backups: `/srv/samba/backups` (encrypted RAID 5)
- Offsite backups: Planned (encrypted before transit)

---

# SECTION 5: COMPLIANCE STATUS

## 5.1 NIST SP 800-171 Rev 2 Compliance

### Implementation Summary

**Total Controls:** 110 (14 families)
**Implemented:** 103 controls (94%)
**Partially Implemented:** 7 controls (6%)
**Not Implemented:** 0 controls

**Estimated SPRS Score:** ~91 points (out of 110)

### Control Families

**Access Control (AC) - 22 controls:**
- Implementation: 100% (22/22)
- Key controls: Least privilege, account management, session controls
- Tools: FreeIPA, SELinux, sudo, HBAC

**Awareness and Training (AT) - 3 controls:**
- Implementation: 33% (1/3)
- Completed: Security awareness policy
- Pending: Formal training program, insider threat training

**Audit and Accountability (AU) - 9 controls:**
- Implementation: 100% (9/9)
- Key controls: Audit logging, log protection, time synchronization
- Tools: Auditd, journald, Wazuh, NTP

**Configuration Management (CM) - 9 controls:**
- Implementation: 100% (9/9)
- Key controls: Baseline configurations, change control, least functionality
- Tools: OpenSCAP, Wazuh SCA, version control

**Identification and Authentication (IA) - 11 controls:**
- Implementation: 91% (10/11)
- Completed: Password policies, Kerberos SSO, session controls
- Pending: Multi-factor authentication (MFA)

**Incident Response (IR) - 4 controls:**
- Implementation: 75% (3/4)
- Completed: Incident handling capability, monitoring, reporting
- Pending: Formal incident response plan documentation

**Maintenance (MA) - 6 controls:**
- Implementation: 100% (6/6)
- Key controls: Controlled maintenance, maintenance tools, remote maintenance
- Tools: iLO 5, SSH, logging

**Media Protection (MP) - 8 controls:**
- Implementation: 100% (8/8)
- Key controls: Media access, marking, storage, transport, sanitization
- Tools: LUKS encryption, physical security

**Personnel Security (PS) - 2 controls:**
- Implementation: 100% (2/2)
- Completed: Personnel screening, termination procedures

**Physical Protection (PE) - 6 controls:**
- Implementation: 100% (6/6)
- Key controls: Physical access control, monitoring, asset tracking
- Tools: Locked facility, iLO intrusion detection, asset inventory

**Risk Assessment (RA) - 3 controls:**
- Implementation: 100% (3/3)
- Completed: Risk assessments, vulnerability scanning, remediation
- Tools: Wazuh vulnerability detection, OpenSCAP

**Security Assessment (CA) - 4 controls:**
- Implementation: 100% (4/4)
- Completed: Security assessments, POA&M, continuous monitoring
- Tools: OpenSCAP, Wazuh, this SSP/POAM document

**System and Communications Protection (SC) - 15 controls:**
- Implementation: 100% (15/15)
- Key controls: Boundary protection, encryption, session termination
- Tools: pfSense, LUKS, TLS, SSH, FIPS mode

**System and Information Integrity (SI) - 8 controls:**
- Implementation: 100% (8/8)
- Key controls: Flaw remediation, malware protection, monitoring
- Tools: DNF automatic, ClamAV, Wazuh FIM, vulnerability scanning

---

## 5.2 FIPS 140-2 Compliance

### Cryptographic Validation

**FIPS Mode Status:** ✓ ENABLED on all systems

**Validation:**
```bash
# Verification command output:
$ fips-mode-setup --check
FIPS mode is enabled.
```

**Cryptographic Modules:**
- Kernel Crypto API (AES, SHA, HMAC)
- OpenSSL 3.0 (FIPS module)
- GnuTLS (FIPS mode)
- NSS (Mozilla Network Security Services, FIPS mode)

**Algorithms Used:**
- Symmetric: AES-256-XTS (LUKS), AES-256-GCM (TLS)
- Hashing: SHA-256, SHA-512
- HMAC: HMAC-SHA-256, HMAC-SHA-512
- Key Exchange: ECDHE, DHE (TLS)
- Digital Signature: RSA-2048, ECDSA

**FIPS Compliance Verification:**
- ✓ All systems boot in FIPS mode
- ✓ OpenSSL FIPS module loaded
- ✓ No non-FIPS algorithms available
- ✓ Kernel crypto API restricted to FIPS algorithms
- ✓ LUKS uses AES-256-XTS (FIPS-approved)

---

## 5.3 OpenSCAP CUI Profile Compliance

### Compliance Scanning Results

**All Systems: 100% Compliant**

**dc1.cyberinabox.net:**
- Profile: SCAP Security Guide - CUI
- Checks Passed: 105/105 (100%)
- Checks Failed: 0
- Last Scan: October 28, 2025

**LabRat, Engineering, Accounting:**
- Profile: SCAP Security Guide - CUI
- Checks Passed: 105/105 (100%) each
- Checks Failed: 0 each
- Last Scan: October 28, 2025

**Key CUI Requirements Met:**
- ✓ Password complexity and aging
- ✓ Account lockout policies
- ✓ Audit logging configuration
- ✓ SELinux enforcing mode
- ✓ Firewall enabled and configured
- ✓ SSH hardening
- ✓ File permission restrictions
- ✓ Service minimization
- ✓ Kernel hardening (sysctl)
- ✓ AIDE file integrity (via Wazuh FIM)

---

## 5.4 CMMC Level 2 Readiness

### CMMC 2.0 Level 2 Assessment

**Total Practices:** 110 (same as NIST 800-171)
**Implementation Status:** 94% (103/110 practices)

**CMMC Domains:**

1. **Access Control (AC):** 100% implemented
2. **Awareness and Training (AT):** 33% implemented (training program pending)
3. **Audit and Accountability (AU):** 100% implemented
4. **Configuration Management (CM):** 100% implemented
5. **Identification and Authentication (IA):** 91% implemented (MFA pending)
6. **Incident Response (IR):** 75% implemented (formal plan pending)
7. **Maintenance (MA):** 100% implemented
8. **Media Protection (MP):** 100% implemented
9. **Personnel Security (PS):** 100% implemented
10. **Physical Protection (PE):** 100% implemented
11. **Risk Assessment (RA):** 100% implemented
12. **Security Assessment (CA):** 100% implemented
13. **System and Communications Protection (SC):** 100% implemented
14. **System and Information Integrity (SI):** 100% implemented

**Maturity Level:**
- Level 1 (Performed): ✓ Met (all basic practices implemented)
- Level 2 (Documented): ✓ Met (SSP/POAM documented)
- Level 3 (Managed): Planned (continuous improvement)

**CMMC Assessment Readiness:** January 1, 2026 (after POA&M completion)

---

# SECTION 6: APPENDICES

## Appendix A: Service Port Matrix

| Service | Port(s) | Protocol | System | Purpose |
|---|---|---|---|---|
| DNS | 53 | TCP/UDP | dc1 | Domain name resolution |
| DHCP | 67 | UDP | pfSense | IP address assignment |
| Kerberos | 88 | TCP/UDP | dc1 | Authentication |
| NTP | 123 | UDP | dc1 | Time synchronization |
| LDAP | 389 | TCP | dc1 | Directory services |
| HTTPS | 443 | TCP | dc1, pfSense | Web services (encrypted) |
| SMB | 445 | TCP | dc1 | File sharing |
| Kerberos Passwd | 464 | TCP/UDP | dc1 | Password changes |
| LDAPS | 636 | TCP | dc1 | Encrypted directory services |
| Wazuh Agent | 1514 | TCP | dc1 | Security monitoring |
| Wazuh Cluster | 1515 | TCP | dc1 | Cluster communication |
| Wazuh Indexer | 9200 | TCP | dc1 | Alert storage (internal) |
| Wazuh API | 55000 | TCP | dc1 | API access |

---

## Appendix B: File System Hierarchy

### dc1.cyberinabox.net File System Layout

```
/                     - Root filesystem (90 GB, encrypted)
├── /boot             - Boot files (7.4 GB, unencrypted)
├── /boot/efi         - EFI System Partition (952 MB, FAT32)
├── /tmp              - Temporary files (15 GB, encrypted, noexec)
├── /var              - Variable data (30 GB, encrypted)
│   ├── /var/log      - System logs (15 GB, encrypted, dedicated partition)
│   └── /var/log/audit - Audit logs (15 GB, encrypted, dedicated partition)
├── /home             - User home directories (239 GB, encrypted)
├── /backup           - Daily backups (931 GB, encrypted)
├── /data             - Application data (350 GB, encrypted)
└── /srv/samba        - CUI data storage (5.5 TB RAID 5, encrypted)
    └── backups       - Weekly ReaR backup ISOs
```

**All partitions use LVM on LUKS encryption except /boot and /boot/efi**

---

## Appendix C: User and Group Structure

### FreeIPA Users (Examples)

- **dshannon** - System Owner, Administrator
- **backup-user** - Automated backup account (service account)
- **wazuh** - Wazuh service account

### FreeIPA Groups

- **admins** - Full administrative access (sudo all)
- **users** - Standard user access
- **engineering** - Engineering workstation access
- **accounting** - Accounting workstation access
- **backup-operators** - Backup and restore permissions

### HBAC Rules

- **allow_admins_all** - Admins can access all hosts
- **allow_engineering** - Engineering group → engineering.cyberinabox.net
- **allow_accounting** - Accounting group → accounting.cyberinabox.net
- **allow_all_services** - Users can access all services (SSH, sudo, login)

---

## Appendix D: Backup Schedule and Retention

### Daily Backups (Automated)

**Schedule:** 2:00 AM daily
**Target:** `/backup` on dc1 (931 GB capacity)
**Retention:** 30 days (daily rotation)
**Method:** rsync with incremental snapshots

**Contents:**
- `/etc` - System configurations
- `/var/lib/ipa` - FreeIPA database
- `/root/.ssh` - SSH keys
- `/var/ossec/etc` - Wazuh configurations
- LUKS encryption headers
- SSL certificates

### Weekly Backups (Automated)

**Schedule:** Sunday 3:00 AM
**Target:** `/srv/samba/backups` on RAID 5 (5.5 TB capacity)
**Retention:** 4 weeks (weekly rotation)
**Method:** ReaR (Relax-and-Recover)
**Format:** Bootable ISO (~890 MB) + full system backup tar.gz

**Capabilities:**
- Bare-metal recovery
- Full system restoration
- LUKS and LVM recreation
- Bootloader reinstallation

### Offsite Backups (Planned)

**Method:** Encrypted backup to cloud storage or external media
**Frequency:** Monthly
**Encryption:** GPG encryption before transfer
**Target:** TBD (AWS S3, Azure Blob, or external HDD)

---

## Appendix E: Acronyms and Abbreviations

| Acronym | Definition |
|---|---|
| AC | Access Control |
| AES | Advanced Encryption Standard |
| AMT | Active Management Technology (Intel) |
| AU | Audit and Accountability |
| CA | Certificate Authority, Security Assessment |
| CAGE | Commercial and Government Entity |
| CIS | Center for Internet Security |
| CM | Configuration Management |
| CMMC | Cybersecurity Maturity Model Certification |
| CP | Contingency Planning |
| CPU | Central Processing Unit |
| CUI | Controlled Unclassified Information |
| CVE | Common Vulnerabilities and Exposures |
| CVSS | Common Vulnerability Scoring System |
| DFARS | Defense Federal Acquisition Regulation Supplement |
| DHCP | Dynamic Host Configuration Protocol |
| DNS | Domain Name System |
| DNSSEC | DNS Security Extensions |
| DUNS | Data Universal Numbering System |
| ECC | Error-Correcting Code |
| FAR | Federal Acquisition Regulation |
| FCI | Federal Contract Information |
| FIM | File Integrity Monitoring |
| FIPS | Federal Information Processing Standards |
| GB | Gigabyte (10^9 bytes) |
| GDPR | General Data Protection Regulation |
| GNOME | GNU Network Object Model Environment |
| GPU | Graphics Processing Unit |
| HBAC | Host-Based Access Control |
| HIPAA | Health Insurance Portability and Accountability Act |
| HTTPS | Hypertext Transfer Protocol Secure |
| IA | Identification and Authentication |
| IDS | Intrusion Detection System |
| iLO | Integrated Lights-Out (HP management) |
| IP | Internet Protocol |
| IPS | Intrusion Prevention System |
| IR | Incident Response |
| ISSO | Information System Security Officer |
| KDC | Key Distribution Center (Kerberos) |
| LDAP | Lightweight Directory Access Protocol |
| LUKS | Linux Unified Key Setup |
| LVM | Logical Volume Manager |
| MA | Maintenance |
| MFA | Multi-Factor Authentication |
| MP | Media Protection |
| NAICS | North American Industry Classification System |
| NAT | Network Address Translation |
| NIST | National Institute of Standards and Technology |
| NTP | Network Time Protocol |
| OTP | One-Time Password |
| PAM | Pluggable Authentication Modules |
| PCI DSS | Payment Card Industry Data Security Standard |
| PE | Physical Protection |
| pfSense | Open-source firewall/router platform |
| PIV | Personal Identity Verification |
| PKI | Public Key Infrastructure |
| POA&M | Plan of Action and Milestones |
| PS | Personnel Security |
| RA | Risk Assessment |
| RAID | Redundant Array of Independent Disks |
| RAM | Random Access Memory |
| RBAC | Role-Based Access Control |
| ReaR | Relax-and-Recover (backup tool) |
| RHEL | Red Hat Enterprise Linux |
| SA | System and Services Acquisition |
| SAN | Subject Alternative Name |
| SATA | Serial AT Attachment |
| SC | System and Communications Protection |
| SCA | Security Configuration Assessment |
| SCAP | Security Content Automation Protocol |
| SELinux | Security-Enhanced Linux |
| SI | System and Information Integrity |
| SIEM | Security Information and Event Management |
| SMB | Server Message Block (file sharing protocol) |
| SMTP | Simple Mail Transfer Protocol |
| SO-DIMM | Small Outline Dual In-line Memory Module |
| SPRS | Supplier Performance Risk System |
| SSD | Solid State Drive |
| SSH | Secure Shell |
| SSL | Secure Sockets Layer |
| SSO | Single Sign-On |
| SSP | System Security Plan |
| TB | Terabyte (10^12 bytes) |
| TCP | Transmission Control Protocol |
| TLS | Transport Layer Security |
| TPM | Trusted Platform Module |
| UDP | User Datagram Protocol |
| UEFI | Unified Extensible Firmware Interface |
| USFF | Ultra Small Form Factor |
| VPN | Virtual Private Network |
| vPro | Intel vPro (management technology) |
| WAN | Wide Area Network |
| XDR | Extended Detection and Response |

---

## Appendix F: References

### Standards and Regulations

1. NIST SP 800-171 Rev 2 - Protecting Controlled Unclassified Information in Nonfederal Systems
2. NIST SP 800-53 Rev 5 - Security and Privacy Controls for Information Systems
3. NIST SP 800-171A - Assessing Security Requirements for Controlled Unclassified Information
4. FIPS 140-2 - Security Requirements for Cryptographic Modules
5. FIPS 199 - Standards for Security Categorization of Federal Information
6. FAR 52.204-21 - Basic Safeguarding of Covered Contractor Information Systems
7. DFARS 252.204-7012 - Safeguarding Covered Defense Information
8. CIS Benchmarks - Rocky Linux 9
9. CMMC 2.0 Model - Cybersecurity Maturity Model Certification

### Product Documentation

1. Rocky Linux 9 Documentation - https://docs.rockylinux.org
2. FreeIPA Documentation - https://www.freeipa.org/page/Documentation
3. Wazuh Documentation - https://documentation.wazuh.com
4. OpenSCAP User Guide - https://www.open-scap.org/resources/documentation/
5. ReaR User Guide - https://relax-and-recover.org/documentation/
6. HP iLO 5 User Guide
7. pfSense Documentation - https://docs.netgate.com

---

## Appendix G: System Diagrams

### Logical Architecture Diagram

```
                          INTERNET
                              |
                    [Netgate 2100 pfSense]
                    (96.72.6.225 WAN)
                    (192.168.1.1 LAN)
                              |
                  -------------------------
                  |       LAN Switch      |
                  -------------------------
                    |       |       |       |
        +-----------+       |       |       +-----------+
        |                   |       |                   |
   [dc1 Server]      [LabRat WS]  [Eng WS]     [Acct WS]
   192.168.1.10      192.168.1.115 192.168.1.104 192.168.1.113

   Services on dc1:
   - FreeIPA (LDAP/Kerberos/DNS/CA)
   - Wazuh SIEM (Manager + Indexer)
   - Samba File Server (5.5TB RAID 5)
   - Backup Server (ReaR + rsync)
   - ClamAV Antivirus
   - NTP Server
```

### Storage Architecture Diagram

```
dc1 Server Storage Layout:

Boot Drive (2 TB SSD/HDD):
┌─────────────────────────────────────────────┐
│ /boot/efi (952 MB) - EFI, unencrypted       │
├─────────────────────────────────────────────┤
│ /boot (7.4 GB) - Kernel, unencrypted        │
├─────────────────────────────────────────────┤
│ LUKS Encrypted Volume (1.98 TB)             │
│ ┌─────────────────────────────────────────┐ │
│ │ LVM Physical Volume                     │ │
│ │ ┌───────────────────────────────────┐   │ │
│ │ │ / (root) - 90 GB                  │   │ │
│ │ │ /tmp - 15 GB                      │   │ │
│ │ │ /var - 30 GB                      │   │ │
│ │ │ /var/log - 15 GB                  │   │ │
│ │ │ /var/log/audit - 15 GB            │   │ │
│ │ │ /home - 239 GB                    │   │ │
│ │ │ /backup - 931 GB (daily backups)  │   │ │
│ │ │ /data - 350 GB                    │   │ │
│ │ │ swap - 29 GB                      │   │ │
│ │ └───────────────────────────────────┘   │ │
│ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘

RAID 5 Array (3 × 3 TB HDDs = 5.5 TB usable):
┌─────────────────────────────────────────────┐
│ RAID 5 (md device)                          │
│ ┌─────────────────────────────────────────┐ │
│ │ LUKS Encrypted Volume (5.5 TB)          │ │
│ │ ┌───────────────────────────────────┐   │ │
│ │ │ /srv/samba (5.5 TB)               │   │ │
│ │ │ - CUI data storage                │   │ │
│ │ │ - Samba file shares               │   │ │
│ │ │ - Weekly backups (ReaR ISOs)      │   │ │
│ │ └───────────────────────────────────┘   │ │
│ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘

Total Usable Storage: ~7.2 TB
```

---

## Appendix H: Contact Information

### System Owner / ISSO

**Name:** Donald E. Shannon
**Title:** Owner/Principal
**Organization:** Donald E. Shannon LLC dba The Contract Coach
**Email:** Don@Contractcoach.com
**Phone:** 505.259.8485
**Security Clearance:** Active DoD Top Secret

### Emergency Contacts

**After-Hours Support:** 505.259.8485
**Incident Reporting:** Don@Contractcoach.com

### Vendor Support Contacts

**HP Enterprise Support:** (For dc1, LabRat - iLO 5)
**HP Business Support:** (For Engineering, Accounting workstations)
**Netgate Support:** (For pfSense firewall)
**Rocky Linux Community:** https://chat.rockylinux.org

---

## DOCUMENT APPROVAL

This Technical Specifications Document accurately represents the CyberHygiene Production Network as deployed and configured as of October 28, 2025.

**System Owner:**

Signature: _______________________________  Date: _______________
Donald E. Shannon, Owner/Principal

**ISSO:**

Signature: _______________________________  Date: _______________
Donald E. Shannon, Information System Security Officer

---

**Last Updated:** October 28, 2025
**Document Version:** 1.2
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Distribution:** Limited to authorized personnel only

**END OF DOCUMENT**
## Additional Appendix Updates for v1.3

### Appendix A: Service Port Matrix - Additional Entries

| Service | Port | Protocol | System | Purpose | External |
|---|---|---|---|---|---|
| Ollama API | 11434 | HTTP | ai.cyberinabox.net | LLM inference API | No (localhost only) |
| AI API Proxy | 443 | HTTPS | dc1.cyberinabox.net | Proxied AI access via /ai-api | Yes (internal) |

### Network Scan Services

| Service | Port/Protocol | System | Purpose |
|---|---|---|---|
| Network Scanner | sudo execution | dc1.cyberinabox.net | nmap-based device discovery |

---

### Appendix I: AI/ML Architecture Diagram

```
CyberHygiene AI Infrastructure

┌──────────────────────────────────────────────────────────────┐
│                     User Workstation                          │
│                  (Web Browser - HTTPS)                        │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         │ HTTPS (443)
                         ↓
┌──────────────────────────────────────────────────────────────┐
│              dc1.cyberinabox.net (Domain Controller)         │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Apache HTTPS Server                                   │  │
│  │  - Serves: /ai-dashboard.html                          │  │
│  │  - Serves: /scan-network.php                           │  │
│  │  - Proxy: /ai-api → http://ai.cyberinabox.net:11434   │  │
│  └──────────┬─────────────────────────┬───────────────────┘  │
│             │                          │                      │
│             │ Execute                  │ HTTP Proxy           │
│             ↓                          ↓                      │
│  ┌─────────────────────┐    ┌──────────────────────────┐     │
│  │ network-scan.sh     │    │  Internal Network        │     │
│  │ (sudo wrapper)      │    │  to AI Server            │     │
│  └──────────┬──────────┘    └────────────┬─────────────┘     │
│             │                            │                    │
│             │ Executes nmap              │                    │
│             ↓                            │                    │
│  ┌─────────────────────┐                │                    │
│  │  nmap -sn -n        │                │                    │
│  │  192.168.1.0/24     │                │                    │
│  └─────────────────────┘                │                    │
└─────────────────────────────────────────┼────────────────────┘
                                          │
                                          │ HTTP (11434)
                                          │ Internal only
                                          ↓
┌──────────────────────────────────────────────────────────────┐
│            ai.cyberinabox.net (AI Server)                    │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Ollama Service (Port 11434, localhost only)           │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │  Code Llama 7B Model (3.8GB)                     │  │  │
│  │  │  - System Administration                         │  │  │
│  │  │  - Security Analysis                             │  │  │
│  │  │  - Log Interpretation                            │  │  │
│  │  │  - Network Diagnostics                           │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  Security Controls:                                          │
│  ✓ No internet access (air-gapped)                          │
│  ✓ SELinux enforcing                                        │
│  ✓ Firewall: Only allow from dc1                           │
│  ✓ All data processing local                               │
└──────────────────────────────────────────────────────────────┘

Data Flow:
1. User accesses dashboard via HTTPS
2. JavaScript in browser communicates with AI via proxy
3. dc1 forwards requests to ai.cyberinabox.net
4. Ollama processes request using local model
5. Response returned through proxy chain
6. No external network access - all processing internal
```

---

### Appendix J: SELinux Policy Modules

**AI Infrastructure Policies:**

| Module Name | Purpose | Systems |
|---|---|---|
| httpd-network-scan-final | Allows httpd to execute sudo/PAM operations | dc1.cyberinabox.net |
| httpd-nmap-network | Allows httpd to create packet sockets for nmap | dc1.cyberinabox.net |
| httpd-sudo-complete | Allows httpd PAM/SSSD access for sudo | dc1.cyberinabox.net |

**Key Policy Permissions:**
```
# httpd_t context permissions for network scanning
allow httpd_t self:capability net_raw;
allow httpd_t self:capability2 bpf;
allow httpd_t self:packet_socket { bind create getopt ioctl map setopt };
allow httpd_t shadow_t:file { getattr open read };
allow httpd_t sssd_conf_t:file { getattr open read };
```

---
