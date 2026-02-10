# Chapter 2: CyberHygiene Project Overview

## 2.1 Project Background

**CyberHygiene Production Network** is an enterprise-grade, NIST 800-171 compliant cybersecurity platform designed specifically for small businesses and government contractors who handle Controlled Unclassified Information (CUI).

**Project Origin:**
- Developed to address the compliance gap for small organizations
- Response to increasing cybersecurity requirements in government contracting
- Built using open-source enterprise security tools
- Enhanced with AI-powered assistance and automation

**Target Audience:**
- Small businesses (1-50 employees)
- Government contractors requiring NIST 800-171 compliance
- Organizations handling CUI or sensitive data
- Businesses seeking enterprise security without enterprise costs

## 2.2 Mission and Objectives

**Mission Statement:**
*"To provide small businesses and government contractors with affordable, enterprise-grade cybersecurity that meets federal compliance requirements while remaining practical and manageable."*

**Primary Objectives:**

1. **Compliance Achievement**
   - Full NIST 800-171 compliance (110 controls)
   - FIPS 140-2 cryptographic standards
   - Auditable security controls
   - Continuous compliance monitoring

2. **Security Excellence**
   - Defense-in-depth architecture
   - Real-time threat detection and response
   - Comprehensive logging and monitoring
   - Automated security updates

3. **Operational Simplicity**
   - User-friendly dashboards
   - Local AI assistant for guidance
   - Automated routine tasks
   - Clear documentation

4. **Cost Effectiveness**
   - Open-source core components
   - Efficient resource utilization
   - Reduced administrative overhead
   - Scalable architecture

## 2.3 Key Features and Capabilities

### Security Infrastructure

**Identity and Access Management:**
- Centralized authentication (FreeIPA)
- Kerberos single sign-on (SSO)
- Multi-factor authentication (MFA)
- Role-based access control (RBAC)
- Automated account lifecycle management

**Network Security:**
- Intrusion Detection/Prevention System (Suricata)
- Real-time traffic analysis
- Threat intelligence integration
- Automated blocking of malicious traffic
- SSL/TLS inspection capabilities

**Endpoint Security:**
- YARA malware detection
- ClamAV antivirus integration
- File integrity monitoring (AIDE)
- Automated threat response
- Quarantine capabilities

**Security Monitoring:**
- Wazuh SIEM (Security Information and Event Management)
- Real-time alert correlation
- Compliance monitoring dashboards
- Automated incident detection
- Forensic investigation tools

### Monitoring and Visibility

**System Health Monitoring:**
- Prometheus metrics collection
- Grafana visualization dashboards
- Real-time performance metrics
- Capacity planning data
- Predictive alerting

**Available Dashboards:**
1. **CPM Dashboard** - Overall compliance and system status
2. **Wazuh SIEM** - Security events and threat analysis
3. **Grafana Dashboards**:
   - Node Exporter Full (system resources)
   - Suricata IDS/IPS (network security)
   - YARA Malware Detection (endpoint threats)
4. **Graylog** - Centralized log analysis

**Monitoring Coverage:**
- 7 active monitoring targets
- 100% uptime tracking
- Real-time alerting
- Historical trend analysis

### AI Enhancement

**Local AI Assistant (Code Llama):**
- Air-gapped Mac Mini M4 server (192.168.1.7)
- Open-source Code Llama language model
- No internet connectivity (NIST 800-171 compliant)
- Interactive CLI tools and web interface
- Available 24/7 on local network
- Human-in-the-loop workflow

**AI Capabilities:**
- Natural language system queries
- Log analysis and pattern recognition
- Security alert interpretation
- Troubleshooting assistance
- Configuration guidance
- Command syntax help

### Data Protection

**Backup and Recovery:**
- Automated daily backups
- Encrypted backup storage
- Off-site backup replication
- Point-in-time recovery
- Disaster recovery procedures
- Regular recovery testing

**Encryption:**
- FIPS 140-2 validated cryptography
- Full disk encryption
- Encrypted communications (TLS 1.3)
- Encrypted backups
- Key management infrastructure

## 2.4 Phase I Achievements

**Status:** Phase I Complete (December 2025)

### POA&M Completion: 100%

**All 29 Control Items Implemented:**
- Access Control (AC): 6 items ✅
- Awareness and Training (AT): 1 item ✅
- Audit and Accountability (AU): 4 items ✅
- Configuration Management (CM): 2 items ✅
- Identification and Authentication (IA): 4 items ✅
- Incident Response (IR): 2 items ✅
- Maintenance (MA): 1 item ✅
- Media Protection (MP): 2 items ✅
- Physical Protection (PE): 1 item ✅
- Risk Assessment (RA): 2 items ✅
- System and Communications Protection (SC): 3 items ✅
- System and Information Integrity (SI): 1 item ✅

**NIST 800-171 Compliance:** 110/110 controls (100%)

### Infrastructure Deployment

**7 Production Systems:**
1. **dc1.cyberinabox.net** - Domain Controller
   - FreeIPA identity management
   - DNS and DHCP services
   - Certificate authority
   - Kerberos KDC

2. **dms.cyberinabox.net** - Document Management Server
   - File sharing (Samba/NFS)
   - Document storage
   - Backup repository

3. **graylog.cyberinabox.net** - Log Management
   - Centralized logging
   - Log analysis
   - SIEM integration

4. **proxy.cyberinabox.net** - Web Proxy
   - HTTP/HTTPS proxy
   - Content filtering
   - SSL inspection

5. **monitoring.cyberinabox.net** - Monitoring Server
   - Prometheus metrics
   - Grafana dashboards
   - Alert management

6. **wazuh.cyberinabox.net** - Security Monitoring
   - SIEM platform
   - Security analytics
   - Compliance dashboards

7. **Mac Mini M4 (192.168.1.7)** - AI Assistant Server
   - Code Llama language model
   - Ollama inference service
   - AnythingLLM web interface
   - Air-gapped (no internet access)

### Monitoring Deployment

**7 Active Monitoring Targets:**
- All systems: 100% UP status
- Node Exporter on all 6 systems
- Suricata exporter (proxy system)
- Comprehensive metrics coverage
- Zero downtime deployment

### Security Hardening

**Implemented Controls:**
- FIPS 140-2 mode enabled system-wide
- SELinux enforcing mode
- Automated security updates
- Firewall hardening (firewalld)
- SSH hardening with MFA
- Account lockout policies
- Password complexity enforcement
- Audit logging (auditd)
- File integrity monitoring (AIDE)

### Dashboard Implementation

**Operational Dashboards:**
- ✅ CPM Compliance Dashboard
- ✅ Wazuh Security Monitoring
- ✅ Grafana System Health (3 dashboards)
- ✅ Graylog Log Analysis
- ✅ Prometheus Metrics Backend

**Current Metrics:**
- 8.8M packets processed (Suricata)
- 4.8 GB data analyzed
- 502 security alerts detected
- 0 malware detections (clean system)
- 56,274 TLS flows (encrypted traffic)

## 2.5 System Benefits

### For Organizations

**Compliance Confidence:**
- Pre-built NIST 800-171 compliance
- Documented security controls
- Audit-ready evidence collection
- Continuous compliance monitoring
- Regular compliance reporting

**Risk Reduction:**
- Multi-layered security defense
- Real-time threat detection
- Automated incident response
- Comprehensive audit logging
- Disaster recovery capability

**Cost Savings:**
- Open-source components (no licensing fees)
- Automated administration
- Reduced manual effort
- Efficient resource utilization
- Lower compliance costs

**Competitive Advantage:**
- Meet government contracting requirements
- Handle CUI with confidence
- Demonstrate security commitment
- Win more contracts
- Build customer trust

### For Users

**Ease of Use:**
- Single sign-on (SSO) across services
- Self-service password reset
- Clear documentation
- Local AI assistant for help
- Intuitive dashboards

**Productivity:**
- Secure remote access
- File sharing and collaboration
- Fast, reliable services
- Minimal security friction
- 24/7 availability

**Security:**
- Protected credentials (Kerberos)
- Multi-factor authentication
- Encrypted communications
- Automatic malware protection
- Privacy preservation

### For Administrators

**Simplified Management:**
- Centralized user management (FreeIPA)
- Automated provisioning
- Unified monitoring dashboards
- Local AI-assisted troubleshooting
- Comprehensive documentation

**Visibility:**
- Real-time system health
- Security event tracking
- Compliance status
- Performance metrics
- Audit trail

**Automation:**
- Automated backups
- Security updates
- Alert notifications
- Threat response
- Report generation

**Support:**
- Detailed operational procedures
- Local AI assistant (Code Llama)
- Troubleshooting guides
- Quick reference cards
- Active documentation

---

**Project Statistics:**

| Metric | Value |
|--------|-------|
| **POA&M Completion** | 100% (29/29 items) |
| **NIST 800-171 Controls** | 110/110 implemented |
| **Systems Deployed** | 7 production servers |
| **Monitoring Targets** | 7 active (100% UP) |
| **Security Dashboards** | 6 operational |
| **Documentation Files** | 150+ consolidated |
| **Uptime** | 99.9% availability |
| **Security Alerts** | 502 detected, 0 incidents |
| **Malware Detections** | 0 (clean environment) |
| **Phase I Duration** | 6 months (Jul-Dec 2025) |

---

## 2.6 Development Tools vs. Production Systems

This manual documents the **production environment** of the CyberHygiene Production Network. It is important to understand the distinction between development tools and production systems:

### Production AI System

**Mac Mini M4 with Code Llama:**
- **Purpose:** Operational AI assistant for production use
- **Location:** 192.168.1.7 (local network only)
- **Model:** Open-source Code Llama via Ollama
- **Connectivity:** Air-gapped, no internet access
- **Compliance:** NIST 800-171 compliant
- **Availability:** 24/7 for administrators and authorized users
- **Documentation:** See Chapter 15 for complete usage guide

### Development Tools (Not Part of Production)

**Claude Code:**
- **Purpose:** Development and documentation creation tool only
- **Usage Period:** Phase I development (Jul-Dec 2025)
- **Status:** Will be disabled when system enters production
- **Reason for Exclusion:** Requires internet connectivity to Anthropic's servers (not FedRAMP approved)
- **Security Concern:** Cannot be used with CUI/FCI data
- **Note:** Claude Code was instrumental in creating this documentation and developing the system architecture, but is not part of the operational environment

**Other Development Tools:**
- Traditional IDEs, code editors, and development utilities
- Used only during system development and maintenance
- Never connected to production CUI/FCI data
- Disabled or isolated when system is operational

### Why This Distinction Matters

**Compliance Requirements:**
NIST 800-171 requires that all systems processing, storing, or transmitting CUI must meet strict security controls. Internet-connected AI systems like Claude Code cannot meet these requirements because they:
- Transmit data to external servers
- Operate outside the security boundary
- Are not FedRAMP authorized
- Cannot provide air-gapped operation

**Operational Security:**
The production AI system (Code Llama on Mac Mini M4) was specifically designed to:
- Operate completely air-gapped
- Process queries without internet connectivity
- Maintain human-in-the-loop control
- Provide audit trails for administrative actions
- Meet all NIST 800-171 security controls

**Documentation Note:**
Throughout this manual, references to "AI assistant" or "AI system" refer to the **production Code Llama system** unless specifically noted otherwise. Any historical references to development tools have been updated or clarified.

---

**Related Chapters:**
- Chapter 3: System Architecture
- Chapter 4: Security Baseline Summary
- Chapter 16: CPM Dashboard Overview
- Chapter 41: POA&M Status

**For More Information:**
- Project Website: https://cyberhygiene.cyberinabox.net
- NIST 800-171: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final
