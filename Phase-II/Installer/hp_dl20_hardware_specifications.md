# HP Proliant DL20 Gen10 Plus Hardware Specifications
## CyberHygiene Phase II Target Platform

**Version:** 1.0
**Date:** 2026-01-01
**Purpose:** Hardware procurement and setup guide for Phase II deployments

---

## Table of Contents

1. [Hardware Overview](#hardware-overview)
2. [Technical Specifications](#technical-specifications)
3. [Recommended Configuration](#recommended-configuration)
4. [Procurement Guide](#procurement-guide)
5. [Initial Setup](#initial-setup)
6. [BIOS Configuration](#bios-configuration)
7. [Hardware Compatibility](#hardware-compatibility)
8. [Troubleshooting](#troubleshooting)

---

## Hardware Overview

### HP Proliant DL20 Gen10 Plus

**Form Factor:** 1U rack-mount server
**Target Use:** Small business server, edge computing, branch office
**CyberHygiene Role:** All-in-one security platform for 5-15 employees

**Key Features:**
- Compact 1U form factor (fits 6U portable rack)
- Intel Xeon E-2300 series processor support
- Up to 128 GB DDR4 ECC memory
- Dual hot-plug 2.5" or single 3.5" drive bays
- Integrated Lights-Out (iLO) remote management
- Redundant power supply option
- TPM 2.0 for hardware-based encryption
- Energy efficient (85% power supply efficiency)

**Dimensions:**
- Height: 1.70 in (4.32 cm) - 1U
- Width: 17.09 in (43.4 cm)
- Depth: 15.05 in (38.23 cm) - Short depth
- Weight: ~20 lbs (9 kg) depending on configuration

**Power:**
- 290W or 500W power supply options
- Input voltage: 100-240V AC, 50/60Hz
- Typical power consumption: 50-150W (depending on load)

---

## Technical Specifications

### Processor Options

**Recommended for CyberHygiene:**
- **Intel Xeon E-2334** (4 cores, 8 threads, 3.4 GHz base, 4.8 GHz turbo)
  - 8 MB cache
  - TDP: 65W
  - **Best balance of performance and cost**

**Alternative Options:**
- Intel Xeon E-2336 (6 cores, 12 threads, 2.9 GHz base)
  - Higher core count for heavy workloads
  - More expensive
- Intel Xeon E-2388G (8 cores, 16 threads, 3.2 GHz base)
  - Maximum performance option
  - Highest cost

**Minimum Requirement:** Xeon E-2334 (4 core) or better

---

### Memory Configuration

**Recommended for CyberHygiene:**
- **64 GB DDR4 ECC** (minimum)
  - 2x 32 GB DIMMs
  - 2933 MHz (PC4-23400)
  - ECC (Error Correcting Code) - required for reliability

**Optimal Configuration:**
- **128 GB DDR4 ECC** (recommended for optimal performance)
  - 4x 32 GB DIMMs
  - 2933 MHz
  - Allows all services to run comfortably with overhead

**Memory Slots:**
- 4x DIMM slots (UDIMM)
- Maximum: 128 GB (4x 32 GB)
- Supports DDR4 2933/2666 MHz

**Memory Allocation (64 GB Configuration):**
- FreeIPA: 8 GB
- Graylog (Elasticsearch): 16 GB
- Wazuh (OpenSearch): 8 GB
- Suricata: 8 GB
- Prometheus: 4 GB
- Grafana: 2 GB
- Samba/System: 8 GB
- **Available:** 10 GB buffer

**Memory Allocation (128 GB Configuration):**
- Double allocations for better performance
- **Available:** 74 GB buffer for future expansion

---

### Storage Configuration

**Recommended for CyberHygiene:**

**Option 1: Single Drive (Simplest)**
- 1x 2 TB NVMe SSD (M.2 form factor)
- PCIe Gen 3 x4 interface
- Read: 3,500 MB/s, Write: 3,000 MB/s
- **Pros:** Simple, fast, lower cost
- **Cons:** No redundancy

**Option 2: Dual Drive with Software RAID (Redundant)**
- 2x 2 TB SATA SSD (2.5" hot-plug)
- RAID 1 (mirroring) via mdadm (Linux software RAID)
- Read: 550 MB/s, Write: 520 MB/s per drive
- **Pros:** Redundancy, hot-swap capability
- **Cons:** Higher cost, slower than NVMe

**Option 3: NVMe + SATA (Best of Both)**
- 1x 512 GB NVMe SSD (system/OS)
- 1x 4 TB SATA SSD (data/logs)
- **Pros:** Fast OS, large data storage
- **Cons:** Most expensive, more complex setup

**Phase II Recommendation:** Option 1 (Single 2 TB NVMe)
- Simpler installation
- Adequate performance
- Future: Can add external backup drive via USB 3.0

**Storage Controllers:**
- Embedded SATA controller (6 Gb/s)
- Optional: Smart Array S100i SR Gen10 SW RAID controller
- NVMe support via M.2 slot

---

### Network Configuration

**Integrated Network Adapters:**
- 2x 1 Gb Ethernet ports (HPE 332i adapter)
- Intel i350 chipset
- Supports teaming/bonding for redundancy

**Network Configuration for CyberHygiene:**
- **Port 1 (eno1):** Primary network interface
  - Static IP: [SUBNET].10 (e.g., 192.168.1.10)
  - Connected to customer LAN
- **Port 2 (eno2):** Reserved for future use
  - Options: Dedicated management network, failover, monitoring

**Optional Network Upgrades:**
- 10 Gb SFP+ network adapter (PCIe slot)
  - Not required for small business deployments

---

### Expansion Slots

**PCIe Slots:**
- 1x PCIe Gen3 x16 slot (low profile)
- 1x M.2 slot (NVMe SSD or WLAN)

**Potential Uses:**
- 10 Gb network adapter
- Additional RAID controller
- GPU for future AI workloads (limited by low-profile requirement)

**USB Ports:**
- Front: 2x USB 3.0
- Rear: 2x USB 3.0
- Internal: 1x USB 2.0 (for bootable key or license dongle)

**Other Interfaces:**
- VGA (rear) - for local console
- Serial port (rear) - for out-of-band management
- Dedicated iLO management port (1 Gb Ethernet)

---

### Management Features

**HP iLO 5 (Integrated Lights-Out):**
- Remote console access (KVM over IP)
- Virtual media support (mount ISOs remotely)
- Power management (remote power on/off/reset)
- Hardware health monitoring
- BIOS/firmware updates
- Event logging

**iLO Licensing:**
- **Standard (included):** Basic remote management
- **Advanced (optional):** Remote console, virtual media, scripting
  - **Recommended for Phase II** - enables remote installation/troubleshooting

**TPM 2.0 (Trusted Platform Module):**
- Hardware-based cryptographic operations
- Secure key storage
- Can be used for disk encryption passphrases
- FIPS 140-2 Level 2 compliant

**Intelligent Provisioning:**
- Pre-boot environment for OS deployment
- Firmware updates
- System diagnostics
- RAID configuration

---

## Recommended Configuration

### Base CyberHygiene Configuration

**Part Number:** P18584-B21 (example base unit)

**Configuration:**
- **Server:** HP Proliant DL20 Gen10 Plus
- **Processor:** Intel Xeon E-2334 (4-core, 3.4 GHz)
- **Memory:** 64 GB (2x 32 GB DDR4-2933 ECC UDIMM)
- **Storage:** 2 TB NVMe SSD (M.2)
- **Network:** Dual 1 Gb Ethernet (integrated)
- **Management:** iLO 5 Advanced
- **Power:** 290W power supply (single, non-redundant for cost savings)
- **Warranty:** 3-year parts and labor, next business day on-site

**Estimated Cost:** $2,500 - $3,000 (depending on configuration and discounts)

### Optimal Configuration (High Availability)

**Configuration:**
- **Server:** HP Proliant DL20 Gen10 Plus
- **Processor:** Intel Xeon E-2336 (6-core, 2.9 GHz)
- **Memory:** 128 GB (4x 32 GB DDR4-2933 ECC UDIMM)
- **Storage:** 2x 2 TB SATA SSD (RAID 1 via software)
- **Network:** Dual 1 Gb Ethernet (integrated)
- **Management:** iLO 5 Advanced
- **Power:** Redundant 500W power supplies
- **Warranty:** 5-year 24x7 support

**Estimated Cost:** $4,000 - $5,000

---

## Procurement Guide

### Where to Purchase

**Authorized HP Resellers:**
- CDW (cdw.com) - Business pricing available
- Insight (insight.com) - Government and education discounts
- Connection (connection.com) - Volume discounts
- Direct from HPE (hpe.com) - Custom configurations

**Considerations:**
- Check for business/government discounts
- Verify warranty terms
- Confirm iLO Advanced license included or purchase separately
- Ask about SmartBuy programs for small businesses

### Pre-Purchase Checklist

Before purchasing, confirm:

- [ ] Processor meets minimum requirement (Xeon E-2334 or better)
- [ ] Memory is ECC (Error Correcting Code) DDR4
- [ ] Storage capacity is adequate (2 TB minimum)
- [ ] iLO Advanced license included or budgeted
- [ ] Power supply meets facility requirements (120V or 240V)
- [ ] Rack rails or shelf included (for 6U portable rack)
- [ ] Warranty duration acceptable (3-year minimum recommended)
- [ ] TPM 2.0 module included (usually standard)

### Accessories Needed

**Required:**
- **Rack rails or shelf:** For mounting in 6U portable rack
  - Part: HPE 1U Short Friction Rail Kit (HP 2U SFF Easy Install Rail Kit)
- **Power cables:** C13 to appropriate plug for customer facility
- **Network cables:** 2x CAT6 Ethernet cables (minimum 3 ft)

**Recommended:**
- **KVM cable kit:** For local console access (VGA + USB)
- **iLO Advanced license:** If not included (enables remote management)
- **Additional NVMe SSD:** For testing/development (can reuse)

**Optional:**
- **UPS (Uninterruptible Power Supply):** APC Smart-UPS 1500VA or similar
- **Portable rack case:** 6U rolling rack case (if not already procured)

---

## Initial Setup

### Unboxing and Inspection

1. **Verify Contents:**
   - [ ] Server unit
   - [ ] Power cable(s)
   - [ ] Rack mounting hardware
   - [ ] Documentation and warranty card
   - [ ] iLO license (if applicable)

2. **Physical Inspection:**
   - Check for shipping damage
   - Verify serial number matches order
   - Confirm configuration (processor, memory via label)

3. **Documentation:**
   - Record serial number and service tag
   - Note iLO default credentials (usually on pull-out tag)
   - Register warranty with HPE

### Physical Installation

**For 6U Portable Rack:**

1. **Install Rack Rails:**
   - Attach rack rails to portable case mounting holes
   - Server mounts at 1U height (leaves 5U for network equipment)

2. **Slide Server into Rack:**
   - Align server with rails
   - Push firmly until latches engage
   - Secure with thumbscrews

3. **Cable Management:**
   - Connect power cable (leave slack for removal)
   - Connect network cables to eno1 (and eno2 if used)
   - Connect iLO management cable (separate from production network recommended)
   - Use cable management arm if provided

4. **Verify Mounting:**
   - Ensure server is level and secure
   - Test sliding in/out for maintenance access

### First Power-On

1. **Pre-Power Checks:**
   - [ ] All cables connected
   - [ ] Power supply voltage selector correct (if applicable)
   - [ ] Network switch powered on
   - [ ] UPS powered on (if used)

2. **Power On Server:**
   - Press power button (front panel)
   - Observe POST (Power-On Self Test)
   - Listen for abnormal beeps or fan noise

3. **Initial Boot Sequence:**
   - HP logo appears
   - Memory test (can be disabled in BIOS)
   - Storage controller initialization
   - Network adapter initialization
   - Boot device selection

4. **Access iLO:**
   - From another computer on same network
   - Navigate to iLO IP address (check DHCP lease or use label)
   - Default credentials: Administrator / [on label]
   - Change default password immediately

---

## BIOS Configuration

### Access BIOS Setup

1. **During POST:**
   - Press **F9** when prompted ("Press F9 for System Utilities")
   - Or **F10** for Intelligent Provisioning

2. **Via iLO (Remote):**
   - Log into iLO web interface
   - Select "Virtual Media" → "Launch Remote Console"
   - Power on server or reset
   - Press F9 during POST

### Required BIOS Settings for CyberHygiene

**System Configuration → Boot Options:**
- **Boot Mode:** UEFI (required for FIPS)
- **Legacy Support:** Disabled
- **Secure Boot:** Disabled (can enable post-OS install)
- **Boot Order:**
  1. NVMe SSD (or first hard drive)
  2. USB (for installation media)
  3. Network Boot (disabled)

**System Configuration → BIOS/Platform Configuration (RBSU):**
- **Processor Options:**
  - Intel Virtualization Technology (VT-x): Enabled
  - Intel VT-d (IOMMU): Enabled
  - Hyper-Threading: Enabled
- **Memory Options:**
  - ECC Memory: Enabled (should be automatic with ECC DIMMs)
  - Memory Patrol Scrubbing: Enabled

**Security → System Security:**
- **TPM State:** Enabled
- **TPM Mode:** FIPS (if option available)
- **Asset Tag Protection:** Set asset tag for tracking
- **Server Configuration Lock:** Disabled (for now)

**Security → Administrator Password:**
- **Set BIOS Administrator Password:** (Required)
  - Choose strong password (20+ characters)
  - Document in secure location
  - Prevents unauthorized BIOS changes

**Power Management:**
- **HP Power Profile:** Maximum Performance (for consistent performance)
- **Collaborative Power Control:** Enabled (allows OS to manage power)
- **Redundant Power Supply Mode:** N/A (if single PSU)

**Date and Time:**
- Set correct date and time
- Timezone will be set in OS

### Save and Exit

1. **Save Changes:**
   - Press **F10** or select "Save and Exit"
   - Confirm changes

2. **Reboot:**
   - Server will reboot with new settings

---

## Hardware Compatibility

### Operating System Compatibility

**Supported Operating Systems:**
- Red Hat Enterprise Linux 8.x, 9.x ✓
- Rocky Linux 8.x, 9.x ✓ (CyberHygiene target)
- CentOS Stream 8, 9 ✓
- Ubuntu Server 20.04, 22.04 LTS ✓
- Windows Server 2019, 2022 ✓

**Driver Support:**
- All hardware components have in-kernel Linux drivers
- No proprietary drivers required for Rocky Linux 9
- HPE provides SPP (Service Pack for ProLiant) for firmware updates

### Storage Compatibility

**NVMe SSD Compatibility:**
- Any M.2 2280 form factor NVMe SSD
- PCIe Gen3 x4 interface
- Recommended brands: Samsung, Intel, Micron, WD

**SATA SSD Compatibility:**
- 2.5" SATA III (6 Gb/s)
- Hot-plug capable
- Recommended brands: Samsung, Crucial, Intel

**FIPS-Certified Storage:**
For FIPS compliance, use self-encrypting drives (SEDs):
- Samsung PM1733/PM1735 (NVMe, FIPS 140-2)
- Micron 7450 (NVMe, FIPS 140-3)
- **Note:** LUKS software encryption is adequate for Phase II

### Memory Compatibility

**Approved Memory:**
- HPE SmartMemory (recommended, validated by HPE)
- Third-party ECC UDIMMs (Kingston, Crucial, Samsung)
  - Must be DDR4-2933 or DDR4-2666
  - Must be ECC (non-ECC will not provide data integrity)

**Verification:**
- Use HPE QuickSpecs tool to verify compatibility
- Check HPE Support website for qualified memory list

---

## Troubleshooting

### Common Issues

**Issue 1: Server Won't Power On**
- **Symptoms:** No lights, no fans
- **Causes:**
  - Power cable not connected
  - Power supply failure
  - Main power switch off (rear of server)
- **Solutions:**
  - Verify power cable connected to both server and outlet
  - Check rear power switch (I/O position)
  - Try different power outlet
  - Check iLO logs for power events

**Issue 2: Server Powers On But No Display**
- **Symptoms:** Fans run, but no video output
- **Causes:**
  - No monitor connected
  - Memory not seated properly
  - BIOS corruption
- **Solutions:**
  - Connect VGA monitor to rear port
  - Reseat all memory DIMMs
  - Clear CMOS (remove battery for 30 seconds)
  - Access via iLO remote console

**Issue 3: Memory Errors During POST**
- **Symptoms:** Beeps, POST error code 1xx
- **Causes:**
  - Faulty DIMM
  - Incompatible memory
  - Improper installation
- **Solutions:**
  - Reseat all DIMMs
  - Test DIMMs one at a time to isolate failure
  - Verify DIMMs are ECC and correct speed
  - Replace faulty DIMM

**Issue 4: Storage Not Detected**
- **Symptoms:** "No bootable device" error
- **Causes:**
  - Drive not installed or connected
  - BIOS set to wrong boot mode
  - Faulty drive
- **Solutions:**
  - Verify drive installation (NVMe or SATA)
  - Check BIOS boot mode (must be UEFI)
  - Check BIOS boot order
  - Test drive in another system

**Issue 5: iLO Not Accessible**
- **Symptoms:** Can't reach iLO web interface
- **Causes:**
  - Network cable not connected to iLO port
  - iLO DHCP not getting address
  - Wrong network/VLAN
- **Solutions:**
  - Verify network cable in dedicated iLO port (rightmost)
  - Check DHCP server for iLO lease
  - Use F9 BIOS → Network Options → iLO Configuration to set static IP
  - Reset iLO to defaults (pinhole button on rear)

**Issue 6: High Fan Noise**
- **Symptoms:** Fans running at 100%
- **Causes:**
  - High CPU temperature
  - Fan failure
  - iLO detecting thermal event
- **Solutions:**
  - Check ambient temperature (should be < 35°C / 95°F)
  - Verify all fans spinning
  - Check for dust accumulation
  - Review iLO thermal logs

### Diagnostic Tools

**Built-in Diagnostics:**
1. **System Utilities (F9 during POST):**
   - Embedded Diagnostics
   - Memory test
   - Storage test
   - Network test

2. **Intelligent Provisioning (F10 during POST):**
   - System information
   - Firmware updates
   - Support dump

3. **iLO Web Interface:**
   - Hardware status (fans, temperature, power)
   - Event logs (IML - Integrated Management Log)
   - System information

**External Diagnostics:**
- HPE Support Pack for ProLiant (SPP) - Bootable USB with diagnostics
- Linux: `dmidecode`, `lshw`, `hwinfo` commands

### Support Resources

**HPE Support:**
- Website: support.hpe.com
- Phone: 1-800-HP-INVENT (1-800-474-6836)
- Chat: Available via support website
- Case Number: Required for warranty claims

**Warranty Lookup:**
- Enter serial number at support.hpe.com
- Verify warranty status before contact

**Spare Parts:**
- Order via HPE Parts Surfer (partsurfer.hpe.com)
- Common spares: Power supply, fans, memory, drives

---

## Maintenance

### Regular Maintenance Tasks

**Weekly:**
- Check iLO event logs for errors
- Verify all fans operational
- Check temperature readings

**Monthly:**
- Review firmware versions
- Check for security advisories
- Inspect physical connections

**Quarterly:**
- Update firmware (BIOS, iLO, storage controller)
- Clean dust from air intakes
- Verify backup procedures working

**Annually:**
- Full system diagnostics
- Replace thermal compound (if temperatures rising)
- Review warranty status

### Firmware Updates

**Recommended Firmware Sources:**
- HPE Support website (support.hpe.com)
- Service Pack for ProLiant (SPP) - Quarterly releases

**Update Procedure:**
1. Download latest SPP ISO
2. Create bootable USB or mount via iLO virtual media
3. Boot to SPP
4. Select "Update Firmware"
5. Review available updates
6. Apply updates (requires reboot)

**Update Order:**
1. iLO firmware
2. System ROM (BIOS)
3. Storage controller firmware
4. Network adapter firmware

---

## Physical Security

### Rack Security

**6U Portable Rack:**
- Locking front and rear doors (use high-quality lock)
- Cable lock anchor points
- Tamper-evident seals for transport

**Server Security Features:**
- Hood lock (prevents opening server cover)
- TPM for hardware-verified boot
- BIOS password prevents unauthorized changes

### Environmental Requirements

**Temperature:**
- Operating: 10°C to 35°C (50°F to 95°F)
- Non-operating: -30°C to 60°C (-22°F to 140°F)
- Recommended: 20-25°C (68-77°F) for optimal reliability

**Humidity:**
- Operating: 8% to 90% non-condensing
- Non-operating: 5% to 95% non-condensing

**Altitude:**
- Operating: 0 to 3,000 m (10,000 ft)
- Non-operating: 0 to 9,000 m (30,000 ft)

**Shock and Vibration:**
- Designed for office environment
- Portable rack provides protection during transport
- Use shock-absorbing materials when transporting

---

## Appendices

### Appendix A: Quick Specifications

| Specification | Value |
|---------------|-------|
| **Form Factor** | 1U rack mount (short depth) |
| **Processor** | Intel Xeon E-2300 series (4-8 cores) |
| **Memory** | Up to 128 GB DDR4-2933 ECC |
| **Storage** | NVMe (M.2) + 2x 2.5" SATA hot-plug |
| **Network** | Dual 1 GbE (Intel i350) |
| **Management** | iLO 5 (Standard or Advanced) |
| **Power** | 290W or 500W (single or redundant) |
| **Dimensions** | 1.7" H x 17.09" W x 15.05" D |
| **Weight** | ~20 lbs (9 kg) |
| **Warranty** | 3-year standard (up to 5-year available) |

### Appendix B: Useful BIOS Keys

| Key | Function |
|-----|----------|
| F9 | System Utilities (BIOS setup) |
| F10 | Intelligent Provisioning |
| F11 | Boot Menu |
| F12 | Network Boot |
| ESC | Boot order selection |

### Appendix C: LED Indicators

**Front Panel:**
- **UID (Blue):** Unit Identification (can activate remotely via iLO)
- **Power (Green):** System powered on
- **Health (Amber/Green):** System health status
- **NIC1/NIC2 (Green):** Network activity

**Health LED Codes:**
- Solid Green: OK
- Flashing Green: iLO initializing
- Solid Amber: Degraded (check iLO)
- Flashing Amber: Critical (check iLO)

---

**Document Version:** 1.0
**Last Updated:** January 1, 2026
**File Location:** `/home/admin/Documents/Installer/hp_dl20_hardware_specifications.md`
