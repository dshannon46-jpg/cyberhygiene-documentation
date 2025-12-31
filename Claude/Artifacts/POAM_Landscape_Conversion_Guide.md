# POAM Landscape Conversion Guide

**Purpose:** Instructions for converting Unified_POAM.md to landscape-oriented Word document
**Date:** November 19, 2025

---

## Method 1: Using Pandoc (Command Line)

If you have Pandoc installed, you can convert the markdown to Word with landscape orientation:

```bash
cd /home/dshannon/Documents/Claude/Artifacts/

pandoc Unified_POAM.md \
  -o Unified_POAM.docx \
  --reference-doc=/path/to/landscape-template.docx
```

**Note:** You'll need to create a landscape-template.docx file first with landscape orientation set.

---

## Method 2: Manual Conversion in LibreOffice/Word

### Step 1: Open the Markdown File
```bash
libreoffice --writer Unified_POAM.md
```
or open the existing `Unified_POAM.docx` in Word/LibreOffice

### Step 2: Change Page Orientation to Landscape

**In LibreOffice Writer:**
1. Go to **Format** → **Page Style** (or **Format** → **Page**)
2. Click the **Page** tab
3. Under **Orientation**, select **Landscape**
4. Click **OK**

**In Microsoft Word:**
1. Go to **Layout** tab (or **Page Layout**)
2. Click **Orientation**
3. Select **Landscape**

### Step 3: Adjust Margins (Recommended)
Set margins to:
- **Top:** 0.5"
- **Bottom:** 0.5"
- **Left:** 0.75"
- **Right:** 0.75"

This maximizes table display space.

### Step 4: Adjust Table Formatting
1. Select all tables (Ctrl+A, then filter to tables)
2. Right-click → **Table Properties**
3. Set **Preferred width** to **100%** or adjust column widths
4. Ensure **AutoFit** is enabled for better readability

### Step 5: Save
Save as `.docx` format with landscape orientation preserved.

---

## Method 3: Using Online Markdown to Word Converter

1. Go to an online converter (e.g., cloudconvert.com, convertio.co)
2. Upload `Unified_POAM.md`
3. Convert to .docx
4. Download and open in Word/LibreOffice
5. Change orientation to landscape (see Method 2, Step 2)

---

## Recommended Settings for POAM Document

### Page Setup
- **Size:** Letter (8.5" x 11")
- **Orientation:** Landscape (11" x 8.5")
- **Margins:** 0.5" (top/bottom), 0.75" (left/right)

### Font Settings
- **Headings:** Arial or Calibri, 14pt bold
- **Body Text:** Arial or Calibri, 11pt
- **Tables:** Arial or Calibri, 10pt

### Table Settings
- **Border:** All cells with thin borders
- **Header Row:** Bold, shaded background (light blue or gray)
- **Alternate Row Shading:** Light gray for better readability
- **Column Width:** Auto-fit to content

---

## Quick Fix for Existing Unified_POAM.docx

If you already have a `Unified_POAM.docx` file:

```bash
# Open the file
libreoffice --writer /home/dshannon/Documents/Claude/Artifacts/Unified_POAM.docx

# Then manually:
# 1. Format → Page → Page tab → Orientation: Landscape
# 2. Format → Page → Page tab → Margins: 0.5" top/bottom, 0.75" left/right
# 3. File → Save
```

Or in Microsoft Word:
1. Open file
2. Layout → Orientation → Landscape
3. Layout → Margins → Custom Margins (0.5" top/bottom, 0.75" left/right)
4. File → Save

---

## Verification Checklist

After conversion, verify:
- [ ] All pages are in landscape orientation
- [ ] Tables fit within page width without horizontal scrolling
- [ ] No text is cut off
- [ ] Headers and footers display correctly
- [ ] Page numbers are centered at bottom
- [ ] Document metadata (title, author, date) is correct
- [ ] Classification marking ("CUI") appears on each page

---

## Automation Script (Optional)

Create a bash script to automate conversion:

```bash
#!/bin/bash
# convert-poam-landscape.sh

INPUT="/home/dshannon/Documents/Claude/Artifacts/Unified_POAM.md"
OUTPUT="/home/dshannon/Documents/Claude/Artifacts/Unified_POAM.docx"

# Convert with pandoc (if installed)
if command -v pandoc &> /dev/null; then
    pandoc "$INPUT" -o "$OUTPUT" \
        --reference-doc=landscape-template.docx \
        --metadata title="PLAN OF ACTION & MILESTONES (POA&M)"
    echo "Conversion complete: $OUTPUT"
else
    echo "Pandoc not installed. Use manual method."
fi
```

---

## Notes

- The markdown file (`Unified_POAM.md`) now includes notes specifying landscape orientation
- Tables in the POAM are wide and benefit significantly from landscape layout
- The Document Control section specifies "Landscape orientation (11" x 8.5")"
- When printing or exporting to PDF, ensure landscape orientation is maintained

---

**Last Updated:** November 19, 2025
