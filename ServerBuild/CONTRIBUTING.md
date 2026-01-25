# Contributing to CyberHygiene Phase II

Thank you for your interest in contributing to CyberHygiene Phase II! This document provides guidelines for contributing to the project.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Security Guidelines](#security-guidelines)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or insulting comments
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

---

## Getting Started

### Prerequisites

Before contributing, you should have:

- Experience with **Rocky Linux 9** or RHEL-based systems
- Understanding of **bash scripting**
- Familiarity with **NIST SP 800-171** compliance (helpful)
- Knowledge of one or more technologies:
  - FreeIPA, Kerberos, LDAP
  - Wazuh SIEM
  - Suricata IDS/IPS
  - Samba file sharing
  - Prometheus/Grafana monitoring
  - Graylog log management

### Areas for Contribution

We welcome contributions in:

1. **Installation Scripts** - Improvements to automation
2. **Documentation** - Clarifications, examples, tutorials
3. **Testing** - Bug reports, test cases, validation scripts
4. **Hardware Support** - Compatibility with additional platforms
5. **Security Enhancements** - NIST control improvements
6. **Troubleshooting** - Common issues and solutions

---

## Development Environment

### Setting Up Test Environment

**Recommended: Virtual Machine**

```bash
# Minimum VM specs
CPU: 4 cores
RAM: 16 GB (8 GB minimum for testing)
Disk: 100 GB
OS: Rocky Linux 9.5 FIPS-enabled

# Install development tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y git vim shellcheck
```

**Hardware Testing: HP Proliant DL20 Gen10 Plus**

For production validation, test on actual hardware when possible.

### Fork and Clone Repository

```bash
# Fork on GitHub first, then:
git clone https://github.com/YOUR-USERNAME/Cyberinabox-phaseII.git
cd Cyberinabox-phaseII

# Add upstream remote
git remote add upstream https://github.com/dshannon46-jpg/Cyberinabox-phaseII.git

# Verify remotes
git remote -v
```

---

## How to Contribute

### Reporting Bugs

**Before submitting:**
1. Check existing issues for duplicates
2. Test on clean Rocky Linux 9 installation
3. Collect relevant logs and error messages

**Bug report should include:**
- Rocky Linux version (`cat /etc/redhat-release`)
- Hardware specifications
- FIPS mode status (`fips-mode-setup --check`)
- Exact error message
- Steps to reproduce
- Expected vs actual behavior
- Relevant log excerpts (redact sensitive data!)

**Submit issue with template:**

```markdown
**Environment**
- OS: Rocky Linux 9.5
- Hardware: HP Proliant DL20 Gen10 Plus
- FIPS: Enabled
- Installation Module: 10_install_freeipa.sh

**Description**
Clear description of the bug

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Logs**
```
Relevant log excerpts (redacted)
```

**Additional Context**
Any other relevant information
```

### Suggesting Enhancements

**Enhancement proposals should include:**
- Use case and business justification
- Affected NIST controls (if applicable)
- Implementation approach (high-level)
- Backward compatibility considerations
- Testing strategy

**Example enhancement issue:**

```markdown
**Title:** Add support for external certificate authorities

**Use Case**
Some organizations already have PKI infrastructure and want to use
existing certificates instead of FreeIPA CA.

**Affected Components**
- `12_deploy_ssl_certs.sh` - SSL deployment
- `installation_info.md` - Add CA configuration section

**Implementation Approach**
1. Add optional `USE_EXTERNAL_CA` flag in installation form
2. Modify SSL deployment to import provided certificates
3. Update FreeIPA configuration to trust external CA

**NIST Impact**
- SC-17 (Public Key Infrastructure Certificates)
- IA-5 (Authenticator Management)

**Testing Strategy**
- Test with Let's Encrypt certificates
- Test with commercial CA (DigiCert, etc.)
- Validate certificate chain trust
```

---

## Coding Standards

### Bash Script Guidelines

**1. Use Strict Error Handling**

```bash
#!/bin/bash
set -euo pipefail  # Always include this

# Explanation:
# -e: Exit on error
# -u: Exit on undefined variable
# -o pipefail: Exit on pipe failure
```

**2. Logging Convention**

```bash
# Use consistent logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [MODULE-NAME] $*"
}

log "Starting installation..."
log "✓ Step completed successfully"
log "✗ Step failed"
```

**3. Variable Naming**

```bash
# Constants: UPPERCASE
DOMAIN="example.com"
REALM="EXAMPLE.COM"

# Local variables: lowercase
local temp_file="/tmp/installer.$$"
local service_name="wazuh-manager"

# Sourced variables: UPPERCASE (from install_vars.sh)
source "${SCRIPT_DIR}/install_vars.sh"
echo "${BUSINESS_NAME}"
```

**4. Error Handling**

```bash
# Check command success
if systemctl start wazuh-manager; then
    log "✓ Wazuh Manager started"
else
    log "✗ Failed to start Wazuh Manager"
    exit 1
fi

# Verify file exists before using
if [[ ! -f "${CONFIG_FILE}" ]]; then
    log "✗ Configuration file not found: ${CONFIG_FILE}"
    exit 1
fi
```

**5. Quoting Variables**

```bash
# Always quote variables to handle spaces
file_path="/path/with spaces/file.txt"
cat "${file_path}"  # Good
cat ${file_path}    # Bad - will fail

# Exception: Arrays
modules=("module1" "module2" "module3")
for module in "${modules[@]}"; do  # Correct
    echo "${module}"
done
```

**6. Use ShellCheck**

```bash
# Install ShellCheck
sudo dnf install -y shellcheck

# Check your script
shellcheck scripts/10_install_freeipa.sh

# Fix all warnings and errors before submitting
```

**7. Comments and Documentation**

```bash
#!/bin/bash
#
# Module 10: Install FreeIPA
# Installs and configures FreeIPA domain controller with DNS, Kerberos, CA
#
# Prerequisites:
#   - Rocky Linux 9 FIPS-enabled
#   - Valid hostname (FQDN)
#   - install_vars.sh sourced
#
# NIST Controls: IA-2, IA-5, AC-2, SC-13
#

# Brief explanation of complex sections
# This loop creates DNS records for all infrastructure servers
for server_entry in "${SERVERS[@]}"; do
    # Parse server name and IP from colon-delimited string
    server_name=$(echo "${server_entry}" | cut -d':' -f1)
    server_ip=$(echo "${server_entry}" | cut -d':' -f2)

    # Add A record to FreeIPA DNS
    ipa dnsrecord-add "${DOMAIN}." "${server_name}" --a-ip-address="${server_ip}"
done
```

### Documentation Standards

**Markdown Formatting**

```markdown
# Main Title (H1 - only one per document)

## Section (H2)

### Subsection (H3)

**Bold** for emphasis
*Italic* for variable names or file paths
`code` for commands, file names, or technical terms

# Code blocks with language
```bash
command here
```

# Lists
- Unordered item
- Another item

1. Ordered item
2. Next item
```

**README Updates**

When adding features:
1. Update main README.md
2. Update installation_info_template.md (if new config needed)
3. Update configuration_substitution_map.md (if new variables)
4. Add troubleshooting section for common issues

---

## Testing Requirements

### Pre-Submission Testing

**1. ShellCheck Validation**

```bash
# All scripts must pass ShellCheck
find scripts/ -name "*.sh" -exec shellcheck {} \;
```

**2. Syntax Check**

```bash
# Verify bash syntax
bash -n scripts/your_module.sh
```

**3. Dry Run Testing**

```bash
# Test script logic without making changes
DRY_RUN=true ./scripts/your_module.sh
```

**4. Full Installation Test**

**Minimum Test Environment:**
- Fresh Rocky Linux 9.5 FIPS-enabled installation
- 8 GB RAM minimum
- 50 GB disk space
- Meets all prerequisites from `00_prerequisites_check.sh`

**Test Procedure:**
```bash
# 1. Clean install of Rocky Linux 9 with FIPS
# 2. Clone your branch
git clone -b your-feature-branch https://github.com/YOUR-USERNAME/Cyberinabox-phaseII.git
cd Cyberinabox-phaseII

# 3. Fill out installation form
cp installation_info_template.md installation_info.md
nano installation_info.md  # Fill in test data

# 4. Run installer
./master_install.sh

# 5. Verify all services start
sudo ipactl status
sudo systemctl status wazuh-manager
sudo systemctl status smb
# ... etc

# 6. Run verification
./scripts/99_final_verification.sh

# 7. Check for errors in logs
grep -i error logs/*.log
```

**5. Regression Testing**

Ensure your changes don't break existing functionality:
- Test all 17 installation modules
- Verify all web interfaces accessible
- Test user authentication
- Verify DNS resolution
- Test file sharing
- Check compliance dashboard

### Test Documentation

Include test results in PR:

```markdown
## Testing Performed

**Environment:**
- OS: Rocky Linux 9.5
- FIPS: Enabled
- Hardware: VMware VM (8 GB RAM, 100 GB disk)

**Tests Executed:**
- [x] ShellCheck passed
- [x] Syntax check passed
- [x] Full installation completed successfully
- [x] All services started
- [x] Final verification: 12/12 tests passed
- [x] No errors in logs

**Services Verified:**
- [x] FreeIPA: https://dc1.test.local
- [x] Wazuh: https://192.168.1.10
- [x] Grafana: http://192.168.1.10:3000
- [x] Samba: \\dc1.test.local\shared

**Regression Testing:**
- [x] Existing FreeIPA functionality unchanged
- [x] DNS resolution working
- [x] User authentication successful

**Logs:**
No errors found in installation logs.
```

---

## Security Guidelines

### Critical Security Rules

**1. NEVER Commit Sensitive Data**

```bash
# Before committing, always verify
git status | grep -E "(installation_info\.md|CREDENTIALS|\.key|\.pem|install_vars)"

# If any matches found, DO NOT COMMIT
```

**2. Password Generation**

```bash
# Always use cryptographically secure random generation
password=$(openssl rand -base64 32 | tr -d '/+=' | cut -c1-32)

# Never use weak methods like:
# password="Password123"  # Bad - hardcoded
# password=$(date +%s)     # Bad - predictable
```

**3. Input Validation**

```bash
# Validate user input before using
validate_domain() {
    local domain="$1"

    # Check format
    if [[ ! "${domain}" =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]]; then
        log "✗ Invalid domain format: ${domain}"
        return 1
    fi

    return 0
}

# Use validation
if ! validate_domain "${DOMAIN}"; then
    exit 1
fi
```

**4. Secure File Permissions**

```bash
# Credentials and keys: 600 (owner read/write only)
chmod 600 /path/to/credentials.txt

# Scripts: 700 (owner execute only)
chmod 700 /usr/local/bin/backup-script.sh

# Configuration files: 644 (owner write, all read)
chmod 644 /etc/app/config.conf
```

**5. No Secrets in Code**

```bash
# Bad - hardcoded secret
API_KEY="abc123def456"

# Good - read from protected file
if [[ -f "/etc/secrets/api_key" ]]; then
    API_KEY=$(cat /etc/secrets/api_key)
    chmod 600 /etc/secrets/api_key
else
    log "✗ API key file not found"
    exit 1
fi
```

### NIST 800-171 Compliance

When modifying security controls:

1. **Document NIST Control ID**
   ```bash
   # NIST 800-171 AC-6: Least Privilege
   # Configure minimum necessary permissions
   ```

2. **Maintain Audit Trail**
   ```bash
   # Log all security-relevant events
   log "User ${username} granted admin privileges" | \
       tee -a /var/log/security-audit.log
   ```

3. **Preserve Encryption**
   ```bash
   # Always use FIPS-approved algorithms
   openssl enc -aes-256-cbc -salt -pbkdf2 ...
   ```

---

## Pull Request Process

### Before Submitting PR

**Checklist:**
- [ ] Code follows style guidelines (ShellCheck clean)
- [ ] Comments added to complex sections
- [ ] Documentation updated (README, troubleshooting, etc.)
- [ ] Tested on clean Rocky Linux 9 installation
- [ ] No sensitive data in commits
- [ ] All 17 modules still work (regression test)
- [ ] Verification script passes (99_final_verification.sh)
- [ ] Commit messages are descriptive

### Creating Pull Request

**1. Create Feature Branch**

```bash
# Update your fork
git checkout main
git pull upstream main
git push origin main

# Create feature branch
git checkout -b feature/add-external-ca-support

# Make your changes
# ... edit files ...

# Commit with descriptive message
git add .
git commit -m "Add support for external certificate authorities

- Modified 12_deploy_ssl_certs.sh to support external CAs
- Added USE_EXTERNAL_CA flag to installation form
- Updated documentation with external CA procedure
- Tested with Let's Encrypt and DigiCert certificates

NIST Controls: SC-17, IA-5"

# Push to your fork
git push origin feature/add-external-ca-support
```

**2. Submit PR on GitHub**

**PR Title Format:**
```
[Feature|Bugfix|Docs|Security]: Brief description
```

**Examples:**
- `Feature: Add support for external certificate authorities`
- `Bugfix: Fix Wazuh indexer startup race condition`
- `Docs: Add troubleshooting section for DNS issues`
- `Security: Improve password generation entropy`

**PR Description Template:**

```markdown
## Summary
Brief description of what this PR does

## Motivation
Why is this change needed? What problem does it solve?

## Changes
- List of specific changes made
- Modified files and why
- New features or functionality

## Testing
- Test environment details
- Test procedures followed
- Test results (pass/fail)

## NIST Impact
- List affected NIST 800-171 controls
- Compliance maintained? Yes/No

## Documentation
- [ ] README.md updated
- [ ] Troubleshooting guide updated
- [ ] Comments added to code
- [ ] Configuration map updated (if new variables)

## Checklist
- [ ] ShellCheck passed
- [ ] Full installation tested
- [ ] No sensitive data committed
- [ ] Backward compatible
- [ ] Regression tests passed

## Screenshots (if applicable)
Before and after screenshots for UI changes

## Related Issues
Fixes #123
Relates to #456
```

**3. Code Review Process**

- Maintainers will review your PR
- Address feedback promptly
- Update PR based on review comments
- Squash commits if requested

**4. Merging**

Once approved:
- PR will be merged to `main` branch
- Your contribution will be credited
- Included in next release

---

## Commit Message Guidelines

### Format

```
[Type]: Brief summary (50 chars or less)

Detailed explanation of what changed and why (wrap at 72 chars).

Include relevant NIST control IDs and any breaking changes.

Fixes #123
```

### Types

- `Feature`: New functionality
- `Bugfix`: Bug repair
- `Docs`: Documentation only
- `Security`: Security improvement
- `Refactor`: Code restructuring (no functional change)
- `Test`: Adding or updating tests
- `Style`: Formatting, whitespace (no code change)

### Examples

**Good Commit Messages:**

```
Feature: Add Prometheus node exporter installation

Added node exporter to collect system metrics for Prometheus.
Configured firewall rules and systemd service.

NIST Controls: AU-12 (Audit Generation)
```

```
Bugfix: Fix race condition in Wazuh indexer startup

Wazuh indexer was starting before Elasticsearch cluster ready.
Added wait loop to verify cluster health before proceeding.

Fixes #42
```

```
Security: Increase backup encryption key strength

Changed backup encryption from AES-128 to AES-256.
Updated key generation to use 32-byte random keys.

NIST Controls: SC-13 (Cryptographic Protection)
```

**Bad Commit Messages:**

```
Fixed stuff
```

```
Updated files
```

```
WIP
```

---

## Community

### Getting Help

- **GitHub Issues:** https://github.com/dshannon46-jpg/Cyberinabox-phaseII/issues
- **Documentation:** See README.md and docs/ directory
- **Discussions:** GitHub Discussions (if enabled)

### Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md (if maintained)
- Credited in release notes
- Acknowledged in project documentation

---

## License

By contributing to CyberHygiene Phase II, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to CyberHygiene Phase II!**

Your contributions help small businesses achieve NIST SP 800-171 compliance affordably.
