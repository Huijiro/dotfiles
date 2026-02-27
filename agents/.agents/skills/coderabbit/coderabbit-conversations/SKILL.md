---
name: coderabbit-conversations
description: List and resolve all unresolved CodeRabbit review conversations from the current PR
version: "1.0.0"
license: Apache-2.0
allowed-tools: "Bash,Read,edit_file,todo_write"
metadata:
  command: "gh api graphql"
  tags: "github pr review coderabbit"
---

# CodeRabbit Conversations

List all unresolved CodeRabbit review conversations from the current PR, create a TODO list to address each one, and resolve them all once fixed.

## Why GraphQL Instead of REST

The `gh pr view --json reviews,comments` approach only returns review-level data and misses individual conversation threads. GitHub's GraphQL API exposes the `reviewThreads` connection which gives us:

- Per-thread resolution status (`isResolved`)
- Whether the comment is outdated/outside diff (`isOutdated`)
- The exact file path and line number
- The full comment body
- Thread IDs needed for the `resolveReviewThread` mutation

## Scripts

All scripts live in `scripts/` relative to this skill file. Run them from that directory.

| Script | Purpose |
|---|---|
| `get-pr-info.sh` | Exports `PR_NUMBER`, `PR_TITLE`, `PR_URL`, `OWNER`, `REPO` — sourced by the other scripts |
| `list-threads.sh` | Fetches and prints all unresolved CodeRabbit threads for the current PR |
| `resolve-threads.sh` | Resolves all unresolved CodeRabbit threads for the current PR |

## Workflow

### Step 1: List Unresolved Conversations

Run from the repo root (or any directory — the scripts use `gh` context):

```bash
./scripts/list-threads.sh
```

This prints every unresolved, non-outdated CodeRabbit thread with its thread ID, file path, line number, and comment body.

> If the PR has more than 100 threads the script exits with a warning. In that case, use cursor-based pagination with the `after` parameter in the GraphQL query.

### Step 2: Create TODO List

After listing, use `todo_write` to create one TODO item per conversation thread. Each TODO should include:

- The thread ID (needed for resolving later)
- The file path and line number
- A brief summary of the issue

### Step 3: Fix Each Issue

Work through the TODOs:
1. Read the relevant file and understand the issue
2. Make the fix
3. Mark the TODO as completed
4. Move to the next one

### Step 4: Resolve All Conversations

After all fixes are committed, resolve every thread:

```bash
./scripts/resolve-threads.sh
```

## Guidelines

- Always fetch threads via GraphQL, not `gh pr view --json reviews` (which misses thread-level data)
- Only process unresolved, non-outdated threads from `coderabbitai`
- Create one TODO per conversation thread for tracking
- Fix all issues before resolving conversations
- Resolve conversations only after the code changes are committed
- If a thread has more than 100 conversations (unlikely), use cursor-based pagination with the `after` parameter
