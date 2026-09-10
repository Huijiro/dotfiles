# Source

- **Origin:** Adapted from `https://github.com/ttttmr/pi-context`.
- **Imported or reviewed:** 2026-08-28
- **Upstream revision:** npm package `pi-context` v2.1.2.
- **Original path:** `skills/context-management/SKILL.md`

## Local Pi adaptations

- Converted to a skill-only workflow with no extension tools or commands.
- Requires user control over native `/compact`; it never rewrites editor text, queues messages, or changes conversation history.
- Its description asks Pi to load it for every task. Pi always exposes skill descriptions, but skill contents remain subject to Pi's normal on-demand skill loading.

## Update procedure

Review the upstream skill for useful workflow changes. Do not restore the upstream extension behavior unless editor-input transformation is explicitly wanted.
