# CyberHygiene AI Admin Assistant

An AI-powered system administration assistant for NIST 800-171 compliant Rocky Linux 9 environments, powered by CodeLlama 34B running on your local Ollama server.

## Features

- **Conversational AI Interface**: Natural language system administration
- **Dual Interface**: Both CLI (terminal) and Web (browser) interfaces
- **Security-First**: Command whitelisting, audit logging, approval workflows
- **System Monitoring**: Real-time CPU, memory, disk, and network status
- **Log Analysis**: Intelligent log parsing and analysis
- **Service Management**: Monitor and manage system services
- **Compliance Focused**: Built for NIST 800-171/CMMC environments

## Architecture

```
┌─────────────────────────────────────────────────┐
│    CodeLlama 34B @ 192.168.1.7:11434           │
│    (M4 Mac Mini - 64GB RAM, 14 CPUs)           │
└────────────────┬────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────┐
│         Core AI Agent (LangChain)               │
│  - Tool system (bash, file ops, monitoring)    │
│  - Security controls & audit logging           │
│  - Command whitelisting & approval             │
└────────┬─────────────────────────┬──────────────┘
         │                         │
    ┌────▼─────┐            ┌─────▼──────┐
    │   CLI    │            │    Web     │
    │ (Rich)   │            │ (Flask +   │
    │  Mode    │            │ SocketIO)  │
    └──────────┘            └────────────┘
```

## Installation

Already completed! The system is installed at:
```bash
/home/dshannon/cyberhygiene-ai-admin/
```

## Usage

### CLI Mode (Terminal Interface)

Start the interactive CLI:
```bash
cd ~/cyberhygiene-ai-admin
./cyberai-cli
```

**Available Commands:**
- `/help` - Show help message
- `/status` - Quick system status
- `/logs [service]` - View recent logs
- `/history` - Show audit history
- `/clear` - Clear screen
- `/exit` or `/quit` - Exit

**Example Questions:**
- "What's the current system status?"
- "Show me Wazuh service status"
- "Check if there are any pending updates"
- "Show me the last 50 lines of /var/log/secure"
- "What services are using the most memory?"

### Web Mode (Browser Interface)

Start the web dashboard:
```bash
cd ~/cyberhygiene-ai-admin
./cyberai-web
```

Then open your browser to:
```
http://192.168.1.10:5000
```

**Features:**
- Real-time chat interface
- System status sidebar
- Quick command buttons
- Live system metrics

## Security Features

### Command Whitelisting
Only approved commands can be executed:
- System status commands (systemctl, df, free, ps, etc.)
- Log viewing (tail, journalctl, cat /var/log/*, etc.)
- Security monitoring (ausearch, wazuh-control, etc.)
- Read-only package management (dnf check-update, rpm -qa, etc.)

### Forbidden Commands
Destructive commands are blocked:
- File deletion (rm -rf, etc.)
- Disk operations (dd, mkfs, fdisk, etc.)
- Service stopping
- Firewall rule removal
- User deletion

### Approval Workflow
Sensitive commands require explicit approval:
- Service restarts
- Package installation/removal
- File permission changes
- Firewall rule additions

### Audit Logging
All actions are logged to:
```bash
/home/dshannon/cyberhygiene-ai-admin/logs/audit.log
```

Each log entry includes:
- Timestamp
- Event type
- User
- Command/action details

## Configuration

Edit configuration in `core/config.py`:

```python
# Ollama server settings
ollama.host = "http://192.168.1.7:11434"
ollama.model = "codellama:34b"

# Security settings
security.allowed_commands = [...]
security.forbidden_commands = [...]
security.require_approval_for = [...]
```

## Project Structure

```
cyberhygiene-ai-admin/
├── core/
│   ├── config.py          # Configuration
│   └── agent.py           # Core AI agent (LangChain + Ollama)
├── tools/
│   ├── system_tools.py    # System command execution
│   └── audit.py           # Audit logging
├── cli/
│   └── interactive.py     # CLI interface (Rich)
├── web/
│   ├── app.py            # Web server (Flask + SocketIO)
│   └── templates/
│       └── index.html    # Web dashboard
├── logs/
│   └── audit.log         # Audit trail
├── cyberai-cli           # CLI launcher
├── cyberai-web           # Web launcher
└── README.md
```

## Example Workflows

### Check System Health
```
You: What's the overall system health?

Agent: Let me check the current system status...
[Executes: get_system_status()]

System Status:
- CPU: 15.2% (8 cores)
- Memory: 45.3% used (3.6GB / 8GB)
- Disk: 62% used (124GB / 200GB)
- Uptime: 156.3 hours
- Load Average: 0.89, 0.72, 0.68

All systems operational!
```

### Troubleshoot Service
```
You: Is Wazuh running correctly?

Agent: Checking Wazuh SIEM status...
[Executes: systemctl status wazuh-manager]

Wazuh Manager is active and running.
- Status: active (running)
- Uptime: 5 days
- PID: 1234

Would you like me to check recent alerts?
```

### Analyze Logs
```
You: Show me any failed login attempts today

Agent: Checking security logs for failed authentication...
[Executes: ausearch -m USER_LOGIN -sv no -ts today]

Found 3 failed login attempts:
1. 14:32:15 - User: admin from 192.168.1.50
2. 14:32:18 - User: admin from 192.168.1.50
3. 14:32:22 - User: admin from 192.168.1.50

Recommendation: Investigate source IP 192.168.1.50
```

## Extending the System

### Add New Tools

Edit `core/agent.py` and add to `_create_tools()`:

```python
Tool(
    name="custom_command",
    func=lambda x: your_function(x),
    description="What this tool does"
)
```

### Modify Security Rules

Edit `core/config.py`:

```python
allowed_commands = [
    "your_new_command",  # Add allowed commands
]

forbidden_commands = [
    "dangerous_command",  # Add forbidden patterns
]
```

## Troubleshooting

### Agent fails to connect to Ollama
```bash
# Check Ollama server is running
curl http://192.168.1.7:11434/api/tags

# Verify network connectivity
ping 192.168.1.7
```

### Web interface won't start
```bash
# Check port availability
sudo netstat -tlnp | grep 5000

# Try different port
./cyberai-web 0.0.0.0 5001
```

### View audit logs
```bash
tail -f ~/cyberhygiene-ai-admin/logs/audit.log
```

## Support

For issues or questions:
1. Check logs: `~/cyberhygiene-ai-admin/logs/audit.log`
2. Review configuration: `~/cyberhygiene-ai-admin/core/config.py`
3. Test Ollama connectivity: `curl http://192.168.1.7:11434/api/tags`

## License

This project is part of the CyberHygiene Production Network NIST 800-171 compliance initiative.

## Changelog

### Version 1.0.0 (2026-01-03)
- Initial release
- CLI interface with Rich UI
- Web dashboard with real-time chat
- LangChain + Ollama integration
- Security controls and audit logging
- System monitoring tools
- Command whitelisting/blacklisting
