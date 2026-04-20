#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install_local_skill.sh [--force] /path/to/target-repo

Copies the docs-drift-check skill into the target repository at:
  .agents/skills/docs-drift-check
EOF
}

FORCE=0

if [ "${1:-}" = "--force" ]; then
  FORCE=1
  shift
fi

TARGET_REPO="${1:-}"

if [ -z "$TARGET_REPO" ]; then
  usage
  exit 1
fi

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

if [ ! -d "$TARGET_REPO" ]; then
  echo "Error: target directory does not exist: $TARGET_REPO" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_SKILL_DIR="$REPO_ROOT/.agents/skills/docs-drift-check"
TARGET_SKILLS_DIR="$TARGET_REPO/.agents/skills"
TARGET_SKILL_DIR="$TARGET_SKILLS_DIR/docs-drift-check"

if [ ! -d "$SOURCE_SKILL_DIR" ]; then
  echo "Error: source skill directory is missing: $SOURCE_SKILL_DIR" >&2
  exit 1
fi

if [ -e "$TARGET_SKILL_DIR" ] && [ "$FORCE" -ne 1 ]; then
  echo "Error: target skill already exists: $TARGET_SKILL_DIR" >&2
  echo "Re-run with --force to replace it." >&2
  exit 1
fi

mkdir -p "$TARGET_SKILLS_DIR"

if [ -e "$TARGET_SKILL_DIR" ]; then
  rm -rf "$TARGET_SKILL_DIR"
fi

cp -R "$SOURCE_SKILL_DIR" "$TARGET_SKILL_DIR"

if ! git -C "$TARGET_REPO" rev-parse --git-dir >/dev/null 2>&1; then
  echo "Installed into $TARGET_SKILL_DIR"
  echo "Warning: $TARGET_REPO is not a git repository yet. The helper script expects to run inside a git repo."
  exit 0
fi

echo "Installed docs-drift-check into $TARGET_SKILL_DIR"
echo "Run it from the target repo with:"
echo "  bash .agents/skills/docs-drift-check/scripts/docs_drift_check.sh main"
