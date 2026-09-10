# GitLab Issues

Use GitLab Issues through the `glab` CLI.

## Discovery and verification

- Infer the project from `git remote -v`, then ask the user to confirm it.
- Verify access with read-only `glab` commands.
- If authentication fails, stop and ask the user to restore access.

## Routine operations

- Create: `glab issue create --title "..." --description "..."`
- Read: `glab issue view <number> --comments`
- Search: `glab issue list -F json`
- Comment: `glab issue note <number> --message "..."`
- Label: `glab issue update <number> --label "..."` or `--unlabel "..."`
- Claim: `glab issue update <number> --assignee @me`
- Close: post the resolution first, then run `glab issue close <number>`

## Wayfinding operations

- Map: one issue labelled `wayfinder:map`.
- Child: an issue labelled `wayfinder:<type>` with `Part of #<map>` near the top of its description. Use a native parent relationship when the project's GitLab tier supports one.
- Blocking: use native blocking links where available. Otherwise use `Blocked by: #<number>, ...` in the child description.
- Frontier: open child issues with no assignee and no unresolved blockers.
- Claim: assign the ticket before doing any work.
- Resolve: add an answer note, close the ticket, then append a linked one-line gist to the map's `Decisions so far` section.

Offer to create missing Wayfinder labels, but wait for confirmation before changing the remote project.
