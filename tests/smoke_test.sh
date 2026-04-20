#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_ROOT="$(mktemp -d)"
TARGET_REPO="$TMP_ROOT/sample-repo"

cleanup() {
  rm -rf "$TMP_ROOT"
}

trap cleanup EXIT

mkdir -p "$TARGET_REPO"
cd "$TARGET_REPO"

git init -q
git config user.name "Codex"
git config user.email "codex@example.com"

mkdir -p docs src
cat > README.md <<'EOF'
# Sample App

Use `--port` to start the server.
EOF

cat > docs/setup.md <<'EOF'
Set `APP_PORT` before running the app.
EOF

cat > src/server.js <<'EOF'
app.get("/api/health", handler)
EOF

git add .
git commit -q -m "initial commit"
BASE_BRANCH="$(git symbolic-ref --short HEAD)"
git checkout -q -b feature/docs-drift

bash "$REPO_ROOT/scripts/install_local_skill.sh" "$TARGET_REPO" >/dev/null

cat > src/server.js <<'EOF'
app.get("/api/status", handler)
const token = process.env.APP_SECRET_TOKEN
EOF

git add src/server.js
git commit -q -m "change public surface"

OUTPUT="$(bash .agents/skills/docs-drift-check/scripts/docs_drift_check.sh "$BASE_BRANCH")"

printf '%s\n' "$OUTPUT"

echo "$OUTPUT" | grep -F 'Likely env var changes' >/dev/null
echo "$OUTPUT" | grep -F 'APP_SECRET_TOKEN' >/dev/null
echo "$OUTPUT" | grep -F 'Likely route or endpoint changes' >/dev/null
echo "$OUTPUT" | grep -F '/api/status' >/dev/null

echo "Smoke test passed."
