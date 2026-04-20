# Docs drift heuristics

Use this file when the script finds candidate changes and you need a consistent rubric for the final judgment.

## High-signal drift candidates

- New or removed API routes
- New required env vars
- CLI flag or command rename
- Config key rename or default change that affects setup or usage
- Setup or onboarding step changes
- File, module, or path rename that docs reference directly

## Low-signal changes

- Pure formatting or comment changes
- Styling-only frontend changes
- Internal refactors with unchanged public behavior
- Test-only changes
- Variable renames that do not appear in user-facing docs

## Confidence guidance

- `low`: weak signals only, or docs already changed appropriately
- `medium`: public behavior changed and docs may need updates, but no stale reference is confirmed
- `high`: concrete stale path, command, route, flag, or setup step found in docs

## Output shape

1. Risk level
2. Why
3. Impacted docs files
4. Recommended edits

Prefer `possible drift` over `confirmed drift` when the evidence is incomplete.
