# AI-Enhanced Dashboard Guide

## Overview

Your System Status Dashboard now has an **embedded AI assistant** that can answer questions and run commands directly from the dashboard interface!

## What's New

### Floating AI Chat Button
- Located in the **bottom-right corner** (🤖 icon)
- Click to open/close the chat panel
- Always accessible without leaving the dashboard

### AI Chat Panel Features
1. **Quick Command Buttons**: One-click common tasks
   - 📊 Status - System status
   - 🛡️ Wazuh - Check Wazuh SIEM
   - 🔐 FreeIPA - Check FreeIPA domain
   - 💾 Disk - Disk usage
   - 📄 Logs - Recent logs

2. **Chat Interface**: Natural language queries
   - "What's the CPU usage?"
   - "Is Wazuh running correctly?"
   - "Show me authentication failures"
   - "Check for pending updates"

3. **Live System Metrics** (auto-updating)
   - CPU usage
   - Memory usage
   - Disk usage
   - System uptime

## How to Use

### Start the Dashboard

```bash
cd ~/cyberhygiene-ai-admin
./cyberai-web
```

Then open your browser to: **http://192.168.1.10:5000**

### Using the AI Assistant

1. **Click the 🤖 button** in the bottom-right corner
2. **Chat panel opens** with quick action buttons
3. **Click a quick button** or type your question
4. **AI responds** with real command output

### Example Workflow

```
1. Open dashboard in browser
2. See system overview and service status
3. Click 🤖 to open AI chat
4. Click "🛡️ Wazuh" quick button
5. AI runs: systemctl status wazuh-manager
6. See real-time status in chat
7. Ask follow-up: "Show me recent alerts"
8. Continue browsing dashboard while chatting
```

## Comparison: Old vs New

### Old Dashboard (Static)
❌ Shows command to run: `df -h`
❌ You copy and paste to terminal
❌ No real-time data
❌ Reference only

### New Dashboard (AI-Enhanced)
✅ AI runs `df -h` for you
✅ Shows results instantly in chat
✅ Live system metrics
✅ Interactive + Reference combined

## Available Interfaces

You now have **3 ways** to interact with the AI:

### 1. **Dashboard with AI Widget** (Recommended)
```bash
./cyberai-web
# http://192.168.1.10:5000
```
- **Best for**: Monitoring + occasional AI queries
- Full dashboard + floating chat
- See overview while asking questions

### 2. **Full-Screen Chat**
```bash
./cyberai-web
# http://192.168.1.10:5000/fullscreen-chat
```
- **Best for**: Extended AI conversations
- Dedicated chat interface
- More space for complex queries

### 3. **CLI Mode**
```bash
./cyberai-cli
```
- **Best for**: SSH sessions, terminal users
- Full terminal interface
- Rich text formatting

## Quick Commands to Try

Once the chat panel is open:

**System Health:**
- "What's the overall system health?"
- "Show me CPU and memory usage"
- "Which services are using the most resources?"

**Security:**
- "Check Wazuh for alerts"
- "Any failed login attempts?"
- "Show me SELinux status"

**Services:**
- "Is FreeIPA running?"
- "Check all systemd services"
- "Show me DNS server status"

**Logs:**
- "Show last 50 lines of /var/log/secure"
- "Any errors in system logs?"
- "Check Wazuh alerts from today"

**Updates:**
- "Are there pending updates?"
- "When was the last update?"
- "Check dnf history"

## Tips

1. **Keep dashboard open**: Chat panel doesn't block the view
2. **Use quick buttons**: Faster than typing for common tasks
3. **Ask follow-ups**: AI remembers context
4. **Scroll chat**: Full conversation history available
5. **Live metrics**: Top metrics auto-update every 30 seconds

## Troubleshooting

### Chat button not responding?
Check the web server is running:
```bash
cd ~/cyberhygiene-ai-admin
./cyberai-web
```

### No AI responses?
Verify Ollama connection:
```bash
curl http://192.168.1.7:11434/api/tags
```

### Metrics not updating?
Check API endpoint:
```bash
curl http://localhost:5000/api/status
```

## Architecture

```
Browser Dashboard (Port 5000)
├── Static Content (HTML/CSS/JS)
├── AI Chat Widget (Bottom right)
├── WebSocket Connection
│   └── Flask Backend
│       └── CyberHygiene AI Agent
│           └── CodeLlama 34B @ 192.168.1.7
└── Live System Metrics (API)
```

## Security

- Same security controls as CLI mode
- Command whitelisting active
- Audit logging enabled
- Approval required for sensitive commands
- No destructive commands allowed

## What's Next?

1. **Try the dashboard**: Start with quick buttons
2. **Ask questions**: Use natural language
3. **Explore**: Compare with old static dashboard
4. **Customize**: Edit `web/templates/dashboard.html` for your needs

The AI assistant runs the same commands you would run manually, but faster and with intelligent context!
