"""Configuration for CyberHygiene AI Admin Assistant"""
import os
from typing import List, Optional
from pydantic import BaseModel, Field


class OllamaConfig(BaseModel):
    """Ollama LLM configuration"""
    host: str = Field(default="http://192.168.1.7:11434", description="Ollama server URL")
    model: str = Field(default="codellama:34b", description="Model to use")
    temperature: float = Field(default=0.1, description="Temperature for generation (0.0-1.0)")
    timeout: int = Field(default=120, description="Request timeout in seconds")


class SecurityConfig(BaseModel):
    """Security and audit configuration"""
    audit_log_path: str = Field(default="/home/dshannon/cyberhygiene-ai-admin/logs/audit.log")
    allowed_commands: List[str] = Field(
        default=[
            # System status commands
            "systemctl status", "systemctl list-units", "systemctl is-active",
            # Monitoring commands
            "uptime", "df", "free", "ps", "top", "htop", "iotop",
            "cat /proc/", "ls", "pwd", "whoami", "w", "last",
            # Log viewing
            "tail", "head", "less", "grep", "journalctl", "cat /var/log",
            # Network status
            "ip addr", "ip route", "ss", "netstat", "ping", "curl",
            # Security monitoring
            "ausearch", "aureport", "sudo wazuh-control",
            "sudo systemctl status wazuh-manager",
            # File integrity
            "sudo mdadm --detail", "cat /proc/mdstat",
            # Package management (read-only)
            "dnf check-update", "dnf list", "rpm -qa", "dnf history",
            # SELinux/FIPS
            "sestatus", "fips-mode-setup --check", "getenforce",
            # FreeIPA
            "sudo ipactl status", "ipa user-find", "ipa host-find",
            # Backup status
            "ls /backup", "ls /var/lib/ipa/backup",
        ],
        description="Whitelist of allowed command prefixes"
    )

    forbidden_commands: List[str] = Field(
        default=[
            "rm -rf", "dd if=", "mkfs", "fdisk", "parted",
            "systemctl stop", "systemctl disable", "systemctl mask",
            "iptables -F", "firewall-cmd --remove",
            "userdel", "usermod -L", "passwd -d",
            "chmod 777", "chown root", "sudo su", "su -",
        ],
        description="Blacklist of forbidden command patterns"
    )

    require_approval_for: List[str] = Field(
        default=[
            "systemctl restart", "systemctl reload", "systemctl start",
            "dnf install", "dnf remove", "dnf update",
            "firewall-cmd --add", "iptables -A", "iptables -I",
            "sudo", "chmod", "chown",
        ],
        description="Commands that require user approval before execution"
    )

    max_output_length: int = Field(default=10000, description="Max characters of command output to return")


class AgentConfig(BaseModel):
    """Main agent configuration"""
    ollama: OllamaConfig = Field(default_factory=OllamaConfig)
    security: SecurityConfig = Field(default_factory=SecurityConfig)
    system_prompt: str = Field(
        default="""You are CyberHygiene AI Admin Assistant, an expert system administrator for a NIST 800-171 compliant Rocky Linux 9 environment.

Your capabilities:
- Execute system commands (with safety controls)
- Read and analyze log files
- Monitor system status and services
- Provide security recommendations
- Help troubleshoot issues

Security Guidelines:
- NEVER execute destructive commands without explicit user approval
- Always explain what a command does before running it
- Prioritize system security and stability
- Follow NIST 800-171 compliance requirements
- Maintain detailed audit logs

When executing commands:
1. Verify the command is safe
2. Explain what it will do
3. Show the results clearly
4. Provide context and recommendations

Be concise, accurate, and security-focused. If unsure, ask for clarification.""",
        description="System prompt for the AI agent"
    )
    max_iterations: int = Field(default=10, description="Max agent reasoning iterations")
    verbose: bool = Field(default=True, description="Enable verbose output")


# Global config instance
config = AgentConfig()
