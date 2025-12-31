# Local AI Integration - Quick Start Guide
**POA&M-040: AI-Assisted System Administration**
**Date:** December 17, 2025
**Status:** Ready for Deployment

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│  Mac Mini M4 (192.168.1.7) - AI Server              │
│  ┌────────────────────────────────────────────┐     │
│  │ Ollama Service (Port 11434)                │     │
│  │ - Code Llama 7B                            │     │
│  │ - AnythingLLM UI                           │     │
│  │ - Air-gapped (no CUI access)               │     │
│  └────────────────────────────────────────────┘     │
└────────────────┬────────────────────────────────────┘
                 │ HTTP API (local network only)
                 ▼
┌─────────────────────────────────────────────────────┐
│  DC1 (192.168.1.10) - Admin Workstation             │
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

✅ CMMC Compliant: AI has no direct CUI access
✅ Human-in-the-Loop: All commands executed manually
✅ Audit Trail: All actions logged on admin workstation
```

---

## Installation Steps

### Step 1: Install AI Components on Mac Mini M4 (192.168.1.7)

**On the Mac Mini M4, run:**

```bash
# Copy the installation script
scp dshannon@192.168.1.10:/home/dshannon/Documents/Claude/Mac_M4_AI_Installation_Commands.sh ~/

# Make it executable
chmod +x ~/Mac_M4_AI_Installation_Commands.sh

# Run the installation
./Mac_M4_AI_Installation_Commands.sh
```

**Or run commands manually:**

```bash
# Install Homebrew (if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Ollama
brew install ollama

# Set Ollama to listen on all interfaces
export OLLAMA_HOST=0.0.0.0:11434

# Start Ollama
ollama serve &

# Pull Code Llama model (7B version - 4GB download)
ollama pull codellama:7b

# Install AnythingLLM
brew install --cask anythingllm
```

**Expected installation time:** 15-30 minutes (depending on internet speed)

---

### Step 2: Verify Installation

**On Mac Mini M4 (192.168.1.7):**

```bash
# Check Ollama is running
curl http://localhost:11434/api/tags

# Should return JSON with installed models

# Test Code Llama
ollama run codellama:7b "Hello! Are you working?"
```

**From DC1 (192.168.1.10):**

```bash
# Test network connectivity
curl http://192.168.1.7:11434/api/tags

# Should return same JSON response

# Test Code Llama query from DC1
curl http://192.168.1.7:11434/api/generate -d '{
  "model": "codellama:7b",
  "prompt": "What command shows disk usage?",
  "stream": false
}' | jq -r '.response'
```

---

## Using the AI Integration Scripts

All scripts are installed on **DC1 at `/usr/local/bin/`** and ready to use:

### 1. General AI Queries: `ask-ai`

```bash
# Ask any system administration question
ask-ai "How do I check failed SSH login attempts?"

ask-ai "What's the command to find large files?"

ask-ai "How do I restart the httpd service safely?"
```

### 2. Wazuh Alert Analysis: `ai-analyze-wazuh`

```bash
# Analyze last 10 Wazuh alerts (default)
ai-analyze-wazuh

# Analyze specific number of alerts
ai-analyze-wazuh 20

# Get AI recommendations for security issues
```

### 3. Log Analysis: `ai-analyze-logs`

```bash
# Analyze /var/log/messages (default)
ai-analyze-logs

# Analyze specific log file
ai-analyze-logs /var/log/secure 100

# Analyze audit logs
ai-analyze-logs /var/log/audit/audit.log 50
```

### 4. Interactive Troubleshooting: `ai-troubleshoot`

```bash
# Describe your problem
ai-troubleshoot "high CPU usage on wazuh-manager"

ai-troubleshoot "disk space running low on /var"

ai-troubleshoot "slow DNS resolution"
```

---

## Example Workflows

### Workflow 1: Security Alert Investigation

```bash
# Step 1: Get AI analysis of recent Wazuh alerts
ai-analyze-wazuh 20

# AI Response: "Multiple failed SSH attempts from 203.0.113.15"

# Step 2: Ask AI for recommended actions
ask-ai "How do I block an IP address using firewalld?"

# AI Response: "Use: firewall-cmd --permanent --add-rich-rule='...' "

# Step 3: Human reviews recommendation

# Step 4: Human manually executes validated command
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="203.0.113.15" reject'
sudo firewall-cmd --reload

# Step 5: Document action in audit log
echo "$(date): Blocked IP 203.0.113.15 due to failed SSH attempts" | sudo tee -a /var/log/security-actions.log
```

### Workflow 2: Log Review Automation

```bash
# Daily log review using AI
ai-analyze-logs /var/log/secure 100 > /tmp/daily-security-review.txt

# Review AI findings
less /tmp/daily-security-review.txt

# Follow up on any issues identified
ask-ai "How do I investigate a specific user's authentication history?"
```

### Workflow 3: Troubleshooting with AI Assistance

```bash
# Problem: Service not starting
ai-troubleshoot "httpd service fails to start"

# AI suggests diagnostic commands
systemctl status httpd
journalctl -u httpd -n 50

# Run suggested diagnostics
# Review output
# AI suggests solution
# Human applies fix manually
```

---

## AnythingLLM Interface

For a more interactive experience, use the AnythingLLM web interface:

### Setup AnythingLLM

1. **Launch AnythingLLM** on Mac Mini M4:
   ```bash
   open /Applications/AnythingLLM.app
   ```

2. **Configure Ollama Connection:**
   - Settings → LLM Providers
   - Select "Ollama"
   - URL: `http://localhost:11434`
   - Model: `codellama:7b`
   - Test Connection

3. **Create Workspaces:**
   - "Security Analysis" - for Wazuh/log analysis
   - "System Administration" - for general tasks
   - "Troubleshooting" - for problem resolution

4. **Use the Web Interface:**
   - Open workspace
   - Ask questions conversationally
   - Copy useful commands to terminal
   - Execute manually on DC1

---

## Security & Compliance

### CMMC Compliance Checklist

- ✅ **AC-3 (Access Enforcement):** AI cannot access CUI data directly
- ✅ **AU-2 (Audit Events):** All admin actions logged on DC1, not AI queries
- ✅ **IA-2 (Authentication):** Human authenticates to DC1, AI doesn't
- ✅ **SC-7 (Boundary Protection):** AI outside CUI boundary (192.168.1.7)
- ✅ **SC-13 (Cryptographic Protection):** DC1 maintains FIPS mode

### Audit Trail

All AI queries and administrative actions should be logged:

```bash
# Create audit log for AI-assisted actions
sudo mkdir -p /var/log/ai-assisted-admin
sudo chown dshannon:dshannon /var/log/ai-assisted-admin

# Log template
echo "$(date +%Y-%m-%d_%H:%M:%S) - User: $(whoami) - Query: [query] - Action: [command executed]" >> /var/log/ai-assisted-admin/actions.log
```

### Network Isolation

Ensure AI server has no internet access after installation:

```bash
# On Mac Mini M4 (192.168.1.7)
# Verify no default route or restrict to local network only
```

---

## Troubleshooting

### AI Server Not Responding

```bash
# From DC1, test connectivity
ping 192.168.1.7
curl http://192.168.1.7:11434/api/tags

# If fails, check on Mac Mini:
# 1. Is Ollama running?
launchctl list | grep ollama

# 2. Check Ollama logs
tail -f /tmp/ollama.log

# 3. Restart Ollama
launchctl unload ~/Library/LaunchAgents/com.ollama.server.plist
launchctl load ~/Library/LaunchAgents/com.ollama.server.plist
```

### Slow AI Responses

```bash
# Code Llama 7B should respond in 10-30 seconds
# If slower:
#  1. Check Mac Mini CPU/RAM usage
#  2. Close other applications
#  3. Consider smaller model or dedicated hardware
```

### Model Not Found

```bash
# List installed models
ollama list

# Re-download if missing
ollama pull codellama:7b
```

---

## Performance Tuning

### Ollama Configuration

```bash
# Increase context window (on Mac Mini)
export OLLAMA_NUM_CTX=4096

# Adjust thread count
export OLLAMA_NUM_THREAD=8

# Restart Ollama to apply changes
```

### Model Selection

- **codellama:7b** - Best for 16GB RAM, fast responses
- **codellama:13b** - Best for 32GB RAM, better accuracy
- **codellama:34b** - Requires 64GB RAM, highest quality

---

## Next Steps

1. ✅ **Complete Installation** - Run installation script on Mac Mini M4
2. ✅ **Test Integration** - Verify all scripts work from DC1
3. ✅ **Train Users** - Familiarize system administrators with tools
4. ✅ **Document Procedures** - Add to standard operating procedures
5. ✅ **Update POA&M-040** - Mark as completed in tracking documents
6. ✅ **Prepare for NCMA Nexus** - Include AI demo in February presentation

---

## Resources

**Documentation:**
- Installation Script: `/home/dshannon/Documents/Claude/Mac_M4_AI_Installation_Commands.sh`
- Integration Scripts: `/usr/local/bin/ask-ai`, `ai-analyze-wazuh`, `ai-analyze-logs`, `ai-troubleshoot`
- POA&M-040: Local AI Integration Plan
- SSP Section: AI Copilot Architecture

**External Resources:**
- Ollama Documentation: https://github.com/ollama/ollama
- Code Llama Info: https://ollama.com/library/codellama
- AnythingLLM Docs: https://docs.useanything.com/

**Support:**
- Ollama logs: `/tmp/ollama.log` (on Mac Mini)
- AI integration issues: Check connectivity, model availability, system resources

---

**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**POA&M-040 Status:** Ready for Implementation
**Target Completion:** January 31, 2026
**Last Updated:** December 17, 2025
