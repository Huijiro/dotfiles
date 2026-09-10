# Domain documentation

Engineering skills read the project's domain language before changing the code or planning work.

## Single-context layout

Use for most repositories:

```text
CONTEXT.md
 docs/adr/
```

Read the root `CONTEXT.md` and relevant ADRs under `docs/adr/`. If either path does not exist, continue without warning. The `domain-modeling` skill creates files only when a term or decision is ready to record.

## Multi-context layout

Use only when the repository contains distinct domain contexts:

```text
CONTEXT-MAP.md
 docs/adr/
 <context>/CONTEXT.md
 <context>/docs/adr/
```

Read `CONTEXT-MAP.md`, then the context documents and ADRs relevant to the work. Root ADRs hold system-wide decisions; context-local ADRs hold decisions confined to one context.

## Vocabulary and decisions

Use canonical terms from the relevant `CONTEXT.md` in issue titles, plans, tests, and code. If required language is missing or ambiguous, use `domain-modeling` rather than silently inventing a synonym.

Surface conflicts with existing ADRs explicitly. Do not silently replace a recorded decision.
