#!/bin/bash
# Local AI Installation Script for Mac Mini M4 (192.168.1.7)
# Date: December 17, 2025
# Components: Ollama, Code Llama, AnythingLLM
# Purpose: POA&M-040 - Local AI Integration for CyberHygiene Project

set -e  # Exit on error

echo "========================================="
echo "Mac Mini M4 - Local AI Installation"
echo "System: 192.168.1.7"
echo "Date: $(date)"
echo "========================================="
echo ""

# Step 1: Install Homebrew (if not already installed)
echo "[1/6] Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✓ Homebrew already installed"
fi
echo ""

# Step 2: Install Ollama
echo "[2/6] Installing Ollama..."
if ! command -v ollama &> /dev/null; then
    brew install ollama
    echo "✓ Ollama installed successfully"
else
    echo "✓ Ollama already installed"
    ollama --version
fi
echo ""

# Step 3: Start Ollama service
echo "[3/6] Starting Ollama service..."
# Create launch agent for Ollama
mkdir -p ~/Library/LaunchAgents

cat > ~/Library/LaunchAgents/com.ollama.server.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ollama.server</string>
    <key>ProgramArguments</key>
    <array>
        <string>/opt/homebrew/bin/ollama</string>
        <string>serve</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>OLLAMA_HOST</key>
        <string>0.0.0.0:11434</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/ollama.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/ollama.error.log</string>
</dict>
</plist>
EOF

# Load the launch agent
launchctl unload ~/Library/LaunchAgents/com.ollama.server.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.ollama.server.plist

echo "✓ Ollama service started (listening on 0.0.0.0:11434)"
echo "  Logs: /tmp/ollama.log"
sleep 5
echo ""

# Step 4: Pull Code Llama models
echo "[4/6] Downloading Code Llama models..."
echo "  This may take 5-15 minutes depending on your internet speed..."
echo ""

# Pull Code Llama 7B (recommended for M4 with 16-24GB RAM)
echo "  Pulling codellama:7b (4GB download)..."
ollama pull codellama:7b

# Optional: Pull larger model if you have 32GB+ RAM
# echo "  Pulling codellama:13b (7GB download)..."
# ollama pull codellama:13b

echo "✓ Code Llama models downloaded"
echo ""

# Step 5: Install AnythingLLM
echo "[5/6] Installing AnythingLLM..."
if ! ls /Applications/AnythingLLM.app &> /dev/null; then
    echo "  Downloading AnythingLLM..."
    cd ~/Downloads
    curl -L -o AnythingLLM.dmg "https://s3.amazonaws.com/public.useanything.com/latest/AnythingLLMDesktop.dmg"

    echo "  Mounting DMG..."
    hdiutil attach AnythingLLM.dmg

    echo "  Installing to /Applications..."
    cp -R /Volumes/AnythingLLM/AnythingLLM.app /Applications/

    echo "  Cleaning up..."
    hdiutil detach /Volumes/AnythingLLM
    rm AnythingLLM.dmg

    echo "✓ AnythingLLM installed"
else
    echo "✓ AnythingLLM already installed"
fi
echo ""

# Step 6: Verify installation and test
echo "[6/6] Verifying installation..."
echo ""

# Test Ollama service
echo "Testing Ollama service..."
sleep 2
if curl -s http://localhost:11434/api/tags | grep -q "models"; then
    echo "✓ Ollama API responding on http://localhost:11434"
else
    echo "⚠ Ollama API not responding. Trying to start manually..."
    OLLAMA_HOST=0.0.0.0:11434 ollama serve &
    sleep 5
fi
echo ""

# List installed models
echo "Installed models:"
ollama list
echo ""

# Test Code Llama
echo "Testing Code Llama..."
TEST_RESPONSE=$(ollama run codellama:7b "Say 'Installation successful!' in one line" --verbose 2>&1 | head -1)
echo "  Response: $TEST_RESPONSE"
echo ""

echo "========================================="
echo "Installation Complete!"
echo "========================================="
echo ""
echo "Next Steps:"
echo "  1. Verify Ollama is accessible from DC1:"
echo "     curl http://192.168.1.7:11434/api/tags"
echo ""
echo "  2. Launch AnythingLLM:"
echo "     open /Applications/AnythingLLM.app"
echo ""
echo "  3. Configure AnythingLLM:"
echo "     - LLM Provider: Ollama"
echo "     - URL: http://localhost:11434"
echo "     - Model: codellama:7b"
echo ""
echo "  4. Test from DC1 (192.168.1.10):"
echo "     Run the integration scripts"
echo ""
echo "System Information:"
echo "  - Mac Mini M4 (192.168.1.7)"
echo "  - Ollama API: http://192.168.1.7:11434"
echo "  - Models: Code Llama 7B"
echo "  - Interface: AnythingLLM"
echo ""
echo "For troubleshooting:"
echo "  - Ollama logs: /tmp/ollama.log"
echo "  - Service status: launchctl list | grep ollama"
echo "  - Restart service: launchctl unload ~/Library/LaunchAgents/com.ollama.server.plist && launchctl load ~/Library/LaunchAgents/com.ollama.server.plist"
echo ""
