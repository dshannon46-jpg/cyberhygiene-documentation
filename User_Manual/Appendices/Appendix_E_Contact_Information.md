# Appendix E: Contact Information

## E.1 Administrative Contacts

### Primary Administrator

**Security Officer / System Administrator:**
```
Name: Donald Shannon
Title: Security Officer & System Administrator
Organization: CyberHygiene Production Network

Primary Email: dshannon@cyberinabox.net
Alternate Email: donald.shannon@cyberinabox.net
Emergency Contact: See Emergency Procedures (Chapter 32)

Responsibilities:
  - Overall system security
  - NIST 800-171 compliance
  - User account management
  - System administration
  - Incident response
  - Change management
  - Security monitoring
  - Policy enforcement
  - Documentation maintenance

Availability:
  - Business Hours: Monday-Friday, 8:00 AM - 5:00 PM
  - After Hours: Emergency contact only
  - Response Time: Within 4 hours (business hours)
  - Emergency Response: Within 1 hour
```

### Backup Contacts

**Escalation Path:**
```
For urgent issues when primary administrator unavailable:

Level 1: Primary Administrator
  Contact: dshannon@cyberinabox.net
  Response: 4 hours (business), 1 hour (emergency)

Level 2: Management Escalation
  Contact: admin@cyberinabox.net
  When: Primary unavailable or critical decision needed
  Response: 2 hours

Level 3: Emergency Services
  Contact: 911 (physical emergencies only)
  When: Fire, medical emergency, physical security breach
```

## E.2 Functional Contacts

### Security Issues

**Security Incident Reporting:**
```
Primary Contact:
  Email: security@cyberinabox.net
  Forwards to: dshannon@cyberinabox.net
  Purpose: Security incidents, vulnerabilities, threats
  Response: Within 1 hour

What to Report:
  ✓ Suspected security incidents
  ✓ Unusual system behavior
  ✓ Malware detections
  ✓ Unauthorized access attempts
  ✓ Lost or stolen credentials
  ✓ Policy violations
  ✓ Vulnerability discoveries
  ✓ Phishing attempts
  ✓ Any security concerns

How to Report:
  1. Email security@cyberinabox.net with:
     - Description of issue
     - When discovered
     - Systems/users affected
     - Any evidence (logs, screenshots)
     - Your contact information

  2. For emergencies, also call/message administrator

  3. Do not delay reporting while gathering info

See Also: Chapter 25 (Reporting Security Issues)
```

### Technical Support

**User Support:**
```
Help Desk:
  Email: help@cyberinabox.net
  Forwards to: dshannon@cyberinabox.net
  Purpose: User questions, access issues, password resets
  Response: Within 4 hours (business hours)

Common Requests:
  - Password reset
  - Account unlock
  - Access requests
  - Software issues
  - Connection problems
  - File sharing issues
  - Email problems
  - General questions

Self-Service Resources:
  - User Manual (this document)
  - FreeIPA password reset: https://dc1.cyberinabox.net
  - Dashboard access: See Appendix B
  - FAQ: See Chapter 10 (Getting Help)

After-Hours Support:
  - Limited to emergency issues
  - Use emergency contact procedures
  - Non-urgent requests wait until business hours
```

### Account Management

**Account Requests:**
```
New Account Requests:
  Email: accounts@cyberinabox.net
  Forwards to: dshannon@cyberinabox.net

  Required Information:
    - Full name
    - Requested username
    - Email address
    - Job role/department
    - Required access/groups
    - Manager approval
    - Start date

  Processing Time: 1-2 business days

Account Modifications:
  Email: accounts@cyberinabox.net

  Types of Changes:
    - Group membership changes
    - Access level changes
    - Role changes
    - Additional permissions

  Required: Manager approval for privilege escalation

Account Termination:
  Email: accounts@cyberinabox.net

  Required Information:
    - Username
    - Termination date
    - Data ownership transfer
    - Manager notification

  Processing: Immediate upon notification

See Also: Chapter 27 (User Management)
```

### Change Requests

**System Changes:**
```
Change Requests:
  Email: changes@cyberinabox.net
  Forwards to: dshannon@cyberinabox.net

  Required Information:
    - Change description
    - Business justification
    - Systems affected
    - Preferred schedule
    - Risk assessment
    - Rollback plan

  Processing:
    - Review within 2 business days
    - Approval/rejection notification
    - Scheduled implementation
    - Completion notification

Emergency Changes:
  Contact: dshannon@cyberinabox.net
  Phone/Direct contact for urgent issues
  See: Chapter 43 (Change Management)
```

## E.3 System-Specific Contacts

### Service URLs and Access

**Web Interfaces:**
```
FreeIPA (Identity Management):
  URL: https://dc1.cyberinabox.net
  Support: dshannon@cyberinabox.net
  Purpose: User self-service, password management
  Documentation: Chapter 6, 7, 8

Wazuh (Security Monitoring):
  URL: https://wazuh.cyberinabox.net
  Support: dshannon@cyberinabox.net
  Purpose: Security alerts, compliance monitoring
  Documentation: Chapter 17
  Access: Administrators only

Grafana (Metrics & Dashboards):
  URL: https://grafana.cyberinabox.net
  Support: dshannon@cyberinabox.net
  Purpose: System monitoring, performance metrics
  Documentation: Chapter 19
  Access: All authenticated users (LDAP)

Graylog (Log Management):
  URL: https://graylog.cyberinabox.net
  Support: dshannon@cyberinabox.net
  Purpose: Log search and analysis
  Documentation: Chapter 21
  Access: Administrators only

Webmail (Roundcube):
  URL: https://mail.cyberinabox.net
  Support: dshannon@cyberinabox.net
  Purpose: Email access
  Documentation: Chapter 13
  Access: All users

Complete Service URLs: Appendix B
```

### Infrastructure Contacts

**Server Responsibilities:**
```
dc1.cyberinabox.net (Domain Controller):
  Services: FreeIPA, Kerberos, LDAP, DNS, PKI
  Administrator: Donald Shannon
  Email: dshannon@cyberinabox.net
  Priority: Critical (24/7)

dms.cyberinabox.net (File Server):
  Services: NFS, Samba, File Sharing
  Administrator: Donald Shannon
  Email: dshannon@cyberinabox.net
  Priority: High (business hours)

graylog.cyberinabox.net (Log Server):
  Services: Graylog, Elasticsearch, MongoDB
  Administrator: Donald Shannon
  Email: dshannon@cyberinabox.net
  Priority: High (24/7 monitoring)

proxy.cyberinabox.net (Security Gateway):
  Services: Suricata IDS/IPS, Proxy
  Administrator: Donald Shannon
  Email: dshannon@cyberinabox.net
  Priority: Critical (24/7)

monitoring.cyberinabox.net (Monitoring):
  Services: Prometheus, Grafana, Alertmanager
  Administrator: Donald Shannon
  Email: dshannon@cyberinabox.net
  Priority: High (24/7 monitoring)

wazuh.cyberinabox.net (SIEM):
  Services: Wazuh Manager, Security Dashboard
  Administrator: Donald Shannon
  Email: dshannon@cyberinabox.net
  Priority: Critical (24/7)

Network Infrastructure:
  Router/Firewall (192.168.1.1)
  Contact: Network Administrator
  Email: dshannon@cyberinabox.net
```

## E.4 Vendor and Third-Party Contacts

### Open Source Projects

**Software Vendors and Support:**
```
Rocky Linux:
  Website: https://rockylinux.org
  Support: Community forums, mailing lists
  Documentation: https://docs.rockylinux.org
  Security: security@rockylinux.org
  Version: 9.5

FreeIPA:
  Website: https://www.freeipa.org
  Support: freeipa-users@lists.fedorahosted.org
  Documentation: https://www.freeipa.org/page/Documentation
  Issue Tracker: https://pagure.io/freeipa/issues
  IRC: #freeipa on Libera.Chat

Wazuh:
  Website: https://wazuh.com
  Support: Community forum, commercial support available
  Documentation: https://documentation.wazuh.com
  GitHub: https://github.com/wazuh/wazuh
  Slack: https://wazuh.com/community/join-us-on-slack/

Grafana:
  Website: https://grafana.com
  Support: Community forum, docs
  Documentation: https://grafana.com/docs/
  GitHub: https://github.com/grafana/grafana
  Community: https://community.grafana.com

Prometheus:
  Website: https://prometheus.io
  Support: Users mailing list
  Documentation: https://prometheus.io/docs/
  GitHub: https://github.com/prometheus/prometheus
  IRC: #prometheus on Libera.Chat

Graylog:
  Website: https://www.graylog.org
  Support: Community forum, commercial support
  Documentation: https://docs.graylog.org
  GitHub: https://github.com/Graylog2/graylog2-server
  Community: https://community.graylog.org

Suricata:
  Website: https://suricata.io
  Support: Mailing lists, forum
  Documentation: https://docs.suricata.io
  GitHub: https://github.com/OISF/suricata
  Forum: https://forum.suricata.io
```

### Security Resources

**Threat Intelligence and CVE Information:**
```
NIST National Vulnerability Database:
  Website: https://nvd.nist.gov
  Purpose: CVE database, vulnerability info
  RSS Feed: https://nvd.nist.gov/feeds/xml/cve/misc/nvd-rss.xml

Red Hat Security Advisories:
  Website: https://access.redhat.com/security/security-updates/
  Purpose: RHEL/Rocky security updates
  Mailing List: rhsa-announce@redhat.com

US-CERT:
  Website: https://www.cisa.gov/uscert/
  Purpose: Cybersecurity alerts and advisories
  Email Alerts: https://www.cisa.gov/subscribe-updates-cisa

NIST Cybersecurity:
  Website: https://www.nist.gov/cybersecurity
  Purpose: NIST 800-series publications, frameworks
  Email: cyberframework@nist.gov

CVE Mitre:
  Website: https://cve.mitre.org
  Purpose: Common Vulnerabilities and Exposures
  Search: https://cve.mitre.org/cve/search_cve_list.html
```

### Compliance Resources

**Regulatory and Standards Organizations:**
```
NIST (National Institute of Standards and Technology):
  Website: https://www.nist.gov
  NIST 800-171: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final
  Contact: inquiries@nist.gov

CMMC (Cybersecurity Maturity Model Certification):
  Website: https://dodcio.defense.gov/CMMC/
  Resources: https://www.acq.osd.mil/cmmc/
  Email: dodcio.mbx.cmmc@mail.mil

FedRAMP:
  Website: https://www.fedramp.gov
  Email: info@fedramp.gov

DFARS (Defense Federal Acquisition Regulation Supplement):
  Website: https://www.acq.osd.mil/dpap/dars/dfarspgi/current/index.html
```

## E.5 Emergency Contacts

### Critical Incident Response

**Emergency Contact Procedures:**
```
CRITICAL SECURITY INCIDENT:
  1. Primary: Donald Shannon
     Email: dshannon@cyberinabox.net
     Emergency: See Chapter 32
     Response: < 1 hour

  2. If unavailable: admin@cyberinabox.net

  3. Law Enforcement (if needed):
     Local: 911
     FBI Cyber Division: https://www.fbi.gov/investigate/cyber
     IC3: https://www.ic3.gov (Internet Crime Complaint Center)

SYSTEM OUTAGE:
  1. Primary: Donald Shannon
     Email: dshannon@cyberinabox.net
     Assessment: < 15 minutes
     Response: < 1 hour

  2. Check Status:
     Grafana: https://grafana.cyberinabox.net
     Wazuh: https://wazuh.cyberinabox.net

DATA BREACH:
  1. Immediate: Donald Shannon
     Email: dshannon@cyberinabox.net
     Start containment procedures (Chapter 22)

  2. Management: admin@cyberinabox.net
     Notification within 1 hour

  3. Regulatory (if required):
     Varies by jurisdiction and data type
     Consult legal counsel

PHYSICAL SECURITY:
  1. Life Safety: 911

  2. Facility Issues:
     Building Management: [Contact Info]
     Security: [Contact Info]

  3. After securing life safety:
     Notify: dshannon@cyberinabox.net

See Also: Chapter 32 (Emergency Procedures)
```

### Escalation Matrix

**Issue Escalation Path:**
```
Level 1: User Issue
  Contact: help@cyberinabox.net
  Response: 4 hours (business hours)
  Resolves: 90% of user issues

Level 2: Technical Issue
  Contact: dshannon@cyberinabox.net
  Response: 2 hours
  Resolves: Advanced technical issues

Level 3: Critical Incident
  Contact: dshannon@cyberinabox.net + admin@cyberinabox.net
  Response: 1 hour
  Resolves: Security incidents, outages

Level 4: Management Decision
  Contact: admin@cyberinabox.net
  Response: As needed
  Resolves: Policy decisions, major incidents

Level 5: External (Legal/Law Enforcement)
  Contact: Via management
  When: Data breach, criminal activity, legal requirement
```

## E.6 Communication Channels

### Email Addresses

**Functional Email Aliases:**
```
Primary Contacts:
  admin@cyberinabox.net       - General administration
  security@cyberinabox.net    - Security issues
  help@cyberinabox.net        - User support
  accounts@cyberinabox.net    - Account management
  changes@cyberinabox.net     - Change requests

Automated Notifications:
  alerts@cyberinabox.net      - Automated security alerts
  backups@cyberinabox.net     - Backup status notifications
  monitoring@cyberinabox.net  - Monitoring alerts

Personal:
  dshannon@cyberinabox.net    - Donald Shannon

All aliases forward to: dshannon@cyberinabox.net
```

### Documentation Repository

**Documentation Access:**
```
Primary Location:
  Server: dms.cyberinabox.net
  Path: /exports/shared/Documentation/
  Access: NFS mount or Samba share

Git Repository:
  Local: /home/dshannon/Documents/
  Remote: https://github.com/dshannon65/cyberh

User Manual:
  Location: /exports/shared/Documentation/User_Manual/
  Format: Markdown (.md files)
  Viewer: Any text editor or markdown viewer

Online Access:
  HTML version: (planned)
  PDF version: (planned)
  Web portal: (planned)
```

### Communication Preferences

**Contact Guidelines:**
```
For Non-Urgent Requests:
  ✓ Use email (preferred)
  ✓ Include all relevant information
  ✓ Use descriptive subject lines
  ✓ Reference documentation chapter if applicable
  ✓ Allow 4 hours for response (business hours)

For Urgent Issues:
  ✓ Email with "URGENT" in subject
  ✓ Also attempt direct contact
  ✓ Describe urgency clearly
  ✓ Expect response within 1 hour

For Emergencies:
  ✓ Use emergency contact procedures (Chapter 32)
  ✓ Email + direct contact
  ✓ Start containment if security incident
  ✓ Document all actions

Do Not Use For:
  ✗ Sensitive credentials (use secure channels)
  ✗ Detailed security vulnerability info (use encrypted email)
  ✗ Personal/confidential data (use appropriate channels)

Response Time Expectations:
  - Business Hours: Within 4 hours
  - Urgent: Within 1 hour
  - Emergency: Within 15 minutes (assessment)
  - After Hours: Next business day (unless emergency)

Business Hours:
  Monday - Friday: 8:00 AM - 5:00 PM
  Weekends: Emergency only
  Holidays: Emergency only
```

## E.7 External Resources

### Training and Certification

**Professional Development:**
```
NIST Resources:
  NIST Learning: https://www.nist.gov/itl/applied-cybersecurity/nice/resources/online-learning-content
  Cybersecurity Framework: https://www.nist.gov/cyberframework

SANS Training:
  Website: https://www.sans.org
  Free Resources: https://www.sans.org/cyberaces/

Cybrary:
  Website: https://www.cybrary.it
  Free courses on cybersecurity topics

FedVTE (Federal Virtual Training Environment):
  Website: https://fedvte.usalearning.gov
  Free training for federal personnel

Linux Training:
  Red Hat Learning: https://www.redhat.com/en/services/training
  Linux Foundation: https://training.linuxfoundation.org
```

### Industry Information

**Cybersecurity News and Information:**
```
General News:
  Krebs on Security: https://krebsonsecurity.com
  Dark Reading: https://www.darkreading.com
  The Hacker News: https://thehackernews.com
  Bleeping Computer: https://www.bleepingcomputer.com

Threat Intelligence:
  CISA: https://www.cisa.gov
  US-CERT: https://www.cisa.gov/uscert
  AlienVault OTX: https://otx.alienvault.com
  Recorded Future: https://www.recordedfuture.com

Technical Blogs:
  Red Hat Blog: https://www.redhat.com/en/blog
  Wazuh Blog: https://wazuh.com/blog/
  Grafana Blog: https://grafana.com/blog/
```

---

**Quick Contact Reference:**

**For Most Issues:**
- Primary: dshannon@cyberinabox.net
- Help Desk: help@cyberinabox.net
- Security: security@cyberinabox.net

**Emergencies:**
- Security Incident: See Chapter 32
- System Outage: dshannon@cyberinabox.net
- Life Safety: 911

**Service Access:**
- FreeIPA: https://dc1.cyberinabox.net
- Grafana: https://grafana.cyberinabox.net
- Complete list: Appendix B

**Response Times:**
- Business hours: 4 hours
- Urgent: 1 hour
- Emergency: 15 minutes

**Business Hours:**
- M-F 8:00 AM - 5:00 PM
- Weekends: Emergency only

**Documentation:**
- User Manual: This document
- File share: /exports/shared/Documentation/
- Git: https://github.com/dshannon65/cyberh

---

**Related Chapters:**
- Chapter 10: Getting Help
- Chapter 22: Incident Response
- Chapter 25: Reporting Security Issues
- Chapter 32: Emergency Procedures
- Appendix B: Service URLs & Access Points

**Last Updated: December 31, 2025**
**Maintained By: Donald Shannon (dshannon@cyberinabox.net)**
