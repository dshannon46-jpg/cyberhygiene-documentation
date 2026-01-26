# Chapter 10: Getting Help & Support

## 10.1 Help Resources

### Available Support Resources

**Tiered Support Structure:**

#### Tier 1: Self-Service Resources
- This User Manual
- Online documentation portal
- AI Assistant (Llama 3.3 70B)
- Quick Reference Card (Chapter 5)
- FAQ database

**Response Time:** Immediate (24/7 availability)

#### Tier 2: Email Support
- System Administrator
- Help desk ticketing system
- Non-urgent issues

**Response Time:** 1 business day

#### Tier 3: Direct Contact
- Phone support
- Urgent issues
- Security incidents

**Response Time:** 4 hours (business hours), 1 hour (critical)

#### Tier 4: Emergency Response
- Critical system failures
- Active security incidents
- Data loss events

**Response Time:** 15 minutes

### Help Desk Contact Information

**Primary Contact:**
```
System Administrator
Email: dshannon@cyberinabox.net
Office Hours: Monday-Friday, 8:00 AM - 5:00 PM EST
Emergency: (See emergency contact card)
```

**Email Templates:**

**General Support Request:**
```
To: dshannon@cyberinabox.net
Subject: [HELP] Brief description of issue

Issue Description:
- What: [Describe the problem]
- When: [When did it start?]
- Where: [What system/service?]
- Who: [Your username]
- Impact: [Can you work? Is it blocking?]

What I've Tried:
- [Steps you've already attempted]

Urgency: [Low / Medium / High / Critical]
```

**Security Incident:**
```
To: security@cyberinabox.net
Subject: [SECURITY] Brief description

Incident Details:
- Type: [Malware, unauthorized access, data loss, etc.]
- System: [Affected system]
- Time: [When detected]
- User: [Your username]
- Description: [What happened]
- Actions Taken: [What you've done so far]

DO NOT delete anything or shut down affected systems.
```

**Account Issues:**
```
To: dshannon@cyberinabox.net
Subject: [ACCOUNT] Issue type

Problem:
- Username: [Your username]
- Issue: [Locked, password reset, MFA problem, etc.]
- Last successful login: [Date/time if known]
- Error message: [Exact error text]

Contact me at: [Alternative email or phone]
```

### Knowledge Base Access

**Documentation Portal:**
- **Location:** /home/dshannon/Documents/
- **Web Access:** https://cyberhygiene.cyberinabox.net (documentation section)
- **Structure:**
  - User Manual (this document)
  - Operations Guides
  - Setup Guides
  - Technical Documentation

**Searchable Topics:**
- User account management
- Password and authentication
- Dashboard access and usage
- Troubleshooting guides
- Security procedures
- Compliance requirements

## 10.2 AI Assistant (Code Llama)

### What is the AI Assistant?

**Code Llama** is a local, air-gapped AI assistant running on a Mac Mini M4 (192.168.1.7) to help users with:
- Answering questions about system usage
- Troubleshooting common issues
- Explaining documentation
- Providing command syntax help
- Security best practices guidance
- Analyzing log files and security alerts

**Availability:** 24/7 via command line tools or web interface

**Best For:**
- Quick questions
- Command syntax help
- Documentation lookups
- Learning how to perform tasks
- Understanding error messages
- Interpreting security alerts

**Not Suitable For:**
- Executing administrative commands (security restriction)
- Making system changes
- Accessing CUI/FCI data directly
- Replacing human support for complex issues
- Emergency situations (contact human support)

### Accessing the AI Assistant

**Command Line Access:**
```bash
# Interactive session (llama or ai command)
llama

# Or use the ai alias
ai

# Quick one-shot query
ask-ai "How do I change my password?"

# Analyze Wazuh alerts
ai-analyze-wazuh

# Analyze log files
ai-analyze-logs /var/log/messages

# Troubleshoot issues
ai-troubleshoot "SSH connection refused"
```

**Interactive Session Example:**
```
$ llama

Connecting to AI Assistant (Code Llama 7B)...
Connected.

Type your question and press Enter.
Type 'exit' or 'quit' to end session.

You: How do I change my password?

AI: You can change your password using the 'passwd' command:

1. SSH to any system: ssh username@dc1.cyberinabox.net
2. Run: passwd
3. Enter your current password when prompted
4. Enter your new password (must be 14+ characters with 3 character classes)
5. Confirm your new password

Alternatively, you can use the FreeIPA web interface:
1. Navigate to https://dc1.cyberinabox.net
2. Login with current credentials (kinit first for Kerberos auth)
3. Click your username → Change Password

You:
```

**Web Interface Access:**
```
AnythingLLM Web Interface:
URL: http://192.168.1.7:3001
Login: (Contact administrator for credentials)

Features:
- Chat interface with Code Llama
- Document upload and analysis
- Conversation history
- Workspace organization
```

### AI Assistant Capabilities

**System Information:**
```
You: How many systems are in the network?

AI: The CyberHygiene Production Network has 7 systems:
1. dc1.cyberinabox.net - Domain Controller
2. dms.cyberinabox.net - Document Management
3. graylog.cyberinabox.net - Log Management
4. proxy.cyberinabox.net - Web Proxy & IDS
5. monitoring.cyberinabox.net - Prometheus/Grafana
6. wazuh.cyberinabox.net - SIEM
7. Mac Mini M4 (192.168.1.7) - AI Assistant Server

All Rocky Linux systems are running version 9.5 in FIPS mode.
```

**Troubleshooting Help:**
```
You: I'm getting "Permission denied" when trying to access /datastore/shared

AI: The "Permission denied" error typically means:

1. Your user account doesn't have access to that directory
2. You're not in the required group

To check:
- Run: groups
- See if you're in the 'shared' group

To request access:
- Email: dshannon@cyberinabox.net
- Subject: "Access Request: /datastore/shared"
- Include your business justification

If you should have access:
- Check if your Kerberos ticket is valid: klist
- Renew if needed: kinit your_username
```

**Command Syntax:**
```
You: What's the syntax for mounting the shared NFS drive?

AI: To mount the shared NFS drive with Kerberos authentication:

sudo mount -t nfs -o sec=krb5 dms.cyberinabox.net:/exports/shared /mnt/shared

Breakdown:
- mount -t nfs: Mount an NFS filesystem
- -o sec=krb5: Use Kerberos for authentication
- dms.cyberinabox.net:/exports/shared: NFS server and export
- /mnt/shared: Local mount point

Prerequisites:
- Valid Kerberos ticket (kinit your_username)
- Mount point exists (mkdir /mnt/shared if needed)
- Proper group membership
```

**Documentation References:**
```
You: Where can I find information about MFA setup?

AI: Multi-Factor Authentication setup is documented in:

User Manual: Chapter 8 - Multi-Factor Authentication (MFA)
Location: /home/dshannon/Documents/User_Manual/Part_II_Getting_Started/Chapter_08_MFA.md

Key sections:
- 8.2 OTP Token Setup
- 8.3 Using MFA
- 8.4 Backup Codes
- 8.5 Troubleshooting MFA

You can also access the FreeIPA web interface at https://dc1.cyberinabox.net
to enroll in MFA directly (use kinit first for Kerberos authentication).
```

### AI Assistant Best Practices

**DO:**
- ✅ Ask clear, specific questions
- ✅ Provide context (what system, what you're trying to do)
- ✅ Include error messages (exact text)
- ✅ Use it for learning and understanding
- ✅ Ask follow-up questions

**DON'T:**
- ❌ Ask it to execute administrative commands
- ❌ Request it to access sensitive data
- ❌ Expect it to make system changes
- ❌ Use it for emergency situations (contact human support)
- ❌ Share sensitive information in your queries (passwords, keys)

**Example Good Questions:**
```
✅ "How do I check my disk quota?"
✅ "What does error 'Authentication failure' mean in SSH?"
✅ "Where is the Grafana dashboard located?"
✅ "How do I generate an SSH key?"
✅ "What are the password requirements?"
```

**Example Poor Questions:**
```
❌ "Fix my account" (too vague)
❌ "Make me an admin" (requires human approval)
❌ "Access this file for me" (security violation)
❌ "My password is X, why doesn't it work?" (don't share passwords)
```

## 10.3 Documentation Portal

### User Manual Structure

**Part I: Introduction & Overview**
- System overview and architecture
- Security baseline
- Quick reference card

**Part II: Getting Started** (You are here!)
- Account setup
- Authentication
- Policies and support

**Part III: Daily Operations**
- Network access
- File sharing
- Email and applications
- AI assistant usage

**Part IV: Dashboards & Monitoring**
- CPM Dashboard
- Wazuh SIEM
- Suricata IDS/IPS
- Grafana system health
- Graylog logs

**Part V: Security Procedures**
- Incident response
- Backup and recovery
- Reporting issues
- Malware alerts

**Part VI: Administrator Guides**
- User management
- System monitoring
- Backups
- Certificates
- Patching

**Part VII: Technical Reference**
- System specifications
- Network topology
- Software inventory
- API documentation

**Part VIII: Compliance & Policies**
- NIST 800-171
- Security policies
- POA&M status
- Audit procedures

**Appendices:**
- Glossary of terms
- Service URLs
- Command reference
- Troubleshooting guide
- Contact information

### Accessing Documentation

**Local File Access:**
```bash
# Navigate to documentation
cd /home/dshannon/Documents/User_Manual

# List parts
ls -la

# Read a chapter
less Part_II_Getting_Started/Chapter_10_Getting_Help.md

# Search for a topic
grep -r "password reset" .
```

**Web Access:**
- Project website: https://cyberhygiene.cyberinabox.net
- Documentation section available
- Searchable interface
- PDF downloads available

## 10.4 Reporting Issues

### Issue Categories and Severity

#### Priority 1: Critical (Emergency)

**Definition:**
- Complete service outage
- Active security breach
- Data loss in progress
- System compromise

**Examples:**
```
🔴 FreeIPA server down (authentication failure)
🔴 Active malware infection detected
🔴 Wazuh SIEM offline
🔴 Data accidentally deleted
```

**Response:**
- **Contact:** System Administrator immediately
- **Method:** Phone (emergency number)
- **Response Time:** 15 minutes
- **Follow-up:** Email with details

**Do Not:**
- Wait for business hours
- Just send an email
- Try to fix it yourself if it's security-related

#### Priority 2: High (Urgent)

**Definition:**
- Partial service degradation
- Security concern (not active breach)
- Multiple users affected
- Time-sensitive business impact

**Examples:**
```
🟠 Cannot access file shares (multiple users)
🟠 Dashboard showing errors
🟠 Suspicious email received
🟠 Account locked out
```

**Response:**
- **Contact:** Email to dshannon@cyberinabox.net
- **Subject:** [URGENT] Issue description
- **Response Time:** 4 hours (business hours)

#### Priority 3: Medium (Important)

**Definition:**
- Single user affected
- Workaround available
- Non-time-sensitive
- Feature request

**Examples:**
```
🟡 Password reset needed
🟡 Need access to new file share
🟡 Dashboard configuration question
🟡 Documentation update needed
```

**Response:**
- **Contact:** Email to dshannon@cyberinabox.net
- **Subject:** [HELP] Issue description
- **Response Time:** 1 business day

#### Priority 4: Low (Informational)

**Definition:**
- General questions
- Feature requests
- Documentation clarifications
- Suggestions

**Examples:**
```
🟢 How do I use feature X?
🟢 Can we add feature Y?
🟢 Typo in documentation
🟢 Training request
```

**Response:**
- **Contact:** Email or ask AI assistant
- **Response Time:** 2-3 business days

### How to Report Effectively

**Include These Details:**

**1. Your Information:**
```
- Name: [Your full name]
- Username: [Your system username]
- Contact: [Email and phone]
- Department: [Your department]
```

**2. Issue Details:**
```
- What: [Clear description of problem]
- When: [Date and time it started]
- Where: [Which system/service]
- Who: [Just you, or multiple users?]
- Frequency: [Constant, intermittent, one-time?]
```

**3. Impact:**
```
- Can you work? [Yes/No/Partially]
- Others affected? [Yes/No/Unknown]
- Business impact: [High/Medium/Low]
- Deadline concerns: [Any time pressures?]
```

**4. Troubleshooting Attempted:**
```
- What have you tried?
- Any error messages? [Exact text]
- Recent changes? [New software, updates?]
```

**5. Supporting Information:**
```
- Screenshots (if applicable)
- Log excerpts
- Error codes
- Steps to reproduce
```

**Example Good Report:**
```
To: dshannon@cyberinabox.net
Subject: [URGENT] Cannot Access Wazuh Dashboard

Name: John Smith
Username: jsmith
Contact: jsmith@cyberinabox.net, ext. 1234
Department: Security

Issue:
Cannot access Wazuh dashboard at https://wazuh.cyberinabox.net
Started: Today at 10:30 AM
Affects: Me and Sarah Jones (sjones)

Symptoms:
- Browser shows "Connection timed out"
- Can access other dashboards (Grafana, CPM) fine
- Same issue from both Firefox and Chrome

Troubleshooting Tried:
- Cleared browser cache
- Tried from different workstation
- Verified credentials with FreeIPA (login works)
- Pinged wazuh.cyberinabox.net (no response)

Impact:
- Cannot review security alerts
- Need for compliance report due Friday
- Medium-High business impact

Error Message:
"ERR_CONNECTION_TIMED_OUT"
```

### Escalation Process

**Normal Flow:**
```
You → Email Support → System Administrator → Resolution
```

**If Not Resolved:**

**After 24 Hours (Medium Priority):**
1. Reply to original email with "ESCALATE"
2. CC: Supervisor or manager
3. Provide update on business impact

**After 4 Hours (High Priority):**
1. Follow up via phone
2. Escalate to management if needed
3. Document escalation

**Immediate (Critical Priority):**
1. Phone call first
2. Email as documentation
3. Management automatically notified

## 10.5 Support Procedures

### Remote Assistance

**When Support Needs Access:**

**What to Expect:**
1. Administrator will request SSH access (normal)
2. May ask for screen sharing (for GUI issues)
3. Will explain what they're doing
4. Will document changes made

**What to Do:**
- ✅ Confirm identity (email from known address)
- ✅ Stay available during session
- ✅ Ask questions if unsure
- ✅ Request explanation of changes

**What NOT to Do:**
- ❌ Share your password (admin has sudo, doesn't need it)
- ❌ Leave workstation unattended during remote session
- ❌ Click suspicious links claiming to be "support"

### Scheduled Maintenance

**Maintenance Windows:**
```
Standard Maintenance: Saturday 6:00 AM - 10:00 AM EST
Emergency Maintenance: As needed with 4-hour notice
```

**Notification:**
- Email sent 5 days in advance
- Reminder 1 day before
- Posted on CPM dashboard
- Emergency: 4-hour advance notice

**During Maintenance:**
- Services may be unavailable
- Plan work accordingly
- Critical work? Contact admin to reschedule

### Feedback and Suggestions

**How to Provide Feedback:**

**Documentation Feedback:**
```
To: dshannon@cyberinabox.net
Subject: [FEEDBACK] Documentation - Chapter X

Feedback Type: [Correction / Improvement / Question]
Location: [Chapter and section]
Issue: [What's unclear or wrong]
Suggestion: [How to improve]
```

**System Improvement Suggestions:**
```
To: dshannon@cyberinabox.net
Subject: [SUGGESTION] System Improvement

Feature Request: [What you'd like to see]
Business Need: [Why it's helpful]
Current Workaround: [What you do now]
Priority: [High / Medium / Low]
```

**Your Input Matters:**
- All feedback reviewed
- Common requests prioritized
- Credits given for good suggestions
- Regular updates on status

### Training and Onboarding

**New User Onboarding:**
```
Day 1: Account creation, initial access
- Receive credentials
- First login, password change
- MFA setup
- Review Acceptable Use Policy

Week 1: Basic training
- User Manual review
- System overview
- Dashboard tour
- AI assistant introduction

Month 1: Advanced topics (as needed)
- Application-specific training
- Security awareness
- Compliance requirements
```

**Ongoing Training:**
- Annual security awareness (mandatory)
- New feature training (as released)
- Role-based training (as needed)
- Compliance updates (quarterly)

**Training Requests:**
```
To: dshannon@cyberinabox.net
Subject: [TRAINING] Topic Request

Requested Training: [What you want to learn]
Reason: [Job requirement, interest, etc.]
Format Preference: [Live demo, documentation, hands-on]
Urgency: [Immediate need or general interest]
```

---

**Support Summary:**

| Issue Type | Contact Method | Response Time | Escalation |
|------------|----------------|---------------|------------|
| **Critical** | Phone + Email | 15 minutes | Automatic |
| **High** | Email [URGENT] | 4 hours | After 4 hours |
| **Medium** | Email [HELP] | 1 business day | After 24 hours |
| **Low** | Email or AI | 2-3 business days | After 1 week |

**Contact Information:**
- **Primary Support:** dshannon@cyberinabox.net
- **Security Issues:** security@cyberinabox.net
- **Emergency:** (See emergency contact card)
- **AI Assistant:** Run `llama` or `ai` command, or visit http://192.168.1.7:3001

**Hours:**
- **Business Hours:** Monday-Friday, 8:00 AM - 5:00 PM EST
- **After Hours:** Emergency only (critical issues)
- **Holidays:** Emergency only

---

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 9: Acceptable Use Policy
- Chapter 22: Incident Response
- Chapter 25: Reporting Security Issues
- Appendix D: Troubleshooting Guide

**Remember:**
- Use appropriate priority level
- Provide complete information
- Try AI assistant for quick questions
- Don't hesitate to ask for help!

**"Better to ask than to break something trying to fix it yourself!"**
