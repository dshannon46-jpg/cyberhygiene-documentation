# How to Use Your SPRS Assessment Files

**Created:** October 26, 2025  
**Purpose:** Guide to understanding and using your SPRS self-assessment

---

## 📦 What You Received

You now have a complete SPRS (Supplier Performance Risk System) self-assessment package:

1. **SPRS_Self_Assessment.txt** - Tab-delimited detailed assessment (Excel-ready)
2. **SPRS_Summary_Report.md** - Executive summary with action plans
3. This guide - How to use the files

---

## 📊 Your Current Score

**SPRS Score: 29 points out of 110 possible**

**What this means:**
- ⚠️ Below acceptable threshold for most DoD contracts
- ✅ Strong technical foundation (75% implemented)
- 🔄 Main gaps are documentation, not technical
- 🎯 Can reach 70+ points in 60 days

---

## 💻 How to Import into Excel

### Step 1: Open the Tab-Delimited File

**Option A: Import into Excel**
```
1. Open Excel (or LibreOffice Calc)
2. File → Open
3. Select: SPRS_Self_Assessment.txt
4. Choose delimiter: Tab
5. Click Finish
```

**Option B: Copy/Paste**
```
1. Open SPRS_Self_Assessment.txt in a text editor
2. Select All (Ctrl+A)
3. Copy (Ctrl+C)
4. Open Excel
5. Paste (Ctrl+V) into cell A1
6. Excel will auto-detect the tabs
```

### Step 2: Format the Spreadsheet

```
1. Select row 1 (headers)
2. Format → Bold
3. Format → Fill color (light blue or gray)
4. Format → Freeze top row
5. Autofit column widths
```

### Step 3: Add Filtering

```
1. Select header row
2. Data → Filter (or AutoFilter)
3. Now you can filter by:
   - Implementation Status
   - Score (positive, negative, zero)
   - Control Family (AC, AT, AU, etc.)
```

---

## 📈 Understanding the Columns

| Column | Description | Values |
|--------|-------------|---------|
| **Control_ID** | NIST 800-171 control identifier | AC-1, AU-2, etc. |
| **Control_Name** | Full control name | "Account Management" |
| **NIST_Weight** | Point value (1, 3, or 5) | Higher = more critical |
| **Implementation_Status** | Current status | Implemented, Partial, Not Implemented, N/A |
| **Score** | Points for this control | +1 to +5, or negative |
| **Evidence** | What supports the score | FreeIPA config, logs, etc. |
| **Notes** | Additional context | Gaps, plans, dependencies |

---

## 🎯 Using the Assessment for Action Planning

### Step 1: Identify Quick Wins (Filter for easy improvements)

**In Excel:**
1. Filter "Score" column for "-1" (worth 1 point each)
2. Filter "Notes" for "Need to" (indicates action needed)
3. Look for "document" or "policy" (easier than technical)

**Quick Wins:**
- AC-8: Add login banner (1 point, 10 minutes)
- PS-1: Create personnel security policy (1 point, 2 hours)
- MP-1: Create media protection policy (1 point, 2 hours)
- PE-1: Document physical security (1 point, 1 hour)

### Step 2: Prioritize Critical Gaps (Filter for high-value items)

**In Excel:**
1. Filter "NIST_Weight" for "3" (worth 3 points each)
2. Filter "Score" for negative values
3. Sort by Score (most negative first)

**Critical Gaps:**
- AT-2: Security awareness training (-3 points) ⭐
- IR-8: Incident response plan (-3 points) ⭐
- PS-3: Personnel screening (-3 points) ⭐
- MP-6: Media sanitization (-3 points) ⭐

### Step 3: Track Your Progress

**Create a tracking sheet:**
1. Copy the assessment to a new tab ("Baseline")
2. Create another tab ("Current")
3. Update "Current" as you implement controls
4. Compare scores to see progress

**Formula for total score:**
```excel
=SUMIF(E:E,">0",E:E) + SUMIF(E:E,"<0",E:E)
```
(Sums positive scores and negative scores)

---

## 📋 Using the Summary Report

The **SPRS_Summary_Report.md** provides:

### Section 1: Overall Score
- Your current 29-point score
- What it means for contracts
- Comparison to industry benchmarks

### Section 2: Score by Control Family
- 14 control families (AC, AT, AU, etc.)
- Score for each family
- Identifies strong and weak areas

### Section 3: Strength Areas
- What you're doing well
- Controls with high scores
- Evidence of good implementation

### Section 4: Critical Gaps
- What needs immediate attention
- Impact and effort estimates
- Priority ranking

### Section 5: Action Plans
- 30-day plan: 29 → 55 points
- 60-day plan: 55 → 70 points  
- 90-day plan: 70 → 80+ points
- Specific actions for each milestone

### Section 6: Contract Impact
- What your score means for eligibility
- How score affects contract bidding
- Timeline to competitive position

---

## 🎯 Recommended Workflow

### Week 1: Assessment Review

**Day 1-2: Understand Your Score**
```
1. Read the Summary Report (Section 1-2)
2. Review the detailed assessment in Excel
3. Filter for "Not Implemented" controls
4. Identify your top 5 gaps
```

**Day 3-4: Validate the Assessment**
```
1. Review each "Not Implemented" control
2. Confirm you truly haven't implemented it
3. Adjust scores if you find implemented controls
4. Document any evidence you have
```

**Day 5-7: Create Action Plan**
```
1. Read the 30-day action plan (Summary Report Section 5)
2. Prioritize based on effort vs. impact
3. Assign responsibilities
4. Set deadlines
```

### Week 2-4: Execute Quick Wins

Follow the 30-day action plan from the Summary Report:

**Week 2: Policies (+9 points)**
- Create Personnel Security Policy
- Create Media Protection Policy
- Document Physical Security

**Week 3: Critical Gaps (+12 points)**
- Develop Incident Response Plan
- Create Security Training Policy
- Conduct Initial Risk Assessment

**Week 4: Implementation (+5 points)**
- Configure session locks
- Add login banners
- Create required forms

### Monthly: Update Assessment

**On the 26th of each month:**
1. Open your Excel assessment
2. Update "Implementation_Status" for completed items
3. Recalculate total score
4. Update the Summary Report
5. Report progress to management

---

## 📊 Creating Management Reports

### Quick Status Dashboard

**What to Show Management:**
1. **Current Score:** 29 / 110 points
2. **Target Score:** 70+ points (good standing)
3. **Timeline:** 60 days to reach target
4. **Top 3 Gaps:** Training, Incident Response, Personnel Security
5. **Investment Needed:** Primarily time (80-120 hours)

### Progress Tracking

**Weekly Status:**
```
Week of: [Date]
Starting Score: 29
Current Score: [Updated]
Points Gained: [Difference]
Controls Completed: [Number]
On Track: Yes/No
Blockers: [Any issues]
```

### Contract Eligibility Report

**For Business Development:**
```
Current Status:
- SPRS Score: 29 (Not eligible for most DoD contracts)
- Technical Implementation: 75% complete
- Documentation: 35% complete

60-Day Projection:
- SPRS Score: 70+ (Eligible for most DoD contracts)
- Timeline: Dec 25, 2025
- Investment: 80 hours staff time + $500

Impact:
- Can compete for DoD contracts worth $XXX
- Protects existing contracts worth $XXX
- Demonstrates compliance maturity
```

---

## 🔄 Updating Your Score

### When You Complete a Control

**In Excel:**
1. Find the control row (e.g., IR-8: Incident Response Plan)
2. Change "Implementation_Status" from "Not Implemented" to "Implemented"
3. Change "Score" from "-3" to "+3"
4. Update "Evidence" with proof (e.g., "IR Plan v1.0, approved 11/15/25")
5. Update "Notes" with completion date

**Recalculate Total:**
```excel
New Total = Old Score + 2 × (Point Value)

Example: IR-8 worth 3 points
Old: -3 (not implemented)
New: +3 (implemented)
Improvement: +6 points total
```

### Quarterly Re-Assessment

**Every 3 months:**
1. Review ALL controls again
2. Verify evidence still exists
3. Check for any regressions
4. Update documentation
5. Submit new SPRS score (if required)

---

## 📤 Submitting to SPRS (If Required)

### When to Submit

**SPRS submission required if:**
- You're a DoD contractor
- Your contract includes DFARS 252.204-7012
- You're bidding on new DoD contracts
- Requested by contracting officer

### How to Submit

**Process:**
1. Go to: https://www.sprs.csd.disa.mil
2. Register if first time
3. Upload your assessment (can use Excel file)
4. Submit your score (29 points currently)
5. Include your POA&M for gaps

**What to Include:**
- Your current SPRS score (29)
- Date of assessment (Oct 26, 2025)
- POA&M with completion dates
- Evidence of implementation
- Remediation timeline (60-90 days)

### POA&M Requirements

**For each gap, include:**
- Control ID (e.g., AT-2)
- Description of gap
- Scheduled completion date
- Resources required
- Milestone dates
- Status updates

*See your SPRS Summary Report Section 4 for POA&M details*

---

## 💡 Tips for Success

### Do's ✅

- **Update regularly:** Track progress weekly
- **Be honest:** Don't inflate scores
- **Document everything:** Evidence is critical
- **Focus on high-value:** Prioritize 3-point controls
- **Get management buy-in:** Need resources and time
- **Celebrate milestones:** Acknowledge progress

### Don'ts ❌

- **Don't exaggerate:** Inflated scores hurt during audits
- **Don't ignore evidence:** "Implemented" needs proof
- **Don't skip documentation:** Even if technically implemented
- **Don't work in isolation:** Involve team members
- **Don't forget maintenance:** Scores can regress
- **Don't delay critical gaps:** Training and IR are required

---

## 🆘 Getting Help

### If You're Stuck

**Internal Resources:**
- Use the compliance checklist to track tasks
- Reference the SSP template for structure
- Follow the documentation guide for policies

**External Resources:**
- NIST 800-171 guidance: https://csrc.nist.gov/publications/detail/sp/800-171/rev-2/final
- SPRS user guide: https://www.sprs.csd.disa.mil
- DIB Cybersecurity: https://dibnet.dod.mil

**Professional Help:**
- Consider gap assessment after 60 days ($3-5k)
- CMMC consultant for assessment prep
- Cybersecurity attorney for contract questions

### If Scores Don't Match Reality

**Common Issues:**
1. **Score too low:** Check if you missed implemented controls
2. **Score too high:** Verify you have actual evidence
3. **Partial credit:** Conservative scoring is safer
4. **Interpretation:** Some controls have multiple valid interpretations

**Solution:** When in doubt, score conservatively and document why

---

## 🎯 Success Criteria

You'll know you're successful when:

- ✅ SPRS score reaches 70+ points
- ✅ All critical gaps closed (training, IR, personnel, media)
- ✅ Evidence documented for all "Implemented" controls
- ✅ POA&M has realistic dates for remaining gaps
- ✅ Management understands and supports plan
- ✅ Can demonstrate progress to customers/auditors
- ✅ Eligible to compete for DoD contracts

**Timeline:** 60-90 days from today (Dec 25, 2025 - Jan 24, 2026)

---

## 📞 Questions?

**About the Assessment:**
- Review the detailed notes in the Excel file
- Check the Summary Report for explanations
- Ask me (Claude) for clarification!

**About SPRS Submission:**
- Contact your contracting officer
- Check SPRS website: https://www.sprs.csd.disa.mil
- Review DFARS 252.204-7012 requirements

**About Improvement:**
- Follow the 60-day action plan
- Use the compliance checklist
- Track progress weekly

---

**Good luck with your compliance journey!**  
**You have a strong foundation - now document it!** 💪

---

**Guide Version:** 1.0  
**Last Updated:** October 26, 2025  
**Next Review:** Monthly as you update scores
