"""Core AI agent implementation using LangChain and Ollama"""
from typing import List, Dict, Any, Optional
from langchain.agents import AgentExecutor, create_react_agent
from langchain.tools import Tool
from langchain_community.llms import Ollama
from langchain.prompts import PromptTemplate
from core.config import config
from tools.system_tools import SystemTools
from tools.audit import audit_log
import json


class CyberHygieneAgent:
    """AI agent for system administration"""

    def __init__(self):
        """Initialize the agent"""
        # Initialize Ollama LLM
        self.llm = Ollama(
            base_url=config.ollama.host,
            model=config.ollama.model,
            temperature=config.ollama.temperature,
        )

        # Create tools
        self.tools = self._create_tools()

        # Create agent
        self.agent_executor = self._create_agent()

        audit_log("AGENT_INITIALIZED", {
            "model": config.ollama.model,
            "host": config.ollama.host,
            "tools_count": len(self.tools)
        })

    def _create_tools(self) -> List[Tool]:
        """Create the tools available to the agent"""
        return [
            Tool(
                name="execute_command",
                func=lambda cmd: SystemTools.execute_command(cmd, approved=False),
                description="""Execute a system command. Use this to run Linux commands like 'systemctl status', 'df -h', 'ps aux', etc.
                Input should be a valid shell command string.
                Some commands may require approval before execution.
                Example: execute_command("systemctl status wazuh-manager")"""
            ),
            Tool(
                name="read_file",
                func=lambda path: SystemTools.read_file(path),
                description="""Read contents of a file. Use this to read log files, configuration files, etc.
                Input should be a valid file path.
                Example: read_file("/var/log/messages")"""
            ),
            Tool(
                name="read_file_tail",
                func=lambda args: self._read_file_tail(args),
                description="""Read last N lines of a file. Useful for recent log entries.
                Input should be JSON: {"path": "/path/to/file", "lines": 50}
                Example: read_file_tail('{"path": "/var/log/secure", "lines": 100}')"""
            ),
            Tool(
                name="get_system_status",
                func=lambda _: json.dumps(SystemTools.get_system_status(), indent=2),
                description="""Get comprehensive system status including CPU, memory, disk, network, and uptime.
                No input required - just call get_system_status("")
                Returns JSON with current system metrics."""
            ),
            Tool(
                name="list_directory",
                func=lambda path: "\n".join(SystemTools.list_directory(path)),
                description="""List contents of a directory with file sizes and modification times.
                Input should be a directory path.
                Example: list_directory("/var/log")"""
            ),
        ]

    def _read_file_tail(self, args_json: str) -> str:
        """Helper to parse JSON args for read_file_tail"""
        try:
            args = json.loads(args_json)
            return SystemTools.read_file(args["path"], lines=args.get("lines", 50), tail=True)
        except Exception as e:
            return f"Error parsing arguments: {e}. Expected JSON with 'path' and optionally 'lines'"

    def _create_agent(self) -> AgentExecutor:
        """Create the ReAct agent"""
        template = """You are CyberHygiene AI Admin Assistant, an expert system administrator for a NIST 800-171 compliant Rocky Linux 9 environment.

Your mission: Help the user monitor, troubleshoot, and maintain their secure infrastructure.

You have access to these tools:
{tools}

Tool names: {tool_names}

CRITICAL FORMAT RULES:
1. Action line must contain ONLY the tool name - no arguments, no parentheses
2. Action Input line contains the argument as plain text
3. Do NOT use function call syntax like "tool_name(argument)"

CORRECT FORMAT EXAMPLES:

Example 1 - Check disk space:
Question: What is the disk usage?
Thought: I need to run the df command to check disk space
Action: execute_command
Action Input: df -h
Observation: [command output]
Thought: I now have the disk usage information
Final Answer: The disk usage is...

Example 2 - Get system status:
Question: What is the system status?
Thought: I should get comprehensive system metrics
Action: get_system_status
Action Input:
Observation: [JSON metrics]
Thought: I have the system metrics
Final Answer: The system is...

Example 3 - Read log file:
Question: Show recent security logs
Thought: I need to read the secure log
Action: read_file_tail
Action Input: {{"path": "/var/log/secure", "lines": 50}}
Observation: [log contents]
Thought: I have the log entries
Final Answer: Recent security events show...

WRONG FORMAT (DO NOT USE):
Action: execute_command("df -h")  ❌ NO! Do not use parentheses
Action: get_system_status()  ❌ NO! Tool name only

When responding to questions:
1. Think step by step about what information you need
2. Use tools to gather that information (follow format exactly!)
3. Analyze the results
4. Provide clear, actionable answers

Begin!

Question: {input}
Thought: {agent_scratchpad}"""

        prompt = PromptTemplate.from_template(template)

        agent = create_react_agent(
            llm=self.llm,
            tools=self.tools,
            prompt=prompt
        )

        return AgentExecutor(
            agent=agent,
            tools=self.tools,
            verbose=config.verbose,
            max_iterations=config.max_iterations,
            handle_parsing_errors=True
        )

    def run(self, query: str) -> str:
        """
        Run the agent with a user query.

        Args:
            query: User's question or request

        Returns:
            Agent's response
        """
        audit_log("AGENT_QUERY", {"query": query})

        try:
            result = self.agent_executor.invoke({"input": query})
            response = result.get("output", "No response generated")

            audit_log("AGENT_RESPONSE", {
                "query": query,
                "response_length": len(response)
            })

            return response

        except Exception as e:
            error_msg = f"Error processing request: {str(e)}"
            audit_log("AGENT_ERROR", {
                "query": query,
                "error": str(e)
            })
            return error_msg

    def chat(self, message: str, context: Optional[List[Dict]] = None) -> str:
        """
        Chat interface with conversation context.

        Args:
            message: User message
            context: Previous conversation context (optional)

        Returns:
            Agent response
        """
        # For now, just use run() - can be enhanced with memory later
        return self.run(message)
