---
name: personal-tmux-devmode
description: Detect and inspect dev servers running in tmux panes. Use this skill whenever the user reports a dev mode issue, build error, compilation failure, runtime error, HMR problem, or any issue that might show up in a dev server's terminal output. Also use when the user mentions "the dev server", "dev mode", "the terminal", "the console output", errors appearing in their running process, or asks you to check what's happening in tmux. Triggers include phrases like "it's not working", "there's an error", "the page is broken", "check the logs", "what does the dev server say", "HMR is stuck", "build failed", or any troubleshooting scenario where a running dev process might have relevant output.
---

# Tmux Dev Mode Inspector

## Overview

This skill lets you detect whether you're running inside tmux and inspect dev server processes running in other tmux panes. This is extremely valuable for troubleshooting — when the user reports an issue with their running app, you can look directly at the dev server's terminal output to see errors, warnings, and stack traces instead of guessing.

## When to Use

- User reports something is broken, erroring, or not working as expected
- User mentions a dev server, build process, or running process
- User asks you to check logs, console output, or terminal output
- After making code changes that should trigger HMR/rebuild, to verify the dev server picked them up
- When debugging runtime errors that would show in the dev server console

## Step 1: Detect Tmux

Check if you're inside tmux:

```bash
# Quick check — if $TMUX is set, we're inside tmux
echo "$TMUX"
```

If `$TMUX` is empty, you're not in tmux and this skill doesn't apply — let the user know and suggest they run the dev server so you can inspect it, or ask them to paste the error output.

## Step 2: Discover Panes and Dev Processes

List all tmux panes across all sessions with their running command and working directory:

```bash
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} | cmd=#{pane_current_command} | path=#{pane_current_path} | pid=#{pane_pid}'
```

This gives you a full picture of every pane. Look for dev server processes by their command name. Common patterns:

| Command | Likely Dev Server |
|---------|-------------------|
| `node` | Next.js, Vite, Express, Webpack, etc. |
| `bun` | Bun dev server (Vite, Astro, etc.) |
| `deno` | Deno dev server |
| `npm`, `pnpm`, `yarn` | Package manager running a dev script |
| `vite` | Vite dev server directly |
| `next` | Next.js dev server |
| `cargo` | Cargo watch or cargo run |
| `python`, `python3` | Flask, Django, FastAPI dev servers |
| `ruby` | Rails server, etc. |
| `go` | Go run or air (hot reload) |
| `java`, `gradle`, `mvn` | JVM dev servers |
| `docker` | Docker compose up |

**Important:** The `pane_current_command` shows the foreground process name, which might be a shell (like `zsh` or `bash`) if the dev server runs as a child process. In that case, check the process tree:

```bash
# Get the full process tree for a pane's PID
pstree -p <pane_pid>
```

This reveals child processes — a `zsh` pane might have `bun` → `vite` running underneath.

## Step 3: Match Dev Server to Current Project

Compare the pane's working directory (`pane_current_path`) with your current working directory. The dev server most relevant to the user is typically:

1. **Same directory** — running in the exact same project root
2. **Parent/child path** — e.g., dev server running in a monorepo app subdirectory
3. **Same session** — if no path match, panes in the same tmux session are more likely related

```bash
# Get current working directory for comparison
pwd

# List panes filtered to current session (if you know the session name)
tmux list-panes -s -F '#{window_index}.#{pane_index} | cmd=#{pane_current_command} | path=#{pane_current_path}'
```

## Step 4: Capture Dev Server Output

Once you've identified the relevant pane, capture its scrollback buffer to read the actual output:

```bash
# Capture the last 100 lines of visible + scrollback output
tmux capture-pane -t <session>:<window>.<pane> -p -S -100

# Capture more history if needed (up to scrollback limit)
tmux capture-pane -t <session>:<window>.<pane> -p -S -500

# Capture the entire scrollback buffer
tmux capture-pane -t <session>:<window>.<pane> -p -S -
```

**Target format:** `session_name:window_index.pane_index` — e.g., `dev:1.3`

### Reading the Output

Look for:
- **Error messages** — stack traces, compilation errors, TypeScript errors
- **Warnings** — deprecation notices, missing dependencies
- **HMR status** — "page reload", "hmr update", connection issues
- **Build output** — success/failure, timing info
- **Network info** — what port the server is on, connection status

### Capturing Large Output

If the scrollback has a lot of content and you need to search it:

```bash
# Capture to a temp file and search
tmux capture-pane -t <target> -p -S - > /tmp/devserver-output.txt
rg "error|Error|ERROR|warning|Warning|WARN|failed|Failed" /tmp/devserver-output.txt
```

## Step 5: Act on What You Find

Based on the captured output:

- **Compilation/build errors** — Fix the code and explain the issue
- **Runtime errors** — Diagnose the root cause from the stack trace
- **HMR issues** — Sometimes a manual restart is needed; let the user know
- **No errors visible** — The issue might be in the browser console instead, or the scrollback may have been cleared. Let the user know what you checked and suggest next steps.
- **Dev server not running** — Let the user know you don't see a dev server for their project and suggest starting one.

## Quick Reference

```bash
# Am I in tmux?
[ -n "$TMUX" ] && echo "yes" || echo "no"

# List all panes with commands and paths
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} cmd=#{pane_current_command} path=#{pane_current_path}'

# Capture last N lines from a pane
tmux capture-pane -t SESSION:WIN.PANE -p -S -N

# Get process tree for a pane
pstree -p $(tmux display-message -t SESSION:WIN.PANE -p '#{pane_pid}')

# Search captured output for errors
tmux capture-pane -t SESSION:WIN.PANE -p -S - | rg -i "error|warn|fail"
```

## Tips

- After you make code changes, it's good practice to check the dev server pane to confirm the rebuild succeeded before telling the user the fix is in place.
- If there are multiple dev servers (e.g., monorepo with frontend + backend), check all relevant panes.
- The scrollback buffer has a finite size (usually 2000-10000 lines depending on config). Very old output may be gone.
- If the pane shows a shell prompt with no running process, the dev server may have crashed. Check the last output above the prompt for the crash message.
