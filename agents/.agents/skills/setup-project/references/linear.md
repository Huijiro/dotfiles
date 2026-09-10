# Linear

Use the available Linear MCP integration or the project's established Linear client.

## Discovery and verification

- Inspect available Linear teams and projects without changing them.
- Ask the user to confirm the workspace, team, and project for this repository.
- Record stable names and identifiers in the generated project document.
- Verify read access before proposing any write.
- If authentication fails, stop and ask the user to restore access.

Do not assume a GitHub repository linked to Linear uses GitHub Issues for planning.

## Routine operations

Document the integration calls available in the current environment for:

- Creating, reading, searching, and updating issues
- Adding comments
- Assigning issues
- Changing issue status
- Adding and removing labels
- Creating parent and sub-issue relationships
- Creating and reading blocking relationships

Record semantic statuses, such as "open" and "resolved", alongside the project's actual Linear workflow states. Do not invent states or labels.

## Wayfinding operations

- Map: one Linear issue labelled `wayfinder:map` in the confirmed team and project.
- Child: a sub-issue of the map labelled `wayfinder:<type>`, where type is `research`, `prototype`, `grilling`, or `task`.
- Blocking: use Linear's native blocking and blocked-by relationships.
- Frontier: open sub-issues of the map with no assignee and no unresolved blockers, ordered by the map's chosen priority or issue order.
- Claim: assign the ticket to the active user before doing any work.
- Resolve: add the answer as a comment, move the ticket to the project's confirmed completed state, then append a linked one-line gist to the map's `Decisions so far` section.

If the integration cannot manage a native relationship, document the limitation and use explicit body fields only for that missing operation:

```markdown
Part of: <map issue identifier>
Blocked by: <issue identifiers>
```

## Labels

Wayfinder expects:

- `wayfinder:map`
- `wayfinder:research`
- `wayfinder:prototype`
- `wayfinder:grilling`
- `wayfinder:task`

Offer to create missing labels in the confirmed Linear workspace, but wait for confirmation because this changes remote project configuration.
