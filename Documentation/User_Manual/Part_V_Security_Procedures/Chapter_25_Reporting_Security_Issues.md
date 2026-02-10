# Chapter 25: Reporting Security Issues

## 25.1 What to Report

### Security Issues Requiring Immediate Reporting

**Always Report These Immediately:**

```
□ Suspicious emails (phishing, malware attachments)
□ Malware detection alerts
□ Unauthorized access attempts
□ Lost or stolen devices (laptop, phone, USB, badge)
□ Suspected account compromise
□ Data breach or exposure
□ Physical security concerns
□ Unknown people in restricted areas
□ Unusual system behavior
□ Security alerts you don't understand
□ Policy violations you witness
□ Social engineering attempts
```

### Types of Security Issues

**1. Phishing and Email Threats**

```
Report If Email Contains:
  □ Requests for password or credentials
  □ Urgent threats ("account will be suspended")
  □ Suspicious attachments (especially .exe, .zip, .doc with macros)
  □ Links to unfamiliar websites
  □ Sender address doesn't match claimed organization
  □ Poor grammar or spelling errors
  □ Unexpected invoices or payment requests
  □ Too-good-to-be-true offers

Examples:
  ❌ "Your email will be deleted in 24 hours. Click here to verify."
  ❌ "CEO needs you to purchase gift cards immediately"
  ❌ "IRS: You owe back taxes. Pay now or face arrest"
  ❌ Fake shipping notifications from unknown senders
```

**2. Malware and System Compromise**

```
Report Immediately If:
  □ Antivirus alert or ClamAV detection
  □ YARA malware detection alert
  □ Wazuh high-severity alert (level 12+)
  □ Files you didn't create or modify
  □ Unexpected popups or windows
  □ System running very slowly without reason
  □ Files encrypted or renamed (ransomware)
  □ New programs installed without your action
  □ Browser redirects to unexpected sites
  □ Can't access files or systems

Don't Wait:
  ⚠️ Minutes matter in malware response
  ⚠️ Report before investigating on your own
  ⚠️ Don't try to "clean" or "fix" yourself
```

**3. Physical Security Issues**

```
Report If:
  □ Lost or stolen equipment (laptop, phone, badge)
  □ Unknown persons in server room
  □ Unlocked doors that should be locked
  □ Security cameras not functioning
  □ Tailgating (unauthorized person following you in)
  □ Suspicious behavior around facilities
  □ Found USB drives or storage devices
  □ Equipment tampering signs

Why Physical Security Matters:
  - Stolen laptop = potential data breach
  - Physical access = bypass many security controls
  - Found USB = possible malware infection vector
```

**4. Data Security Concerns**

```
Report If You Discover:
  □ Sensitive data in wrong location
  □ Unencrypted CUI/PII on shared drive
  □ Files accessible by wrong people
  □ Accidental email to wrong recipients
  □ Data sent to external party without authorization
  □ Database credentials in plain text
  □ Backup files left in public location

Examples:
  - Customer list emailed to external address
  - Password file in unencrypted shared folder
  - Sensitive document in public web directory
```

**5. Access Control Issues**

```
Report If:
  □ Able to access systems you shouldn't
  □ Can view files you don't need
  □ Shared account credentials
  □ Orphaned accounts (ex-employees still active)
  □ Excessive permissions granted
  □ Unauthorized administrative access
  □ MFA not required where it should be

Why Report:
  - Indicates access control misconfiguration
  - Could be exploited by others
  - Compliance requirement (least privilege)
```

**6. Policy Violations**

```
Report If You Witness:
  □ Password sharing
  □ Unauthorized software installation
  □ Data removal on unauthorized media
  □ Use of personal devices for work data (if prohibited)
  □ Unauthorized access attempts
  □ Disabling security controls
  □ Bypassing security procedures

Note: Report violations to protect the organization, not to "get someone in trouble"
```

## 25.2 How to Report

### Reporting Methods

**Method 1: Email (Most Common)**

**For Phishing/Suspicious Emails:**
```
To: security@cyberinabox.net
Subject: [SECURITY] Suspicious Email

DO NOT click links or open attachments first!

Forward email as attachment:
  1. In email client, click "Forward as attachment"
     (Don't just forward - this preserves headers)
  2. To: security@cyberinabox.net
  3. In body, note what made it suspicious:
     - Claims to be from [company] but sender is external
     - Requests password
     - Threatens account closure
     - Unexpected attachment
  4. Send

Alternative (Roundcube):
  1. Select email
  2. More → Forward as attachment
  3. To: security@cyberinabox.net
  4. Add notes
  5. Send
```

**For Other Security Issues:**
```
To: security@cyberinabox.net
Subject: [SECURITY] Brief Description

Template:

Issue: [What you discovered or observed]
Date/Time: [When it happened]
System: [Which system/service if known]
Impact: [Who/what is affected]
Your Actions: [What you did, if anything]

Details:
[Detailed description of the issue]

Evidence:
[Attach screenshots, error messages, log snippets if available]

Contact:
[Your name, email, phone]
[When you're available for follow-up]

Priority: [Low/Medium/High/Critical - your assessment]
```

**Method 2: AI Assistant (Quick Assessment)**

For non-critical issues or to understand severity:

```bash
# Run AI assistant
llama

# Or use quick query
ask-ai "I received an email claiming to be from IT asking me to verify
my password. It looks suspicious. Should I report this?"

# Describe the issue in interactive mode
You: I received an email claiming to be from IT asking me to verify
     my password. It looks suspicious. Should I report this?

AI: [Provides assessment and reporting guidance]

# The AI will help you:
# - Assess severity
# - Determine if it's a security issue
# - Guide you on reporting
# - Provide immediate actions to take
```

**Method 3: Phone (Critical/Urgent)**

```
For CRITICAL issues only:
  - Active malware infection
  - Data breach in progress
  - Ransomware encryption
  - Physical security emergency

Call: [Emergency number from Chapter 5]
Available: 24/7 for critical security incidents

When calling:
  1. State: "Security incident"
  2. Describe briefly: "Ransomware detected on workstation"
  3. Follow instructions
  4. Follow up with email for documentation
```

**Method 4: In-Person (If Available)**

```
When to use:
  - Extremely sensitive issue
  - Cannot use email (email system compromised)
  - Physical security concerns
  - Need immediate guidance

Find: System administrator or security team member
Location: [Office location from Chapter 5]
Follow up: With email documentation after conversation
```

### Reporting Templates

**Template 1: Phishing Email Report**

```
To: security@cyberinabox.net
Subject: [SECURITY] Phishing Attempt

I received a suspicious email that appears to be a phishing attempt.

Sender: ceo@cybe1nabox.net (note the "1" instead of "i")
Subject: "Urgent: Verify Your Account"
Received: 2025-12-31 14:23:15

Red Flags:
- Sender address is fake (note the "1")
- Requests password verification
- Urgent language ("within 24 hours or account locked")
- Link goes to: http://203.0.113.45/login (suspicious IP)

Actions Taken:
- Did NOT click link
- Did NOT open attachment
- Forwarding email as attachment

Status: Email is still in my inbox, not deleted

Contact: jsmith@cyberinabox.net, ext. 1234

I am forwarding the original email as an attachment.
```

**Template 2: Malware Detection**

```
To: security@cyberinabox.net
Subject: [CRITICAL] Malware Detected

Malware has been detected on my system.

System: workstation-05.cyberinabox.net
User: jsmith
Date/Time: 2025-12-31 15:30:00

Alert Source: Wazuh Dashboard
Alert Level: 12 (Critical)
Alert Message: "Malware detected: Trojan.Generic.12345"

File Location: /home/jsmith/Downloads/invoice.pdf.exe

Actions Taken:
- Did NOT open or run the file
- Disconnected from network (unplugged ethernet)
- Taking screenshots of alerts
- Awaiting instructions

Current Status:
- System isolated from network
- File has not been executed
- Awaiting forensic analysis instructions

Contact: jsmith@cyberinabox.net, mobile: 555-1234
Availability: Immediately available

Attachments: screenshots of Wazuh alerts
```

**Template 3: Lost/Stolen Device**

```
To: security@cyberinabox.net
Subject: [URGENT] Lost Device - Laptop

I need to report a lost/stolen device.

Device Type: Laptop
Make/Model: Dell Latitude 5420
Serial Number: ABC123456789 (if known)
Hostname: laptop-jsmith (if known)
Asset Tag: IT-2025-0042 (if known)

User: jsmith
Lost/Stolen: Lost
Location: Coffee shop at 123 Main Street
Date/Time: 2025-12-31, approximately 14:00

Circumstances:
I left my laptop at a coffee shop and realized 2 hours later.
Returned to location but laptop was gone.

Data on Device:
- Work files in /home/jsmith/
- SSH keys (password-protected)
- Saved browser passwords (Firefox - master password protected)
- VPN configuration

Security Features:
- Full disk encryption: YES (LUKS)
- Screen lock password: YES
- BIOS password: YES
- Find My Device: Unknown

Passwords to Revoke:
- Change my CyberHygiene password immediately
- Revoke SSH keys
- Disable VPN access

Actions Taken:
- Reported to local police (report #12345)
- This email notification

Urgency: HIGH - Device contains work data

Contact: jsmith@cyberinabox.net, mobile: 555-1234
Available: Immediately
```

**Template 4: Suspicious Activity**

```
To: security@cyberinabox.net
Subject: [SECURITY] Suspicious Account Activity

I've noticed suspicious activity on my account.

User: jsmith
Discovery Time: 2025-12-31 16:00

Suspicious Indicators:
1. Login notifications from unknown location
   - Location: Moscow, Russia
   - Time: 2025-12-31 03:00 (middle of night, I was asleep)
   - IP: 203.0.113.45

2. Files accessed that I didn't open
   - /exports/shared/confidential/customer_data.xlsx
   - Last accessed: 2025-12-31 03:15
   - I did not access this file

3. Password change attempt (failed)
   - Email notification received at 03:20
   - I did NOT attempt to change password

Actions Taken:
- Changed password immediately (16:05)
- Reviewing Graylog for my username
- All current sessions visible to me look legitimate

Evidence:
- Email screenshots attached
- Graylog query: username:jsmith (last 24 hours)

Current Status:
- Password changed
- Monitoring account activity
- No further suspicious activity since 03:20

Request:
- Review account access logs
- Check for unauthorized access
- Advise on additional protective measures

Contact: jsmith@cyberinabox.net, mobile: 555-1234
Available: Until 18:00 today, then mobile only
```

**Template 5: Physical Security**

```
To: security@cyberinabox.net
Subject: [SECURITY] Physical Security Concern

I need to report a physical security concern.

Date/Time: 2025-12-31 14:30
Location: Server Room, Building A

Issue:
Server room door was propped open with a box. No one was visible
inside or nearby. Door should require badge access and be kept closed.

Observations:
- Door open approximately 30 minutes (last time I passed)
- No maintenance signs or scheduled work
- Cooling/temperature seemed normal
- No obvious tampering or unusual equipment
- Security camera visible, appears functional

Actions Taken:
- Did NOT enter room
- Did NOT move the box
- Checked schedule - no maintenance listed
- Took photo of open door (attached)
- Reporting immediately

Potential Impact:
- Unauthorized physical access possible
- Environmental controls compromised
- Security camera footage may show who opened door

Request:
- Security team investigate
- Review camera footage
- Verify all equipment intact
- Remind staff of door policy

Contact: jsmith@cyberinabox.net, ext. 1234
Location: Currently at my desk
Available: For next 2 hours
```

## 25.3 What Happens After You Report

### Incident Response Process

**Step 1: Acknowledgment (Within 15 minutes - Critical, 1 hour - Standard)**

```
You'll receive email confirmation:

From: Security Team <security@cyberinabox.net>
Subject: RE: [SECURITY] Your Report

Thank you for reporting this security issue.

Incident #: INC-20251231-001
Priority: [High/Medium/Low]
Assigned to: [Security Team Member]

Next Steps:
- We are investigating your report
- Expected update: [timeframe]
- We may contact you for additional information

Your Actions:
[Any immediate actions you should take]

Do NOT:
[Things to avoid while we investigate]

Contact: [Direct contact for urgent updates]

Thank you for helping keep our systems secure.
```

**Step 2: Investigation (Timeline varies by severity)**

Security team will:

```
For Phishing Reports:
  1. Analyze email headers and links (15-30 min)
  2. Check if other users received same email
  3. Update email filters if needed
  4. Block sender/domain
  5. Send alert to all users if widespread

For Malware:
  1. Isolate affected system immediately
  2. Collect forensic evidence
  3. Identify malware type and source
  4. Check for spread to other systems
  5. Remediate and restore system
  6. Update detection signatures

For Lost Device:
  1. Disable account access immediately
  2. Revoke certificates and keys
  3. Remote wipe device (if possible)
  4. Assess data exposure risk
  5. File insurance claim if applicable
  6. Provision replacement device

For Access Issues:
  1. Review access logs
  2. Verify permissions are correct
  3. Revoke unauthorized access
  4. Investigate how it occurred
  5. Prevent recurrence
```

**Step 3: Updates (Regular communication)**

```
You'll receive periodic updates:

Critical Issues (every 1-2 hours):
  - Investigation status
  - Actions being taken
  - What you need to do
  - Estimated resolution time

Standard Issues (daily):
  - Progress update
  - Findings so far
  - Expected completion date
```

**Step 4: Resolution (When issue is resolved)**

```
Final Report Email:

From: Security Team <security@cyberinabox.net>
Subject: [RESOLVED] INC-20251231-001

Incident: [Brief description]
Status: RESOLVED
Resolution Date: 2025-12-31 18:00

Summary:
[What the issue was]

Root Cause:
[How it happened]

Actions Taken:
[What we did to resolve]

Preventive Measures:
[Changes made to prevent recurrence]

Impact:
[What was affected, if anything]

Your Next Steps:
[Any actions you need to take]

Lessons Learned:
[What we learned from this incident]

Thank you for reporting this issue promptly. Your vigilance helps
protect the entire organization.

If you have questions, please contact: security@cyberinabox.net
```

**Step 5: Follow-Up (Days to weeks later)**

```
Possible follow-up activities:

Training:
  - You may be asked to attend refresher training
  - Not punitive - reinforces good practices
  - Helps prevent similar issues

Policy Updates:
  - New policies based on incident lessons
  - You'll be notified of changes

System Changes:
  - New security controls implemented
  - New monitoring or alerts
  - Updated procedures

Feedback Request:
  - How can reporting process be improved?
  - Were instructions clear?
  - Was response timely?
```

### Timeline Examples

**Phishing Email Report:**
```
00:00 - You receive suspicious email
00:05 - You report to security team
00:20 - Security team acknowledges (automated)
00:30 - Security analyst reviews email
01:00 - Email filter updated, sender blocked
01:15 - Alert sent to all users (if widespread attack)
02:00 - You receive resolution email
```

**Malware Detection:**
```
00:00 - Malware alert triggered
00:05 - You isolate system and report
00:10 - Security team acknowledges (CRITICAL)
00:15 - Security team remotely analyzes system
00:30 - Malware identified, containment verified
02:00 - System cleaned and restored
04:00 - Additional monitoring deployed
24:00 - Follow-up scan confirms all clear
48:00 - Final resolution report sent
```

**Lost Device:**
```
00:00 - Device lost/stolen
02:00 - You discover and report
02:10 - Security team disables account access
02:15 - Certificates and SSH keys revoked
02:20 - Remote wipe initiated (if possible)
04:00 - Data exposure assessment complete
24:00 - Replacement device ordered
48:00 - New device provisioned
72:00 - You're back to normal operations
```

## 25.4 False Alarms and Mistakes

### It's Okay to Report False Alarms

**Remember:**

```
✓ False positive (false alarm) is better than missed threat
✓ Security team would rather investigate 10 false alarms than miss 1 real threat
✓ Reporting suspicious activity is never wrong
✓ Better to ask "Is this normal?" than assume it is
✓ You will NOT be penalized for good-faith reports
```

**Common False Positives:**

```
Examples that might be false alarms but should still be reported:

1. "Phishing" email from legitimate vendor
   → Vendor changed email system, looks suspicious
   → Good to verify! Security team will confirm

2. Wazuh alert for your own activity
   → You ran legitimate security scan
   → Report to confirm it was you (audit trail)

3. Failed login attempts from your IP
   → You mistyped password 3 times
   → Normal, but log shows attempts - good to know

4. File access outside normal hours
   → You worked late and accessed files
   → Unusual for you, but legitimate - confirming is good

5. Suspicious system behavior
   → System update in progress, causing slowness
   → Hard to tell from malware without expertise

All of these: Report and let security team assess.
```

### Reporting Mistakes

**If You Accidentally Cause a Security Issue:**

```
Example Scenarios:

1. Accidentally clicked phishing link
2. Opened suspicious attachment
3. Shared password with colleague (against policy)
4. Saved sensitive data in wrong location
5. Sent email to wrong recipient
6. Lost USB drive containing work data
7. Clicked "Yes" on unexpected popup

DO:
✓ Report immediately - faster we know, faster we can mitigate
✓ Be honest about what happened
✓ Explain circumstances
✓ Cooperative in remediation

DON'T:
✗ Try to hide the mistake
✗ Attempt to fix it yourself
✗ Wait to see if anything bad happens
✗ Fear punishment - mistakes happen

The goal is learning and prevention, not blame.
```

**Mistake Report Template:**

```
To: security@cyberinabox.net
Subject: [SECURITY] I Made a Mistake - Need Help

I need to report a security mistake I made.

What Happened:
[Honest description of what you did]

When: 2025-12-31 14:30

Example:
"I clicked on a link in an email I thought was from IT but now
realize was phishing. The link opened a website that asked for my
username and password. I entered them before realizing the URL was
wrong (cybe1nabox.net instead of cyberinabox.net)."

What I Did After:
- Closed browser immediately
- Changed my password
- Reported to security team (this email)

Potential Impact:
- Attacker may have my old password
- May try to access my account
- Need to verify no unauthorized access occurred

Current Status:
- Password changed
- Monitoring account
- Awaiting further instructions

I understand this was a mistake and am cooperating fully with
remediation. Please advise on next steps.

Contact: jsmith@cyberinabox.net, mobile: 555-1234
Available: Immediately
```

### No Blame Culture

**Our Policy:**

```
Security awareness is learning process:
  ✓ Report mistakes without fear
  ✓ Focus on fixing, not blaming
  ✓ Learn from incidents
  ✓ Improve controls to prevent recurrence

Disciplinary action only for:
  ✗ Intentional malicious activity
  ✗ Deliberate policy violations
  ✗ Repeated reckless behavior after training
  ✗ Attempting to hide security incidents

Reporting a mistake is NOT grounds for discipline.
Hiding a mistake MAY be.
```

## 25.5 Confidentiality and Attribution

### Confidential Reporting

**All security reports are treated confidentially:**

```
Who Sees Your Report:
  ✓ Security team (need-to-know basis)
  ✓ System administrator (if needed for remediation)
  ✓ Management (for critical incidents only)

Who Does NOT See Your Report:
  ✗ Your colleagues (unless directly involved)
  ✗ General public
  ✗ External parties (without your consent)

Exception: Legal/compliance requirements may mandate disclosure
```

**Anonymous Reporting:**

```
If you wish to report anonymously:

Option 1: Anonymous Email
  - Create temporary email account
  - Report to: security@cyberinabox.net
  - Include enough detail to be actionable
  - Acknowledge: May limit our ability to follow up

Option 2: Report Through Third Party
  - Ask trusted colleague to report on your behalf
  - Your identity protected
  - Third party can relay follow-up questions

Note: Some issues (especially physical security) may require
identification for investigation purposes.
```

### Attribution and Recognition

**Responsible Disclosure:**

```
If you discover a security vulnerability:

✓ Report to security team first (not public disclosure)
✓ Allow time for remediation before any publication
✓ Work with security team on coordinated disclosure

Recognition:
  - Internal recognition for security findings
  - Potential bonus or reward for significant discoveries
  - Attribution in internal security reports (with permission)
  - External attribution if you prefer

Never:
  ✗ Publish vulnerabilities before they're fixed
  ✗ Exploit vulnerabilities for personal gain
  ✗ Share vulnerabilities with external parties first
```

---

**Security Reporting Quick Reference:**

**Always Report:**
- Phishing emails (suspicious emails)
- Malware alerts or detections
- Lost/stolen devices
- Suspicious account activity
- Physical security concerns
- Unusual system behavior
- Policy violations witnessed

**How to Report:**
```
Email: security@cyberinabox.net
Subject: [SECURITY] Brief Description

Include:
- What happened
- When it happened
- What system/service
- What you did
- Contact info

For CRITICAL issues, also call: [Emergency number - Chapter 5]
```

**Response Times:**
- Critical (malware, breach): < 15 minutes
- High (phishing, suspicious activity): < 1 hour
- Medium (policy questions): < 4 hours
- Low (informational): < 24 hours

**Remember:**
- ✓ Report immediately, don't investigate alone
- ✓ Preserve evidence, don't delete
- ✓ False alarms are okay
- ✓ Mistakes should be reported, not hidden
- ✓ Confidentiality is maintained
- ✓ No blame for good-faith reports

**AI Assistant Help:**
```bash
# Run AI assistant
llama

"I received a suspicious email. Should I report this?"
"I think I clicked a phishing link. What do I do?"
"How do I report a security concern?"
```

**Common Reports:**
1. Phishing: Forward as attachment to security@cyberinabox.net
2. Malware: Isolate system, email security team immediately
3. Lost device: Email security team, list device details
4. Suspicious activity: Check Graylog, screenshot, report
5. Physical security: Email with location, time, description

**For Help:**
- Security Team: security@cyberinabox.net
- Administrator: dshannon@cyberinabox.net
- Emergency: See Chapter 5
- AI Assistant: `llama` or `ai` command

---

**Related Chapters:**
- Chapter 5: Quick Reference Card
- Chapter 9: Acceptable Use Policy
- Chapter 13: Email & Communication (phishing)
- Chapter 22: Incident Response
- Chapter 24: Password Management (compromised passwords)
- Appendix D: Troubleshooting Guide

**External Resources:**
- Report Phishing (Google): https://safebrowsing.google.com/safebrowsing/report_phish/
- Report Phishing (Microsoft): https://www.microsoft.com/en-us/wdsi/support/report-unsafe-site
- FTC Scam Reporting: https://reportfraud.ftc.gov/
- US-CERT: https://www.cisa.gov/uscert
