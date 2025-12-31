# Interactive Code Llama CLI - User Guide
**Date:** December 17, 2025
**Command:** `llama` or `ai`
**POA&M-040:** Local AI Integration

---

## Quick Start

```bash
# Start interactive session (like 'claude' command)
llama

# Or use the shorter alias
ai
```

---

## Interface Overview

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🦙 Interactive Code Llama CLI                           ║
║   Local AI Assistant for System Administration           ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

Server: http://192.168.1.7:11434
Model:  codellama:7b
Type /help for commands or /exit to quit

You > [your question here]

Assistant >
[AI response]
```

---

## Available Commands

### Chat Commands (during interactive session)

| Command | Description |
|---------|-------------|
| `/help` or `/h` | Show help message |
| `/exit` or `/quit` | Exit the program |
| `/clear` | Clear conversation history |
| `/history` | Show full conversation history |
| `/model [name]` | Switch to different model |
| `/system [prompt]` | Change system personality |
| `/multiline` | Enter multiline input mode |

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Cancel current input |
| `Ctrl+D` | Exit (when input is empty) |
| `↑` / `↓` | Navigate command history |

---

## Usage Examples

### Example 1: Basic Interaction

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

You > /exit
Goodbye! 👋
```

### Example 2: Multi-turn Conversation

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

You > /exit
```

### Example 3: Switching Models

```bash
You > /model

Current model: codellama:7b

Available models:
  - codellama:7b
  - codellama:13b
  - llama2:latest

You > /model codellama:13b

✓ Switched to model: codellama:13b

You > Now analyze this complex script...
```

### Example 4: Custom System Prompt

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

### Example 5: Multiline Input

```bash
You > /multiline

Enter your message (press Ctrl+D when done):
I have a bash script that's failing:

#!/bin/bash
for file in /var/log/*.log; do
    gzip $file
done

The error is "file not found" but the files exist.
What's wrong?
[Press Ctrl+D]

Assistant >
The issue is likely that the glob pattern `/var/log/*.log` is expanding
to literal `*.log` when no files match, or the files have already been
gzipped (ending in .log.gz).

Solutions:

1. Check if files exist first:
```bash
shopt -s nullglob  # Don't expand to literal string if no matches
for file in /var/log/*.log; do
    [ -f "$file" ] && gzip "$file"
done
```

2. Handle already-gzipped files:
```bash
for file in /var/log/*.log; do
    [ -f "$file" ] && gzip "$file"
done
```

3. Add error checking:
```bash
for file in /var/log/*.log; do
    if [ -f "$file" ]; then
        if gzip "$file"; then
            echo "Compressed: $file"
        else
            echo "Error compressing: $file" >&2
        fi
    fi
done
```
```

---

## Command-Line Options

```bash
# Start with specific model
llama -m codellama:13b

# Start with custom system prompt
llama -s "You are a database expert"

# Combine options
llama -m codellama:13b -s "You are a security analyst"

# Show help
llama -h
```

---

## Convenient Aliases

The following aliases are automatically loaded:

```bash
ai              # Same as 'llama'
chat            # Same as 'llama'
codellama       # Same as 'llama'

ai-quick        # Non-interactive query: ask-ai
ai-wazuh        # Analyze Wazuh alerts
ai-logs         # Analyze system logs
ai-help         # Troubleshooting assistant

# Model-specific
llama7b         # Force 7B model
llama13b        # Force 13B model
llama34b        # Force 34B model

# Specialized modes
ai-security     # Security expert mode
ai-code         # Programming expert mode
ai-linux        # Linux admin expert mode

# Utilities
ai-status       # Show installed models
ai-test         # Test AI server connection
```

---

## Comparison with Other Tools

### Interactive AI (llama)
```bash
$ llama
You > [conversational interface]
```

### Quick Queries (ask-ai)
```bash
$ ask-ai "How do I restart Apache?"
[immediate one-shot answer]
```

### Specialized Analysis (ai-analyze-wazuh)
```bash
$ ai-analyze-wazuh
[analyzes alerts and provides report]
```

---

## Tips & Best Practices

### 1. Use Conversation History
The AI remembers your conversation within a session. Build on previous questions:

```bash
You > How do I check memory usage?
Assistant > [explains free, top, htop commands]

You > Which one should I use for servers?
Assistant > [recommends based on previous context]
```

### 2. Be Specific
Better: "How do I configure firewalld to block port 22 from specific IP?"
vs.
Vague: "How do I use firewall?"

### 3. Use Multiline for Complex Questions
```bash
You > /multiline
[paste your entire error message or log excerpt]
```

### 4. Leverage System Prompts
```bash
# For security analysis
llama -s "You are a NIST 800-171 compliance expert"

# For coding help
llama -s "You are a Python developer. Provide clean, documented code."
```

### 5. Check History
```bash
You > /history
[review full conversation to recall previous recommendations]
```

---

## Troubleshooting

### AI Server Not Responding

```bash
# Check if server is online
ai-test

# Manual test
curl http://192.168.1.7:11434/api/tags

# Check from Mac Mini
ssh Admin@192.168.1.7 'launchctl list | grep ollama'
```

### Slow Responses

- **Code Llama 7B**: Responds in 10-30 seconds (normal)
- **Code Llama 13B**: Responds in 20-60 seconds
- **Code Llama 34B**: Responds in 60-120 seconds

If slower:
1. Close other applications on Mac Mini
2. Check Mac Mini CPU/RAM usage
3. Consider using smaller model

### Model Not Found

```bash
# List available models
curl -s http://192.168.1.7:11434/api/tags | jq -r '.models[].name'

# Pull missing model
ssh Admin@192.168.1.7 'ollama pull codellama:7b'
```

### Connection Timeout

```bash
# Verify Mac Mini is reachable
ping 192.168.1.7

# Check if Ollama port is open
nc -zv 192.168.1.7 11434

# Restart Ollama on Mac Mini
ssh Admin@192.168.1.7 'launchctl unload ~/Library/LaunchAgents/com.ollama.server.plist && launchctl load ~/Library/LaunchAgents/com.ollama.server.plist'
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_HOST` | `http://192.168.1.7:11434` | Ollama server URL |
| `LLAMA_MODEL` | `codellama:7b` | Default model |

Example:
```bash
export OLLAMA_HOST=http://localhost:11434  # Use local Ollama
export LLAMA_MODEL=codellama:13b           # Default to 13B model
llama  # Uses new settings
```

---

## Advanced Features

### Session Persistence

Command history is saved to `~/.llama_history` and persists across sessions.

### Conversation Context

Each session maintains conversation context in `/tmp/llama_conversation_$$`

### Custom Configuration

Create `~/.llamarc` for custom settings:
```bash
export LLAMA_MODEL=codellama:13b
export OLLAMA_HOST=http://192.168.1.7:11434
```

---

## Integration with Other Tools

### Pipe Input
```bash
# Analyze log file
cat /var/log/secure | ask-ai "Analyze these SSH logs"

# Get help with command output
journalctl -u httpd -n 50 | ask-ai "Why is Apache failing?"
```

### In Scripts
```bash
#!/bin/bash
# Get AI recommendation
RECOMMENDATION=$(ask-ai "What's the safest way to clear /var/log/?")
echo "AI Recommendation: $RECOMMENDATION"

# Human reviews and decides
read -p "Execute? (y/n): " CONFIRM
if [ "$CONFIRM" = "y" ]; then
    # Execute validated command
fi
```

---

## Comparison: llama vs claude

| Feature | `llama` (Local) | `claude` (Cloud) |
|---------|----------------|------------------|
| **Privacy** | 100% local, air-gapped | Cloud-based |
| **Speed** | 10-30s response | 1-3s response |
| **Cost** | Free (after hardware) | Subscription |
| **Availability** | Requires local server | Always available |
| **Model** | Code Llama 7B/13B/34B | Claude Sonnet/Opus |
| **Context** | Limited (4K tokens) | Extended (200K tokens) |
| **CMMC Compliant** | ✅ Yes | ❌ Requires boundary |

---

## Resources

- **Quick Start:** Run `llama` or `ai`
- **Help:** Run `llama -h` or type `/help` in session
- **Test Connection:** Run `ai-test`
- **Ollama Docs:** https://github.com/ollama/ollama
- **Code Llama Info:** https://ollama.com/library/codellama

---

**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**POA&M-040:** Local AI Integration
**Last Updated:** December 17, 2025

**Happy Chatting! 🦙**
