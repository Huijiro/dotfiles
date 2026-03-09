# Conversation Mode Extension

Read-only exploration mode for safe code analysis.

## Features

- **Read-only tools**: Restricts available tools to read, bash, grep, find, ls, questionnaire
- **Bash allowlist**: Only read-only bash commands are allowed
- **Plan extraction**: Extracts numbered steps from `Plan:` sections
- **Progress tracking**: Widget shows completion status during execution
- **[DONE:n] markers**: Explicit step completion tracking
- **Todo integration**: Plan steps are managed by the todo extension via its event bus
- **Session persistence**: State survives session resume

## Commands

- `/conversation` - Toggle conversation mode
- `/todos` - Show current plan progress (provided by the todo extension)
- `Tab` - Toggle conversation mode (shortcut)

## Usage

1. Enable conversation mode with `/conversation` or `--conversation` flag
2. Ask the agent to analyze code and create a plan
3. The agent should output a numbered plan under a `Plan:` header:

```
Plan:
1. First step description
2. Second step description
3. Third step description
```

4. Choose "Execute the plan" when prompted
5. During execution, the agent marks steps complete with `[DONE:n]` tags
6. Progress widget shows completion status

## How It Works

### Conversation Mode (Read-Only)
- Only read-only tools available (via `setActiveTools`)
- Bash commands filtered through allowlist
- Agent creates a plan without making changes
- System prompt injection tells the LLM about restrictions

### Execution Mode
- Full tool access restored
- Agent executes steps in order
- `[DONE:n]` markers track completion
- Widget shows progress
- Completion message shown when all steps done

### Todo Integration

Plan steps are imported into the **todo extension** via `pi.events`:

- `todo:import` — Bulk import plan steps as todos
- `todo:complete` — Mark steps done when `[DONE:n]` is detected
- `todo:clear` — Clear todos when a new plan is created
- `todo:get` — Query current todo state for widget/status display

This means `/todos` shows both manually added todos and plan steps in a
single unified view.

### Command Allowlist

Safe commands (allowed):
- File inspection: `cat`, `head`, `tail`, `less`, `more`
- Search: `grep`, `find`, `rg`, `fd`
- Directory: `ls`, `pwd`, `tree`
- Git read: `git status`, `git log`, `git diff`, `git branch`
- Package info: `npm list`, `npm outdated`, `yarn info`
- System info: `uname`, `whoami`, `date`, `uptime`

Blocked commands:
- File modification: `rm`, `mv`, `cp`, `mkdir`, `touch`
- Git write: `git add`, `git commit`, `git push`
- Package install: `npm install`, `yarn add`, `pip install`
- System: `sudo`, `kill`, `reboot`
- Editors: `vim`, `nano`, `code`
