# Chapter 14: Web Applications & Services

## 14.1 Available Applications

### Web-Based Services Overview

The CyberHygiene network provides several web-based applications and services accessible through your browser.

**Authentication Required:**
All web applications require login with your CyberHygiene credentials (username and password).

### Primary Applications

**1. CPM Dashboard**
```
URL: https://cpm.cyberinabox.net
Purpose: System overview and compliance status
Access: All users (read-only)
Features:
  - System health at-a-glance
  - NIST 800-171 compliance metrics
  - Service status indicators
  - Quick links to other dashboards
```

**2. Wazuh Security Dashboard**
```
URL: https://wazuh.cyberinabox.net
Purpose: Security monitoring and threat detection
Access: Security team, administrators
Features:
  - Real-time security alerts
  - Threat analysis
  - Compliance monitoring
  - Incident investigation tools
```

**3. Grafana Monitoring**
```
URL: https://grafana.cyberinabox.net
Purpose: System metrics and performance
Access: All users (read-only), Admins (full access)
Features:
  - System resource usage (CPU, memory, disk)
  - Network traffic analysis
  - Custom dashboards
  - Alert configuration
```

**4. Graylog Log Management**
```
URL: https://graylog.cyberinabox.net
Purpose: Centralized log analysis
Access: Administrators, operations team
Features:
  - Log search and filtering
  - Real-time log streaming
  - Alert configuration
  - Saved searches and dashboards
```

**5. FreeIPA Identity Management**
```
URL: https://dc1.cyberinabox.net
Purpose: User account self-service
Access: All users
Features:
  - Change password
  - Manage SSH keys
  - View group memberships
  - Reset OTP/MFA
  - Update contact information
```

**6. Roundcube Webmail**
```
URL: https://mail.cyberinabox.net
Purpose: Email access
Access: All users
Features:
  - Send and receive email
  - Manage folders
  - Create filters
  - Address book
  - Calendar (basic)
```

**7. CyberHygiene Project Website**
```
URL: https://cyberhygiene.cyberinabox.net
Purpose: Project information and documentation
Access: Public (no login required)
Features:
  - Project overview
  - Documentation portal
  - News and updates
  - Contact information
```

## 14.2 Single Sign-On (SSO)

### Current SSO Status

**Status:** Partial SSO implementation

**What Works Now:**
- FreeIPA web interface (Kerberos-based)
- Internal web services can use Kerberos authentication
- Shared credentials across all services (same username/password)

**What's Planned (Phase II):**
- Full SPNEGO/Kerberos SSO for web applications
- Login once, access all services
- No repeated authentication prompts

### Using SSO

**Current Experience:**
1. Access first service (e.g., FreeIPA)
2. Login with username/password
3. Access second service (e.g., Grafana)
4. Login again with same credentials
5. Each service maintains separate session

**With Kerberos Ticket (Advanced):**

If you have a Kerberos ticket on your workstation:
```bash
# Get Kerberos ticket
kinit your_username

# Access web services in browser
# Some services auto-authenticate with Kerberos
```

**Browser Configuration for Kerberos SSO:**

**Firefox:**
1. Type `about:config` in address bar
2. Search for: `network.negotiate-auth.trusted-uris`
3. Set value to: `.cyberinabox.net`
4. Restart Firefox

**Chrome/Chromium (Linux):**
```bash
google-chrome --auth-server-whitelist="*.cyberinabox.net"
```

**Note:** Full SSO deployment planned for Phase II

## 14.3 Application Access

### Browser Requirements

**Recommended Browsers:**
- Mozilla Firefox (latest version) - Best compatibility
- Google Chrome (latest version)
- Microsoft Edge (latest version)
- Safari (macOS/iOS)

**Browser Settings:**

**Enable JavaScript:**
Required for all dashboards
```
Firefox: Settings → Privacy & Security → Allow JavaScript
Chrome: Settings → Privacy and security → Site Settings → JavaScript → Allowed
```

**Enable Cookies:**
Required for session management
```
Firefox: Settings → Privacy & Security → Cookies and Site Data → Allow
Chrome: Settings → Privacy and security → Cookies → Allow all cookies
```

**Accept Internal Certificates:**

Your browser may show certificate warnings for internal services:

**One-Time Setup:**
1. Access service (e.g., https://grafana.cyberinabox.net)
2. See certificate warning
3. Click "Advanced" or "Show Details"
4. Review certificate (issued to *.cyberinabox.net)
5. Click "Accept Risk and Continue" or "Proceed"

**Better Solution:** Install internal CA certificate (contact IT)

### Accessing Applications

**Standard Access Flow:**

**1. Navigate to URL**
```
Open browser
Enter: https://grafana.cyberinabox.net
Press Enter
```

**2. Accept Certificate (if prompted)**
```
Click "Advanced" → "Proceed to grafana.cyberinabox.net"
```

**3. Login**
```
Username: your_username
Password: [your password]
OTP (if required): [6-digit code from authenticator app]
Click "Sign In" or "Login"
```

**4. Access Application**
```
Dashboard/application loads
Navigate using menus and buttons
```

**5. Logout When Done**
```
Click your username or avatar (top right)
Select "Logout" or "Sign Out"
```

### Session Management

**Session Timeouts:**

| Application | Idle Timeout | Max Session | Auto-Logout |
|-------------|--------------|-------------|-------------|
| **CPM Dashboard** | 30 minutes | 8 hours | Yes |
| **Wazuh** | 30 minutes | 8 hours | Yes |
| **Grafana** | 30 minutes | 24 hours | Yes |
| **Graylog** | 1 hour | 12 hours | Yes |
| **FreeIPA** | 20 minutes | 8 hours | Yes |
| **Roundcube** | 30 minutes | 24 hours | Yes |

**Session Best Practices:**

**DO:**
- ✅ Logout when finished
- ✅ Lock screen when stepping away
- ✅ Close browser when done
- ✅ Clear sessions on shared computers

**DON'T:**
- ❌ Leave sessions open overnight
- ❌ Share session cookies
- ❌ Use "Remember Me" on shared computers
- ❌ Access from public computers (library, hotel)

**Multiple Tabs:**
- You can open multiple dashboards simultaneously
- Each maintains independent session
- Closing one tab doesn't logout others
- All tabs share same authentication

## 14.4 Service Catalog

### Service Details

**CPM Dashboard**

**URL:** https://cpm.cyberinabox.net

**Features:**
- System status overview
- Compliance percentage (NIST 800-171)
- POA&M status (100% complete)
- Service health indicators
- Quick navigation to other services

**When to Use:**
- Daily health check
- Before starting work (check for alerts)
- Demonstrating compliance status
- High-level system overview

**User Guide:** Chapter 16

---

**Wazuh SIEM**

**URL:** https://wazuh.cyberinabox.net

**Features:**
- Security event dashboard
- Real-time threat alerts
- Compliance monitoring
- Incident investigation
- File integrity monitoring results
- Vulnerability scan reports

**When to Use:**
- Investigating security alerts
- Reviewing compliance status
- Incident response
- Audit evidence collection

**User Guide:** Chapter 17

---

**Grafana**

**URL:** https://grafana.cyberinabox.net

**Available Dashboards:**
1. Node Exporter Full - System resources
2. Suricata IDS/IPS - Network security
3. YARA Malware Detection - Endpoint security

**Features:**
- Real-time metrics
- Historical trend analysis
- Custom time ranges
- Dashboard sharing
- Alert configuration (admin)

**When to Use:**
- Monitor system performance
- Check resource usage
- Identify performance issues
- Capacity planning

**User Guide:** Chapter 19

---

**Graylog**

**URL:** https://graylog.cyberinabox.net

**Features:**
- Centralized log search
- Real-time log streaming
- Advanced filtering
- Saved searches
- Alert configuration
- Dashboard creation

**When to Use:**
- Troubleshooting issues
- Searching for specific events
- Audit log review
- Security investigation

**User Guide:** Chapter 21

---

**FreeIPA**

**URL:** https://dc1.cyberinabox.net

**Self-Service Features:**
- Change password
- Upload/manage SSH keys
- View group memberships
- Reset MFA/OTP tokens
- Update email address
- View account status

**When to Use:**
- Password change or reset
- SSH key management
- MFA issues
- Check account details

**User Guide:** Chapter 6, 7, 8

---

**Roundcube Webmail**

**URL:** https://mail.cyberinabox.net

**Features:**
- Send and receive email
- Folder management
- Email filters and rules
- Address book
- Vacation responder
- Attachment handling (up to 25 MB)

**When to Use:**
- Accessing email from any device
- Don't have email client configured
- Quick email check
- Away from main workstation

**User Guide:** Chapter 13

## 14.5 Custom Applications

### Requesting New Applications

**Process for New Web Application:**

**1. Submit Request**
```
To: dshannon@cyberinabox.net
Subject: New Web Application Request

Application: [Name and description]
Purpose: [Business need]
Users: [Who needs access]
URL/Hosting: [Where it will be hosted]
Requirements: [Special needs - database, storage, etc.]
Timeline: [When needed]
```

**2. Evaluation**
Administrator evaluates:
- Security implications
- Resource requirements
- Compliance impact
- Integration needs
- Cost (if any)

**3. Approval/Denial**
- Approved: Implementation timeline provided
- Denied: Reason and alternatives suggested

**4. Implementation**
If approved:
- Application deployed
- Security hardening applied
- Access controls configured
- User training provided
- Documentation created

### Development/Test Applications

**For Developers:**

Test applications can be deployed on development systems:

**Requirements:**
- Must run on internal network only
- Cannot expose externally without approval
- Must follow security baselines
- Regular security updates required

**Request Process:**
```
To: dshannon@cyberinabox.net
Subject: Development Application Deployment

Application: [Name]
Purpose: Testing/Development
Port: [Requested port number]
Duration: [Temporary or permanent]
Security: [Authentication, encryption, etc.]
```

### Application Integration

**Integrating with Existing Services:**

**Authentication:**
- LDAP integration with FreeIPA
- Kerberos SSO (Phase II)
- OAuth/SAML (if needed)

**Logging:**
- Forward logs to Graylog
- Standard syslog format
- Include authentication events

**Monitoring:**
- Prometheus metrics endpoint
- Health check endpoint
- Alert integration

**Example Integration Request:**
```
Application: Custom Inventory System
Authentication: LDAP (FreeIPA)
Base DN: dc=cyberinabox,dc=net
LDAP Server: dc1.cyberinabox.net:636 (LDAPS)

Logging: Syslog to graylog.cyberinabox.net:514
Format: JSON

Monitoring: Prometheus endpoint at /metrics
Health: /health endpoint (returns 200 OK when healthy)
```

### Application Guidelines

**Security Requirements:**

**Mandatory:**
- ✅ HTTPS/TLS encryption
- ✅ Authentication required
- ✅ Input validation
- ✅ SQL injection prevention
- ✅ XSS protection
- ✅ CSRF tokens
- ✅ Secure password storage (hashed)
- ✅ Session management
- ✅ Logging of access/changes

**Recommended:**
- ✅ Regular security updates
- ✅ Vulnerability scanning
- ✅ Code review
- ✅ Penetration testing
- ✅ Web application firewall (WAF)

**Prohibited:**
- ❌ Hardcoded credentials
- ❌ Default passwords
- ❌ Unencrypted communications
- ❌ Storing passwords in plaintext
- ❌ Running as root
- ❌ Unnecessary services enabled

### Third-Party SaaS Applications

**Using External Services:**

**Approval Required For:**
- Storing company data in cloud
- Granting access to internal systems
- Processing CUI (Controlled Unclassified Information)
- Integration with internal services

**Evaluation Criteria:**
- Security and compliance certifications
- Data residency (where data is stored)
- Encryption at rest and in transit
- Access controls and authentication
- Vendor security practices
- Data portability and deletion

**Request Process:**
```
To: dshannon@cyberinabox.net
Subject: SaaS Application Approval Request

Application: [Name - e.g., Slack, Dropbox, etc.]
Purpose: [Why needed]
Data: [What data will be stored]
Users: [Who needs access]
Cost: [Monthly/annual fee]
Security: [Link to vendor security documentation]
Compliance: [SOC 2, ISO 27001, etc.]
```

---

**Web Applications Summary:**

**Available Now:**
- CPM Dashboard (system overview)
- Wazuh (security monitoring)
- Grafana (performance metrics)
- Graylog (log analysis)
- FreeIPA (identity management)
- Roundcube (webmail)
- Project website (public information)

**Access Requirements:**
- Modern web browser
- CyberHygiene credentials
- MFA for sensitive applications
- Internal network or VPN (Phase II)

**Session Management:**
- Typical timeout: 30 minutes idle
- Maximum session: 8-24 hours
- Auto-logout on timeout
- Manual logout recommended

**Getting Help:**
- Application-specific issues: Contact IT
- Access requests: Email administrator
- Security concerns: security@cyberinabox.net
- How-to questions: Ask Claude Code

---

**Related Chapters:**
- Chapter 11: Accessing the Network
- Chapter 13: Email & Communication
- Chapter 16-21: Dashboard Guides
- Appendix B: Service URLs & Access Points

**Quick Access Links:**
- **Dashboards:** See Appendix B
- **Webmail:** https://mail.cyberinabox.net
- **Identity:** https://dc1.cyberinabox.net
- **Support:** dshannon@cyberinabox.net
