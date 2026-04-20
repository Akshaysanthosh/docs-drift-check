---
name: docs-drift-check
description: Check whether code changes likely require documentation updates. Use when reviewing a branch, PR, or local diff for README, docs, examples, setup, CLI, config, env var, or API drift.
---

# Docs Drift Check

Determine whether a branch or diff likely created documentation drift, then point to the exact docs files and terms worth reviewing. This skill should bias toward concrete evidence from the diff, not broad speculation.

## Use This Skill When

- The user asks whether a branch, PR, or local change likely needs doc updates.
- The diff changes public-facing behavior such as API routes, CLI flags, env vars, config keys, setup steps, or file/module names that docs may reference.
- The task is to review README, `docs/`, `examples/`, onboarding, or setup documentation for drift.

Do not use this skill for pure styling changes, test-only changes, or clearly internal refactors with no visible behavior change.

## Quick Start

1. Run the helper:
   `bash .agents/skills/docs-drift-check/scripts/docs_drift_check.sh [base-ref]`
2. Read the highest-signal sections first:
   - `Potential renames`
   - `Likely env var changes`
   - `Likely CLI flag changes`
   - `Likely route or endpoint changes`
   - `Likely config changes`
3. Inspect the most likely docs targets:
   - `README.md`
   - `docs/`
   - `examples/`
   - setup or onboarding docs near the affected feature
4. Return a short result with:
   - risk level: `low`, `medium`, or `high`
   - concrete evidence from the diff
   - likely impacted docs files
   - recommended edits or patch plan

## Workflow

### 1. Establish the comparison

- Prefer a user-provided base ref.
- If none is provided, the helper defaults to `main`.
- If the base ref is missing, say so clearly and ask for the correct branch or compare target.

### 2. Identify doc-sensitive changes

Focus on high-signal change types:

- env vars
- CLI flags and commands
- API routes or endpoints
- config keys
- renamed files or modules
- setup or onboarding steps

Use the helper script for a deterministic first pass, then inspect the diff manually if needed.

### 3. Compare the code changes against docs

- Search docs for old and new names, paths, flags, routes, and config terms.
- Prefer docs closest to the changed area before scanning the full repo.
- Read [references/heuristics.md](references/heuristics.md) when you need the signal rubric or output shape.

### 4. Classify the outcome

- `low`: docs likely OK, or only weak signals with no stale references found
- `medium`: possible drift, or strong public-surface changes without confirmed stale docs
- `high`: likely or confirmed drift with specific stale terms, paths, or missing instructions

### 5. Keep the output concise

Use this shape:

1. Risk level
2. Why
3. Impacted docs files
4. Recommended edits

## Rules

- Prefer deterministic evidence from the diff before semantic guesses.
- Do not claim confirmed drift unless you can point to a concrete stale reference, missing doc update, or renamed path.
- If evidence is partial, say `possible drift` instead of overstating certainty.
- Ignore formatting-only, comment-only, and test-only changes unless they alter user-facing behavior.
- Keep the result short and actionable.
