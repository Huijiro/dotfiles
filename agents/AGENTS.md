# Agent Guidelines

## File Operations Tools

### Search & Discovery
When finding and grepping files, prefer using:
- **`rg` (ripgrep)**: For fast, pattern-based file searching and grepping
- **`fd`**: For efficient file discovery and filtering

These tools are faster and more user-friendly than their traditional counterparts (`grep` and `find`).

### Viewing Files
- **`bat`**: Use `bat` instead of `cat` for viewing file contents, with syntax highlighting and line numbers

### Understanding Commands
- **`tldr`**: Use `tldr` instead of `man` to quickly understand how commands work with practical examples

### Editing & Transformation
- **`sd`**: Modern find-and-replace tool, simpler and faster than sed for text substitution
- **`ast-grep`**: AST-based code searching and refactoring across multiple files with syntax awareness
- **`parallel`**: Run commands on multiple files concurrently for bulk operations

### Batch Processing
- **`parallel`**: Execute operations in parallel on multiple files to speed up bulk transformations

## Programming Guidelines

### Code Change Discipline
- Make the smallest change that solves the problem.
- Don't refactor unrelated code while passing through.
- Match the surrounding style: naming, indentation, error handling, file layout.
- Don't introduce abstractions (helpers, wrappers, config layers) until there are 2–3 concrete callers.
- Prefer editing existing files over creating new ones.
- Don't rename, move, or reformat files unless asked.
- When code already exists that does what you need, move or copy it instead of rewriting it from scratch. Cut-and-paste (for relocations) or copy-and-paste (for reuse) preserves the original logic, comments, and edge-case handling that a from-scratch rewrite tends to silently drop. Don't retype from memory.
  - Default flow: `read` the source range, then `edit` the destination with that text verbatim. For a relocation, follow with a second `edit` that removes the original.
  - For syntax-aware moves of whole functions/classes/blocks across files, use `ast-grep` to match by AST shape rather than line ranges.
  - For large literal blocks where `edit` is awkward, `sed -n 'X,Yp' src >> dst` (or `head`/`tail`) is acceptable as a transport, but verify the result by reading the destination after.
  - For mechanical literal substitutions across many files, `sd` (often with `parallel`) beats hand-editing each site.
  - When the source is a running process rather than a file (REPL output, server log), pull it with `tmux capture-pane -p` and paste into the destination — don't reconstruct it.
  - System clipboard is `wl-copy` / `wl-paste` (Wayland; xclip/pbcopy are not installed). Only reach for it when handing a snippet to the user, not for in-repo moves.

### Before Writing Code
- Read the relevant files first. Don't guess at APIs, signatures, or types.
- Check how a function or pattern is already used in the repo before adding a new one.
- For non-trivial changes, state the plan in 1–3 lines before editing.
- Surface assumptions explicitly ("assuming X, I'll do Y") instead of silently choosing.

### Planning & Task Tracking
Match the planning tool to the size of the work. Don't over-plan trivial changes; don't under-plan big ones.

**Trivial / single-step tasks**
- No formal plan. Just do it and report back.

**Genuinely complex tasks** (multi-file, multi-stage, or non-obvious sequencing)
- Use the `todo` tool to track steps as you go.
- Add todos before starting; mark them done as you complete each.
- Don't pad it with one-liners just to look thorough.

**Big-scope features or refactors** (anything you'd describe as "a project" — new subsystems, large migrations, multi-day work, anything likely to span sessions)
- Create a `PLAN.md` at the project root.
- Structure: goal, scope (in/out), milestones with checkboxes, open questions, decisions log.
- Update it as work progresses: tick off completed items, log decisions with a date, capture new questions.
- Read `PLAN.md` first when resuming such work in a later session.
- **Delete `PLAN.md` once the plan is fully executed.** It is a working document, not a permanent artifact — don't leave stale plans in the repo.

**General planning rules**
- State the plan before editing for anything beyond a trivial change.
- If the plan changes mid-task, say so before pivoting.
- Don't invent scope. Plans capture what was agreed, not wishlist additions.

### Comments & Documentation
- Comments explain *why*, not *what*.
- No narration of obvious code (`// increment counter`, `// loop through items`).
- No filler or apology comments (`// TODO: improve later`, `// this might need work`).
- Keep docstrings short and factual. Drop them if the signature is self-explanatory.
- Don't leave commented-out code behind.

### Error Handling
- Don't swallow errors with empty `catch` / `pcall` / `except: pass`.
- Either handle the error meaningfully or let it propagate.
- Log at boundaries (entry points, IO edges), not at every layer.
- Don't catch broad exception types just to silence them.

### Don't Reinvent
- Use the language's stdlib before writing custom loops, parsers, or utilities (e.g. `Array.prototype.*`, `pathlib`, `vim.fs`, `vim.iter`).
- Check the project for existing helpers before adding a parallel one.
- Don't rebuild a framework feature — use what the framework already provides.
- If you find yourself writing something that feels generic, search first; it probably exists.

### Typing (Optionally-Typed Languages)
Applies to TypeScript, Python (with type hints), Lua (with annotations), PHP, Ruby (RBS/Sorbet), etc.
- Always add proper, specific types. Don't rely on inference where an explicit annotation aids readers.
- Never use `any` (or equivalents like `Object`, `Function`, untyped `dict`). For truly unknown values, use `unknown` (TS) / `object` (Py) and narrow with type guards before use.
- No type casting (`as`, `<T>`, `cast()`, `@ts-ignore`, `# type: ignore`) to silence the checker. Fix the underlying type instead.
- If a cast is truly unavoidable (e.g. crossing an untyped boundary), narrow it to the smallest scope and add a one-line comment explaining why.
- Prefer discriminated unions, generics, and narrowing over broad types.
- Don't widen types to make errors go away. Don't make fields optional just to avoid initializing them.
- Treat type-checker warnings as errors. No new red squiggles.

### Dependencies
- Don't add a dependency for something the stdlib or existing deps already do.
- Justify new dependencies briefly when adding them.
- Pin or note versions; don't introduce floating `latest`.
- Don't pull in large libraries for a one-line utility.

### Git
- **Authentication failures mean the user is AFK, not that the command is wrong.** If `git push`, `git pull`, `git fetch`, or any remote operation fails with an auth/credential/2FA/SSH error, stop immediately. Do not retry. Do not try alternate auth methods. Report the failure and wait for the user to unblock it before trying again.
- **Re-check repo state before doing git work.** The user may have committed, pulled, switched branches, or rebased between agent runs. Before staging, committing, or pushing, briefly run `git status`, `git branch --show-current`, and `git log --oneline -n 5` (and `git fetch` + compare with `@{u}` when remote state matters). Don't act on a stale mental model of the repo.
- Never commit secrets, tokens, `.env` files, or large binaries.
- Don't rewrite shared history (`push --force`, interactive rebase on pushed branches) without explicit permission.

### Testing & Verification
- After edits, run the project's lint / typecheck / test command if one exists (check `package.json`, `Makefile`, `justfile`, `pyproject.toml`, etc.).
- Don't claim a task is done without at least reading back the changed file or running it.
- When fixing a bug, reproduce it first if feasible.
- Don't disable, skip, or weaken tests to make them pass.
- **Test fixture strings**: Prefer long, obviously fake text (for example `THISISAVERYLONGANDVERYOBVIOUSTESTVALUE`) over random-looking characters, base64, PEM blocks, or secret-shaped literals. Obvious test values avoid gitleaks false positives and make intent clear.

### Running Inside Tmux
If `$TMUX` is set, the agent is running inside a tmux session — and the user almost certainly has other panes with relevant context (dev servers, REPLs, log tails, build watchers, related shells).

- **Check for tmux at the start of any non-trivial debugging or runtime task** with `[ -n "$TMUX" ] && echo yes`.
- When inside tmux, list panes (`tmux list-panes -a -F '...'`) to see what's running before asking the user about errors, server state, or output. The answer is often already on screen.
- Match panes to the current project by `pane_current_path` and inspect their scrollback with `tmux capture-pane -p -S -N` instead of asking the user to paste output.
- Use this proactively after code changes that should trigger a rebuild/HMR — verify the dev server picked them up rather than assuming.
- For full procedure (process tree, target syntax, search patterns), load the `personal-tmux-devmode` skill.
- Don't start a new dev server if one is already running in another pane for the same project.
- Don't send keystrokes or commands into other panes unless the user asks for it.

### Communication Style
- Be concise. Don't restate the request back.
- When uncertain between two reasonable approaches, ask one short question instead of guessing.
- Report what was actually done, including anything skipped or left incomplete.
- Don't oversell: "works" means verified, not "should work".
