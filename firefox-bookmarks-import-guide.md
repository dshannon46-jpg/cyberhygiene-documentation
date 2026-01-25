# Firefox Bookmarks Import Guide

**Date:** 2026-01-10 (Updated: 2026-01-11)
**Bookmarks Files:**
- DC1 Websites: `/home/dshannon/Documents/dc1-bookmarks.html`
- iLO Management: `/home/dshannon/Documents/ilo-bookmarks.html`
**Backup File:** `/home/dshannon/Documents/firefox-places-backup-20260110.sqlite`

## Overview

Created a comprehensive bookmark collection for all DC1 websites, dashboards, and management interfaces organized into logical categories for easy access.

**Update 2026-01-11:** Added iLO5 management interface bookmarks for out-of-band server management.

## Bookmark Organization

The bookmarks are organized in a folder structure:

```
DC1 Websites & Dashboards/
├── Main Website/
│   ├── CyberHygiene Project
│   └── Control Center (Switchboard)
├── Dashboards/
│   ├── AI System Administration Dashboard
│   ├── CPM Dashboard
│   ├── Workstation Monitoring Dashboard
│   ├── System Status Dashboard
│   └── DC1 CPM Dashboard
├── Documentation & Policies/
│   ├── Policy Index (uppercase)
│   └── Policy Index (lowercase)
└── Web Applications/
    ├── Grafana - Metrics & Analytics
    ├── Redmine - Project Management
    ├── Roundcube Webmail
    ├── FreeIPA - Identity Management
    └── Nextcloud - File Sharing

iLO Management Interfaces/
├── dc1 iLO5 Management (192.168.1.129)
└── LabRat iLO5 Management (192.168.1.130)
```

## Import Instructions

### Method 1: Import via Firefox Library (Recommended)

1. **Open Firefox Library**
   - Press `Ctrl+Shift+B` (or `Cmd+Shift+B` on Mac)
   - Or click Menu (≡) → Bookmarks → Manage Bookmarks

2. **Import the Bookmarks**
   - Click "Import and Backup" in the toolbar
   - Select "Import Bookmarks from HTML..."
   - Navigate to `/home/dshannon/Documents/dc1-bookmarks.html`
   - Click "Open"

3. **Result**
   - All bookmarks will be imported under "Bookmarks Menu"
   - Look for the folder "DC1 Websites & Dashboards"

### Method 2: Command Line Import

```bash
# Close Firefox first
killall firefox

# Copy the bookmarks file to Firefox bookmarkbackups directory
cp /home/dshannon/Documents/dc1-bookmarks.html \
   ~/.mozilla/firefox/3ulrwtwf.default-default/bookmarkbackups/bookmarks-$(date +%Y-%m-%d).html

# Restart Firefox
```

## Backup Information

### Current Backup
- **Location:** `/home/dshannon/Documents/firefox-places-backup-20260110.sqlite`
- **Date:** 2026-01-10
- **Purpose:** Safety backup before adding new bookmarks

### Restoring from Backup (If Needed)

If you need to restore your original bookmarks:

1. **Close Firefox completely**
   ```bash
   killall firefox
   ```

2. **Restore the backup**
   ```bash
   cp /home/dshannon/Documents/firefox-places-backup-20260110.sqlite \
      ~/.mozilla/firefox/3ulrwtwf.default-default/places.sqlite
   ```

3. **Restart Firefox**

## Bookmark Contents

### Total Links: 16 (14 websites + 2 iLO management interfaces)

1. **Main Website (2)**
   - CyberHygiene Project: https://cyberinabox.net/
   - Control Center: https://cyberinabox.net/switchboard.html

2. **Dashboards (5)**
   - AI Dashboard: https://cyberinabox.net/ai-dashboard.html
   - CPM Dashboard: https://cyberinabox.net/cpm-dashboard.html
   - Monitoring Dashboard: https://cyberinabox.net/monitoring-dashboard.html
   - System Status: https://cyberinabox.net/System_Status_Dashboard.html
   - DC1 CPM: https://dc1.cyberinabox.net/dashboard

3. **Documentation (2)**
   - Policy Index: https://cyberinabox.net/Policy_Index.html
   - Policy Index: https://cyberinabox.net/policy-index.html

4. **Web Applications (5)**
   - Grafana: https://grafana.cyberinabox.net
   - Redmine: https://projects.cyberinabox.net
   - Webmail: https://webmail.cyberinabox.net
   - FreeIPA: https://dc1.cyberinabox.net/ipa
   - Nextcloud: https://dc1.cyberinabox.net/nextcloud

5. **iLO Management Interfaces (2)** *(Added 2026-01-11)*
   - dc1 iLO5 Management: https://192.168.1.129
   - LabRat iLO5 Management: https://192.168.1.130

## Organizing After Import

After importing, you can:

1. **Move to Bookmarks Toolbar**
   - Drag the "DC1 Websites & Dashboards" folder to your Bookmarks Toolbar for quick access

2. **Create Shortcuts**
   - Right-click any bookmark → "Add to Bookmarks Toolbar"

3. **Add Keywords**
   - Right-click a bookmark → Properties
   - Add a keyword (e.g., "ai" for AI Dashboard)
   - Type the keyword in address bar to go directly to the site

## Verification

After importing, verify the bookmarks:

1. Open Firefox Library (`Ctrl+Shift+B`)
2. Expand "Bookmarks Menu"
3. Look for "DC1 Websites & Dashboards" folder (14 links)
4. Look for "iLO Management Interfaces" folder (2 links)
5. Verify all 16 total links are present

## Files Created

- **DC1 Bookmarks:** `/home/dshannon/Documents/dc1-bookmarks.html` (2.5KB)
- **iLO Bookmarks:** `/home/dshannon/Documents/ilo-bookmarks.html` (571 bytes)
- **Backup:** `/home/dshannon/Documents/firefox-places-backup-20260110.sqlite` (5.0MB)
- **This Guide:** `/home/dshannon/Documents/firefox-bookmarks-import-guide.md`

## Related Documentation

- **Website Inventory:** `/home/dshannon/Documents/dc1-hosted-websites.md`
- **Firefox Profile:** `~/.mozilla/firefox/3ulrwtwf.default-default/`

## Notes

- The bookmarks file uses the Netscape Bookmark File Format, compatible with all modern browsers
- All bookmarks use HTTPS for secure connections
- Some dashboards may require authentication (FreeIPA, Grafana, etc.)
- The backup is a complete snapshot of your Firefox bookmarks database

## Troubleshooting

### Import Doesn't Show Up
- Check that Firefox is fully closed before importing
- Look in "Bookmarks Menu" or "Other Bookmarks" folders

### Bookmarks Already Exist
- Firefox will import without checking for duplicates
- You can manually remove duplicate bookmarks after import

### Restore Not Working
- Ensure Firefox is completely closed (`killall firefox`)
- Check file permissions: `ls -l /home/dshannon/Documents/firefox-places-backup-20260110.sqlite`

## Contact

**Administrator:** don@contract-coach.com
**Server:** dc1.cyberinabox.net
**Created:** 2026-01-10
