# AI Functions Reference

**SysAdmin Agent Dashboard - Technical Documentation**
**Version:** 2.0
**Last Updated:** January 31, 2026

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Explainable AI Schema](#explainable-ai-schema)
3. [Response Parsing](#response-parsing)
4. [Feedback System](#feedback-system)
5. [Evaluation Metrics](#evaluation-metrics)
6. [Abnormal Event Detection](#abnormal-event-detection)
7. [Reporting Functions](#reporting-functions)
8. [Configuration](#configuration)
9. [API Reference](#api-reference)

---

## Architecture Overview

### Component Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    SysAdmin Agent Dashboard                      │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │  Streamlit  │  │  LangGraph  │  │    Ollama LLM Server    │ │
│  │     UI      │──│   Workflow  │──│   (Llama 3.3 70B)       │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
│         │                │                                       │
│  ┌──────┴────────────────┴──────────────────────────────────┐  │
│  │                    Core Modules                           │  │
│  ├──────────────┬──────────────┬──────────────┬────────────┤  │
│  │ Explainable  │   Feedback   │  Evaluation  │  Abnormal  │  │
│  │  Response    │   Database   │   Reports    │  Detection │  │
│  └──────────────┴──────────────┴──────────────┴────────────┘  │
│                           │                                     │
│  ┌────────────────────────┴─────────────────────────────────┐  │
│  │                    Data Storage                           │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────────────┐  │  │
│  │  │ SQLite DB  │  │ Audit Logs │  │ Evaluation Reports │  │  │
│  │  │ (feedback) │  │   (JSON)   │  │   (MD/JSON)        │  │  │
│  │  └────────────┘  └────────────┘  └────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### File Structure

```
/data/ai-workspace/sysadmin-agent/
├── app.py                      # Main Streamlit application
├── config/
│   └── config.py               # Configuration settings
├── models/
│   ├── __init__.py
│   └── explainable_response.py # XAI schema and parsing
├── database/
│   ├── __init__.py
│   ├── feedback_db.py          # Feedback storage
│   ├── evaluation_reports.py   # Report generation
│   └── feedback.db             # SQLite database
├── tools/
│   ├── monitoring_tools.py     # System monitoring
│   ├── security_tools.py       # Security functions
│   ├── compliance_tools.py     # OpenSCAP integration
│   └── abnormal_event_detector.py  # Event detection
├── graphs/
│   └── common.py               # LangGraph state and prompts
├── scripts/
│   └── daily_evaluation.py     # Scheduled report generation
├── reports/                    # Generated evaluation reports
├── logs/                       # Application logs
└── docs/                       # Documentation
```

---

## Explainable AI Schema

### Module: `models/explainable_response.py`

### ConfidenceLevel Enum

```python
class ConfidenceLevel(Enum):
    HIGH = "HIGH"       # 80-100% certainty
    MEDIUM = "MEDIUM"   # 50-79% certainty
    LOW = "LOW"         # Below 50% certainty
    UNKNOWN = "UNKNOWN" # Could not determine
```

### HumanReviewLevel Enum

```python
class HumanReviewLevel(Enum):
    REQUIRED = "REQUIRED"       # Must review before action
    RECOMMENDED = "RECOMMENDED" # Should review
    ROUTINE = "ROUTINE"         # Low risk, informational
    UNKNOWN = "UNKNOWN"         # Could not determine
```

### ExplainableResponse Dataclass

```python
@dataclass
class ExplainableResponse:
    # Identification
    response_id: str              # UUID for tracking
    timestamp: str                # ISO format timestamp

    # Content
    analysis: str                 # Main analysis text

    # Confidence Assessment
    confidence_level: ConfidenceLevel
    confidence_score: int         # 0-100 percentage
    confidence_justification: str

    # Explainability Elements
    evidence: List[str]           # Supporting observations
    alternative_hypotheses: List[str]  # Other explanations
    validation_steps: List[str]   # Verification commands

    # Human Review
    human_review_level: HumanReviewLevel
    human_review_reason: str

    # Action
    recommended_action: str

    # Metadata
    raw_response: str             # Original AI text
    parsing_successful: bool
    parsing_errors: List[str]
    query_type: str               # log_analysis, security_scan, etc.
    source_data: str              # What was analyzed
```

### Key Methods

| Method | Description |
|--------|-------------|
| `to_dict()` | Convert to dictionary for JSON serialization |
| `to_json()` | Convert to JSON string |
| `from_dict(data)` | Create instance from dictionary |
| `is_actionable()` | Check if response requires action |
| `requires_human_review()` | Check if human review needed |
| `get_summary()` | Get brief summary string |

---

## Response Parsing

### Function: `parse_ai_response()`

Parses raw AI text into structured `ExplainableResponse`.

```python
def parse_ai_response(
    raw_response: str,
    query_type: str = "",
    source_data: str = ""
) -> ExplainableResponse
```

**Regex Patterns Used:**

| Section | Pattern |
|---------|---------|
| Confidence | `\*\*Confidence:\*\*\s*(\w+)\s*\((\d+)%?\)` |
| Evidence | `\*\*Evidence:\*\*\s*\n((?:\s*\d+\.\s*.+\n?)+)` |
| Alternatives | `\*\*Alternative Hypotheses:\*\*\s*\n((?:\s*\d+\.\s*.+\n?)+)` |
| Validation | `\*\*Validation Steps:\*\*\s*\n((?:\s*\d+\.\s*.+\n?)+)` |
| Review | `\*\*Human Review:\*\*\s*(\w+)\s*[-–—]?\s*(.+?)` |

### Function: `format_explainable_response()`

Formats `ExplainableResponse` as human-readable markdown with color-coded icons.

```python
def format_explainable_response(response: ExplainableResponse) -> str
```

---

## Feedback System

### Module: `database/feedback_db.py`

### Database Schema

**Table: `ai_responses`**
```sql
CREATE TABLE ai_responses (
    id INTEGER PRIMARY KEY,
    response_id TEXT UNIQUE NOT NULL,
    timestamp TEXT NOT NULL,
    query_type TEXT,
    source_data_summary TEXT,
    confidence_level TEXT,
    confidence_score INTEGER,
    human_review_level TEXT,
    analysis_summary TEXT,
    evidence_count INTEGER,
    alternatives_count INTEGER,
    validation_steps_count INTEGER,
    parsing_successful INTEGER,
    raw_response_hash TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

**Table: `feedback`**
```sql
CREATE TABLE feedback (
    id INTEGER PRIMARY KEY,
    response_id TEXT NOT NULL,
    user_id TEXT NOT NULL,
    rating TEXT NOT NULL,           -- positive, negative, neutral
    issue_categories TEXT,          -- JSON array
    correction_text TEXT,
    actual_confidence_level TEXT,
    actual_outcome TEXT,
    timestamp TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (response_id) REFERENCES ai_responses(response_id)
);
```

**Table: `evaluation_metrics`**
```sql
CREATE TABLE evaluation_metrics (
    id INTEGER PRIMARY KEY,
    metric_date TEXT NOT NULL UNIQUE,
    total_responses INTEGER DEFAULT 0,
    positive_feedback_count INTEGER DEFAULT 0,
    negative_feedback_count INTEGER DEFAULT 0,
    avg_confidence_score REAL,
    confidence_calibration_error REAL,
    high_confidence_accuracy REAL,
    medium_confidence_accuracy REAL,
    low_confidence_accuracy REAL,
    common_issues TEXT,             -- JSON array
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
```

### FeedbackRating Enum

```python
class FeedbackRating(Enum):
    POSITIVE = "positive"   # Thumbs up
    NEGATIVE = "negative"   # Thumbs down
    NEUTRAL = "neutral"     # No opinion
```

### IssueCategory Enum

```python
class IssueCategory(Enum):
    FACTUAL_ERROR = "factual_error"
    SECURITY_CONCERN = "security_concern"
    OVERCONFIDENCE = "overconfidence"
    UNDERCONFIDENCE = "underconfidence"
    MISSING_CONTEXT = "missing_context"
    WRONG_HYPOTHESIS = "wrong_hypothesis"
    INCOMPLETE = "incomplete"
    FORMATTING = "formatting"
    OTHER = "other"
```

### Core Functions

| Function | Description |
|----------|-------------|
| `store_ai_response(response_data)` | Store AI response for tracking |
| `store_feedback(feedback)` | Store user feedback |
| `get_response_feedback(response_id)` | Get feedback for a response |
| `get_recent_responses(limit, query_type, has_feedback)` | Query responses |
| `calculate_confidence_calibration(days)` | Compare confidence to accuracy |
| `get_common_issues(days, limit)` | Get frequently reported issues |
| `generate_daily_metrics(date)` | Create daily aggregates |
| `get_metrics_history(days)` | Get historical metrics |
| `get_feedback_summary()` | Get overall statistics |

---

## Evaluation Metrics

### Module: `database/evaluation_reports.py`

### PerformanceMetrics Dataclass

```python
@dataclass
class PerformanceMetrics:
    period_start: str
    period_end: str
    total_responses: int
    total_feedback: int
    feedback_rate: float            # Percentage
    positive_rate: float            # Percentage
    negative_rate: float            # Percentage
    avg_confidence_score: float
    calibration_error: float        # Percentage
    responses_by_confidence: Dict[str, int]
    responses_by_query_type: Dict[str, int]
    top_issues: List[Dict[str, Any]]
```

### Calibration Calculation

Calibration error measures how well stated confidence matches actual accuracy:

```
Expected Accuracy by Level:
- HIGH: 85%
- MEDIUM: 65%
- LOW: 35%

Calibration Error = |Actual Accuracy - Expected Accuracy|
```

A well-calibrated model has calibration error < 10%.

### Report Functions

| Function | Description |
|----------|-------------|
| `get_performance_metrics(days)` | Comprehensive metrics |
| `get_calibration_report(days)` | Calibration analysis |
| `get_issue_trend_report(days)` | Issue patterns over time |
| `get_query_type_analysis(days)` | Performance by query type |
| `generate_compliance_report(days)` | CMMC/NIST documentation |
| `export_report_markdown(report)` | Export as markdown |
| `export_report_json(report)` | Export as JSON |

---

## Abnormal Event Detection

### Module: `tools/abnormal_event_detector.py`

### EventSeverity Enum

```python
class EventSeverity(Enum):
    CRITICAL = "CRITICAL"   # Immediate attention
    HIGH = "HIGH"           # Significant concern
    MEDIUM = "MEDIUM"       # Notable, may be benign
    LOW = "LOW"             # Informational
    INFO = "INFO"           # Normal activity
```

### EventCategory Enum

```python
class EventCategory(Enum):
    FAILED_LOGIN = "failed_login"
    DATA_TRANSFER = "data_transfer"
    USB_VIOLATION = "usb_violation"
    SELINUX_SECURITY = "selinux_security"
    PRIVILEGE_ESCALATION = "privilege_escalation"
    AFTER_HOURS_ACTIVITY = "after_hours_activity"
```

### AbnormalEvent Dataclass

```python
@dataclass
class AbnormalEvent:
    event_id: str
    timestamp: str
    category: EventCategory
    severity: EventSeverity
    summary: str
    details: str
    source_log: str
    raw_entries: List[str]

    # Explainable AI fields
    confidence_score: int
    evidence: List[str]
    alternative_hypotheses: List[str]
    validation_steps: List[str]
    recommended_action: str
    human_review_required: bool
```

### Detection Functions

| Function | Description |
|----------|-------------|
| `detect_failed_logins(since_minutes)` | SSH/PAM authentication failures |
| `detect_usb_violations(since_minutes)` | USBGuard policy violations |
| `detect_data_transfers(since_minutes)` | Suspicious outbound transfers |
| `detect_selinux_security_events(since_minutes)` | Security-sensitive denials |
| `run_full_detection(since_minutes)` | Run all detectors |
| `format_detection_report(results)` | Format as markdown |

### Detection Logic

**Failed Logins:**
- Pattern: 3+ failures from same IP
- Severity: HIGH if 10+ failures, MEDIUM if 3-9
- Confidence reduced for internal IPs

**USB Violations:**
- Pattern: Blocked device insertions
- Severity: HIGH if after-hours, MEDIUM otherwise
- Tracks policy modification attempts

**Data Transfers:**
- Pattern: External IP transfers via scp/rsync/curl
- Suricata alerts for large outbound flows (>100MB)
- Severity: HIGH if after-hours

**SELinux Security:**
- Sensitive patterns: shadow, passwd, ssh, sudoers, ptrace
- Severity: CRITICAL for shadow/sudoers access
- Filters routine probing denials

---

## Reporting Functions

### Scheduled Report Generation

**Script:** `scripts/daily_evaluation.py`

**Schedule:** Daily at 6:00 AM via systemd timer

**Alert Thresholds:**
```python
ALERT_THRESHOLDS = {
    "calibration_error_max": 25.0,
    "negative_rate_max": 40.0,
    "feedback_rate_min": 5.0,
}
```

**Functions:**

| Function | Description |
|----------|-------------|
| `generate_daily_report()` | Create daily metrics and reports |
| `check_thresholds(metrics)` | Check for alert conditions |
| `cleanup_old_reports(keep_days)` | Remove old reports |
| `get_trend_data(days)` | Get data for charts |
| `generate_weekly_summary()` | Create weekly summary text |

### Report Output

**Location:** `/data/ai-workspace/sysadmin-agent/reports/`

**Files Generated:**
- `evaluation_report_YYYYMMDD.json` - Machine-readable
- `evaluation_report_YYYYMMDD.md` - Human-readable

**Retention:** 90 days

---

## Configuration

### System Prompt Location

**File:** `graphs/common.py`

**Key Sections:**
- Server environment details
- Security posture (SELinux, FIPS, firewall)
- Log analysis guidelines
- Explainable AI requirements format
- Available tools list

### Dashboard Configuration

**File:** `config/config.py`

**Key Settings:**
```python
LLM_BASE_URL = "https://192.168.1.7:11443/v1"
LLM_MODEL = "llama3.3:70b-instruct-q4_K_M"
LLM_TEMPERATURE = 0.1
LLM_MAX_TOKENS = 4096
```

### Systemd Services

**Dashboard Service:**
```
/etc/systemd/system/sysadmin-agent.service
```

**Evaluation Timer:**
```
/etc/systemd/system/sysadmin-agent-eval.timer
/etc/systemd/system/sysadmin-agent-eval.service
```

---

## API Reference

### Dashboard Session State

| Key | Type | Description |
|-----|------|-------------|
| `messages` | List[dict] | Chat history |
| `ai_responses` | List[dict] | Parsed AI responses |
| `show_approval_dialog` | bool | Approval dialog visibility |
| `pending_command` | str | Command awaiting approval |
| `show_alert_details` | bool | Alert view visibility |
| `cached_alerts` | dict | Cached detection results |
| `show_feedback_form` | str | Response ID for feedback |
| `show_evaluation_report` | bool | Report view visibility |
| `export_compliance_report` | bool | Export dialog visibility |

### Audit Event Types

| Event Type | Description |
|------------|-------------|
| `USER_QUERY` | User submitted a question |
| `AI_RESPONSE` | AI generated a response |
| `COMMAND_APPROVED` | User approved command execution |
| `COMMAND_REJECTED` | User rejected command |
| `COMMAND_EXECUTED` | Command was executed |
| `FEEDBACK_SUBMITTED` | User submitted feedback |
| `COMPLIANCE_REPORT_GENERATED` | Report was generated |
| `USB_BLOCKED` | USB device was blocked |

---

## Compliance Mapping

### NIST 800-171 Controls

| Control | Implementation |
|---------|----------------|
| 3.3.1 - Audit Events | All AI responses and actions logged |
| 3.3.2 - Audit Content | Timestamps, user IDs, event details |
| 3.4.1 - Baseline Config | System prompt defines security baseline |
| 3.5.1 - Identify Users | User ID tracked in feedback |
| 3.6.1 - Incident Handling | Abnormal event detection |
| 3.14.6 - Monitor Systems | Continuous health and security monitoring |

### CMMC Level 2 Practices

| Practice | Implementation |
|----------|----------------|
| AU.L2-3.3.1 | Comprehensive audit logging |
| CA.L2-3.12.1 | Continuous evaluation reports |
| IR.L2-3.6.1 | Security alert detection |
| SI.L2-3.14.6 | Real-time monitoring dashboard |

---

*This reference is part of the SysAdmin Agent Dashboard technical documentation.*
