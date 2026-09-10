---
name: setup-project
description: Configure repository-level agent workflows. Use when the user invokes /setup-project, asks to set up project tracking for agent skills, or when Wayfinder lacks issue-tracker instructions. Always ask which tracker this project uses, even when repository metadata suggests one.
disable-model-invocation: true
---

# Setup project

Configure the current repository so planning and domain-modeling skills know where project work lives. Keep the result project-specific and tracker-neutral.

## Outputs

Write:

- `docs/agents/issue-tracker.md`, describing the chosen tracker's operations.
- `docs/agents/domain.md`, when the user opts into explicit domain-document conventions.
- A concise `## Project workflow` section in the repository's active agent instruction file, pointing to those documents.

Do not edit other skills. Do not configure authentication or expose credentials.

## Process

### 1. Inspect without changing anything

Read:

- `git remote -v` and `.git/config`
- Root `AGENTS.md` and `CLAUDE.md`, if present
- Existing `docs/agents/`, `CONTEXT.md`, `CONTEXT-MAP.md`, and `docs/adr/`
- Monorepo signals such as workspace configuration and multiple substantial packages
- Available tracker integrations, CLIs, and MCP tools

Repository signals may support a recommendation, but they do not choose the tracker. A GitHub remote does not prove that the project uses GitHub Issues.

### 2. Ask which tracker this project uses

Always ask the user. Recommend an option when the evidence is strong, but require confirmation.

Offer the relevant choices, including:

- GitHub Issues
- Linear
- GitLab Issues
- Local Markdown
- Another tracker or workflow described by the user

If the user selects a hosted tracker, identify the exact repository, workspace, team, and project needed to prevent writes to the wrong place. Ask only for identifiers that cannot be discovered safely.

### 3. Establish operations

Read the matching bundled reference as a starting point:

- GitHub: [references/github.md](references/github.md)
- Linear: [references/linear.md](references/linear.md)
- GitLab: [references/gitlab.md](references/gitlab.md)
- Local Markdown: [references/local-markdown.md](references/local-markdown.md)

For another tracker, ask the user how it represents the same operations and write a concrete document from their answer.

The resulting `docs/agents/issue-tracker.md` must explain how agents:

1. Identify the correct project or repository.
2. Create, read, search, update, comment on, and close a ticket.
3. Create and identify a Wayfinder map.
4. Relate child tickets to a map.
5. Represent blocking relationships.
6. Find the frontier: open, unblocked, unclaimed child tickets.
7. Claim a ticket before work.
8. Record a resolution and update the map.

Prefer native parent-child and dependency relationships. Document a text fallback only when the tracker lacks those features.

Verify that the required CLI or MCP integration is available. Read-only checks are allowed. Ask before remote writes such as creating labels, projects, workflows, or issue states.

### 4. Configure domain documentation

Recommend the single-context convention for most repositories:

- `CONTEXT.md`
- `docs/adr/`

Offer multi-context configuration only when the repository is a substantial monorepo or the user requests it. The multi-context convention uses a root `CONTEXT-MAP.md` pointing to context-specific `CONTEXT.md` and ADR directories.

Ask whether to write `docs/agents/domain.md`. If accepted, adapt [references/domain.md](references/domain.md) to the selected layout. Do not create empty glossaries or ADR directories; `domain-modeling` creates them when there is content.

### 5. Show the proposed changes

Before writing, show:

- The selected tracker and exact project scope
- The proposed `docs/agents/issue-tracker.md`
- The proposed domain configuration, if selected
- The instruction-file block
- Any optional remote changes, such as creating missing Wayfinder labels

Wait for confirmation before writing files or making remote changes.

### 6. Write and verify

Prefer the instruction file used by the active harness. For Pi, use `AGENTS.md`. If the repository already declares a canonical instruction file, follow that convention. If none exists, ask before creating one.

Add or update one block rather than appending duplicates:

```markdown
## Project workflow

### Issue tracker

[One-line tracker and project summary.] See `docs/agents/issue-tracker.md`.

### Domain documentation

[One-line layout summary.] See `docs/agents/domain.md`.
```

Omit the domain subsection if the user declined domain configuration.

Read the changed files back and confirm that every referenced path exists. Report remote changes separately from local file changes.
