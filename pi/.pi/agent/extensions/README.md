# Pi Agent Extensions

## Conversation Mode Extension

Located: `conversation-mode/` (directory with index.ts + utils.ts)

### Purpose
Read-only exploration mode for safe code analysis. When enabled, only read-only tools are available and bash is restricted to an allowlist of safe commands. The agent creates a numbered plan that can then be executed with progress tracking.

### How It Works

**Conversation Mode (Read-Only):**
- Uses `setActiveTools()` to restrict to: read, bash, grep, find, ls, questionnaire
- Bash commands filtered through a comprehensive allowlist (safe) / blocklist (destructive)
- System prompt injection tells the LLM about restrictions
- Agent creates a plan without making changes

**Execution Mode:**
- Full tool access restored
- Agent executes plan steps in order
- `[DONE:n]` markers track completion
- Progress widget shows status in footer and above editor

### Usage

**Toggle conversation mode:**
- `/conversation` command
- `Tab` shortcut
- `--conversation` CLI flag

**Show plan progress:**
- `/todos` command

**After the agent creates a plan, choose:**
- Execute the plan (track progress)
- Stay in conversation mode
- Refine the plan

### Session Persistence
State (enabled, todos, execution progress) persists across session resume via `appendEntry`.

### Auto-Discovery
This extension is automatically loaded from `~/.pi/agent/extensions/` when pi starts.
