# CyberHygiene AI Dashboard - Systemd Service Guide

## Overview

The AI dashboard can run as a systemd service for:
- **Automatic startup** on system boot
- **Automatic restart** on failure
- **Proper logging** via journald
- **Resource management** and limits
- **Standard service management** with systemctl

## Installation

### Install the Service

```bash
cd ~/cyberhygiene-ai-admin
sudo ./install-service.sh
```

This will:
1. Stop any test instances
2. Install the service file to `/etc/systemd/system/`
3. Reload systemd
4. Enable auto-start on boot
5. Start the service immediately

### Default Configuration

- **Port:** 5500 (accessible on all interfaces)
- **URL:** `http://192.168.1.10:5500`
- **User:** dshannon
- **Working Dir:** `/home/dshannon/cyberhygiene-ai-admin`
- **Auto-restart:** Yes (10 second delay)
- **Memory Limit:** 2GB

## Service Management

### Basic Commands

**Start the service:**
```bash
sudo systemctl start cyberhygiene-ai-dashboard
```

**Stop the service:**
```bash
sudo systemctl stop cyberhygiene-ai-dashboard
```

**Restart the service:**
```bash
sudo systemctl restart cyberhygiene-ai-dashboard
```

**Check status:**
```bash
sudo systemctl status cyberhygiene-ai-dashboard
```

**Enable auto-start (on boot):**
```bash
sudo systemctl enable cyberhygiene-ai-dashboard
```

**Disable auto-start:**
```bash
sudo systemctl disable cyberhygiene-ai-dashboard
```

### View Logs

**Live log monitoring:**
```bash
sudo journalctl -u cyberhygiene-ai-dashboard -f
```

**Last 100 lines:**
```bash
sudo journalctl -u cyberhygiene-ai-dashboard -n 100
```

**Logs since today:**
```bash
sudo journalctl -u cyberhygiene-ai-dashboard --since today
```

**Logs from last boot:**
```bash
sudo journalctl -u cyberhygiene-ai-dashboard -b
```

**Search logs:**
```bash
sudo journalctl -u cyberhygiene-ai-dashboard | grep "error"
```

## Configuration

### Change Port

Edit the service file:
```bash
sudo nano /etc/systemd/system/cyberhygiene-ai-dashboard.service
```

Find the `ExecStart` line and change `port=5500` to your desired port:
```ini
ExecStart=/home/dshannon/cyberhygiene-ai-admin/venv/bin/python3 -c "from web.app import main; main(host='0.0.0.0', port=8080, debug=False)"
```

Then reload and restart:
```bash
sudo systemctl daemon-reload
sudo systemctl restart cyberhygiene-ai-dashboard
```

### Change Memory Limit

Edit the service file:
```bash
sudo nano /etc/systemd/system/cyberhygiene-ai-dashboard.service
```

Modify the `MemoryLimit` line:
```ini
MemoryLimit=4G  # Increase to 4GB
```

Reload and restart:
```bash
sudo systemctl daemon-reload
sudo systemctl restart cyberhygiene-ai-dashboard
```

### Change Restart Behavior

Edit the service file to modify:
```ini
Restart=always          # always, on-failure, on-abnormal, on-abort, never
RestartSec=10          # Seconds to wait before restart
```

## Firewall Configuration

If you need to access from other machines, open the port:

```bash
# For firewalld (Rocky Linux default)
sudo firewall-cmd --permanent --add-port=5500/tcp
sudo firewall-cmd --reload

# Verify
sudo firewall-cmd --list-ports
```

## Security Features

The service includes several security hardening features:

- **NoNewPrivileges:** Prevents privilege escalation
- **PrivateTmp:** Isolated /tmp directory
- **ProtectSystem:** Read-only access to system files
- **ProtectHome:** Read-only home directory (except logs)
- **MemoryLimit:** Prevents memory exhaustion
- **TasksMax:** Limits number of processes

## Troubleshooting

### Service won't start

**Check status:**
```bash
sudo systemctl status cyberhygiene-ai-dashboard
```

**Check logs:**
```bash
sudo journalctl -u cyberhygiene-ai-dashboard -n 50
```

**Common issues:**
- Port already in use
- Python virtual environment missing
- Ollama server not accessible
- Permission issues

### Port already in use

Find what's using the port:
```bash
sudo netstat -tlnp | grep 5500
```

Kill the process or change the service port.

### Cannot connect to Ollama

Test connection:
```bash
curl http://192.168.1.7:11434/api/tags
```

If it fails:
- Check Ollama is running on 192.168.1.7
- Verify network connectivity: `ping 192.168.1.7`
- Check firewall rules

### Check if service is enabled

```bash
sudo systemctl is-enabled cyberhygiene-ai-dashboard
```

### Manual debugging

Stop the service and run manually:
```bash
sudo systemctl stop cyberhygiene-ai-dashboard
cd ~/cyberhygiene-ai-admin
./cyberai-web
```

## Monitoring

### Check if service is running

```bash
sudo systemctl is-active cyberhygiene-ai-dashboard
```

### Check process details

```bash
ps aux | grep cyberhygiene-ai
```

### Check memory usage

```bash
sudo systemctl status cyberhygiene-ai-dashboard | grep Memory
```

### Check restart count

```bash
sudo systemctl show cyberhygiene-ai-dashboard | grep NRestarts
```

## Uninstallation

### Remove the Service

```bash
cd ~/cyberhygiene-ai-admin
sudo ./uninstall-service.sh
```

This will:
1. Stop the service
2. Disable auto-start
3. Remove the service file
4. Reload systemd

The application files remain intact and can still be run manually with `./cyberai-web`.

## Integration with System

### Start on boot

The service is configured to start after:
- Network is online
- All network targets are ready

### Logs integration

All logs go to systemd journal:
- Searchable with `journalctl`
- Integrated with system logging
- Automatic rotation

### Resource limits

The service respects system resource limits:
- Memory cap: 2GB
- Max processes: 100
- Nice level: Default

## Best Practices

1. **Use the service for production** - Reliable, auto-starting, managed
2. **Use manual mode for testing** - `./cyberai-web` for development
3. **Monitor logs regularly** - `journalctl -u cyberhygiene-ai-dashboard`
4. **Keep it updated** - Restart after code changes
5. **Check status after reboot** - Ensure it auto-started

## Service File Location

- **Installed:** `/etc/systemd/system/cyberhygiene-ai-dashboard.service`
- **Source:** `/home/dshannon/cyberhygiene-ai-admin/cyberhygiene-ai-dashboard.service`

After editing the source file, reinstall:
```bash
cd ~/cyberhygiene-ai-admin
sudo ./install-service.sh
```

## Example Workflow

**Initial setup:**
```bash
cd ~/cyberhygiene-ai-admin
sudo ./install-service.sh
# Opens browser to http://192.168.1.10:5500
```

**Daily use:**
```bash
# Just open browser - service is always running
# http://192.168.1.10:5500
```

**After updates:**
```bash
cd ~/cyberhygiene-ai-admin
git pull  # or make changes
sudo systemctl restart cyberhygiene-ai-dashboard
```

**Troubleshooting:**
```bash
sudo systemctl status cyberhygiene-ai-dashboard
sudo journalctl -u cyberhygiene-ai-dashboard -f
```

The service makes the AI dashboard a permanent, reliable part of your infrastructure!
