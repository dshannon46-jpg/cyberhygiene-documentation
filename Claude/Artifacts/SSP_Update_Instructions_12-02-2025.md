# SYSTEM SECURITY PLAN UPDATE INSTRUCTIONS

**Date:** December 2, 2025
**Current SSP Version:** 1.4 (November 2, 2025)
**Recommended Next Version:** 1.5
**Purpose:** Document Graylog centralized logging deployment and update POA&M status

---

## SUMMARY OF CHANGES

The CyberHygiene Production Network has completed a major milestone: deployment of Graylog centralized log management system (POA&M-037). This update documents the new logging infrastructure and reflects the current POA&M completion status of 80% (24/30 items complete).

---

## SECTION-BY-SECTION UPDATE INSTRUCTIONS

### 1. DOCUMENT HEADER (Page 1)

**Current:**
```
Version: 1.4
Date: November 2, 2025
```

**Update to:**
```
Version: 1.5
Date: December 2, 2025
```

---

### 2. SECTION 1: SYSTEM INFORMATION

#### Update System Architecture Diagram (if present)

Add the following components to the system architecture diagram:

- **Graylog Server** (Port 9000) - Web interface and log processing
- **MongoDB** (Port 27017) - Graylog metadata storage
- **OpenSearch** (Port 9200) - Log data indexing and storage
- **rsyslog** - Log forwarding from all system components to Graylog

#### Update System Components Table

Add new table section for **Centralized Log Management**:

| Component | Version | Purpose | IP/Port |
|-----------|---------|---------|---------|
| Graylog Server | 6.0.14 | Centralized log management and analysis | dc1:9000 |
| MongoDB | 7.0.26 | Graylog metadata storage | localhost:27017 |
| OpenSearch | 2.19.4 | Log data indexing and search | localhost:9200 |
| rsyslog | System default | Log forwarding to Graylog | → localhost:1514 |

---

### 3. SECTION 2: SYSTEM ENVIRONMENT

#### 2.X Services and Ports (add new subsection if needed)

Add the following to the services table:

| Service | Port | Protocol | Purpose | Status |
|---------|------|----------|---------|--------|
| Graylog Web UI | 9000 | TCP | Log management interface | Operational |
| Graylog Syslog Input | 1514 | UDP | Log ingestion | Operational |
| MongoDB | 27017 | TCP | Database (localhost only) | Operational |
| OpenSearch | 9200 | TCP | Search API (localhost only) | Operational |

---

### 4. SECTION 3: CONTROL IMPLEMENTATION (Critical Updates)

#### AU-2: Auditable Events

**Add to existing text:**

"All system logs are centralized in Graylog 6.0.14 for unified searchable storage. rsyslog forwards logs from all system components including:
- System logs (journald)
- FreeIPA authentication and authorization events
- Wazuh security alerts and FIM events
- Linux audit logs (auditd)
- Application logs (email, web servers, NextCloud)

Graylog provides:
- Real-time log ingestion via syslog (UDP 1514)
- Full-text search across all log sources
- Long-term retention (30+ days minimum for NIST compliance)
- Dashboard visualization
- Alert capabilities for security events

Configuration: /etc/rsyslog.d/90-graylog.conf forwards all logs to 127.0.0.1:1514"

#### AU-3: Content of Audit Records

**Add to existing text:**

"Graylog preserves all original audit record content including timestamps, source identifiers, event types, outcomes, and user identities. OpenSearch provides indexed storage for rapid search and retrieval."

#### AU-6: Audit Review, Analysis, and Reporting

**Add to existing text:**

"Graylog Web UI (http://dc1.cyberinabox.net:9000) provides centralized audit review capabilities with:
- Advanced search and filtering
- Dashboard visualization
- Alert configuration for security events
- Integration with Wazuh SIEM for correlation

ISSO reviews security-relevant events daily via Graylog interface."

#### AU-7: Audit Reduction and Report Generation

**Add to existing text:**

"Graylog provides audit reduction through:
- Full-text search with regex support
- Field-based filtering and aggregation
- Dashboard creation for recurring reports
- Export capabilities (CSV, JSON)

This enables ISSO to rapidly analyze large volumes of audit data."

#### AU-9: Protection of Audit Information

**Add to existing text:**

"Graylog audit log storage:
- OpenSearch data directory: /var/lib/opensearch (root-owned, 700 permissions)
- MongoDB metadata: /var/lib/mongo (mongod user ownership)
- Access restricted to root and service accounts
- Web UI access restricted to admin account with strong password
- Backend services (MongoDB, OpenSearch) bound to localhost only (no network exposure)"

#### SI-4: Information System Monitoring

**Update existing text to include:**

"System monitoring is provided through integrated tools:
- **Wazuh SIEM 4.9.2:** Real-time security event detection, FIM, vulnerability scanning, compliance assessment
- **Graylog 6.0.14:** Centralized log management and search
- **Suricata IDS/IPS:** Network threat detection (pfSense)
- **Auditd:** System call auditing with OSPP v42 rules

Wazuh forwards security alerts to Graylog for unified visibility. ISSO monitors both Wazuh alerts and Graylog dashboards for security events."

---

### 5. SECTION 8: DATA FLOW DIAGRAMS

#### Update Log Flow Diagram

Add the following to the data flow diagram (if present):

```
[All System Components]
         ↓
   [System Logs]
         ↓
    [journald]
         ↓
     [rsyslog] → /etc/rsyslog.d/90-graylog.conf
         ↓
  [Graylog Input] (UDP 1514)
         ↓
  [Graylog Server] (Processing & Web UI)
         ↓         ↓
   [MongoDB]  [OpenSearch]
   (Metadata) (Log Storage)
         ↓
  [ISSO via Web UI] (9000)
```

---

### 6. SECTION 10: PLAN OF ACTION & MILESTONES (POA&M)

#### Update POA&M Summary Statistics

**Current (in SSP v1.4):**
```
Total Items: 29
Completed: 23 (79%)
In Progress: 2 (7%)
On Track: 4 (14%)
Planned: 0 (0%)
```

**Update to:**
```
Total Items: 30
Completed: 24 (80%)
In Progress: 2 (7%)
On Track: 4 (13%)
Planned: 0 (0%)

Latest Completion: POA&M-037 - Centralized log management (Graylog) deployed on 12/02/2025
```

#### Add New POA&M Item (if POA&M table is in SSP)

**POA&M-037:**

| ID | Weakness | Controls | Target Date | Status | Completion |
|----|----------|----------|-------------|--------|------------|
| POA&M-037 | Centralized log management not deployed | AU-2, AU-3, AU-6, AU-7, AU-9 | 12/02/2025 | COMPLETED | 12/02/2025 |

**Evidence:**
- Graylog 6.0.14 operational at http://dc1.cyberinabox.net:9000
- MongoDB 7.0.26 and OpenSearch 2.19.4 installed and running
- rsyslog forwarding configured (/etc/rsyslog.d/90-graylog.conf)
- All system logs centralized and searchable
- FIPS compatibility achieved via system Java workaround (/etc/sysconfig/graylog-server: JAVA=/usr/bin/java)

**References:**
- System Security Technical Overview (System_Security_Technical_Overview.md)
- POA&M v2.2 (Unified_POAM.md)

---

### 7. SECTION 11: SECURITY ASSESSMENT

#### Update Implementation Status

**Current:**
```
Overall Implementation: 98% complete
```

**Update to:**
```
Overall Implementation: 99% complete
```

**Add to recent completions list:**
- Graylog centralized logging deployed (POA&M-037) - December 2, 2025

---

### 8. APPENDICES

#### Appendix A: Configuration Files

Add the following configuration file references:

**Graylog Configuration:**
- `/etc/graylog/server/server.conf` - Graylog server settings
- `/etc/sysconfig/graylog-server` - Java environment (FIPS workaround)
- `/etc/rsyslog.d/90-graylog.conf` - rsyslog log forwarding

**MongoDB Configuration:**
- `/etc/mongod.conf` - MongoDB database settings

**OpenSearch Configuration:**
- `/etc/opensearch/opensearch.yml` - OpenSearch cluster settings

---

### 9. UPDATE REFERENCES TO OTHER DOCUMENTS

Throughout the SSP, update any references that cite:

**Old:**
- "POA&M v2.1 (79% complete, 23/29 items)"
- "Updated: November 19, 2025"

**New:**
- "POA&M v2.2 (80% complete, 24/30 items)"
- "Updated: December 2, 2025"

---

### 10. DOCUMENT CONTROL / REVISION HISTORY

Add new entry to revision history table:

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.5 | 12/02/2025 | D. Shannon | Added Graylog centralized logging deployment (POA&M-037). Updated AU controls (AU-2, AU-3, AU-6, AU-7, AU-9) and SI-4 to document log management infrastructure. Updated POA&M status: 30 items, 24 complete (80%). Added MongoDB 7.0.26, OpenSearch 2.19.4, Graylog 6.0.14, and rsyslog forwarding to system components. Implementation status: 99% complete. |

---

## QUICK REFERENCE: KEY FACTS FOR SSP UPDATE

### Graylog Deployment Details

- **Graylog Version:** 6.0.14
- **MongoDB Version:** 7.0.26
- **OpenSearch Version:** 2.19.4
- **Deployment Date:** December 2, 2025
- **POA&M Item:** POA&M-037 (COMPLETED)

### Access Information

- **Web Interface:** http://dc1.cyberinabox.net:9000
- **Admin Credentials:** admin/admin (⚠️ change in production)
- **Syslog Input:** UDP port 1514 (RSYSLOG_SyslogProtocol23Format)

### Configuration Files

- **/etc/graylog/server/server.conf** - Main Graylog configuration
- **/etc/sysconfig/graylog-server** - Environment variables (JAVA=/usr/bin/java for FIPS)
- **/etc/rsyslog.d/90-graylog.conf** - Log forwarding configuration
- **/etc/mongod.conf** - MongoDB configuration
- **/etc/opensearch/opensearch.yml** - OpenSearch configuration

### Log Locations

- **Graylog Logs:** /var/log/graylog-server/
- **MongoDB Logs:** /var/log/mongodb/mongod.log
- **OpenSearch Logs:** /var/log/opensearch/
- **Graylog Data:** /var/lib/graylog-server/
- **MongoDB Data:** /var/lib/mongo/
- **OpenSearch Data:** /var/lib/opensearch/

### Services

- **graylog-server.service** - Graylog server daemon
- **mongod.service** - MongoDB database
- **opensearch.service** - OpenSearch search engine

### NIST Controls Affected

Primary controls enhanced by Graylog deployment:
- **AU-2:** Auditable Events (centralized log collection)
- **AU-3:** Content of Audit Records (preserved in OpenSearch)
- **AU-6:** Audit Review, Analysis, and Reporting (Web UI, dashboards)
- **AU-7:** Audit Reduction and Report Generation (search, filtering, export)
- **AU-9:** Protection of Audit Information (access controls, localhost-only backends)
- **SI-4:** Information System Monitoring (unified visibility with Wazuh)

### FIPS Compatibility Note

Graylog 6.0.14 bundled JVM is incompatible with FIPS mode. Workaround implemented:
- Created `/etc/sysconfig/graylog-server` with `JAVA=/usr/bin/java`
- System OpenJDK 17 used instead of bundled JVM
- All cryptographic operations remain FIPS 140-2 compliant via system OpenJDK

---

## SUPPORTING DOCUMENTATION UPDATED

The following supporting documents have already been updated to reflect Graylog deployment:

✅ **POA&M v2.2** (Unified_POAM.md)
- Added POA&M-037 as completed item
- Updated summary: 30 items, 24 complete (80%)
- Updated completion trend and metrics

✅ **System Status Dashboard** (System_Status_Dashboard.html)
- Added Graylog section under Security Monitoring & SIEM
- Updated metrics: 100% health, 11/11 services operational, 80% POA&M complete
- Added Graylog to log directories quick access
- Added Graylog quick commands
- Updated timestamp: December 2, 2025

✅ **Policy Index** (Policy_Index.html)
- Updated POA&M v2.2 reference
- Updated completion statistics throughout
- Updated "Last Updated" dates
- Added Graylog to recent achievements

✅ **System Security Technical Overview** (System_Security_Technical_Overview.md) - **NEW DOCUMENT**
- Comprehensive 15-page technical guide
- Documents all security products and their interactions
- Includes Graylog deployment details, configuration, and troubleshooting
- System interaction diagrams
- Log flow and correlation workflows

---

## CHECKLIST FOR SSP UPDATE

Use this checklist when updating the SSP Word document:

- [ ] Update document header (Version 1.5, Date 12/02/2025)
- [ ] Update System Components table (add Graylog, MongoDB, OpenSearch)
- [ ] Update Services and Ports table
- [ ] Update AU-2 control implementation (auditable events)
- [ ] Update AU-3 control implementation (audit record content)
- [ ] Update AU-6 control implementation (audit review)
- [ ] Update AU-7 control implementation (audit reduction)
- [ ] Update AU-9 control implementation (protection of audit info)
- [ ] Update SI-4 control implementation (system monitoring)
- [ ] Update data flow diagram (if present)
- [ ] Update POA&M summary statistics (30 items, 24 complete, 80%)
- [ ] Add POA&M-037 to POA&M table (if present in SSP)
- [ ] Update implementation status (99% complete)
- [ ] Add Graylog to recent completions list
- [ ] Add configuration file references to appendix
- [ ] Update all references to POA&M version (v2.1 → v2.2)
- [ ] Add Version 1.5 entry to revision history
- [ ] Proofread and verify all changes
- [ ] Save as System_Security_Plan_v1.5.docx

---

## NOTES

1. **SSP Word Document:** The SSP is stored at `/home/dshannon/Documents/Claude/Artifacts/System_Security_Plan_v1.4.docx`. Create a new version (v1.5) after applying these updates.

2. **Backup:** Before making changes, create a backup of SSP v1.4 to the Archives directory.

3. **References:** Use the System Security Technical Overview document (System_Security_Technical_Overview.md) as the authoritative reference for technical details about Graylog deployment.

4. **Coordination:** These updates align with POA&M v2.2, System Status Dashboard, and Policy Index which have all been updated to reflect the Graylog deployment.

5. **Next Review:** SSP quarterly review scheduled for January 31, 2026. At that time, consider updating to reflect any additional POA&M completions or system changes.

---

## DOCUMENT CONTROL

**Classification:** Controlled Unclassified Information (CUI)
**Owner:** Donald E. Shannon, ISSO
**Purpose:** Instructions for updating SSP to Version 1.5
**Created:** December 2, 2025
**Location:** /home/dshannon/Documents/Claude/Artifacts/SSP_Update_Instructions_12-02-2025.md

---

*END OF SSP UPDATE INSTRUCTIONS*
