"""Interactive CLI interface for CyberHygiene AI Admin Assistant"""
import sys
import os
from datetime import datetime
from typing import Optional

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from rich.console import Console
from rich.panel import Panel
from rich.markdown import Markdown
from rich.table import Table
from rich.prompt import Prompt, Confirm
from rich.live import Live
from rich.spinner import Spinner
from rich import box
from prompt_toolkit import PromptSession
from prompt_toolkit.history import FileHistory
from prompt_toolkit.auto_suggest import AutoSuggestFromHistory

from core.agent import CyberHygieneAgent
from core.config import config
from core.approval import approval_manager, ApprovalRequest


class InteractiveCLI:
    """Interactive command-line interface"""

    def __init__(self):
        """Initialize the CLI"""
        self.console = Console()
        self.agent = None
        self.session = PromptSession(
            history=FileHistory(os.path.expanduser("~/.cyberhygiene_history")),
            auto_suggest=AutoSuggestFromHistory(),
        )

    def print_banner(self):
        """Print welcome banner"""
        banner = """
# CyberHygiene AI Admin Assistant

**NIST 800-171 Compliant System Administration**

Connected to: CodeLlama 34B @ 192.168.1.7
Environment: Rocky Linux 9.6 (FIPS Mode)
"""
        self.console.print(Panel(
            Markdown(banner),
            title="[bold cyan]Welcome[/bold cyan]",
            border_style="cyan",
            box=box.DOUBLE
        ))

    def print_help(self):
        """Print help information"""
        table = Table(title="Available Commands", box=box.ROUNDED)
        table.add_column("Command", style="cyan", no_wrap=True)
        table.add_column("Description", style="white")

        commands = [
            ("/help", "Show this help message"),
            ("/status", "Quick system status overview"),
            ("/logs [service]", "View recent logs (e.g., /logs wazuh)"),
            ("/clear", "Clear the screen"),
            ("/history", "Show recent audit history"),
            ("/exit or /quit", "Exit the assistant"),
            ("", ""),
            ("Any other text", "Ask the AI assistant a question"),
        ]

        for cmd, desc in commands:
            table.add_row(cmd, desc)

        self.console.print(table)

    def approval_callback(self, request: ApprovalRequest) -> bool:
        """
        Handle approval requests from the AI.
        This is called when the AI wants to execute a command.
        """
        # Display approval request in a panel
        self.console.print()
        self.console.print(Panel(
            f"[bold yellow]Command Approval Required[/bold yellow]\n\n"
            f"[cyan]Command:[/cyan] [bold]{request.command}[/bold]\n"
            f"[cyan]Reason:[/cyan] {request.reason}\n"
            f"[cyan]Time:[/cyan] {request.timestamp}\n\n"
            f"[dim]This command will be executed on your system and logged in the audit trail.[/dim]",
            title="[bold red]⚠️  Authorization Request[/bold red]",
            border_style="yellow",
            padding=(1, 2)
        ))

        # Ask for approval
        approved = Confirm.ask(
            "[bold]Do you authorize this command?[/bold]",
            default=False
        )

        if approved:
            self.console.print("[green]✓ Command authorized[/green]\n")
        else:
            self.console.print("[red]✗ Command denied[/red]\n")

        return approved

    def initialize_agent(self):
        """Initialize the AI agent with loading spinner"""
        with self.console.status("[bold green]Initializing AI agent...", spinner="dots"):
            try:
                self.agent = CyberHygieneAgent()

                # Set up approval callback
                approval_manager.set_approval_callback(self.approval_callback)

                self.console.print("[green]✓[/green] Agent initialized successfully")
                self.console.print("[yellow]⚠[/yellow]  Command approval mode: [bold]ENABLED[/bold]")
                self.console.print("[dim]   You will be asked to approve each command before execution[/dim]\n")
            except Exception as e:
                self.console.print(f"[red]✗[/red] Error initializing agent: {e}\n")
                sys.exit(1)

    def handle_command(self, user_input: str) -> bool:
        """
        Handle special commands.

        Returns:
            True if should continue, False if should exit
        """
        cmd = user_input.strip().lower()

        if cmd in ["/exit", "/quit", "/q"]:
            self.console.print("[yellow]Goodbye![/yellow]")
            return False

        elif cmd == "/help" or cmd == "/?":
            self.print_help()

        elif cmd == "/clear":
            self.console.clear()
            self.print_banner()

        elif cmd == "/status":
            self.quick_status()

        elif cmd.startswith("/logs"):
            parts = cmd.split()
            service = parts[1] if len(parts) > 1 else "messages"
            self.show_logs(service)

        elif cmd == "/history":
            self.show_history()

        else:
            # Not a special command, process as normal query
            return None

        return True

    def quick_status(self):
        """Show quick system status"""
        with self.console.status("[bold green]Checking system status...", spinner="dots"):
            response = self.agent.run("Show me a quick system status overview with CPU, memory, and disk usage")

        self.console.print(Panel(
            Markdown(response),
            title="[bold green]System Status[/bold green]",
            border_style="green"
        ))

    def show_logs(self, service: str):
        """Show recent logs for a service"""
        with self.console.status(f"[bold green]Fetching {service} logs...", spinner="dots"):
            response = self.agent.run(f"Show me the last 30 lines of logs for {service}")

        self.console.print(Panel(
            response,
            title=f"[bold yellow]Logs: {service}[/bold yellow]",
            border_style="yellow"
        ))

    def show_history(self):
        """Show recent audit history"""
        from tools.audit import get_recent_audit_logs

        logs = get_recent_audit_logs(count=20)

        table = Table(title="Recent Activity", box=box.ROUNDED)
        table.add_column("Time", style="cyan")
        table.add_column("Event", style="yellow")
        table.add_column("Details", style="white")

        for log in logs:
            time = datetime.fromisoformat(log["timestamp"]).strftime("%H:%M:%S")
            event = log["event_type"]
            details = str(log.get("data", {}))[:50]
            table.add_row(time, event, details)

        self.console.print(table)

    def process_query(self, query: str):
        """Process a user query through the agent"""
        try:
            # Show thinking indicator
            with self.console.status("[bold green]Thinking...", spinner="dots"):
                response = self.agent.run(query)

            # Display response in a panel
            self.console.print(Panel(
                Markdown(response) if response.strip().startswith("#") else response,
                title="[bold blue]Response[/bold blue]",
                border_style="blue",
                padding=(1, 2)
            ))

        except KeyboardInterrupt:
            self.console.print("\n[yellow]Interrupted[/yellow]")
        except Exception as e:
            self.console.print(f"[red]Error: {e}[/red]")

    def run(self):
        """Main CLI loop"""
        self.print_banner()
        self.console.print("[dim]Type /help for available commands, /exit to quit[/dim]\n")

        # Initialize agent
        self.initialize_agent()

        # Main interaction loop
        while True:
            try:
                # Get user input
                user_input = self.session.prompt(
                    "You: ",
                    default="",
                ).strip()

                if not user_input:
                    continue

                # Check for special commands
                result = self.handle_command(user_input)
                if result is False:
                    break
                elif result is True:
                    continue

                # Process normal query
                self.process_query(user_input)
                self.console.print()  # Empty line for spacing

            except KeyboardInterrupt:
                if Confirm.ask("\n[yellow]Exit?[/yellow]"):
                    break
                else:
                    self.console.print()
            except EOFError:
                break
            except Exception as e:
                self.console.print(f"[red]Error: {e}[/red]")


def main():
    """Main entry point"""
    cli = InteractiveCLI()
    cli.run()


if __name__ == "__main__":
    main()
