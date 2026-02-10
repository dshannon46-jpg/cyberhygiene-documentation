"""Audit logging for security and compliance"""
import json
import os
from datetime import datetime
from typing import Dict, Any, Optional
from pathlib import Path


def ensure_log_dir():
    """Ensure the log directory exists"""
    log_path = Path("/home/dshannon/cyberhygiene-ai-admin/logs")
    log_path.mkdir(parents=True, exist_ok=True)


def audit_log(event_type: str, data: Dict[str, Any]):
    """
    Log an audit event.

    Args:
        event_type: Type of event (e.g., "COMMAND_EXECUTE", "FILE_READ")
        data: Additional data about the event
    """
    ensure_log_dir()

    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "event_type": event_type,
        "user": os.getenv("USER", "unknown"),
        "data": data
    }

    log_file = "/home/dshannon/cyberhygiene-ai-admin/logs/audit.log"

    try:
        with open(log_file, 'a') as f:
            f.write(json.dumps(log_entry) + "\n")
    except Exception as e:
        # Don't raise - we don't want audit logging failures to break the application
        print(f"Warning: Failed to write audit log: {e}")


def get_recent_audit_logs(count: int = 100, event_type: Optional[str] = None) -> list:
    """
    Get recent audit log entries.

    Args:
        count: Number of recent entries to return
        event_type: Filter by event type (optional)

    Returns:
        List of audit log entries
    """
    log_file = "/home/dshannon/cyberhygiene-ai-admin/logs/audit.log"

    if not os.path.exists(log_file):
        return []

    try:
        with open(log_file, 'r') as f:
            lines = f.readlines()

        # Parse JSON lines
        entries = []
        for line in lines[-count*2:]:  # Read more than needed to allow for filtering
            try:
                entry = json.loads(line)
                if event_type is None or entry.get("event_type") == event_type:
                    entries.append(entry)
            except json.JSONDecodeError:
                continue

        return entries[-count:]

    except Exception as e:
        print(f"Warning: Failed to read audit log: {e}")
        return []
