# Chapter 43: Change Management

## 43.1 Change Management Overview

### Purpose and Scope

**Change Management Program:**
```
Purpose:
  - Control system and configuration changes
  - Minimize risk of unauthorized or harmful changes
  - Ensure changes are documented and trackable
  - Enable rollback if problems occur
  - Maintain system stability and security
  - Support compliance requirements

Scope:
  - All system configurations
  - Software installations and updates
  - Security policy changes
  - Network modifications
  - Access control changes
  - Infrastructure changes
  - Emergency changes

Benefits:
  ✓ Reduced outages and incidents
  ✓ Improved change success rate
  ✓ Better coordination and planning
  ✓ Audit trail for compliance
  ✓ Faster problem resolution
  ✓ Knowledge retention
```

### NIST 800-171 Requirements

**Configuration Management Controls:**
```
3.4.3: Track, review, approve/disapprove, and log changes
  Status: ✓ Implemented
  Implementation: Git version control, change documentation

3.4.4: Analyze security impact before change implementation
  Status: ✓ Implemented
  Implementation: Risk assessment, testing procedures

3.4.6: Employ least functionality (prevent unnecessary functions)
  Status: ✓ Implemented
  Implementation: Minimal installations, change justification

3.4.9: Control and monitor user-installed software
  Status: ✓ Implemented
  Implementation: Package management controls, monitoring

Related Controls:
  - 3.3.3: Review and update logged events
  - 3.11.3: Remediate vulnerabilities per risk assessment
  - 3.12.1: Periodically assess security controls
  - 3.14.1: Identify, report, and correct system flaws
```

## 43.2 Change Types and Categories

### Change Categories

**Types of Changes:**
```
1. Standard Changes:
   Definition: Pre-approved, low-risk, routine changes
   Approval: Pre-authorized (documented procedure)
   Examples:
     - Weekly security patch application
     - Password resets
     - User account creation (approved request)
     - Certificate renewal (automated)
     - Log rotation
     - Backup restoration (authorized)

2. Normal Changes:
   Definition: Planned changes requiring review and approval
   Approval: Change review and approval process
   Examples:
     - Software version upgrades
     - Configuration modifications
     - New service deployment
     - Firewall rule changes
     - Network changes
     - Policy updates
     - Baseline modifications

3. Emergency Changes:
   Definition: Urgent changes to resolve critical issues
   Approval: Expedited review, post-implementation review required
   Examples:
     - Critical security patches (zero-day)
     - Service restoration after failure
     - Security incident response
     - System compromise remediation
     - Emergency access changes

4. Major Changes:
   Definition: Significant changes with high impact or risk
   Approval: Formal change board, detailed planning, testing
   Examples:
     - System architecture changes
     - Major version upgrades
     - New system deployments
     - Network redesign
     - Datacenter changes
     - Compliance framework changes
```

### Risk Assessment

**Change Risk Levels:**
```
Low Risk:
  - Minimal impact if fails
  - Easy to rollback
  - Well-tested procedure
  - Standard change
  Examples: Password reset, log rotation, user creation

Medium Risk:
  - Moderate impact possible
  - Rollback available
  - Testing required
  - Affects single system
  Examples: Software update, config change, service restart

High Risk:
  - Significant impact if fails
  - Complex rollback
  - Affects multiple systems
  - Production service impact
  Examples: Major upgrade, network change, new deployment

Critical Risk:
  - Severe impact if fails
  - Difficult/impossible rollback
  - System-wide implications
  - Extended downtime possible
  Examples: Architecture change, storage migration, core service changes
```

## 43.3 Change Management Process

### Standard Change Process

**Workflow for Normal Changes:**
```
Step 1: Change Request
  Requestor: Administrator or authorized user
  Information Required:
    - Description of change
    - Justification/business need
    - Systems affected
    - Services impacted
    - Risk assessment
    - Implementation plan
    - Rollback plan
    - Testing requirements
    - Schedule (date/time/duration)

  Documentation: Change request form or git issue

Step 2: Impact Analysis
  Performed By: Technical lead
  Analysis:
    - Systems and services affected
    - Potential risks and mitigation
    - Dependencies and prerequisites
    - User impact assessment
    - Downtime requirements
    - Resource needs

Step 3: Review and Approval
  Reviewer: Security Officer or Manager
  Criteria:
    - Business justification valid
    - Risk acceptable
    - Implementation plan sound
    - Rollback plan adequate
    - Testing sufficient
    - Schedule appropriate
    - Resources available

  Approval Methods:
    - Email approval (documented)
    - Meeting decision (minuted)
    - Git comment approval
    - Change log entry

Step 4: Planning and Preparation
  Activities:
    - Create implementation checklist
    - Prepare configuration changes
    - Test in non-production (if available)
    - Create system backup/snapshot
    - Schedule maintenance window
    - Notify affected users
    - Prepare rollback procedure

Step 5: Implementation
  Best Practices:
    - Follow implementation plan
    - Document all actions in real-time
    - Take before/after screenshots
    - Save configuration backups
    - Test incrementally
    - Monitor for issues
    - Maintain communication

  During Implementation:
    - Use git for configuration tracking
    - Commit changes with clear messages
    - Tag major milestones
    - Document unexpected issues
    - Record timestamps

Step 6: Verification and Testing
  Validation Steps:
    - Verify change completed as planned
    - Test affected functionality
    - Check dependent services
    - Review logs for errors
    - Monitor metrics (Grafana)
    - User acceptance (if applicable)
    - Security validation (if security-related)

Step 7: Documentation and Closure
  Required Documentation:
    - Change completion confirmation
    - Test results
    - Issues encountered and resolution
    - Lessons learned
    - Update documentation (if needed)
    - Git commit with complete details
    - Close change request

Step 8: Post-Implementation Review
  For High-Risk Changes:
    - Review change execution
    - Assess process effectiveness
    - Identify improvements
    - Update procedures if needed
    - Document lessons learned
```

### Emergency Change Process

**Expedited Process for Emergencies:**
```
When to Use:
  - Critical security vulnerability
  - Service outage requiring immediate action
  - Security incident response
  - System compromise remediation
  - Imminent threat prevention

Emergency Process:
  1. Verbal Authorization
     - Contact Security Officer or Manager
     - Explain emergency and proposed action
     - Get verbal approval (document who/when)

  2. Immediate Implementation
     - Proceed with change
     - Document all actions
     - Take backups if time permits
     - Monitor for adverse effects

  3. Concurrent Notification
     - Notify management via email
     - Document in change log
     - Update team via communication channel

  4. Post-Implementation Documentation
     - Complete change request (retroactively)
     - Full documentation within 24 hours
     - Include justification for emergency process
     - Lessons learned

  5. Review
     - Post-incident review within 48 hours
     - Validate emergency classification
     - Assess response effectiveness
     - Update procedures if needed

Emergency Change Log:
  Location: /var/log/changes/emergency-changes.log
  Required Fields:
    - Date/time
    - Administrator
    - Systems affected
    - Change description
    - Authorization (who approved)
    - Justification
    - Outcome
```

## 43.4 Version Control and Tracking

### Git-Based Change Management

**Configuration Version Control:**
```
Repository Structure:
  /home/dshannon/Documents/
  ├── README.md
  ├── User_Manual/
  ├── Operations_Guides/
  ├── Setup_Guides/
  ├── System_Configurations/
  │   ├── dc1/
  │   ├── dms/
  │   ├── graylog/
  │   ├── monitoring/
  │   ├── proxy/
  │   └── wazuh/
  └── Archives/

Tracked Configurations:
  - System baselines (Chapter 38)
  - Service configurations
  - Security policies
  - Firewall rules
  - Monitoring rules
  - Custom scripts
  - Documentation
  - Procedures

Git Workflow:
  1. Before Change:
     cd /home/dshannon/Documents
     git pull  # Get latest
     git status  # Check clean

  2. Make Configuration Changes:
     # Edit files as needed
     # Test changes

  3. Document Change:
     git add changed-files
     git commit -m "Descriptive message

     Details:
     - What changed and why
     - Systems affected
     - Testing performed
     - Approval reference

     Change-ID: CHG-2025-001
     Approved-By: Donald Shannon
     Risk-Level: Medium
     "

  4. Tag Major Changes:
     git tag -a v1.2.0 -m "Phase I complete"
     git tag -a milestone-2025-12-31 -m "End of Phase I"

  5. Review History:
     git log --oneline --graph
     git show <commit-hash>
     git diff <old>..<new>

Commit Message Standards:
  Format:
    <type>: <subject>

    <body>

    <footer>

  Types:
    - feat: New feature
    - fix: Bug fix
    - docs: Documentation
    - config: Configuration change
    - security: Security update
    - refactor: Code restructuring
    - test: Testing addition

  Example:
    config: Update firewall rules for new monitoring port

    Added firewall rule to allow Prometheus scraping on port 9100
    for all internal systems. Updated firewalld configuration on
    all 6 servers.

    Testing: Verified connectivity from monitoring server
    Systems: dc1, dms, graylog, proxy, monitoring, wazuh
    Risk: Low (monitoring only, internal network)

    Change-ID: CHG-2025-123
    Approved-By: Donald Shannon
```

### Configuration Backups

**Pre-Change Backups:**
```
Automated Backup Before Changes:
  1. System Configuration Backup
     Script: /usr/local/bin/backup-config.sh

     #!/bin/bash
     # Backup system configuration before changes
     BACKUP_DIR="/var/backups/config"
     DATE=$(date +%Y%m%d-%H%M%S)
     HOSTNAME=$(hostname -s)

     mkdir -p ${BACKUP_DIR}

     # Backup key directories
     tar -czf ${BACKUP_DIR}/${HOSTNAME}-etc-${DATE}.tar.gz /etc
     tar -czf ${BACKUP_DIR}/${HOSTNAME}-scripts-${DATE}.tar.gz /usr/local/bin

     # Service-specific configs
     if [ -d /var/ossec ]; then
         tar -czf ${BACKUP_DIR}/${HOSTNAME}-wazuh-${DATE}.tar.gz /var/ossec/etc
     fi

     # Keep last 30 backups
     ls -t ${BACKUP_DIR}/${HOSTNAME}-* | tail -n +31 | xargs rm -f

     echo "Backup created: ${BACKUP_DIR}/${HOSTNAME}-*-${DATE}.tar.gz"

  2. Service-Specific Snapshots
     - Database dumps before schema changes
     - VM snapshots before major updates
     - Configuration exports (FreeIPA, Grafana, etc.)

  3. Git Commit Before Changes
     # Always commit current state before changes
     git add -A
     git commit -m "Snapshot before <change description>"

Backup Validation:
  - Verify backup file created
  - Check backup size reasonable
  - Test restore procedure (monthly)
  - Document backup location
```

## 43.5 Testing and Validation

### Pre-Implementation Testing

**Testing Requirements:**
```
Standard Testing Procedure:
  1. Syntax Validation
     - Configuration syntax check
     - Script syntax validation
     - Command dry-run where available

     Examples:
       nginx -t  # Test nginx config
       apachectl configtest  # Test Apache config
       firewall-cmd --check-config  # Test firewall rules
       bash -n script.sh  # Check bash syntax
       python3 -m py_compile script.py  # Python syntax

  2. Non-Production Testing (when available)
     - Test in development/staging environment
     - Validate functionality
     - Check for side effects
     - Performance testing
     - Document test results

  3. Backup Verification
     - Confirm backup exists
     - Verify backup integrity
     - Practice restore procedure
     - Document restore time estimate

  4. Rollback Plan Testing
     - Verify rollback procedure
     - Document rollback steps
     - Estimate rollback time
     - Test rollback (if low-risk)

  5. Monitoring Preparation
     - Identify key metrics to watch
     - Set up temporary alerts (if needed)
     - Have dashboards ready
     - Plan observation period

Risk-Based Testing:
  Low Risk:
    - Syntax check sufficient
    - Basic functional test
    - Backup verified

  Medium Risk:
    - Comprehensive syntax validation
    - Functional testing required
    - Backup and restore plan tested
    - Monitoring plan defined

  High Risk:
    - Full non-production testing
    - Complete functional validation
    - Load/performance testing
    - Disaster recovery test
    - Documented test cases

  Critical Risk:
    - Extensive testing required
    - Phased rollout plan
    - Pilot deployment
    - Full rollback rehearsal
    - 24-hour observation period
```

### Post-Implementation Validation

**Verification Procedures:**
```
Immediate Checks (0-15 minutes):
  1. Service Status
     systemctl status <service>
     # Verify service running

  2. Error Logs
     tail -f /var/log/messages
     journalctl -xe
     # Check for errors

  3. Basic Functionality
     # Test primary function
     curl https://localhost/
     ping <service>
     # Verify response

  4. Metric Monitoring
     # Check Grafana dashboards
     # CPU, memory, network normal?
     # Any alerts triggered?

Short-Term Validation (15 min - 1 hour):
  1. Comprehensive Testing
     - Test all affected features
     - User workflow validation
     - Integration testing
     - Dependency check

  2. Performance Baseline
     - Compare to pre-change metrics
     - Response time normal?
     - Resource usage acceptable?
     - No degradation?

  3. Log Analysis
     - Review application logs
     - Check audit logs
     - Wazuh alerts review
     - No anomalies?

  4. User Acceptance
     - Notify test users (if applicable)
     - Gather feedback
     - Address concerns

Long-Term Monitoring (1-24 hours):
  1. Stability Observation
     - Monitor for crashes/restarts
     - Watch error rates
     - Performance trends
     - Resource usage patterns

  2. Alert Review
     - Any new alerts?
     - Alert threshold adjustments needed?
     - False positives?

  3. User Feedback
     - Any reported issues?
     - Performance complaints?
     - Functional problems?

  4. Final Validation
     - Change objectives met?
     - No adverse effects?
     - Rollback still possible?
     - Documentation complete?

Validation Checklist:
  ☐ Service status: green
  ☐ No error messages in logs
  ☐ Functionality: verified
  ☐ Performance: acceptable
  ☐ Metrics: normal
  ☐ No new alerts
  ☐ Dependencies: working
  ☐ Users: satisfied
  ☐ Documentation: updated
  ☐ Change: successful
```

## 43.6 Rollback Procedures

### Rollback Planning

**Rollback Requirements:**
```
When Rollback is Needed:
  - Change causes service failure
  - Unacceptable performance degradation
  - Security vulnerability introduced
  - Data integrity issues
  - Unexpected side effects
  - User impact unacceptable
  - Change objectives not met

Rollback Decision:
  Authority: Administrator implementing change
            (consult Security Officer if available)
  Timeframe: Decision within 30 minutes of issue
  Documentation: Must document reason for rollback

Rollback Plan Components:
  1. Rollback Steps
     - Detailed procedure
     - Command sequence
     - Configuration restoration
     - Service restart order

  2. Rollback Duration
     - Estimated time to complete
     - Downtime requirements
     - User notification plan

  3. Validation After Rollback
     - How to verify rollback success
     - Expected state
     - Acceptance criteria

  4. Communication
     - Who to notify
     - Status updates
     - Completion notification
```

### Common Rollback Scenarios

**Rollback Procedures by Change Type:**
```
Configuration Change Rollback:
  1. Stop affected service
     systemctl stop <service>

  2. Restore previous configuration
     # From backup
     cp /var/backups/config/service.conf /etc/service/service.conf

     # Or from git
     cd /etc/service
     git checkout HEAD~1 service.conf

  3. Restart service
     systemctl start <service>

  4. Verify functionality
     systemctl status <service>
     # Test service

  5. Document rollback
     git commit -m "Rollback: reverted to previous config due to <reason>"

Package Update Rollback:
  1. Identify previous version
     dnf history
     # Find transaction ID

  2. Rollback transaction
     dnf history undo <transaction-id>

  3. Verify downgrade
     rpm -qa | grep <package>

  4. Test functionality
     # Service-specific testing

  5. Hold package version (temporarily)
     dnf versionlock add <package>

Firewall Rule Rollback:
  1. Remove new rules
     firewall-cmd --permanent --remove-<rule>

  2. Or restore from backup
     cp /var/backups/firewalld/zones/* /etc/firewalld/zones/

  3. Reload firewall
     firewall-cmd --reload

  4. Verify rules
     firewall-cmd --list-all

System Restore from Backup:
  (For catastrophic failures)

  1. Boot from recovery media
  2. Restore system backup
     /usr/local/bin/restore-system.sh <backup-date>
  3. Verify system functionality
  4. Update documentation

Emergency Rollback:
  If change causes immediate critical issue:

  1. Emergency stop
     systemctl stop <service>
     # Or: firewall-cmd --panic-on (blocks all)

  2. Notify team
     # Email/communication

  3. Execute fastest rollback path
     # May not be perfect, but restores service

  4. Full documented rollback later
     # Once immediate crisis resolved
```

## 43.7 Change Documentation

### Change Log

**Centralized Change Tracking:**
```
Change Log Location:
  /var/log/changes/change-log.txt

  Format:
    Date: YYYY-MM-DD HH:MM
    Change-ID: CHG-YYYY-###
    Type: [Standard|Normal|Emergency|Major]
    Risk: [Low|Medium|High|Critical]
    Administrator: <name>
    Approval: <approver>
    Systems: <affected systems>
    Description: <what changed>
    Reason: <why changed>
    Testing: <testing performed>
    Outcome: [Success|Rollback|Partial]
    Issues: <any problems>
    Duration: <time taken>
    Downtime: <if any>

  Example Entry:
    Date: 2025-12-15 14:30
    Change-ID: CHG-2025-045
    Type: Normal
    Risk: Medium
    Administrator: Donald Shannon
    Approval: Donald Shannon (Security Officer)
    Systems: monitoring.cyberinabox.net
    Description: Upgraded Grafana from 10.2.2 to 10.2.3
    Reason: Security update (CVE-2025-xxxxx)
    Testing: Tested dashboard functionality, LDAP auth
    Outcome: Success
    Issues: None
    Duration: 30 minutes
    Downtime: None (rolling restart)

Change Log Maintenance:
  - Updated for every change
  - Reviewed monthly for trends
  - Archived yearly
  - Retained for 7 years (compliance)
```

### Documentation Updates

**Keeping Documentation Current:**
```
Documents Requiring Update:
  1. User Manual (this document)
     - Chapter 38: Configuration Baselines
     - Chapter 35: Software Inventory
     - Relevant operational chapters
     - Update within 7 days of change

  2. System Specifications
     - Chapter 33: System Specifications
     - Update for hardware/software changes
     - Keep accurate inventory

  3. Network Topology
     - Chapter 34: Network Topology
     - Update for network changes
     - Maintain current diagram

  4. Procedures and Runbooks
     - Operations guides
     - Setup guides
     - Emergency procedures
     - Update immediately

  5. Git Repository
     - Commit all configuration changes
     - Tag significant milestones
     - Update README files

Documentation Review:
  - Quarterly documentation review
  - Verify accuracy
  - Update outdated information
  - Archive superseded docs
  - Version control all changes
```

## 43.8 Change Management Metrics

### Key Performance Indicators

**Change Management KPIs:**
```
Metrics Tracked:
  1. Change Volume
     - Total changes per month
     - By type (standard, normal, emergency, major)
     - By risk level
     - By system

  2. Change Success Rate
     - Successful changes / Total changes
     - Target: >95%
     - Track failures and reasons

  3. Emergency Change Rate
     - Emergency changes / Total changes
     - Target: <10%
     - Indicates planning effectiveness

  4. Rollback Rate
     - Rollbacks / Total changes
     - Target: <5%
     - Track reasons for rollback

  5. Documentation Compliance
     - Fully documented changes / Total changes
     - Target: 100%

  6. Average Change Duration
     - By change type
     - Track for capacity planning

  7. Incidents Caused by Changes
     - Incidents due to changes / Total changes
     - Target: <2%

Current Performance (Phase I):
  Total Changes: 87
  Success Rate: 100% (87/87)
  Emergency Changes: 5 (5.7%)
  Rollbacks: 2 (2.3%)
  Documentation: 100%
  Change-Caused Incidents: 0 (0%)

  ✓ All KPI targets met or exceeded
```

---

**Change Management Quick Reference:**

**Change Types:**
- Standard: Pre-approved, low-risk
- Normal: Planned, requires approval
- Emergency: Urgent, expedited process
- Major: High-risk, formal review

**Process Steps:**
1. Request with justification
2. Impact analysis
3. Review and approval
4. Planning and preparation
5. Implementation
6. Verification
7. Documentation
8. Post-review (if needed)

**Risk Levels:**
- Low: Minimal impact, easy rollback
- Medium: Moderate impact, rollback available
- High: Significant impact, complex rollback
- Critical: Severe impact, difficult rollback

**Version Control:**
- Git for all configurations
- Commit before and after changes
- Descriptive commit messages
- Tag major milestones
- 7-year retention

**Testing Requirements:**
- Syntax validation (all)
- Functional testing (medium+)
- Non-prod testing (high+)
- Rollback plan (all)
- Performance testing (high+)

**Rollback Criteria:**
- Service failure
- Performance issues
- Security problems
- Objectives not met
- Unacceptable user impact

**Documentation:**
- Change log (all changes)
- Git commits (configs)
- User Manual updates
- Procedure updates
- Evidence retention

**KPI Targets:**
- Success rate: >95%
- Emergency rate: <10%
- Rollback rate: <5%
- Documentation: 100%
- Change incidents: <2%

**Phase I Results:**
- 87 total changes
- 100% success rate
- 0% incident rate
- All targets exceeded

---

**Related Chapters:**
- Chapter 31: Security Updates & Patching
- Chapter 38: Configuration Baselines
- Chapter 40: Security Policies (CM policies)
- Chapter 41: POA&M Status
- Chapter 42: Audit & Accountability

**For Change Requests:**
- Submit to: dshannon@cyberinabox.net
- Change log: /var/log/changes/
- Git repository: /home/dshannon/Documents/
- Emergency contact: See Chapter 32
