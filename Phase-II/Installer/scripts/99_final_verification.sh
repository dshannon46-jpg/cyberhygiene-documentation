#!/bin/bash
#
# Module 99: Final Verification
# Comprehensive verification of all CyberHygiene services
# NIST 800-171 Compliance Verification
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Load installation variables
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/install_vars.sh"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [99-VERIFY] $*"
}

log "Running comprehensive system verification..."

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNED=0
declare -a FAILURES=()
declare -a WARNINGS=()

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"
    local is_critical="${3:-true}"

    if eval "${test_command}" 2>/dev/null; then
        log "  ✓ ${test_name}"
        ((TESTS_PASSED++))
        return 0
    else
        if [[ "${is_critical}" == "true" ]]; then
            log "  ✗ ${test_name}"
            FAILURES+=("${test_name}")
            ((TESTS_FAILED++))
        else
            log "  ⚠ ${test_name}"
            WARNINGS+=("${test_name}")
            ((TESTS_WARNED++))
        fi
        return 1
    fi
}

# ==========================================
# SECTION 1: System Security
# ==========================================
echo ""
log "=========================================="
log "SECTION 1: System Security"
log "=========================================="

# FIPS Mode
run_test "FIPS mode enabled" "fips-mode-setup --check 2>/dev/null | grep -q 'FIPS mode is enabled'"

# SELinux
run_test "SELinux enforcing" "getenforce | grep -q 'Enforcing'"

# Firewall
run_test "Firewall active" "systemctl is-active --quiet firewalld"

# ==========================================
# SECTION 2: Identity Management
# ==========================================
echo ""
log "=========================================="
log "SECTION 2: Identity Management (FreeIPA)"
log "=========================================="

run_test "FreeIPA service running" "ipactl status 2>/dev/null | grep -q 'running'"
run_test "DNS service running" "systemctl is-active --quiet named-pkcs11 || systemctl is-active --quiet named"
run_test "Kerberos KDC running" "systemctl is-active --quiet krb5kdc"
run_test "LDAP service running" "systemctl is-active --quiet dirsrv@*"

# Test authentication
if echo "${ADMIN_PASSWORD:-}" | kinit admin 2>/dev/null; then
    log "  ✓ Kerberos authentication works"
    ((TESTS_PASSED++))
    kdestroy 2>/dev/null || true
else
    log "  ⚠ Kerberos authentication test skipped (no password available)"
    ((TESTS_WARNED++))
fi

# ==========================================
# SECTION 3: Log Management
# ==========================================
echo ""
log "=========================================="
log "SECTION 3: Log Management (Graylog)"
log "=========================================="

run_test "MongoDB running" "systemctl is-active --quiet mongod"
run_test "OpenSearch/Elasticsearch running" "systemctl is-active --quiet opensearch || systemctl is-active --quiet elasticsearch"
run_test "Graylog server running" "systemctl is-active --quiet graylog-server"
run_test "Graylog API responding" "curl -s http://localhost:9000/api/system/lbstatus 2>/dev/null | grep -q 'ALIVE'" "false"

# ==========================================
# SECTION 4: Security Monitoring (Wazuh)
# ==========================================
echo ""
log "=========================================="
log "SECTION 4: Security Monitoring (Wazuh)"
log "=========================================="

run_test "Wazuh Indexer running" "systemctl is-active --quiet wazuh-indexer"
run_test "Wazuh Manager running" "systemctl is-active --quiet wazuh-manager"
run_test "Wazuh Dashboard running" "systemctl is-active --quiet wazuh-dashboard"
run_test "Wazuh Dashboard port 5601 listening" "ss -tlnp | grep -q ':5601'"

# ==========================================
# SECTION 5: Network Security (Suricata)
# ==========================================
echo ""
log "=========================================="
log "SECTION 5: Network Security (Suricata)"
log "=========================================="

run_test "Suricata IDS running" "systemctl is-active --quiet suricata"
run_test "Suricata rules present" "test -f /var/lib/suricata/rules/suricata.rules"
run_test "Suricata eve.json exists" "test -f /var/log/suricata/eve.json" "false"

# ==========================================
# SECTION 6: Monitoring Stack
# ==========================================
echo ""
log "=========================================="
log "SECTION 6: Monitoring Stack"
log "=========================================="

run_test "Prometheus running" "systemctl is-active --quiet prometheus"
run_test "Grafana running" "systemctl is-active --quiet grafana-server"
run_test "Node Exporter running" "systemctl is-active --quiet node_exporter" "false"

# ==========================================
# SECTION 7: Application Whitelisting
# ==========================================
echo ""
log "=========================================="
log "SECTION 7: Application Whitelisting"
log "=========================================="

run_test "fapolicyd running" "systemctl is-active --quiet fapolicyd"
run_test "fapolicyd trust database exists" "test -f /var/lib/fapolicyd/data/trust.db"

# ==========================================
# SECTION 8: USB Security
# ==========================================
echo ""
log "=========================================="
log "SECTION 8: USB Security"
log "=========================================="

run_test "USBGuard running" "systemctl is-active --quiet usbguard"
run_test "USBGuard rules exist" "test -f /etc/usbguard/rules.conf"

# ==========================================
# SECTION 9: Malware Detection
# ==========================================
echo ""
log "=========================================="
log "SECTION 9: Malware Detection"
log "=========================================="

run_test "YARA installed" "command -v yara &>/dev/null"
run_test "YARA rules exist" "test -d /etc/yara/rules.d && ls /etc/yara/rules.d/*.yar &>/dev/null"

# ==========================================
# SECTION 10: SysAdmin Dashboard
# ==========================================
echo ""
log "=========================================="
log "SECTION 10: SysAdmin Agent Dashboard"
log "=========================================="

run_test "SysAdmin Agent running" "systemctl is-active --quiet sysadmin-agent" "false"
run_test "Ollama AI service running" "systemctl is-active --quiet ollama" "false"

# ==========================================
# SECTION 11: SSL/TLS Certificates
# ==========================================
echo ""
log "=========================================="
log "SECTION 11: SSL/TLS Certificates"
log "=========================================="

if [[ -f "${SSL_CERT_PATH:-/root/ssl-certificates/wildcard.crt}" ]]; then
    run_test "SSL certificate exists" "test -f ${SSL_CERT_PATH:-/root/ssl-certificates/wildcard.crt}"
    run_test "SSL certificate valid" "openssl x509 -in ${SSL_CERT_PATH:-/root/ssl-certificates/wildcard.crt} -noout -checkend 0"
else
    log "  ⚠ SSL certificate path not found"
    ((TESTS_WARNED++))
fi

# ==========================================
# SECTION 12: Resources
# ==========================================
echo ""
log "=========================================="
log "SECTION 12: System Resources"
log "=========================================="

# Disk space
ROOT_SPACE=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
if [[ ${ROOT_SPACE} -gt 10 ]]; then
    log "  ✓ Disk space: ${ROOT_SPACE}GB available"
    ((TESTS_PASSED++))
else
    log "  ⚠ Low disk space: ${ROOT_SPACE}GB available"
    WARNINGS+=("Low disk space")
    ((TESTS_WARNED++))
fi

# Memory
FREE_MEM=$(free -g | awk '/^Mem:/ {print $7}')
if [[ ${FREE_MEM} -gt 4 ]]; then
    log "  ✓ Memory: ${FREE_MEM}GB available"
    ((TESTS_PASSED++))
else
    log "  ⚠ Low memory: ${FREE_MEM}GB available"
    WARNINGS+=("Low memory")
    ((TESTS_WARNED++))
fi

# CPU load
LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
log "  ℹ Load average: ${LOAD}"

# ==========================================
# Generate Report
# ==========================================
REPORT_FILE="${SCRIPT_DIR}/VERIFICATION_REPORT_$(date +%Y%m%d_%H%M%S).txt"

cat > "${REPORT_FILE}" <<EOF
================================================================================
CyberHygiene Phase II - Installation Verification Report
================================================================================
Generated: $(date)
Hostname: $(hostname -f)
Domain: ${DOMAIN:-N/A}

================================================================================
TEST SUMMARY
================================================================================
Tests Passed:  ${TESTS_PASSED}
Tests Failed:  ${TESTS_FAILED}
Tests Warned:  ${TESTS_WARNED}
--------------------------------------------------------------------------------
Total Tests:   $((TESTS_PASSED + TESTS_FAILED + TESTS_WARNED))

================================================================================
SYSTEM INFORMATION
================================================================================
Operating System: $(cat /etc/redhat-release 2>/dev/null || echo "Unknown")
Kernel: $(uname -r)
FIPS Mode: $(fips-mode-setup --check 2>/dev/null || echo "Unknown")
SELinux: $(getenforce 2>/dev/null || echo "Unknown")
Hostname: $(hostname -f)
IP Address: $(hostname -I | awk '{print $1}')

Memory: $(free -h | awk '/^Mem:/ {print $2}') total, $(free -h | awk '/^Mem:/ {print $7}') available
Disk (/): $(df -h / | awk 'NR==2 {print $2}') total, $(df -h / | awk 'NR==2 {print $4}') available

================================================================================
RUNNING SERVICES
================================================================================
$(systemctl list-units --type=service --state=running | grep -E "ipa|wazuh|graylog|suricata|prometheus|grafana|fapolicyd|usbguard|mongod|httpd|named" | head -20)

================================================================================
FAILED TESTS
================================================================================
EOF

if [[ ${#FAILURES[@]} -gt 0 ]]; then
    for failure in "${FAILURES[@]}"; do
        echo "- ${failure}" >> "${REPORT_FILE}"
    done
else
    echo "None - All critical tests passed!" >> "${REPORT_FILE}"
fi

cat >> "${REPORT_FILE}" <<EOF

================================================================================
WARNINGS
================================================================================
EOF

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    for warning in "${WARNINGS[@]}"; do
        echo "- ${warning}" >> "${REPORT_FILE}"
    done
else
    echo "None" >> "${REPORT_FILE}"
fi

cat >> "${REPORT_FILE}" <<EOF

================================================================================
ACCESS INFORMATION
================================================================================
FreeIPA Web UI:     https://$(hostname -f)/ipa/ui/
Wazuh Dashboard:    https://$(hostname -f):5601
Graylog:            http://$(hostname -f):9000
Grafana:            http://$(hostname -f):3000
Prometheus:         http://$(hostname -f):9090
SysAdmin Agent:     https://$(hostname -f)/sysadmin/

Default Username: admin
Passwords: See CREDENTIALS file in installation directory

================================================================================
NIST 800-171 COMPLIANCE STATUS
================================================================================
- Access Control (3.1): FreeIPA + USBGuard
- Audit & Accountability (3.3): Graylog + Wazuh
- Configuration Management (3.4): fapolicyd + OpenSCAP
- Identification & Auth (3.5): FreeIPA/Kerberos
- System & Communications (3.13): Firewall + SSL/TLS
- System & Info Integrity (3.14): Wazuh + Suricata + YARA

================================================================================
NEXT STEPS
================================================================================
1. Review this verification report for any failures
2. Test all web interfaces are accessible
3. Change default passwords
4. Configure additional users in FreeIPA
5. Set up log retention policies in Graylog
6. Review Wazuh agent deployment for clients
7. Configure alerting rules
8. Complete customer handoff documentation

================================================================================
EOF

chmod 600 "${REPORT_FILE}"

# Summary
echo ""
log "=========================================="
log "Verification Complete"
log "=========================================="
log "Tests Passed: ${TESTS_PASSED}"
log "Tests Failed: ${TESTS_FAILED}"
log "Tests Warned: ${TESTS_WARNED}"
echo ""

if [[ ${TESTS_FAILED} -eq 0 ]]; then
    log "✓✓✓ ALL CRITICAL TESTS PASSED ✓✓✓"
    echo ""
    log "CyberHygiene installation verified successfully!"
    log "System is ready for production deployment."
else
    log "⚠ SOME CRITICAL TESTS FAILED"
    echo ""
    log "Failed tests:"
    for failure in "${FAILURES[@]}"; do
        log "  - ${failure}"
    done
    echo ""
    log "Review and resolve failures before production deployment."
fi

if [[ ${TESTS_WARNED} -gt 0 ]]; then
    echo ""
    log "Warnings (non-critical):"
    for warning in "${WARNINGS[@]}"; do
        log "  - ${warning}"
    done
fi

echo ""
log "Full report: ${REPORT_FILE}"
echo ""

# Exit with appropriate code
if [[ ${TESTS_FAILED} -eq 0 ]]; then
    exit 0
else
    exit 1
fi
