#!/bin/bash
#
# Module 65: Install SysAdmin Agent Dashboard
# AI-assisted system administration dashboard (Streamlit + Ollama)
# CyberHygiene Phase II Feature
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [65-SYSADMIN] $*"
}

log "Installing SysAdmin Agent Dashboard..."

# Configuration
SYSADMIN_DIR="/data/ai-workspace/sysadmin-agent"
SYSADMIN_USER="${SYSADMIN_USER:-admin}"  # Set in install_vars.sh or defaults to admin
STREAMLIT_PORT="8501"

# Step 1: Install Python dependencies
log "Step 1: Installing Python dependencies..."
dnf install -y python3 python3-pip python3-devel

log "✓ Python installed"

# Step 2: Create directory structure
log "Step 2: Creating directory structure..."
mkdir -p "${SYSADMIN_DIR}"/{config,logs,data}
chown -R "${SYSADMIN_USER}:${SYSADMIN_USER}" "${SYSADMIN_DIR}"

log "✓ Directory structure created"

# Step 3: Install Ollama (local LLM)
log "Step 3: Installing Ollama..."

if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
    log "✓ Ollama installed"
else
    log "✓ Ollama already installed"
fi

# Enable and start Ollama service
systemctl enable ollama
systemctl start ollama

# Wait for Ollama to be ready
sleep 5

# Pull a lightweight model for system administration
log "  Pulling llama3.2:3b model (this may take a few minutes)..."
ollama pull llama3.2:3b || log "  Model pull may need to be done manually"

log "✓ Ollama configured"

# Step 4: Create Python virtual environment
log "Step 4: Creating Python virtual environment..."

cd "${SYSADMIN_DIR}"
python3 -m venv venv
source venv/bin/activate

# Install required packages
pip install --upgrade pip
pip install streamlit ollama psutil requests pyyaml

deactivate

log "✓ Python environment configured"

# Step 5: Create the SysAdmin Agent application
log "Step 5: Creating SysAdmin Agent application..."

cat > "${SYSADMIN_DIR}/app.py" <<'APPEOF'
#!/usr/bin/env python3
"""
CyberHygiene SysAdmin Agent Dashboard
AI-assisted system administration interface
"""

import streamlit as st
import subprocess
import psutil
import os
from datetime import datetime

# Page configuration
st.set_page_config(
    page_title="SysAdmin Agent Dashboard",
    page_icon="🖥️",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS
st.markdown("""
<style>
    .main-header { font-size: 2.5rem; font-weight: bold; color: #1f77b4; }
    .status-ok { color: #28a745; }
    .status-warn { color: #ffc107; }
    .status-error { color: #dc3545; }
    .metric-card { background-color: #f8f9fa; padding: 1rem; border-radius: 0.5rem; }
</style>
""", unsafe_allow_html=True)

def get_system_info():
    """Get system information"""
    return {
        "hostname": subprocess.getoutput("hostname -f"),
        "os": subprocess.getoutput("cat /etc/redhat-release"),
        "kernel": subprocess.getoutput("uname -r"),
        "uptime": subprocess.getoutput("uptime -p"),
        "cpu_percent": psutil.cpu_percent(interval=1),
        "memory": psutil.virtual_memory(),
        "disk": psutil.disk_usage("/"),
    }

def get_service_status(service_name):
    """Check if a service is running"""
    try:
        result = subprocess.run(
            ["systemctl", "is-active", service_name],
            capture_output=True, text=True
        )
        return result.stdout.strip() == "active"
    except:
        return False

def main():
    # Header
    st.markdown('<p class="main-header">🖥️ SysAdmin Agent Dashboard</p>', unsafe_allow_html=True)
    st.caption(f"CyberHygiene Phase II | {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    # Sidebar
    with st.sidebar:
        st.header("⚙️ Settings")

        # AI Status
        st.subheader("🤖 AI Status")
        try:
            import ollama
            models = ollama.list()
            st.success("Ollama Connected")
            if models.get('models'):
                for model in models['models'][:3]:
                    st.caption(f"• {model.get('name', 'Unknown')}")
        except:
            st.error("Ollama Not Connected")

        st.divider()

        # Quick Links
        st.subheader("🔗 Dashboards")
        dashboards = [
            ("FreeIPA Admin", "/ipa/ui/"),
            ("Wazuh SIEM", ":5601"),
            ("Graylog Logs", ":9000"),
            ("Grafana", ":3000"),
            ("Prometheus", ":9090"),
        ]
        for name, path in dashboards:
            st.markdown(f"[{name}](https://{os.uname().nodename}{path})")

    # Main content
    tab1, tab2, tab3, tab4 = st.tabs(["📊 Overview", "🔧 Services", "🛡️ Security", "💬 AI Assistant"])

    with tab1:
        # System Overview
        info = get_system_info()

        col1, col2, col3, col4 = st.columns(4)
        with col1:
            st.metric("CPU Usage", f"{info['cpu_percent']}%")
        with col2:
            st.metric("Memory", f"{info['memory'].percent}%")
        with col3:
            st.metric("Disk", f"{info['disk'].percent}%")
        with col4:
            st.metric("Uptime", info['uptime'].replace("up ", ""))

        st.divider()

        col1, col2 = st.columns(2)
        with col1:
            st.subheader("System Information")
            st.text(f"Hostname: {info['hostname']}")
            st.text(f"OS: {info['os']}")
            st.text(f"Kernel: {info['kernel']}")

        with col2:
            st.subheader("Memory Details")
            mem = info['memory']
            st.text(f"Total: {mem.total / (1024**3):.1f} GB")
            st.text(f"Used: {mem.used / (1024**3):.1f} GB")
            st.text(f"Available: {mem.available / (1024**3):.1f} GB")

    with tab2:
        # Services Status
        st.subheader("🔧 Service Status")

        services = [
            ("FreeIPA", "ipa"),
            ("Wazuh Manager", "wazuh-manager"),
            ("Wazuh Dashboard", "wazuh-dashboard"),
            ("Graylog", "graylog-server"),
            ("Suricata IDS", "suricata"),
            ("Prometheus", "prometheus"),
            ("Grafana", "grafana-server"),
            ("fapolicyd", "fapolicyd"),
            ("USBGuard", "usbguard"),
            ("Firewall", "firewalld"),
        ]

        cols = st.columns(5)
        for i, (name, service) in enumerate(services):
            with cols[i % 5]:
                status = get_service_status(service)
                icon = "✅" if status else "❌"
                st.markdown(f"{icon} **{name}**")

    with tab3:
        # Security Status
        st.subheader("🛡️ Security Status")

        col1, col2 = st.columns(2)

        with col1:
            # SELinux
            selinux = subprocess.getoutput("getenforce")
            st.metric("SELinux", selinux)

            # FIPS
            fips = subprocess.getoutput("fips-mode-setup --check 2>/dev/null | grep -q enabled && echo Enabled || echo Disabled")
            st.metric("FIPS Mode", fips)

        with col2:
            # Recent security events
            st.markdown("**Recent Wazuh Alerts**")
            alerts = subprocess.getoutput("tail -5 /var/ossec/logs/alerts/alerts.log 2>/dev/null | head -10")
            st.code(alerts or "No recent alerts", language="text")

    with tab4:
        # AI Assistant
        st.subheader("💬 AI System Assistant")
        st.caption("Ask questions about system administration, security, or troubleshooting")

        if "messages" not in st.session_state:
            st.session_state.messages = []

        # Display chat history
        for msg in st.session_state.messages:
            with st.chat_message(msg["role"]):
                st.markdown(msg["content"])

        # Chat input
        if prompt := st.chat_input("Ask a sysadmin question..."):
            st.session_state.messages.append({"role": "user", "content": prompt})

            with st.chat_message("user"):
                st.markdown(prompt)

            with st.chat_message("assistant"):
                try:
                    import ollama
                    response = ollama.chat(
                        model="llama3.2:3b",
                        messages=[
                            {"role": "system", "content": "You are a helpful Linux system administrator assistant for a NIST 800-171 compliant Rocky Linux server. Provide concise, accurate technical guidance."},
                            {"role": "user", "content": prompt}
                        ]
                    )
                    answer = response['message']['content']
                except Exception as e:
                    answer = f"AI unavailable: {str(e)}. Please ensure Ollama is running."

                st.markdown(answer)
                st.session_state.messages.append({"role": "assistant", "content": answer})

if __name__ == "__main__":
    main()
APPEOF

chown "${SYSADMIN_USER}:${SYSADMIN_USER}" "${SYSADMIN_DIR}/app.py"

log "✓ Application created"

# Step 6: Create configuration file
log "Step 6: Creating configuration..."

cat > "${SYSADMIN_DIR}/config/config.py" <<'CONFIGEOF'
"""
SysAdmin Agent Configuration
"""

# Ollama settings
OLLAMA_HOST = "http://localhost:11434"
OLLAMA_MODEL = "llama3.2:3b"

# Dashboard settings
STREAMLIT_PORT = 8501
STREAMLIT_ADDRESS = "127.0.0.1"

# Dashboard tiles
DASHBOARD_TILES = {
    "dashboards": [
        {
            "id": "freeipa",
            "title": "FreeIPA Admin",
            "icon": "👥",
            "description": "Identity management",
            "url": "https://dc1.${DOMAIN}/ipa/ui/",
        },
        {
            "id": "wazuh",
            "title": "Wazuh SIEM",
            "icon": "🛡️",
            "description": "Security events and alerts",
            "url": "https://dc1.${DOMAIN}:5601",
        },
        {
            "id": "graylog",
            "title": "Graylog Logs",
            "icon": "📊",
            "description": "Centralized log management",
            "url": "http://dc1.${DOMAIN}:9000",
        },
        {
            "id": "grafana",
            "title": "Grafana",
            "icon": "📈",
            "description": "Metrics visualization",
            "url": "http://dc1.${DOMAIN}:3000",
        },
    ]
}
CONFIGEOF

# Substitute domain
sed -i "s/\${DOMAIN}/${DOMAIN}/g" "${SYSADMIN_DIR}/config/config.py"

chown -R "${SYSADMIN_USER}:${SYSADMIN_USER}" "${SYSADMIN_DIR}/config"

log "✓ Configuration created"

# Step 7: Create systemd service
log "Step 7: Creating systemd service..."

cat > /etc/systemd/system/sysadmin-agent.service <<EOF
[Unit]
Description=SysAdmin Agent Dashboard (Streamlit)
After=network.target ollama.service
Wants=ollama.service

[Service]
Type=simple
User=${SYSADMIN_USER}
Group=${SYSADMIN_USER}
WorkingDirectory=${SYSADMIN_DIR}
Environment="PATH=${SYSADMIN_DIR}/venv/bin:/usr/bin"
ExecStart=${SYSADMIN_DIR}/venv/bin/python -m streamlit run app.py \\
    --server.port ${STREAMLIT_PORT} \\
    --server.address 127.0.0.1 \\
    --server.headless true \\
    --browser.gatherUsageStats false \\
    --server.baseUrlPath sysadmin \\
    --server.enableXsrfProtection false \\
    --server.enableCORS false
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable sysadmin-agent

log "✓ Systemd service created"

# Step 8: Configure Apache proxy
log "Step 8: Configuring Apache reverse proxy..."

cat > /etc/httpd/conf.d/sysadmin-agent.conf <<EOF
# SysAdmin Agent Dashboard Proxy
<Location /sysadmin>
    ProxyPass http://127.0.0.1:${STREAMLIT_PORT}/sysadmin
    ProxyPassReverse http://127.0.0.1:${STREAMLIT_PORT}/sysadmin

    # WebSocket support for Streamlit
    RewriteEngine On
    RewriteCond %{HTTP:Upgrade} =websocket [NC]
    RewriteRule /sysadmin/(.*) ws://127.0.0.1:${STREAMLIT_PORT}/sysadmin/\$1 [P,L]
</Location>

# Streamlit static files
<Location /sysadmin/static>
    ProxyPass http://127.0.0.1:${STREAMLIT_PORT}/sysadmin/static
    ProxyPassReverse http://127.0.0.1:${STREAMLIT_PORT}/sysadmin/static
</Location>

<Location /sysadmin/_stcore>
    ProxyPass http://127.0.0.1:${STREAMLIT_PORT}/sysadmin/_stcore
    ProxyPassReverse http://127.0.0.1:${STREAMLIT_PORT}/sysadmin/_stcore
</Location>
EOF

# Enable proxy modules
if ! httpd -M 2>/dev/null | grep -q proxy_wstunnel; then
    log "  Enabling proxy_wstunnel module..."
fi

systemctl reload httpd || log "  Apache reload may need manual attention"

log "✓ Apache proxy configured"

# Step 9: Start services
log "Step 9: Starting SysAdmin Agent..."

systemctl start sysadmin-agent

sleep 5

if systemctl is-active --quiet sysadmin-agent; then
    log "✓ SysAdmin Agent is running"
else
    log "ERROR: SysAdmin Agent failed to start"
    journalctl -u sysadmin-agent -n 20 --no-pager
    exit 1
fi

# Summary
echo ""
log "=========================================="
log "SysAdmin Agent Installation Summary"
log "=========================================="
log "✓ SysAdmin Agent Dashboard installed"
log "✓ Ollama AI backend configured"
log "✓ Apache reverse proxy configured"
log ""
log "Access: https://${DC1_HOSTNAME}/sysadmin/"
log ""
log "Features:"
log "  - System monitoring dashboard"
log "  - Service status overview"
log "  - Security status display"
log "  - AI-powered system assistant"
log "  - Quick links to all dashboards"
log ""
log "Management:"
log "  systemctl status sysadmin-agent"
log "  journalctl -u sysadmin-agent -f"
log ""

exit 0
