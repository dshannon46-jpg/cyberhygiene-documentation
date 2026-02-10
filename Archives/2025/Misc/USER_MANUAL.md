# SysAdmin Agent Dashboard - User Manual

**Version:** 2.0
**Last Updated:** January 31, 2026
**CMMC Level 2 / NIST 800-171 Compliant**

---

## Table of Contents

1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [Dashboard Interface](#dashboard-interface)
4. [AI Assistant](#ai-assistant)
5. [Explainable AI Features](#explainable-ai-features)
6. [Security Alerts](#security-alerts)
7. [AI Evaluation & Feedback](#ai-evaluation--feedback)
8. [Compliance Reporting](#compliance-reporting)
9. [USB Device Management](#usb-device-management)
10. [Troubleshooting](#troubleshooting)

---

## Overview

The SysAdmin Agent Dashboard is a secure, AI-assisted system administration tool designed for CMMC Level 2 and NIST 800-171 compliance. It provides:

- **AI-Powered Analysis**: Intelligent log analysis, security assessment, and system health monitoring
- **Explainable AI**: Transparent AI responses with confidence scores, evidence, and validation steps
- **Human-in-the-Loop**: All high-impact actions require explicit approval
- **Continuous Evaluation**: Feedback collection and model performance tracking
- **Compliance Reporting**: Automated reports for audit documentation

### Key Features

| Feature | Description |
|---------|-------------|
| System Health Monitoring | Real-time CPU, memory, disk, and service status |
| Log Analysis | AI-powered analysis of system, security, and application logs |
| Security Alerts | Automated detection of failed logins, USB violations, data transfers |
| Compliance Scanning | OpenSCAP integration for NIST 800-171 compliance |
| Audit Logging | Complete audit trail of all actions and AI recommendations |

---

## Getting Started

### Accessing the Dashboard

1. Open a web browser and navigate to: `https://dc1.cyberinabox.net/sysadmin/`
2. Authenticate using your domain credentials
3. The dashboard loads with the main tile interface

### First-Time Setup

On first access, the dashboard will:
- Initialize the feedback database
- Check AI connectivity (Llama 3.3 70B)
- Load system health metrics

---

## Dashboard Interface

### Main Tiles

The dashboard presents quick-action tiles for common tasks:

| Tile | Function |
|------|----------|
| System Health | View CPU, memory, disk usage |
| Disk Usage | Detailed partition status |
| Running Services | Check critical service status |
| Security Summary | SELinux, firewall, Wazuh status |
| Log Synopsis | AI-generated summary of recent logs |
| Audit Report | View agent action history |
| Compliance Status | OpenSCAP scan results |

### Sidebar

The sidebar provides:

- **Connection Status**: AI connectivity indicator
- **Security Alerts**: Quick alert scan and counts
- **AI Evaluation**: Response metrics and report access
- **Quick Stats**: CPU, memory, uptime at a glance
- **Actions**: Clear chat, download audit log

---

## AI Assistant

### Using the Chat Interface

The AI Assistant is available at the bottom of the dashboard. You can:

1. **Ask questions** about system status, logs, or configurations
2. **Request analysis** of security events or performance issues
3. **Get recommendations** for troubleshooting

### Example Queries

```
"What's causing high CPU usage?"
"Analyze the last hour of security logs"
"Are there any failed login attempts?"
"What services are currently stopped?"
"Explain the SELinux denials in the audit log"
```

### Command Execution

The AI can suggest commands for you to execute. High-risk commands require approval:

1. AI suggests a command in a code block
2. Approval dialog appears with command details
3. Review the command and context
4. Click **Approve & Execute** or **Reject**

**Note**: Destructive commands (rm -rf, mkfs, etc.) are blocked by policy.

---

## Explainable AI Features

All AI responses include transparency elements for CMMC compliance:

### Response Structure

Every AI analysis includes:

1. **Confidence Assessment**
   - **HIGH (80-100%)**: Strong evidence, clear patterns
   - **MEDIUM (50-79%)**: Moderate evidence, some ambiguity
   - **LOW (<50%)**: Limited evidence, multiple interpretations

2. **Evidence**: Specific log entries, metrics, or observations supporting the analysis

3. **Alternative Hypotheses**: Other plausible explanations to consider

4. **Validation Steps**: Commands or checks to verify the analysis

5. **Human Review Flag**:
   - **REQUIRED**: Security incidents, unusual patterns
   - **RECOMMENDED**: Medium confidence findings
   - **ROUTINE**: High confidence, low risk

### Viewing Explainability Details

After each AI response, click **"AI Explainability Details"** to see:
- Confidence level with color indicator
- Confidence score percentage
- Human review requirement
- Evidence list (top 3 items)
- Validation steps (top 3 items)

### Color Indicators

| Icon | Meaning |
|------|---------|
| 🟢 | HIGH confidence / ROUTINE review |
| 🟡 | MEDIUM confidence / RECOMMENDED review |
| 🔴 | LOW confidence / REQUIRED review |

---

## Security Alerts

### Automated Detection

The system monitors for abnormal events:

| Category | Events Detected |
|----------|-----------------|
| Failed Logins | SSH failures, brute force patterns |
| USB Violations | USBGuard blocks, after-hours attempts |
| Data Transfers | External transfers, large outbound flows |
| SELinux Security | Access to shadow, keys, sudoers |

### Checking for Alerts

1. In the sidebar, find **Security Alerts**
2. Click **"Check for Alerts"**
3. View severity counts (CRITICAL/HIGH/MEDIUM/LOW)
4. Click **"View Alert Details"** for full information

### Alert Details

Each alert includes:
- **Summary**: Brief description of the event
- **Severity**: CRITICAL, HIGH, MEDIUM, LOW
- **Confidence Score**: How certain the detection is
- **Evidence**: Supporting log entries
- **Alternative Hypotheses**: Benign explanations
- **Validation Steps**: How to verify
- **Recommended Action**: Suggested response

---

## AI Evaluation & Feedback

### Providing Feedback

Help improve AI accuracy by rating responses:

1. **Thumbs Up (👍)**: Response was helpful and accurate
2. **Thumbs Down (👎)**: Response had issues (opens feedback form)
3. **Correct (📝)**: Provide correction details

### Feedback Form

When reporting issues, you can specify:

- **Issue Categories**:
  - Factual Error
  - Security Concern
  - Overconfident / Underconfident
  - Missing Context
  - Wrong Hypothesis
  - Incomplete
  - Other

- **Correction Text**: Describe what was wrong
- **Actual Confidence**: What it should have been
- **Actual Outcome**: What really happened

### Viewing Evaluation Reports

1. In sidebar, click **"View Evaluation Report"**
2. Select report period (7/14/30/90 days)
3. View:
   - Performance metrics (response count, feedback rate)
   - Confidence calibration analysis
   - Historical trend charts
   - Top reported issues
   - Archived reports

---

## Compliance Reporting

### Automated Daily Reports

The system generates evaluation reports daily at 6:00 AM:
- Location: `/data/ai-workspace/sysadmin-agent/reports/`
- Format: JSON and Markdown
- Retention: 90 days

### Exporting Compliance Reports

1. In sidebar, click **"Export Compliance Report"**
2. Select report period
3. Preview the report content
4. Download as Markdown or JSON

### Report Contents

Compliance reports include:
- Executive summary
- Human oversight evidence
- Model performance metrics
- Calibration analysis
- Issue tracking
- Recommendations
- Compliance notes for CMMC/NIST

---

## USB Device Management

### Quick Commands

Type these in the chat:

| Command | Action |
|---------|--------|
| `usb status` | Show connected USB devices |
| `enable usb [ID]` | Allow a blocked device (requires approval) |
| `block usb [ID]` | Block a specific device |
| `block all usb` | Block all USB storage devices |

### USBGuard Integration

The dashboard integrates with USBGuard for:
- Real-time device blocking
- Policy-based access control
- Audit logging of all USB events

---

## Troubleshooting

### AI Not Responding

1. Check sidebar for **"AI Connected"** status
2. If offline, verify Ollama service: `systemctl status ollama`
3. Check network connectivity to AI server (192.168.1.7:11443)

### Alerts Not Loading

1. Ensure sufficient permissions for log access
2. Check journald service: `systemctl status systemd-journald`
3. Review `/var/log/messages` for errors

### Feedback Not Saving

1. Verify database file permissions:
   ```bash
   ls -la /data/ai-workspace/sysadmin-agent/database/feedback.db
   ```
2. Check disk space: `df -h`

### Dashboard Not Loading

1. Check service status:
   ```bash
   systemctl status sysadmin-agent.service
   ```
2. View logs:
   ```bash
   journalctl -u sysadmin-agent.service -f
   ```
3. Restart if needed:
   ```bash
   systemctl restart sysadmin-agent.service
   ```

---

## Support

For issues or feature requests:
- Review audit logs for error details
- Check system logs via Log Synopsis
- Contact system administrator

---

*This manual is part of the SysAdmin Agent Dashboard documentation.*
*CMMC Level 2 / NIST 800-171 Compliant*
