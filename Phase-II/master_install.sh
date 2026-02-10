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

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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
            echo "CyberHygiene Phase II Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run        Simulate installation without making changes"
            echo "  --skip-backups   Skip backup creation (not recommended)"
            echo "  --service=NAME   Install only specific service (e.g., freeipa, wazuh)"
            echo "  --help           Display this help message"
            echo ""
            echo "Examples:"
            echo "  $0                          # Full installation"
            echo "  $0 --dry-run                # Test run without changes"
            echo "  $0 --service=freeipa        # Install only FreeIPA"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
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

    # Color based on level
    local color="${NC}"
    case "${level}" in
        ERROR)   color="${RED}" ;;
        WARN)    color="${YELLOW}" ;;
        INFO)    color="${GREEN}" ;;
        DEBUG)   color="${BLUE}" ;;
    esac

    # Log to file and console
    echo "[${timestamp}] [${level}] ${message}" >> "${MAIN_LOG}"
    echo -e "${color}[${level}]${NC} ${message}"
}

# Error handler
error_exit() {
    log "ERROR" "$1"
    log "ERROR" "Installation failed at: $2"
    log "ERROR" "Check logs in: ${LOG_DIR}"
    log "ERROR" "Main log: ${MAIN_LOG}"
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
        error_exit "This script must be run as root (use sudo)" "verify_prerequisites"
    fi

    # Check if FIPS mode is enabled
    if ! fips-mode-setup --check 2>/dev/null | grep -q "FIPS mode is enabled"; then
        log "WARN" "FIPS mode is not enabled. This should be enabled before proceeding."
        log "WARN" "Run: fips-mode-setup --enable && reboot"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # Check if installation_info.md exists and is filled out
    if [[ ! -f "${SCRIPT_DIR}/installation_info.md" ]]; then
        error_exit "installation_info.md not found. Please complete the installation information form." "verify_prerequisites"
    fi

    # Check if scripts directory exists
    if [[ ! -d "${SCRIPTS_DIR}" ]]; then
        error_exit "Scripts directory not found: ${SCRIPTS_DIR}" "verify_prerequisites"
    fi

    # Check if Claude Code is available (optional but recommended)
    if command -v claude &> /dev/null; then
        log "INFO" "✓ Claude Code is available for AI-assisted configuration"
    else
        log "WARN" "Claude Code not found. AI assistance will not be available."
        log "WARN" "Some automation features may be limited."
    fi

    log "INFO" "✓ Prerequisites verified"
}

# Display installation summary
display_summary() {
    echo ""
    echo "=========================================="
    echo "CyberHygiene Phase II Installation"
    echo "=========================================="
    echo "Version: 1.0"
    echo "Timestamp: ${INSTALL_TIMESTAMP}"
    echo "Dry Run: ${DRY_RUN}"
    echo "Skip Backups: ${SKIP_BACKUPS}"
    if [[ -n "$SPECIFIC_SERVICE" ]]; then
        echo "Service Filter: ${SPECIFIC_SERVICE}"
    fi
    echo "Log Directory: ${LOG_DIR}"
    echo "Backup Directory: ${BACKUP_DIR}"
    echo "=========================================="
    echo ""

    if [[ "$DRY_RUN" == "false" ]]; then
        read -p "Press ENTER to begin installation (or Ctrl+C to abort)..."
    fi
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
    display_summary

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
        "61_install_fapolicyd.sh"
        "62_install_usbguard.sh"
        "63_install_yara.sh"
        "65_install_sysadmin_agent.sh"
        "70_configure_backup.sh"
        "80_deploy_policies.sh"
        "90_customize_documentation.sh"
        "99_final_verification.sh"
    )

    # If specific service requested, filter modules
    if [[ -n "$SPECIFIC_SERVICE" ]]; then
        log "INFO" "Installing only service: ${SPECIFIC_SERVICE}"
        modules=($(printf '%s\n' "${modules[@]}" | grep -i "${SPECIFIC_SERVICE}"))
        if [[ ${#modules[@]} -eq 0 ]]; then
            error_exit "No modules found matching service: ${SPECIFIC_SERVICE}" "main"
        fi
    fi

    # Execute each module
    local completed=0
    local total=${#modules[@]}

    for module in "${modules[@]}"; do
        local module_path="${SCRIPTS_DIR}/${module}"

        if [[ ! -f "${module_path}" ]]; then
            log "WARN" "Module not found: ${module} (skipping)"
            continue
        fi

        ((completed++))
        log "INFO" "Progress: ${completed}/${total} modules"

        run_module "${module_path}"

        # Pause between modules for review (unless dry run or non-interactive)
        if [[ "$DRY_RUN" == "false" ]] && [[ -t 0 ]] && [[ "$completed" -lt "$total" ]]; then
            echo ""
            read -p "Press ENTER to continue to next module (or Ctrl+C to abort)..."
            echo ""
        fi
    done

    log "INFO" "=========================================="
    log "INFO" "Installation Complete!"
    log "INFO" "=========================================="
    log "INFO" "Completed: ${completed}/${total} modules"
    log "INFO" "Installation logs: ${LOG_DIR}"
    log "INFO" "System backups: ${BACKUP_DIR}"
    log "INFO" "Main log file: ${MAIN_LOG}"
    log "INFO" "=========================================="
    echo ""
    log "INFO" "Next steps:"
    log "INFO" "1. Review installation logs for any warnings"
    log "INFO" "2. Test all services are accessible"
    log "INFO" "3. Review final verification report"
    log "INFO" "4. Complete customer handoff documentation"
    echo ""
}

# Trap errors
trap 'error_exit "Script interrupted" "line $LINENO"' ERR INT TERM

# Run main installation
main "$@"
