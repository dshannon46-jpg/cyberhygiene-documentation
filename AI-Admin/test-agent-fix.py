#!/usr/bin/env python3
"""Test the improved agent prompt"""
import sys
sys.path.insert(0, '/home/dshannon/cyberhygiene-ai-admin')

from core.agent import CyberHygieneAgent
from core.approval import approval_manager
from rich.console import Console
from rich.panel import Panel

console = Console()

def auto_approve_callback(request):
    """Auto-approve for testing"""
    console.print(f"[yellow]Auto-approving: {request.command}[/yellow]")
    return True

# Set up auto-approval
approval_manager.set_approval_callback(auto_approve_callback)

# Initialize agent
console.print("[cyan]Initializing agent with improved prompt...[/cyan]\n")
agent = CyberHygieneAgent()

# Test queries
test_queries = [
    "What is the system uptime?",
    "Show disk usage",
    "What's the current CPU usage?"
]

for i, query in enumerate(test_queries, 1):
    console.print(f"\n[bold]Test {i}:[/bold] {query}")
    console.print("="*70)

    try:
        response = agent.run(query)

        console.print(Panel(
            response,
            title=f"[green]Response to Test {i}[/green]",
            border_style="green"
        ))
        console.print("[green]✓ Success[/green]\n")

    except Exception as e:
        console.print(f"[red]✗ Error: {e}[/red]\n")

console.print("\n[bold cyan]Test Complete![/bold cyan]")
console.print("\nCheck logs for details:")
console.print("  tail -f /tmp/dashboard.log")
