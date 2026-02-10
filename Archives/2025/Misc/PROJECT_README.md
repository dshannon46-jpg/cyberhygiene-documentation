# SysAdmin Agent Dashboard

**AI-Assisted System Administration with Explainable AI**

A secure, CMMC Level 2 / NIST 800-171 compliant dashboard for AI-assisted Linux system administration. Features transparent AI responses with confidence scores, evidence-based reasoning, and continuous model evaluation.

---

## Features

### Core Capabilities
- **System Health Monitoring** - Real-time CPU, memory, disk, and service status
- **AI-Powered Log Analysis** - Intelligent analysis with explainable reasoning
- **Security Alerting** - Automated detection of failed logins, USB violations, data transfers
- **Compliance Scanning** - OpenSCAP integration for NIST 800-171 profiles
- **Human-in-the-Loop** - All high-impact actions require explicit approval

### Explainable AI
- **Confidence Scores** - HIGH/MEDIUM/LOW with percentage (0-100%)
- **Evidence** - Specific log entries and observations supporting analysis
- **Alternative Hypotheses** - Other plausible explanations to consider
- **Validation Steps** - Commands to verify the analysis
- **Human Review Flags** - REQUIRED/RECOMMENDED/ROUTINE indicators

### Continuous Evaluation
- **Feedback Collection** - Thumbs up/down ratings with detailed issue reporting
- **Calibration Tracking** - Compare stated confidence to actual accuracy
- **Trend Analysis** - Historical charts of performance metrics
- **Compliance Reporting** - Automated daily reports for audit documentation

---

## Quick Start

### Access the Dashboard
```
https://dc1.cyberinabox.net/sysadmin/
```

### Check Service Status
```bash
systemctl status sysadmin-agent.service
systemctl status sysadmin-agent-eval.timer
```

### View Logs
```bash
journalctl -u sysadmin-agent.service -f
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                  SysAdmin Agent Dashboard                    │
├─────────────────────────────────────────────────────────────┤
│   Streamlit UI  →  LangGraph Workflow  →  Ollama LLM        │
│                          ↓                                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Explainable AI │ Feedback DB │ Eval Reports │ Alerts│   │
│   └─────────────────────────────────────────────────────┘   │
│                          ↓                                   │
│   SQLite (feedback.db) │ Audit Logs │ Evaluation Reports    │
└─────────────────────────────────────────────────────────────┘
```

---

## Directory Structure

```
/data/ai-workspace/sysadmin-agent/
├── app.py                          # Main Streamlit application
├── config/config.py                # Configuration settings
├── models/
│   └── explainable_response.py     # XAI schema and parsing
├── database/
│   ├── feedback_db.py              # Feedback storage
│   ├── evaluation_reports.py       # Report generation
│   └── feedback.db                 # SQLite database
├── tools/
│   ├── monitoring_tools.py         # System monitoring
│   ├── security_tools.py           # Security functions
│   ├── compliance_tools.py         # OpenSCAP integration
│   └── abnormal_event_detector.py  # Event detection
├── graphs/common.py                # LangGraph state and prompts
├── scripts/daily_evaluation.py     # Scheduled reporting
├── reports/                        # Generated reports (90-day retention)
├── logs/                           # Application and alert logs
└── docs/                           # Documentation
    ├── USER_MANUAL.md
    └── AI_FUNCTIONS_REFERENCE.md
```

---

## Technology Stack

| Component | Technology |
|-----------|------------|
| Frontend | Streamlit |
| AI Framework | LangChain / LangGraph |
| LLM | Llama 3.3 70B Instruct (via Ollama) |
| Database | SQLite |
| Scheduling | systemd timers |
| Security | SELinux, USBGuard, Wazuh, Suricata |

---

## Configuration

### LLM Settings (`config/config.py`)
```python
LLM_BASE_URL = "https://192.168.1.7:11443/v1"
LLM_MODEL = "llama3.3:70b-instruct-q4_K_M"
LLM_TEMPERATURE = 0.1
LLM_MAX_TOKENS = 4096
```

### Alert Thresholds (`scripts/daily_evaluation.py`)
```python
ALERT_THRESHOLDS = {
    "calibration_error_max": 25.0,    # Alert if > 25%
    "negative_rate_max": 40.0,        # Alert if > 40%
    "feedback_rate_min": 5.0,         # Alert if < 5%
}
```

---

## Systemd Services

### Dashboard Service
```bash
# Status
systemctl status sysadmin-agent.service

# Restart
systemctl restart sysadmin-agent.service

# Logs
journalctl -u sysadmin-agent.service -f
```

### Daily Evaluation Timer
```bash
# Status
systemctl status sysadmin-agent-eval.timer

# Next run
systemctl list-timers sysadmin-agent-eval.timer

# Manual run
systemctl start sysadmin-agent-eval.service
```

---

## Compliance

### NIST 800-171 Controls Addressed
- **3.3.1** - Audit Events (AI response logging)
- **3.3.2** - Audit Content (timestamps, user IDs, event details)
- **3.4.1** - Baseline Configuration (security-aware system prompt)
- **3.6.1** - Incident Handling (abnormal event detection)
- **3.14.6** - Monitor Systems (continuous health monitoring)

### CMMC Level 2 Practices
- **AU.L2-3.3.1** - Comprehensive audit logging
- **CA.L2-3.12.1** - Continuous evaluation and assessment
- **IR.L2-3.6.1** - Security incident detection
- **SI.L2-3.14.6** - Real-time monitoring

---

## Documentation

- [User Manual](docs/USER_MANUAL.md) - End-user guide
- [AI Functions Reference](docs/AI_FUNCTIONS_REFERENCE.md) - Technical documentation

---

## License

Internal use only. CMMC Level 2 / NIST 800-171 compliant.

---

*SysAdmin Agent Dashboard v2.0*
*Last Updated: January 31, 2026*
