# Chapter 39: Demo Unit Overview & Architecture

**Part IX: Trade Show Operations**

---

## 39.1 Introduction

The CyberHygiene Portable Demo Unit is a self-contained, trade-show-ready demonstration environment that showcases the full capabilities of the CyberHygiene Production Network in a compact, transportable form factor.

### Purpose

This portable demonstration unit serves multiple strategic objectives:

- **Lead Generation:** Showcase CyberHygiene capabilities at trade shows, conferences, and prospect meetings
- **Sales Enablement:** Provide hands-on, interactive demonstrations of security features
- **Proof of Concept:** Demonstrate NIST 800-171 compliance and security controls in real-time
- **Scalability Demonstration:** Show how the architecture scales from small business (5-15 employees) to enterprise (500+)
- **Brand Visibility:** Professional, impressive display of technical capabilities

### Design Philosophy

The demo unit adheres to the following principles:

1. **Authentic Replication:** Mirrors production environment architecture and capabilities
2. **Air-Gapped by Default:** Maintains NIST 800-171 compliance demonstration without venue dependencies
3. **Self-Contained:** No external internet required for core demonstrations
4. **Rapid Deployment:** 30-minute setup, 20-minute teardown
5. **Interactive:** Live attack simulations, real-time monitoring, AI assistant interaction
6. **Professional Appearance:** Silent operation, clean cabling, impressive visual presentation

---

## 39.2 Hardware Architecture

### Overview

The demo unit consists of a 3-node Mac Mini M4 cluster running 8 virtualized servers, replicating the production 7-server architecture plus an attacker simulation VM.

### Hardware Components

#### Compute Infrastructure

**3x Mac Mini M4 (16GB RAM, 256GB SSD)**

- **Model:** Mac Mini M4 (Late 2024)
- **Processor:** Apple M4 chip (10-core CPU, 10-core GPU)
- **Memory:** 16GB unified memory
- **Storage:** 256GB SSD
- **Power:** 15W idle, 50W peak per unit
- **Dimensions:** 7.7" × 7.7" × 1.4" (19.7cm × 19.7cm × 3.6cm)
- **Weight:** 1.5 lbs (670g) per unit

**Role Assignment:**
- **Mini #1 "Infrastructure Server":** dc1-demo, proxy-demo, ai-demo
- **Mini #2 "Security Server":** wazuh-demo, graylog-demo
- **Mini #3 "Services Server":** monitoring-demo, dms-demo, attacker-demo

#### Networking Equipment

**TP-Link TL-SG108E 8-Port Managed Switch**
- 8× Gigabit Ethernet ports
- VLAN support (demo network isolation)
- Fanless (silent operation)
- Compact form factor (6.2" × 3.9" × 1")

**GL.iNet GL-AXT1800 Travel Router**
- Dual-band WiFi 6 (optional venue connectivity)
- 4× Gigabit Ethernet LAN ports
- VPN client/server capabilities
- Compact travel design

**UniFi 6 Lite Access Point**
- WiFi 6 (802.11ax) support
- Dual-band concurrent operation
- PoE powered (simplifies cabling)
- Used for attendee device connectivity (optional)

#### Presentation Equipment

**ASUS MB16ACV 24" Portable Monitor**
- 1920×1080 Full HD resolution
- USB-C powered (single cable from Mac Mini)
- Lightweight (1.9 lbs)
- Foldable stand for easy transport

**Logitech MK270 Wireless Keyboard/Mouse Combo**
- 2.4GHz wireless (reliable, no Bluetooth pairing)
- Compact keyboard with numeric keypad
- Long battery life (24 months)

#### Transport & Protection

**Pelican 1610 Case with Foam Insert**
- Dimensions: 25.62" × 20.62" × 13.87"
- Watertight, crushproof, dustproof
- Pressure equalization valve
- Custom foam cutouts for all equipment
- TSA-approved locks
- Wheels and retractable handle

**Weight Distribution:**
- 3× Mac Mini M4: 4.5 lbs
- Networking equipment: 3 lbs
- Monitor, keyboard, cables: 5 lbs
- Case: 22 lbs (empty)
- **Total Travel Weight:** ~35 lbs (meets carry-on requirements for most airlines)

### Hardware Budget

| Item | Quantity | Unit Price | Total |
|------|----------|------------|-------|
| Mac Mini M4 (16GB/256GB) | 3 | $599 | $1,797 |
| TP-Link TL-SG108E Switch | 1 | $80 | $80 |
| GL.iNet GL-AXT1800 Router | 1 | $130 | $130 |
| UniFi 6 Lite AP | 1 | $99 | $99 |
| ASUS MB16ACV Monitor | 1 | $250 | $250 |
| Logitech MK270 Keyboard/Mouse | 1 | $50 | $50 |
| Pelican 1610 Case | 1 | $150 | $150 |
| Cables & Power Strips | 1 | $150 | $150 |
| **TOTAL HARDWARE** | | | **$2,706** |

### Power Requirements

**Total Power Consumption:**
- 3× Mac Mini M4 (peak): 150W
- Switch + Router + AP: 30W
- Monitor: 15W
- **Total Peak Draw:** ~195W

**Power Distribution:**
- 1× 6-outlet surge protector power strip
- Requires single 120V/15A outlet at venue
- UPS battery backup optional (APC Back-UPS 600VA, +$75)

### Physical Footprint

**Booth/Table Space Required:**
- Width: 36" (3 Mac Minis side-by-side with spacing)
- Depth: 18" (monitor stand + Mac Minis)
- Height: 24" (monitor on stand)
- **Minimum Table:** 4' × 2' standard trade show table

---

## 39.3 Virtual Machine Distribution

### VM Architecture Overview

The demo unit runs 8 Rocky Linux 9.3 ARM64 virtual machines distributed across the 3 Mac Mini M4 hosts using UTM virtualization (Apple Virtualization.framework).

### Mac Mini #1: Infrastructure Server

**Total RAM Allocated:** 14GB (2GB reserved for macOS host)

#### dc1-demo (FreeIPA Identity Management)
- **RAM:** 4GB
- **vCPU:** 2 cores
- **Storage:** 30GB virtual disk
- **IP Address:** 10.42.42.10
- **Services:** FreeIPA, DNS, Kerberos, LDAP
- **Role:** Centralized identity and authentication

#### proxy-demo (Network Security Gateway)
- **RAM:** 4GB
- **vCPU:** 2 cores
- **Storage:** 40GB virtual disk
- **IP Address:** 10.42.42.40
- **Services:** Suricata IDS/IPS, firewall
- **Role:** Network threat detection and prevention

#### ai-demo (AI Assistant)
- **RAM:** 6GB
- **vCPU:** 3 cores
- **Storage:** 60GB virtual disk
- **IP Address:** 10.42.42.7
- **Services:** Ollama, Code Llama 13B model, AnythingLLM
- **Role:** NIST 800-171 compliant AI assistant

### Mac Mini #2: Security Server

**Total RAM Allocated:** 14GB (2GB reserved for macOS host)

#### wazuh-demo (SIEM & XDR Platform)
- **RAM:** 8GB
- **vCPU:** 4 cores
- **Storage:** 80GB virtual disk
- **IP Address:** 10.42.42.60
- **Services:** Wazuh Manager, Elasticsearch, Kibana
- **Role:** Security information and event management

#### graylog-demo (Log Management)
- **RAM:** 6GB
- **vCPU:** 3 cores
- **Storage:** 60GB virtual disk
- **IP Address:** 10.42.42.30
- **Services:** Graylog, MongoDB, Elasticsearch
- **Role:** Centralized log aggregation and analysis

### Mac Mini #3: Services Server

**Total RAM Allocated:** 12GB (4GB reserved for macOS host)

#### monitoring-demo (System Monitoring)
- **RAM:** 4GB
- **vCPU:** 2 cores
- **Storage:** 40GB virtual disk
- **IP Address:** 10.42.42.50
- **Services:** Prometheus, Grafana, Node Exporter
- **Role:** System health and performance monitoring

#### dms-demo (File Sharing)
- **RAM:** 4GB
- **vCPU:** 2 cores
- **Storage:** 40GB virtual disk
- **IP Address:** 10.42.42.20
- **Services:** Samba, NFS
- **Role:** Document management and file sharing

#### attacker-demo (Attack Simulation)
- **RAM:** 4GB
- **vCPU:** 2 cores
- **Storage:** 40GB virtual disk
- **IP Address:** 10.42.42.100
- **Services:** Kali Linux tools, custom attack scripts
- **Role:** Controlled attack demonstrations

### VM Resource Summary

| VM | RAM | vCPU | Storage | Host |
|----|-----|------|---------|------|
| dc1-demo | 4GB | 2 | 30GB | Mini #1 |
| proxy-demo | 4GB | 2 | 40GB | Mini #1 |
| ai-demo | 6GB | 3 | 60GB | Mini #1 |
| wazuh-demo | 8GB | 4 | 80GB | Mini #2 |
| graylog-demo | 6GB | 3 | 60GB | Mini #2 |
| monitoring-demo | 4GB | 2 | 40GB | Mini #3 |
| dms-demo | 4GB | 2 | 40GB | Mini #3 |
| attacker-demo | 4GB | 2 | 40GB | Mini #3 |
| **TOTAL** | **40GB** | **20** | **390GB** | All |

---

## 39.4 Network Topology

### Demo Network Design

The demo unit uses an isolated `10.42.42.0/24` network, air-gapped by default with optional venue connectivity.

```
┌─────────────────────────────────────────────────────────────┐
│                   Demo Network 10.42.42.0/24                 │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Mac Mini #1 │  │  Mac Mini #2 │  │  Mac Mini #3 │       │
│  │Infrastructure│  │   Security   │  │   Services   │       │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘       │
│         │                 │                 │               │
│         └─────────────────┴─────────────────┘               │
│                         │                                   │
│                ┌────────┴────────┐                          │
│                │  TL-SG108E      │                          │
│                │  8-Port Switch  │                          │
│                └────────┬────────┘                          │
│                         │                                   │
│         ┌───────────────┼───────────────┐                  │
│         │               │               │                  │
│   ┌─────┴─────┐   ┌────┴────┐    ┌─────┴─────┐            │
│   │GL-AXT1800 │   │UniFi AP │    │  Monitor  │            │
│   │  Router   │   │ (WiFi6) │    │ (Display) │            │
│   └─────┬─────┘   └─────────┘    └───────────┘            │
│         │                                                   │
│         │ (Optional)                                       │
│    Venue WiFi/Ethernet                                     │
└─────────┴───────────────────────────────────────────────────┘
```

### IP Address Allocation

| System | IP Address | Services | Port(s) |
|--------|------------|----------|---------|
| dc1-demo | 10.42.42.10 | FreeIPA Web UI | 443 |
| | | DNS | 53 |
| | | Kerberos | 88, 464, 749 |
| | | LDAP | 389, 636 |
| dms-demo | 10.42.42.20 | Samba | 139, 445 |
| | | NFS | 2049 |
| graylog-demo | 10.42.42.30 | Graylog Web UI | 9000 |
| | | Syslog | 514, 5140 |
| proxy-demo | 10.42.42.40 | Suricata | - |
| | | HTTP Proxy | 3128 |
| monitoring-demo | 10.42.42.50 | Grafana | 3000 |
| | | Prometheus | 9090 |
| wazuh-demo | 10.42.42.60 | Wazuh Dashboard | 443 |
| | | Wazuh API | 55000 |
| ai-demo | 10.42.42.7 | AnythingLLM | 3001 |
| | | Ollama API | 11434 |
| attacker-demo | 10.42.42.100 | Attack scripts | - |
| GL-AXT1800 Router | 10.42.42.1 | Gateway | - |

### Network Segmentation

**VLAN 10: Demo Production Network**
- All 8 VMs
- Default network for demonstrations
- Air-gapped (no external routing)

**VLAN 20: Attendee WiFi (Optional)**
- UniFi AP broadcasts "CyberHygiene-Demo" SSID
- Isolated from demo network (firewall rules)
- Used for prospect devices viewing dashboards
- Optional internet access via venue WiFi bridge

### Firewall Rules

**Default Deny All, Allow by Exception:**

```
# Allow all traffic within demo network
allow from 10.42.42.0/24 to 10.42.42.0/24

# Allow attendee WiFi to specific demo dashboards only
allow from VLAN20 to 10.42.42.50:3000  # Grafana
allow from VLAN20 to 10.42.42.60:443   # Wazuh
allow from VLAN20 to 10.42.42.7:3001   # AnythingLLM
deny from VLAN20 to 10.42.42.0/24      # Block all other

# Block attacker-demo from production (safety)
deny from 10.42.42.100 to 192.168.1.0/24

# Optional: Allow outbound for software updates
allow from 10.42.42.10 to any port 80,443  # dc1 only
```

---

## 39.5 Comparison: Demo vs. Production

### Architectural Differences

| Aspect | Production Network | Demo Unit |
|--------|-------------------|-----------|
| **Servers** | 7 physical servers | 3 Mac Minis (8 VMs) |
| **Network** | 192.168.1.0/24 | 10.42.42.0/24 |
| **Power** | Dedicated 120V circuits | Single outlet |
| **Internet** | Fiber 1Gbps | Air-gapped (offline) |
| **Storage** | 3.5TB RAID arrays | 390GB virtual disks |
| **Footprint** | Server rack (42U) | 36" × 18" table space |
| **Weight** | ~500 lbs | 35 lbs (portable) |
| **Setup Time** | Weeks (permanent) | 30 minutes |

### Capability Parity

The demo unit replicates the following production capabilities:

✅ **Security Monitoring:**
- Real-time threat detection (Suricata IDS/IPS)
- SIEM correlation and alerting (Wazuh)
- Log aggregation and analysis (Graylog)

✅ **Compliance:**
- 100% NIST 800-171 compliance demonstration
- Automated compliance reporting (CPM dashboard)
- Audit log collection and retention

✅ **Identity Management:**
- Centralized authentication (FreeIPA/Kerberos)
- Role-based access control (RBAC)
- Multi-factor authentication (OTP)

✅ **Monitoring & Observability:**
- System health dashboards (Grafana)
- Performance metrics (Prometheus)
- Real-time alerting

✅ **AI Assistant:**
- Natural language queries (Code Llama)
- Log analysis and threat interpretation
- NIST 800-171 compliant (air-gapped)

### Demo-Specific Enhancements

The demo unit includes features NOT in production:

➕ **attacker-demo VM:** Controlled attack simulations for live demonstrations
➕ **Optimized Dashboards:** 24" display-optimized layouts for trade show visibility
➕ **Low-Threshold Alerts:** Instant detection feedback for demonstration purposes
➕ **Scripted Attack Scenarios:** Repeatable, timing-controlled demonstrations
➕ **ROI Calculator:** Interactive tool for prospect cost comparisons

---

## 39.6 Design Rationale

### Why Mac Mini M4 Cluster?

**Advantages:**
1. **Proven Platform:** Already deployed Mac Mini M4 AI server in production (192.168.1.7)
2. **Performance:** Apple M4 chip delivers server-class performance in compact form
3. **Silent Operation:** Fanless/silent critical for trade show booth environments
4. **Low Power:** 15W idle × 3 = 45W (single outlet sufficient)
5. **Professional Appearance:** Sleek, modern design impresses prospects
6. **Portability:** 1.5 lbs each, total system <35 lbs
7. **Reliability:** Solid-state design, no moving parts (except fans on load)

**Alternatives Considered:**
- ❌ **Single NUC:** Single point of failure, less visually impressive
- ❌ **Laptop-based:** Unprofessional appearance, thermal constraints
- ❌ **Cloud Demo:** Requires venue internet, latency, violates air-gap demo
- ❌ **Rack-mount Servers:** Too heavy, requires dolly, power-hungry

### Why UTM Virtualization?

**Advantages:**
1. **Native macOS:** Uses Apple Virtualization.framework (optimized for M4)
2. **ARM64 Support:** Rocky Linux ARM64 fully supported
3. **No Kernel Extensions:** Secure boot compatible, no system modifications
4. **Free & Open Source:** No licensing costs
5. **Familiar:** Already used for Mac Mini M4 AI server deployment

**Alternatives Considered:**
- ❌ **VMware Fusion:** Licensing costs, x86-64 emulation overhead
- ❌ **Parallels Desktop:** Consumer-focused, not ideal for servers
- ❌ **Docker:** Not suitable for full OS demonstrations

### Why 10.42.42.0/24 Network?

**Rationale:**
1. **Distinct from Production:** 192.168.1.x used in production (avoids confusion)
2. **Easy to Remember:** "42" memorable for operators (Hitchhiker's Guide reference)
3. **RFC 1918 Private:** Standard private address space
4. **No Venue Conflicts:** Unlikely to conflict with venue networks

### Why Air-Gapped Design?

**Rationale:**
1. **Compliance Demo:** Demonstrates NIST 800-171 air-gap architecture
2. **Venue Independence:** No reliance on venue internet (unreliable at events)
3. **Security:** No exposure of demo environment to public networks
4. **Offline Capability:** Full functionality without connectivity

**Optional Connectivity:**
- Venue WiFi bridge available for software updates, external demos
- Firewall rules prevent VM exposure
- Operator-controlled (not automatic)

---

## 39.7 Use Cases

### Trade Shows & Conferences

**Ideal Events:**
- RSA Conference
- Black Hat USA
- DEF CON
- GovSec (government security)
- CMMC Summit (DoD contractors)
- Regional CPA conferences (accounting firms)
- HIMSS (healthcare IT)

**Booth Setup:**
- 10' × 10' standard booth
- Demo unit on 4' table
- Monitor at eye level for standing attendees
- Operator stationed behind table
- Marketing materials rack adjacent

### Prospect Meetings

**On-Site Demonstrations:**
- Bring demo unit to prospect's office
- Conference room table setup
- 30-minute presentation + 15-minute Q&A
- Leave-behind marketing materials

**Ideal Prospects:**
- DoD contractors requiring CMMC compliance
- Government agencies needing NIST 800-171
- Healthcare organizations (HIPAA + security)
- Financial services (SOC 2, PCI-DSS)

### Webinars & Virtual Events

**Remote Demonstrations:**
- Operator runs demo from office
- Screen share Grafana, Wazuh, AnythingLLM dashboards
- Live attack simulations
- Recording for on-demand viewing

### Training & Enablement

**Sales Team Training:**
- Hands-on demo practice sessions
- Attack scenario walkthroughs
- Dashboard navigation training
- Objection handling preparation

**Partner Enablement:**
- VAR/reseller training
- Co-marketing opportunities
- Joint demonstrations at partner events

---

## 39.8 Success Metrics

### Technical KPIs

- **Setup Time:** Target 30 minutes (measure at each event)
- **Uptime:** 100% during event hours (no crashes or reboots)
- **Attack Success Rate:** 100% of scripted attacks detected and displayed
- **Dashboard Responsiveness:** <2 second load times for all dashboards

### Business KPIs

- **Leads Generated:** Target 3 qualified leads per event (conservative)
- **Lead Conversion:** 25% close rate (industry average for qualified leads)
- **Revenue Impact:** $40K average contract × 3 leads × 25% = $30K per event
- **ROI:** $30K revenue / $2,706 hardware = 1,009% ROI (single event)

### Attendee Engagement

- **Demo Duration:** Average 15 minutes per prospect
- **Follow-Up Requests:** >50% request follow-up meeting/call
- **Satisfaction:** >4.0/5.0 average rating (post-demo survey)
- **Repeat Visitors:** Prospects return with colleagues/executives

---

## 39.9 Next Steps

For detailed operational procedures, see:

- **Chapter 40:** Setup & Teardown Procedures (30-minute deployment process)
- **Chapter 41:** Demo Scenarios & Scripts (interactive demonstrations)
- **Chapter 42:** Demo Unit Maintenance & Troubleshooting (field support)

For technical implementation details, see:

- **Appendix G:** UTM VM Creation Procedure (Rocky Linux ARM64)
- **Appendix H:** Demo Attack Scripts Reference
- **Appendix I:** Demo Dashboard Configuration

---

**Document Version:** 1.0
**Last Updated:** January 1, 2026
**Part of:** CyberHygiene User Manual v1.1.0 (Phase II)
**Status:** Draft - Implementation in Progress
