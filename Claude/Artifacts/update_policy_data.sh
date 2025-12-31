#!/bin/bash
# Extract current policy and POA&M data for dynamic index

POAM_FILE="/home/dshannon/Documents/Claude/Artifacts/Unified_POAM.md"
SSP_FILE="/home/dshannon/Documents/Claude/Artifacts/System_Security_Plan_v1.5.docx"

# Extract POA&M statistics
POAM_VERSION=$(grep "^\*\*Version:\*\*" "$POAM_FILE" | head -1 | sed 's/.*Version:\*\* //' | sed 's/ .*//')
POAM_DATE=$(grep "^.*Updated: " "$POAM_FILE" | head -1 | sed 's/.*Updated: //' | sed 's/).*//')
POAM_COMPLETED=$(grep "^\*\*Completed:\*\*" "$POAM_FILE" | head -1 | sed 's/.*Completed:\*\* //' | sed 's/ .*//')
POAM_PERCENT=$(grep "^\*\*Completed:\*\*" "$POAM_FILE" | head -1 | sed 's/.*(//' | sed 's/).*//')
POAM_IN_PROGRESS=$(grep "^\*\*In Progress:\*\*" "$POAM_FILE" | head -1 | sed 's/.*Progress:\*\* //' | sed 's/ .*//')
POAM_ON_TRACK=$(grep "^\*\*On Track:\*\*" "$POAM_FILE" | head -1 | sed 's/.*Track:\*\* //' | sed 's/ .*//')
POAM_PLANNED=$(grep "^\*\*Planned:\*\*" "$POAM_FILE" | head -1 | sed 's/.*Planned:\*\* //' | sed 's/ .*//')

# Calculate total items
POAM_TOTAL=$((POAM_COMPLETED + POAM_IN_PROGRESS + POAM_ON_TRACK + POAM_PLANNED))

# Get SSP version and date
SSP_VERSION="1.5"
SSP_DATE="December 2, 2025"

# Current date
CURRENT_DATE=$(date "+%B %d, %Y")

# Generate JSON
cat > /home/dshannon/Documents/Claude/Artifacts/policy_data.json << JSONEOF
{
  "lastUpdated": "$CURRENT_DATE",
  "ssp": {
    "version": "$SSP_VERSION",
    "date": "$SSP_DATE",
    "implementation": "99%"
  },
  "poam": {
    "version": "$POAM_VERSION",
    "date": "$POAM_DATE",
    "total": $POAM_TOTAL,
    "completed": $POAM_COMPLETED,
    "inProgress": $POAM_IN_PROGRESS,
    "onTrack": $POAM_ON_TRACK,
    "planned": $POAM_PLANNED,
    "completionPercent": "$POAM_PERCENT"
  }
}
JSONEOF

echo "Policy data extracted to policy_data.json"
cat /home/dshannon/Documents/Claude/Artifacts/policy_data.json
