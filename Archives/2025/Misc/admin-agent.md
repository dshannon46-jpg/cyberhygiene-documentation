# SysAdmin Agent Dashboard Architecture  
**Purpose**: Build a secure, local, production-grade dashboard front-end for a surrogate system administrator agent powered by LangGraph.  
The dashboard runs on a hardened RHEL server (FIPS-enabled)192.168.1.10, connects via local API to Llama 3.3 70B Instruct hosted on a Mac M4 Pro 192.168.1.7.  
It supports NIST SP 800-171 / CMMC compliance through human-in-the-loop, full audit logging, least privilege, and no cloud dependencies.
It Communicates using FIPS 140 approved methods.

## High-Level Goals
- **UI Layout**: Modern dashboard with:
  - Top: Grid of clickable "tiles" (cards/buttons) for common, predefined sysadmin actions.
  - Bottom: Persistent interactive chat window for natural-language queries, follow-ups, and guidance.
- **Backend**: LangGraph graphs orchestrate agent logic (planning, tool use, reflection, execution).
- **Key Principles**:
  - Human oversight for all high-impact actions (e.g., installs, config changes, backups).
  - Every action logged with timestamp, user, agent decision path, tool calls, and outcome.
  - Stateful sessions (conversation + workflow resumption).
  - Secure: Local-only API calls, restricted shell execution, input validation.

## Core Components & Tech Stack
- **Frontend Framework**: Streamlit (lightweight, Python-native, easy to secure/audit).
  - Use `st.columns`, `st.container`, `st.expander` for responsive tile grid.
  - Use `st.chat_input` + `st.chat_message` for the chat window.
  - Session state (`st.session_state`) for thread_id, chat history, active workflow.
- **Backend Orchestration**: LangGraph (stateful graphs with checkpointer).
  - Use `MemorySaver` or SQLite/Postgres checkpointer for persistence.
  - Graphs support conditional edges, human interrupts, tool calls.
- **LLM Backend**: OpenAI-compatible API to local Ollama/Llama 3.3 70B (http://<mac-ip>:11434/v1).
- **Tools**: Custom LangChain/LangGraph tools for:
  - Shell execution (subprocess with sudo/logging/whitelist).
  - File read/write (logs, configs).
  - Monitoring (psutil, journalctl parsing).
  - Backup (rsync to NAS).
  - All tools log inputs/outputs and require approval for privileged ops.
- **Additional Libraries**:
  - `langgraph`, `langchain-core`, `langchain-community` (tools).
  - `pydantic` for state schema.
  - `logging` + `auditd` integration for CMMC evidence.
  - Optional: `streamlit-authenticator` or simple password for access control.

## Recommended File Structure
# SysAdmin Agent Dashboard Architecture  
├── app.py                  # Main Streamlit entry point (dashboard UI)
├── graphs/
│   ├── init.py
│   ├── common.py           # Shared utilities, state schema, tools
│   ├── backup_graph.py     # Graph for NAS backup workflow
│   ├── update_graph.py     # Graph for document/package updates
│   ├── log_synopsis_graph.py # Graph for log summarization
│   └── general_agent_graph.py # ReAct-style graph for chat queries
├── tools/
│   ├── init.py
│   ├── shell_tool.py       # Audited subprocess wrapper
│   ├── monitoring_tools.py # psutil, log readers, etc.
│   └── backup_tools.py     # rsync, tar, etc.
├── config/
│   └── config.py           # LLM endpoint, allowed commands, log paths
├── logs/                   # Agent action logs (for audit)
└── requirements.txt
## State Schema (TypedDict or Pydantic)
```python
from typing_extensions import TypedDict, Annotated
from langchain_core.messages import BaseMessage
from langgraph.graph.message import add_messages

class AgentState(TypedDict):
    messages: Annotated[list[BaseMessage], add_messages]     # Chat history
    user_id: str                                             # For audit
    thread_id: str                                           # LangGraph thread
    current_task: str                                        # e.g., "backup_nas"
    decision_log: list[str]                                  # For explainability/audit
    needs_approval: bool
    approval_granted: bool
    tool_output: dict                                        # Last tool result
    server_status: dict                                      # Cached metrics