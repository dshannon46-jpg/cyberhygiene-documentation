# CyberHygiene Weekly Documentation Update System

**System Name:** `cyberhygiene-weekly-update`
**Version:** 1.0
**Created:** November 19, 2025
**System:** cyberinabox.net NIST 800-171 Compliance

---

## Overview

The **CyberHygiene Weekly Update System** is an automated tool designed to review and update CyberHygiene documentation dashboards to reflect recent changes and modifications. This system helps maintain accurate, up-to-date compliance documentation by automatically scanning for document changes and generating comprehensive update reports.

### Purpose

- **Automated Documentation Tracking:** Identifies files modified within a specified time period
- **Dashboard Updates:** Automatically updates the System Status Dashboard with recent changes
- **Compliance Reporting:** Generates weekly reports for compliance review and audit trails
- **Change Management:** Provides visibility into documentation changes across the system

### Key Features

- Scans markdown, HTML, and DOCX files for recent modifications
- Generates detailed weekly update reports with file categorization
- Automatically updates the System Status Dashboard
- Creates backups before modifying dashboards
- Supports both interactive and automated (cron) execution
- Comprehensive logging for audit and troubleshooting
- Flexible configuration options

---

## Installation

The script is already installed at:
```bash
/home/dshannon/bin/cyberhygiene-weekly-update
```

### Verify Installation

```bash
# Check if script exists and is executable
ls -lh /home/dshannon/bin/cyberhygiene-weekly-update

# Test the script
cyberhygiene-weekly-update --help
```

### Directory Structure

The system uses the following directories:

```
/home/dshannon/Documents/Claude/          # Main documentation directory
├── Artifacts/                            # Policy documents and dashboards
│   └── System_Status_Dashboard.html     # Main dashboard
├── Reports/                              # Generated weekly update reports & guide
├── Archives/                             # Dashboard backups
└── [Various .md and .docx files]        # Documentation files

/var/log/cyberhygiene/                    # Log directory
└── weekly-update.log                     # Activity log
```

---

## Usage

### Basic Usage

Run the weekly update manually:

```bash
cyberhygiene-weekly-update
```

This will:
1. Scan for files modified in the last 7 days
2. Generate a weekly update report
3. Backup the current dashboard
4. Update the dashboard with recent changes

### Command-Line Options

```bash
# Show help and usage information
cyberhygiene-weekly-update --help

# Generate report only, don't update dashboard
cyberhygiene-weekly-update --report-only

# Enable verbose output
cyberhygiene-weekly-update --verbose

# Look back 14 days instead of default 7
cyberhygiene-weekly-update --days 14

# Combine options
cyberhygiene-weekly-update --days 30 --verbose --report-only
```

### Common Use Cases

#### Weekly Review (Recommended)
```bash
# Run every Monday morning
cyberhygiene-weekly-update
```

#### Monthly Comprehensive Review
```bash
# Review entire month of changes
cyberhygiene-weekly-update --days 30 --verbose
```

#### Quick Status Check
```bash
# Generate report without modifying dashboard
cyberhygiene-weekly-update --report-only
```

#### Troubleshooting
```bash
# Run with verbose output for debugging
cyberhygiene-weekly-update --verbose
```

---

## Automated Execution (Cron)

### Setting Up Weekly Automated Updates

The script is designed to run automatically via cron. Here's how to set it up:

#### Option 1: User Crontab (Recommended)

```bash
# Edit your crontab
crontab -e

# Add this line to run every Monday at 8:00 AM
0 8 * * 1 /home/dshannon/bin/cyberhygiene-weekly-update

# Or run every Sunday night at 11:00 PM
0 23 * * 0 /home/dshannon/bin/cyberhygiene-weekly-update

# Save and exit
```

#### Option 2: System Crontab (Root)

```bash
# Edit system crontab
sudo crontab -e

# Add this line
0 8 * * 1 /home/dshannon/bin/cyberhygiene-weekly-update
```

#### Cron Schedule Examples

```bash
# Every Monday at 8:00 AM
0 8 * * 1 /home/dshannon/bin/cyberhygiene-weekly-update

# Every day at 7:00 AM
0 7 * * * /home/dshannon/bin/cyberhygiene-weekly-update

# First day of every month at 9:00 AM
0 9 1 * * /home/dshannon/bin/cyberhygiene-weekly-update

# Every Friday at 5:00 PM (end of week)
0 17 * * 5 /home/dshannon/bin/cyberhygiene-weekly-update
```

### Verify Cron Setup

```bash
# List current cron jobs
crontab -l

# Check cron service is running
sudo systemctl status crond

# View recent cron execution logs
grep cyberhygiene /var/log/cron
```

### Email Notifications (Optional)

To receive email notifications when the script runs:

```bash
# Edit crontab
crontab -e

# Add MAILTO variable at the top
MAILTO=your.email@cyberinabox.net

# Then add your cron job
0 8 * * 1 /home/dshannon/bin/cyberhygiene-weekly-update
```

---

## Output and Reports

### Generated Reports

Weekly update reports are saved to:
```
/home/dshannon/Documents/Claude/Reports/Weekly_Update_YYYY-MM-DD_HH-MM-SS.md
```

Each report includes:
- **Executive Summary:** Total files modified, review period
- **Recent Documentation Changes:** Table of modified files with timestamps and categories
- **Documentation Categories Summary:** Overview of documentation types
- **System Dashboard Updates:** Status of dashboard modifications
- **Recommendations:** Action items for review
- **Next Steps:** Checklist for follow-up actions

### Example Report Structure

```markdown
# CyberHygiene Documentation Weekly Update Report

**Generated:** November 19, 2025 at 08:00 MST
**Review Period:** Last 7 days

## Executive Summary
- Total Files Modified: 14
- Documentation Base: /home/dshannon/Documents/Claude
- Dashboard Status: Updated

## Recent Documentation Changes
| File | Last Modified | Size | Category |
|------|---------------|------|----------|
| `Artifacts/Unified_POAM.md` | 2025-11-17 11:53:56 | 16KiB | Artifact/Policy |
| `Final_Implementation_Status.md` | 2025-11-13 06:43:55 | 19KiB | Status Report |
...
```

### Dashboard Backups

Before updating the dashboard, the script creates a backup:
```
/home/dshannon/Documents/Claude/Archives/System_Status_Dashboard_YYYY-MM-DD_HH-MM-SS.html
```

Backups are retained indefinitely for audit purposes.

### Log Files

Activity logs are stored at:
```
/var/log/cyberhygiene/weekly-update.log
```

Log entries include:
- Timestamp of execution
- Files scanned and modified
- Errors or warnings
- Report generation status

---

## File Categorization

The script automatically categorizes documentation files:

| Category | Criteria | Examples |
|----------|----------|----------|
| **Artifact/Policy** | Files in Artifacts directory | Acceptable Use Policy, Incident Response Plan |
| **Compliance** | POAM, SPRS in filename | Unified_POAM.md, SPRS_Update_Guide.md |
| **Status Report** | "Implementation" or "Status" in filename | Implementation_Status_Report.md |
| **Operational Guide** | "Guide" or "Procedure" in filename | MFA_OTP_Configuration_Guide.md |
| **Documentation** | All other files | General documentation, notes, summaries |

---

## Maintenance and Troubleshooting

### Check Script Status

```bash
# Verify script is executable
ls -lh /home/dshannon/bin/cyberhygiene-weekly-update

# Test script execution
cyberhygiene-weekly-update --report-only --verbose

# Check recent logs
tail -f /var/log/cyberhygiene/weekly-update.log
```

### Common Issues

#### Script Not Found
```bash
# Ensure script is in PATH
echo $PATH

# Run with full path
/home/dshannon/bin/cyberhygiene-weekly-update
```

#### Permission Denied
```bash
# Make script executable
chmod +x /home/dshannon/bin/cyberhygiene-weekly-update

# Verify permissions
ls -lh /home/dshannon/bin/cyberhygiene-weekly-update
```

#### No Files Found
```bash
# Check documentation directory exists
ls -la /home/dshannon/Documents/Claude

# Run with longer time period
cyberhygiene-weekly-update --days 30 --verbose
```

#### Dashboard Not Updated
```bash
# Verify dashboard file exists
ls -lh /home/dshannon/Documents/Claude/Artifacts/System_Status_Dashboard.html

# Check permissions
ls -ld /home/dshannon/Documents/Claude/Artifacts/

# Run in report-only mode to test
cyberhygiene-weekly-update --report-only
```

### Log Rotation

To prevent log files from growing too large:

```bash
# Create logrotate configuration
sudo nano /etc/logrotate.d/cyberhygiene

# Add this configuration:
/var/log/cyberhygiene/*.log {
    weekly
    rotate 12
    compress
    delaycompress
    missingok
    notifempty
    create 0644 dshannon dshannon
}
```

---

## Integration with Compliance Workflow

### Weekly Review Process

1. **Monday Morning (Automated)**
   - Script runs via cron at 8:00 AM
   - Scans documentation for changes from previous week
   - Generates weekly update report
   - Updates System Status Dashboard

2. **Review Actions**
   - Review generated report in `/home/dshannon/Documents/Claude/Reports/`
   - Verify all documented changes are accurate
   - Update SPRS if compliance status changed
   - Notify stakeholders of significant changes

3. **Monthly Activities**
   - Review all weekly reports from the month
   - Archive old reports per retention policy
   - Update POAMs with progress
   - Generate monthly compliance summary

### NIST 800-171 Alignment

This system supports the following NIST 800-171 controls:

- **AC-2 (Account Management):** Tracks user management documentation changes
- **AU-2/AU-3 (Audit Events):** Maintains audit trail of documentation updates
- **AU-12 (Audit Generation):** Generates weekly audit reports
- **CM-3 (Configuration Change Control):** Documents system configuration changes
- **CM-6 (Configuration Settings):** Tracks configuration documentation updates
- **RA-5 (Vulnerability Scanning):** Documents scan results and remediation
- **SI-2 (Flaw Remediation):** Tracks security update documentation

---

## Security Considerations

### File Permissions

The script requires appropriate permissions:

```bash
# Script should be executable by owner
-rwx--x--x /home/dshannon/bin/cyberhygiene-weekly-update

# Documentation directory should be readable
drwxr-xr-x /home/dshannon/Documents/Claude

# Log directory may require sudo
drwxr-xr-x /var/log/cyberhygiene
```

### Backup Strategy

- Dashboard backups are created before each update
- Backups are stored in `/home/dshannon/Documents/Claude/Archives/`
- Retention: Backups are kept indefinitely for compliance audit
- Recovery: Restore from backup if needed

### Audit Trail

The system maintains a complete audit trail:
- All executions logged to `/var/log/cyberhygiene/weekly-update.log`
- Weekly reports archived in `/home/dshannon/Documents/Claude/Reports/`
- Dashboard backups in `/home/dshannon/Documents/Claude/Archives/`

---

## Advanced Configuration

### Customizing Scan Directories

Edit the script to change scan directories:

```bash
# Edit the script
nano /home/dshannon/bin/cyberhygiene-weekly-update

# Modify these variables near the top:
DOCS_DIR="/home/dshannon/Documents/Claude"
ARTIFACTS_DIR="${DOCS_DIR}/Artifacts"
DASHBOARD_FILE="${ARTIFACTS_DIR}/System_Status_Dashboard.html"
```

### Customizing File Types

To scan additional file types:

```bash
# Find this section in the script:
local modified_files=$(find "${DOCS_DIR}" -type f \
    \( -name "*.md" -o -name "*.html" -o -name "*.docx" \) \
    ...

# Add more file types:
local modified_files=$(find "${DOCS_DIR}" -type f \
    \( -name "*.md" -o -name "*.html" -o -name "*.docx" -o -name "*.pdf" -o -name "*.txt" \) \
    ...
```

### Excluding Directories

The script already excludes:
- `/Archives/*` - Backup archives
- `/.git/*` - Git repositories
- `/Downloads/*` - Download directory

To add more exclusions, edit the script:

```bash
! -path "*/YourDirectory/*" \
```

---

## Troubleshooting Guide

### Script Won't Execute

**Symptom:** `bash: cyberhygiene-weekly-update: command not found`

**Solution:**
```bash
# Check if ~/bin is in PATH
echo $PATH | grep -o "bin"

# Run with full path
/home/dshannon/bin/cyberhygiene-weekly-update

# Or add to PATH in ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### No Files Detected

**Symptom:** Report shows "0 files modified"

**Solution:**
```bash
# Increase time window
cyberhygiene-weekly-update --days 30

# Check if files exist
find /home/dshannon/Documents/Claude -type f -name "*.md" -mtime -7

# Verify documentation directory
ls -la /home/dshannon/Documents/Claude
```

### Dashboard Not Updated

**Symptom:** Dashboard still shows old "Last Updated" date

**Solution:**
```bash
# Check file permissions
ls -lh /home/dshannon/Documents/Claude/Artifacts/System_Status_Dashboard.html

# Try running without report-only mode
cyberhygiene-weekly-update --verbose

# Check for errors in log
tail -n 50 /var/log/cyberhygiene/weekly-update.log
```

### Cron Job Not Running

**Symptom:** No reports being generated automatically

**Solution:**
```bash
# Verify cron service
sudo systemctl status crond

# Check crontab
crontab -l

# Check cron logs
grep cyberhygiene /var/log/cron

# Test manual execution
/home/dshannon/bin/cyberhygiene-weekly-update --verbose
```

---

## Best Practices

### Weekly Review Workflow

1. **Automated Execution (Monday 8:00 AM)**
   - Let the script run automatically via cron
   - Check email for any error notifications

2. **Manual Review (Monday 9:00 AM)**
   ```bash
   # View the latest report
   cd /home/dshannon/Documents/Claude/Reports
   ls -lt | head -5
   # Open and review the latest report
   ```

3. **Stakeholder Communication**
   - Email summary of significant changes to team
   - Update project management tools if needed
   - Schedule meetings for critical updates

4. **Compliance Actions**
   - Update SPRS if security controls changed
   - Modify POAMs based on implementation progress
   - Document any new risks or findings

### Monthly Activities

```bash
# Generate comprehensive monthly report
cyberhygiene-weekly-update --days 30 --verbose

# Archive old reports (older than 90 days)
find /home/dshannon/Documents/Claude/Reports -name "Weekly_Update*.md" -mtime +90 -exec mv {} /home/dshannon/Documents/Claude/Archives/ \;

# Review all weekly reports
ls -lth /home/dshannon/Documents/Claude/Reports/Weekly_Update*.md | head -4
```

### Quarterly Compliance Review

1. Run comprehensive scan: `cyberhygiene-weekly-update --days 90`
2. Review all documentation categories
3. Verify POAMs are up to date
4. Update System Security Plan (SSP)
5. Run OpenSCAP compliance scan
6. Generate SPRS submission

---

## Support and Maintenance

### Getting Help

```bash
# View help
cyberhygiene-weekly-update --help

# Check logs for errors
tail -f /var/log/cyberhygiene/weekly-update.log

# Review recent reports
ls -lth /home/dshannon/Documents/Claude/Reports/ | head -5
```

### Script Updates

The script is located at:
```
/home/dshannon/bin/cyberhygiene-weekly-update
```

To modify or update:
```bash
# Backup current version
cp /home/dshannon/bin/cyberhygiene-weekly-update /home/dshannon/bin/cyberhygiene-weekly-update.backup

# Edit script
nano /home/dshannon/bin/cyberhygiene-weekly-update

# Test changes
/home/dshannon/bin/cyberhygiene-weekly-update --report-only --verbose
```

### Version Control

Consider adding the script to version control:
```bash
cd /home/dshannon/bin
git init
git add cyberhygiene-weekly-update
git commit -m "Initial version of weekly update script"
```

---

## Appendix

### Complete Cron Setup Example

```bash
# Edit crontab
crontab -e

# Add these lines:

# Email notifications
MAILTO=admin@cyberinabox.net

# Run weekly update every Monday at 8:00 AM
0 8 * * 1 /home/dshannon/bin/cyberhygiene-weekly-update

# Optional: Run monthly comprehensive review on 1st of month
0 9 1 * * /home/dshannon/bin/cyberhygiene-weekly-update --days 30
```

### Quick Reference Commands

```bash
# Run weekly update
cyberhygiene-weekly-update

# Run with verbose output
cyberhygiene-weekly-update -v

# Generate report only (no dashboard update)
cyberhygiene-weekly-update --report-only

# Review last 30 days
cyberhygiene-weekly-update --days 30

# View latest report
ls -lt /home/dshannon/Documents/Claude/Reports/ | head -2

# Check logs
tail -50 /var/log/cyberhygiene/weekly-update.log

# List cron jobs
crontab -l

# Test cron job manually
/home/dshannon/bin/cyberhygiene-weekly-update
```

### File Locations Reference

| Item | Location |
|------|----------|
| Script | `/home/dshannon/bin/cyberhygiene-weekly-update` |
| Documentation | `/home/dshannon/Documents/Claude/` |
| Dashboard | `/home/dshannon/Documents/Claude/Artifacts/System_Status_Dashboard.html` |
| Reports & Guide | `/home/dshannon/Documents/Claude/Reports/` |
| Backups | `/home/dshannon/Documents/Claude/Archives/` |
| Logs | `/var/log/cyberhygiene/weekly-update.log` |

---

## Changelog

### Version 1.0 (2025-11-19)
- Initial release
- Automated documentation scanning
- Dashboard update functionality
- Weekly report generation
- Cron integration
- Comprehensive logging
- File categorization
- Backup management

---

**Document Information:**
- **Filename:** CyberHygiene_Weekly_Update_Guide.md
- **Location:** /home/dshannon/Documents/Claude/Reports/
- **Created:** 2025-11-19
- **System:** cyberinabox.net
- **Classification:** Internal Use - NIST 800-171 Documentation
