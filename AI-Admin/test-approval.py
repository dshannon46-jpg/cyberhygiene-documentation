#!/usr/bin/env python3
"""Test the approval system"""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from rich.console import Console
from rich.panel import Panel
from core.approval import approval_manager, ApprovalRequest
from tools.system_tools import SystemTools
from datetime import datetime

console = Console()

def test_approval_callback(request: ApprovalRequest) -> bool:
    """Simulated approval callback for testing"""
    console.print("\n" + "="*60)
    console.print(Panel(
        f"[bold yellow]APPROVAL REQUEST RECEIVED[/bold yellow]\n\n"
        f"[cyan]Command:[/cyan] [bold]{request.command}[/bold]\n"
        f"[cyan]Reason:[/cyan] {request.reason}\n"
        f"[cyan]Timestamp:[/cyan] {request.timestamp}\n"
        f"[cyan]User:[/cyan] {request.user}\n"
        f"[cyan]Session:[/cyan] {request.session_id}",
        title="[red]⚠️  Authorization Request[/red]",
        border_style="yellow"
    ))

    # For testing, auto-approve
    console.print("[green]✓ AUTO-APPROVED (test mode)[/green]\n")
    return True


def test_approval_system():
    """Test the approval system end-to-end"""
    console.print("\n[bold cyan]Testing CyberHygiene AI Approval System[/bold cyan]\n")

    # Set up approval callback
    approval_manager.set_approval_callback(test_approval_callback)
    console.print("✓ Approval callback configured\n")

    # Test 1: Execute a safe command with approval
    console.print("[bold]Test 1: Execute command with approval[/bold]")
    try:
        result = SystemTools.execute_command(
            command="uptime",
            ai_reason="Testing the approval system with uptime command"
        )
        console.print(Panel(
            result,
            title="[green]Command Output[/green]",
            border_style="green"
        ))
        console.print("✓ Test 1 PASSED: Command executed after approval\n")
    except Exception as e:
        console.print(f"[red]✗ Test 1 FAILED: {e}[/red]\n")

    # Test 2: Execute another command to show multiple approvals
    console.print("[bold]Test 2: Execute second command[/bold]")
    try:
        result = SystemTools.execute_command(
            command="hostname",
            ai_reason="Getting hostname to verify system identity"
        )
        console.print(Panel(
            result,
            title="[green]Command Output[/green]",
            border_style="green"
        ))
        console.print("✓ Test 2 PASSED: Second command executed\n")
    except Exception as e:
        console.print(f"[red]✗ Test 2 FAILED: {e}[/red]\n")

    # Test 3: Try a blocked command
    console.print("[bold]Test 3: Try a forbidden command[/bold]")
    try:
        result = SystemTools.execute_command(
            command="rm -rf /tmp/test",
            ai_reason="This should be blocked"
        )
        console.print(f"[red]✗ Test 3 FAILED: Forbidden command was not blocked![/red]\n")
    except Exception as e:
        console.print(Panel(
            f"[green]Command blocked as expected:[/green]\n{str(e)}",
            title="[green]Security Check Passed[/green]",
            border_style="green"
        ))
        console.print("✓ Test 3 PASSED: Forbidden command blocked\n")

    # Test 4: Check audit logs
    console.print("[bold]Test 4: Verify audit trail[/bold]")
    try:
        from tools.audit import get_recent_audit_logs

        logs = get_recent_audit_logs(count=10)
        approval_logs = [l for l in logs if 'APPROVAL' in l.get('event_type', '')]

        console.print(f"Found {len(approval_logs)} approval-related log entries:")
        for log in approval_logs[-5:]:  # Show last 5
            event = log.get('event_type', 'UNKNOWN')
            data = log.get('data', {})
            cmd = data.get('command', 'N/A')
            console.print(f"  • {event}: {cmd}")

        if len(approval_logs) > 0:
            console.print("✓ Test 4 PASSED: Audit trail working\n")
        else:
            console.print("[yellow]⚠ Test 4 WARNING: No approval logs found[/yellow]\n")
    except Exception as e:
        console.print(f"[red]✗ Test 4 FAILED: {e}[/red]\n")

    # Summary
    console.print("\n" + "="*60)
    console.print("[bold green]Approval System Test Complete![/bold green]")
    console.print("="*60 + "\n")

    console.print("Audit log location: [cyan]~/cyberhygiene-ai-admin/logs/audit.log[/cyan]")
    console.print("\nTo view full audit trail:")
    console.print("  [cyan]tail -20 ~/cyberhygiene-ai-admin/logs/audit.log[/cyan]")
    console.print("\nTo view only approval events:")
    console.print("  [cyan]grep APPROVAL ~/cyberhygiene-ai-admin/logs/audit.log | tail -10[/cyan]")


if __name__ == "__main__":
    test_approval_system()
