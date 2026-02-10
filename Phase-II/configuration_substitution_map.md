# CyberHygiene Phase II Configuration Substitution Map

**Version:** 1.0
**Date:** 2026-01-01
**Purpose:** Document all configuration items that must be customized per installation

---

## Overview

The CyberHygiene system contains **2,120 references to "cyberinabox.net" across 219 files**. This document maps the substitution variables needed for automated deployment.

---

## Substitution Variables

These variables will be collected from the `installation_info.md` form and substituted throughout the system:

| Variable | Example (CyberInABox) | Example (Customer) | Description |
|----------|----------------------|-------------------|-------------|
| `{{DOMAIN}}` | cyberinabox.net | acmecorp.com | Base domain name |
| `{{REALM}}` | CYBERINABOX.NET | ACMECORP.COM | Kerberos realm (uppercase) |
| `{{BUSINESS_NAME}}` | CyberInABox | Acme Corporation | Legal business name |
| `{{BUSINESS_DBA}}` | CyberHygiene Project | Acme Corp | Doing Business As name |
| `{{SUBNET}}` | 192.168.1 | 192.168.1 | Internal network subnet (first 3 octets) |
| `{{GATEWAY}}` | 192.168.1.1 | 192.168.1.1 | Network gateway IP |
| `{{EXTERNAL_IP}}` | [varies] | [customer IP] | External static IP |
| `{{TIMEZONE}}` | America/Denver | America/New_York | System timezone |
| `{{ADMIN_EMAIL}}` | admin@cyberinabox.net | admin@acmecorp.com | Administrator email |
| `{{DUNS}}` | [varies] | 123456789 | DUNS number |
| `{{CAGE}}` | [varies] | 1A2B3 | CAGE code |
| `{{ADDRESS}}` | [varies] | 123 Main St | Physical address |
| `{{CITY}}` | [varies] | Denver | City |
| `{{STATE}}` | [varies] | CO | State |
| `{{ZIP}}` | [varies] | 80202 | ZIP code |

---

## System Configuration Files Requiring Substitution

### 1. FreeIPA / Identity Management

**Location:** `/etc/ipa/`
**Files:**
- `default.conf` - Domain configuration
- `ca.conf` - Certificate authority settings

**Substitutions:**
- Domain name: `cyberinabox.net` → `{{DOMAIN}}`
- Realm: `CYBERINABOX.NET` → `{{REALM}}`
- Server hostname: `dc1.cyberinabox.net` → `dc1.{{DOMAIN}}`

**Installation Command:**
```bash
ipa-server-install \
  --domain={{DOMAIN}} \
  --realm={{REALM}} \
  --hostname=dc1.{{DOMAIN}} \
  --ds-password={{DS_PASSWORD}} \
  --admin-password={{ADMIN_PASSWORD}} \
  --mkhomedir \
  --setup-dns \
  --auto-forwarders \
  --auto-reverse \
  --no-ntp \
  --unattended
```

---

### 2. DNS Configuration

**Location:** `/etc/named/` and FreeIPA DNS
**Files:**
- FreeIPA manages DNS automatically after domain setup

**Substitutions:**
- Forward zone: `cyberinabox.net` → `{{DOMAIN}}`
- Reverse zone: `1.168.192.in-addr.arpa` → Calculated from `{{SUBNET}}`
- All hostname FQDNs: `[host].cyberinabox.net` → `[host].{{DOMAIN}}`

---

### 3. SSL/TLS Certificates

**Location:** `/etc/pki/tls/` (system-wide) and service-specific directories
**Files:**
- `/etc/pki/tls/certs/*.crt`
- `/etc/pki/tls/private/*.key`
- Service-specific cert paths

**Substitutions:**
- Certificate Common Name (CN): `*.cyberinabox.net` → `*.{{DOMAIN}}`
- Certificate paths in configuration files

**Certificate Deployment Script:** Will copy customer SSL certificate files to appropriate locations

---

### 4. Hostname Configuration

**Location:** `/etc/hostname` on each server
**Files:**
- `/etc/hostname`
- `/etc/hosts`

**Server Hostnames:**
| Server | Current FQDN | New FQDN Template |
|--------|--------------|-------------------|
| DC1 | dc1.cyberinabox.net | dc1.{{DOMAIN}} |
| DMS | dms.cyberinabox.net | dms.{{DOMAIN}} |
| Graylog | graylog.cyberinabox.net | graylog.{{DOMAIN}} |
| Proxy | proxy.cyberinabox.net | proxy.{{DOMAIN}} |
| Monitoring | monitoring.cyberinabox.net | monitoring.{{DOMAIN}} |
| Wazuh | wazuh.cyberinabox.net | wazuh.{{DOMAIN}} |

---

### 5. Network Configuration

**Location:** `/etc/sysconfig/network-scripts/` (Rocky Linux 9)
**Files:**
- `ifcfg-eno1` (or similar interface name)

**Substitutions:**
- IP addresses: `192.168.1.X` → `{{SUBNET}}.X`
- Gateway: `192.168.1.1` → `{{GATEWAY}}`
- DNS servers: FreeIPA DC at `{{SUBNET}}.10`

**IP Address Assignments:**
- dc1: `{{SUBNET}}.10`
- dms: `{{SUBNET}}.20`
- graylog: `{{SUBNET}}.30`
- proxy: `{{SUBNET}}.40`
- monitoring: `{{SUBNET}}.50`
- wazuh: `{{SUBNET}}.60`

---

### 6. Apache/HTTPD Configuration

**Location:** `/etc/httpd/` and service-specific Apache configs
**Files:**
- `/etc/httpd/conf.d/ssl.conf`
- `/etc/httpd/conf.d/*.conf` (various services)
- `/var/www/html/cpm/config.php` (CPM Dashboard)

**Substitutions:**
- ServerName directives: `*.cyberinabox.net` → `*.{{DOMAIN}}`
- SSL certificate paths
- Virtual host configurations

---

### 7. Prometheus Configuration

**Location:** `/etc/prometheus/`
**Files:**
- `prometheus.yml` - Main configuration

**Substitutions:**
- Target hostnames: `dc1.cyberinabox.net:9100` → `dc1.{{DOMAIN}}:9100`
- All scrape targets updated with new domain

**Sample:**
```yaml
scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets:
        - 'dc1.{{DOMAIN}}:9100'
        - 'dms.{{DOMAIN}}:9100'
        - 'graylog.{{DOMAIN}}:9100'
        - 'proxy.{{DOMAIN}}:9100'
        - 'monitoring.{{DOMAIN}}:9100'
        - 'wazuh.{{DOMAIN}}:9100'
```

---

### 8. Grafana Configuration

**Location:** `/etc/grafana/`
**Files:**
- `grafana.ini` - Main configuration
- Dashboard JSON files (if exported)

**Substitutions:**
- `domain` setting: `cyberinabox.net` → `{{DOMAIN}}`
- `root_url`: `https://grafana.cyberinabox.net` → `https://grafana.{{DOMAIN}}`

---

### 9. Graylog Configuration

**Location:** `/etc/graylog/server/`
**Files:**
- `server.conf` - Main configuration

**Substitutions:**
- `http_bind_address`: Update with correct hostname
- `http_external_uri`: `https://graylog.{{DOMAIN}}`
- Elasticsearch node name

---

### 10. Wazuh Configuration

**Location:** `/var/ossec/etc/`
**Files:**
- `ossec.conf` - Wazuh manager configuration
- Agent configs on all servers

**Substitutions:**
- Manager hostname: `wazuh.cyberinabox.net` → `wazuh.{{DOMAIN}}`
- Agent enrollment addresses

**Wazuh Dashboard:**
**Location:** `/etc/wazuh-dashboard/`
**Files:**
- `opensearch_dashboards.yml`

**Substitutions:**
- Server host: Update with `wazuh.{{DOMAIN}}`

---

### 11. Samba Configuration

**Location:** `/etc/samba/`
**Files:**
- `smb.conf` - Samba configuration

**Substitutions:**
- `realm` parameter: `CYBERINABOX.NET` → `{{REALM}}`
- `workgroup`: Derived from domain
- `netbios name`: Server-specific

---

### 12. Email Configuration

**Location:** `/etc/postfix/` or `/etc/dovecot/`
**Files:**
- `main.cf` (Postfix)
- Various dovecot config files

**Substitutions:**
- `myhostname`: `[server].{{DOMAIN}}`
- `mydomain`: `{{DOMAIN}}`
- `myorigin`: `{{DOMAIN}}`

---

### 13. CPM Dashboard

**Location:** `/var/www/html/cpm/`
**Files:**
- `config.php` - Dashboard configuration
- HTML/PHP files with hardcoded URLs

**Substitutions:**
- All service URLs: `https://[service].cyberinabox.net` → `https://[service].{{DOMAIN}}`
- Business name and contact information

---

### 14. Documentation Files

**Location:** `/home/admin/Documents/`
**Files:**
- User Manual (219 files containing domain references)
- Policies and procedures
- Technical documentation

**Substitutions:**
- All instances of `cyberinabox.net` → `{{DOMAIN}}`
- Business name: `CyberInABox` → `{{BUSINESS_NAME}}`
- Contact information in policies

**Note:** Documentation substitution can be done post-installation using automated script

---

### 15. Monitoring Dashboards

**Location:** Various (Grafana, Wazuh, Graylog)
**Files:**
- Grafana dashboard JSON exports
- Wazuh dashboard configurations

**Substitutions:**
- All hostname references in queries and filters
- Dashboard titles if they include domain name

---

### 16. Firewall Rules

**Location:** `/etc/firewalld/` on each server
**Files:**
- Zone configurations
- Rich rules

**Substitutions:**
- Source IP addresses (if static rules based on `{{SUBNET}}`)

---

### 17. Backup Scripts

**Location:** `/usr/local/bin/` or `/opt/backups/`
**Files:**
- Backup automation scripts
- Restore procedures

**Substitutions:**
- Paths containing domain name
- Email notification addresses

---

### 18. Audit and Compliance Files

**Location:** `/home/admin/Documents/Certification and Compliance Evidence/`
**Files:**
- System Security Plan (SSP)
- POA&M documents
- Policy documents

**Substitutions:**
- Business name throughout all documents
- Domain names
- Contact information
- DUNS/CAGE codes
- Physical address information

---

## Automated Substitution Strategy

### Phase 1: Pre-Installation
1. Collect customer information using `installation_info.md` form
2. Validate all required fields are completed
3. Generate substitution variables file: `/root/install_vars.sh`

### Phase 2: During Base OS Installation
1. Set hostname during Rocky Linux installation
2. Configure network interfaces with correct IP addresses
3. Set timezone

### Phase 3: Post-OS Installation
1. Run substitution scripts to update configuration files
2. Install and configure FreeIPA with correct domain/realm
3. Deploy SSL certificates
4. Configure all services with new domain

### Phase 4: Service Configuration
1. Deploy service configurations with substitutions applied
2. Start services in dependency order
3. Verify connectivity and DNS resolution

### Phase 5: Documentation Update
1. Run documentation substitution script
2. Update all policy documents
3. Generate customer-specific compliance documents

---

## Substitution Script Template

```bash
#!/bin/bash
# Phase II Configuration Substitution Script
# Version 1.0

# Load installation variables
source /root/install_vars.sh

# Validate required variables
required_vars=(
    "DOMAIN"
    "REALM"
    "BUSINESS_NAME"
    "SUBNET"
)

for var in "${required_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
        echo "ERROR: Required variable $var is not set"
        exit 1
    fi
done

# Function to substitute in file
substitute_in_file() {
    local file="$1"
    local backup="${file}.bak"

    # Create backup
    cp "$file" "$backup"

    # Perform substitutions
    sed -i "s/cyberinabox\.net/${DOMAIN}/g" "$file"
    sed -i "s/CYBERINABOX\.NET/${REALM}/g" "$file"
    sed -i "s/CyberInABox/${BUSINESS_NAME}/g" "$file"
    sed -i "s/192\.168\.1\./${SUBNET}./g" "$file"

    # Add more substitutions as needed
}

# Process configuration files
echo "Starting configuration substitution..."

# Example: Update Apache config
if [[ -f /etc/httpd/conf.d/ssl.conf ]]; then
    substitute_in_file /etc/httpd/conf.d/ssl.conf
fi

# Example: Update Prometheus config
if [[ -f /etc/prometheus/prometheus.yml ]]; then
    substitute_in_file /etc/prometheus/prometheus.yml
fi

# Continue for all config files...

echo "Configuration substitution complete"
```

---

## Installation Variables File Template

**File:** `/root/install_vars.sh`

```bash
#!/bin/bash
# CyberHygiene Phase II Installation Variables
# Auto-generated from installation_info.md

# Domain Configuration
export DOMAIN="acmecorp.com"
export REALM="ACMECORP.COM"
export SUBDOMAIN_PREFIX="cyberhygiene"  # Optional

# Business Information
export BUSINESS_NAME="Acme Corporation"
export BUSINESS_DBA="Acme Corp"
export DUNS="123456789"
export CAGE="1A2B3"
export ADDRESS="123 Main Street"
export CITY="Denver"
export STATE="CO"
export ZIP="80202"

# Network Configuration
export SUBNET="192.168.1"
export GATEWAY="192.168.1.1"
export EXTERNAL_IP="203.0.113.10"
export DNS_FORWARDERS="8.8.8.8,8.8.4.4"

# Server IP Assignments
export DC1_IP="${SUBNET}.10"
export DMS_IP="${SUBNET}.20"
export GRAYLOG_IP="${SUBNET}.30"
export PROXY_IP="${SUBNET}.40"
export MONITORING_IP="${SUBNET}.50"
export WAZUH_IP="${SUBNET}.60"

# System Configuration
export TIMEZONE="America/New_York"
export ADMIN_EMAIL="admin@${DOMAIN}"

# Installation Secrets (generated during install)
export DS_PASSWORD="[generated]"
export ADMIN_PASSWORD="[generated]"
export GRUB_PASSWORD="[generated]"

# SSL Certificate Paths
export SSL_CERT_PATH="/root/ssl-certificates/wildcard.crt"
export SSL_KEY_PATH="/root/ssl-certificates/wildcard.key"
export SSL_CHAIN_PATH="/root/ssl-certificates/ca-bundle.crt"

# Installation Metadata
export INSTALL_DATE="$(date +%Y-%m-%d)"
export INSTALLER_NAME="[Installer Name]"
export CUSTOMER_CONTACT="[Customer Name]"
export CUSTOMER_EMAIL="[Customer Email]"
export CUSTOMER_PHONE="[Customer Phone]"
```

---

## File Categories by Substitution Priority

### Priority 1: Critical (Must substitute before system functions)
- FreeIPA domain/realm configuration
- DNS zone files
- Network interface configurations
- Hostname files

### Priority 2: Service Configuration (Required for services to start)
- Apache virtual hosts
- Prometheus targets
- Wazuh manager configuration
- Samba realm configuration
- Email server domain settings

### Priority 3: Documentation (Can be done post-deployment)
- User Manual files
- Policy documents
- Technical documentation
- Compliance evidence

### Priority 4: Optional (Cosmetic or informational)
- Dashboard titles
- Email templates
- Welcome messages
- Capability statements

---

## Verification Checklist

After substitution, verify:

- [ ] All services resolve DNS to correct FQDNs
- [ ] SSL certificates match deployed domain
- [ ] FreeIPA realm matches domain (uppercase)
- [ ] All inter-service communication works
- [ ] Monitoring targets accessible
- [ ] Web dashboards accessible via correct URLs
- [ ] Email headers show correct domain
- [ ] File sharing uses correct realm for Kerberos
- [ ] Documentation references correct business name
- [ ] Compliance documents have correct company info

---

## Notes

1. **Backup Strategy:** All configuration files must be backed up before substitution
2. **Rollback Capability:** Keep `.bak` files for 30 days post-installation
3. **Testing:** Test substitution on development system before production deployment
4. **Manual Review:** Critical files should be manually reviewed after automated substitution
5. **Documentation:** Document any manual changes required that couldn't be automated

---

**Last Updated:** 2026-01-01
**Version:** 1.0
**File Location:** `/home/admin/Documents/Installer/configuration_substitution_map.md`
