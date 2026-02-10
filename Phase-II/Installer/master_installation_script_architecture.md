# CyberHygiene Phase II Master Installation Script Architecture

**Version:** 1.0
**Date:** 2026-01-01
**Purpose:** Define the automated installation script framework for rapid deployment

---

## Overview

The Phase II installation system uses a modular, AI-assisted script architecture to automatically deploy the CyberHygiene security platform with customer-specific configurations.

**Design Principles:**
- Modular design (separate scripts per service)
- Idempotent execution (can be run multiple times safely)
- Comprehensive logging and error handling
- AI-assisted configuration generation (Claude Code integration)
- Human verification at critical decision points
- Automated rollback capability

---

## Directory Structure

```
/home/admin/Documents/Installer/
├── installation_info.md              # Customer-specific data (filled out)
├── installation_info_template.md      # Blank template
├── install_vars.sh                    # Generated variables file
├── master_install.sh                  # Main orchestration script
├── scripts/
│   ├── 00_prerequisites_check.sh      # Verify system ready
│   ├── 01_generate_variables.sh       # Parse installation_info.md
│   ├── 02_backup_system.sh            # Create restore point
│   ├── 10_install_freeipa.sh          # Domain Controller
│   ├── 11_configure_dns.sh            # DNS zones
│   ├── 12_deploy_ssl_certs.sh         # SSL certificate installation
│   ├── 20_install_samba.sh            # File sharing (DMS)
│   ├── 30_install_graylog.sh          # Log management
│   ├── 40_install_suricata.sh         # IDS/IPS (Proxy)
│   ├── 50_install_prometheus.sh       # Monitoring
│   ├── 51_install_grafana.sh          # Dashboards
│   ├── 60_install_wazuh.sh            # Security monitoring
│   ├── 70_configure_backup.sh         # Backup automation
│   ├── 80_deploy_policies.sh          # Security policies
│   ├── 90_customize_documentation.sh  # Update docs for customer
│   └── 99_final_verification.sh       # System validation
├── templates/
│   ├── freeipa.conf.template          # Service config templates
│   ├── prometheus.yml.template
│   ├── grafana.ini.template
│   └── ...
├── logs/
│   ├── installation.log               # Main log file
│   ├── [timestamp]_00_prerequisites.log
│   ├── [timestamp]_10_freeipa.log
│   └── ...
└── backups/
    └── [timestamp]_pre_install/       # System state backups
```

---

## Master Installation Script

### `master_install.sh`

```bash
#!/bin/bash
#
# CyberHygiene Phase II Master Installation Script
# Version: 1.0
# Purpose: Orchestrate automated deployment of CyberHygiene platform
#
# Usage: sudo ./master_install.sh [--dry-run] [--skip-backups] [--service=SERVICE]
#

set -euo pipefail  # Exit on error, undefined variables, pipe failures

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
BACKUP_DIR="${SCRIPT_DIR}/backups"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

# Timestamp for this installation run
INSTALL_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
MAIN_LOG="${LOG_DIR}/installation_${INSTALL_TIMESTAMP}.log"

# Command line options
DRY_RUN=false
SKIP_BACKUPS=false
SPECIFIC_SERVICE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --skip-backups)
            SKIP_BACKUPS=true
            shift
            ;;
        --service=*)
            SPECIFIC_SERVICE="${1#*=}"
            shift
            ;;
        --help)
            echo "Usage: $0 [--dry-run] [--skip-backups] [--service=SERVICE]"
            echo "  --dry-run        : Simulate installation without making changes"
            echo "  --skip-backups   : Skip backup creation (not recommended)"
            echo "  --service=NAME   : Install only specific service (e.g., freeipa, wazuh)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Create directories
mkdir -p "${LOG_DIR}" "${BACKUP_DIR}"

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}" | tee -a "${MAIN_LOG}"
}

# Error handler
error_exit() {
    log "ERROR" "$1"
    log "ERROR" "Installation failed at: $2"
    log "ERROR" "Check logs in: ${LOG_DIR}"
    exit 1
}

# Run a script module
run_module() {
    local module_script="$1"
    local module_name=$(basename "${module_script}" .sh)
    local module_log="${LOG_DIR}/${INSTALL_TIMESTAMP}_${module_name}.log"

    log "INFO" "======================================"
    log "INFO" "Starting module: ${module_name}"
    log "INFO" "======================================"

    if [[ "$DRY_RUN" == "true" ]]; then
        log "INFO" "[DRY RUN] Would execute: ${module_script}"
        return 0
    fi

    # Execute module script and log output
    if bash "${module_script}" 2>&1 | tee "${module_log}"; then
        log "INFO" "✓ Module ${module_name} completed successfully"
        return 0
    else
        error_exit "Module ${module_name} failed" "${module_script}"
    fi
}

# Verify prerequisites
verify_prerequisites() {
    log "INFO" "Verifying prerequisites..."

    # Check if running as root
    if [[ $EUID -ne 0 ]]; then
        error_exit "This script must be run as root" "verify_prerequisites"
    fi

    # Check if FIPS mode is enabled
    if ! fips-mode-setup --check | grep -q "FIPS mode is enabled"; then
        error_exit "FIPS mode must be enabled before installation" "verify_prerequisites"
    fi

    # Check if installation_info.md exists and is filled out
    if [[ ! -f "${SCRIPT_DIR}/installation_info.md" ]]; then
        error_exit "installation_info.md not found. Please complete the installation information form." "verify_prerequisites"
    fi

    # Check if Claude Code is available (optional but recommended)
    if command -v claude &> /dev/null; then
        log "INFO" "✓ Claude Code is available for AI-assisted configuration"
    else
        log "WARN" "Claude Code not found. AI assistance will not be available."
    fi

    log "INFO" "✓ Prerequisites verified"
}

# Main installation sequence
main() {
    log "INFO" "=========================================="
    log "INFO" "CyberHygiene Phase II Installation"
    log "INFO" "Version: 1.0"
    log "INFO" "Timestamp: ${INSTALL_TIMESTAMP}"
    log "INFO" "Dry Run: ${DRY_RUN}"
    log "INFO" "=========================================="

    verify_prerequisites

    # Installation modules in dependency order
    local modules=(
        "00_prerequisites_check.sh"
        "01_generate_variables.sh"
        "02_backup_system.sh"
        "10_install_freeipa.sh"
        "11_configure_dns.sh"
        "12_deploy_ssl_certs.sh"
        "20_install_samba.sh"
        "30_install_graylog.sh"
        "40_install_suricata.sh"
        "50_install_prometheus.sh"
        "51_install_grafana.sh"
        "60_install_wazuh.sh"
        "70_configure_backup.sh"
        "80_deploy_policies.sh"
        "90_customize_documentation.sh"
        "99_final_verification.sh"
    )

    # If specific service requested, filter modules
    if [[ -n "$SPECIFIC_SERVICE" ]]; then
        log "INFO" "Installing only service: ${SPECIFIC_SERVICE}"
        modules=($(printf '%s\n' "${modules[@]}" | grep -i "${SPECIFIC_SERVICE}"))
    fi

    # Execute each module
    for module in "${modules[@]}"; do
        local module_path="${SCRIPTS_DIR}/${module}"

        if [[ ! -f "${module_path}" ]]; then
            log "WARN" "Module not found: ${module} (skipping)"
            continue
        fi

        run_module "${module_path}"

        # Pause between modules for review (unless dry run)
        if [[ "$DRY_RUN" == "false" ]] && [[ -t 0 ]]; then
            read -p "Press ENTER to continue to next module (or Ctrl+C to abort)..."
        fi
    done

    log "INFO" "=========================================="
    log "INFO" "Installation Complete!"
    log "INFO" "=========================================="
    log "INFO" "Installation logs: ${LOG_DIR}"
    log "INFO" "System backups: ${BACKUP_DIR}"
    log "INFO" "Review logs for any warnings or errors"
}

# Run main installation
main "$@"
```

---

## Module Scripts

### Example Module: `01_generate_variables.sh`

```bash
#!/bin/bash
#
# Generate installation variables from installation_info.md
# Uses Claude Code AI to parse and validate customer information
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_FILE="${SCRIPT_DIR}/installation_info.md"
OUTPUT_FILE="${SCRIPT_DIR}/install_vars.sh"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Check if Claude Code is available
if command -v claude &> /dev/null; then
    log "Using Claude Code AI to parse installation information..."

    # Use Claude Code to extract values from installation_info.md
    claude --prompt "Parse the installation_info.md file and extract all filled-in values. Generate a bash variables file (install_vars.sh) with all the configuration values needed for CyberHygiene installation. Include validation of required fields." \
        --file "${SOURCE_FILE}" \
        --output "${OUTPUT_FILE}"

else
    log "Claude Code not available. Using manual parsing..."

    # Manual parsing logic (fallback)
    # Extract domain name
    DOMAIN=$(grep "Fully Qualified Domain Name" "${SOURCE_FILE}" | sed 's/.*: \(.*\)/\1/' | tr -d '_')

    # Extract realm (uppercase domain)
    REALM=$(echo "${DOMAIN}" | tr '[:lower:]' '[:upper:]')

    # Extract business name
    BUSINESS_NAME=$(grep "Business Name (Legal)" "${SOURCE_FILE}" | sed 's/.*: \(.*\)/\1/' | tr -d '_')

    # ... continue for all fields ...

    # Generate variables file
    cat > "${OUTPUT_FILE}" <<EOF
#!/bin/bash
# Auto-generated installation variables
# Source: ${SOURCE_FILE}
# Generated: $(date)

export DOMAIN="${DOMAIN}"
export REALM="${REALM}"
export BUSINESS_NAME="${BUSINESS_NAME}"
# ... more variables ...
EOF
fi

# Validate generated file
if [[ ! -f "${OUTPUT_FILE}" ]]; then
    log "ERROR: Failed to generate ${OUTPUT_FILE}"
    exit 1
fi

# Source and validate required variables
source "${OUTPUT_FILE}"

required_vars=("DOMAIN" "REALM" "BUSINESS_NAME" "SUBNET")
for var in "${required_vars[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        log "ERROR: Required variable ${var} is not set in ${OUTPUT_FILE}"
        exit 1
    fi
done

log "✓ Installation variables generated and validated"
log "Variables file: ${OUTPUT_FILE}"
```

---

### Example Module: `10_install_freeipa.sh`

```bash
#!/bin/bash
#
# Install and configure FreeIPA Domain Controller
# Integrates with customer-specific domain name and configuration
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${SCRIPT_DIR}/install_vars.sh"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [FreeIPA] $*"
}

# Check if FreeIPA is already installed
if ipa --version &> /dev/null; then
    log "FreeIPA already installed. Skipping installation."
    exit 0
fi

log "Installing FreeIPA packages..."
dnf module enable -y idm:DL1/{dns,client,server,common}
dnf install -y ipa-server ipa-server-dns

log "Configuring FreeIPA domain: ${DOMAIN}"
log "Kerberos realm: ${REALM}"

# Generate secure passwords (or use pre-generated from install_vars.sh)
if [[ -z "${DS_PASSWORD:-}" ]]; then
    DS_PASSWORD=$(openssl rand -base64 32)
    log "Generated Directory Server password"
fi

if [[ -z "${ADMIN_PASSWORD:-}" ]]; then
    ADMIN_PASSWORD=$(openssl rand -base64 24)
    log "Generated Admin password"
fi

# Store passwords securely
cat > /root/freeipa_passwords.txt <<EOF
# FreeIPA Passwords - $(date)
# Store this file securely!

Directory Server Password: ${DS_PASSWORD}
Admin Password: ${ADMIN_PASSWORD}
EOF
chmod 600 /root/freeipa_passwords.txt

log "Starting FreeIPA installation (this may take 10-15 minutes)..."

ipa-server-install \
    --domain="${DOMAIN}" \
    --realm="${REALM}" \
    --hostname="dc1.${DOMAIN}" \
    --ds-password="${DS_PASSWORD}" \
    --admin-password="${ADMIN_PASSWORD}" \
    --mkhomedir \
    --setup-dns \
    --auto-forwarders \
    --auto-reverse \
    --no-ntp \
    --unattended

if [[ $? -eq 0 ]]; then
    log "✓ FreeIPA installation completed successfully"
    log "Admin password stored in: /root/freeipa_passwords.txt"
    log "You can now log in with: kinit admin"
else
    log "ERROR: FreeIPA installation failed"
    exit 1
fi

# Verify installation
log "Verifying FreeIPA installation..."
if kinit admin <<< "${ADMIN_PASSWORD}" 2>/dev/null; then
    log "✓ FreeIPA authentication verified"
    kdestroy
else
    log "ERROR: FreeIPA authentication failed"
    exit 1
fi

log "FreeIPA installation complete"
```

---

## AI-Assisted Configuration

### Claude Code Integration

The installation scripts can leverage Claude Code for:

1. **Parsing Installation Forms:**
   - Extract values from `installation_info.md`
   - Validate required fields
   - Generate variables file

2. **Configuration File Generation:**
   - Read template files
   - Substitute customer-specific values
   - Validate syntax before deployment

3. **Documentation Customization:**
   - Update User Manual with customer domain
   - Customize policy documents
   - Generate customer-specific guides

4. **Troubleshooting:**
   - Analyze error logs
   - Suggest remediation steps
   - Generate configuration fixes

### Example Claude Code Usage

```bash
# Use AI to generate Prometheus configuration
claude --prompt "Generate a Prometheus configuration for CyberHygiene \
    deployment with domain ${DOMAIN}. Include scrape targets for all 6 \
    servers (dc1, dms, graylog, proxy, monitoring, wazuh) using the \
    subnet ${SUBNET}.0/24. Use TLS with client certificates for authentication." \
    --template templates/prometheus.yml.template \
    --output /etc/prometheus/prometheus.yml

# Use AI to validate configuration
claude --prompt "Validate this Prometheus configuration file. Check for \
    syntax errors, verify all targets are reachable, and ensure TLS is \
    properly configured." \
    --file /etc/prometheus/prometheus.yml
```

---

## Installation Phases

### Phase 0: Pre-Installation (Manual)
- Hardware setup and BIOS configuration
- Rocky Linux FIPS-enabled installation
- OpenSCAP remediation
- Network configuration
- Installation media preparation

### Phase 1: Prerequisites and Validation (Automated)
- Verify FIPS mode enabled
- Check disk space and resources
- Validate installation_info.md
- Generate variables file
- Create system backups

### Phase 2: Core Infrastructure (Automated)
- Install FreeIPA (Domain Controller)
- Configure DNS zones
- Deploy SSL certificates
- Create initial user accounts

### Phase 3: Service Deployment (Automated)
- Install file sharing (Samba/NFS)
- Install log management (Graylog)
- Install web proxy and IDS (Suricata)
- Install monitoring (Prometheus/Grafana)
- Install security platform (Wazuh)

### Phase 4: Configuration and Hardening (Automated)
- Configure backups
- Deploy security policies
- Configure compliance monitoring
- Setup alerting and notifications

### Phase 5: Documentation and Validation (Automated)
- Customize documentation for customer
- Generate compliance reports
- Run final verification tests
- Create customer handoff package

---

## Error Handling and Rollback

### Automatic Rollback Strategy

Each module creates a backup before making changes:

```bash
# Before making changes
backup_state() {
    local module_name="$1"
    local backup_dir="${BACKUP_DIR}/${INSTALL_TIMESTAMP}_${module_name}"

    mkdir -p "${backup_dir}"

    # Backup relevant files
    cp -r /etc/freeipa "${backup_dir}/" 2>/dev/null || true
    cp -r /etc/httpd "${backup_dir}/" 2>/dev/null || true

    # Create package list
    rpm -qa > "${backup_dir}/packages.txt"

    log "Backup created: ${backup_dir}"
}

# Restore from backup
restore_state() {
    local module_name="$1"
    local backup_dir="${BACKUP_DIR}/${INSTALL_TIMESTAMP}_${module_name}"

    if [[ ! -d "${backup_dir}" ]]; then
        log "ERROR: Backup not found: ${backup_dir}"
        return 1
    fi

    log "Restoring from backup: ${backup_dir}"
    # Restoration logic...
}
```

---

## Logging and Reporting

### Log Levels

- **INFO:** Normal operation progress
- **WARN:** Non-critical issues, system continues
- **ERROR:** Critical failures, module stops
- **DEBUG:** Detailed information for troubleshooting

### Log Files

- `installation_{timestamp}.log` - Main log
- `{timestamp}_{module}.log` - Per-module logs
- `/var/log/cyberhygiene_install.log` - System-wide log

### Progress Reporting

Generate HTML progress report:

```bash
generate_progress_report() {
    cat > "${SCRIPT_DIR}/installation_progress.html" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>CyberHygiene Installation Progress</title>
</head>
<body>
    <h1>Installation Progress: ${BUSINESS_NAME}</h1>
    <p>Started: ${INSTALL_TIMESTAMP}</p>
    <ul>
        $(for module in "${completed_modules[@]}"; do
            echo "<li>✓ ${module}</li>"
        done)
    </ul>
</body>
</html>
EOF
}
```

---

## Success Criteria

Installation is considered successful when:

- [ ] All module scripts complete without errors
- [ ] All services are running and accessible
- [ ] DNS resolution works for all hostnames
- [ ] SSL certificates are valid and deployed
- [ ] Users can authenticate via FreeIPA
- [ ] Monitoring dashboards are accessible
- [ ] Security scans show 100% compliance (or documented POA&M items)
- [ ] Backup system is functional
- [ ] Documentation is customized for customer

---

## Next Steps

1. **Create individual module scripts** for each service
2. **Develop configuration templates** for each service
3. **Integrate Claude Code** for AI-assisted configuration
4. **Test installation** on development hardware
5. **Create rollback procedures** for each module
6. **Document known issues** and troubleshooting steps

---

**Document Version:** 1.0
**Last Updated:** 2026-01-01
**File Location:** `/home/admin/Documents/Installer/master_installation_script_architecture.md`
