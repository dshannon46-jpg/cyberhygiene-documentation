# Chapter 37: API & Integrations

## 37.1 FreeIPA API

### API Overview

**FreeIPA JSON-RPC API:**
```
Endpoint: https://dc1.cyberinabox.net/ipa/json
Protocol: JSON-RPC 2.0 over HTTPS
Authentication: Kerberos (GSSAPI) or session cookie
Port: 443 (HTTPS)
Documentation: https://dc1.cyberinabox.net/ipa/ui/#/p/apibrowser/

API Version: 2.251
Methods: 600+ available commands
Categories:
  - User management (user-*)
  - Group management (group-*)
  - Host management (host-*)
  - Service management (service-*)
  - DNS management (dnsrecord-*, dnszone-*)
  - Certificate management (cert-*)
  - SUDO rules (sudorule-*)
  - HBAC rules (hbacrule-*)
```

### Authentication Methods

**Method 1: Kerberos Authentication (Recommended)**
```bash
# Obtain Kerberos ticket
kinit admin@CYBERINABOX.NET

# Use ipa command (automatically uses Kerberos)
ipa user-show jsmith

# API call with curl (using Kerberos)
curl -X POST \
  --negotiate -u : \
  -H "Content-Type: application/json" \
  -H "Referer: https://dc1.cyberinabox.net/ipa" \
  -d '{"method":"user_show","params":[["jsmith"],{}],"id":0}' \
  https://dc1.cyberinabox.net/ipa/json
```

**Method 2: Session Cookie Authentication**
```bash
# Login and get session cookie
curl -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Referer: https://dc1.cyberinabox.net/ipa" \
  -c /tmp/ipa-cookie.txt \
  --data "user=admin&password=PASSWORD" \
  https://dc1.cyberinabox.net/ipa/session/login_password

# Use session cookie for API calls
curl -X POST \
  -b /tmp/ipa-cookie.txt \
  -H "Content-Type: application/json" \
  -H "Referer: https://dc1.cyberinabox.net/ipa" \
  -d '{"method":"user_find","params":[[],{"all":true}],"id":0}' \
  https://dc1.cyberinabox.net/ipa/json
```

### Common API Operations

**User Management:**
```bash
# Find users
ipa user-find --all

# Show user details
ipa user-show jsmith --all

# Add user
ipa user-add newuser \
  --first=New \
  --last=User \
  --email=newuser@cyberinabox.net \
  --homedir=/home/newuser \
  --shell=/bin/bash

# Modify user
ipa user-mod jsmith --title="Senior Engineer"

# Disable user
ipa user-disable jsmith

# Enable user
ipa user-enable jsmith

# Delete user (with preservation)
ipa user-del jsmith --preserve

# Permanently delete
ipa user-del jsmith
```

**Group Management:**
```bash
# Find groups
ipa group-find

# Create group
ipa group-add developers --desc="Development Team"

# Add members
ipa group-add-member developers --users=jsmith,anotheruser

# Remove members
ipa group-remove-member developers --users=jsmith

# Show group
ipa group-show developers
```

**Host Management:**
```bash
# Add host
ipa host-add newserver.cyberinabox.net \
  --ip-address=192.168.1.100 \
  --location="Server Room" \
  --platform="x86_64"

# Show host
ipa host-show newserver.cyberinabox.net

# Add host to group
ipa hostgroup-add-member webservers --hosts=newserver.cyberinabox.net

# Remove host
ipa host-del newserver.cyberinabox.net
```

**DNS Management:**
```bash
# Add A record
ipa dnsrecord-add cyberinabox.net newhost \
  --a-rec=192.168.1.100

# Add CNAME record
ipa dnsrecord-add cyberinabox.net www \
  --cname-rec=newhost.cyberinabox.net.

# Add PTR record
ipa dnsrecord-add 1.168.192.in-addr.arpa 100 \
  --ptr-rec=newhost.cyberinabox.net.

# Show DNS record
ipa dnsrecord-show cyberinabox.net newhost

# Delete DNS record
ipa dnsrecord-del cyberinabox.net newhost
```

### Python API Integration

**Python Example:**
```python
#!/usr/bin/env python3
"""
FreeIPA API example using python-ipalib
"""
from ipalib import api
from ipalib import errors

# Initialize API
api.bootstrap(context='cli')
api.finalize()

# Connect (requires Kerberos ticket)
api.Backend.rpcclient.connect()

try:
    # Find all users
    result = api.Command.user_find(all=True)
    print(f"Found {result['count']} users")

    for user in result['result']:
        print(f"  - {user['uid'][0]}: {user['cn'][0]}")

    # Show specific user
    user_details = api.Command.user_show('jsmith', all=True)
    print(f"\nUser details: {user_details['result']}")

    # Add user
    new_user = api.Command.user_add(
        'testuser',
        givenname='Test',
        sn='User',
        mail='testuser@cyberinabox.net',
        userpassword='TempPassword123!'
    )
    print(f"Created user: {new_user['result']['uid'][0]}")

except errors.DuplicateEntry:
    print("User already exists")
except errors.NotFound:
    print("User not found")
except Exception as e:
    print(f"Error: {e}")
finally:
    api.Backend.rpcclient.disconnect()
```

## 37.2 Wazuh API

### API Overview

**Wazuh RESTful API:**
```
Endpoint: https://wazuh.cyberinabox.net:55000
Protocol: REST (HTTPS)
Authentication: JWT tokens
Port: 55000
Documentation: https://documentation.wazuh.com/current/user-manual/api/reference.html

API Version: 4.8.0
Authentication: Bearer token (JWT)
Rate Limit: 100 requests/minute per token
TLS: Required (mutual TLS available)
```

### Authentication

**Obtain JWT Token:**
```bash
# Login with credentials
TOKEN=$(curl -u admin:PASSWORD -k -X POST \
  "https://wazuh.cyberinabox.net:55000/security/user/authenticate?raw=true")

echo "Token: $TOKEN"

# Use token in subsequent requests
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/" \
  -H "Authorization: Bearer $TOKEN"
```

### Common API Operations

**Agent Management:**
```bash
# List all agents
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/agents?pretty=true&wait_for_complete=true" \
  -H "Authorization: Bearer $TOKEN"

# Get agent details
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/agents/001?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Get agent status
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/agents/001/stats?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Restart agent
curl -k -X PUT \
  "https://wazuh.cyberinabox.net:55000/agents/001/restart?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Delete agent
curl -k -X DELETE \
  "https://wazuh.cyberinabox.net:55000/agents/001?pretty=true" \
  -H "Authorization: Bearer $TOKEN"
```

**Alert Queries:**
```bash
# Get recent alerts
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/security/alerts?pretty=true&limit=100" \
  -H "Authorization: Bearer $TOKEN"

# Get alerts for specific agent
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/security/alerts?pretty=true&agents_list=001" \
  -H "Authorization: Bearer $TOKEN"

# Filter by severity level
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/security/alerts?pretty=true&level=10" \
  -H "Authorization: Bearer $TOKEN"

# Filter by rule ID
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/security/alerts?pretty=true&rule_id=5503" \
  -H "Authorization: Bearer $TOKEN"
```

**Rules and Decoders:**
```bash
# List all rules
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/rules?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Get specific rule
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/rules/5503?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# List decoders
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/decoders?pretty=true" \
  -H "Authorization: Bearer $TOKEN"
```

**Configuration Management:**
```bash
# Get manager configuration
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/manager/configuration?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Get agent configuration
curl -k -X GET \
  "https://wazuh.cyberinabox.net:55000/agents/001/config/client?pretty=true" \
  -H "Authorization: Bearer $TOKEN"

# Update agent configuration
curl -k -X PUT \
  "https://wazuh.cyberinabox.net:55000/agents/groups/001/configuration?pretty=true" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/xml" \
  -d @new_config.xml
```

### Python Integration

**Python Example:**
```python
#!/usr/bin/env python3
"""
Wazuh API example using requests library
"""
import requests
import json
from base64 import b64encode

# Disable SSL warnings for self-signed cert
requests.packages.urllib3.disable_warnings()

# API configuration
WAZUH_API = "https://wazuh.cyberinabox.net:55000"
USERNAME = "admin"
PASSWORD = "your_password"

# Authenticate
def get_token():
    credentials = f"{USERNAME}:{PASSWORD}"
    encoded = b64encode(credentials.encode()).decode()
    headers = {
        'Authorization': f'Basic {encoded}'
    }
    response = requests.post(
        f"{WAZUH_API}/security/user/authenticate",
        headers=headers,
        params={'raw': 'true'},
        verify=False
    )
    return response.text

# Get all agents
def get_agents(token):
    headers = {
        'Authorization': f'Bearer {token}'
    }
    response = requests.get(
        f"{WAZUH_API}/agents",
        headers=headers,
        params={'pretty': 'true'},
        verify=False
    )
    return response.json()

# Main
if __name__ == "__main__":
    # Get authentication token
    token = get_token()
    print(f"Token obtained: {token[:20]}...")

    # Get agents
    agents = get_agents(token)
    print(f"\nTotal agents: {agents['data']['total_affected_items']}")

    for agent in agents['data']['affected_items']:
        print(f"  - {agent['id']}: {agent['name']} ({agent['ip']}) - {agent['status']}")
```

## 37.3 Prometheus API

### API Overview

**Prometheus HTTP API:**
```
Endpoint: http://monitoring.cyberinabox.net:9091/api/v1/
Protocol: HTTP (JSON)
Authentication: None (internal network)
Port: 9091
Documentation: https://prometheus.io/docs/prometheus/latest/querying/api/

API Version: v1
Query Language: PromQL
Response Format: JSON
Time Series Database
```

### Query API

**Instant Queries:**
```bash
# Query current value
curl -G 'http://monitoring.cyberinabox.net:9091/api/v1/query' \
  --data-urlencode 'query=up'

# CPU usage for all nodes
curl -G 'http://monitoring.cyberinabox.net:9091/api/v1/query' \
  --data-urlencode 'query=100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)'

# Memory usage percentage
curl -G 'http://monitoring.cyberinabox.net:9091/api/v1/query' \
  --data-urlencode 'query=(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100'

# Disk usage
curl -G 'http://monitoring.cyberinabox.net:9091/api/v1/query' \
  --data-urlencode 'query=(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100'
```

**Range Queries:**
```bash
# Query over time range
curl -G 'http://monitoring.cyberinabox.net:9091/api/v1/query_range' \
  --data-urlencode 'query=node_load1' \
  --data-urlencode 'start=2025-12-31T00:00:00Z' \
  --data-urlencode 'end=2025-12-31T23:59:59Z' \
  --data-urlencode 'step=300s'

# Network traffic over last hour
curl -G 'http://monitoring.cyberinabox.net:9091/api/v1/query_range' \
  --data-urlencode 'query=rate(node_network_receive_bytes_total[5m])' \
  --data-urlencode 'start='$(date -u -d '1 hour ago' +%s) \
  --data-urlencode 'end='$(date -u +%s) \
  --data-urlencode 'step=60s'
```

### Metadata Queries

**Target Discovery:**
```bash
# List all targets
curl 'http://monitoring.cyberinabox.net:9091/api/v1/targets'

# List active targets only
curl 'http://monitoring.cyberinabox.net:9091/api/v1/targets?state=active'

# List all labels
curl 'http://monitoring.cyberinabox.net:9091/api/v1/labels'

# Get values for specific label
curl 'http://monitoring.cyberinabox.net:9091/api/v1/label/job/values'
```

**Series Queries:**
```bash
# Find series matching label selectors
curl -G 'http://monitoring.cyberinabox.net:9091/api/v1/series' \
  --data-urlencode 'match[]=up' \
  --data-urlencode 'match[]=node_cpu_seconds_total{instance="dc1.cyberinabox.net:9100"}'

# Get metric metadata
curl 'http://monitoring.cyberinabox.net:9091/api/v1/metadata'
```

### Python Integration

**Python Example:**
```python
#!/usr/bin/env python3
"""
Prometheus API query example
"""
import requests
import json
from datetime import datetime, timedelta

PROMETHEUS_URL = "http://monitoring.cyberinabox.net:9091"

def query_prometheus(query):
    """Execute instant query"""
    response = requests.get(
        f"{PROMETHEUS_URL}/api/v1/query",
        params={'query': query}
    )
    return response.json()

def query_range(query, hours=1, step='60s'):
    """Execute range query"""
    end_time = datetime.now()
    start_time = end_time - timedelta(hours=hours)

    response = requests.get(
        f"{PROMETHEUS_URL}/api/v1/query_range",
        params={
            'query': query,
            'start': start_time.timestamp(),
            'end': end_time.timestamp(),
            'step': step
        }
    )
    return response.json()

def get_system_metrics():
    """Get current system metrics for all nodes"""
    metrics = {}

    # CPU usage
    cpu_query = '100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)'
    cpu_result = query_prometheus(cpu_query)

    for item in cpu_result['data']['result']:
        instance = item['metric']['instance']
        value = float(item['value'][1])
        metrics[instance] = {'cpu_percent': round(value, 2)}

    # Memory usage
    mem_query = '(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100'
    mem_result = query_prometheus(mem_query)

    for item in mem_result['data']['result']:
        instance = item['metric']['instance']
        value = float(item['value'][1])
        if instance in metrics:
            metrics[instance]['memory_percent'] = round(value, 2)

    return metrics

if __name__ == "__main__":
    # Get current metrics
    metrics = get_system_metrics()

    print("Current System Metrics:\n")
    for instance, data in metrics.items():
        print(f"{instance}:")
        print(f"  CPU: {data.get('cpu_percent', 'N/A')}%")
        print(f"  Memory: {data.get('memory_percent', 'N/A')}%")
        print()

    # Query CPU history for last hour
    print("CPU Usage History (last hour):")
    cpu_history = query_range(
        'avg by (instance) (rate(node_cpu_seconds_total{mode!="idle"}[5m])) * 100',
        hours=1
    )

    for series in cpu_history['data']['result']:
        instance = series['metric']['instance']
        values = series['values']
        print(f"\n{instance}:")
        for timestamp, value in values[-5:]:  # Last 5 data points
            dt = datetime.fromtimestamp(timestamp)
            print(f"  {dt.strftime('%H:%M:%S')}: {float(value):.2f}%")
```

## 37.4 Grafana API

### API Overview

**Grafana HTTP API:**
```
Endpoint: https://grafana.cyberinabox.net/api/
Protocol: HTTPS (JSON)
Authentication: API Key or Basic Auth
Port: 3001 (proxied via nginx on 443)
Documentation: https://grafana.com/docs/grafana/latest/http_api/

API Version: Grafana 10.2.3
Authentication Methods:
  - API Key (recommended)
  - Basic Auth (username/password)
  - Session cookie
```

### Authentication

**Create API Key:**
```bash
# Via Grafana UI:
# 1. Settings → API Keys → Add API Key
# 2. Set name, role (Admin/Editor/Viewer), expiration
# 3. Copy key (shown only once)

# Test API key
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/org
```

**Basic Authentication:**
```bash
# Using username and password
curl -u admin:PASSWORD \
  https://grafana.cyberinabox.net/api/org
```

### Dashboard Management

**List Dashboards:**
```bash
# Get all dashboards
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/search?type=dash-db

# Search dashboards by tag
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/search?tag=security

# Get dashboard by UID
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/dashboards/uid/node-exporter-full
```

**Create/Update Dashboard:**
```bash
# Export dashboard as JSON
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/dashboards/uid/node-exporter-full \
  > dashboard.json

# Create new dashboard
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d @dashboard.json \
  https://grafana.cyberinabox.net/api/dashboards/db

# Delete dashboard
curl -X DELETE \
  -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/dashboards/uid/DASHBOARD_UID
```

### User Management

**List Users:**
```bash
# Get all users
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/users

# Get user by ID
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/users/2

# Search users
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/users/search?query=smith
```

**Create User:**
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Smith",
    "email": "jsmith@cyberinabox.net",
    "login": "jsmith",
    "password": "TempPassword123!"
  }' \
  https://grafana.cyberinabox.net/api/admin/users
```

### Alerts and Annotations

**Get Alerts:**
```bash
# List all alerts
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/alerts

# Get alert by ID
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://grafana.cyberinabox.net/api/alerts/1
```

**Create Annotation:**
```bash
# Add annotation (event marker)
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "dashboardId": 1,
    "panelId": 1,
    "time": '$(date +%s000)',
    "text": "Deployment completed",
    "tags": ["deployment", "production"]
  }' \
  https://grafana.cyberinabox.net/api/annotations
```

### Python Integration

**Python Example:**
```python
#!/usr/bin/env python3
"""
Grafana API automation example
"""
import requests
import json

GRAFANA_URL = "https://grafana.cyberinabox.net"
API_KEY = "your_api_key_here"

headers = {
    'Authorization': f'Bearer {API_KEY}',
    'Content-Type': 'application/json'
}

def search_dashboards(tag=None):
    """Search for dashboards"""
    params = {'type': 'dash-db'}
    if tag:
        params['tag'] = tag

    response = requests.get(
        f"{GRAFANA_URL}/api/search",
        headers=headers,
        params=params,
        verify=True
    )
    return response.json()

def get_dashboard(uid):
    """Get dashboard by UID"""
    response = requests.get(
        f"{GRAFANA_URL}/api/dashboards/uid/{uid}",
        headers=headers,
        verify=True
    )
    return response.json()

def create_annotation(dashboard_id, text, tags=None):
    """Create annotation on dashboard"""
    import time

    data = {
        'dashboardId': dashboard_id,
        'time': int(time.time() * 1000),
        'text': text
    }
    if tags:
        data['tags'] = tags

    response = requests.post(
        f"{GRAFANA_URL}/api/annotations",
        headers=headers,
        json=data,
        verify=True
    )
    return response.json()

def backup_all_dashboards(output_dir='/tmp/grafana-backup'):
    """Backup all dashboards to JSON files"""
    import os

    os.makedirs(output_dir, exist_ok=True)

    dashboards = search_dashboards()
    print(f"Found {len(dashboards)} dashboards")

    for dash in dashboards:
        uid = dash['uid']
        title = dash['title'].replace('/', '_')

        # Get full dashboard
        full_dash = get_dashboard(uid)

        # Save to file
        filename = f"{output_dir}/{title}_{uid}.json"
        with open(filename, 'w') as f:
            json.dump(full_dash, f, indent=2)

        print(f"Backed up: {title}")

if __name__ == "__main__":
    # List all dashboards
    dashboards = search_dashboards()
    print(f"Found {len(dashboards)} dashboards:\n")

    for dash in dashboards:
        print(f"  - {dash['title']} (UID: {dash['uid']})")
        print(f"    Tags: {', '.join(dash.get('tags', []))}")
        print(f"    URL: {dash['url']}")
        print()

    # Backup all dashboards
    print("\nBacking up dashboards...")
    backup_all_dashboards()
```

## 37.5 Graylog API

### API Overview

**Graylog REST API:**
```
Endpoint: https://graylog.cyberinabox.net/api
Protocol: HTTPS (JSON)
Authentication: Basic Auth or Session Token
Port: 9000 (HTTPS via reverse proxy)
Documentation: https://graylog.cyberinabox.net/api/api-browser

API Version: 5.2.3
Authentication: Basic Auth (username:password)
Rate Limit: None configured
```

### Authentication

**Basic Authentication:**
```bash
# Using admin credentials
curl -u admin:PASSWORD \
  https://graylog.cyberinabox.net/api/system

# Create API token (recommended)
curl -u admin:PASSWORD -X POST \
  https://graylog.cyberinabox.net/api/users/admin/tokens/token_name
```

### Search API

**Execute Search:**
```bash
# Simple text search
curl -u admin:PASSWORD -X GET \
  "https://graylog.cyberinabox.net/api/search/universal/relative?query=failed&range=3600&limit=100"

# Field-specific search
curl -u admin:PASSWORD -X GET \
  "https://graylog.cyberinabox.net/api/search/universal/relative?query=source:dc1%20AND%20ssh&range=3600"

# Search with absolute time range
curl -u admin:PASSWORD -X GET \
  "https://graylog.cyberinabox.net/api/search/universal/absolute?query=*&from=2025-12-31T00:00:00.000Z&to=2025-12-31T23:59:59.999Z"
```

**Field Statistics:**
```bash
# Get field statistics
curl -u admin:PASSWORD -X GET \
  "https://graylog.cyberinabox.net/api/search/universal/relative/stats?field=response_time&query=*&range=3600"

# Field histogram
curl -u admin:PASSWORD -X GET \
  "https://graylog.cyberinabox.net/api/search/universal/relative/histogram?query=*&interval=hour&range=86400"
```

### Stream Management

**List Streams:**
```bash
# Get all streams
curl -u admin:PASSWORD \
  https://graylog.cyberinabox.net/api/streams

# Get stream by ID
curl -u admin:PASSWORD \
  https://graylog.cyberinabox.net/api/streams/STREAM_ID
```

**Create Stream:**
```bash
curl -u admin:PASSWORD -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "title": "SSH Failures",
    "description": "Failed SSH login attempts",
    "matching_type": "AND",
    "remove_matches_from_default_stream": false
  }' \
  https://graylog.cyberinabox.net/api/streams
```

### Input Management

**List Inputs:**
```bash
# Get all inputs
curl -u admin:PASSWORD \
  https://graylog.cyberinabox.net/api/system/inputs

# Get input by ID
curl -u admin:PASSWORD \
  https://graylog.cyberinabox.net/api/system/inputs/INPUT_ID
```

### Python Integration

**Python Example:**
```python
#!/usr/bin/env python3
"""
Graylog API query example
"""
import requests
from datetime import datetime, timedelta
import json

GRAYLOG_URL = "https://graylog.cyberinabox.net/api"
USERNAME = "admin"
PASSWORD = "your_password"

auth = (USERNAME, PASSWORD)

def search_logs(query, hours=1, limit=100):
    """Search logs with relative time range"""
    range_seconds = hours * 3600

    response = requests.get(
        f"{GRAYLOG_URL}/search/universal/relative",
        auth=auth,
        params={
            'query': query,
            'range': range_seconds,
            'limit': limit,
            'sort': 'timestamp:desc'
        },
        verify=True
    )
    return response.json()

def get_field_terms(field, query='*', hours=1):
    """Get top values for a field"""
    range_seconds = hours * 3600

    response = requests.get(
        f"{GRAYLOG_URL}/search/universal/relative/terms",
        auth=auth,
        params={
            'field': field,
            'query': query,
            'range': range_seconds,
            'size': 50
        },
        verify=True
    )
    return response.json()

def get_message_count(query='*', hours=24):
    """Get message count matching query"""
    range_seconds = hours * 3600

    response = requests.get(
        f"{GRAYLOG_URL}/count/total",
        auth=auth,
        params={
            'query': query,
            'range': range_seconds
        },
        verify=True
    )
    return response.json()

if __name__ == "__main__":
    # Search for failed SSH attempts
    print("Recent SSH Failures:\n")
    results = search_logs('ssh AND failed', hours=24, limit=10)

    for msg in results.get('messages', []):
        timestamp = msg['message']['timestamp']
        source = msg['message'].get('source', 'unknown')
        message = msg['message'].get('message', '')
        print(f"{timestamp} - {source}: {message[:80]}")

    print(f"\nTotal: {results.get('total_results', 0)} failures")

    # Get top source IPs
    print("\n\nTop Source Hosts:\n")
    top_sources = get_field_terms('source', hours=24)

    for term in top_sources.get('terms', {}).items():
        print(f"  {term[0]}: {term[1]} messages")

    # Get total message count
    print("\n\nTotal Messages (last 24 hours):")
    count = get_message_count(hours=24)
    print(f"  {count.get('count', 0):,} messages")
```

## 37.6 Integration Patterns

### Service-to-Service Integrations

**Wazuh → Graylog Integration:**
```
Data Flow: Wazuh agents → Wazuh manager → filebeat → Graylog

Configuration:
1. Wazuh manager outputs to filebeat
2. Filebeat forwards to Graylog GELF input (port 12201)
3. Graylog processes and stores Wazuh alerts

File: /etc/filebeat/filebeat.yml
output.logstash:
  hosts: ["graylog.cyberinabox.net:5044"]
  ssl.enabled: true
```

**Prometheus → Grafana Integration:**
```
Data Flow: Exporters → Prometheus → Grafana

Configuration:
1. Prometheus scrapes exporters every 15 seconds
2. Grafana queries Prometheus via HTTP API
3. Dashboards visualize time-series data

Grafana Data Source:
  Type: Prometheus
  URL: http://monitoring.cyberinabox.net:9091
  Access: Server (proxy)
```

**FreeIPA → All Services (LDAP Auth):**
```
Integration: LDAP authentication for all web services

Services Using FreeIPA LDAP:
  - Grafana: LDAP authentication
  - Graylog: LDAP authentication (planned)
  - Roundcube: LDAP addressbook
  - Custom applications: LDAP bind

LDAP Connection:
  Server: ldaps://dc1.cyberinabox.net:636
  Base DN: cn=users,cn=accounts,dc=cyberinabox,dc=net
  Bind DN: uid=readonly,cn=sysaccounts,cn=etc,dc=cyberinabox,dc=net
  TLS: Required (LDAPS)
```

### Webhook Integrations

**Alertmanager Webhook (Prometheus Alerts):**
```yaml
# /etc/alertmanager/alertmanager.yml
route:
  receiver: 'email-admin'
  routes:
    - match:
        severity: 'critical'
      receiver: 'webhook-notify'

receivers:
  - name: 'webhook-notify'
    webhook_configs:
      - url: 'http://monitoring.cyberinabox.net:5001/alerts'
        send_resolved: true
```

**Wazuh Webhook (Custom Alerting):**
```xml
<!-- /var/ossec/etc/ossec.conf -->
<integration>
  <name>custom-webhook</name>
  <hook_url>https://monitoring.cyberinabox.net:5002/wazuh</hook_url>
  <level>10</level>
  <alert_format>json</alert_format>
</integration>
```

### Custom Integration Script

**Example: Sync FreeIPA Users to Application:**
```python
#!/usr/bin/env python3
"""
Sync FreeIPA users to custom application
"""
from ipalib import api
import requests
import json

# Initialize FreeIPA API
api.bootstrap(context='cli')
api.finalize()
api.Backend.rpcclient.connect()

# Application API
APP_URL = "https://app.cyberinabox.net/api"
APP_TOKEN = "your_app_token"

def get_ipa_users():
    """Get all active users from FreeIPA"""
    result = api.Command.user_find(
        all=True,
        sizelimit=0
    )

    users = []
    for user in result['result']:
        if user.get('nsaccountlock', [False])[0]:
            continue  # Skip disabled users

        users.append({
            'username': user['uid'][0],
            'email': user.get('mail', [''])[0],
            'first_name': user.get('givenname', [''])[0],
            'last_name': user.get('sn', [''])[0],
            'groups': user.get('memberof_group', [])
        })

    return users

def sync_user_to_app(user):
    """Sync user to application"""
    headers = {
        'Authorization': f'Bearer {APP_TOKEN}',
        'Content-Type': 'application/json'
    }

    response = requests.post(
        f"{APP_URL}/users/sync",
        headers=headers,
        json=user,
        verify=True
    )

    return response.status_code == 200

if __name__ == "__main__":
    # Get IPA users
    ipa_users = get_ipa_users()
    print(f"Found {len(ipa_users)} active users in FreeIPA")

    # Sync to application
    success_count = 0
    for user in ipa_users:
        if sync_user_to_app(user):
            success_count += 1
            print(f"  ✓ Synced: {user['username']}")
        else:
            print(f"  ✗ Failed: {user['username']}")

    print(f"\nSynced {success_count}/{len(ipa_users)} users")

    api.Backend.rpcclient.disconnect()
```

## 37.7 API Security Best Practices

### Authentication Security

**API Key Management:**
```
Best Practices:
  ✓ Use API keys instead of passwords when possible
  ✓ Rotate API keys quarterly
  ✓ Set expiration dates on API keys
  ✓ Use separate keys for different applications
  ✓ Store keys in environment variables or secrets management
  ✓ Never commit keys to version control
  ✓ Revoke unused or compromised keys immediately

Example (environment variable):
export GRAFANA_API_KEY="your_key_here"
curl -H "Authorization: Bearer $GRAFANA_API_KEY" ...
```

**Kerberos Authentication:**
```bash
# Prefer Kerberos for API access (FreeIPA)
kinit admin@CYBERINABOX.NET
ipa user-find

# Automated scripts should use keytab
kinit -kt /etc/krb5.keytab service/hostname@CYBERINABOX.NET
```

### Rate Limiting

**Client-Side Rate Limiting:**
```python
import time
from functools import wraps

def rate_limit(calls_per_minute=60):
    """Decorator to rate limit API calls"""
    min_interval = 60.0 / calls_per_minute
    last_call = [0.0]

    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            elapsed = time.time() - last_call[0]
            if elapsed < min_interval:
                time.sleep(min_interval - elapsed)

            result = func(*args, **kwargs)
            last_call[0] = time.time()
            return result

        return wrapper
    return decorator

@rate_limit(calls_per_minute=50)  # Under Wazuh's 100/min limit
def query_wazuh_api(endpoint):
    # API call here
    pass
```

### Error Handling

**Robust Error Handling:**
```python
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

def create_session_with_retries():
    """Create requests session with automatic retries"""
    session = requests.Session()

    retry = Retry(
        total=3,
        read=3,
        connect=3,
        backoff_factor=0.5,
        status_forcelist=(500, 502, 503, 504)
    )

    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    session.mount('https://', adapter)

    return session

# Usage
session = create_session_with_retries()

try:
    response = session.get('https://grafana.cyberinabox.net/api/health')
    response.raise_for_status()
    print(response.json())
except requests.exceptions.RequestException as e:
    print(f"API error: {e}")
```

---

**API Integration Quick Reference:**

**FreeIPA API:**
- Endpoint: https://dc1.cyberinabox.net/ipa/json
- Auth: Kerberos (kinit) or session cookie
- Commands: ipa user-*, group-*, host-*, dns*

**Wazuh API:**
- Endpoint: https://wazuh.cyberinabox.net:55000
- Auth: JWT token (Bearer)
- Rate Limit: 100 req/min

**Prometheus API:**
- Endpoint: http://monitoring.cyberinabox.net:9091/api/v1/
- Auth: None (internal)
- Query Language: PromQL

**Grafana API:**
- Endpoint: https://grafana.cyberinabox.net/api/
- Auth: API Key or Basic Auth
- Operations: Dashboard, user, alert management

**Graylog API:**
- Endpoint: https://graylog.cyberinabox.net/api
- Auth: Basic Auth or token
- Operations: Search, streams, inputs

**Integration Points:**
- Wazuh → Graylog (filebeat)
- Prometheus → Grafana (data source)
- FreeIPA → All (LDAP auth)
- Alertmanager → Webhooks

**Security:**
- Use API keys (not passwords)
- Rotate keys quarterly
- Rate limit client-side
- Implement retry logic
- Never commit keys to git

---

**Related Chapters:**
- Chapter 17: Wazuh Security Monitoring
- Chapter 19: Grafana Dashboards
- Chapter 21: Graylog Log Analysis
- Chapter 28: System Monitoring Configuration
- Appendix C: Command Reference

**For API Support:**
- FreeIPA API Browser: https://dc1.cyberinabox.net/ipa/ui/#/p/apibrowser/
- API issues: dshannon@cyberinabox.net
- Security concerns: Report immediately
