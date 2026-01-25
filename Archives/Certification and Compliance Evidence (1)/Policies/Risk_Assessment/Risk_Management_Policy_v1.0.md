# Risk Management Policy and Procedures

**Document ID:** TCC-RA-001
**Version:** 1.0
**Effective Date:** November 2, 2025
**Review Schedule:** Annually or upon significant changes
**Next Review:** November 2, 2026
**Owner:** Donald E. Shannon, ISSO/System Owner
**Distribution:** Authorized personnel only
**Classification:** Controlled Unclassified Information (CUI)

---

## 1. Risk Management Policy

### Purpose

This policy establishes a structured framework for identifying, assessing, prioritizing, responding to, and monitoring risks to The Contract Coach's CyberHygiene Production Network (CPN) and associated operations. It ensures the protection of Controlled Unclassified Information (CUI) and Federal Contract Information (FCI) by integrating risk management into daily activities, aligning with NIST SP 800-171 Revision 2 (RA-1 through RA-9) and supporting CMMC Level 2 requirements. The policy minimizes threats to core functions such as proposal development, contract administration, and client communications, while leveraging existing tools like Wazuh SIEM for vulnerability detection and OpenSCAP for configuration assessments.

### Scope

This policy applies to all CPN assets and personnel involved in handling CUI/FCI, including:

**Systems:**
- **Domain controller:** dc1.cyberinabox.net (192.168.1.10)
  - FreeIPA domain services
  - Wazuh Manager (SIEM and security monitoring)
  - Samba file server with encrypted RAID 5 array
  - Centralized rsyslog server

- **Workstations:**
  - LabRat (192.168.1.115)
  - Engineering (192.168.1.104)
  - Accounting (192.168.1.113)

- **Network Infrastructure:**
  - pfSense firewall (192.168.1.1) with Suricata IDS/IPS

**Personnel:**
- Employees (ISSO/System Owner)
- Contractors and subcontractors accessing CPN via FreeIPA or Samba shares

**Processes:**
- Risk assessments during system changes
- Personnel onboarding/offboarding (per TCC-PS-001)
- Incident response integration (per TCC-IRP-001)
- System and information integrity monitoring (per TCC-SI-001)

**Risk Types:**
- Cybersecurity threats (malware, unauthorized access, data exfiltration)
- Operational disruptions (hardware failure, power outage)
- Insider threats (accidental or intentional)
- Supply chain vulnerabilities (third-party contractors, software vendors)
- Physical security risks (theft, damage)
- Natural disasters (fire, flood)

**Exclusions:** Non-CUI administrative tasks (none currently identified).

### Definitions

- **Risk:** Potential for loss of confidentiality, integrity, or availability of CUI/FCI due to threats exploiting vulnerabilities

- **Risk Assessment:** Systematic process to identify, analyze, and evaluate risks using qualitative or quantitative methods

- **Risk Response:** Actions to avoid, mitigate, transfer, or accept risks based on analysis

- **Residual Risk:** Risk remaining after risk response actions have been implemented

- **Threat:** Potential cause of an unwanted incident (e.g., malware, insider threat)

- **Vulnerability:** Weakness in a system that can be exploited by a threat (e.g., unpatched software)

- **Impact:** Magnitude of harm resulting from a threat exploiting a vulnerability

- **Likelihood:** Probability that a threat will exploit a vulnerability

### Policy Statements

#### 1. Risk Management Policy and Procedures (RA-1)

The Contract Coach shall maintain and review this policy annually, with procedures documented in Section 2 of this document. Compliance is verified through:
- Quarterly System Security Plan (SSP) reviews
- Integration with Wazuh alerts for real-time risk indicators
- OpenSCAP compliance scanning results
- Incident response lessons learned

#### 2. Security Categorization (RA-2)

All CPN systems and information shall be categorized based on potential impact to organizational operations, assets, and individuals (Low/Moderate/High per FIPS 199):

**System Categorization:**
- **Overall CPN:** Moderate impact due to CUI/FCI handling
- **Domain Controller (dc1):** Moderate impact (critical authentication and authorization services)
- **Workstations:** Moderate impact (CUI data processing and storage)
- **Network Infrastructure:** Moderate impact (controls access to all CUI systems)

**Information Categorization:**
- **CUI/FCI:** Moderate confidentiality impact
- **System configuration:** Moderate integrity impact
- **Service availability:** Moderate availability impact

**Recategorization Triggers:**
- New DoD contracts with different data classifications
- Significant system architecture changes
- Addition of new services or capabilities
- Annual review cycle

Document categorization in SSP Section 2.1.

#### 3. Risk Assessment (RA-3)

Conduct comprehensive risk assessments at the following intervals:

**Frequency:**
- **Annual:** Complete risk assessment of all systems
- **Ad-hoc:** Triggered by system changes, new threats, vendor changes
- **Post-Incident:** Within 72 hours of security incidents

**Assessment Methods:**
- Wazuh Vulnerability Detection (automated, 60-minute feed updates)
- OpenSCAP compliance scans (quarterly CUI profile evaluations)
- Threat modeling for common attack vectors (phishing, supply chain, ransomware)
- NIST SP 800-30 risk assessment methodology

**Assessment Outputs:**
- Risk register maintained in `/backup/risk-management/risk-register.xlsx`
- Risk scoring: Likelihood (Low/Medium/High) × Impact (Low/Medium/High)
- Documented mitigation strategies
- Residual risk acceptance decisions

**Timeline:** Complete assessments within 30 days of trigger event.

#### 4. Risk Assessment Updates (RA-3)

Update risk assessments within 72 hours of:
- Security incidents (per TCC-IRP-001)
- Wazuh vulnerability alerts with CVSS scores >7.0
- OpenSCAP compliance failures
- New threat intelligence
- System configuration changes

Integrate updates with:
- System and Information Integrity Policy (TCC-SI-001) for flaw remediation tracking
- Incident Response Policy (TCC-IRP-001) for post-incident analysis
- Plan of Action & Milestones (POA&M) for remediation tracking

#### 5. Vulnerability Monitoring and Scanning (RA-5)

**Automated Scanning:**
- **Wazuh SIEM:** Continuous monitoring with:
  - Vulnerability detection enabled (syscollector module)
  - Security Configuration Assessment (SCA) per CIS Rocky Linux 9 Benchmark
  - Scan interval: 12 hours
  - File Integrity Monitoring (FIM): 12-hour intervals

- **OpenSCAP:** Quarterly full compliance evaluations
  - Profile: `xccdf_org.ssgproject.content_profile_cui`
  - Generate HTML reports for evidence
  - Results stored in `/backup/compliance-scans/`

**Manual Reviews:**
- High-risk asset configurations (dc1 FreeIPA, pfSense firewall)
- Third-party software before deployment
- Custom scripts and configurations

**Remediation Timelines:**
- **Critical vulnerabilities (CVSS 9.0-10.0):** 7 days
- **High severity (CVSS 7.0-8.9):** 30 days
- **Medium severity (CVSS 4.0-6.9):** 90 days
- **Low severity (CVSS 0.1-3.9):** Next maintenance window

Track all remediation activities in POA&M.

**Evidence Retention:**
- Wazuh dashboard reports and logs
- OpenSCAP ARF XML results files
- OpenSCAP HTML reports
- Remediation documentation
- Retain for 3 years minimum

#### 6. Vulnerability Scanning Coverage (RA-5)

Vulnerability scans shall cover:
- All CPN endpoints (domain controller, workstations)
- Network devices (pfSense firewall)
- Authenticated scans where possible (Wazuh agents)
- Operating system vulnerabilities
- Application vulnerabilities
- Configuration compliance

**Scanning Restrictions:**
- Prohibit scans that disrupt operations (e.g., DoS-like aggressive scans)
- Schedule intensive scans during maintenance windows
- Use Wazuh agent-based scanning to minimize network impact

**Information Sharing:**
- Share vulnerability findings with personnel via security awareness training (per TCC-AT-001)
- Brief users on applicable mitigations
- Update documentation based on findings

#### 7. Supply Chain Risk Assessment (RA-6)

Assess risks from third-party vendors and contractors:

**Vendor Assessment Process:**
1. Require vendor security attestations during onboarding
2. Request CMMC self-assessment or certification status
3. Review vendor security policies and procedures
4. Assess vendor access requirements (FreeIPA accounts, Samba shares)
5. Implement least-privilege access controls

**Vendor Categories:**
- **High Risk:** Software providers, IT service providers, cloud services
- **Medium Risk:** Occasional contractors with CUI access
- **Low Risk:** Vendors without system access

**Assessment Frequency:**
- Annual reviews for high-risk vendors (e.g., Wazuh, Rocky Linux)
- Triennial reviews for medium-risk vendors
- Event-driven for vendor security incidents

**Mitigation Strategies:**
- Contract flow-down clauses (FAR 52.204-21, DFARS 252.204-7012)
- Non-Disclosure Agreements (NDAs) for all contractors
- Limited-duration FreeIPA accounts with expiration dates
- Quarterly access reviews and account audits
- Personnel Security procedures (per TCC-PS-001)

#### 8. Criticality Analysis (RA-7)

Prioritize CPN components by criticality to organizational operations:

**Criticality Levels:**

**High Criticality:**
- dc1.cyberinabox.net (domain controller)
  - FreeIPA authentication/authorization
  - Wazuh Manager security monitoring
  - Samba file server (CUI data storage)
  - rsyslog centralized logging
- Loss impact: Complete operational shutdown

**Medium Criticality:**
- Workstations (Engineering, Accounting, LabRat)
  - Proposal development and contract administration
  - CUI document processing
- Loss impact: Reduced operational capacity, deadline risk

**Low Criticality:**
- pfSense firewall (easily restored from backup configuration)
- Loss impact: Network isolation, restore within 4 hours

**Criticality Analysis Updates:**
- Annual review cycle
- Post-incident analysis
- After significant system changes
- Document in SSP Appendix B

**Protection Priorities:**
- Allocate resources based on criticality
- Prioritize backup/recovery for high-criticality systems
- Focus monitoring on high-criticality assets
- Schedule maintenance to minimize high-criticality system downtime

#### 9. All-Hazards Risk Assessment (RA-8)

Include non-cyber risks in comprehensive risk assessments:

**Physical Security Risks:**
- Unauthorized physical access to home office
- Theft or damage to equipment
- Loss of power or environmental controls
- Coordinate with Physical Security Policy (TCC-PE-001)

**Personnel Risks:**
- Insider threats (accidental or malicious)
- Loss of key personnel (solopreneur business continuity)
- Coordinate with Personnel Security Policy (TCC-PS-001)

**Natural Disasters:**
- Fire, flood, severe weather
- Coordinate with Incident Response and Backup procedures

**Operational Risks:**
- Hardware failure (especially RAID array)
- Software failures or corruption
- Third-party service outages (Internet, power)

**Combined Risk Scenarios:**
- Ransomware + backup failure
- Insider threat + physical theft
- Incident during personnel absence

#### 10. Ongoing Risk Monitoring (RA-9)

Continuous monitoring and periodic review of organizational risks:

**Continuous Monitoring Tools:**
- **Wazuh SIEM:** Real-time log aggregation and alerting
  - FIM every 12 hours
  - Vulnerability detection: 60-minute updates
  - SCA: 12-hour intervals
  - Active response for critical alerts

- **Suricata IDS/IPS:** Network intrusion detection on pfSense
  - Integration with Wazuh for centralized alerting
  - Daily rule updates

- **rsyslog:** Centralized logging from all systems
  - 90-day retention minimum
  - Integration with Wazuh

- **auditd:** System audit logging per NIST CUI profile
  - Tamper-proof audit trail
  - Weekly manual review

**Periodic Reviews:**
- **Monthly:** ISSO reviews risk register and Wazuh dashboards
- **Quarterly:** SSP and POA&M review
- **Annually:** Comprehensive risk assessment
- **Post-Incident:** Risk reassessment within 72 hours

**Escalation Procedures:**
- Residual risks >Medium escalated to Owner/Principal for acceptance decision
- Critical vulnerabilities (CVSS >9.0) require immediate Owner notification
- Supply chain incidents reported within 24 hours

**Record Retention:**
- Risk registers: 3 years minimum
- Assessment reports: 3 years minimum
- Wazuh logs: 90 days
- OpenSCAP reports: 3 years
- Incident-related risk documents: 3 years post-incident

### Roles and Responsibilities

| Role | Responsibilities |
|------|------------------|
| **ISSO (Don Shannon)** | Lead risk assessments; maintain risk register; integrate Wazuh/OpenSCAP tools; report high risks to Owner/Principal; remediate or mitigate identified risks; coordinate DoD reporting per DFARS 252.204-7012 |
| **Owner/Principal (Don Shannon)** | Approve risk responses for Medium/High residual risks; authorize resource allocation for risk mitigation; oversee policy compliance; make risk acceptance decisions |
| **Personnel/Contractors** | Report potential risks immediately; participate in risk assessment interviews; cooperate with vulnerability scanning; attend tabletop exercises |
| **Contract Administrator (if engaged)** | Support supply chain risk assessments; manage vendor NDAs and flow-down clauses; track vendor compliance |

**Note:** As a solopreneur, the ISSO and Owner/Principal roles are fulfilled by the same individual (Don Shannon).

### Compliance and Enforcement

This policy integrates with:
- FAR 52.204-21 (Basic Safeguarding of Covered Contractor Information Systems)
- DFARS 252.204-7012 (Safeguarding Covered Defense Information and Cyber Incident Reporting)
- CMMC Level 2 requirements
- NIST SP 800-171 Rev 2, RA Family

**Enforcement:**
- Violations (e.g., unreported risks, failure to remediate) may result in access revocation, disciplinary action, or contract termination
- Quarterly tabletop exercises validate effectiveness
- Exercise results update SSP and POA&M
- Annual policy review and approval

### References

- NIST SP 800-171 Rev 2, RA Family (Risk Assessment)
- NIST SP 800-30 Rev 1, Guide for Conducting Risk Assessments
- System Security Plan (SSP), Section 3.11
- Incident Response Policy (TCC-IRP-001)
- Personnel Security Policy (TCC-PS-001)
- System and Information Integrity Policy (TCC-SI-001)
- Physical and Environmental Protection Policy (TCC-PE-001)
- Wazuh Operations Guide
- OpenSCAP compliance reports

---

## 2. Risk Management Procedures

### Overview

This procedure provides step-by-step guidance for implementing the Risk Management Policy (TCC-RA-001). It operationalizes risk identification, assessment, response, and monitoring processes to protect CUI/FCI on the CPN. Processes leverage automated capabilities like Wazuh SIEM (vulnerability detection, FIM, SCA) on dc1.cyberinabox.net and OpenSCAP for compliance scans.

Risks are tracked in a centralized risk register: `/backup/risk-management/risk-register.xlsx`

All actions support NIST SP 800-171 RA-1 through RA-9 and provide CMMC Level 2 evidence.

### Risk Register Format

The risk register shall include:
- **Risk ID:** Unique identifier (RISK-YYYY-NNN)
- **Risk Description:** Clear description of the threat and vulnerability
- **Threat Source:** Internal, external, natural, or accidental
- **Likelihood:** Low (1), Medium (2), High (3)
- **Impact:** Low (1), Medium (2), High (3)
- **Risk Score:** Likelihood × Impact (1-9)
- **Risk Category:** Technical, operational, physical, supply chain
- **Affected Systems:** List of impacted assets
- **Current Controls:** Existing mitigations
- **Residual Risk:** Risk level after current controls
- **Response Strategy:** Avoid, mitigate, transfer, or accept
- **Planned Actions:** Specific mitigation steps
- **Owner:** Person responsible for mitigation
- **Target Date:** Completion deadline
- **Status:** Open, In Progress, Closed, Accepted
- **Last Review:** Date of last assessment

### Procedure Steps

#### 1. Annual Risk Assessment (RA-3)

**Trigger:** Annual cycle (recommend January for calendar alignment)

**Timeline:** Complete within 30 days

**Process:**

**Step 1.1** - Prepare for Assessment:
```bash
# Create assessment workspace
mkdir -p /backup/risk-management/assessment-$(date +%Y)
cd /backup/risk-management/assessment-$(date +%Y)

# Gather baseline data
sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --results oscap-baseline-$(date +%Y%m%d).xml \
    --report oscap-baseline-$(date +%Y%m%d).html \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# Export Wazuh vulnerability data
# Access Wazuh dashboard: https://dc1.cyberinabox.net:443
# Navigate to Modules > Security Events > Vulnerabilities
# Export vulnerability report

# Review previous risk register
cp /backup/risk-management/risk-register.xlsx ./risk-register-previous.xlsx
```

**Step 1.2** - Identify Assets:
- Review SSP for current asset inventory
- Document any new systems or workstations
- Update network diagram if changes occurred
- List all software applications processing CUI

**Step 1.3** - Identify Threats and Vulnerabilities:

**Automated Sources:**
```bash
# Review Wazuh vulnerability reports
# Dashboard: Vulnerabilities > Inventory
# Focus on CVSS scores >4.0

# Review OpenSCAP failures
# Generate summary report from baseline scan

# Review audit log anomalies
sudo aureport -au --summary --failed
sudo aureport -x --summary
```

**Manual Analysis:**
- Review threat intelligence (CISA alerts, vendor bulletins)
- Analyze incident response lessons learned from past year
- Review POA&M for unmitigated items
- Consider supply chain changes (new vendors, software)
- Assess physical security observations

**Step 1.4** - Assess Likelihood and Impact:

For each identified risk:
1. Determine threat likelihood (Low/Medium/High)
2. Determine impact if exploited (Low/Medium/High)
3. Calculate risk score (1-9)
4. Categorize risk type

**Likelihood Criteria:**
- **Low (1):** Unlikely to occur within 3 years
- **Medium (2):** Likely to occur within 1-3 years
- **High (3):** Likely to occur within 1 year or already observed

**Impact Criteria:**
- **Low (1):** Minimal disruption, no CUI compromise
- **Medium (2):** Moderate disruption, potential CUI exposure
- **High (3):** Severe disruption, confirmed CUI compromise, contract termination risk

**Step 1.5** - Determine Risk Response:

For each risk:
- **Accept:** Document residual risk, requires Owner approval for Medium/High
- **Avoid:** Eliminate the risk source (e.g., discontinue risky practice)
- **Mitigate:** Implement controls to reduce likelihood or impact
- **Transfer:** Use insurance or contracts to share risk

**Step 1.6** - Document and Approve:
- Update risk register with all findings
- Create risk assessment report
- Present Medium/High residual risks to Owner for acceptance
- File report in `/backup/risk-management/`

#### 2. Vulnerability Scanning (RA-5)

**Automated Continuous Scanning:**

**Wazuh Configuration Verification:**
```bash
# Verify Wazuh Manager status
sudo systemctl status wazuh-manager

# Check vulnerability detector module
sudo grep -A 10 "<vulnerability-detector>" /var/ossec/etc/ossec.conf

# Verify agent status
sudo /var/ossec/bin/wazuh-control status

# Review recent vulnerability alerts
sudo tail -f /var/ossec/logs/alerts/alerts.log | grep -i vulnerability
```

**Quarterly OpenSCAP Scanning:**
```bash
# Run comprehensive CUI profile scan
sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --results /backup/compliance-scans/oscap-$(date +%Y%m%d).xml \
    --report /backup/compliance-scans/oscap-$(date +%Y%m%d).html \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml

# Review failures
grep -i "fail" /backup/compliance-scans/oscap-$(date +%Y%m%d).html

# Generate remediation script for review (do not auto-apply)
sudo oscap xccdf generate fix \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --output /tmp/oscap-remediation-$(date +%Y%m%d).sh \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

**Step 2.1** - Review Scan Results:
- Access Wazuh dashboard for vulnerability summary
- Identify vulnerabilities with CVSS >7.0 (high/critical)
- Review OpenSCAP failures
- Cross-reference with risk register

**Step 2.2** - Prioritize Remediation:
- Group vulnerabilities by severity
- Consider system criticality (dc1 = highest priority)
- Account for compensating controls
- Create POA&M items for each vulnerability

**Step 2.3** - Remediate Vulnerabilities:
```bash
# Apply security updates
sudo dnf update --security -y

# Verify FIPS mode after updates
fips-mode-setup --check

# Apply specific OpenSCAP remediations (review script first)
# sudo bash /tmp/oscap-remediation-$(date +%Y%m%d).sh

# Restart services if required
sudo ipactl restart
sudo systemctl restart wazuh-manager

# Re-scan to verify
sudo oscap xccdf eval \
    --profile xccdf_org.ssgproject.content_profile_cui \
    --results /backup/compliance-scans/oscap-recheck-$(date +%Y%m%d).xml \
    /usr/share/xml/scap/ssg/content/ssg-rl9-ds.xml
```

**Step 2.4** - Document Remediation:
- Update POA&M with completed items
- Update risk register with reduced risk scores
- Document any accepted risks (with Owner approval)
- File evidence in `/backup/compliance-scans/`

#### 3. Supply Chain Risk Assessment (RA-6)

**Trigger:** New vendor onboarding, annual review, vendor security incident

**Process:**

**Step 3.1** - Vendor Information Gathering:
- Request vendor security policies
- Obtain CMMC certification or self-assessment
- Review vendor incident history
- Assess vendor's supply chain practices

**Step 3.2** - Access Requirements Analysis:
- Determine if vendor needs CPN access
- Identify minimum required privileges
- Specify access duration (temporary vs. ongoing)
- Plan for FreeIPA account provisioning

**Step 3.3** - Risk Assessment:
- Evaluate vendor's security posture
- Assess potential impact of vendor compromise
- Determine data types vendor will access
- Calculate vendor risk score

**Step 3.4** - Mitigation Implementation:
```bash
# Create time-limited contractor account
kinit admin
ipa user-add contractor_name --first=First --last=Last \
    --email=contractor@example.com --shell=/bin/bash

# Set account expiration
ipa user-mod contractor_name --principal-expiration=20260101000000Z

# Add to appropriate groups (least privilege)
ipa group-add-member contractors --users=contractor_name
ipa group-add-member file_share_ro --users=contractor_name

# Verify no admin privileges
ipa user-show contractor_name
```

**Step 3.5** - Contractual Controls:
- Include FAR 52.204-21 and DFARS 252.204-7012 flow-down clauses
- Require signed NDA
- Specify incident reporting requirements
- Define audit rights

**Step 3.6** - Ongoing Monitoring:
- Quarterly access reviews
- Annual security posture re-assessment
- Monitor for vendor security incidents
- Review Wazuh logs for contractor account activity

#### 4. Criticality Analysis (RA-7)

**Annual Review Process:**

**Step 4.1** - System Inventory:
- List all systems and their functions
- Document dependencies
- Identify single points of failure

**Step 4.2** - Business Impact Analysis:
For each system, assess:
- Mission-critical functions supported
- RTO (Recovery Time Objective)
- RPO (Recovery Point Objective)
- Impact of 1-hour outage
- Impact of 24-hour outage
- Impact of permanent loss

**Step 4.3** - Criticality Scoring:

| System | Function | Users | CUI Data | RTO | Criticality |
|--------|----------|-------|----------|-----|-------------|
| dc1 | Authentication, files, monitoring | All | Yes | 4 hours | High |
| Engineering WS | Proposal development | 1 | Yes | 24 hours | Medium |
| Accounting WS | Contract admin | 1 | Yes | 24 hours | Medium |
| LabRat WS | Testing, development | 1 | No | 72 hours | Low |
| pfSense | Network security | All | No | 4 hours | Medium |

**Step 4.4** - Protection Prioritization:
- Allocate backup resources based on criticality
- Schedule maintenance windows (least critical first)
- Focus monitoring on high-criticality systems
- Plan redundancy for single points of failure

#### 5. Ongoing Risk Monitoring (RA-9)

**Daily Activities (Automated):**
```bash
# Wazuh performs continuous monitoring:
# - Vulnerability detection updates every 60 minutes
# - FIM scans every 12 hours
# - SCA scans every 12 hours
# - Real-time log analysis

# Verify Wazuh is operational
sudo systemctl status wazuh-manager
```

**Weekly Activities (Manual):**
```bash
# Review Wazuh dashboard for new alerts
# https://dc1.cyberinabox.net:443

# Check for critical vulnerabilities
# Dashboard: Vulnerabilities > CVSS > Critical

# Review authentication failures
sudo aureport -au --failed --summary

# Check system resource utilization
df -h
free -h
uptime
```

**Monthly Activities:**
```bash
# Review risk register
# Update status of open risks
# Add newly identified risks
# Close mitigated risks

# Generate Wazuh compliance report
# Dashboard: Management > Reporting

# Review POA&M progress
# Update target dates if needed

# Check for vendor security incidents
# Review vendor notifications and bulletins
```

**Quarterly Activities:**
```bash
# Run comprehensive OpenSCAP scan (see Section 2 above)
# Update SSP with risk posture changes
# Review and update POA&M
# Conduct tabletop exercise for high-priority risks
# Brief Owner on risk trends
```

#### 6. Risk Response Implementation

**For each identified risk requiring mitigation:**

**Step 6.1** - Develop Mitigation Plan:
- Specify technical or administrative controls
- Assign implementation owner (ISSO)
- Set target completion date
- Estimate resource requirements

**Step 6.2** - Implement Controls:
- Execute technical changes
- Document configuration changes
- Update system baseline
- Test effectiveness

**Step 6.3** - Verify Effectiveness:
- Re-scan with Wazuh or OpenSCAP
- Conduct penetration test if applicable
- Review audit logs for control operation
- Calculate residual risk

**Step 6.4** - Document and Update:
- Update risk register with new risk score
- Update POA&M status
- File implementation evidence
- Brief Owner if residual risk remains >Medium

---

## Appendix A: Risk Assessment Template

**Risk ID:** RISK-2025-001
**Date Identified:** YYYY-MM-DD
**Identified By:** Don Shannon (ISSO)

**Risk Description:**
[Detailed description of threat and vulnerability]

**Threat Source:**
☐ Internal (user error, insider threat)
☐ External (cyber attack, malware)
☐ Environmental (natural disaster, power failure)
☐ Supply Chain (vendor compromise)

**Affected Systems:**
[List all impacted systems]

**Likelihood Assessment:**
☐ Low (1) - Unlikely within 3 years
☐ Medium (2) - Likely within 1-3 years
☐ High (3) - Likely within 1 year

**Impact Assessment:**
☐ Low (1) - Minimal disruption, no CUI impact
☐ Medium (2) - Moderate disruption, potential CUI exposure
☐ High (3) - Severe disruption, confirmed CUI compromise

**Risk Score:** [Likelihood × Impact = 1-9]

**Current Controls:**
[List existing mitigations]

**Residual Risk:** [Low/Medium/High]

**Risk Response Strategy:**
☐ Accept (requires Owner approval for Medium/High)
☐ Avoid (eliminate risk source)
☐ Mitigate (implement additional controls)
☐ Transfer (insurance, contracts)

**Planned Mitigations:**
[Specific actions to reduce risk]

**Implementation Owner:** Don Shannon
**Target Date:** YYYY-MM-DD
**Status:** ☐ Open ☐ In Progress ☐ Closed ☐ Accepted

**Approval (for Medium/High Residual Risk):**
/s/ Donald E. Shannon, Owner/Principal
Date: _______________

---

## Appendix B: Common Risk Scenarios

### 1. Ransomware Attack
- **Threat:** Malware encrypts RAID array
- **Likelihood:** Medium (increasing threat landscape)
- **Impact:** High (CUI data inaccessible)
- **Risk Score:** 6
- **Mitigations:** ClamAV scanning, Wazuh FIM, offline backups, LUKS encryption
- **Residual Risk:** Low

### 2. Workstation Hardware Failure
- **Threat:** Disk failure on Engineering workstation
- **Likelihood:** Medium (age of equipment)
- **Impact:** Medium (work disruption, data loss if no backup)
- **Risk Score:** 4
- **Mitigations:** Daily backups, ReaR recovery, spare equipment
- **Residual Risk:** Low

### 3. Unauthorized Physical Access
- **Threat:** Intruder accesses server rack
- **Likelihood:** Low (home office, locked)
- **Impact:** High (CUI exposure, equipment theft)
- **Risk Score:** 3
- **Mitigations:** Locked office, alarm system, LUKS encryption, TS clearance holder
- **Residual Risk:** Low

### 4. Contractor Account Compromise
- **Threat:** Contractor credentials phished
- **Likelihood:** Low (limited contractor use)
- **Impact:** Medium (potential CUI access)
- **Risk Score:** 2
- **Mitigations:** Time-limited accounts, least privilege, Wazuh monitoring, MFA (planned)
- **Residual Risk:** Low

### 5. Software Vulnerability Exploitation
- **Threat:** Unpatched CVE exploited
- **Likelihood:** Medium (constant vulnerability discovery)
- **Impact:** Medium (potential unauthorized access)
- **Risk Score:** 4
- **Mitigations:** Wazuh vulnerability scanning, dnf-automatic updates, OpenSCAP, FIPS mode
- **Residual Risk:** Low

---

## Appendix C: Wazuh Risk Monitoring Dashboard

**Key Metrics to Review:**

1. **Vulnerabilities**
   - Dashboard: Modules > Security Events > Vulnerabilities
   - Focus on: CVSS >7.0, exploits available
   - Action: Create POA&M items for critical/high

2. **Security Configuration Assessment**
   - Dashboard: Modules > Security Events > Configuration Assessment
   - Review: CIS Rocky Linux 9 Benchmark compliance
   - Action: Remediate failures within 90 days

3. **File Integrity Monitoring**
   - Dashboard: Modules > Security Events > Integrity Monitoring
   - Watch for: Unauthorized changes to /etc, /var/ossec, /srv/samba
   - Action: Investigate all unexpected changes

4. **Authentication**
   - Dashboard: Modules > Security Events > Authentication
   - Monitor: Failed login attempts, unusual login times
   - Action: Investigate >5 failures, unusual patterns

5. **Compliance**
   - Dashboard: Management > Status and Reports > Compliance
   - Review: NIST 800-171 compliance posture
   - Action: Address non-compliant items

---

## Approval

**Prepared By:**
Donald E. Shannon, ISSO

**Approved By:**
/s/ Donald E. Shannon
Owner/Principal, The Contract Coach

**Date:** November 2, 2025

**Next Review Date:** November 2, 2026
