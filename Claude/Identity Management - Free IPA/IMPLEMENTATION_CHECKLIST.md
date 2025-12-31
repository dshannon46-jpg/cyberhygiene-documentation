# ClamAV FIPS Solution - Implementation Checklist

**Date:** October 29, 2025 (Updated: November 12, 2025)
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**System:** Rocky Linux 9.6 NIST 800-171 Domain Controller

---

## Overview

Comprehensive implementation checklist for deploying FIPS-compatible antivirus solution using ClamAV 1.5.x with interim Wazuh enhancements.

---

## ✅ Completed Tasks (Today)

### Planning and Research
- [x] Identified ClamAV 1.5.x as FIPS-compatible solution
- [x] Researched open-source alternatives (excluded Kaspersky)
- [x] Evaluated VirusTotal integration options
- [x] Assessed YARA pattern detection capabilities
- [x] Documented multi-layered security approach

### Monitoring Infrastructure
- [x] Created ClamAV version monitoring script
  - **Location:** `/home/dshannon/bin/check-clamav-version.sh`
  - **Schedule:** Weekly (Mondays 9 AM)
  - **Function:** Checks EPEL for ClamAV 1.5.x availability
  - **Status:** ✅ Active and tested

### Documentation Created
- [x] ClamAV 1.5.x Source Build Guide (14 KB)
- [x] Wazuh VirusTotal Integration Guide (17 KB)
- [x] Wazuh YARA Integration Guide (21 KB)
- [x] ClamAV FIPS Solution Update Report (29 KB)
- [x] Implementation Checklist (this document)

---

## 📋 Week 1: Immediate Actions (October 29 - November 4, 2025)

### VirusTotal Integration

- [ ] **Obtain VirusTotal API Key**
  - [ ] Create account: https://www.virustotal.com/gui/join-us
  - [ ] Verify email address
  - [ ] Retrieve API key from: https://www.virustotal.com/gui/my-apikey
  - [ ] Store API key securely (do not commit to git)
  - **Duration:** 15 minutes

- [ ] **Configure Wazuh Integration**
  - [ ] Edit: `sudo vi /var/ossec/etc/ossec.conf`
  - [ ] Add VirusTotal integration block (see guide)
  - [ ] Insert API key in configuration
  - [ ] Add custom rules to `/var/ossec/etc/rules/local_rules.xml`
  - [ ] Validate config: `sudo /var/ossec/bin/wazuh-control check`
  - **Duration:** 30 minutes
  - **Guide:** `/home/dshannon/Documents/Claude/Wazuh_VirusTotal_Integration_Guide.md`

- [ ] **Test VirusTotal Integration**
  - [ ] Restart Wazuh: `sudo systemctl restart wazuh-manager`
  - [ ] Download EICAR: `wget https://secure.eicar.org/eicar.com.txt -O /tmp/eicar.com`
  - [ ] Wait 30-60 seconds for API call
  - [ ] Check alerts: `sudo tail -f /var/ossec/logs/alerts/alerts.log`
  - [ ] Verify detection and positive count
  - [ ] Clean up: `rm /tmp/eicar.com`
  - **Duration:** 15 minutes

- [ ] **Optional: Configure Active Response**
  - [ ] Add quarantine configuration (see guide section 7)
  - [ ] Create quarantine script
  - [ ] Test with EICAR file
  - **Duration:** 30 minutes

### YARA Integration

- [ ] **Install YARA**
  - [ ] Install packages: `sudo dnf install -y yara python3-yara`
  - [ ] Verify: `yara --version`
  - [ ] Test Python: `python3 -c "import yara; print(yara.__version__)"`
  - **Duration:** 10 minutes

- [ ] **Deploy YARA Rules**
  - [ ] Create directories: `sudo mkdir -p /var/ossec/ruleset/yara/{rules,scripts}`
  - [ ] Copy rule files from guide to `/var/ossec/ruleset/yara/rules/`
    - `malware_common.yar`
    - `linux_malware.yar`
    - `windows_malware.yar`
  - [ ] Set permissions: `sudo chown -R wazuh:wazuh /var/ossec/ruleset/yara`
  - **Duration:** 20 minutes
  - **Guide:** `/home/dshannon/Documents/Claude/Wazuh_YARA_Integration_Guide.md`

- [ ] **Deploy YARA Integration Script**
  - [ ] Create: `/var/ossec/ruleset/yara/scripts/yara-integration.py`
  - [ ] Make executable: `sudo chmod 750 yara-integration.py`
  - [ ] Create log file: `sudo touch /var/log/yara.log && sudo chown wazuh:wazuh /var/log/yara.log`
  - [ ] Test script: `sudo -u wazuh /var/ossec/ruleset/yara/scripts/yara-integration.py /tmp/test`
  - **Duration:** 15 minutes

- [ ] **Configure Wazuh YARA Integration**
  - [ ] Edit: `sudo vi /var/ossec/etc/ossec.conf`
  - [ ] Add YARA active response (see guide section 5)
  - [ ] Create: `/var/ossec/active-response/bin/yara-scan.sh`
  - [ ] Add YARA rules to `/var/ossec/etc/rules/local_rules.xml`
  - [ ] Restart Wazuh: `sudo systemctl restart wazuh-manager`
  - **Duration:** 20 minutes

- [ ] **Test YARA Detection**
  - [ ] Create EICAR: `cd /tmp && echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > eicar_yara.txt`
  - [ ] Check YARA log: `sudo tail -f /var/log/yara.log`
  - [ ] Check Wazuh alerts: `sudo grep -i yara /var/ossec/logs/alerts/alerts.log`
  - [ ] Clean up: `rm /tmp/eicar_yara.txt`
  - **Duration:** 10 minutes

### Documentation and Compliance

- [ ] **Update System Logs**
  - [ ] Document VirusTotal integration in change log
  - [ ] Document YARA deployment in change log
  - [ ] Note SI-3 status change: PARTIAL → ENHANCED
  - **Duration:** 15 minutes

- [ ] **Monitor Initial Performance**
  - [ ] Track VirusTotal API usage (first 24 hours)
  - [ ] Review YARA scan logs for errors
  - [ ] Check for false positives
  - [ ] Note: `/var/log/yara.log` and `/var/ossec/logs/ossec.log`
  - **Duration:** Ongoing

**Week 1 Total Estimated Time: 3-4 hours**

---

## 📋 Weeks 2-4: ClamAV 1.5.x Testing (November 5-25, 2025)

### Test Environment Setup

- [ ] **Create Test VM**
  - [ ] Deploy Rocky Linux 9.6 VM
  - [ ] Enable FIPS mode: `sudo fips-mode-setup --enable`
  - [ ] Reboot and verify: `cat /proc/sys/crypto/fips_enabled` (should be 1)
  - [ ] Install build dependencies (see build guide)
  - **Duration:** 2 hours

### Build ClamAV 1.5.x

- [ ] **Download and Verify Source**
  - [ ] Download: `wget https://www.clamav.net/downloads/production/clamav-1.5.1.tar.gz`
  - [ ] Download sig: `wget https://www.clamav.net/downloads/production/clamav-1.5.1.tar.gz.sig`
  - [ ] Import GPG key: `gpg --keyserver hkps://keys.openpgp.org --recv-keys 609B024F2B3EDD07`
  - [ ] Verify: `gpg --verify clamav-1.5.1.tar.gz.sig clamav-1.5.1.tar.gz`
  - **Duration:** 30 minutes
  - **Guide:** `/home/dshannon/Documents/Claude/ClamAV_1.5_Source_Build_Guide.md`

- [ ] **Build from Source**
  - [ ] Extract: `tar -xzf clamav-1.5.1.tar.gz && cd clamav-1.5.1`
  - [ ] Configure: `mkdir build && cd build && cmake .. -G Ninja <options>`
  - [ ] Compile: `ninja -j$(nproc)`
  - [ ] Run tests: `ninja test`
  - [ ] Install: `sudo ninja install`
  - **Duration:** 1-2 hours (compile time)

- [ ] **Configure ClamAV**
  - [ ] Create config directory: `sudo mkdir -p /usr/local/clamav-1.5/etc`
  - [ ] Copy configs: `sudo cp .../*.sample /usr/local/clamav-1.5/etc/`
  - [ ] Edit freshclam.conf (uncomment Example, set paths)
  - [ ] Edit clamd.conf (uncomment Example, set paths)
  - [ ] Create directories: `/var/lib/clamav-1.5`, `/var/log/clamav-1.5`
  - **Duration:** 30 minutes

### FIPS Testing

- [ ] **Initial Database Download**
  - [ ] Run: `sudo -u clamupdate /usr/local/clamav-1.5/bin/freshclam --verbose`
  - [ ] Verify FIPS mode detected in output
  - [ ] Check for `.cvd.sign` files: `ls /var/lib/clamav-1.5/*.sign`
  - [ ] Verify database loaded: `ls /var/lib/clamav-1.5/*.cvd`
  - **Duration:** 30 minutes

- [ ] **Test Scanning**
  - [ ] Download EICAR: `wget https://secure.eicar.org/eicar.com.txt -O /tmp/eicar.com`
  - [ ] Scan: `/usr/local/clamav-1.5/bin/clamscan /tmp/eicar.com`
  - [ ] Verify detection: "Win.Test.EICAR_HDB-1 FOUND"
  - [ ] Check FIPS mode: `clamscan --version`
  - **Duration:** 15 minutes

- [ ] **Performance Testing**
  - [ ] Full system scan: `clamscan -r /home`
  - [ ] Monitor CPU/RAM usage: `top`, `htop`
  - [ ] Check scan speed (MB/s)
  - [ ] Log results for comparison
  - **Duration:** 2-4 hours

### Stability Testing

- [ ] **2-Week Monitoring**
  - [ ] Create stability test script (see build guide)
  - [ ] Schedule daily cron job
  - [ ] Monitor logs daily: `/var/log/clamav-1.5/*.log`
  - [ ] Check for:
    - Service crashes
    - Database update failures
    - Memory leaks
    - Scan errors
  - **Duration:** 2 weeks (daily 15-min checks)

- [ ] **Issue Documentation**
  - [ ] Log any errors or anomalies
  - [ ] Report critical issues to ClamAV GitHub
  - [ ] Assess production readiness
  - **Duration:** Ongoing

**Weeks 2-4 Total Estimated Time: 10-15 hours + 2-week monitoring**

---

## 📋 Weeks 5-6: Production Preparation (November 26 - December 9, 2025)

### Deployment Planning

- [ ] **Create Production Runbook**
  - [ ] Document step-by-step deployment procedure
  - [ ] Include rollback steps
  - [ ] Define success criteria
  - [ ] Identify stakeholders for notification
  - **Duration:** 2 hours

- [ ] **Backup Current Configuration**
  - [ ] Backup: `sudo tar -czf /backup/clamav-1.4-config-$(date +%Y%m%d).tar.gz /etc/clamd.d /var/lib/clamav`
  - [ ] Verify backup integrity
  - [ ] Store backup securely
  - **Duration:** 30 minutes

- [ ] **Prepare Systemd Services**
  - [ ] Create: `/etc/systemd/system/clamav-1.5-freshclam.service`
  - [ ] Create: `/etc/systemd/system/clamav-1.5-clamd.service`
  - [ ] Test in non-production: `systemctl start clamav-1.5-clamd`
  - **Duration:** 1 hour

### Documentation Updates

- [ ] **Draft SSP Updates**
  - [ ] Update Section 2.6 (Antivirus and Malware Protection)
  - [ ] Document FIPS compliance
  - [ ] Note multi-layered approach
  - [ ] Reference supporting documentation
  - **Duration:** 2 hours

- [ ] **Update POA&M-014**
  - [ ] Change status: PLANNED → IN PROGRESS
  - [ ] Update milestones with actual dates
  - [ ] Document progress (60% → 90%)
  - [ ] Adjust target completion if needed
  - **Duration:** 30 minutes

- [ ] **Prepare Compliance Scan**
  - [ ] Schedule OpenSCAP scan post-deployment
  - [ ] Prepare test checklist
  - [ ] Document expected outcomes
  - **Duration:** 1 hour

**Weeks 5-6 Total Estimated Time: 6-8 hours**

---

## 📋 Weeks 7-8: Production Deployment (December 10-23, 2025)

### Pre-Deployment

- [ ] **Final Verification**
  - [ ] Confirm test environment stability (2+ weeks)
  - [ ] Review test logs for issues
  - [ ] Verify EPEL availability (or proceed with source install)
  - [ ] Schedule maintenance window
  - [ ] Notify stakeholders
  - **Duration:** 2 hours

- [ ] **Deployment Checklist**
  - [ ] FIPS mode enabled: `fips-mode-setup --check`
  - [ ] Wazuh operational: `systemctl status wazuh-manager`
  - [ ] Backup completed and verified
  - [ ] Rollback plan documented
  - [ ] Emergency contacts identified
  - **Duration:** 1 hour

### Deployment

- [ ] **Install ClamAV 1.5.x**
  - [ ] Option A: From EPEL (if available): `sudo dnf update clamav`
  - [ ] Option B: From source (see build guide)
  - [ ] Verify installation: `clamscan --version`
  - **Duration:** 1-2 hours

- [ ] **Configure and Start Services**
  - [ ] Update configuration files
  - [ ] Enable services: `sudo systemctl enable clamav-1.5-clamd clamav-1.5-freshclam`
  - [ ] Start services: `sudo systemctl start clamav-1.5-clamd clamav-1.5-freshclam`
  - [ ] Check status: `systemctl status clamav-1.5-*`
  - **Duration:** 30 minutes

- [ ] **Verify Operation**
  - [ ] Check FIPS mode: `clamscan --version | grep -i fips`
  - [ ] Test scan: `clamscan -r /tmp`
  - [ ] Verify database: `ls -lh /var/lib/clamav-1.5/*.sign`
  - [ ] Check logs: `sudo tail -f /var/log/clamav-1.5/*.log`
  - **Duration:** 30 minutes

### Wazuh Integration

- [ ] **Configure ClamAV Logging**
  - [ ] Edit clamd.conf: Enable syslog
  - [ ] Configure log file: `/var/log/clamd.log`
  - [ ] Restart service: `systemctl restart clamav-1.5-clamd`
  - **Duration:** 15 minutes

- [ ] **Update Wazuh Configuration**
  - [ ] Add ClamAV log monitoring to `/var/ossec/etc/ossec.conf`
  - [ ] Verify existing rules: `/var/ossec/ruleset/rules/0320-clam_av_rules.xml`
  - [ ] Restart Wazuh: `systemctl restart wazuh-manager`
  - **Duration:** 20 minutes

- [ ] **Test Integration**
  - [ ] Scan with EICAR: `clamscan /tmp/eicar.com`
  - [ ] Verify Wazuh alert: `sudo grep "52502" /var/ossec/logs/alerts/alerts.log`
  - [ ] Check alert details (rule ID, file path, malware name)
  - **Duration:** 15 minutes

### Post-Deployment

- [ ] **Run Compliance Scan**
  - [ ] Execute OpenSCAP: `sudo oscap xccdf eval --profile cui ...`
  - [ ] Generate report
  - [ ] Review results for SI-3 control
  - [ ] Document compliance status
  - **Duration:** 1 hour

- [ ] **1-Week Monitoring**
  - [ ] Daily log review: `/var/log/clamav-1.5/*.log`
  - [ ] Check service status: `systemctl status clamav-1.5-*`
  - [ ] Monitor Wazuh alerts
  - [ ] Verify database updates
  - [ ] Address any issues immediately
  - **Duration:** 7 days × 15 minutes/day

- [ ] **Update Documentation**
  - [ ] Finalize SSP Section 2.6 updates
  - [ ] Close POA&M-014: Status → COMPLETED
  - [ ] Update implementation metrics: 94% → 97%
  - [ ] Update SPRS score: 90 → 91 points
  - [ ] Archive deployment notes
  - **Duration:** 2 hours

**Weeks 7-8 Total Estimated Time: 8-10 hours + 1-week monitoring**

---

## 📋 Q1 2026: Optimization and Review (January - March 2026)

### Performance Tuning

- [ ] **Analyze Performance Metrics**
  - [ ] Review scan times and throughput
  - [ ] Check CPU/RAM usage trends
  - [ ] Optimize scan schedules if needed
  - [ ] Tune real-time scanning exclusions
  - **Duration:** 2 hours

- [ ] **Refine Detection Rules**
  - [ ] Review false positives (past 30 days)
  - [ ] Update YARA rules for accuracy
  - [ ] Adjust Wazuh alert thresholds
  - [ ] Document rule changes
  - **Duration:** 3 hours

### Cost Optimization

- [ ] **Review VirusTotal Usage**
  - [ ] Analyze API calls (past 90 days)
  - [ ] Calculate daily average
  - [ ] Assess free tier adequacy (500/day)
  - [ ] Decision: Keep free or upgrade to premium ($180/year)
  - **Duration:** 1 hour

- [ ] **Archive Interim Solutions**
  - [ ] Document VirusTotal as supplemental (not primary)
  - [ ] Retain YARA for pattern detection
  - [ ] Consider disabling VirusTotal if redundant
  - [ ] Update SSP to reflect architecture
  - **Duration:** 2 hours

### Compliance Review

- [ ] **Quarterly Compliance Scan**
  - [ ] Run OpenSCAP: `sudo oscap xccdf eval ...`
  - [ ] Generate compliance report
  - [ ] Compare to baseline (94% → 97%)
  - [ ] Address any new findings
  - **Duration:** 2 hours

- [ ] **Risk Reassessment**
  - [ ] Update risk register
  - [ ] Document residual risks
  - [ ] Verify compensating controls
  - [ ] Prepare for CMMC assessment
  - **Duration:** 3 hours

### SPRS Score Update

- [ ] **Recalculate SPRS**
  - [ ] Verify SI-3: FULLY IMPLEMENTED
  - [ ] Update assessment evidence
  - [ ] Calculate new score (~91 points)
  - [ ] Document in SSP
  - **Duration:** 2 hours

- [ ] **Prepare for Audit**
  - [ ] Compile evidence (logs, configs, reports)
  - [ ] Document malware detection incidents
  - [ ] Prepare demonstration (EICAR test)
  - [ ] Review POA&M closure documentation
  - **Duration:** 4 hours

**Q1 2026 Total Estimated Time: 15-20 hours**

---

## 📊 Total Effort Summary

| Phase | Duration | Calendar Time | Status |
|-------|----------|---------------|--------|
| Planning & Research | 4 hours | Oct 29 | ✅ Complete |
| Week 1: Interim Solutions | 3-4 hours | Oct 29 - Nov 4 | 🔄 Ready |
| Weeks 2-4: Testing | 10-15 hours | Nov 5-25 | ⏳ Pending |
| Weeks 5-6: Preparation | 6-8 hours | Nov 26 - Dec 9 | ⏳ Pending |
| Weeks 7-8: Deployment | 8-10 hours | Dec 10-23 | ⏳ Pending |
| Q1 2026: Optimization | 15-20 hours | Jan-Mar 2026 | ⏳ Pending |
| **Total** | **46-61 hours** | **~12 weeks** | **In Progress** |

---

## 🎯 Success Criteria

### Technical Success
- [x] ClamAV version monitoring active
- [ ] VirusTotal integration functional (EICAR detected)
- [ ] YARA scanning operational (EICAR detected)
- [ ] ClamAV 1.5.x built and tested successfully
- [ ] FIPS mode verified active
- [ ] Database updates working (.cvd.sign files)
- [ ] Wazuh integration generating alerts
- [ ] No service disruptions during deployment

### Compliance Success
- [ ] SI-3 status: PARTIAL → FULLY IMPLEMENTED
- [ ] SPRS score: 90 → 91 points
- [ ] OpenSCAP scan: >95% compliant
- [ ] POA&M-014: COMPLETED
- [ ] SSP updated and approved
- [ ] CMMC assessment ready

### Operational Success
- [ ] False positive rate: <1%
- [ ] Detection rate: >95% (malware samples)
- [ ] Service uptime: >99.9%
- [ ] Database update success: >99%
- [ ] Alert response time: <1 hour

---

## 📚 Reference Documentation

**Created Guides (October 29, 2025):**
1. `/home/dshannon/Documents/Claude/ClamAV_1.5_Source_Build_Guide.md` (14 KB)
2. `/home/dshannon/Documents/Claude/Wazuh_VirusTotal_Integration_Guide.md` (17 KB)
3. `/home/dshannon/Documents/Claude/Wazuh_YARA_Integration_Guide.md` (21 KB)
4. `/home/dshannon/Documents/Claude/ClamAV_FIPS_Solution_Update_Report.md` (29 KB)

**Existing Documentation:**
1. `/home/dshannon/Documents/Claude/ClamAV_FIPS_Incompatibility_Final_Report.md` (Oct 28)
2. `/home/dshannon/Documents/Claude/CLAUDE.md` (System overview)

**External Resources:**
- ClamAV Official: https://www.clamav.net
- ClamAV 1.5.0 Release: https://blog.clamav.net/2025/10/clamav-150-released.html
- Wazuh Documentation: https://documentation.wazuh.com
- NIST 800-171 Rev 2: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final

---

## 🆘 Troubleshooting Quick Reference

**VirusTotal Not Working:**
```bash
# Check API key
curl -X GET "https://www.virustotal.com/api/v3/files/test" -H "x-apikey: YOUR_KEY"

# Check Wazuh logs
sudo grep -i virustotal /var/ossec/logs/ossec.log

# Verify FIM triggering
sudo grep syscheck /var/ossec/logs/ossec.log
```

**YARA Not Scanning:**
```bash
# Test YARA directly
sudo -u wazuh /var/ossec/ruleset/yara/scripts/yara-integration.py /tmp/eicar.com

# Check logs
sudo cat /var/log/yara.log

# Verify permissions
ls -lh /var/ossec/ruleset/yara/scripts/yara-integration.py
```

**ClamAV Build Fails:**
```bash
# Check dependencies
sudo dnf groupinfo "Development Tools"

# Review CMake error log
cat build/CMakeFiles/CMakeError.log

# Verify FIPS mode
cat /proc/sys/crypto/fips_enabled  # Should be 1
```

**Database Updates Fail:**
```bash
# Manual update
sudo -u clamupdate freshclam --verbose

# Check connectivity
curl -I https://database.clamav.net

# Verify .cvd.sign files
ls -lh /var/lib/clamav/*.sign
```

---

## ✅ Completion Sign-Off

- [ ] **Week 1 Complete** - Interim solutions deployed
  - Date: __________
  - Signature: __________

- [ ] **Weeks 2-4 Complete** - ClamAV 1.5.x tested
  - Date: __________
  - Signature: __________

- [ ] **Weeks 7-8 Complete** - Production deployment successful
  - Date: __________
  - Signature: __________

- [ ] **Q1 2026 Complete** - Optimization and compliance verified
  - Date: __________
  - Signature: __________

---

**Prepared by:** Claude Code
**Date:** October 29, 2025
**Classification:** CONTROLLED UNCLASSIFIED INFORMATION (CUI)
**For:** Donald E. Shannon, System Owner/ISSO
