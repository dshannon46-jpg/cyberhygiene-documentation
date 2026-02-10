# Command Approval System - Security Protocol

## Overview

The CyberHygiene AI Admin Assistant now includes a **mandatory command approval system** that requires explicit user authorization before executing ANY system command.

##  Security Features

### ✅ Mandatory Approval
- **EVERY command** requires user approval
- No automatic execution - even for "safe" commands
- AI must explain WHY it wants to run the command
- User sees exactly what will be executed

### ✅ Comprehensive Audit Trail
All approval decisions are logged with:
- Command being requested
- AI's reason for the command
- Timestamp of request
- User who made the decision
- Approval or denial decision
- Time taken to make decision
- Session ID
- Hostname
- Process ID

### ✅ Auto-Deny on Error
- If no approval callback is configured: AUTO-DENY
- If user doesn't respond within timeout: AUTO-DENY
- If any error occurs: AUTO-DENY
- Default is ALWAYS to deny for safety

## How It Works

### CLI Mode

1. User asks AI a question
2. AI determines it needs to run a command
3. **Approval prompt appears** with:
   - Command to be executed
   - AI's reason for running it
   - Timestamp
4. User approves or denies
5. Decision logged to audit trail
6. If approved: command executes
7. If denied: AI receives error message

### Web Mode

1. User asks AI a question via chat
2. AI determines it needs to run a command
3. **Modal dialog appears** with:
   - Command to be executed
   - AI's reason for running it
   - Approve/Deny buttons
4. User clicks button
5. Decision sent via WebSocket
6. Decision logged to audit trail
7. Command executes only if approved

## Audit Trail Format

Every approval interaction creates multiple audit log entries:

### 1. Approval Request
```json
{
  "timestamp": "2026-01-03T11:30:45.123456",
  "event_type": "APPROVAL_REQUESTED",
  "user": "dshannon",
  "data": {
    "command": "systemctl status wazuh-manager",
    "reason": "User asked to check Wazuh status",
    "timestamp": "2026-01-03T11:30:45.123456",
    "user": "dshannon",
    "session_id": "20260103_113045",
    "hostname": "dc1.cyberinabox.net",
    "pid": 12345
  }
}
```

### 2. Approval Decision
```json
{
  "timestamp": "2026-01-03T11:30:48.456789",
  "event_type": "APPROVAL_GRANTED",  // or APPROVAL_DENIED
  "user": "dshannon",
  "data": {
    "command": "systemctl status wazuh-manager",
    "reason": "User asked to check Wazuh status",
    "decision": "APPROVED",  // or "DENIED"
    "approved": true,  // or false
    "approval_timestamp": "2026-01-03T11:30:48.456789",
    "duration_ms": 3333,
    "denial_reason": null,  // or reason if denied
    "hostname": "dc1.cyberinabox.net"
  }
}
```

### 3. Command Execution
```json
{
  "timestamp": "2026-01-03T11:30:48.500000",
  "event_type": "COMMAND_EXECUTE",
  "user": "dshannon",
  "data": {
    "command": "systemctl status wazuh-manager"
  }
}
```

### 4. Command Result
```json
{
  "timestamp": "2026-01-03T11:30:48.650000",
  "event_type": "COMMAND_SUCCESS",
  "user": "dshannon",
  "data": {
    "command": "systemctl status wazuh-manager",
    "exit_code": 0,
    "output_length": 1234
  }
}
```

## Viewing Approval Audit Logs

### All approval activity:
```bash
grep -E "APPROVAL_(REQUESTED|GRANTED|DENIED)" ~/cyberhygiene-ai-admin/logs/audit.log | python3 -m json.tool
```

### Approvals only:
```bash
grep "APPROVAL_GRANTED" ~/cyberhygiene-ai-admin/logs/audit.log
```

### Denials only:
```bash
grep "APPROVAL_DENIED" ~/cyberhygiene-ai-admin/logs/audit.log
```

### Today's approvals:
```bash
grep "APPROVAL_" ~/cyberhygiene-ai-admin/logs/audit.log | grep "$(date +%Y-%m-%d)"
```

### Specific command:
```bash
grep "APPROVAL_" ~/cyberhygiene-ai-admin/logs/audit.log | grep "systemctl"
```

### Approval statistics:
```bash
echo "Total Requests: $(grep -c 'APPROVAL_REQUESTED' ~/cyberhygiene-ai-admin/logs/audit.log)"
echo "Approved: $(grep -c 'APPROVAL_GRANTED' ~/cyberhygiene-ai-admin/logs/audit.log)"
echo "Denied: $(grep -c 'APPROVAL_DENIED' ~/cyberhygiene-ai-admin/logs/audit.log)"
```

## Testing the Approval System

### CLI Test:
```bash
cd ~/cyberhygiene-ai-admin
./cyberai-cli
```

Then try:
```
You: What's the system uptime?
```

You should see:
1. AI thinking message
2. **Approval prompt** appears showing the command
3. You approve (y) or deny (n)
4. If approved: AI shows the result
5. If denied: AI explains it was denied

### View the audit log:
```bash
tail -f ~/cyberhygiene-ai-admin/logs/audit.log
```

## Example Interaction

```
You: What's the CPU usage?

AI: [Thinking...]

╭─────────── ⚠️  Authorization Request ───────────╮
│                                                  │
│ Command Approval Required                       │
│                                                  │
│ Command: df -h                                   │
│ Reason: Checking system disk usage to report    │
│ Time: 2026-01-03T11:30:45.123456                │
│                                                  │
│ This command will be executed on your system    │
│ and logged in the audit trail.                  │
│                                                  │
╰──────────────────────────────────────────────────╯

Do you authorize this command? (y/n): y

✓ Command authorized

AI: Current disk usage:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        89G   21G   68G  24% /
```

## Security Benefits

1. **No Surprise Commands**: You see every command before it runs
2. **Explainability**: AI must explain why it wants to run the command
3. **Full Audit Trail**: Complete record of what was requested and decided
4. **Compliance**: Meets requirements for authorized system access
5. **User Control**: You're always in control of what executes
6. **Safe by Default**: If anything goes wrong, default is to deny

## Compliance Value

This approval system provides:
- **Accountability**: Every command ties to a user decision
- **Traceability**: Full audit trail for compliance reviews
- **Authorization**: Explicit approval before privileged actions
- **Non-repudiation**: Timestamped records of approvals
- **Principle of Least Privilege**: No automatic execution rights

Perfect for NIST 800-171, CMMC, and other compliance frameworks!

## Files

- **Approval Logic**: `/home/dshannon/cyberhygiene-ai-admin/core/approval.py`
- **CLI Integration**: `/home/dshannon/cyberhygiene-ai-admin/cli/interactive.py`
- **Web Integration**: `/home/dshannon/cyberhygiene-ai-admin/web/app.py`
- **System Tools**: `/home/dshannon/cyberhygiene-ai-admin/tools/system_tools.py`
- **Audit Logs**: `/home/dshannon/cyberhygiene-ai-admin/logs/audit.log`

## Future Enhancements

Potential additions:
- Pre-approved command whitelist (still logged)
- Role-based approval (different users, different permissions)
- Multi-person approval for critical commands
- Approval delegation
- Time-limited approvals
- Approval workflow management UI
