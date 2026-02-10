# Chapter 15: AI Assistant (Local Llama 3.3 70B)

## 15.1 AI Assistant Overview

### What is the AI Assistant?

The CyberHygiene Production Network includes a **local AI assistant** powered by Llama 3.3 70B Instruct running on a dedicated Mac Mini M4 Pro. This AI provides 24/7 support, guidance, and assistance to users and administrators without requiring internet connectivity.

**Key Features:**
- **Air-Gapped Security**: Runs entirely on local network (192.168.1.7)
- **NIST 800-171 Compliant**: No CUI data sent to external servers
- **Human-in-the-Loop**: AI provides recommendations; humans execute commands
- **Comprehensive Audit Trail**: All interactions and actions logged
- **No Internet Required**: Fully operational in offline environment

**Hardware:**
```
System: Mac Mini M4 Pro
IP Address: 192.168.1.7
RAM: 64GB (supports Llama 3.3 70B Instruct)
Purpose: Dedicated AI inference server
Network: Air-gapped (local network only, no internet)
```

**Software Stack:**
```
Ollama Service:
  Port: 11434
  Models: Llama 3.3 70B Instruct (default, quantized q5_K_M)
  Purpose: AI model inference engine

AnythingLLM:
  Interface: Web-based UI
  Features: Workspaces, document analysis, chat interface

CLI Tools:
  - llama / ai: Interactive chat
  - ask-ai: Quick queries
  - ai-analyze-wazuh: Security alert analysis
  - ai-analyze-logs: Log file analysis
  - ai-troubleshoot: Problem diagnosis
```

### How It Works

**Architecture:**
```
┌─────────────────────────────────────────────────────┐
│  Mac Mini M4 (192.168.1.7) - AI Server              │
│  ┌────────────────────────────────────────────┐     │
│  │ Ollama Service (Port 11434)                │     │
│  │ - Llama 3.3 70B Instruct                   │     │
│  │ - SysAdmin Agent Dashboard                 │     │
│  │ - Air-gapped (no CUI access)               │     │
│  └────────────────────────────────────────────┘     │
└────────────────┬────────────────────────────────────┘
                 │ HTTP API (local network only)
                 ▼
┌─────────────────────────────────────────────────────┐
│  Admin Workstations (dc1, etc.)                     │
│  ┌────────────────────────────────────────────┐     │
│  │ AI Integration Scripts                     │     │
│  │ - ask-ai (general queries)                 │     │
│  │ - ai-analyze-wazuh (alert analysis)        │     │
│  │ - ai-analyze-logs (log review)             │     │
│  │ - ai-troubleshoot (problem solving)        │     │
│  └────────────────────────────────────────────┘     │
│                                                      │
│  System Administrator                               │
│  - Reviews AI recommendations                       │
│  - Manually executes validated commands             │
│  - All actions logged for audit                     │
└─────────────────────────────────────────────────────┘

✅ NIST 800-171 Compliant: AI has no direct CUI access
✅ Human-in-the-Loop: All commands executed manually
✅ Audit Trail: All actions logged on admin workstation
```

### What the AI Can Help With

**System Administration:**
- Command syntax and examples
- Troubleshooting procedures
- Configuration guidance
- Best practices recommendations
- Error message interpretation

**Security Analysis:**
- Wazuh alert analysis and recommendations
- Log file pattern analysis
- Security best practice guidance
- Incident response suggestions
- Compliance requirement explanations

**Documentation:**
- Explain system procedures
- Guide through User Manual topics
- Clarify technical concepts
- Provide step-by-step instructions

**What the AI Does NOT Do:**
- ❌ Execute commands directly (human must execute)
- ❌ Access CUI or sensitive data directly
- ❌ Make system changes autonomously
- ❌ Require internet connectivity
- ❌ Send data to external servers

## 15.2 Using the Interactive AI (llama / ai)

### Starting an Interactive Session

**Command:**
```bash
# Start interactive AI session
llama

# Or use shorter alias
ai

# Or full name
codellama
```

**Interface:**
```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🦙 Interactive Code Llama CLI                           ║
║   Local AI Assistant for System Administration           ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

Server: http://192.168.1.7:11434
Model:  llama3.3:70b-instruct-q5_K_M
Type /help for commands or /exit to quit

You > [your question here]

Assistant >
[AI response]
```

### Basic Interaction Examples

**Example 1: Simple Question**
```bash
$ llama

You > How do I check disk space on Linux?

Assistant >
To check disk space on Linux, use the `df` command:

df -h          # Human-readable format
df -h /var     # Check specific partition
du -sh *       # Show size of current directory contents
du -h --max-depth=1 /var/log  # Show sizes one level deep

The `-h` flag shows sizes in human-readable format (GB, MB, etc.)

You > Thank you!

Assistant >
You're welcome! Let me know if you need help with anything else.

You > /exit
Goodbye! 👋
```

**Example 2: Multi-Turn Conversation**
```bash
You > What is the command to find large files?

Assistant >
Use the `find` command with size parameter:

find /var -type f -size +100M -exec ls -lh {} \;

This finds files larger than 100MB in /var directory.

You > Can you explain each part of that command?

Assistant >
Sure! Breaking down the command:

- `find /var`: Start searching in /var directory
- `-type f`: Only find files (not directories)
- `-size +100M`: Files larger than 100 megabytes
- `-exec ls -lh {} \;`: Execute ls -lh on each file found
  - `{}` is replaced with the filename
  - `\;` marks the end of the -exec command

You > Perfect, thank you!
```

### Interactive Commands

**Within a Session:**
```
| Command | Description |
|---------|-------------|
| /help or /h | Show help message |
| /exit or /quit | Exit the program |
| /clear | Clear conversation history |
| /history | Show full conversation history |
| /model [name] | Switch to different model |
| /system [prompt] | Change AI personality/focus |
| /multiline | Enter multiline input mode |
```

**Keyboard Shortcuts:**
```
| Shortcut | Action |
|----------|--------|
| Ctrl+C | Cancel current input |
| Ctrl+D | Exit (when input is empty) |
| ↑ / ↓ | Navigate command history |
```

### Specialized System Prompts

**Security Expert Mode:**
```bash
You > /system You are a security expert focused on NIST 800-171 compliance. Provide security-focused recommendations.

✓ System prompt updated

You > How should I configure SSH for CUI systems?

Assistant >
For NIST 800-171 compliant SSH configuration:

1. Strong encryption (FIPS 140-2):
   Ciphers aes256-gcm@openssh.com,aes256-ctr
   MACs hmac-sha2-256,hmac-sha2-512

2. Authentication:
   - Disable password auth (PasswordAuthentication no)
   - Require key-based auth
   - Consider multi-factor with FreeIPA OTP

3. Access control:
   - AllowUsers or AllowGroups for authorized users only
   - DenyUsers for specific account blocks

4. Session management:
   - ClientAliveInterval 300 (session timeout)
   - MaxAuthTries 3
   - LoginGraceTime 60

5. Logging:
   - LogLevel VERBOSE for audit trail
   - Send logs to centralized SIEM (Wazuh)

This satisfies AC-17, SC-8, SC-13, and AU-2 controls.
```

## 15.3 Quick Query Commands

### ask-ai: One-Shot Questions

**Usage:**
```bash
# Simple syntax
ask-ai "your question here"

# Examples
ask-ai "How do I restart Apache?"
ask-ai "What's the command to check memory usage?"
ask-ai "How do I add a user to a group in FreeIPA?"
```

**Example Output:**
```bash
$ ask-ai "How do I check failed SSH login attempts?"

To check failed SSH login attempts, use:

# View recent failed SSH attempts
grep "Failed password" /var/log/secure | tail -20

# Count failures by IP address
grep "Failed password" /var/log/secure | \
  awk '{print $(NF-3)}' | sort | uniq -c | sort -rn

# Check last 100 failed attempts with details
ausearch -m USER_LOGIN -sv no -i | tail -100

# For real-time monitoring
tail -f /var/log/secure | grep "Failed"

These logs are also centralized in Graylog for easier analysis.
```

### ai-analyze-wazuh: Security Alert Analysis

**Usage:**
```bash
# Analyze last 10 Wazuh alerts (default)
ai-analyze-wazuh

# Analyze specific number of alerts
ai-analyze-wazuh 20

# Analyze alerts from specific time period
ai-analyze-wazuh 50
```

**Example:**
```bash
$ ai-analyze-wazuh 20

Analyzing last 20 Wazuh alerts...

========================================
WAZUH ALERT ANALYSIS
========================================

SUMMARY:
  Total alerts analyzed: 20
  Critical (Level 12+): 2
  High (Level 10-11): 5
  Medium (Level 7-9): 11
  Low (Level 1-6): 2

TOP ISSUES:
1. Multiple failed SSH attempts from 203.0.113.15
   - 8 occurrences in last hour
   - Recommendation: Block IP address via firewalld
   - Command: firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="203.0.113.15" reject'

2. Elevated privilege usage (sudo)
   - User: jsmith
   - 12 sudo commands in last 30 minutes
   - Recommendation: Review if activity is expected

3. File integrity change detected
   - File: /etc/passwd
   - Change: User account modification
   - Status: Normal (account creation by admin)

RECOMMENDED ACTIONS:
☐ Block suspicious IP: 203.0.113.15
☐ Review jsmith's recent sudo activity
☐ Verify /etc/passwd changes are authorized

Would you like detailed analysis of any specific alert?
```

### ai-analyze-logs: Log File Analysis

**Usage:**
```bash
# Analyze /var/log/messages (default)
ai-analyze-logs

# Analyze specific log file
ai-analyze-logs /var/log/secure 100

# Analyze audit logs
ai-analyze-logs /var/log/audit/audit.log 50
```

**Example:**
```bash
$ ai-analyze-logs /var/log/secure 100

Analyzing last 100 lines of /var/log/secure...

========================================
SECURITY LOG ANALYSIS
========================================

AUTHENTICATION SUMMARY:
  Successful logins: 45
  Failed logins: 12
  Sudo executions: 23
  SSH sessions: 18

NOTABLE EVENTS:
1. Failed Login Pattern (Priority: HIGH)
   - User: root
   - Source: 198.51.100.42
   - Count: 8 attempts in 5 minutes
   - Time: 14:25-14:30
   - Recommendation: Investigate source IP, consider blocking

2. Unusual Time Login (Priority: MEDIUM)
   - User: dshannon
   - Time: 03:42 AM
   - Source: 192.168.1.50
   - Status: Successful
   - Note: Late night access (normal for admin?)

3. Service Account Activity (Priority: LOW)
   - User: wazuh
   - Activity: Normal service operations
   - Status: Expected

RECOMMENDATIONS:
1. Block 198.51.100.42 if not authorized
2. Verify dshannon's 3AM login was legitimate
3. Continue monitoring patterns

No immediate security concerns detected.
```

### ai-troubleshoot: Interactive Problem Solving

**Usage:**
```bash
# Describe your problem
ai-troubleshoot "high CPU usage on wazuh-manager"
ai-troubleshoot "disk space running low on /var"
ai-troubleshoot "slow DNS resolution"
```

**Example:**
```bash
$ ai-troubleshoot "httpd service fails to start"

Analyzing problem: "httpd service fails to start"

DIAGNOSTIC STEPS:
================

Step 1: Check service status
--------------------------------------
Run: systemctl status httpd
Look for: Error messages, failed state

Step 2: Check logs
--------------------------------------
Run: journalctl -u httpd -n 50
Look for: Configuration errors, port conflicts

Step 3: Test configuration
--------------------------------------
Run: apachectl configtest
Look for: Syntax errors in config files

Step 4: Check port availability
--------------------------------------
Run: netstat -tlnp | grep :80
       netstat -tlnp | grep :443
Look for: Other processes using ports 80/443

COMMON CAUSES:
--------------
1. Configuration syntax error
   Fix: Check /etc/httpd/conf/httpd.conf

2. Port already in use
   Fix: Stop conflicting service or change Apache ports

3. SELinux denial
   Fix: Check ausearch -m avc -ts recent

4. Missing SSL certificates
   Fix: Verify /etc/pki/tls/certs/ has required certs

NEXT STEPS:
-----------
1. Run diagnostic commands above
2. Share output if issue persists
3. I can help interpret results

Would you like me to explain any of these steps in detail?
```

## 15.4 AnythingLLM Web Interface

### Accessing the Web Interface

**URL:** http://192.168.1.7 (from Mac Mini M4)

**Features:**
- Visual chat interface
- Document upload and analysis
- Workspace organization
- Conversation history
- Copy-paste friendly

**Workspaces:**
```
1. "Security Analysis"
   Purpose: Wazuh alerts, log analysis, security issues

2. "System Administration"
   Purpose: General system tasks, troubleshooting

3. "Troubleshooting"
   Purpose: Problem diagnosis, error resolution

4. "Compliance"
   Purpose: NIST 800-171, policy questions
```

### Using AnythingLLM

**Basic Workflow:**
1. Open AnythingLLM on Mac Mini M4
2. Select appropriate workspace
3. Ask questions conversationally
4. Copy useful commands to terminal
5. Execute manually on admin workstation
6. Document actions taken

**Example Session:**
```
User: I'm getting high memory alerts on the Wazuh server.
      How do I investigate?

AI: Here's how to investigate high memory usage on Wazuh:

    1. Check current memory usage:
       free -h
       top -o %MEM

    2. Identify top memory consumers:
       ps aux --sort=-%mem | head -20

    3. Check Wazuh-specific processes:
       ps aux | grep wazuh
       systemctl status wazuh-manager

    4. Review Wazuh logs:
       tail -f /var/ossec/logs/ossec.log

    5. Check for memory leaks:
       cat /proc/$(pgrep wazuh-analysisd)/status | grep VmRSS

    Would you like me to help interpret the output?
```

## 15.5 Security and Compliance

### NIST 800-171 Compliance

**How AI Maintains Compliance:**
```
✅ AC-3 (Access Enforcement):
   - AI cannot access CUI data directly
   - All data access through human administrators
   - AI server outside CUI boundary (192.168.1.7)

✅ AU-2 (Audit Events):
   - Admin actions logged on DC1, not AI queries
   - Full audit trail maintained
   - AI queries not considered security-relevant events

✅ IA-2 (Authentication):
   - Human authenticates to workstation
   - AI doesn't handle authentication
   - No AI access to credentials

✅ SC-7 (Boundary Protection):
   - AI server physically separated
   - No internet connectivity
   - Local network only (192.168.1.0/24)

✅ SC-13 (Cryptographic Protection):
   - Workstations maintain FIPS mode
   - AI server doesn't process CUI
   - Encrypted connections between components
```

### Audit Trail

**Logging AI-Assisted Actions:**
```bash
# All administrative actions should be logged
# Log location: /var/log/ai-assisted-admin/actions.log

# Example log entry
2025-12-31_15:30:45 - User: dshannon - Query: "How to block IP 203.0.113.15" - Action: firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="203.0.113.15" reject'
```

**Logging Script:**
```bash
#!/bin/bash
# log-ai-action.sh
# Usage: log-ai-action.sh "query" "command executed"

LOG_DIR="/var/log/ai-assisted-admin"
LOG_FILE="${LOG_DIR}/actions.log"

mkdir -p "${LOG_DIR}"

echo "$(date +%Y-%m-%d_%H:%M:%S) - User: $(whoami) - Query: $1 - Action: $2" >> "${LOG_FILE}"
```

### Human-in-the-Loop Workflow

**Required Process:**
```
1. Admin asks AI for recommendation
   ↓
2. AI provides suggested command/action
   ↓
3. Admin reviews recommendation
   ↓
4. Admin validates appropriateness
   ↓
5. Admin manually executes command
   ↓
6. Admin logs action for audit
   ↓
7. Admin verifies result
```

**Example:**
```bash
# Step 1: Ask AI
ask-ai "How do I check for failed SSH logins from last hour?"

# Step 2: AI provides command
# grep "Failed password" /var/log/secure | grep "$(date +%b\ %d\ %H)"

# Step 3-4: Admin reviews and validates
# Command looks safe, appropriate for task

# Step 5: Admin executes manually
grep "Failed password" /var/log/secure | grep "$(date +%b\ %d\ %H)"

# Step 6: Log action
log-ai-action.sh "check failed SSH logins" "grep 'Failed password' /var/log/secure"

# Step 7: Review output, take further action if needed
```

## 15.6 Best Practices

### Effective AI Usage

**Be Specific:**
```
❌ Vague: "How do I use firewall?"
✅ Better: "How do I block port 22 from specific IP using firewalld?"

❌ Vague: "Email not working"
✅ Better: "Postfix service running but mail not being delivered, where do I check for errors?"
```

**Provide Context:**
```
Good Question:
"I'm seeing high CPU usage on the wazuh-manager process.
It's using 80% CPU consistently. How do I diagnose this?"

Better Question:
"The wazuh-manager process on wazuh.cyberinabox.net is using 80% CPU.
This started after we added 2 new agents. How do I diagnose if this
is normal increased load or a problem?"
```

**Use Multiline for Complex Issues:**
```bash
You > /multiline

Enter your message (press Ctrl+D when done):
I'm getting this error when trying to restart httpd:

Job for httpd.service failed because the control process exited
with error code.
See "systemctl status httpd.service" and "journalctl -xe" for details.

The logs show:
[ssl:warn] [pid 12345] AH01906: server.example.com:443:0 server certificate does not include an ID which matches the server name

How do I fix this?
[Press Ctrl+D]
```

### When to Use Each Tool

**Interactive AI (llama):**
- Complex problems requiring back-and-forth
- Learning new concepts
- Exploring multiple solutions
- When you need detailed explanations

**Quick Queries (ask-ai):**
- Simple command syntax questions
- Quick fact lookups
- When you know exactly what you need
- One-off questions

**Specialized Analysis:**
- Wazuh alerts → `ai-analyze-wazuh`
- Log files → `ai-analyze-logs`
- Problems → `ai-troubleshoot`

**AnythingLLM Web UI:**
- Analyzing documents or long text
- When you prefer visual interface
- Multiple related questions in sequence
- Accessing from Mac Mini directly

### Performance Expectations

**Response Times:**
```
Llama 3.3 70B Instruct: 15-45 seconds (normal)
Complex queries: 30-90 seconds
Code generation: 20-60 seconds
```

**Quality:**
```
70B Model: Excellent reasoning, comprehensive answers
Quantization: q5_K_M balances quality and performance
RAM Usage: ~45GB during inference
```

## 15.7 Troubleshooting

### AI Server Not Responding

**Check Connectivity:**
```bash
# Test network connection
ping 192.168.1.7

# Test Ollama service
curl http://192.168.1.7:11434/api/tags

# Expected response: JSON with model list
```

**Check Ollama Service:**
```bash
# SSH to Mac Mini (if you have access)
ssh Admin@192.168.1.7

# Check if Ollama is running
launchctl list | grep ollama

# View Ollama logs
tail -f /tmp/ollama.log

# Restart Ollama
launchctl unload ~/Library/LaunchAgents/com.ollama.server.plist
launchctl load ~/Library/LaunchAgents/com.ollama.server.plist
```

### Slow Responses

**Normal:**
- 15-45 seconds for typical queries (Llama 3.3 70B)
- Longer for complex analysis or code generation

**If Unusually Slow:**
```bash
# Check Mac Mini resources (from Mac Mini)
top
# Look for: CPU usage, memory usage

# Close unnecessary applications on Mac Mini
# Restart Ollama service if needed
```

### Model Not Found Error

**Check Available Models:**
```bash
# List models on server
curl -s http://192.168.1.7:11434/api/tags | jq -r '.models[].name'

# Expected output:
# codellama:7b
# (possibly codellama:13b, codellama:34b)
```

**Re-download Model (from Mac Mini):**
```bash
# SSH to Mac Mini
ssh Admin@192.168.1.7

# Pull model again
ollama pull llama3.3:70b-instruct-q5_K_M

# Takes 30-60 minutes (~40GB download)
```

### Command Not Found

**Install AI Tools (if missing):**
```bash
# Tools should be in /usr/local/bin/
ls -la /usr/local/bin/ask-ai
ls -la /usr/local/bin/ai-*

# If missing, contact administrator
# Installation requires Mac Mini M4 setup first
```

---

**AI Assistant Quick Reference:**

**Interactive Chat:**
- Command: `llama` or `ai`
- Use for: Complex questions, learning, exploration
- Response time: 10-30 seconds

**Quick Queries:**
- Command: `ask-ai "question"`
- Use for: Simple questions, command syntax
- Response time: 15-30 seconds

**Security Analysis:**
- Command: `ai-analyze-wazuh [count]`
- Use for: Security alert triage
- Response time: 30-60 seconds

**Log Analysis:**
- Command: `ai-analyze-logs [file] [lines]`
- Use for: Log file investigation
- Response time: 20-45 seconds

**Troubleshooting:**
- Command: `ai-troubleshoot "problem"`
- Use for: Diagnostic guidance
- Response time: 20-45 seconds

**Web Interface:**
- Access: http://192.168.1.7 (from Mac Mini)
- Use for: Visual interface, document analysis
- Features: Workspaces, history, copy-paste

**AI Server:**
- Location: Mac Mini M4 Pro (192.168.1.7)
- Model: Llama 3.3 70B Instruct (q5_K_M)
- Service: Ollama (port 11434)
- Network: Air-gapped (local only)

**Compliance:**
- ✅ NIST 800-171 compliant
- ✅ No CUI access by AI
- ✅ Human-in-the-loop required
- ✅ Full audit trail
- ✅ No internet dependency

**Best Practices:**
- Be specific with questions
- Provide context for complex issues
- Review AI recommendations before executing
- Log all administrative actions
- Use appropriate tool for task

**Remember:**
The AI provides recommendations; you decide and execute!

---

**Related Chapters:**
- Chapter 10: Getting Help
- Chapter 17: Wazuh Security Monitoring
- Chapter 21: Graylog Log Analysis
- Chapter 22: Incident Response
- Appendix C: Command Reference

**For AI Issues:**
- Server connectivity: ping 192.168.1.7
- Service status: curl http://192.168.1.7:11434/api/tags
- Administrator: dshannon@cyberinabox.net
- Documentation: /home/dshannon/Documents/Claude/Interactive AI/

**Note on Development:**
This system uses Llama 3.3 70B Instruct running locally. During Phase I development,
Claude Code (an internet-connected AI from Anthropic) was used as a
development tool but is not part of the production system due to
compliance requirements. See Chapter 2 for details on development tools.

---

## 15.8 SysAdmin Agent Dashboard

### Overview

The **SysAdmin Agent Dashboard** is a web-based AI-assisted administration interface that provides Claude Code-like functionality entirely on the local network. It integrates with the Llama 3.3 70B model to provide intelligent system administration assistance.

**Access URL:** `https://dc1.cyberinabox.net/sysadmin/`

**Key Features:**
- Web-based interface (no terminal required)
- AI-powered system monitoring
- Security alerts and analysis
- Compliance scanning (NIST 800-171)
- Human-in-the-loop approval workflow
- Full audit logging
- No internet dependency

### Dashboard Sections

**Quick Actions:**
```
Monitoring:
  - Check Server Health (CPU, memory, disk, uptime)
  - View Recent Logs
  - List Running Services
  - Check Disk Usage
  - System Update Status

Security:
  - Wazuh Alerts
  - Suricata IDS Alerts
  - YARA Malware Status
  - Run YARA Scan (requires approval)
  - Security Services Status
  - Graylog Logs
  - Prometheus Metrics
  - USB Access Control

Compliance:
  - Compliance Status
  - Scan DC1 Server (requires approval)
  - Scan Workstations (requires approval)
  - View Reports

Maintenance (all require approval):
  - Apply Security Updates
  - Full System Update
  - Backup to NAS
  - Restart Service
```

**Dashboard Links:**
Quick access to other management interfaces:
- FreeIPA Admin
- Wazuh SIEM
- Graylog Logs
- Grafana Metrics
- Prometheus
- Policy Index
- NextCloud

### AI Assistant Chat

The dashboard includes an AI chat interface powered by the local Llama 3.3 70B:

```
You: What are the most common Wazuh alerts today?

AI: Based on the recent alerts, here are the most common:
    1. SSH Authentication failures (12 occurrences)
    2. File integrity changes (8 occurrences)
    3. Sudo command execution (6 occurrences)

    The SSH failures are from IP 203.0.113.45. Consider blocking...
```

**USB Control via Chat:**
```
You: usb status
AI: [Shows connected USB devices and their status]

You: enable usb 5
AI: [Requests approval to allow USB device ID 5]

You: block all usb
AI: [Blocks all USB storage devices]
```

### Approval Workflow

High-risk operations require explicit approval:

```
⚠️ APPROVAL REQUIRED

Context: Apply security updates (dnf update --security)

Command to execute:
  sudo dnf update --security -y

This action requires your explicit approval before execution.

[✅ Approve & Execute]  [❌ Cancel]
```

**Actions Requiring Approval:**
- Service restarts (systemctl start/stop/restart)
- Package updates (dnf install/update/remove)
- System reboots
- Firewall changes
- Compliance scans
- USB device changes
- File edits (Code Assistant)

### Audit Logging

All dashboard actions are logged:

**Log Location:** `/data/ai-workspace/sysadmin-agent/logs/agent_audit.log`

**Log Format:**
```json
{
  "timestamp": "2026-01-29T13:45:23.456789",
  "event_type": "TILE_CLICKED",
  "details": "Tile: wazuh_alerts",
  "user": "admin"
}
```

**Event Types:**
- `TILE_CLICKED` - Dashboard button clicked
- `USER_QUERY` - Chat message sent
- `COMMAND_EXECUTED` - Low-risk command run
- `APPROVED_COMMAND_EXECUTED` - High-risk command approved and run
- `CODE_ASSISTANT_QUERY` - Code question asked
- `CODE_ASSISTANT_APPROVED` - File edit or command approved
- `CODE_ASSISTANT_REJECTED` - Action rejected by user

---

## 15.9 Code Assistant (Terminal AI Integration)

### Overview

The **Code Assistant** is a Claude Code-like feature within the SysAdmin Agent Dashboard. It allows the AI to:

- Answer questions about code and configuration files
- Browse and view files in allowed directories
- Analyze log output with AI interpretation
- Edit files directly (with human approval)

**Access:** Expand "🖥️ Code Assistant (Terminal AI Integration)" in the dashboard

**NIST 800-171 Compliance:**
- ✅ All file modifications require human approval
- ✅ All actions logged to audit trail
- ✅ Restricted to allowed directories only
- ✅ No internet connectivity required
- ✅ Human-in-the-loop for all changes

### Code Assistant Tabs

#### Tab 1: Ask About Code

**Purpose:** Ask questions about code or configurations (read-only)

**Approval Required:** No (queries are logged but don't modify anything)

**Usage:**
1. Select files for context (optional)
2. Type your question
3. Click "Ask AI"

**Example:**
```
Selected Files: /data/ai-workspace/sysadmin-agent/app.py

Question: How does the approval workflow work in this file?

AI Response:
The approval workflow is implemented through session state variables:
1. `st.session_state.pending_command` stores the command awaiting approval
2. `st.session_state.show_approval_dialog` triggers the approval UI
3. When approved, `execute_approved_command()` runs the command
4. All actions are logged via `log_audit_event()`
...
```

#### Tab 2: Browse Files

**Purpose:** Navigate and view files in allowed directories

**Approval Required:** No (read-only operations)

**Allowed Directories:**
```
/data/ai-workspace       - AI workspace and dashboard
/etc/fapolicyd           - Application whitelisting config
/etc/usbguard            - USB security config
/etc/yara                - YARA malware rules
/etc/httpd/conf.d        - Apache configuration
/var/www                 - Web content
/opt/aider-api           - Aider API service
/home                    - User home directories
/root                    - Root home directory
```

**Features:**
- Navigate directories
- View file contents
- Select files for AI context
- Quick access buttons for common directories

#### Tab 3: Analyze Logs

**Purpose:** Execute whitelisted commands and get AI analysis

**Approval Required:** Yes (executes commands)

**Available Analysis Types:**
```
wazuh_alerts       - Analyze Wazuh security alerts
secure_logs        - Analyze authentication logs
audit_logs         - Analyze audit logs
system_messages    - Analyze system messages for errors
apache_errors      - Analyze Apache error logs
journal_errors     - Analyze recent journal errors
top_processes      - Analyze top processes
disk_usage         - Analyze disk usage
memory_usage       - Analyze memory usage
failed_logins      - Analyze failed login attempts
ipa_status         - Analyze FreeIPA status
firewall_status    - Analyze firewall configuration
```

**Workflow:**
1. Select analysis type
2. Enter what AI should look for
3. Click "Analyze"
4. **Approve** the command execution
5. View results and AI interpretation

**Example:**
```
Analysis Type: wazuh_alerts
AI Prompt: Look for any critical security issues or patterns

[Approve] clicked

Command Output:
[Wazuh alert data...]

AI Analysis:
Based on the alerts, I found:
1. Multiple failed SSH attempts from 203.0.113.15 (potential brute force)
2. File integrity change in /etc/shadow (password change)
3. Elevated privilege usage by user jsmith

Recommendations:
- Consider blocking IP 203.0.113.15
- Verify the password change was authorized
- Review jsmith's sudo activity
```

#### Tab 4: Edit Files

**Purpose:** Have AI edit files based on instructions

**Approval Required:** Yes (ALL file modifications require approval)

**Workflow:**
1. Select files to edit (from Browse tab)
2. Enter edit instructions
3. Click "Request Edit"
4. **Review and Approve** the changes
5. AI applies the edits

**Example:**
```
Selected Files: /data/ai-workspace/sysadmin-agent/config/config.py

Edit Instruction: Add a new dashboard tile for SSL certificate monitoring

⚠️ APPROVAL REQUIRED FOR CODE ASSISTANT ACTION

File Edit Request

Files to modify:
- /data/ai-workspace/sysadmin-agent/config/config.py

Edit instruction: Add a new dashboard tile for SSL certificate monitoring

⚠️ This will modify the above files!

[✅ Approve]  [❌ Reject]
```

### Security Features

**Restricted Directories:**
Files outside allowed directories cannot be accessed:
```
Error: Path not allowed: /etc/shadow
```

**Allowed File Extensions:**
```
.py, .sh, .bash, .yml, .yaml, .json, .conf, .cfg,
.md, .txt, .html, .css, .js, .xml, .ini, .rules,
.service, .timer, .socket, .yar, .yara
```

**Audit Trail:**
Every Code Assistant action is logged:
```
CODE_ASSISTANT_QUERY - All questions asked
CODE_ASSISTANT_FILE_READ - File views
CODE_ASSISTANT_APPROVED - Approved actions
CODE_ASSISTANT_REJECTED - Rejected actions
CODE_ASSISTANT_EDIT_COMPLETE - Successful edits
```

### Best Practices

**For Asking Questions:**
- Be specific about what you want to know
- Include relevant files in context
- Reference specific line numbers or functions

**For Log Analysis:**
- Start with broad analysis prompts
- Narrow down based on initial findings
- Review command output before AI analysis

**For File Edits:**
- Always review the edit instruction carefully
- Start with small, focused changes
- Test changes after approval
- Keep backups of critical files

### Troubleshooting

**"Aider API Offline" Error:**
```bash
# Check service status
sudo systemctl status aider-api

# Start if stopped
sudo systemctl start aider-api

# View logs
journalctl -u aider-api -n 50
```

**File Not in Allowed Directory:**
```
Only directories in the whitelist can be accessed.
Contact administrator to add new directories if needed.
```

**Edit Fails:**
```
Check:
1. File exists and is writable
2. File extension is in allowed list
3. Aider API is running
4. AI server (192.168.1.7) is accessible
```

---

## 15.10 AI Integration Summary

### Available AI Interfaces

| Interface | Access | Best For |
|-----------|--------|----------|
| **SysAdmin Dashboard** | https://dc1.cyberinabox.net/sysadmin/ | Web-based administration, monitoring |
| **Code Assistant** | Dashboard → Code Assistant | File editing, code questions |
| **Interactive CLI** | `llama` or `ai` | Complex terminal conversations |
| **Quick Query** | `ask-ai "question"` | One-off questions |
| **Wazuh Analysis** | `ai-analyze-wazuh` | Security alert triage |
| **Log Analysis** | `ai-analyze-logs` | Log file investigation |
| **Troubleshooting** | `ai-troubleshoot` | Problem diagnosis |

### Compliance Summary

All AI interfaces maintain NIST 800-171 compliance:

```
✅ No CUI data sent to external servers (air-gapped)
✅ Human-in-the-loop for all system changes
✅ Full audit trail of all actions
✅ Least privilege (restricted directories/commands)
✅ No internet dependency
✅ Local model (Llama 3.3 70B on 192.168.1.7)
```

### Quick Reference

**Dashboard URL:** `https://dc1.cyberinabox.net/sysadmin/`

**Services:**
```bash
# SysAdmin Dashboard
systemctl status sysadmin-agent

# Aider API (Code Assistant backend)
systemctl status aider-api

# AI Model Server
curl http://192.168.1.7:11434/api/tags
```

**Logs:**
```bash
# Dashboard audit log
/data/ai-workspace/sysadmin-agent/logs/agent_audit.log

# Dashboard service log
journalctl -u sysadmin-agent -f

# Aider API log
journalctl -u aider-api -f
```
