# Chapter 17: Security Monitoring (Wazuh)

## 17.1 Wazuh Dashboard Overview

### What is Wazuh?

**Wazuh** is a comprehensive **Security Information and Event Management (SIEM)** platform that provides:
- Real-time security event monitoring
- Threat detection and analysis
- Compliance monitoring (NIST 800-171, PCI-DSS, HIPAA)
- File integrity monitoring
- Vulnerability detection
- Incident investigation tools

**Purpose:**
- Centralize security monitoring across all systems
- Detect and alert on security threats
- Provide evidence for compliance audits
- Enable rapid incident response
- Track security posture over time

**Who Uses Wazuh:**
- **Security Team:** Primary users, investigate all alerts
- **Administrators:** System security monitoring
- **Compliance Officers:** Audit evidence collection
- **Incident Responders:** Forensic analysis

### Accessing Wazuh

**URL:** https://wazuh.cyberinabox.net

**Login Procedure:**
1. Navigate to Wazuh dashboard URL
2. Enter username and password
3. Complete MFA challenge
4. Click "Sign In"
5. Dashboard loads with default view

**Default View:**
- Security Events Overview
- Recent alerts timeline
- Top agents (monitored systems)
- Alert severity distribution

**Access Levels:**
- **Read-Only:** View dashboards, cannot modify
- **Analyst:** View + create custom dashboards
- **Administrator:** Full access, manage rules and agents

### Dashboard Navigation

**Main Menu (Left Sidebar):**
```
📊 Overview - Main dashboard
🔍 Security Events - Alert details
📁 Integrity Monitoring - File changes
🔒 Vulnerability Detection - Security flaws
📋 Compliance - NIST 800-171, PCI-DSS
🖥️ Agents - Monitored systems
⚙️ Management - Configuration (admin)
```

**Top Navigation Bar:**
- Time range selector (last 24h, 7d, 30d, custom)
- Search bar (filter events)
- Refresh button
- User menu (settings, logout)

**Dashboard Filters:**
- Agent (filter by system)
- Rule level (alert severity)
- Rule group (type of alert)
- Time range
- Custom queries

## 17.2 Security Alerts

### Alert Severity Levels

**Wazuh uses severity levels 0-15:**

#### 🔵 **Level 0-3: Informational**
```
Examples:
- Successful user login
- Service started
- Configuration file read

Action: None required (logged for audit trail)
```

#### 🟢 **Level 4-6: Low**
```
Examples:
- Failed login attempt (single)
- Permission denied
- Non-critical service stopped

Action: Review if unusual pattern
```

#### 🟡 **Level 7-10: Medium**
```
Examples:
- Multiple failed login attempts (3-5)
- Port scan detected
- Unusual process execution
- Configuration change

Action: Investigate within 24 hours
```

#### 🟠 **Level 11-13: High**
```
Examples:
- Brute force attack detected (>5 failures)
- Malware signature detected
- Critical file modified
- Privilege escalation attempt

Action: Investigate within 4 hours
```

#### 🔴 **Level 14-15: Critical**
```
Examples:
- Active attack in progress
- System compromise indicators
- Security control disabled
- Data exfiltration detected

Action: Immediate response required (15 minutes)
```

### Alert Categories

**Common Alert Types:**

**1. Authentication Alerts**
```
Rule 5503: User login failed
Severity: 5 (Low)
Description: Single failed login attempt
Example: User 'jsmith' failed to authenticate via SSH
```

```
Rule 5710: Multiple authentication failures
Severity: 10 (Medium)
Description: 5+ failed attempts from same source
Example: Brute force attack from IP 203.0.113.45
```

**2. File Integrity Monitoring (FIM)**
```
Rule 550: File modified
Severity: 7 (Medium)
Description: Monitored file changed
Example: /etc/passwd modified by root
```

```
Rule 554: Critical system file modified
Severity: 12 (High)
Description: Critical config file changed
Example: /etc/shadow modified unexpectedly
```

**3. Malware Detection**
```
Rule 100001: Rootkit detected
Severity: 13 (High)
Description: Rootkit signatures found
Example: Rootkit hunter found suspicious files
```

```
Rule 87104: Malware detected by YARA
Severity: 14 (Critical)
Description: YARA rule match on file
Example: Ransomware signature in /tmp/malicious.exe
```

**4. Network Security**
```
Rule 40101: Port scan detected
Severity: 8 (Medium)
Description: Multiple port probes from single source
Example: Nmap scan from 192.168.1.100
```

```
Rule 87901: DDoS attack detected
Severity: 12 (High)
Description: High volume traffic from multiple sources
Example: SYN flood attack on web server
```

**5. System Integrity**
```
Rule 535: User added to system
Severity: 8 (Medium)
Description: New user account created
Example: User 'attacker' added to /etc/passwd
```

```
Rule 80791: SELinux disabled
Severity: 13 (High)
Description: Security control disabled
Example: SELinux changed from Enforcing to Permissive
```

### Alert Timeline

**Security Events Dashboard:**

**Recent Alerts (Last 24 Hours):**
```
Time                Level   Rule      Description
------------------------------------------------------------------
12/31 14:23:45     5       5503      SSH login failed (jsmith)
12/31 13:15:22     7       550       File modified: /etc/hosts
12/31 12:48:09     10      5710      Multiple auth failures (192.168.1.50)
12/31 11:02:33     5       5503      SSH login failed (admin)
12/31 10:15:47     7       554       File modified: /etc/sudoers
12/31 09:45:12     8       40101     Port scan detected (external IP)
```

**Alert Statistics:**
- Total alerts (24h): 147
- Critical (14-15): 0
- High (11-13): 3
- Medium (7-10): 24
- Low (4-6): 45
- Info (0-3): 75

## 17.3 Threat Detection

### Real-Time Threat Monitoring

**Active Threats Dashboard:**

**Current Threat Status:**
```
🟢 No Active Threats Detected

Last threat: 12/29/2025 (Port scan attempt - blocked)
Systems at risk: 0
Active investigations: 0
```

**Threat Categories Monitored:**
- ✅ Malware infections
- ✅ Brute force attacks
- ✅ Port scans
- ✅ DDoS attempts
- ✅ Data exfiltration
- ✅ Privilege escalation
- ✅ Lateral movement
- ✅ Rootkit installation

### Threat Intelligence Integration

**Integrated Threat Feeds:**
```
🌐 AlienVault OTX
Status: Active
Last update: 2 hours ago
Threat indicators: 45,892

🌐 Emerging Threats
Status: Active
Last update: 1 hour ago
Signatures: 28,451

🌐 Abuse.ch
Status: Active
Last update: 30 minutes ago
Malware hashes: 12,384
```

**Threat Matching:**
- IP addresses matched against threat feeds
- File hashes compared to malware databases
- URLs checked against phishing lists
- Automatic blocking of known bad actors

### Attack Detection

**Common Attack Patterns:**

**1. Brute Force Attack**
```
Alert: Multiple authentication failures
Source IP: 203.0.113.45
Target: dc1.cyberinabox.net (SSH)
Attempts: 47 in 5 minutes
Status: 🔴 BLOCKED by firewall (automated)
```

**Response:**
- IP automatically added to firewall blocklist
- Alert sent to security team
- Incident ticket created
- Block maintained for 24 hours

**2. Port Scan**
```
Alert: Network reconnaissance detected
Source IP: 198.51.100.23
Target: proxy.cyberinabox.net
Ports scanned: 22, 80, 443, 3306, 8080
Status: ⚠️ DETECTED and logged
```

**Response:**
- Alert logged for investigation
- Scan patterns analyzed
- Source IP flagged for monitoring
- If repeated: automatic blocking

**3. File Integrity Violation**
```
Alert: Critical system file modified
File: /etc/passwd
Modified by: unknown process (PID 1234)
Timestamp: 2025-12-31 14:30:15
Status: 🔴 CRITICAL - Investigate immediately
```

**Response:**
- Immediate notification to security team
- File change details captured
- Process tree analyzed
- System quarantined if compromise suspected

## 17.4 Compliance Monitoring

### NIST 800-171 Dashboard

**Compliance Overview:**
```
📋 NIST 800-171 Compliance Status
Overall Score: 100%
Controls Monitored: 110
Compliant: 110
Non-Compliant: 0
Last Assessment: 12/31/2025
```

**Control Categories:**

**Access Control (AC):**
```
✅ AC.1.001 - Authorized users only
   Evidence: User account monitoring
   Status: Compliant

✅ AC.1.002 - Authorized transactions only
   Evidence: Sudo logging, SELinux enforcing
   Status: Compliant

✅ AC.2.016 - Remote access monitoring
   Evidence: SSH session logging
   Status: Compliant
```

**Audit & Accountability (AU):**
```
✅ AU.2.041 - Audit logs generated
   Evidence: Auditd active, logs retained 12 months
   Status: Compliant

✅ AU.2.042 - Non-repudiation
   Evidence: Log signatures, write-once storage
   Status: Compliant

✅ AU.3.046 - Alert on audit failures
   Evidence: Wazuh monitoring auditd
   Status: Compliant
```

**System & Information Integrity (SI):**
```
✅ SI.1.210 - Flaw remediation
   Evidence: Automated patching, vulnerability scanning
   Status: Compliant

✅ SI.1.211 - Malicious code detection
   Evidence: YARA, ClamAV, Suricata active
   Status: Compliant

✅ SI.2.214 - Security alerts
   Evidence: Wazuh SIEM operational
   Status: Compliant
```

### Compliance Evidence Collection

**Evidence Automatically Collected:**
- ✅ User login/logout events
- ✅ Administrative actions (sudo commands)
- ✅ File access and modifications
- ✅ Configuration changes
- ✅ Security control status
- ✅ Vulnerability scan results
- ✅ Malware detection events
- ✅ Network security events

**Retention Policy:**
- Security events: 12 months minimum
- Audit logs: 12 months minimum
- Compliance reports: 3 years
- Incident records: 7 years

**Report Generation:**
```
[Generate Compliance Report]
Report Type: NIST 800-171
Time Period: Last 30 days
Format: PDF
Includes:
  - Control status summary
  - Evidence documentation
  - Exceptions and deviations
  - Remediation activities
```

## 17.5 Incident Investigation

### Investigation Workflow

**Step 1: Alert Identification**
1. Security event appears in dashboard
2. Severity level indicates priority
3. Alert details reviewed

**Step 2: Initial Analysis**
1. Click alert for full details
2. Review:
   - Source system
   - User account involved
   - Process/command executed
   - File(s) affected
   - Network connections
   - Related events

**Step 3: Scope Assessment**
```
Investigation Questions:
- Is this a false positive?
- What systems are affected?
- Is attack still ongoing?
- What data is at risk?
- Do we need to escalate?
```

**Step 4: Response Actions**
- Contain threat (isolate system, block IP)
- Preserve evidence (snapshot, logs)
- Remediate (remove malware, patch vulnerability)
- Document (incident report)

**Step 5: Post-Incident**
- Lessons learned
- Update detection rules
- Implement preventive controls

### Investigation Tools

**Log Search:**
```
Search Query Examples:

1. Find all failed SSH logins:
   data.srcip:* AND rule.id:5503

2. Find sudo commands by user:
   data.dstuser:jsmith AND rule.groups:sudo

3. Find file modifications in /etc:
   syscheck.path:/etc/* AND syscheck.event:modified

4. Find high severity alerts:
   rule.level:>=11
```

**Event Details View:**
```
Alert Details
-------------
Rule ID: 5710
Description: Multiple authentication failures
Severity: 10 (Medium)
Timestamp: 2025-12-31 14:23:45
Agent: dc1.cyberinabox.net

Event Data
----------
Source IP: 203.0.113.45
Destination IP: 192.168.1.10 (dc1)
User: root
Service: sshd
Attempts: 12
Time span: 3 minutes

Recommended Actions
-------------------
1. Block source IP at firewall
2. Review /var/log/secure for additional context
3. Check if account compromised
4. Verify source IP legitimacy
```

**Timeline Reconstruction:**
```
Incident Timeline for: Brute force attack on dc1

14:20:00 - First failed login (user: root, src: 203.0.113.45)
14:20:15 - 2nd failed login
14:20:30 - 3rd failed login
14:21:00 - 5th failed login - Rule 5710 triggered
14:21:15 - 10th failed login
14:23:45 - 12th failed login - Alert escalated
14:24:00 - Firewall block applied
14:24:15 - Connection attempts stop
```

### Forensic Analysis

**Available Forensic Data:**

**1. File Integrity Monitoring (FIM)**
- Before/after file hashes
- Modification timestamps
- Process that modified file
- User context

**2. Process Monitoring**
- Process execution history
- Parent-child relationships
- Command line arguments
- Network connections

**3. Network Activity**
- Connections established
- Data transferred
- Protocols used
- External IPs contacted

**4. User Activity**
- Login/logout times
- Commands executed
- Files accessed
- Privilege escalations

**Example Investigation:**
```
Scenario: Suspicious process detected

Alert: Unknown process communicating externally
Process: /tmp/suspicious_binary
PID: 4521
User: www-data
External IP: 198.51.100.77:443

Investigation:
1. Check file hash: md5sum /tmp/suspicious_binary
   Hash: a1b2c3d4... (unknown, not in database)

2. Check process tree:
   Parent: apache2 (PID 1234)
   Command: /tmp/suspicious_binary --connect 198.51.100.77

3. Check file origin:
   FIM: File created 2025-12-31 14:15:00
   Created by: apache2 (www-data user)
   Source: HTTP upload to /var/www/uploads/

4. Check network activity:
   Connection: ESTABLISHED to 198.51.100.77:443
   Data sent: 2.4 MB (possible data exfiltration)

Conclusion: Likely web shell uploaded via vulnerability
Actions:
  - Kill process (PID 4521)
  - Delete /tmp/suspicious_binary
  - Review web server logs
  - Patch web application vulnerability
  - Block external IP
  - Scan for additional compromises
```

---

**Wazuh Dashboard Summary:**

| Feature | Description | Update Frequency |
|---------|-------------|------------------|
| **Security Events** | Real-time alerts and analysis | Real-time (seconds) |
| **Threat Detection** | Attack pattern recognition | Real-time |
| **Compliance Monitoring** | NIST 800-171 status | Daily |
| **File Integrity** | System file changes | Real-time |
| **Vulnerability Detection** | Security flaw identification | Daily scans |
| **Incident Investigation** | Forensic analysis tools | On-demand |

**Alert Response Times:**

| Severity | Response Time SLA | Notification Method |
|----------|-------------------|---------------------|
| **Critical (14-15)** | 15 minutes | Email, SMS, Dashboard |
| **High (11-13)** | 4 hours | Email, Dashboard |
| **Medium (7-10)** | 24 hours | Dashboard |
| **Low (4-6)** | Review weekly | Dashboard only |
| **Info (0-3)** | No action required | Logged only |

**Current Security Posture:**
```
🟢 Security Status: PROTECTED

Active Agents: 6/6 (100%)
Events/Day: ~10,000
Alerts/Day: ~150
Critical Alerts: 0
Malware Detections: 0
Active Investigations: 0
Last Incident: None (30+ days)
```

---

**Related Chapters:**
- Chapter 16: CPM Dashboard Overview
- Chapter 18: Network Security (Suricata)
- Chapter 22: Incident Response Procedures
- Chapter 25: Reporting Security Issues
- Chapter 26: Malware Detection Alerts

**For More Information:**
- Wazuh Dashboard: https://wazuh.cyberinabox.net
- Wazuh Documentation: https://documentation.wazuh.com/
- Security Team: security@cyberinabox.net
- Emergency: Follow Chapter 22 incident response procedures
