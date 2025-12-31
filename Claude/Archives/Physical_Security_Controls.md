# PHYSICAL SECURITY CONTROLS DOCUMENTATION
**Organization:** The Contract Coach (Donald E. Shannon LLC)
**System:** CyberHygiene Production Network (cyberinabox.net)
**Facility:** 5338 La Colonia Drive N.W., Albuquerque, NM 87120
**Version:** 1.0
**Effective Date:** November 1, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)

**NIST Controls:** PE-1, PE-2, PE-3, PE-4, PE-5, PE-6, PE-8, PE-12, PE-13, PE-14, PE-15, PE-16, PE-17

---

## DOCUMENT CONTROL

| Name / Title | Role | Signature / Date |
|---|---|---|
| Donald E. Shannon<br>Owner/Principal | System Owner | _____________________<br>Date: _______________ |
| Donald E. Shannon<br>Owner/Principal | Facility Security Officer | _____________________<br>Date: _______________ |

**Review Schedule:** Annually or upon facility changes
**Next Review Date:** November 1, 2026

---

## 1. FACILITY OVERVIEW

### 1.1 Facility Description
**Type:** Home-based office/data center
**Address:** 5338 La Colonia Drive N.W., Albuquerque, NM 87120
**Square Footage:** Dedicated office space within residential property
**Occupancy:** Single occupant (Owner/Principal)
**Hours of Operation:** Variable (home-based business)

### 1.2 Security Zones

**Zone 1: Public Areas**
- Front entrance and common areas
- No CUI processing or storage
- General residential security measures

**Zone 2: Secure Office/Data Center (Single Room)**
- Dedicated locked office room for all business operations
- **All equipment located in this single room:**
  - Locking server rack containing:
    - Domain controller (dc1)
    - Synology NAS (DataStore)
    - Netgate pfSense router/firewall
    - Network switches
    - Workstation CPUs (ws1, ws2, ws3)
  - Monitors, keyboards, peripherals (outside rack)
  - Backup media storage (inside rack)
- CUI processing and storage
- Room locked when unoccupied
- Server rack locked at all times (additional layer of security)

---

## 2. PHYSICAL ACCESS CONTROLS (PE-2, PE-3)

### 2.1 Perimeter Security

**Residential Property Boundaries:**
- Defined property lines with fencing
- Front door with deadbolt lock
- Garage doors with automatic openers
- Security doors on all exterior access points
- Motion-sensor exterior lighting

**Access Points:**
- Front entrance: Keyed deadbolt lock
- Garage entrance: Electronic opener + keypad
- All windows: Secured with locks
- Sliding doors: Security bar when not in use

### 2.2 Interior Access Controls

**Secure Office/Data Center Room (Zone 2):**
- **Room-Level Security:**
  - Dedicated office room with locking door
  - Key control by owner only
  - Locked when not in use
  - Sign indicating "Private Office - Authorized Personnel Only"
  - No visitor access without escort

- **Server Rack Security (Additional Layer):**
  - Locking server rack housing all critical equipment
  - Key or combination lock (single authorized person)
  - All servers, network equipment, and workstation CPUs secured inside rack
  - Rack locked at all times, even when room occupied
  - Backup media stored inside locked rack
  - Cable management prevents unauthorized physical access

**Dual-Layer Protection:**
```
Layer 1: Locked office room (access control to room)
Layer 2: Locked server rack (access control to equipment)
```

**Key Control:**
- Office room key: Controlled by Donald E. Shannon only
- Server rack key/combination: Controlled by Donald E. Shannon only
- No spare keys provided to third parties
- Keys stored securely when not in use
- Lock changes upon any security concern
- Separate keys for room and rack (defense in depth)

### 2.3 Access Authorization

**Authorized Personnel:**
1. Donald E. Shannon (Owner/Principal) - Full access to all zones

**Visitor Policy:**
- Visitors generally not permitted in secure office (Zone 2)
- Any visitors must be escorted at all times
- Visitors log maintained (if necessary)
- Visitors do not have unescorted access to CUI systems
- Screen lock activated before admitting visitors to office
- Server rack remains locked when visitors present

**Maintenance/Service Personnel:**
- HVAC, electrical, plumbing: Escorted at all times
- Systems physically secured before technician access
- Server rack locked at all times (technicians never access rack)
- Screens locked, CUI documents secured
- Monitor technician activities
- Verify identification before entry

### 2.4 Physical Access Monitoring (PE-6)

**Monitoring Methods:**
- Owner visual monitoring (home-based)
- Residential alarm system (if equipped)
- Motion sensor lighting on exterior
- Periodic security walks during business hours

**Access Logs:**
For significant events:
- Date and time of access
- Person accessing facility
- Purpose of access
- Duration of visit
- Any anomalies observed

**Incident Reporting:**
- Unauthorized access attempts reported immediately
- Physical security incidents documented
- Law enforcement contacted for significant breaches
- Incident Response Plan activated as appropriate

---

## 3. PHYSICAL SECURITY SAFEGUARDS (PE-5)

### 3.1 Equipment Protection

**Server Equipment (dc1.cyberinabox.net):**
- Located in dedicated secure room/cabinet
- Rack-mounted or secured in locked cabinet
- Power cables secured and protected
- Cable management prevents tampering
- Equipment serialized and inventoried

**Workstations:**
- Located in office area (Zone 2)
- Cable locks when left unattended
- Secured to desk when possible
- Screen lock activated (<5 minutes idle)
- Powered off or locked when leaving facility

**Network Equipment:**
- pfSense firewall in secure equipment room
- Network switches in locked cabinet or room
- Cables organized and secured
- Physical access restricted

**Backup Media:**
- USB drives stored in locked drawer or safe
- External backup drives in locked cabinet
- Offsite backup media in secure location (safe deposit box or secure off-site)
- Media labeled with date, not system details

**Portable Devices:**
- Laptops secured with cable locks when unattended
- Full disk encryption (LUKS) on all portable devices
- Devices not left in vehicles
- Secure storage when traveling

### 3.2 Output Device Protection (PE-5)

**Printers:**
- Located in secure office area
- Not visible from windows
- Output retrieved immediately
- Sensitive documents shredded after use
- No network-accessible printers with unencrypted storage

**Displays/Monitors:**
- Privacy screens on monitors handling CUI
- Monitors positioned away from windows
- Automatic screen lock after 5 minutes
- Screens blanked when visitors present

**Mobile Devices:**
- Auto-lock enabled (< 5 minutes)
- Full device encryption required
- Screen guards for shoulder surfing protection
- No CUI stored on personal mobile devices

---

## 4. ENVIRONMENTAL CONTROLS (PE-14, PE-15)

### 4.1 Temperature and Humidity

**HVAC System:**
- Residential climate control system operational
- Temperature maintained: 65-75°F
- Humidity maintained: 30-50% relative humidity
- Regular HVAC maintenance schedule
- Air filters changed quarterly

**Equipment Room Monitoring:**
- Temperature monitoring (visual checks daily)
- Adequate ventilation for equipment
- Equipment not in enclosed spaces without airflow
- Warning signs of overheating monitored

### 4.2 Power Protection (PE-11)

**Power Supply:**
- Dedicated electrical circuits for server equipment
- Surge protectors on all equipment
- Uninterruptible Power Supply (UPS) for dc1 server
  - Battery backup: Minimum 15 minutes runtime
  - Graceful shutdown scripts configured
  - Monthly UPS self-test
  - Annual battery replacement
  - Surge and spike protection

**Power Considerations:**
- UPS allows clean shutdown during outages
- Server configured for automatic startup after power restoration
- Critical data saved to encrypted partitions
- Backup generators not required (acceptable risk for home office)

### 4.3 Fire Protection (PE-13)

**Fire Suppression:**
- Smoke detectors installed per building code
- Fire extinguisher (ABC-rated) located in equipment area
- Inspected annually
- Quick access to fire extinguisher
- Emergency egress routes clear

**Fire Prevention:**
- No smoking in facility
- Flammable materials stored away from equipment
- Electrical cords in good condition, not overloaded
- Equipment room kept free of debris
- Regular inspection for fire hazards

**Fire Response:**
- Dial 911 immediately
- Evacuate per residential fire plan
- Do not attempt to fight large fires
- Fire department contact: Albuquerque Fire Department (911)

### 4.4 Water Damage Protection (PE-15)

**Water Leak Prevention:**
- Equipment not located near plumbing
- Equipment elevated off floor
- No overhead water pipes above equipment
- Regular inspection for leaks
- Rapid response to any water intrusion

**Water Damage Response:**
- Immediately power down affected equipment
- Move equipment to dry location if safe
- Document damage for insurance
- Restore from backups if equipment damaged
- Replace equipment as needed

---

## 5. EQUIPMENT DISPOSAL AND REUSE (PE-18)

### 5.1 Media Sanitization

**Hard Drives and SSDs:**
Method: DOD 5220.22-M 7-pass wipe OR physical destruction
```bash
# Software wipe (7-pass)
sudo shred -vfz -n 7 /dev/sdX

# Verification
sudo dd if=/dev/sdX bs=1M count=100 | hexdump -C
```

**Physical Destruction (preferred for CUI drives):**
- Remove drives from equipment
- Drill multiple holes through platters
- Use degausser if available
- Physically crush or shred drive
- Document destruction (date, drive serial, method)

**Solid State Drives (SSDs):**
- Encrypt drive, destroy encryption keys
- Physical destruction (shred or crush)
- SSD-specific secure erase if manufacturer provides
- Do not rely solely on software wipes for CUI data

**USB Drives and Media:**
- Software wipe with overwrite tools
- Physical destruction for CUI media
- Document disposition

### 5.2 Equipment Disposal

**Computer Equipment:**
- Remove all hard drives before disposal
- Sanitize remaining components (memory wiped)
- Remove all identification labels/stickers
- Recycle through certified e-waste recycler
- Obtain certificate of destruction if available

**Documentation:**
- Maintain disposal log
- Record: Date, equipment type, serial number, disposal method
- Certificate of destruction (if applicable)
- Authorized by: Donald E. Shannon

### 5.3 Equipment Reuse

**Internal Reuse:**
- Wipe and reimage with clean OS
- Verify no residual CUI data
- Update inventory records
- Document sanitization performed

**External Transfer/Sale:**
- NOT PERMITTED for equipment that has processed CUI
- All CUI-processing equipment destroyed or permanently retained

---

## 6. DELIVERY AND REMOVAL (PE-16)

### 6.1 Equipment Delivery

**Receiving Procedures:**
- Verify expected delivery (PO number, tracking info)
- Inspect for tampering or damage
- Document delivery (date, time, contents, condition)
- Verify serial numbers match purchase order
- Photograph any damage
- Inspect packaging for evidence of compromise

**Unpackaging:**
- Unpack in controlled area
- Inspect for unauthorized modifications
- Verify firmware versions and settings
- Scan for malware before deployment
- Update inventory records

### 6.2 Equipment Removal

**Authorized Removal:**
- Equipment removal requires owner approval
- Document: Date, time, equipment, destination, purpose
- Escort equipment during transport if CUI data present
- Verify data sanitization before removal
- Update inventory upon removal

**Unauthorized Removal:**
- Report immediately to owner
- Contact law enforcement if theft suspected
- Document incident per Incident Response Plan
- Assess data exposure risk
- Revoke cryptographic keys if device encrypted

---

## 7. ALTERNATE WORK SITES (PE-17)

### 7.1 Remote Work Policy

**General Policy:**
As a home-based business, the primary facility IS the work site. However, occasional work from alternate locations (travel, client sites) may occur.

**Requirements for Remote Work:**
- Full disk encryption (LUKS) on all portable devices
- VPN required for network access (when deployed)
- Physical security of devices maintained
- Screen privacy filters on laptops
- Auto-lock enabled (<5 minutes)
- No CUI processing on public Wi-Fi without VPN
- Secure storage of portable devices when traveling

**Prohibited Locations:**
- Public spaces with no physical security (coffee shops)
- Hotels without safe for equipment storage
- Any location where devices cannot be secured
- Locations with poor physical security

**Client Site Work:**
- Verify client site security adequate
- Use privacy screens
- Lock laptop when stepping away
- No CUI data left on client systems
- Secure transport of equipment and media

---

## 8. VISITOR ACCESS (PE-2, PE-3, PE-8)

### 8.1 Visitor Policy

**General Policy:**
Visitors are generally not permitted in secure areas (Zones 2 and 3). When necessary:

**Authorization:**
- All visitors require owner pre-approval
- Business purpose documented
- Escort required at all times
- No unescorted access to Zone 2 (secure office)
- Server rack remains locked at all times when visitors present

**Visitor Procedures:**
1. Verify visitor identity (photo ID)
2. Document visit (date, name, company, purpose)
3. Provide visitor badge or notation if recurring
4. Escort to meeting area only
5. Secure screens and CUI documents before visitor entry
6. Lock server rack (if not already locked)
7. Monitor visitor activities at all times
8. Escort visitor out of facility
9. Verify no materials removed without authorization

**Visitor Log Template:**
```
Date: __________
Name: ____________________
Company: ____________________
Photo ID Verified: [ ] Yes [ ] No
Purpose: ____________________
Areas Accessed: [ ] Zone 1 [ ] Zone 2 (Secure Office)
Server Rack Access: [ ] No (locked)
Time In: ______ Time Out: ______
Escorted By: Donald E. Shannon
Notes: ____________________
```

### 8.2 Maintenance Personnel

**HVAC/Electrical/Plumbing Technicians:**
- Schedule maintenance during business hours when possible
- Verify technician credentials and company
- Escort at all times in secure areas
- Lock all screens before technician entry
- Secure CUI documents and media
- Visual monitoring of activities
- Verify work completed as expected
- Document visit in maintenance log

---

## 9. EMERGENCY PROCEDURES

### 9.1 Emergency Response

**Fire:**
1. Evacuate immediately
2. Call 911
3. Do not re-enter to save equipment
4. Account for all personnel (self)
5. Notify fire department if CUI materials present

**Medical Emergency:**
1. Call 911 immediately
2. Provide first aid if trained
3. Secure facility if possible before leaving
4. Document incident

**Natural Disaster (Earthquake, Flood, Severe Weather):**
1. Ensure personal safety first
2. Protect equipment if time permits (cover, elevate)
3. Evacuate if instructed
4. Document damage upon return
5. Activate disaster recovery procedures if needed

**Active Shooter/Intruder:**
1. Run, Hide, Fight (last resort)
2. Call 911 when safe
3. Do not confront intruder
4. Secure room and barricade if safe
5. Follow law enforcement instructions

### 9.2 Emergency Contacts

**Emergency Services:** 911

**Albuquerque Fire Department:** 505-764-6300
**Albuquerque Police Department:** 505-242-COPS (2677)
**Poison Control:** 1-800-222-1222

**Utility Companies:**
- Electric: PNM 1-888-342-5766
- Gas: NM Gas Company 1-888-664-2726
- Water: Albuquerque Water Authority 505-842-9290

**Owner Contact:**
Donald E. Shannon: 505-259-8485

### 9.3 Facility Recovery

**Post-Emergency Assessment:**
- Ensure facility safe to enter
- Document all damage with photographs
- Assess impact to equipment and data
- Contact insurance provider if applicable
- Initiate disaster recovery procedures
- Restore from backups if needed
- File incident report

---

## 10. PHYSICAL SECURITY AWARENESS

### 10.1 Security Reminders

**Daily Practices:**
- Lock doors when leaving office area
- Lock screens when stepping away (< 5 minutes auto-lock)
- Secure CUI documents when not in use
- Verify doors/windows locked at end of day
- Report suspicious activity immediately
- Challenge unknown persons in secure areas

**Secure Work Habits:**
- Clean desk policy - no CUI left on desks
- Shred sensitive documents before disposal
- Lock file cabinets containing CUI
- Use privacy screens on monitors
- Position monitors away from windows
- Secure backup media in locked storage

### 10.2 Security Inspections

**Daily Checks:**
- Verify doors locked when arriving/departing
- Check for signs of tampering or intrusion
- Verify equipment powered on/operating normally
- Check environmental conditions (temperature, leaks)

**Weekly Checks:**
- Inspect locks and access controls
- Review physical security logs (if incidents)
- Verify fire extinguisher accessible
- Check UPS status and battery

**Monthly Checks:**
- Test smoke detectors
- Inspect fire extinguisher gauge
- Review visitor logs (if any)
- Inspect facility for security improvements

**Annual Checks:**
- Comprehensive security assessment
- Test all emergency procedures
- Fire extinguisher inspection (professional)
- UPS battery replacement evaluation
- Update physical security documentation

---

## 11. DOCUMENTATION AND RECORDS

### 11.1 Required Documentation

**Maintained Records:**
- Visitor logs (if visitors present)
- Maintenance logs for HVAC, electrical, fire equipment
- Equipment inventory with serial numbers and locations
- Disposal records for sanitized media and equipment
- Physical security incident reports
- Emergency response drill records
- UPS test and maintenance records

**Record Retention:**
- Physical security records: 3 years
- Equipment disposal records: 7 years
- Incident reports: 7 years
- Maintenance records: 3 years

### 11.2 Equipment Inventory

| Equipment | Serial Number | Location | Acquisition Date | Disposition |
|---|---|---|---|---|
| Server (dc1) | ____________ | Zone 2 - Server Rack | __________ | Active |
| Synology NAS (DataStore) | ____________ | Zone 2 - Server Rack | __________ | Active |
| Workstation CPU (ws1) | ____________ | Zone 2 - Server Rack | __________ | Active |
| Workstation CPU (ws2) | ____________ | Zone 2 - Server Rack | __________ | Active |
| Workstation CPU (ws3) | ____________ | Zone 2 - Server Rack | __________ | Active |
| pfSense Router | ____________ | Zone 2 - Server Rack | __________ | Active |
| Network Switch | ____________ | Zone 2 - Server Rack | __________ | Active |
| UPS | ____________ | Zone 2 - Server Rack | __________ | Active |
| RAID Array (3x3TB) | ____________ | Zone 2 - Server Rack | __________ | Active |
| Monitor (ws1) | ____________ | Zone 2 - Desk | __________ | Active |
| Monitor (ws2) | ____________ | Zone 2 - Desk | __________ | Active |
| Monitor (ws3) | ____________ | Zone 2 - Desk | __________ | Active |
| Keyboard/Mouse | ____________ | Zone 2 - Desk | __________ | Active |
|  |  |  |  |  |

---

## 12. COMPLIANCE VERIFICATION

### 12.1 Control Implementation Checklist

| Control | Requirement | Implementation | Status |
|---|---|---|---|
| PE-1 | Physical and environmental protection policy | This document | ✓ |
| PE-2 | Physical access authorizations | Owner only, visitor escort | ✓ |
| PE-3 | Physical access control | Locks on all secure areas | ✓ |
| PE-4 | Access control for transmission | N/A - no external transmission medium | N/A |
| PE-5 | Access control for output devices | Printer secured, screens protected | ✓ |
| PE-6 | Monitoring physical access | Owner monitoring, logs maintained | ✓ |
| PE-8 | Visitor access records | Visitor log template created | ✓ |
| PE-11 | Emergency power | UPS on server equipment | ✓ |
| PE-12 | Emergency lighting | Residential lighting adequate | ✓ |
| PE-13 | Fire protection | Smoke detectors, fire extinguisher | ✓ |
| PE-14 | Temperature and humidity controls | HVAC system operational | ✓ |
| PE-15 | Water damage protection | Equipment protected from water | ✓ |
| PE-16 | Delivery and removal | Procedures documented | ✓ |
| PE-17 | Alternate work site | Requirements documented | ✓ |
| PE-18 | Location of system components | Documented in inventory | ✓ |

### 12.2 Annual Review

**Next Review Date:** November 1, 2026

**Review Checklist:**
- [ ] Verify all access controls functional
- [ ] Update equipment inventory
- [ ] Review visitor logs (if any)
- [ ] Inspect physical security measures
- [ ] Test emergency equipment (smoke detectors, UPS)
- [ ] Review and update procedures as needed
- [ ] Document review completion

---

## APPENDIX A: FACILITY DIAGRAM

```
┌────────────────────────────────────────────────────────┐
│  RESIDENCE - 5338 La Colonia Drive NW                  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  ZONE 1: PUBLIC/COMMON AREAS                     │  │
│  │  - Entry                                         │  │
│  │  - Common areas                                  │  │
│  │  No CUI processing                               │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  ZONE 2: SECURE OFFICE/DATA CENTER [LOCKED]     │  │
│  │                                                  │  │
│  │  LOCKING SERVER RACK (Inside Room):             │  │
│  │  ┌─────────────────────────────────────────┐   │  │
│  │  │ - Domain controller (dc1)               │   │  │
│  │  │ - Synology NAS (DataStore)              │   │  │
│  │  │ - pfSense router/firewall               │   │  │
│  │  │ - Network switch                        │   │  │
│  │  │ - Workstation CPUs (ws1, ws2, ws3)      │   │  │
│  │  │ - RAID array (5.5TB)                    │   │  │
│  │  │ - UPS                                   │   │  │
│  │  │ - Backup media storage                  │   │  │
│  │  └─────────────────────────────────────────┘   │  │
│  │  [RACK LOCKED 24/7]                             │  │
│  │                                                  │  │
│  │  OUTSIDE RACK (Inside Room):                    │  │
│  │  - Monitors (ws1, ws2, ws3)                     │  │
│  │  - Keyboards/mice                               │  │
│  │  - Desk and work surfaces                       │  │
│  │  - File cabinets (locked)                       │  │
│  │  - Printer                                      │  │
│  │                                                  │  │
│  │  CUI Processing and Storage                     │  │
│  │  Access: Owner only - Room locked when vacant   │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
```

---

## APPENDIX B: SECURITY INSPECTION CHECKLIST

**Inspection Date:** ___________________
**Inspector:** Donald E. Shannon

### Physical Barriers
- [ ] All exterior doors locked and functional
- [ ] Office room door locked when unoccupied
- [ ] Server rack locked at all times
- [ ] Windows secured
- [ ] No signs of forced entry or tampering

### Access Controls
- [ ] Office room key accounted for and secure
- [ ] Server rack key/combination secure
- [ ] Locks functional
- [ ] No unauthorized access observed
- [ ] Visitor procedures followed (if applicable)

### Equipment Security
- [ ] All equipment accounted for per inventory
- [ ] Equipment properly secured
- [ ] Cables organized and protected
- [ ] No unauthorized devices connected
- [ ] Serial numbers match inventory

### Environmental Controls
- [ ] Temperature within acceptable range (65-75°F)
- [ ] HVAC system operational
- [ ] No water leaks or damage
- [ ] Adequate ventilation
- [ ] Fire extinguisher accessible and charged

### Emergency Equipment
- [ ] Smoke detectors functional (test button)
- [ ] Fire extinguisher gauge in green
- [ ] UPS operational (check LEDs)
- [ ] Emergency exits clear
- [ ] Lighting functional

### Clean Desk/Work Area
- [ ] No CUI documents left unsecured
- [ ] Screens locked when unattended
- [ ] File cabinets locked
- [ ] Backup media secured
- [ ] Shredder functional

### Issues Identified:
_________________________________________________________________
_________________________________________________________________

### Corrective Actions:
_________________________________________________________________
_________________________________________________________________

**Inspection Complete:** ___________________

---

**END OF PHYSICAL SECURITY CONTROLS DOCUMENTATION**
