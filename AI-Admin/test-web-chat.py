#!/usr/bin/env python3
"""Test the web dashboard AI chat with approval system"""
import socketio
import time
import requests
from rich.console import Console
from rich.panel import Panel

console = Console()

# Connect to the dashboard
sio = socketio.Client()
approval_received = False
agent_response = None

@sio.on('connect')
def on_connect():
    console.print("[green]✓ Connected to dashboard[/green]")

@sio.on('status')
def on_status(data):
    console.print(f"[cyan]Status:[/cyan] {data.get('message', '')}")

@sio.on('approval_request')
def on_approval_request(data):
    """Handle approval request from AI"""
    global approval_received
    approval_received = True

    console.print("\n" + "="*70)
    console.print(Panel(
        f"[bold yellow]APPROVAL REQUEST FROM AI[/bold yellow]\n\n"
        f"[cyan]Command:[/cyan] [bold]{data.get('command', 'N/A')}[/bold]\n"
        f"[cyan]Reason:[/cyan] {data.get('reason', 'N/A')}\n"
        f"[cyan]Timestamp:[/cyan] {data.get('timestamp', 'N/A')}\n"
        f"[cyan]Session:[/cyan] {data.get('session_id', 'N/A')}",
        title="[red]⚠️  Web Approval Request[/red]",
        border_style="yellow",
        padding=(1, 2)
    ))

    # Auto-approve for testing
    console.print("[green]✓ AUTO-APPROVING (test mode)[/green]\n")
    sio.emit('approval_response', {'approved': True})

@sio.on('approval_acknowledged')
def on_approval_ack(data):
    console.print(f"[dim]Approval acknowledged: {data}[/dim]")

@sio.on('user_message')
def on_user_message(data):
    console.print(f"[blue]User:[/blue] {data.get('message', '')}")

@sio.on('agent_thinking')
def on_agent_thinking():
    console.print("[yellow]AI is thinking...[/yellow]")

@sio.on('agent_response')
def on_agent_response(data):
    """Handle AI response"""
    global agent_response
    agent_response = data.get('message', '')

    console.print(Panel(
        agent_response,
        title="[green]AI Response[/green]",
        border_style="green",
        padding=(1, 2)
    ))

@sio.on('error')
def on_error(data):
    console.print(f"[red]Error:[/red] {data.get('message', '')}")

def test_web_chat():
    """Test the web chat functionality"""
    console.print("\n[bold cyan]Testing CyberHygiene AI Web Dashboard[/bold cyan]\n")

    # Test 1: Check if server is running
    console.print("[bold]Test 1: Server connectivity[/bold]")
    try:
        response = requests.get('http://localhost:5500/api/status', timeout=5)
        if response.status_code == 200:
            console.print("✓ Dashboard API responding\n")
        else:
            console.print(f"[red]✗ API returned status {response.status_code}[/red]\n")
            return
    except Exception as e:
        console.print(f"[red]✗ Cannot connect to dashboard: {e}[/red]\n")
        console.print("Make sure the dashboard is running on port 5500")
        return

    # Test 2: Connect via WebSocket
    console.print("[bold]Test 2: WebSocket connection[/bold]")
    try:
        sio.connect('http://localhost:5500')
        time.sleep(1)
        console.print("✓ WebSocket connected\n")
    except Exception as e:
        console.print(f"[red]✗ WebSocket connection failed: {e}[/red]\n")
        return

    # Test 3: Send a chat message
    console.print("[bold]Test 3: Send chat message with command execution[/bold]")
    console.print("Sending: 'What is the system uptime?'\n")

    try:
        # Send the message
        sio.emit('chat_message', {'message': 'What is the system uptime?'})

        # Wait for approval request and response
        timeout = 30
        start_time = time.time()

        while time.time() - start_time < timeout:
            if agent_response:
                break
            time.sleep(0.5)

        if approval_received:
            console.print("\n[green]✓ Test 3 PASSED: Approval system working in web interface[/green]")
        else:
            console.print("\n[yellow]⚠ Test 3 WARNING: No approval request received[/yellow]")

        if agent_response:
            console.print("[green]✓ AI responded successfully[/green]\n")
        else:
            console.print("[yellow]⚠ No response received within timeout[/yellow]\n")

    except Exception as e:
        console.print(f"[red]✗ Test 3 FAILED: {e}[/red]\n")

    # Disconnect
    console.print("[bold]Disconnecting...[/bold]")
    sio.disconnect()
    time.sleep(1)

    # Summary
    console.print("\n" + "="*70)
    console.print("[bold green]Web Dashboard Test Complete![/bold green]")
    console.print("="*70 + "\n")

    console.print("Dashboard URL: [cyan]http://192.168.1.10:5500[/cyan]")
    console.print("\nTo test interactively:")
    console.print("  1. Open browser to http://192.168.1.10:5500")
    console.print("  2. Click the 🤖 button (bottom right)")
    console.print("  3. Click '📊 Status' quick button")
    console.print("  4. Approval dialog should appear")
    console.print("  5. Click 'Approve' to execute command")
    console.print("\nAudit logs: [cyan]/home/dshannon/cyberhygiene-ai-admin/logs/audit.log[/cyan]")

if __name__ == "__main__":
    try:
        test_web_chat()
    except KeyboardInterrupt:
        console.print("\n[yellow]Test interrupted by user[/yellow]")
        try:
            sio.disconnect()
        except:
            pass
