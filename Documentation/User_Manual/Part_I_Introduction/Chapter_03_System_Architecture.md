# Chapter 3: System Architecture

## 3.1 Network Topology

### Network Overview

The CyberHygiene Production Network consists of 7 production servers deployed in a secure, segmented architecture:

```
Internet
   |
   v
[Firewall/Router] (192.168.1.1)
   |
   +------ [Internal Network: 192.168.1.0/24]
           |
           +-- dc1.cyberinabox.net (192.168.1.10)
           |   Domain Controller, DNS, Certificate Authority
           |
           +-- dms.cyberinabox.net (192.168.1.20)
           |   Document Management, File Sharing
           |
           +-- graylog.cyberinabox.net (192.168.1.30)
           |   Log Management, SIEM Integration
           |
           +-- proxy.cyberinabox.net (192.168.1.40)
           |   Web Proxy, Content Filtering, Suricata IDS
           |
           +-- monitoring.cyberinabox.net (192.168.1.50)
           |   Prometheus, Grafana, Alerting
           |
           +-- wazuh.cyberinabox.net (192.168.1.60)
           |   SIEM, Security Monitoring, Compliance
           |
           +-- Mac Mini M4 (192.168.1.7)
               AI Assistant, Code Llama, AnythingLLM (Air-gapped)
```

### Network Segmentation

**Single Trusted Zone:**
- All production servers on 192.168.1.0/24
- Internal traffic trusted (Kerberos authenticated)
- Firewall protects entire network perimeter
- No DMZ required (all services internal or proxied)

**External Access:**
- HTTPS only (ports 443, 3001, 9091)
- TLS 1.3 encryption required
- Certificate-based authentication
- Rate limiting enabled

### DNS Configuration

**Internal DNS (dc1):**
- cyberinabox.net domain
- All internal hostnames
- Reverse DNS configured
- DNSSEC enabled

**External DNS:**
- Public records point to external IP
- Web services accessible externally
- SSH access enabled (port 22)

## 3.2 Core Components

### 1. Domain Controller (dc1.cyberinabox.net)

**Primary Functions:**
- Identity and Access Management (FreeIPA)
- DNS and DHCP services
- Kerberos Key Distribution Center (KDC)
- Certificate Authority (CA)
- LDAP directory services
- NTP time synchronization

**Key Services:**
- FreeIPA: Identity management
- BIND: DNS server
- ISC DHCP: Network addressing
- Kerberos: Single sign-on
- Dogtag CA: Certificate issuance
- 389 Directory Server: LDAP

**Specifications:**
- OS: Rocky Linux 9.5 (FIPS mode)
- CPU: 4 cores
- Memory: 8 GB RAM
- Storage: 100 GB system, 500 GB data
- Network: 1 Gbps

### 2. Document Management Server (dms.cyberinabox.net)

**Primary Functions:**
- File sharing (Samba/NFS)
- Document storage
- Backup repository
- User home directories
- Shared workspaces

**Key Services:**
- Samba: Windows-compatible file sharing
- NFS: Unix file sharing
- Kerberos integration: Secure authentication
- Backup agent: rsync/borg

**Specifications:**
- OS: Rocky Linux 9.5 (FIPS mode)
- CPU: 4 cores
- Memory: 8 GB RAM
- Storage: 100 GB system, 2 TB data (/datastore)
- Network: 1 Gbps

### 3. Log Management (graylog.cyberinabox.net)

**Primary Functions:**
- Centralized log collection
- Log parsing and indexing
- Search and analysis
- SIEM integration
- Compliance logging

**Key Services:**
- Graylog Server: Log management
- Elasticsearch: Log indexing and search
- MongoDB: Metadata storage
- Rsyslog: Log collection

**Specifications:**
- OS: Rocky Linux 9.5 (FIPS mode)
- CPU: 4 cores
- Memory: 16 GB RAM (Elasticsearch intensive)
- Storage: 100 GB system, 1 TB logs
- Network: 1 Gbps

### 4. Web Proxy (proxy.cyberinabox.net)

**Primary Functions:**
- HTTP/HTTPS proxying
- Content filtering
- SSL/TLS inspection
- Intrusion detection (Suricata)
- Network security monitoring

**Key Services:**
- Squid: Web proxy
- Suricata: IDS/IPS
- YARA: Malware detection
- ClamAV: Antivirus scanning

**Specifications:**
- OS: Rocky Linux 9.5 (FIPS mode)
- CPU: 6 cores (IDS processing)
- Memory: 16 GB RAM
- Storage: 100 GB system, 500 GB logs
- Network: 1 Gbps (high throughput)

**Monitoring Metrics:**
- 8.8M packets processed
- 4.8 GB data analyzed
- 56,274 TLS flows
- 104,233 DNS queries
- 502 security alerts

### 5. Monitoring Server (monitoring.cyberinabox.net)

**Primary Functions:**
- Metrics collection (Prometheus)
- Visualization (Grafana)
- Alert management
- Performance monitoring
- Capacity planning

**Key Services:**
- Prometheus: Metrics database
- Grafana: Dashboard visualization
- Alertmanager: Alert routing
- Node Exporter: System metrics (on all hosts)

**Specifications:**
- OS: Rocky Linux 9.5 (FIPS mode)
- CPU: 4 cores
- Memory: 8 GB RAM
- Storage: 100 GB system, 500 GB metrics
- Network: 1 Gbps

**Monitoring Targets:**
- 7 active targets (100% UP)
- 6 Node Exporters (one per server)
- 1 Suricata Exporter (proxy)
- Metrics retention: 15 days

### 6. Security Monitoring (wazuh.cyberinabox.net)

**Primary Functions:**
- Security Information and Event Management (SIEM)
- Security event correlation
- Compliance monitoring
- Threat detection
- Incident investigation

**Key Services:**
- Wazuh Manager: Security orchestration
- Wazuh Indexer: Event storage (OpenSearch)
- Wazuh Dashboard: Web interface
- Wazuh Agents: Endpoint monitoring (on all hosts)

**Specifications:**
- OS: Rocky Linux 9.5 (FIPS mode)
- CPU: 4 cores
- Memory: 8 GB RAM
- Storage: 100 GB system, 1 TB events
- Network: 1 Gbps

**Monitored Events:**
- File integrity monitoring (FIM)
- Log analysis
- Rootkit detection
- Vulnerability scanning
- Compliance checks (NIST 800-171)

### 7. AI Assistant Server (Mac Mini M4)

**Primary Functions:**
- Local AI assistant (Code Llama)
- Natural language query processing
- Log analysis assistance
- Troubleshooting guidance
- Security alert interpretation
- Configuration help

**Key Services:**
- Ollama: AI inference engine
- Code Llama: Open-source language model
- AnythingLLM: Web-based UI
- Custom CLI tools: llama, ai, ask-ai, ai-analyze-wazuh

**Specifications:**
- Hardware: Mac Mini M4
- CPU: Apple Silicon M4
- Memory: 16 GB RAM
- Storage: 512 GB SSD
- Network: 1 Gbps (local network only)

**Security Configuration:**
- Air-gapped (no internet connectivity)
- Local network access only (192.168.1.0/24)
- No access to CUI/FCI data
- Human-in-the-loop workflow required
- NIST 800-171 compliant architecture

**Available Models:**
- Code Llama 7B (default)
- Code Llama 13B (available)
- Code Llama 34B (available)
- Model selection based on query complexity

## 3.3 Security Infrastructure

### Defense-in-Depth Layers

**Layer 1: Network Perimeter**
- Hardware firewall/router
- Stateful packet inspection
- Port-based access control
- DDoS protection
- External IP filtering

**Layer 2: Host Firewall**
- firewalld on all systems
- Default-deny policy
- Service-specific rules
- Zone-based security
- Rate limiting

**Layer 3: Network Security Monitoring**
- Suricata IDS/IPS
- Real-time traffic analysis
- Threat intelligence feeds
- Automated threat blocking
- Alert correlation

**Layer 4: Identity and Access Control**
- FreeIPA identity management
- Kerberos authentication
- Multi-factor authentication (MFA)
- Role-based access control (RBAC)
- Least privilege principle

**Layer 5: Endpoint Security**
- Wazuh agent on all systems
- File integrity monitoring (AIDE)
- YARA malware detection
- ClamAV antivirus
- Automated threat response

**Layer 6: Encryption**
- FIPS 140-2 cryptography
- TLS 1.3 for all communications
- Full disk encryption (LUKS)
- Encrypted backups
- Certificate-based authentication

**Layer 7: Monitoring and Logging**
- Comprehensive audit logging (auditd)
- Centralized log management (Graylog)
- Security event correlation (Wazuh)
- Real-time alerting
- Compliance monitoring

### Authentication Flow

```
User Login Attempt
    |
    v
[FreeIPA] -- Validates credentials
    |
    v
[Kerberos KDC] -- Issues ticket-granting ticket (TGT)
    |
    v
[Service Request] -- User requests service access
    |
    v
[Kerberos KDC] -- Issues service ticket
    |
    v
[Service] -- Validates ticket, grants access
    |
    v
[Audit Log] -- Records access event
```

**Security Features:**
- Password complexity enforcement
- Account lockout after failed attempts
- MFA for privileged access
- Session timeout (8 hours)
- Ticket renewal limits

### Certificate Infrastructure

**Certificate Authority (CA):**
- FreeIPA integrated CA (Dogtag)
- Internal PKI for all services
- Automated certificate issuance
- 90-day certificate lifetime
- Auto-renewal 30 days before expiry

**Certificate Uses:**
- HTTPS (web services)
- LDAPS (directory services)
- SSH (host keys)
- Email (S/MIME)
- Code signing

## 3.4 Monitoring Architecture

### Metrics Collection Flow

```
[Systems] -- Node Exporter (port 9100)
    |
    v
[Prometheus] -- Scrapes metrics every 15s
    |
    v
[Grafana] -- Visualizes data
    |
    v
[Alertmanager] -- Sends alerts
    |
    v
[Email/Webhook] -- Notifies admins
```

### Security Event Flow

```
[Systems] -- Generate logs/events
    |
    +-- [Auditd] -- System audit events
    |
    +-- [Application Logs] -- Service logs
    |
    v
[Wazuh Agent] -- Collects and analyzes
    |
    v
[Wazuh Manager] -- Correlates events
    |
    v
[Wazuh Indexer] -- Stores events
    |
    v
[Wazuh Dashboard] -- Displays alerts
```

### Log Collection Flow

```
[Systems] -- Generate logs
    |
    v
[Rsyslog] -- Forwards to Graylog
    |
    v
[Graylog] -- Receives logs (port 514/1514)
    |
    v
[Elasticsearch] -- Indexes logs
    |
    v
[Graylog Web] -- Search and analysis
```

### Dashboard Architecture

**Available Dashboards:**

1. **CPM Dashboard** (https://cpm.cyberinabox.net)
   - System overview
   - Compliance status
   - Service health
   - Quick access links

2. **Wazuh Dashboard** (https://wazuh.cyberinabox.net)
   - Security events
   - Threat detection
   - Compliance monitoring
   - Incident investigation

3. **Grafana Dashboards** (https://grafana.cyberinabox.net)
   - Node Exporter Full (system resources)
   - Suricata IDS/IPS (network security)
   - YARA Malware Detection (endpoint threats)

4. **Graylog Dashboard** (https://graylog.cyberinabox.net)
   - Log search
   - Event analysis
   - Custom queries
   - Alert configuration

## 3.5 Integration Points

### FreeIPA Integration

**Integrated Services:**
- SSH (public key distribution)
- Sudo (privilege management)
- Samba (file sharing authentication)
- Web applications (LDAP authentication)
- Email (user accounts)

**Benefits:**
- Single user database
- Centralized password management
- Automatic home directory creation
- Group-based access control
- Unified policy enforcement

### Kerberos Integration

**Services Using Kerberos:**
- SSH (GSSAPI authentication)
- HTTP (SPNEGO for web SSO)
- NFS (secure file sharing)
- LDAP (secure directory access)
- SMTP (email authentication)

**Benefits:**
- Single sign-on (SSO)
- Password-less authentication
- Mutual authentication
- Encrypted communications
- Replay attack protection

### Monitoring Integration

**Prometheus Data Sources:**
- Node Exporter (all systems)
- Suricata Exporter (proxy)
- Custom exporters (application metrics)

**Grafana Data Sources:**
- Prometheus (primary)
- Elasticsearch (Graylog logs)
- MySQL (application databases)

**Wazuh Integrations:**
- YARA (malware detection)
- ClamAV (antivirus)
- AIDE (file integrity)
- Suricata (network IDS)
- Auditd (system auditing)

### AI Assistant Integration

**Code Llama Features:**
- Documentation queries via natural language
- Troubleshooting assistance and diagnostics
- Configuration syntax help
- Security alert interpretation
- Log analysis and pattern recognition
- Command examples and guidance

**Access Methods:**
- Command line tools: `llama`, `ai`, `ask-ai`
- Specialized tools: `ai-analyze-wazuh`, `ai-analyze-logs`, `ai-troubleshoot`
- Web interface: AnythingLLM (http://192.168.1.7:3001)

**Architecture:**
- Air-gapped deployment (no internet required)
- Human-in-the-loop workflow (AI suggests, humans execute)
- No direct system access (read-only queries only)
- Compliant with NIST 800-171 requirements

---

**Network Summary:**

| Component | Hostname | IP Address | Primary Role |
|-----------|----------|------------|--------------|
| Domain Controller | dc1.cyberinabox.net | 192.168.1.10 | Identity, DNS, CA |
| Document Server | dms.cyberinabox.net | 192.168.1.20 | File Sharing |
| Log Management | graylog.cyberinabox.net | 192.168.1.30 | Centralized Logging |
| Web Proxy | proxy.cyberinabox.net | 192.168.1.40 | Proxy, IDS/IPS |
| Monitoring | monitoring.cyberinabox.net | 192.168.1.50 | Metrics, Dashboards |
| Security | wazuh.cyberinabox.net | 192.168.1.60 | SIEM, Compliance |
| AI Assistant | Mac Mini M4 | 192.168.1.7 | AI Support (Air-gapped) |

---

**Related Chapters:**
- Chapter 2: CyberHygiene Project Overview
- Chapter 4: Security Baseline Summary
- Chapter 33: System Specifications
- Chapter 34: Network Topology (detailed)

**For More Information:**
- System architecture diagrams available in Technical Documentation
- Network topology details in Chapter 34
