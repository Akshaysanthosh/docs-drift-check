#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install_local_plugin.sh [--force] /path/to/target-repo

Copies the docs-drift-check plugin into the target repository at:
  plugins/docs-drift-check

Also creates or updates:
  .agents/plugins/marketplace.json
EOF
}

FORCE=0

if [ "${1:-}" = "--force" ]; then
  FORCE=1
  shift
fi

TARGET_REPO="${1:-}"

if [ -z "$TARGET_REPO" ] || [ $# -ne 1 ]; then
  usage
  exit 1
fi

if [ ! -d "$TARGET_REPO" ]; then
  echo "Error: target directory does not exist: $TARGET_REPO" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_PLUGIN_DIR="$REPO_ROOT/plugins/docs-drift-check"
TARGET_PLUGIN_DIR="$TARGET_REPO/plugins/docs-drift-check"
TARGET_MARKETPLACE="$TARGET_REPO/.agents/plugins/marketplace.json"

if [ ! -d "$SOURCE_PLUGIN_DIR" ]; then
  echo "Error: source plugin directory is missing: $SOURCE_PLUGIN_DIR" >&2
  exit 1
fi

if [ -e "$TARGET_PLUGIN_DIR" ] && [ "$FORCE" -ne 1 ]; then
  echo "Error: target plugin already exists: $TARGET_PLUGIN_DIR" >&2
  echo "Re-run with --force to replace it." >&2
  exit 1
fi

mkdir -p "$TARGET_REPO/plugins" "$(dirname "$TARGET_MARKETPLACE")"

if [ -e "$TARGET_PLUGIN_DIR" ]; then
  rm -rf "$TARGET_PLUGIN_DIR"
fi

cp -R "$SOURCE_PLUGIN_DIR" "$TARGET_PLUGIN_DIR"

python3 - "$TARGET_MARKETPLACE" "$FORCE" <<'PY'
import json
import sys
from pathlib import Path

marketplace_path = Path(sys.argv[1])
force = sys.argv[2] == "1"
plugin_name = "docs-drift-check"
plugin_entry = {
    "name": plugin_name,
    "source": {
        "source": "local",
        "path": "./plugins/docs-drift-check",
    },
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL",
    },
    "category": "Developer Tools",
}

if marketplace_path.exists():
    data = json.loads(marketplace_path.read_text())
else:
    data = {
        "name": "docs-drift-check-local",
        "interface": {"displayName": "Docs Drift Check"},
        "plugins": [],
    }

plugins = data.setdefault("plugins", [])
existing_index = next((i for i, item in enumerate(plugins) if item.get("name") == plugin_name), None)

if existing_index is not None:
    if not force:
        raise SystemExit(f"Error: marketplace already contains '{plugin_name}'. Re-run with --force to replace it.")
    plugins[existing_index] = plugin_entry
else:
    plugins.append(plugin_entry)

data.setdefault("name", "docs-drift-check-local")
data.setdefault("interface", {})
data["interface"].setdefault("displayName", "Docs Drift Check")

marketplace_path.write_text(json.dumps(data, indent=2) + "\n")
PY

if ! git -C "$TARGET_REPO" rev-parse --git-dir >/dev/null 2>&1; then
  echo "Installed plugin into $TARGET_PLUGIN_DIR"
  echo "Updated marketplace at $TARGET_MARKETPLACE"
  echo "Warning: $TARGET_REPO is not a git repository yet. The bundled helper expects to run inside a git repo."
  exit 0
fi

echo "Installed docs-drift-check plugin into $TARGET_PLUGIN_DIR"
echo "Updated marketplace at $TARGET_MARKETPLACE"
echo "Run the bundled helper from the target repo with:"
echo "  bash plugins/docs-drift-check/skills/docs-drift-check/scripts/docs_drift_check.sh main"
