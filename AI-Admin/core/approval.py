"""Command approval system with comprehensive audit trail"""
import threading
import os
from typing import Optional, Callable
from dataclasses import dataclass, asdict
from datetime import datetime
from tools.audit import audit_log


@dataclass
class ApprovalRequest:
    """Represents a command awaiting approval"""
    command: str
    reason: str
    timestamp: str
    user: str
    session_id: str
    approved: Optional[bool] = None
    approval_timestamp: Optional[str] = None
    denial_reason: Optional[str] = None


class ApprovalManager:
    """Manages command approval workflow with full audit trail"""

    def __init__(self):
        self.pending_request: Optional[ApprovalRequest] = None
        self.approval_callback: Optional[Callable] = None
        self.lock = threading.Lock()
        self.session_id = datetime.now().strftime("%Y%m%d_%H%M%S")

    def set_approval_callback(self, callback: Callable):
        """Set the callback function for requesting user approval"""
        self.approval_callback = callback
        audit_log("APPROVAL_CALLBACK_SET", {
            "session_id": self.session_id,
            "user": os.getenv("USER", "unknown")
        })

    def request_approval(self, command: str, reason: str) -> bool:
        """
        Request user approval for a command with full audit trail.

        Args:
            command: The command to execute
            reason: Why this command is being run (from AI)

        Returns:
            True if approved, False if denied
        """
        with self.lock:
            # Create approval request
            request = ApprovalRequest(
                command=command,
                reason=reason,
                timestamp=datetime.now().isoformat(),
                user=os.getenv("USER", "unknown"),
                session_id=self.session_id
            )

            self.pending_request = request

            # Comprehensive audit log entry for request
            audit_log("APPROVAL_REQUESTED", {
                **asdict(request),
                "hostname": os.uname().nodename,
                "pid": os.getpid()
            })

            # If no callback is set, auto-deny for safety
            if not self.approval_callback:
                self._deny_request(request, "No approval callback configured (safety auto-deny)")
                return False

            # Call the approval callback (blocks until user responds)
            try:
                approved = self.approval_callback(request)
                request.approved = approved
                request.approval_timestamp = datetime.now().isoformat()

                if approved:
                    self._approve_request(request)
                else:
                    self._deny_request(request, "User denied approval")

                return approved

            except Exception as e:
                self._deny_request(request, f"Approval error: {str(e)}")
                return False
            finally:
                self.pending_request = None

    def _approve_request(self, request: ApprovalRequest):
        """Log approval decision"""
        audit_log("APPROVAL_GRANTED", {
            **asdict(request),
            "decision": "APPROVED",
            "hostname": os.uname().nodename,
            "duration_ms": self._calculate_duration(request)
        })

    def _deny_request(self, request: ApprovalRequest, reason: str):
        """Log denial decision"""
        request.approved = False
        request.approval_timestamp = datetime.now().isoformat()
        request.denial_reason = reason

        audit_log("APPROVAL_DENIED", {
            **asdict(request),
            "decision": "DENIED",
            "denial_reason": reason,
            "hostname": os.uname().nodename,
            "duration_ms": self._calculate_duration(request)
        })

    def _calculate_duration(self, request: ApprovalRequest) -> int:
        """Calculate time between request and decision in milliseconds"""
        if not request.approval_timestamp:
            return 0

        start = datetime.fromisoformat(request.timestamp)
        end = datetime.fromisoformat(request.approval_timestamp)
        return int((end - start).total_seconds() * 1000)

    def get_pending_request(self) -> Optional[ApprovalRequest]:
        """Get the current pending approval request"""
        return self.pending_request

    def get_session_summary(self) -> dict:
        """Get summary of approval activity for this session"""
        # This could be enhanced to track all approvals in memory
        return {
            "session_id": self.session_id,
            "user": os.getenv("USER", "unknown"),
            "has_callback": self.approval_callback is not None
        }


# Global approval manager instance
approval_manager = ApprovalManager()
