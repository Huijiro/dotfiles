# Local Markdown

Store planning artifacts under `.scratch/` when the project does not use a hosted issue tracker.

## Layout

- Map: `.scratch/<effort>/map.md`
- Child ticket: `.scratch/<effort>/issues/<NN>-<slug>.md`

A child ticket starts with fields for its state and relationships:

```markdown
Type: research | prototype | grilling | task
Status: open | claimed | resolved
Blocked by: 01, 02

## Question

<question this ticket resolves>
```

Omit `Blocked by` when there are no blockers.

## Operations

- Create, read, search, and update tickets with normal file operations.
- Append discussion under `## Comments`.
- Find the frontier by scanning child files in numeric order and selecting tickets whose status is `open` and whose blockers are all `resolved`.
- Claim by changing `Status: open` to `Status: claimed` before doing any work.
- Resolve by adding `## Answer`, changing the status to `resolved`, and appending a relative link plus one-line gist to the map's `Decisions so far` section.

Ask whether `.scratch/` should be committed or ignored. Do not assume either policy.
