# CyberHygiene Phase II - GitHub Deployment Guide

This guide explains how to commit the installer to GitHub and make it available for customer deployments.

---

## Repository Information

**GitHub Repository:** https://github.com/The-CyberHygiene-Project/Cyberinabox-phaseII
**License:** MIT
**Platform:** Rocky Linux 9 (FIPS-enabled)

---

## Pre-Commit Checklist

Before committing to GitHub, verify:

### ✅ Safe to Commit (Already Created)

- [x] `master_install.sh` - Main installation orchestrator
- [x] `scripts/*.sh` - All 17 installation modules
- [x] `installation_info_template.md` - Customer information template (empty)
- [x] `configuration_substitution_map.md` - Configuration documentation
- [x] `fips_rocky_linux_installation_guide.md` - FIPS installation guide
- [x] `master_installation_script_architecture.md` - Architecture documentation
- [x] `hp_dl20_hardware_specifications.md` - Hardware specifications
- [x] `README.md` - Installation guide
- [x] `README_GITHUB.md` - Public repository documentation
- [x] `quick-install.sh` - One-command installer
- [x] `.gitignore` - Security protections
- [x] `LICENSE` - MIT license file

### ❌ NEVER Commit (Protected by .gitignore)

- [ ] `installation_info.md` - Filled out customer data
- [ ] `install_vars.sh` - Generated variables and passwords
- [ ] `CREDENTIALS_*.txt` - Password files
- [ ] `logs/` - Installation logs
- [ ] `backups/` - System backups
- [ ] `*.key`, `*.pem` - Encryption keys and certificates

---

## First-Time Repository Setup

### Step 1: Initialize Git Repository

```bash
# Navigate to installer directory
cd "/path/to/Cyberinabox-phaseII"  # Adjust to your local clone location

# Initialize git (if not already done)
git init

# Add remote (if not already done)
git remote add origin https://github.com/The-CyberHygiene-Project/Cyberinabox-phaseII.git
```

### Step 2: Verify .gitignore is Working

```bash
# Check git status
git status

# You should see:
#   - All .sh files, .md files, LICENSE (safe files)
#
# You should NOT see (if they exist):
#   - installation_info.md
#   - install_vars.sh
#   - CREDENTIALS_*.txt
#   - logs/, backups/

# Test .gitignore protection
echo "test" > installation_info.md
git status
# Should NOT show installation_info.md

# Clean up test
rm installation_info.md
```

### Step 3: Configure Git Identity

```bash
# Set your git identity
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Or use global settings
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 4: Commit All Files

```bash
# Stage all safe files
git add .

# Verify what will be committed
git status

# Commit with descriptive message
git commit -m "Initial commit: CyberHygiene Phase II automated installer

- Complete installation automation (17 modules)
- NIST SP 800-171 compliant deployment
- Reduces installation time from 2-3 weeks to 90 minutes
- HP Proliant DL20 Gen10 Plus target platform
- Rocky Linux 9 FIPS-enabled
- Includes FreeIPA, Wazuh, Samba, Graylog, Suricata, Prometheus, Grafana
- Automated password generation and secure credential handling
- Comprehensive documentation and troubleshooting guides"
```

### Step 5: Push to GitHub

```bash
# Push to main branch
git branch -M main
git push -u origin main

# If you encounter authentication issues:
# 1. Use personal access token instead of password
# 2. Or configure SSH key authentication
```

---

## Updating the Repository

### After Making Changes

```bash
# Check what changed
git status
git diff

# Stage changes
git add <file1> <file2>
# or
git add .

# Commit changes
git commit -m "Descriptive message about what changed"

# Push to GitHub
git push
```

### Before Every Commit: Security Verification

```bash
# Always verify before committing
git status | grep -E "(installation_info\.md|install_vars\.sh|CREDENTIALS|\.key|\.pem)"

# If the above command shows any output, DO NOT COMMIT!
# Check your .gitignore file

# Safe commit verification
git diff --cached | grep -E "(password|secret|key|credential)" || echo "Safe to commit"
```

---

## Repository Structure

```
Cyberinabox-phaseII/
├── master_install.sh              # Main installer
├── quick-install.sh               # One-command download script
├── scripts/                       # Installation modules
│   ├── 00_prerequisites_check.sh
│   ├── 01_generate_variables.sh
│   ├── 02_backup_system.sh
│   ├── 10_install_freeipa.sh
│   ├── 11_configure_dns.sh
│   ├── 12_deploy_ssl_certs.sh
│   ├── 20_install_samba.sh
│   ├── 30_install_graylog.sh
│   ├── 40_install_suricata.sh
│   ├── 50_install_prometheus.sh
│   ├── 51_install_grafana.sh
│   ├── 60_install_wazuh.sh
│   ├── 70_configure_backup.sh
│   ├── 80_deploy_policies.sh
│   ├── 90_customize_documentation.sh
│   └── 99_final_verification.sh
├── installation_info_template.md  # Customer data form (template only)
├── configuration_substitution_map.md
├── fips_rocky_linux_installation_guide.md
├── master_installation_script_architecture.md
├── hp_dl20_hardware_specifications.md
├── README.md                      # Installation guide
├── README_GITHUB.md              # Public documentation
├── LICENSE                        # MIT license
└── .gitignore                     # Security protections
```

---

## Testing the Public Installer

### Test Download from GitHub

```bash
# On a test system, try the quick-install script
curl -sSL https://raw.githubusercontent.com/The-CyberHygiene-Project/Cyberinabox-phaseII/main/quick-install.sh | sudo bash

# Or manual clone
git clone https://github.com/The-CyberHygiene-Project/Cyberinabox-phaseII.git
cd Cyberinabox-phaseII
./master_install.sh
```

### Verify Documentation Renders Correctly

Visit on GitHub:
- https://github.com/The-CyberHygiene-Project/Cyberinabox-phaseII
- Check README displays correctly
- Verify badges render (License, Platform, FIPS)
- Test all internal links

---

## GitHub Repository Settings

### Recommended Settings

**Repository Description:**
```
NIST SP 800-171 compliant security platform installer for small businesses.
Automated deployment of FreeIPA, Wazuh SIEM, Samba, Graylog, Suricata IDS/IPS,
Prometheus, and Grafana on Rocky Linux 9 (FIPS-enabled).
```

**Topics (tags):**
- `nist-800-171`
- `cybersecurity`
- `freeipa`
- `wazuh`
- `siem`
- `rocky-linux`
- `fips`
- `automation`
- `small-business`
- `compliance`

**Website:**
- (Optional) Link to your business website or documentation

### Branch Protection (Optional)

For production repository:
1. Go to Settings → Branches
2. Add branch protection rule for `main`
3. Enable:
   - Require pull request reviews before merging
   - Require status checks to pass
   - Include administrators

---

## Continuous Integration (Future Enhancement)

Consider adding GitHub Actions for:

### Example: `.github/workflows/security-check.yml`

```yaml
name: Security Check
on: [push, pull_request]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Check for sensitive data
        run: |
          if grep -r "password.*=" scripts/ --include="*.sh"; then
            echo "ERROR: Found hardcoded passwords"
            exit 1
          fi

      - name: Verify .gitignore
        run: |
          if [ ! -f .gitignore ]; then
            echo "ERROR: .gitignore missing"
            exit 1
          fi

      - name: ShellCheck scripts
        run: |
          sudo apt-get install -y shellcheck
          find scripts/ -name "*.sh" -exec shellcheck {} \;
```

---

## Common Git Commands Reference

```bash
# Check repository status
git status

# View commit history
git log --oneline

# View differences
git diff                    # Unstaged changes
git diff --cached           # Staged changes
git diff HEAD~1             # Last commit

# Undo changes
git checkout -- <file>      # Discard unstaged changes
git reset HEAD <file>       # Unstage file
git reset --soft HEAD~1     # Undo last commit (keep changes)

# Create branch for development
git checkout -b feature-name
git push -u origin feature-name

# Create release tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## Release Management

### Creating a Release

1. **Commit all final changes**
   ```bash
   git add .
   git commit -m "Prepare release v1.0.0"
   git push
   ```

2. **Create tag**
   ```bash
   git tag -a v1.0.0 -m "CyberHygiene Phase II v1.0.0 - Initial Release

   Features:
   - Automated installation (90 minutes)
   - NIST SP 800-171 compliance
   - 17 installation modules
   - FreeIPA, Wazuh, Samba, Graylog, Suricata, Prometheus, Grafana
   - Rocky Linux 9 FIPS support"

   git push origin v1.0.0
   ```

3. **Create GitHub release**
   - Go to GitHub repository → Releases → Draft a new release
   - Select tag: v1.0.0
   - Release title: "CyberHygiene Phase II v1.0.0"
   - Description: Copy from tag message
   - Attach any additional files (optional)
   - Publish release

---

## Troubleshooting

### Problem: Git shows installation_info.md as staged

**Solution:**
```bash
# Remove from staging
git reset HEAD installation_info.md

# Verify .gitignore contains
cat .gitignore | grep "installation_info.md"

# If not in .gitignore, add it
echo "installation_info.md" >> .gitignore
git add .gitignore
git commit -m "Fix: Add installation_info.md to .gitignore"
```

### Problem: Already committed sensitive file

**Solution (if caught before push):**
```bash
# Remove from last commit
git rm --cached <sensitive-file>
git commit --amend -m "Remove sensitive file"
```

**Solution (if already pushed - DANGEROUS):**
```bash
# WARNING: This rewrites history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch <sensitive-file>" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (coordinate with team first!)
git push origin --force --all
```

Better: Rotate all exposed credentials immediately and create new commit with fixes.

### Problem: Push rejected (authentication failed)

**Solution 1: Personal Access Token**
```bash
# Create token at: https://github.com/settings/tokens
# Use token as password when prompted
git push
```

**Solution 2: SSH Key**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
cat ~/.ssh/id_ed25519.pub

# Change remote URL
git remote set-url origin git@github.com:The-CyberHygiene-Project/Cyberinabox-phaseII.git
```

---

## Security Best Practices

### 1. Never Force Push to Main

```bash
# Bad
git push --force

# Good
git push
# If rejected, pull and merge
```

### 2. Review Before Committing

```bash
# Always review what you're committing
git diff --cached

# Check for sensitive data
git diff --cached | grep -i "password\|secret\|key"
```

### 3. Use Signed Commits (Optional)

```bash
# Generate GPG key
gpg --full-generate-key

# Configure git
git config --global user.signingkey <your-key-id>
git config --global commit.gpgsign true

# Sign commits
git commit -S -m "Signed commit message"
```

### 4. Regular Security Audits

```bash
# Check for exposed secrets
git log --all --full-history --source --oneline -- installation_info.md

# Should return nothing if .gitignore worked correctly
```

---

## Support and Contributing

### Getting Help

1. Check [README_GITHUB.md](README_GITHUB.md) for documentation
2. Review [troubleshooting guide](README_GITHUB.md#troubleshooting)
3. Open issue on GitHub with:
   - Rocky Linux version
   - Hardware specifications
   - Error messages (redact sensitive data)
   - Steps to reproduce

### Contributing

1. Fork repository
2. Create feature branch
3. Test on clean Rocky Linux 9 installation
4. Submit pull request with detailed description
5. Ensure no sensitive data included

---

## Post-Deployment Checklist

After pushing to GitHub:

- [ ] Verify README displays correctly on GitHub
- [ ] Test `quick-install.sh` download from GitHub
- [ ] Check all documentation links work
- [ ] Verify `.gitignore` prevents sensitive files
- [ ] Add repository description and topics
- [ ] Create v1.0.0 release tag
- [ ] Test installation on HP Proliant DL20 hardware
- [ ] Document any issues encountered
- [ ] Plan alpha test deployment

---

## Next Steps

1. **Initial Commit**
   - Follow "First-Time Repository Setup" above
   - Push all files to GitHub

2. **Test Public Access**
   - Verify quick-install script works from GitHub
   - Check documentation renders correctly

3. **Alpha Testing**
   - Deploy at test customer site
   - Gather feedback
   - Iterate and improve

4. **Production Release**
   - Create v1.0.0 release
   - Update documentation with lessons learned
   - Plan customer deployments

---

**Repository Ready for Deployment!**

All files are prepared, security protections in place, and documentation complete.
Follow the steps above to commit and push to GitHub.
