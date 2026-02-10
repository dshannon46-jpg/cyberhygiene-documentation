#!/usr/bin/env python3
"""Simple test script for CyberHygiene AI Admin Assistant"""
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from core.agent import CyberHygieneAgent
from tools.system_tools import SystemTools
from rich.console import Console
from rich.panel import Panel

console = Console()

def test_ollama_connection():
    """Test connection to Ollama server"""
    console.print("\n[bold cyan]Test 1: Ollama Connection[/bold cyan]")
    try:
        import requests
        response = requests.get("http://192.168.1.7:11434/api/tags")
        if response.status_code == 200:
            models = response.json().get("models", [])
            console.print(f"[green]✓[/green] Connected to Ollama server")
            console.print(f"[green]✓[/green] Found {len(models)} models")
            for model in models:
                console.print(f"  - {model['name']}")
            return True
        else:
            console.print(f"[red]✗[/red] Connection failed: HTTP {response.status_code}")
            return False
    except Exception as e:
        console.print(f"[red]✗[/red] Connection error: {e}")
        return False


def test_system_tools():
    """Test system tools"""
    console.print("\n[bold cyan]Test 2: System Tools[/bold cyan]")
    try:
        # Test system status
        status = SystemTools.get_system_status()
        console.print(f"[green]✓[/green] System status: CPU {status['cpu']['percent']}%, Memory {status['memory']['percent']}%")

        # Test safe command
        output = SystemTools.execute_command("uptime")
        console.print(f"[green]✓[/green] Command execution works")

        return True
    except Exception as e:
        console.print(f"[red]✗[/red] Error: {e}")
        return False


def test_agent():
    """Test AI agent"""
    console.print("\n[bold cyan]Test 3: AI Agent[/bold cyan]")
    try:
        console.print("[yellow]Initializing agent...[/yellow]")
        agent = CyberHygieneAgent()
        console.print(f"[green]✓[/green] Agent initialized with {len(agent.tools)} tools")

        console.print("\n[yellow]Testing simple query...[/yellow]")
        response = agent.run("What is the current CPU usage?")
        console.print(Panel(response, title="Agent Response", border_style="green"))

        return True
    except Exception as e:
        console.print(f"[red]✗[/red] Error: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    """Run all tests"""
    console.print(Panel.fit(
        "[bold]CyberHygiene AI Admin Assistant - System Test[/bold]",
        border_style="cyan"
    ))

    results = []

    # Test Ollama
    results.append(("Ollama Connection", test_ollama_connection()))

    # Test System Tools
    results.append(("System Tools", test_system_tools()))

    # Test Agent (only if Ollama is available)
    if results[0][1]:  # If Ollama test passed
        results.append(("AI Agent", test_agent()))

    # Summary
    console.print("\n[bold cyan]Test Summary[/bold cyan]")
    for name, passed in results:
        status = "[green]PASSED[/green]" if passed else "[red]FAILED[/red]"
        console.print(f"{name}: {status}")

    all_passed = all(r[1] for r in results)
    if all_passed:
        console.print("\n[bold green]All tests passed! System is ready to use.[/bold green]")
        console.print("\nTo start:")
        console.print("  CLI mode:  [cyan]./cyberai-cli[/cyan]")
        console.print("  Web mode:  [cyan]./cyberai-web[/cyan]")
    else:
        console.print("\n[bold red]Some tests failed. Please check the errors above.[/bold red]")

    return 0 if all_passed else 1


if __name__ == "__main__":
    sys.exit(main())
