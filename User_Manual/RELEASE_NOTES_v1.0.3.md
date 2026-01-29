# CyberHygiene User Manual - Version 1.0.3

**Release Date:** January 29, 2026
**Release Type:** MINOR - New Feature Documentation
**Status:** Production Ready

---

## Overview

Version 1.0.3 documents the new **SysAdmin Agent Dashboard** and **Code Assistant** features, providing Claude Code-like AI integration capabilities entirely on the local network while maintaining NIST 800-171 compliance.

---

## What's New

### SysAdmin Agent Dashboard (Section 15.8)

A new web-based AI-assisted administration interface accessible at:
**https://dc1.cyberinabox.net/sysadmin/**

**Features Documented:**
- Dashboard quick actions (monitoring, security, compliance, maintenance)
- AI-powered chat interface with Llama 3.3 70B
- Human-in-the-loop approval workflow for high-risk operations
- USB device control via chat commands
- Direct links to all management dashboards
- Full audit logging for NIST compliance

### Code Assistant (Section 15.9)

Terminal AI integration providing Claude Code-like functionality:

**Features Documented:**
- **Ask About Code** - AI-powered code questions (read-only, no approval needed)
- **Browse Files** - Navigate and view files in allowed directories
- **Analyze Logs** - Execute whitelisted commands with AI analysis (requires approval)
- **Edit Files** - AI-assisted file editing (requires approval)

**Security Features:**
- All file modifications require explicit human approval
- Restricted to whitelisted directories only
- Complete audit trail of all actions
- No internet dependency (uses local Llama 3.3 70B)

### AI Integration Summary (Section 15.10)

New summary section providing:
- Quick reference table of all AI interfaces
- Compliance summary
- Service status commands
- Log file locations

---

## Changes to Existing Documentation

### Chapter 15: AI Assistant
- Added Section 15.8: SysAdmin Agent Dashboard (+200 lines)
- Added Section 15.9: Code Assistant (Terminal AI Integration) (+250 lines)
- Added Section 15.10: AI Integration Summary (+50 lines)

### Table of Contents
- Updated version to 1.0.3
- Added new sections 15.8, 15.9, 15.10
- Added cross-reference note in Part IV pointing to SysAdmin Dashboard

---

## Technical Details

### New Services Documented

| Service | Port | Purpose |
|---------|------|---------|
| sysadmin-agent | 8501 | Streamlit dashboard (proxied via Apache) |
| aider-api | 5001 | Code Assistant backend API |

### Audit Log Locations

```
/data/ai-workspace/sysadmin-agent/logs/agent_audit.log
```

### New Event Types Logged

- `CODE_ASSISTANT_QUERY` - Code questions asked
- `CODE_ASSISTANT_FILE_READ` - File views
- `CODE_ASSISTANT_APPROVED` - Approved edit/execute actions
- `CODE_ASSISTANT_REJECTED` - Rejected actions
- `CODE_ASSISTANT_EDIT_COMPLETE` - Successful file edits

---

## NIST 800-171 Compliance

All new features maintain full compliance:

| Control | Implementation |
|---------|----------------|
| AC-3 (Access Enforcement) | Human approval required for all changes |
| AU-2 (Audit Events) | All actions logged with timestamps |
| AU-3 (Audit Content) | User, action, and outcome recorded |
| SC-7 (Boundary Protection) | Air-gapped, local network only |

---

## Upgrade Notes

No user action required. Documentation update only.

**For Administrators:**
- SysAdmin Agent Dashboard: `systemctl status sysadmin-agent`
- Code Assistant API: `systemctl status aider-api`
- Both services should already be running

---

## Related Documentation

- Chapter 15: AI Assistant (complete AI documentation)
- Part IV: Dashboards & Monitoring (cross-reference added)
- Appendix B: Service URLs (includes sysadmin dashboard URL)

---

## Version History

| Version | Date | Type | Description |
|---------|------|------|-------------|
| 1.0.3 | 2026-01-29 | MINOR | SysAdmin Dashboard & Code Assistant documentation |
| 1.0.2 | 2026-01-26 | PATCH | Technical reference updates |
| 1.0.1 | 2026-01-01 | PATCH | Claude Code vs Code Llama correction |
| 1.0.0 | 2025-12-31 | MAJOR | Initial release |
