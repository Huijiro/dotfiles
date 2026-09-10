---
name: context-management
description: Always load this skill for every task. Keep multi-turn or noisy work oriented with concise state summaries, clear phase boundaries, and explicit next steps. Use it for research, debugging, planning, implementation, validation, handoffs, and task switches.
---

# Context management

Use this skill on every task. Keep the current conversation understandable without changing, replacing, or queuing the user's input.

## Keep a working state

For work that spans multiple steps, maintain a short internal state:

- current goal and user-approved scope
- decisions and constraints
- files, commands, or external systems changed
- validation completed and remaining risks
- the next concrete action

Do not repeat this state to the user unless it helps them make a decision or resume work.

## Mark real phase boundaries

Pause and orient when moving between phases such as:

- investigation to planning
- planning to implementation
- implementation to validation
- diagnosis to a new approach
- a completed task to a new request
- a handoff after a long or interrupted task

Before changing phases, retain the facts the next phase needs. Drop raw process detail that can be recovered from files, commands, or source links.

## Keep user control

- Never rewrite the user's editor text or turn it into a command.
- Never queue a follow-up message on the user's behalf.
- Do not compact, fork, or otherwise change conversation history automatically.
- If native Pi compaction would help, explain why briefly and let the user choose whether to run `/compact`.

## Handoffs

When a task becomes long, interrupted, or ready for another phase, offer a concise handoff only when useful. Include:

1. Goal and approved scope
2. Decisions and constraints
3. Changed files or external side effects
4. Verification and remaining risks
5. Exact next step

A handoff is not a final answer. Resume from it only after the user confirms the next direction.

## Avoid process theater

Do not create summaries, plans, or checkpoints for simple one-step work. Prefer direct execution when the active context is already small, coherent, and sufficient.
