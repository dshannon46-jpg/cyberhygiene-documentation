# Quick Start Guide

## Installation Complete!

Your CyberHygiene AI Admin Assistant is installed and ready to use.

## Quick Test

Run the test suite to verify everything works:
```bash
cd ~/cyberhygiene-ai-admin
source venv/bin/activate
python3 test_system.py
```

## Launch Options

### Option 1: CLI Mode (Recommended for SSH sessions)

```bash
cd ~/cyberhygiene-ai-admin
./cyberai-cli
```

**CLI Commands:**
- `/help` - Show help
- `/status` - Quick system status
- `/logs wazuh` - View Wazuh logs
- `/history` - Audit history
- `/exit` - Quit

**Example usage:**
```
You: What's the system status?
You: Show me the last 50 lines of /var/log/secure
You: Is FreeIPA running?
You: Check for pending updates
```

### Option 2: Web Dashboard

```bash
cd ~/cyberhygiene-ai-admin
./cyberai-web
```

Then open browser to: **http://192.168.1.10:5000**

## Example Questions to Ask

### System Monitoring
- "What's the current CPU and memory usage?"
- "Show me disk usage"
- "What's the system uptime?"
- "Which processes are using the most resources?"

### Service Status
- "Is Wazuh running?"
- "Check FreeIPA status"
- "Show me all running services"
- "Is the RAID array healthy?"

### Log Analysis
- "Show me recent security logs"
- "Any failed login attempts today?"
- "Check Wazuh alerts from the last hour"
- "Show me authentication errors"

### Security & Compliance
- "Check FIPS mode status"
- "Show SELinux status"
- "Are there any pending security updates?"
- "Check file integrity monitoring status"

## Security Features

✅ **Command Whitelisting**: Only safe commands allowed
✅ **Audit Logging**: All actions logged to `logs/audit.log`
✅ **Approval Workflow**: Sensitive commands require confirmation
✅ **No Destructive Actions**: Dangerous commands blocked

## Files to Know

```
~/cyberhygiene-ai-admin/
├── cyberai-cli           # Launch CLI
├── cyberai-web          # Launch web dashboard
├── test_system.py       # Test script
├── README.md            # Full documentation
├── logs/audit.log       # Audit trail
└── core/config.py       # Configuration
```

## Troubleshooting

### Can't connect to Ollama?
```bash
curl http://192.168.1.7:11434/api/tags
ping 192.168.1.7
```

### View audit logs:
```bash
tail -f ~/cyberhygiene-ai-admin/logs/audit.log
```

### Web dashboard port in use?
```bash
./cyberai-web 0.0.0.0 5001  # Use different port
```

## What's Next?

1. **Try the CLI**: Start with simple queries
2. **Explore the Web UI**: Great for visual monitoring
3. **Review Audit Logs**: See what the AI is doing
4. **Customize**: Edit `core/config.py` to add more commands

## Support

- Full docs: `~/cyberhygiene-ai-admin/README.md`
- Configuration: `~/cyberhygiene-ai-admin/core/config.py`
- Audit logs: `~/cyberhygiene-ai-admin/logs/audit.log`

Enjoy your AI-powered system administration! 🤖
