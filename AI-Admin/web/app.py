#!/usr/bin/env python3
"""
CPM System Status Dashboard - Flask Web Application
Secure log viewer and system monitoring interface for cyberinabox.net
With Ollama AI Integration
"""

from flask import Flask, render_template, request, jsonify, send_file, redirect, url_for, session
from flask_socketio import SocketIO, emit
from flask_cors import CORS
from werkzeug.middleware.proxy_fix import ProxyFix
from functools import wraps
import subprocess
import os
import json
import hmac
import hashlib
import threading
import urllib.request
import urllib.error
import socket
from datetime import datetime
import re

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'cpm-dashboard-change-in-production')
CORS(app)
socketio = SocketIO(app, cors_allowed_origins="*", async_mode='eventlet')

# Ollama Configuration
OLLAMA_URL = 'http://192.168.1.7:11434'
OLLAMA_MODEL = 'llama3.3:70b-instruct-q4_K_M'

# Sudo Proxy Integration
sudo_proxy_approvals = {}
sudo_proxy_lock = threading.Lock()
session_conversations = {}

# HMAC key for signing responses
HMAC_KEY_PATH = '/opt/sudo-proxy/keys/approval.key'
try:
    with open(HMAC_KEY_PATH, 'r') as f:
        SUDO_PROXY_HMAC_KEY = f.read().strip().encode()
except:
    SUDO_PROXY_HMAC_KEY = b'development-key-change-in-production'

# Configure session for reverse proxy
app.config['SESSION_COOKIE_PATH'] = '/dashboard'
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'

# Middleware to handle reverse proxy with path prefix
class ReverseProxied(object):
    def __init__(self, app):
        self.app = app

    def __call__(self, environ, start_response):
        script_name = environ.get('HTTP_X_SCRIPT_NAME', '')
        if script_name:
            environ['SCRIPT_NAME'] = script_name
            path_info = environ['PATH_INFO']
            if path_info.startswith(script_name):
                environ['PATH_INFO'] = path_info[len(script_name):]

        scheme = environ.get('HTTP_X_FORWARDED_PROTO', '')
        if scheme:
            environ['wsgi.url_scheme'] = scheme
        return self.app(environ, start_response)

# Apply middleware
app.wsgi_app = ReverseProxied(app.wsgi_app)

# Security configuration
ALLOWED_LOG_FILES = {
    # Wazuh logs
    'wazuh_manager': '/var/ossec/logs/ossec.log',
    'wazuh_alerts': '/var/ossec/logs/alerts/alerts.log',
    'wazuh_integrations': '/var/ossec/logs/integrations.log',
    'wazuh_api': '/var/ossec/logs/api.log',

    # System logs
    'messages': '/var/log/messages',
    'secure': '/var/log/secure',
    'audit': '/var/log/audit/audit.log',

    # FreeIPA logs
    'ldap_access': '/var/log/dirsrv/slapd-CYBERINABOX-NET/access',
    'ldap_errors': '/var/log/dirsrv/slapd-CYBERINABOX-NET/errors',
    'kerberos': '/var/log/krb5kdc.log',
    'httpd_error': '/var/log/httpd/error_log',
    'httpd_access': '/var/log/httpd/access_log',

    # Graylog logs
    'graylog_server': '/var/log/graylog-server/server.log',

    # Mail logs
    'maillog': '/var/log/maillog',

    # Other logs
    'dnf': '/var/log/dnf.log',
    'clamav': '/var/log/clamav/clamd.log',
    'samba': '/var/log/samba/log.smbd',
}

ALLOWED_COMMANDS = {
    # System status
    'uptime': ['uptime'],
    'df': ['df', '-h'],
    'free': ['free', '-h'],
    'top_snapshot': ['top', '-b', '-n', '1', '-o', '%CPU'],

    # Service status
    'wazuh_status': ['sudo', 'systemctl', 'status', 'wazuh-manager'],
    'freeipa_status': ['sudo', 'ipactl', 'status'],
    'httpd_status': ['sudo', 'systemctl', 'status', 'httpd'],
    'graylog_status': ['sudo', 'systemctl', 'status', 'graylog-server'],

    # RAID status
    'mdadm_detail': ['sudo', 'mdadm', '--detail', '/dev/md0'],
    'mdstat': ['cat', '/proc/mdstat'],

    # Security status
    'fips_status': ['fips-mode-setup', '--check'],
    'selinux_status': ['getenforce'],
    'auditd_status': ['sudo', 'systemctl', 'status', 'auditd'],

    # Network status
    'firewall_status': ['sudo', 'firewall-cmd', '--list-all'],
    'listening_ports': ['sudo', 'ss', '-tulpn'],

    # User/auth status
    'ipa_users': ['ipa', 'user-find', '--all'],
    'last_logins': ['last', '-n', '20'],
    'failed_logins': ['sudo', 'lastb', '-n', '20'],
}


def login_required(f):
    """Decorator to require login for protected routes"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'authenticated' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function


# Index route removed - dashboard route now handles root path


@app.route('/login', methods=['GET', 'POST'])
def login():
    """Simple login page - in production, integrate with FreeIPA"""
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        # TODO: Implement proper FreeIPA authentication
        # For now, simple check (CHANGE THIS IN PRODUCTION!)
        if username == 'admin' and password == 'TestPass2025!':
            session['authenticated'] = True
            session['username'] = username
            return redirect(url_for('dashboard'))
        else:
            return render_template('login.html', error='Invalid credentials')

    return render_template('login.html')


@app.route('/logout')
def logout():
    """Logout user"""
    session.clear()
    return redirect(url_for('login'))


@app.route('/debug/env')
def debug_env():
    """Debug endpoint to check environment"""
    return jsonify({
        'script_root': request.script_root,
        'url_root': request.url_root,
        'base_url': request.base_url,
        'path': request.path,
        'full_path': request.full_path,
        'environ_script_name': request.environ.get('SCRIPT_NAME', 'not set'),
        'environ_path_info': request.environ.get('PATH_INFO', 'not set')
    })


@app.route('/')
@login_required
def dashboard():
    """Main dashboard interface"""
    return render_template('dashboard.html',
                          log_files=ALLOWED_LOG_FILES,
                          commands=ALLOWED_COMMANDS)


@app.route('/api/log/<log_name>')
@login_required
def view_log(log_name):
    """API endpoint to view log files"""
    if log_name not in ALLOWED_LOG_FILES:
        return jsonify({'error': 'Log file not allowed'}), 403

    log_path = ALLOWED_LOG_FILES[log_name]

    # Get query parameters
    lines = request.args.get('lines', 100, type=int)
    search = request.args.get('search', '')
    tail = request.args.get('tail', 'true') == 'true'

    # Limit lines to prevent DoS
    lines = min(lines, 10000)

    try:
        if tail:
            # Use tail to get last N lines
            cmd = ['sudo', 'tail', '-n', str(lines), log_path]
        else:
            # Use head to get first N lines
            cmd = ['sudo', 'head', '-n', str(lines), log_path]

        result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)

        if result.returncode != 0:
            return jsonify({
                'error': f'Failed to read log: {result.stderr}',
                'path': log_path
            }), 500

        log_content = result.stdout

        # Apply search filter if provided
        if search:
            lines_list = log_content.split('\n')
            filtered_lines = [line for line in lines_list if search.lower() in line.lower()]
            log_content = '\n'.join(filtered_lines)

        return jsonify({
            'log_name': log_name,
            'path': log_path,
            'content': log_content,
            'lines': len(log_content.split('\n')),
            'search': search,
            'timestamp': datetime.now().isoformat()
        })

    except subprocess.TimeoutExpired:
        return jsonify({'error': 'Command timeout'}), 500
    except FileNotFoundError:
        return jsonify({'error': f'Log file not found: {log_path}'}), 404
    except Exception as e:
        return jsonify({'error': f'Error reading log: {str(e)}'}), 500


@app.route('/api/command/<command_name>')
@login_required
def execute_command(command_name):
    """API endpoint to execute whitelisted commands"""
    if command_name not in ALLOWED_COMMANDS:
        return jsonify({'error': 'Command not allowed'}), 403

    cmd = ALLOWED_COMMANDS[command_name]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)

        return jsonify({
            'command': ' '.join(cmd),
            'output': result.stdout,
            'error': result.stderr,
            'return_code': result.returncode,
            'timestamp': datetime.now().isoformat()
        })

    except subprocess.TimeoutExpired:
        return jsonify({'error': 'Command timeout (30s limit)'}), 500
    except Exception as e:
        return jsonify({'error': f'Error executing command: {str(e)}'}), 500


@app.route('/api/system/status')
@login_required
def system_status():
    """Get overall system status"""
    status = {}

    # Get uptime
    try:
        uptime_output = subprocess.run(['uptime'], capture_output=True, text=True).stdout.strip()
        status['uptime'] = uptime_output
    except:
        status['uptime'] = 'Unknown'

    # Get load average
    try:
        with open('/proc/loadavg', 'r') as f:
            load = f.read().split()[:3]
            status['load_avg'] = ' '.join(load)
    except:
        status['load_avg'] = 'Unknown'

    # Get memory usage
    try:
        mem_output = subprocess.run(['free', '-h'], capture_output=True, text=True).stdout
        status['memory'] = mem_output
    except:
        status['memory'] = 'Unknown'

    # Get disk usage
    try:
        disk_output = subprocess.run(['df', '-h', '/'], capture_output=True, text=True).stdout
        status['disk'] = disk_output
    except:
        status['disk'] = 'Unknown'

    return jsonify(status)


@app.route('/api/logs/tail/<log_name>')
@login_required
def tail_log(log_name):
    """Stream log file updates (for future WebSocket implementation)"""
    if log_name not in ALLOWED_LOG_FILES:
        return jsonify({'error': 'Log file not allowed'}), 403

    log_path = ALLOWED_LOG_FILES[log_name]
    lines = request.args.get('lines', 50, type=int)

    try:
        result = subprocess.run(['sudo', 'tail', '-n', str(lines), log_path],
                              capture_output=True, text=True, timeout=10)

        return jsonify({
            'content': result.stdout,
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# =============================================================
# Ollama Integration
# =============================================================

def call_ollama(messages: list) -> dict:
    """Send chat request to Ollama."""
    url = f"{OLLAMA_URL}/api/chat"
    payload = json.dumps({
        'model': OLLAMA_MODEL,
        'messages': messages,
        'stream': False
    }).encode()

    try:
        req = urllib.request.Request(
            url,
            data=payload,
            headers={'Content-Type': 'application/json'},
            method='POST'
        )
        with urllib.request.urlopen(req, timeout=300) as resp:
            result = json.loads(resp.read().decode())
            return {'response': result.get('message', {}).get('content', 'No response from AI')}
    except urllib.error.HTTPError as e:
        error_body = e.read().decode() if e.fp else str(e)
        return {'error': f'Ollama error ({e.code}): {error_body}'}
    except urllib.error.URLError as e:
        return {'error': f'Cannot reach Ollama: {e.reason}'}
    except Exception as e:
        return {'error': f'Ollama request failed: {str(e)}'}


def check_ollama_health() -> bool:
    """Check if Ollama is reachable"""
    try:
        req = urllib.request.Request(f"{OLLAMA_URL}/api/tags", method='GET')
        with urllib.request.urlopen(req, timeout=5) as resp:
            result = json.loads(resp.read().decode())
            return 'models' in result
    except:
        return False


def sign_approval_response(request_id: str, approved: bool, approver: str, timestamp: str) -> str:
    """Generate HMAC signature for approval response"""
    message = f"{request_id}:{approved}:{approver}:{timestamp}"
    return hmac.new(SUDO_PROXY_HMAC_KEY, message.encode(), hashlib.sha256).hexdigest()


def send_response_to_proxy(request_id: str, approved: bool, approver: str):
    """Send signed approval response back to sudo-proxy"""
    timestamp = datetime.now().isoformat()
    signature = sign_approval_response(request_id, approved, approver, timestamp)

    response = {
        'type': 'approval_response',
        'request_id': request_id,
        'approved': approved,
        'approver': approver,
        'timestamp': timestamp,
        'signature': signature
    }

    try:
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.settimeout(10)
        sock.connect('/run/sudo-proxy/sudo-proxy.sock')
        sock.sendall(json.dumps(response).encode() + b'\n')
        ack = sock.recv(1024)
        sock.close()
        return json.loads(ack.decode().strip()).get('received', False)
    except Exception as e:
        print(f"Error sending to sudo-proxy: {e}")
        return False


@app.route('/api/sudo-approval', methods=['POST'])
@login_required
def handle_sudo_approval_request():
    """Receive approval requests from sudo-proxy"""
    try:
        data = request.get_json()
        if data.get('type') != 'sudo_approval_request':
            return jsonify({'received': False, 'error': 'Invalid request type'}), 400

        request_id = data.get('request_id')
        if not request_id:
            return jsonify({'received': False, 'error': 'Missing request_id'}), 400

        with sudo_proxy_lock:
            sudo_proxy_approvals[request_id] = {
                'request_id': request_id,
                'command_type': data.get('command_type', 'unknown'),
                'args': data.get('args', []),
                'reason': data.get('reason', 'No reason provided'),
                'source': data.get('source', 'unknown'),
                'timestamp': data.get('timestamp', datetime.now().isoformat()),
                'dangerous': data.get('dangerous', False)
            }

        socketio.emit('sudo_approval_request', sudo_proxy_approvals[request_id])
        return jsonify({'received': True})
    except Exception as e:
        return jsonify({'received': False, 'error': str(e)}), 500


@app.route('/api/sudo-approval/pending')
@login_required
def get_pending_sudo_approvals():
    """Get list of pending sudo approval requests"""
    with sudo_proxy_lock:
        return jsonify({
            'success': True,
            'pending': list(sudo_proxy_approvals.values()),
            'count': len(sudo_proxy_approvals)
        })


@app.route('/api/ai/status')
@login_required
def get_ai_status():
    """Get Ollama and Sudo Proxy service status"""
    def check_service(name):
        try:
            result = subprocess.run(['systemctl', 'is-active', name],
                                    capture_output=True, text=True, timeout=5)
            return result.stdout.strip() == 'active'
        except:
            return False

    return jsonify({
        'success': True,
        'ollama': {
            'reachable': check_ollama_health(),
            'url': OLLAMA_URL,
            'model': OLLAMA_MODEL
        },
        'sudo_proxy': {
            'service': check_service('sudo-proxy'),
            'socket': os.path.exists('/run/sudo-proxy/sudo-proxy.sock')
        },
        'pending_approvals': len(sudo_proxy_approvals)
    })


# =============================================================
# WebSocket Event Handlers
# =============================================================

@socketio.on('connect')
def handle_connect():
    """Handle client connection"""
    emit('status', {'message': 'Connected to CPM Dashboard AI Assistant'})


@socketio.on('chat_message')
def handle_chat_message(data):
    """Handle chat message - routes through Ollama"""
    from flask import request as flask_request
    try:
        user_message = data.get('message', '')
        session_id = flask_request.sid

        if not user_message:
            emit('error', {'message': 'Empty message'})
            return

        emit('user_message', {'message': user_message, 'timestamp': datetime.now().isoformat()})

        if session_id not in session_conversations:
            session_conversations[session_id] = []

        session_conversations[session_id].append({'role': 'user', 'content': user_message})

        # Keep last 10 messages
        if len(session_conversations[session_id]) > 10:
            session_conversations[session_id] = session_conversations[session_id][-10:]

        if not check_ollama_health():
            emit('error', {'message': 'Ollama is not reachable. Please ensure the service is running at ' + OLLAMA_URL})
            return

        emit('agent_thinking', {})
        result = call_ollama(session_conversations[session_id])

        if 'error' in result:
            emit('error', {'message': result['error']})
            return

        response_text = result.get('response', 'No response from AI')

        session_conversations[session_id].append({'role': 'assistant', 'content': response_text})

        emit('agent_response', {
            'message': response_text,
            'timestamp': datetime.now().isoformat(),
            'via': 'ollama'
        })
    except Exception as e:
        emit('error', {'message': f'Error: {str(e)}'})


@socketio.on('sudo_approval_response')
def handle_sudo_approval_response(data):
    """Handle user's approval/denial response"""
    request_id = data.get('request_id')
    approved = data.get('approved', False)
    approver = data.get('approver', 'dashboard_user')

    if not request_id:
        emit('sudo_approval_error', {'error': 'Missing request_id'})
        return

    with sudo_proxy_lock:
        if request_id not in sudo_proxy_approvals:
            emit('sudo_approval_error', {'error': 'Unknown or expired request'})
            return
        request_data = sudo_proxy_approvals.pop(request_id, None)

    success = send_response_to_proxy(request_id, approved, approver)

    emit('sudo_approval_acknowledged', {
        'request_id': request_id,
        'approved': approved,
        'sent_to_proxy': success
    })

    socketio.emit('sudo_approval_resolved', {
        'request_id': request_id,
        'approved': approved,
        'approver': approver,
        'command_type': request_data.get('command_type') if request_data else 'unknown'
    })


@socketio.on('clear_conversation')
def handle_clear_conversation():
    """Clear conversation history for this session"""
    from flask import request as flask_request
    session_id = flask_request.sid
    session_conversations.pop(session_id, None)
    emit('conversation_cleared', {'timestamp': datetime.now().isoformat()})


@socketio.on('disconnect')
def handle_disconnect():
    """Handle client disconnection"""
    from flask import request as flask_request
    session_id = flask_request.sid
    session_conversations.pop(session_id, None)


if __name__ == '__main__':
    # Development server - use gunicorn with eventlet in production
    print(f"Starting CPM Dashboard with Ollama integration")
    print(f"Ollama: {OLLAMA_URL} (model: {OLLAMA_MODEL})")
    if check_ollama_health():
        print("Ollama: HEALTHY")
    else:
        print("WARNING: Ollama not responding")
    socketio.run(app, host='0.0.0.0', port=5000, debug=False, allow_unsafe_werkzeug=True)
