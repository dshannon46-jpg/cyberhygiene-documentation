"""System administration tools for the AI agent"""
import subprocess
import os
import psutil
from datetime import datetime
from typing import Optional, Dict, Any, List
from core.config import config
from tools.audit import audit_log
from core.approval import approval_manager


class CommandExecutionError(Exception):
    """Raised when command execution fails or is forbidden"""
    pass


class SystemTools:
    """Tools for system administration tasks"""

    @staticmethod
    def is_command_safe(command: str) -> tuple[bool, Optional[str]]:
        """
        Check if a command is safe to execute.

        Returns:
            (is_safe, reason) - True if safe, False with reason if not
        """
        # Check forbidden commands
        for forbidden in config.security.forbidden_commands:
            if forbidden in command:
                return False, f"Command contains forbidden pattern: {forbidden}"

        # Check if command is in allowed list
        is_allowed = False
        for allowed in config.security.allowed_commands:
            if command.strip().startswith(allowed):
                is_allowed = True
                break

        if not is_allowed:
            return False, f"Command not in allowed list. Use only whitelisted commands."

        return True, None

    @staticmethod
    def requires_approval(command: str) -> bool:
        """Check if command requires user approval"""
        for pattern in config.security.require_approval_for:
            if pattern in command:
                return True
        return False

    @staticmethod
    def execute_command(command: str, approved: bool = False, ai_reason: str = "AI requested") -> str:
        """
        Execute a system command with mandatory approval and safety checks.

        Args:
            command: The command to execute
            approved: Whether the user has pre-approved this command
            ai_reason: Explanation from AI about why it wants to run this command

        Returns:
            Command output as string
        """
        # Security check
        is_safe, reason = SystemTools.is_command_safe(command)
        if not is_safe:
            audit_log("COMMAND_BLOCKED", {"command": command, "reason": reason})
            raise CommandExecutionError(f"Command blocked: {reason}")

        # MANDATORY APPROVAL: Request user authorization before executing ANY command
        if not approved:
            approved = approval_manager.request_approval(
                command=command,
                reason=ai_reason
            )

            if not approved:
                raise CommandExecutionError(f"Command denied by user: {command}")

        # Execute command (only if approved)
        try:
            audit_log("COMMAND_EXECUTE", {"command": command})
            result = subprocess.run(
                command,
                shell=True,
                capture_output=True,
                text=True,
                timeout=30
            )

            output = result.stdout if result.stdout else result.stderr

            # Truncate if too long
            if len(output) > config.security.max_output_length:
                output = output[:config.security.max_output_length] + "\n... (output truncated)"

            audit_log("COMMAND_SUCCESS", {
                "command": command,
                "exit_code": result.returncode,
                "output_length": len(output)
            })

            return output if output else f"Command completed (exit code: {result.returncode})"

        except subprocess.TimeoutExpired:
            audit_log("COMMAND_TIMEOUT", {"command": command})
            raise CommandExecutionError("Command timed out after 30 seconds")
        except Exception as e:
            audit_log("COMMAND_ERROR", {"command": command, "error": str(e)})
            raise CommandExecutionError(f"Command failed: {str(e)}")

    @staticmethod
    def read_file(file_path: str, lines: Optional[int] = None, tail: bool = False) -> str:
        """
        Read a file with safety checks.

        Args:
            file_path: Path to the file
            lines: Number of lines to read (None = all)
            tail: If True, read last N lines; if False, read first N lines

        Returns:
            File contents as string
        """
        # Basic security check - only allow reading from specific directories
        allowed_paths = ["/var/log", "/etc", "/proc", "/sys", "/home/dshannon"]

        abs_path = os.path.abspath(file_path)
        if not any(abs_path.startswith(allowed) for allowed in allowed_paths):
            audit_log("FILE_READ_BLOCKED", {"path": file_path, "reason": "Path not in allowed list"})
            raise CommandExecutionError(f"Cannot read file: {file_path} (not in allowed paths)")

        try:
            audit_log("FILE_READ", {"path": file_path, "lines": lines, "tail": tail})

            with open(abs_path, 'r') as f:
                if lines is None:
                    content = f.read()
                elif tail:
                    # Read last N lines
                    all_lines = f.readlines()
                    content = ''.join(all_lines[-lines:])
                else:
                    # Read first N lines
                    content = ''.join([next(f) for _ in range(min(lines, sum(1 for _ in f)))])

            # Truncate if too long
            if len(content) > config.security.max_output_length:
                content = content[:config.security.max_output_length] + "\n... (content truncated)"

            return content

        except FileNotFoundError:
            raise CommandExecutionError(f"File not found: {file_path}")
        except PermissionError:
            raise CommandExecutionError(f"Permission denied: {file_path}")
        except Exception as e:
            audit_log("FILE_READ_ERROR", {"path": file_path, "error": str(e)})
            raise CommandExecutionError(f"Error reading file: {str(e)}")

    @staticmethod
    def get_system_status() -> Dict[str, Any]:
        """Get comprehensive system status"""
        try:
            audit_log("SYSTEM_STATUS_CHECK", {})

            # CPU info
            cpu_percent = psutil.cpu_percent(interval=1)
            cpu_count = psutil.cpu_count()

            # Memory info
            memory = psutil.virtual_memory()

            # Disk info
            disk = psutil.disk_usage('/')

            # Network info
            net_io = psutil.net_io_counters()

            # Boot time
            boot_time = datetime.fromtimestamp(psutil.boot_time())

            # Load average
            load_avg = os.getloadavg()

            status = {
                "timestamp": datetime.now().isoformat(),
                "cpu": {
                    "percent": cpu_percent,
                    "count": cpu_count,
                    "load_avg_1min": load_avg[0],
                    "load_avg_5min": load_avg[1],
                    "load_avg_15min": load_avg[2],
                },
                "memory": {
                    "total_gb": round(memory.total / (1024**3), 2),
                    "used_gb": round(memory.used / (1024**3), 2),
                    "available_gb": round(memory.available / (1024**3), 2),
                    "percent": memory.percent,
                },
                "disk": {
                    "total_gb": round(disk.total / (1024**3), 2),
                    "used_gb": round(disk.used / (1024**3), 2),
                    "free_gb": round(disk.free / (1024**3), 2),
                    "percent": disk.percent,
                },
                "network": {
                    "bytes_sent_gb": round(net_io.bytes_sent / (1024**3), 2),
                    "bytes_recv_gb": round(net_io.bytes_recv / (1024**3), 2),
                },
                "uptime_hours": round((datetime.now() - boot_time).total_seconds() / 3600, 1),
                "boot_time": boot_time.isoformat(),
            }

            return status

        except Exception as e:
            audit_log("SYSTEM_STATUS_ERROR", {"error": str(e)})
            raise CommandExecutionError(f"Error getting system status: {str(e)}")

    @staticmethod
    def list_directory(path: str, pattern: Optional[str] = None) -> List[str]:
        """List directory contents with optional pattern matching"""
        allowed_paths = ["/var/log", "/etc", "/home/dshannon", "/backup", "/srv"]

        abs_path = os.path.abspath(path)
        if not any(abs_path.startswith(allowed) for allowed in allowed_paths):
            raise CommandExecutionError(f"Cannot list directory: {path} (not in allowed paths)")

        try:
            audit_log("DIRECTORY_LIST", {"path": path, "pattern": pattern})

            entries = os.listdir(abs_path)

            if pattern:
                import fnmatch
                entries = [e for e in entries if fnmatch.fnmatch(e, pattern)]

            # Get detailed info
            result = []
            for entry in sorted(entries):
                full_path = os.path.join(abs_path, entry)
                try:
                    stat = os.stat(full_path)
                    size = stat.st_size
                    mtime = datetime.fromtimestamp(stat.st_mtime).strftime('%Y-%m-%d %H:%M')
                    is_dir = os.path.isdir(full_path)
                    result.append(f"{'d' if is_dir else '-'} {size:>12} {mtime} {entry}")
                except:
                    result.append(f"? {entry}")

            return result

        except Exception as e:
            raise CommandExecutionError(f"Error listing directory: {str(e)}")
