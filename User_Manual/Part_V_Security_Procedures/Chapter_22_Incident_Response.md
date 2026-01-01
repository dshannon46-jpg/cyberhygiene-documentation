# Chapter 22: Incident Response

## 22.1 Incident Overview

### What is a Security Incident?

A security incident is any event that:
- Threatens confidentiality, integrity, or availability of systems or data
- Violates security policies
- Compromises access controls
- Indicates malicious activity
- Results in unauthorized access or data exposure

**Common Incident Types:**

```
1. Malware Infection
   - Virus, worm, ransomware, trojan detected
   - Unusual system behavior
   - Unauthorized software execution

2. Unauthorized Access
   - Successful brute force attack
   - Compromised credentials
   - Privilege escalation
   - Account hijacking

3. Data Breach
   - Unauthorized data access
   - Data exfiltration
   - Sensitive information exposure
   - CUI/PII disclosure

4. Network Attacks
   - DDoS (Denial of Service)
   - Port scanning
   - Network intrusion
   - Man-in-the-middle

5. Policy Violations
   - Acceptable use policy breach
   - Unauthorized software installation
   - Inappropriate access attempts
   - Data handling violations

6. Physical Security
   - Unauthorized physical access
   - Lost/stolen devices
   - Server room breach
   - Equipment tampering
```

### Incident Severity Levels

**CRITICAL (P1) - Immediate Response Required**
```
Impact: System-wide outage or major data breach
Examples:
  - Ransomware encryption of critical systems
  - Active data exfiltration
  - Complete system compromise
  - Multiple server failures

Response Time: Immediate (< 15 minutes)
Escalation: Automatic to security team and management
Actions: All hands on deck, full incident response
```

**HIGH (P2) - Urgent Response**
```
Impact: Significant security threat or service degradation
Examples:
  - Successful unauthorized access
  - Malware detected and contained
  - Failed backup processes
  - Single critical server down

Response Time: < 1 hour
Escalation: Security team + relevant administrators
Actions: Immediate investigation and containment
```

**MEDIUM (P3) - Standard Response**
```
Impact: Potential security issue or minor service impact
Examples:
  - Repeated failed login attempts
  - Suspicious network traffic
  - Policy violation
  - Non-critical service failure

Response Time: < 4 hours
Escalation: Security team review
Actions: Investigation and remediation during business hours
```

**LOW (P4) - Routine Monitoring**
```
Impact: Informational, no immediate threat
Examples:
  - Automated security alerts (informational)
  - Compliance findings (non-critical)
  - User support requests
  - Scheduled maintenance

Response Time: < 24 hours
Escalation: Logged for review
Actions: Standard workflow handling
```

## 22.2 Detection and Identification

### Detection Methods

**1. Automated Monitoring Systems**

**Wazuh SIEM:**
```
Alert Levels to Watch:
  Level 12+: Critical security events (immediate action)
  Level 7-11: Important security events (investigate)
  Level 0-6: Informational (review periodically)

Access: https://wazuh.cyberinabox.net
Dashboard → Security Events → Threats
```

**Suricata IDS/IPS:**
```
Monitor for:
  - Alert signatures triggering
  - Blocked connections spike
  - Unusual traffic patterns
  - Known malicious IPs

Access: https://grafana.cyberinabox.net
Dashboard: Suricata IDS/IPS
```

**Graylog Log Analysis:**
```
Set up alerts for:
  - Failed authentication (>10 in 5 minutes)
  - Privilege escalation attempts
  - Unusual sudo commands
  - Service failures
  - File integrity changes

Access: https://graylog.cyberinabox.net
```

**2. User Reports**

Users are the first line of defense. Report immediately:
- Suspicious emails (phishing attempts)
- Unexpected system behavior
- Unauthorized access to files
- Lost or stolen devices
- Unusual account activity

**3. Periodic Reviews**

**Daily:**
- Check CPM dashboard for system health
- Review Wazuh security alerts
- Monitor Grafana for anomalies

**Weekly:**
- Audit sudo command logs
- Review failed authentication attempts
- Check AIDE file integrity reports
- Analyze network traffic patterns

**Monthly:**
- User access review
- Security policy compliance check
- Vulnerability scan review
- Backup integrity verification

### Identifying Indicators of Compromise (IOC)

**System-Level IOCs:**
```
□ Unusual processes running
□ Unexpected network connections
□ New user accounts created
□ Files modified without authorization
□ Antivirus/AIDE alerts
□ System performance degradation
□ Unexpected reboots or crashes
```

**Network-Level IOCs:**
```
□ Unusual outbound connections
□ Large data transfers
□ Connections to known malicious IPs
□ Port scanning activity
□ Failed connection attempts spike
□ DNS queries to suspicious domains
```

**User-Level IOCs:**
```
□ Multiple failed login attempts
□ Login from unusual locations
□ Login at unusual times
□ Access to files outside normal scope
□ Privilege escalation attempts
□ Unusual sudo commands
```

**Application-Level IOCs:**
```
□ Unexpected application errors
□ Database query anomalies
□ Web application attacks (SQL injection, XSS)
□ API abuse
□ Unauthorized configuration changes
```

## 22.3 Reporting Procedures

### How to Report an Incident

**IMMEDIATE (Critical/High Severity):**

**Email Security Team:**
```
To: security@cyberinabox.net
Subject: [SECURITY INCIDENT] Brief Description
Priority: HIGH

Incident Details:
- Discovery Time: [timestamp]
- System(s) Affected: [hostname(s)]
- Incident Type: [malware/unauthorized access/data breach/etc.]
- Current Status: [active/contained/unknown]
- Your Name: [name]
- Contact: [phone/email]

What I Observed:
[Detailed description of what you saw, alerts triggered, etc.]

Initial Actions Taken:
[What you've done so far - isolated system, changed password, etc.]

DO NOT:
- Delete files
- Shutdown systems (unless instructed)
- Modify logs
- Attempt cleanup before forensics

I am available at: [contact info]
```

**Phone (Critical Only):**
```
Administrator: [Phone number from Chapter 5]
Available: 24/7 for critical incidents
```

**STANDARD (Medium/Low Severity):**

**AI Assistant (Quick Assessment):**
```bash
# SSH to any system
ssh username@dc1.cyberinabox.net

# Start Claude Code
claude

# Describe the issue
You: I'm seeing multiple failed login attempts from IP 203.0.113.45
     in the last 10 minutes. Is this normal?

Claude: [Provides analysis and next steps]
```

**Email Administrator:**
```
To: dshannon@cyberinabox.net
Subject: [SECURITY] Potential Issue - Brief Description

Issue: [Description]
Severity: [Low/Medium]
System: [hostname]
When: [timestamp]
Details: [What you observed]

Response needed by: [timeframe if urgent]
```

### Required Information

**Gather This Before Reporting:**

**System Information:**
```bash
# What system?
hostname

# Your username
whoami

# System time (for correlation)
date

# System status
uptime
```

**Incident Details:**
```
1. What happened? (detailed description)
2. When did it happen? (exact timestamp if possible)
3. Which system(s) are affected?
4. What actions triggered the incident (if known)?
5. Has anything changed recently?
6. Is data or service affected?
```

**Evidence (Do NOT modify):**
```bash
# Recent logs (if you have access)
sudo journalctl -n 50

# Recent Wazuh alerts (screenshot)
# Recent Graylog entries (screenshot)
# Error messages (exact text or screenshot)
# Network connections (if relevant)
ss -tupn
```

## 22.4 Initial Response Steps

### Incident Response Workflow

**CRITICAL Incident (P1/P2) - First 15 Minutes:**

**Step 1: STOP and ASSESS (1 minute)**
```
DO NOT:
❌ Panic or rush
❌ Delete anything
❌ Shutdown systems without approval
❌ Attempt to "fix" without assessment
❌ Notify everyone (limited distribution)

DO:
✅ Take a breath
✅ Note the exact time
✅ Preserve evidence
✅ Contact security team immediately
✅ Document what you observe
```

**Step 2: CONTAIN (if possible, 5 minutes)**
```
If Safe to Do:
1. Isolate affected system from network:
   - Unplug network cable, OR
   - Disable network interface:
     sudo ip link set eth0 down

2. Change compromised credentials immediately:
   - FreeIPA: https://dc1.cyberinabox.net
   - Change password
   - Revoke sessions

3. Block malicious IP (if known):
   Contact administrator for firewall update

DO NOT power off unless:
- Active ransomware encryption in progress
- Data exfiltration actively occurring
- Instructed by security team
```

**Step 3: NOTIFY (immediately)**
```
Email: security@cyberinabox.net
Subject: [CRITICAL INCIDENT] System Compromise - [hostname]

Immediate Actions Taken:
- [System isolated? Yes/No]
- [Credentials changed? Yes/No]
- [Services stopped? Which ones?]

Current Status: [Active threat / Contained / Investigating]

Awaiting instructions.
Contact: [your phone/email]
```

**Step 4: DOCUMENT (ongoing)**
```
Create incident log:
/home/your_username/incident_log_[YYYYMMDD].txt

Log Format:
[Timestamp] [Action/Observation]

Example:
2025-12-31 14:23:15 - Wazuh alert level 12: Malware detected
2025-12-31 14:23:45 - Isolated workstation from network
2025-12-31 14:24:00 - Notified security team via email
2025-12-31 14:25:00 - Awaiting further instructions
```

**Step 5: PRESERVE Evidence**
```
DO NOT:
- Delete files (even malicious ones)
- Clear logs
- Reboot system
- Run antivirus scans (wait for forensics)
- "Clean up" anything

DO:
- Take screenshots of alerts
- Note any error messages (exact text)
- List running processes:
  ps aux > /tmp/processes_$(date +%Y%m%d_%H%M%S).txt
- List network connections:
  ss -tupn > /tmp/connections_$(date +%Y%m%d_%H%M%S).txt
- Copy logs (don't delete originals):
  sudo cp /var/log/messages /tmp/messages_backup_$(date +%Y%m%d).txt
```

### STANDARD Incident (P3/P4) - First Hour:

**Step 1: Gather Information**
```bash
# Check system logs
sudo journalctl -xe -n 100

# Check Wazuh alerts
# Access: https://wazuh.cyberinabox.net
# Review: Last 24 hours

# Check Graylog
# Access: https://graylog.cyberinabox.net
# Search for: [relevant keywords]

# Check authentication logs
sudo grep "authentication failure" /var/log/secure | tail -20
```

**Step 2: Assess Impact**
```
Questions to Answer:
□ Is system still functioning normally?
□ Are other systems affected?
□ Is data at risk?
□ Are users impacted?
□ Is this an ongoing threat or historical event?
```

**Step 3: Initial Containment**
```
Low Risk Actions (safe to do immediately):
✅ Change password if credentials suspected compromised
✅ Lock user account if policy violation
✅ Restart failed service (if just service failure)
✅ Clear disk space if disk full

Medium Risk Actions (consult first):
⚠️ Isolate system from network
⚠️ Stop running services
⚠️ Block IP addresses
⚠️ Modify firewall rules
```

**Step 4: Report and Track**
```
Email: dshannon@cyberinabox.net
Subject: [SECURITY] Incident Report - [Brief Description]

Incident Details:
- Type: [failed logins / policy violation / etc.]
- Severity: Medium/Low
- System: [hostname]
- Time: [when discovered]
- Current status: [investigating / contained / resolved]

Analysis:
[What you found in logs, dashboards, etc.]

Actions Taken:
[What you did to contain or investigate]

Recommendation:
[What you think should be done]

Request: [Guidance / Permission to proceed / etc.]
```

## 22.5 Escalation Process

### Escalation Levels

**Level 1: Self-Service / AI Assistant**
```
Appropriate For:
- Informational alerts
- User questions
- Minor issues
- How-to questions
- Password resets (self-service)

Resources:
- AI Assistant (Claude Code)
- User Manual (this document)
- Dashboard quick reference
- FreeIPA self-service portal

Time: Immediate to 30 minutes
```

**Level 2: Administrator**
```
Appropriate For:
- Service failures (non-critical)
- Configuration requests
- Access requests
- Account issues
- Standard troubleshooting

Contact: dshannon@cyberinabox.net
Response Time: 1 business day
```

**Level 3: Security Team**
```
Appropriate For:
- Security alerts (medium severity)
- Policy violations
- Suspicious activity
- Failed authentication patterns
- Compliance issues

Contact: security@cyberinabox.net
Response Time: 4 hours
```

**Level 4: Critical Incident Response**
```
Appropriate For:
- Active attacks
- System compromise
- Data breach
- Ransomware
- Service outage (critical systems)

Contact:
  Email: security@cyberinabox.net [CRITICAL]
  Phone: [Emergency contact from Chapter 5]
Response Time: 15 minutes
```

### When to Escalate

**Immediate Escalation Triggers:**
```
Escalate immediately if ANY of these occur:
□ Ransomware/encryption detected
□ Unauthorized administrative access
□ Data exfiltration suspected
□ Multiple system compromise
□ Active ongoing attack
□ CUI/PII exposure
□ Critical service failure
□ Wazuh alert level 12 or higher
```

**Standard Escalation (within 4 hours):**
```
Escalate during business hours if:
□ Repeated failed login attempts (>20)
□ Malware detected but contained
□ Policy violation by user
□ Suspicious network activity
□ File integrity changes (AIDE alerts)
□ Vulnerability scan findings
□ Compliance violations
```

**Information Only (next business day):**
```
Report but don't escalate if:
□ Informational security alerts
□ Scheduled maintenance impact
□ User questions answered
□ Minor configuration issues resolved
□ False positive alerts
```

## 22.6 Post-Incident Review

### Incident Documentation

After incident resolution, complete incident report:

**Incident Report Template:**

```markdown
# Incident Report: [Brief Title]

**Report ID:** INC-[YYYYMMDD]-[NNN]
**Date:** [Date of incident]
**Reporter:** [Your name]
**Severity:** [P1/P2/P3/P4]

## Executive Summary
[2-3 sentence overview of what happened and resolution]

## Incident Timeline

| Time | Event | Action Taken |
|------|-------|--------------|
| 14:23 | Wazuh alert: Malware detected | Isolated system from network |
| 14:25 | Security team notified | Awaited instructions |
| 14:30 | Forensic analysis initiated | Preserved evidence |
| 15:15 | Malware identified and removed | System cleaned |
| 16:00 | System restored to service | Monitoring active |

## Root Cause
[Detailed explanation of how incident occurred]

## Impact Assessment
- **Systems Affected:** [List systems]
- **Data Impact:** [None / Limited / Significant]
- **User Impact:** [Number of users, duration]
- **Service Impact:** [Services unavailable, duration]
- **Financial Impact:** [If applicable]

## Response Actions
[Detailed list of all actions taken during response]

## Evidence Preserved
- Log files: [locations]
- Screenshots: [locations]
- Forensic images: [if applicable]
- Network captures: [if applicable]

## Lessons Learned
**What Went Well:**
- [Positive aspects of response]

**What Could Improve:**
- [Areas for improvement]

**Action Items:**
1. [Specific action] - Assigned to: [person] - Due: [date]
2. [Specific action] - Assigned to: [person] - Due: [date]

## Recommendations
[Specific recommendations to prevent recurrence]

## Approval
- **Prepared by:** [Name, Date]
- **Reviewed by:** [Security Team, Date]
- **Approved by:** [Administrator, Date]
```

### Root Cause Analysis

**The 5 Whys Method:**

```
Example: Malware Infection

Why did malware infect the system?
→ User opened malicious email attachment

Why did user open the attachment?
→ Email appeared to be from trusted source (CEO)

Why did email pass through filters?
→ Email came from legitimate but compromised account

Why was the account compromised?
→ User reused password from breached external service

Why was password reuse possible?
→ No password uniqueness checking across services

Root Cause: Lack of password policy enforcement preventing reuse

Fix: Implement password complexity checking and user training
```

### Preventive Measures

Based on incident findings, implement:

**Technical Controls:**
```
Examples:
- Enhanced logging for specific activities
- Stricter firewall rules
- Additional monitoring alerts
- Software updates/patches
- Configuration hardening
- Access control adjustments
```

**Administrative Controls:**
```
Examples:
- Policy updates
- Procedure refinements
- Training programs
- Awareness campaigns
- Compliance audits
- Regular reviews
```

**Physical Controls:**
```
Examples:
- Enhanced physical security
- Device inventory updates
- Asset tagging
- Access badge reviews
```

### Continuous Improvement

**Quarterly Reviews:**
- Incident trend analysis
- Response time metrics
- Effectiveness of controls
- Training effectiveness
- Policy compliance

**Annual Assessment:**
- Incident response plan review
- Tabletop exercises
- Full-scale incident simulation
- Third-party security assessment
- Compliance audit

---

**Incident Response Quick Reference:**

**Report Security Incident:**
- **Email:** security@cyberinabox.net
- **Phone:** [Emergency number - Chapter 5]
- **AI:** `claude` via SSH for quick assessment

**First Actions (Critical):**
1. Note exact time
2. Isolate affected system (if safe)
3. Preserve evidence (don't delete anything)
4. Contact security team immediately
5. Document everything

**Don't Do:**
- ❌ Panic
- ❌ Delete files/logs
- ❌ Shutdown without approval
- ❌ Attempt cleanup before forensics
- ❌ Broadcast widely

**Do:**
- ✅ Stay calm
- ✅ Document timeline
- ✅ Preserve evidence
- ✅ Follow instructions
- ✅ Report immediately

**Severity Levels:**
- **P1 Critical:** Active attack, data breach, ransomware (Response: < 15 min)
- **P2 High:** System compromise, malware detected (Response: < 1 hour)
- **P3 Medium:** Suspicious activity, policy violation (Response: < 4 hours)
- **P4 Low:** Informational, minor issues (Response: < 24 hours)

**Detection Tools:**
- Wazuh: https://wazuh.cyberinabox.net
- Suricata: https://grafana.cyberinabox.net (Suricata dashboard)
- Graylog: https://graylog.cyberinabox.net
- CPM: https://cpm.cyberinabox.net

**Key Principle:**
When in doubt, report it. False positives are better than missed incidents.

---

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 17: Wazuh Security Monitoring
- Chapter 18: Suricata Network Security
- Chapter 21: Graylog Log Analysis
- Chapter 25: Reporting Security Issues
- Chapter 31: Security Updates & Patching

**For Incident Response:**
- Security Team: security@cyberinabox.net
- Administrator: dshannon@cyberinabox.net
- Emergency: See Chapter 5
- AI Assistant: Run `claude` via SSH
