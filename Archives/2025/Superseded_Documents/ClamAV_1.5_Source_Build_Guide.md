# ClamAV 1.5.x Source Build Guide for Rocky Linux 9.6 FIPS

**Date:** October 29, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Purpose:** Build and test ClamAV 1.5.x with FIPS 140-2 support from source
**Author:** Claude Code for Donald E. Shannon

---

## Prerequisites

### System Requirements

- **Operating System:** Rocky Linux 9.6 (Blue Onyx)
- **FIPS Mode:** Enabled (required)
- **RAM:** Minimum 2GB for build, 4GB recommended
- **Disk Space:** 2GB free for build artifacts
- **User Access:** sudo privileges required

### Verify FIPS Mode

```bash
# Must return "FIPS mode is enabled"
sudo fips-mode-setup --check

# Must return "1"
cat /proc/sys/crypto/fips_enabled

# Verify kernel parameter
cat /proc/cmdline | grep fips
```

---

## Build Dependencies Installation

### Step 1: Install Development Tools

```bash
# Install EPEL repository (if not already installed)
sudo dnf install -y epel-release

# Install build essentials
sudo dnf groupinstall -y "Development Tools"

# Install CMake (required version 3.13+)
sudo dnf install -y cmake ninja-build

# Verify CMake version
cmake --version  # Should be 3.20+ on Rocky 9.6
```

### Step 2: Install ClamAV Build Dependencies

```bash
# Core dependencies
sudo dnf install -y \
    gcc \
    gcc-c++ \
    make \
    pkgconfig \
    python3 \
    python3-pytest \
    valgrind

# Library dependencies
sudo dnf install -y \
    bzip2-devel \
    check-devel \
    json-c-devel \
    libcurl-devel \
    libxml2-devel \
    ncurses-devel \
    openssl-devel \
    pcre2-devel \
    sendmail-devel \
    systemd-devel \
    zlib-devel

# Optional but recommended
sudo dnf install -y \
    libprelude-devel \
    libtool \
    libtool-ltdl-devel
```

### Step 3: Verify OpenSSL FIPS Module

```bash
# Verify OpenSSL supports FIPS
openssl version

# Check FIPS provider
openssl list -providers

# Should show "fips" provider available
```

---

## Download and Verify ClamAV Source

### Step 4: Download Latest Release

```bash
# Create build directory
mkdir -p ~/clamav-build
cd ~/clamav-build

# Download ClamAV 1.5.x source
CLAMAV_VERSION="1.5.1"  # Update as needed
wget https://www.clamav.net/downloads/production/clamav-${CLAMAV_VERSION}.tar.gz

# Download signature for verification
wget https://www.clamav.net/downloads/production/clamav-${CLAMAV_VERSION}.tar.gz.sig

# Import ClamAV GPG key
gpg --keyserver hkps://keys.openpgp.org --recv-keys 609B024F2B3EDD07
# Key ID: Talos (Talos, Cisco Systems Inc.) <research@sourcefire.com>

# Verify signature
gpg --verify clamav-${CLAMAV_VERSION}.tar.gz.sig clamav-${CLAMAV_VERSION}.tar.gz
```

**Expected output:**
```
gpg: Good signature from "Talos (Talos, Cisco Systems Inc.)"
```

### Step 5: Extract Source

```bash
tar -xzf clamav-${CLAMAV_VERSION}.tar.gz
cd clamav-${CLAMAV_VERSION}
```

---

## Build Configuration for FIPS Mode

### Step 6: Configure Build with FIPS Support

```bash
# Create build directory
mkdir build
cd build

# Configure with CMake (FIPS-aware)
cmake .. \
    -G Ninja \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=/usr/local/clamav-1.5 \
    -D ENABLE_JSON_SHARED=ON \
    -D ENABLE_SYSTEMD=ON \
    -D ENABLE_EXAMPLES=OFF \
    -D ENABLE_TESTS=ON \
    -D ENABLE_MILTER=OFF \
    -D OPENSSL_ROOT_DIR=/usr \
    -D OPENSSL_CRYPTO_LIBRARY=/usr/lib64/libcrypto.so

# Note: We install to /usr/local/clamav-1.5 to avoid conflicting
# with EPEL package, allowing easy fallback if needed
```

**Important FIPS Configuration Notes:**

- `OPENSSL_ROOT_DIR=/usr` ensures FIPS-validated OpenSSL is used
- Rocky Linux 9 OpenSSL is FIPS 140-2 validated when FIPS mode enabled
- ClamAV 1.5.x will auto-detect FIPS mode and enable FIPS-limits

### Step 7: Review Configuration

```bash
# Check configuration summary
cat CMakeCache.txt | grep -i openssl
cat CMakeCache.txt | grep -i fips

# Verify using system OpenSSL
grep "OPENSSL_" CMakeCache.txt
```

---

## Build and Test

### Step 8: Compile ClamAV

```bash
# Build using all available cores
ninja -j$(nproc)

# Build time: ~10-20 minutes depending on CPU
```

### Step 9: Run Unit Tests (Optional but Recommended)

```bash
# Run test suite
ninja test

# Or run ctest directly for verbose output
ctest --output-on-failure

# Expected: All tests should PASS in FIPS mode
# Note: Some tests may be skipped if they test non-FIPS algorithms
```

### Step 10: Install Built Binaries

```bash
# Install to /usr/local/clamav-1.5
sudo ninja install

# Create symlink for easy access (optional)
sudo ln -sf /usr/local/clamav-1.5/bin/clamscan /usr/local/bin/clamscan-1.5
sudo ln -sf /usr/local/clamav-1.5/bin/freshclam /usr/local/bin/freshclam-1.5
sudo ln -sf /usr/local/clamav-1.5/bin/clamd /usr/local/bin/clamd-1.5
```

---

## Configuration for FIPS Testing

### Step 11: Create Configuration Directory

```bash
# Create configuration directory
sudo mkdir -p /usr/local/clamav-1.5/etc

# Copy sample configurations
sudo cp /usr/local/clamav-1.5/share/clamav/template/*.sample \
    /usr/local/clamav-1.5/etc/

# Rename samples
cd /usr/local/clamav-1.5/etc
sudo mv freshclam.conf.sample freshclam.conf
sudo mv clamd.conf.sample clamd.conf
```

### Step 12: Configure freshclam

```bash
sudo vi /usr/local/clamav-1.5/etc/freshclam.conf
```

**Key settings:**

```
# Comment out Example line
#Example

# Database directory
DatabaseDirectory /var/lib/clamav-1.5

# Update log file
UpdateLogFile /var/log/clamav-1.5/freshclam.log

# Enable FIPS-compliant signature verification
# This is auto-detected, but can be forced:
# ExtraDatabase /var/lib/clamav-1.5/custom.cvd

# Database mirror
DatabaseMirror database.clamav.net
```

### Step 13: Create Directories and Set Permissions

```bash
# Create database directory
sudo mkdir -p /var/lib/clamav-1.5
sudo chown clamupdate:clamupdate /var/lib/clamav-1.5

# Create log directory
sudo mkdir -p /var/log/clamav-1.5
sudo chown clamupdate:clamupdate /var/log/clamav-1.5

# If clamupdate user doesn't exist, create it
if ! id clamupdate &>/dev/null; then
    sudo useradd -r -M -d /var/lib/clamav-1.5 -s /sbin/nologin clamupdate
fi
```

---

## FIPS Mode Testing

### Step 14: Initial Database Download

```bash
# Run freshclam as clamupdate user
sudo -u clamupdate /usr/local/clamav-1.5/bin/freshclam \
    --config-file=/usr/local/clamav-1.5/etc/freshclam.conf \
    --datadir=/var/lib/clamav-1.5 \
    --verbose

# This should download:
# - main.cvd
# - daily.cvd (or daily.cld)
# - bytecode.cvd
# - main.cvd.sign (FIPS signature)
# - daily.cvd.sign (FIPS signature)
# - bytecode.cvd.sign (FIPS signature)
```

**Expected FIPS output:**

```
FIPS mode detected: FIPS-limits enabled
Downloading main.cvd.sign
Verifying main.cvd using FIPS-compliant SHA256 signature
main.cvd verification: PASSED
```

### Step 15: Verify FIPS Signature Files

```bash
# Check for .cvd.sign files
ls -lh /var/lib/clamav-1.5/*.sign

# Expected files:
# main.cvd.sign
# daily.cvd.sign (or daily.cld.sign)
# bytecode.cvd.sign
```

### Step 16: Test Scanning with EICAR

```bash
# Download EICAR test file
cd /tmp
wget https://secure.eicar.org/eicar.com.txt

# Scan with ClamAV 1.5.x
/usr/local/clamav-1.5/bin/clamscan \
    --database=/var/lib/clamav-1.5 \
    /tmp/eicar.com.txt

# Expected output:
# /tmp/eicar.com.txt: Win.Test.EICAR_HDB-1 FOUND
```

### Step 17: Verify FIPS Mode Active

```bash
# Check version and FIPS status
/usr/local/clamav-1.5/bin/clamscan --version

# Should show version 1.5.x

# Verbose scan shows FIPS mode
/usr/local/clamav-1.5/bin/clamscan --verbose \
    --database=/var/lib/clamav-1.5 \
    /tmp/eicar.com.txt 2>&1 | grep -i fips
```

---

## Systemd Service Configuration (Optional)

### Step 18: Create Systemd Service Files

**freshclam service:**

```bash
sudo vi /etc/systemd/system/clamav-1.5-freshclam.service
```

```ini
[Unit]
Description=ClamAV 1.5.x virus database updater
Documentation=man:freshclam(1) man:freshclam.conf(5) https://docs.clamav.net/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/clamav-1.5/bin/freshclam \
    --config-file=/usr/local/clamav-1.5/etc/freshclam.conf \
    --daemon \
    --foreground=true
Restart=on-failure
User=clamupdate
Group=clamupdate

[Install]
WantedBy=multi-user.target
```

**clamd service:**

```bash
sudo vi /etc/systemd/system/clamav-1.5-clamd.service
```

```ini
[Unit]
Description=ClamAV 1.5.x daemon
Documentation=man:clamd(8) man:clamd.conf(5) https://docs.clamav.net/
After=clamav-1.5-freshclam.service

[Service]
Type=simple
ExecStart=/usr/local/clamav-1.5/sbin/clamd \
    --config-file=/usr/local/clamav-1.5/etc/clamd.conf \
    --foreground=true
Restart=on-failure
User=clamupdate
Group=clamupdate

[Install]
WantedBy=multi-user.target
```

### Step 19: Enable and Start Services

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable services
sudo systemctl enable clamav-1.5-freshclam.service
sudo systemctl enable clamav-1.5-clamd.service

# Start services
sudo systemctl start clamav-1.5-freshclam.service
sudo systemctl start clamav-1.5-clamd.service

# Check status
sudo systemctl status clamav-1.5-freshclam.service
sudo systemctl status clamav-1.5-clamd.service
```

---

## Validation and Testing

### Step 20: 2-Week Stability Test

**Create test monitoring script:**

```bash
cat > ~/test-clamav-1.5-stability.sh << 'EOF'
#!/bin/bash
# ClamAV 1.5 Stability Monitor
LOG="/var/log/clamav-1.5-stability.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Stability Check" >> $LOG

# Check service status
systemctl is-active clamav-1.5-clamd >> $LOG 2>&1
systemctl is-active clamav-1.5-freshclam >> $LOG 2>&1

# Check database updates
/usr/local/clamav-1.5/bin/freshclam \
    --config-file=/usr/local/clamav-1.5/etc/freshclam.conf \
    --check >> $LOG 2>&1

# Test scan
/usr/local/clamav-1.5/bin/clamscan \
    --database=/var/lib/clamav-1.5 \
    /tmp >> $LOG 2>&1

# Check for errors in logs
grep -i error /var/log/clamav-1.5/*.log >> $LOG 2>&1

echo "[$DATE] Check Complete" >> $LOG
echo "---" >> $LOG
EOF

chmod +x ~/test-clamav-1.5-stability.sh

# Run daily via cron
(crontab -l; echo "0 2 * * * ~/test-clamav-1.5-stability.sh") | crontab -
```

**Monitor for:**

- ✅ Service crashes or restarts
- ✅ Database update failures
- ✅ FIPS signature verification errors
- ✅ Memory leaks (check RSS in `ps aux`)
- ✅ CPU usage spikes
- ✅ Scan errors or false positives

---

## Production Deployment Checklist

### Step 21: Pre-Production Verification

Before deploying to production, verify:

- [ ] FIPS mode enabled: `fips-mode-setup --check`
- [ ] ClamAV 1.5.x version: `clamscan --version`
- [ ] Database signatures current: `freshclam --check`
- [ ] FIPS signatures present: `ls /var/lib/clamav-1.5/*.sign`
- [ ] EICAR test detection working
- [ ] Services auto-start on boot
- [ ] 2+ weeks stability testing completed
- [ ] No errors in logs: `/var/log/clamav-1.5/*.log`
- [ ] Wazuh integration tested
- [ ] SELinux denials resolved (check `ausearch -m avc`)
- [ ] Backup of old ClamAV config: `/etc/clamd.d/`

### Step 22: Rollback Plan

**If issues occur in production:**

```bash
# Stop 1.5 services
sudo systemctl stop clamav-1.5-clamd.service
sudo systemctl stop clamav-1.5-freshclam.service

# Re-enable EPEL version (if still installed)
sudo systemctl start clamd@scan
sudo systemctl start clamav-freshclam

# Or revert to compensating controls
# (Wazuh FIM + VirusTotal integration)
```

**Preserve build for debugging:**

```bash
# Archive built binaries
sudo tar -czf /backup/clamav-1.5-build-$(date +%Y%m%d).tar.gz \
    /usr/local/clamav-1.5 \
    /var/lib/clamav-1.5 \
    /var/log/clamav-1.5
```

---

## Troubleshooting

### Build Errors

**CMake fails to find OpenSSL:**

```bash
# Verify OpenSSL installed
rpm -qa | grep openssl-devel

# Explicitly set OpenSSL path
export OPENSSL_ROOT_DIR=/usr
cmake .. <other options>
```

**Compilation errors with FIPS:**

```bash
# Check FIPS mode during build
cat /proc/sys/crypto/fips_enabled

# Review build log
cat build/CMakeFiles/CMakeError.log
```

### Runtime Errors

**freshclam fails to download .cvd.sign files:**

```bash
# Check network connectivity
curl -I https://database.clamav.net

# Verify DNS resolution
dig database.clamav.net

# Try manual download
cd /var/lib/clamav-1.5
sudo -u clamupdate wget https://database.clamav.net/main.cvd.sign
```

**Signature verification fails:**

```bash
# Check if FIPS signatures exist
ls -lh /var/lib/clamav-1.5/*.sign

# Verify database integrity
/usr/local/clamav-1.5/bin/sigtool \
    --info /var/lib/clamav-1.5/main.cvd
```

**SELinux denials:**

```bash
# Check for denials
sudo ausearch -m avc -ts recent | grep clam

# Generate policy
sudo ausearch -m avc -ts recent | grep clam | audit2allow -M clamav_1.5_local
sudo semodule -i clamav_1.5_local.pp
```

---

## Resources

**Official Documentation:**
- ClamAV 1.5 Announcement: https://blog.clamav.net/2025/10/clamav-150-released.html
- Build Instructions: https://docs.clamav.net/manual/Installing/Installing-from-source.html
- FIPS Support: https://docs.clamav.net/manual/Usage/Configuration.html

**GitHub Repository:**
- Source Code: https://github.com/Cisco-Talos/clamav
- Issue Tracker: https://github.com/Cisco-Talos/clamav/issues
- FIPS Issue #564: https://github.com/Cisco-Talos/clamav/issues/564

**Rocky Linux FIPS:**
- FIPS Mode Setup: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/switching-rhel-to-fips-mode_security-hardening

---

**Prepared by:** Claude Code
**Date:** October 29, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**Reviewed for:** Donald E. Shannon, System Owner/ISSO
