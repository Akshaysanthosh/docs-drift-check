# Docs Drift Check

`docs-drift-check` is a Codex skill and local Codex plugin for spotting likely documentation drift in a branch, PR, or local diff.

Public repository: [github.com/Akshaysanthosh/docs-drift-check](https://github.com/Akshaysanthosh/docs-drift-check)

It focuses on high-signal, user-facing changes such as:

- env vars
- CLI flags and commands
- API routes or endpoints
- config keys
- renamed files or modules
- setup and onboarding steps

## What this repo contains

- A repo-local Codex skill at `.agents/skills/docs-drift-check/`
- A local Codex plugin at `plugins/docs-drift-check/`
- A deterministic helper script for scanning git diffs
- Local installers for the skill and the plugin
- Smoke tests for both installation paths

## Repository layout

```text
.agents/skills/docs-drift-check/
  SKILL.md
  agents/openai.yaml
  references/heuristics.md
  scripts/docs_drift_check.sh
docs/go-to-market.md
plugins/docs-drift-check/
  .codex-plugin/plugin.json
  skills/docs-drift-check/
scripts/install_local_skill.sh
scripts/install_local_plugin.sh
tests/smoke_test.sh
tests/plugin_smoke_test.sh
```

## Quick start

This repository is the source of truth for both the raw skill and the packaged local plugin.

### Option 1: install the repo-local skill

To use just the skill in another codebase:

```bash
bash scripts/install_local_skill.sh /path/to/target-repo
```

Then, inside the target repo:

```bash
bash .agents/skills/docs-drift-check/scripts/docs_drift_check.sh main
```

Or invoke it in Codex with:

```text
Use $docs-drift-check to assess whether this branch likely needs documentation updates.
```

### Option 2: install the local plugin

To package the skill as a local Codex plugin in another repository:

```bash
bash scripts/install_local_plugin.sh /path/to/target-repo
```

This copies the plugin into `plugins/docs-drift-check/` and creates or updates `.agents/plugins/marketplace.json`.

## Install behavior

- The installer copies `.agents/skills/docs-drift-check/` into the target repository.
- The plugin installer copies `plugins/docs-drift-check/` into the target repository and adds a repo marketplace entry.
- It refuses to overwrite an existing installation unless you pass `--force`.
- Both installers warn if the target directory is not a git repository yet.

## Development

Run the smoke tests locally:

```bash
bash tests/smoke_test.sh
bash tests/plugin_smoke_test.sh
```

The tests create temporary git repos, install either the skill or the plugin, make a docs-sensitive code change, and verify that the helper script reports the expected signals.

## License

This project is available under the MIT license. See [LICENSE](LICENSE).

## Commercialization

A lightweight go-to-market plan lives at [docs/go-to-market.md](docs/go-to-market.md).

## Next steps

Good follow-ups from here:

- improve the heuristics on real PRs
- add language-specific route or config patterns if you see repeatable gaps
- add screenshots and a first tagged release once the workflow stabilizes
