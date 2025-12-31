# Policy Index - Dynamic Data Updates

## Overview

The Policy Index (Policy_Index.html) now includes dynamic data loading capabilities. It automatically reads current statistics from `policy_data.json` to display up-to-date information about the System Security Plan (SSP) and Plan of Action & Milestones (POA&M).

## How It Works

1. **Static Baseline:** The HTML file contains current data as a baseline (works without JavaScript)
2. **Dynamic Updates:** When opened in a browser, JavaScript fetches `policy_data.json` and updates all data elements
3. **Auto-Refresh:** Data automatically refreshes every 5 minutes while the page is open
4. **Graceful Degradation:** If JSON file is not found, the static baseline data is displayed

## Updating the Data

### Manual Update

Run the extraction script to update `policy_data.json`:

```bash
cd /home/dshannon/Documents/Claude/Artifacts
./update_policy_data.sh
```

This script:
- Extracts current statistics from `Unified_POAM.md`
- Reads SSP version information
- Generates updated `policy_data.json`

### Automatic Updates

**Option 1: Cron Job (Recommended for server deployment)**

Add to crontab to update daily at 8 AM:

```bash
0 8 * * * /home/dshannon/Documents/Claude/Artifacts/update_policy_data.sh
```

**Option 2: Manual Updates**

Update whenever you modify the POA&M:

```bash
# After updating Unified_POAM.md
cd /home/dshannon/Documents/Claude/Artifacts
./update_policy_data.sh
```

## Data Sources

The update script extracts data from:

1. **Unified_POAM.md**
   - Version number
   - Last updated date
   - Completed items count
   - In Progress items count
   - On Track items count
   - Planned items count
   - Total items and completion percentage

2. **System_Security_Plan_v1.5.docx** (metadata only)
   - Version number
   - Date
   - Implementation status

## Dynamic Elements

The following elements update automatically:

### Header
- `lastUpdated` - Last index update date

### SSP Card
- `sspVersionBadge` - SSP version number
- `sspDate` - SSP publication date
- `sspImplementation` - Implementation percentage

### POA&M Card
- `poamVersionBadge` - POA&M version number
- `poamCompleteBadge` - Completion percentage
- `poamTotalBadge` - Total items count
- `poamInProgressBadge` - In progress count
- `poamPlannedBadge` - Planned count
- `poamDate` - Last POA&M update date
- `poamComplete` - Complete statistics
- `poamDescription` - Full description with current counts

### Other Locations
- `poamHighlightStats` - SSP highlights section
- `quickAccessPoam` - Quick access section
- `footerLastUpdated` - Footer last updated
- `footerPoamStatus` - Footer POA&M status

## JSON Data Format

```json
{
  "lastUpdated": "December 23, 2025",
  "ssp": {
    "version": "1.5",
    "date": "December 2, 2025",
    "implementation": "99%"
  },
  "poam": {
    "version": "2.4",
    "date": "December 17, 2025",
    "total": 34,
    "completed": 30,
    "inProgress": 1,
    "onTrack": 1,
    "planned": 2,
    "completionPercent": "88%"
  }
}
```

## Deployment

### Local File System

1. Keep `Policy_Index.html` and `policy_data.json` in the same directory
2. Open `Policy_Index.html` in a web browser
3. Data will load automatically

### Web Server Deployment

1. Copy both files to web server directory:
   ```bash
   cp Policy_Index.html policy_data.json /var/www/html/policies/
   ```

2. Set up cron job on server to auto-update:
   ```bash
   0 8 * * * /path/to/update_policy_data.sh
   ```

3. Access via web URL:
   ```
   https://cyberinabox.net/policies/Policy_Index.html
   ```

## Troubleshooting

### Data Not Updating

**Check browser console:**
- Open Developer Tools (F12)
- Look for JavaScript errors or fetch errors

**Verify JSON file:**
```bash
cat /home/dshannon/Documents/Claude/Artifacts/policy_data.json
```

**Test JSON validity:**
```bash
python3 -m json.tool policy_data.json
```

### Update Script Fails

**Check POA&M file location:**
```bash
ls -l /home/dshannon/Documents/Claude/Artifacts/Unified_POAM.md
```

**Run script with error output:**
```bash
bash -x ./update_policy_data.sh
```

## Version History

- **v1.0 (2025-12-23):** Initial implementation with dynamic loading
  - Added JavaScript data loading
  - Created extraction script
  - Updated all data to current status (SSP v1.5, POA&M v2.4)

## Maintenance

To keep the Policy Index current:

1. **After POA&M Updates:** Run `./update_policy_data.sh`
2. **After SSP Updates:** Update version in script if needed
3. **Monthly:** Review and verify all data accuracy
4. **Quarterly:** Update static baseline in HTML if automation fails

## Security Notes

- **Classification:** This is CUI-marked documentation
- **Access Control:** Restrict to authorized personnel only
- **Storage:** Must be on encrypted partition
- **Distribution:** Internal use only, not for public web servers

## Contact

For questions or issues:
- **ISSO:** Donald E. Shannon
- **Email:** Don@contractcoach.com
- **Phone:** 505.259.8485
