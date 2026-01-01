# Chapter 13: Email & Communication

## 13.1 Roundcube Webmail

### Accessing Webmail

**URL:** https://mail.cyberinabox.net

**Login Process:**
1. Navigate to webmail URL
2. Enter username (just username, not full email)
3. Enter password
4. Click "Login"

**First-Time Setup:**
After first login, configure:
- Display name
- Time zone
- Language preference
- Default signature

### Roundcube Interface

**Main Interface Layout:**

```
┌─────────────────────────────────────────────────┐
│ [Roundcube Logo]  Inbox (45)      [Settings] [Logout] │
├─────────────┬───────────────────────────────────┤
│ Folders:    │ Message List                      │
│ ▼ INBOX(45) │ ┌─────────────────────────────┐ │
│   Drafts(2) │ │ From    Subject      Date   │ │
│   Sent      │ │ sender  Meeting...   12:34  │ │
│   Junk      │ │ boss    Report...    11:22  │ │
│   Trash     │ │ team    Update...    10:15  │ │
│             │ └─────────────────────────────┘ │
├─────────────┼───────────────────────────────────┤
│             │ Message Preview Pane              │
│             │ [Email content displays here]     │
└─────────────┴───────────────────────────────────┘
```

**Key Features:**

**1. Folders (Left Panel)**
- **Inbox:** New messages
- **Drafts:** Saved unfinished emails
- **Sent:** Sent messages
- **Junk:** Spam (auto-filtered)
- **Trash:** Deleted messages
- **Custom folders:** Create your own

**2. Message List (Top Right)**
- **Unread** messages in bold
- **Flagged** messages with star ⭐
- **Attachments** shown with 📎 icon
- **Sort** by date, sender, subject

**3. Preview Pane (Bottom Right)**
- Message content
- Attachments
- Action buttons (Reply, Forward, Delete)

### Reading Email

**Open a Message:**
- Click message in list
- Message displays in preview pane
- Double-click to open in new window

**Mark as Read/Unread:**
- Right-click message → "Mark as unread"
- Checkbox message → More → Mark as unread

**Flag Important Messages:**
- Click star icon ⭐
- Or right-click → "Flag"
- Flagged messages easy to find later

**Download Attachments:**
1. Scroll to bottom of message
2. Click attachment name or "Download" button
3. File downloads to your Downloads folder

**⚠️ Security Warning:**
- Never open attachments from unknown senders
- Suspicious attachment? Forward to security@cyberinabox.net
- Don't enable macros in documents unless you trust sender

### Composing Email

**New Message:**
1. Click "Compose" button (top left)
2. Fill in fields:
   - **To:** Recipient email address
   - **Cc:** Carbon copy (visible to all)
   - **Bcc:** Blind carbon copy (hidden from recipients)
   - **Subject:** Brief description
   - **Body:** Message content

**Formatting Options:**
- Bold, Italic, Underline
- Font size and color
- Bulleted/numbered lists
- Insert links
- Align text

**Add Attachments:**
1. Click "Attach" button (📎)
2. Select file from your computer
3. Wait for upload (progress bar)
4. Maximum: 25 MB per email

**Multiple Large Files?**
- Use file sharing instead (see Chapter 12)
- Or split into multiple emails

**Save as Draft:**
- Click "Save" button
- Draft saved in Drafts folder
- Continue editing later

**Send Email:**
1. Review recipients, subject, content
2. Click "Send" button
3. Confirmation: "Message sent successfully"
4. Copy saved in Sent folder

### Email Management

**Create Folders:**
1. Right-click "Folders" → "Manage folders"
2. Click "+" (Create folder)
3. Enter folder name (e.g., "Projects", "Important")
4. Click "Save"

**Move Messages:**
- Drag message to folder
- Or: Select → More → Move to → Choose folder

**Delete Messages:**
- Select message → Click "Delete"
- Moves to Trash folder
- **Empty Trash:** Settings → Folders → Trash → Empty

**Search Email:**
1. Use search box (top right)
2. Enter search terms (sender, subject, content)
3. Filter by date, folder, attachment
4. Results appear in message list

**Advanced Search:**
- Click magnifying glass → "Advanced search"
- Search specific fields
- Date ranges
- Include/exclude folders

### Filters and Rules

**Auto-Organize Emails:**

**Create Filter:**
1. Settings → Filters
2. Click "+" to create new filter
3. Configure:
   - **Name:** "Team Updates"
   - **For incoming mail:**
     - Subject contains: "[TEAM]"
   - **...execute the following actions:**
     - Move to: Team folder
     - Mark as read (optional)
4. Save filter

**Example Filters:**

```
Filter: "Automated Reports"
Condition: From contains "reports@"
Action: Move to "Reports" folder, Skip inbox

Filter: "High Priority"
Condition: Subject contains "[URGENT]"
Action: Flag message, Play sound

Filter: "Newsletters"
Condition: Subject contains "newsletter"
Action: Move to "Reading" folder
```

**Vacation/Auto-Reply:**
1. Settings → Filters
2. Enable "Vacation message"
3. Set dates (start/end)
4. Compose message:
   ```
   I am out of office from Jan 1-5 with limited email access.
   For urgent matters, contact: colleague@cyberinabox.net
   ```
5. Save

## 13.2 Email Clients

### Desktop Email Clients

**Supported Clients:**
- Mozilla Thunderbird (recommended, free)
- Microsoft Outlook
- Apple Mail (macOS)
- Evolution (Linux)

**Why Use Desktop Client?**
- ✅ Offline access to email
- ✅ Multiple account management
- ✅ Better performance for large mailboxes
- ✅ Advanced search and filtering
- ✅ Calendar and contacts integration

### Thunderbird Setup (Recommended)

**Download and Install:**
1. Download from https://www.thunderbird.net/
2. Install on your computer
3. Launch Thunderbird

**Configure Account:**

Thunderbird should auto-detect settings:
1. File → New → Existing Mail Account
2. Enter:
   - **Your name:** John Smith
   - **Email address:** jsmith@cyberinabox.net
   - **Password:** [your password]
3. Click "Continue"
4. Thunderbird auto-detects:
   ```
   Incoming (IMAP):
     Server: mail.cyberinabox.net
     Port: 993
     SSL: SSL/TLS
     Authentication: Normal password

   Outgoing (SMTP):
     Server: mail.cyberinabox.net
     Port: 587
     SSL: STARTTLS
     Authentication: Normal password
   ```
5. Click "Done"

**Manual Configuration (if needed):**

**Incoming Mail (IMAP):**
```
Protocol: IMAP
Server: mail.cyberinabox.net
Port: 993
Security: SSL/TLS
Authentication: Normal password
Username: jsmith
```

**Outgoing Mail (SMTP):**
```
Server: mail.cyberinabox.net
Port: 587
Security: STARTTLS
Authentication: Normal password
Username: jsmith
```

### Microsoft Outlook Setup

**Add Account:**
1. File → Add Account
2. Enter email: jsmith@cyberinabox.net
3. Click "Connect"
4. Enter password
5. Outlook attempts auto-configuration

**Manual Setup (if auto-config fails):**
1. File → Account Settings → New
2. Select "Manual setup"
3. Choose "POP or IMAP"
4. Enter settings (same as Thunderbird above)
5. Test Account Settings
6. Finish

### Mobile Email Access

**iOS (iPhone/iPad):**
1. Settings → Mail → Accounts → Add Account
2. Select "Other" → Add Mail Account
3. Enter:
   - Name, Email, Password, Description
4. Tap "Next"
5. Select "IMAP"
6. Enter server settings:
   - **Incoming:** mail.cyberinabox.net, port 993, SSL
   - **Outgoing:** mail.cyberinabox.net, port 587, TLS
7. Tap "Save"

**Android:**
1. Gmail app → Settings → Add account → Other
2. Enter email address
3. Choose "Personal (IMAP)"
4. Enter password
5. Server settings (same as above)
6. Finish

**Security Note:**
- Mobile devices must have screen lock enabled
- Don't store passwords in notes or unencrypted apps
- Report lost/stolen device immediately

## 13.3 Email Security

### Identifying Phishing Emails

**Warning Signs:**

**1. Suspicious Sender:**
```
❌ Bad: CEO <ceo@cybe1nabox.net> (note the "1")
✅ Good: CEO <ceo@cyberinabox.net>

Tip: Hover over sender name to see actual email address
```

**2. Urgent/Threatening Language:**
```
❌ "Your account will be suspended in 24 hours!"
❌ "Immediate action required or you will lose access"
❌ "Click here now to avoid account deletion"

Legitimate IT never uses urgent threats
```

**3. Suspicious Links:**
```
How to Check:
1. Hover over link (don't click!)
2. Look at URL in bottom left of browser/email client

❌ Bad: Link says "cyberinabox.net" but URL shows "cvberinabox.net"
❌ Bad: Link goes to IP address: http://203.0.113.45/login
✅ Good: Link matches expected domain exactly
```

**4. Requests for Credentials:**
```
❌ "Verify your password by clicking here"
❌ "Confirm your account information"
❌ "Update your security settings"

IT will NEVER ask for your password via email
```

**5. Poor Grammar/Spelling:**
```
❌ "Dear valued customer" (generic greeting)
❌ "You're account has been compromise"
❌ Lots of spelling and grammar errors

Professional organizations proofread communications
```

**6. Unexpected Attachments:**
```
❌ Invoice.zip from unknown sender
❌ Resume.exe (executable file)
❌ Document.docx with urgent request to enable macros

Never open attachments from unknown senders
```

### Reporting Phishing

**If You Receive Suspicious Email:**

**DO:**
1. ✅ Do NOT click any links
2. ✅ Do NOT open attachments
3. ✅ Do NOT reply to the email
4. ✅ Forward to security@cyberinabox.net
5. ✅ Delete the email after reporting

**Email to Security Team:**
```
To: security@cyberinabox.net
Subject: [SECURITY] Suspicious Email

Forwarded email as attachment.

Suspicious indicators:
- Sender claims to be [CEO/IT/etc] but email is external
- Requests password/credentials
- Urgent deadline
- Other: [describe what's suspicious]

I have NOT clicked any links or opened attachments.
```

**Security Team Response:**
- Analyzes email
- Blocks sender if malicious
- Updates email filters
- Sends alert to all users if widespread attack

### Email Best Practices

**DO:**
- ✅ Use strong subject lines
- ✅ Keep messages concise
- ✅ Use proper business formatting
- ✅ Reply promptly (within 24 hours)
- ✅ Use Bcc for mass emails (privacy)
- ✅ Proofread before sending
- ✅ Include clear call-to-action

**DON'T:**
- ❌ Send sensitive data via email (use secure file share)
- ❌ Use email for urgent matters (call instead)
- ❌ Reply All unless necessary
- ❌ Forward chain emails
- ❌ Use ALL CAPS (shouting)
- ❌ Send large attachments (>25 MB)
- ❌ Share your password

**Sensitive Information:**

**Never Email:**
- Passwords or credentials
- Social Security Numbers
- Credit card numbers (full)
- Confidential business data
- CUI (Controlled Unclassified Information)

**Use Instead:**
- Secure file share (Chapter 12)
- Encrypted communication tools
- Phone call for very sensitive info

## 13.4 Mailing Lists

### Available Mailing Lists

**Organization-Wide Lists:**

```
all-staff@cyberinabox.net
  - All employees
  - Announcements, company news
  - Low volume (1-3 emails/week)

it-announcements@cyberinabox.net
  - System updates, maintenance
  - Security alerts
  - Downtime notifications
```

**Department Lists:**

```
engineering@cyberinabox.net
  - Engineering team
  - Technical discussions
  - Project updates

operations@cyberinabox.net
  - IT operations team
  - Operational issues
  - On-call rotations
```

**Project Lists:**

```
project-alpha@cyberinabox.net
  - Project-specific communications
  - Team collaboration
  - Created per project, deleted when complete
```

### Subscribing to Lists

**Automatic Subscriptions:**
- All employees: all-staff
- Department members: department list
- Based on group membership in FreeIPA

**Request Subscription:**
```
To: dshannon@cyberinabox.net
Subject: Mailing List Subscription Request

List: project-alpha@cyberinabox.net
User: jsmith@cyberinabox.net
Reason: I'm joining the Alpha project team
```

### Posting to Mailing Lists

**Sending to List:**
- Compose email normally
- **To:** listname@cyberinabox.net
- Message distributed to all subscribers

**Posting Guidelines:**

**DO:**
- Stay on topic
- Use clear subject lines
- Reply to relevant posts
- Trim quoted text
- Include enough context

**DON'T:**
- Post spam or off-topic content
- Reply All for "thanks" or "me too"
- Include large attachments
- Start flame wars
- Use for personal messages

**Example Good Post:**
```
To: engineering@cyberinabox.net
Subject: [Question] Database Schema Migration Best Practice

Team,

I'm working on migrating our user database schema and wanted to get
feedback on the approach. Should we:

1. Blue-green deployment with schema versioning
2. Rolling migration with backward compatibility
3. Maintenance window with downtime

Context: 500K user records, ~10GB database size

Thoughts?

- John
```

### Mailing List Etiquette

**Subject Line Prefixes:**
```
[URGENT] - Immediate action needed
[FYI] - Informational only
[Question] - Seeking advice
[Resolved] - Following up on previous thread
```

**Reply Guidelines:**
- **Reply:** Sends to original sender only
- **Reply All:** Sends to entire list
- **Use Reply All** when: Your response is relevant to all
- **Use Reply** when: Personal response to individual

**Vacation Mode:**
- Set up out-of-office properly (no auto-replies to lists!)
- Unsubscribe from high-volume lists if extended absence
- Re-subscribe when you return

## 13.5 Email Best Practices

### Writing Effective Emails

**Subject Lines:**
```
❌ Bad: "Question"
✅ Good: "Database Migration Question - Need Input by Friday"

❌ Bad: "Meeting"
✅ Good: "Project Alpha Status Meeting - Jan 15, 2PM"
```

**Email Structure:**

```
Subject: Clear, specific subject

Hi [Name],

[Opening: State purpose in first sentence]
I'm writing to request feedback on the Q4 budget proposal.

[Body: Details and context]
The proposal includes:
- 20% increase in infrastructure
- New hiring budget for 3 positions
- Training allocation of $50K

[Action: What you need]
Could you review the attached proposal and provide feedback by
Friday, January 10?

[Closing]
Thank you,
[Your Name]

[Signature]
John Smith
Senior Engineer
Engineering Team
jsmith@cyberinabox.net
```

**Professional Signature:**
```
Best regards,
John Smith
Senior Engineer, Engineering Team
CyberHygiene Production Network
jsmith@cyberinabox.net
Office: (555) 123-4567
```

### Email Productivity

**Inbox Zero Strategy:**

**1. Process Email in Batches:**
- Morning: 9-9:30 AM
- Midday: 12-12:30 PM
- Afternoon: 4-4:30 PM

**2. The 4 D's:**
- **Delete:** Spam, irrelevant emails
- **Do:** Takes <2 minutes, do it now
- **Delegate:** Forward to appropriate person
- **Defer:** Move to folder, schedule time to handle

**3. Use Folders:**
```
Inbox: Needs action
@Action: Requires your response
@Waiting: Waiting for someone else
@Reference: Keep for later
Archive: Completed/processed
```

**4. Keyboard Shortcuts:**
```
Roundcube:
c - Compose new message
r - Reply
a - Reply all
f - Forward
Del - Delete message
Ctrl+Enter - Send message
```

### Managing Email Volume

**Reduce Incoming:**
- Unsubscribe from newsletters you don't read
- Use filters to auto-file low-priority emails
- Set expectations: "I check email 3x daily"

**Batch Processing:**
- Turn off notifications
- Check email at set times
- Don't live in your inbox

**Use Other Tools:**
- Chat for quick questions (when available)
- Phone for urgent matters
- File share for document collaboration
- Project management tools for tasks

---

**Email Quick Reference:**

**Webmail:** https://mail.cyberinabox.net

**IMAP Settings:**
- Server: mail.cyberinabox.net
- Port: 993
- Security: SSL/TLS

**SMTP Settings:**
- Server: mail.cyberinabox.net
- Port: 587
- Security: STARTTLS

**Support:**
- Email issues: dshannon@cyberinabox.net
- Phishing reports: security@cyberinabox.net
- Password reset: Contact administrator

**Limits:**
- Attachment size: 25 MB
- Mailbox quota: 10 GB (check in Settings)
- Daily send limit: 500 messages

---

**Related Chapters:**
- Chapter 9: Acceptable Use Policy
- Chapter 12: File Sharing (for large files)
- Chapter 25: Reporting Security Issues
- Appendix D: Troubleshooting Guide

**For Help:**
- Roundcube guide: Click "?" in webmail
- Email client setup: Contact IT
- Phishing concerns: security@cyberinabox.net
- General questions: Use Claude Code assistant
