# GitHub Issues

Use GitHub Issues through the `gh` CLI.

## Discovery and verification

- Infer the repository from `git remote -v`, then ask the user to confirm it.
- Check access with `gh auth status` and `gh repo view`.
- If authentication fails, stop and ask the user to restore access. Do not retry with another authentication method.
- Inspect existing labels before proposing changes.

## Routine operations

- Create: `gh issue create --title "..." --body-file <file>`
- Read: `gh issue view <number> --comments`
- Search: `gh issue list --state open --json number,title,body,labels,assignees`
- Comment: `gh issue comment <number> --body-file <file>`
- Label: `gh issue edit <number> --add-label "..."` or `--remove-label "..."`
- Claim: `gh issue edit <number> --add-assignee @me`
- Close: post the resolution first, then run `gh issue close <number>`

Use files or quoted heredocs for multiline Markdown to avoid shell interpolation.

## Wayfinding operations

- Map: one issue labelled `wayfinder:map`.
- Child: a GitHub sub-issue labelled `wayfinder:<type>`, where type is `research`, `prototype`, `grilling`, or `task`.
- Blocking: use GitHub's native issue dependencies when available.
- Frontier: the map's open child issues with no assignee and no open blockers, ordered as they appear under the map.
- Claim: assign the ticket to the current GitHub user before doing any work.
- Resolve: post the answer, close the ticket, then append a linked one-line gist to the map's `Decisions so far` section.

Before relying on sub-issues or dependencies, verify current GitHub API support and the repository's feature availability. Record the tested `gh api` operations in the generated project document. Do not copy unverified endpoint syntax into project instructions.

If native sub-issues are unavailable, put `Part of #<map>` in each child body and maintain a task list on the map. If native dependencies are unavailable, put `Blocked by: #<number>, ...` near the top of the child body.

## Labels

Wayfinder expects:

- `wayfinder:map`
- `wayfinder:research`
- `wayfinder:prototype`
- `wayfinder:grilling`
- `wayfinder:task`

Offer to create missing labels, but treat label creation as a remote write and wait for confirmation.
