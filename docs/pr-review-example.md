# PR Review Example

Use Docs Drift Check as a focused pass before merge when a change might affect setup, usage, or public behavior.

## Example prompt

```text
Use $docs-drift-check on this branch and tell me whether README, setup docs, or API docs need updating before merge.
```

## Good cases for this workflow

- a new environment variable was introduced
- a package script changed
- a route or endpoint changed
- a deployment rewrite or proxy changed
- a config key or file path was renamed

## Recommended output shape

Ask for:

1. risk level
2. why
3. likely impacted docs files
4. recommended edits

Example follow-up:

```text
If drift looks likely, list the exact docs files and the smallest patch plan.
```

## Why this works well

The plugin is strongest when used as a targeted review pass right before merge, because the diff is small, the likely docs surface is obvious, and reviewers can act on the output immediately.
