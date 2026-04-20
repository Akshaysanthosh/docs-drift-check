# Install in Codex

Docs Drift Check can be installed in Codex in two practical ways today.

## Option 1: repo marketplace

Use this when the plugin should live inside a specific repository.

1. Copy `plugins/docs-drift-check/` into the target repo under `plugins/`.
2. Copy or update `.agents/plugins/marketplace.json`.
3. Restart Codex.
4. Open the plugin browser and install the plugin from that repo marketplace.

This repository already includes the install helper:

```bash
bash scripts/install_local_plugin.sh /path/to/target-repo
```

## Option 2: personal marketplace

Use this when you want the plugin available across your local Codex workflows.

1. Copy the plugin into your personal plugin directory.
2. Point `~/.agents/plugins/marketplace.json` at that plugin path.
3. Restart Codex.

The official Codex build docs for local plugin installation are here:

- https://developers.openai.com/codex/plugins/build

## Invocation

After installation, you can:

- ask Codex directly to check for docs drift
- invoke the plugin explicitly
- invoke the bundled skill with `$docs-drift-check`

Example prompts:

- `Use $docs-drift-check on this branch.`
- `Check whether this PR likely needs README or setup updates.`
- `Review this diff for docs drift before merge.`
