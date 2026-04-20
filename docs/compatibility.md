# Compatibility

Last updated: April 20, 2026

Docs Drift Check is currently designed and tested for:

- Codex repo-local skill usage
- Codex local plugin usage through repo or personal marketplaces
- Git repositories with branch-based diffs
- shell environments that can run the bundled Bash helper

## Validated repo types in this repository

- small Next.js repos
- larger frontend repos with deployment config
- research or Python repos with setup-heavy READMEs

## Current assumptions

- `git` is available
- the repository has at least one commit
- a valid base ref such as `main` or `master` exists locally

## Known limitations

- The helper is heuristic-based and not semantic-proof.
- It is strongest on public-surface changes such as commands, env vars, routes, config keys, and renames.
- It is weaker on subtle behavioral changes that do not leave recognizable diff markers.
