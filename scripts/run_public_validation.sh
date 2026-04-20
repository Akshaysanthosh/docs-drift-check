#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORK_ROOT="${1:-/tmp/docs-drift-check-public-validation}"
OUTPUT_DIR="$REPO_ROOT/docs/validation"
HELPER_SCRIPT="$REPO_ROOT/plugins/docs-drift-check/skills/docs-drift-check/scripts/docs_drift_check.sh"

log() {
  printf '%s\n' "$1"
}

clone_repo() {
  local url="$1"
  local dest="$2"
  git clone --depth 1 "$url" "$dest" >/dev/null 2>&1
}

init_repo() {
  local repo_dir="$1"
  git -C "$repo_dir" config user.name "Codex"
  git -C "$repo_dir" config user.email "codex@example.com"
}

write_output() {
  local name="$1"
  local repo_url="$2"
  local scenario="$3"
  local output="$4"

  mkdir -p "$OUTPUT_DIR"
  cat > "$OUTPUT_DIR/$name.txt" <<EOF
Repository: $repo_url
Scenario: $scenario

$output
EOF
}

run_my_portfolio() {
  local repo_dir="$WORK_ROOT/my-portfolio"
  local repo_url="https://github.com/Akshaysanthosh/my-portfolio"
  local base_branch
  local output

  clone_repo "$repo_url.git" "$repo_dir"
  init_repo "$repo_dir"
  base_branch="$(git -C "$repo_dir" symbolic-ref --short HEAD)"

  git -C "$repo_dir" checkout -q -b validation/script-rename
  python3 - <<'PY' "$repo_dir/package.json"
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
old = '    "dev": "next dev --turbopack",\n'
new = '    "site:dev": "next dev --turbopack",\n'
if old not in text:
    raise SystemExit("expected dev script not found")
path.write_text(text.replace(old, new, 1))
PY
  git -C "$repo_dir" add package.json
  git -C "$repo_dir" commit -q -m "Rename dev script"
  output="$(cd "$repo_dir" && bash "$HELPER_SCRIPT" "$base_branch")"
  write_output "my-portfolio" "$repo_url" "Renamed the primary local dev script from npm run dev to npm run site:dev without updating README." "$output"
}

run_relam_homepage() {
  local repo_dir="$WORK_ROOT/Relam-homepage"
  local repo_url="https://github.com/Akshaysanthosh/Relam-homepage"
  local base_branch
  local output

  clone_repo "$repo_url.git" "$repo_dir"
  init_repo "$repo_dir"
  base_branch="$(git -C "$repo_dir" symbolic-ref --short HEAD)"

  git -C "$repo_dir" checkout -q -b validation/contact-api
  mkdir -p "$repo_dir/src/app/api/contact"
  cat > "$repo_dir/src/app/api/contact/route.ts" <<'EOF'
import { NextResponse } from "next/server";

const CONTACT_ROUTE = "/api/contact";

export async function POST() {
  return NextResponse.json({ ok: true, route: CONTACT_ROUTE });
}
EOF
  git -C "$repo_dir" add src/app/api/contact/route.ts
  git -C "$repo_dir" commit -q -m "Add contact API route"
  output="$(cd "$repo_dir" && bash "$HELPER_SCRIPT" "$base_branch")"
  write_output "Relam-homepage" "$repo_url" "Added a new public contact endpoint at /api/contact without updating README or spec notes." "$output"
}

run_dara_lab() {
  local repo_dir="$WORK_ROOT/dara-lab"
  local repo_url="https://github.com/Akshaysanthosh/dara-lab"
  local base_branch
  local output

  clone_repo "$repo_url.git" "$repo_dir"
  init_repo "$repo_dir"
  base_branch="$(git -C "$repo_dir" symbolic-ref --short HEAD)"

  git -C "$repo_dir" checkout -q -b validation/ga-env-var
  python3 - <<'PY' "$repo_dir/src/components/GoogleAnalytics.tsx"
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
old = """export default function GoogleAnalytics() {\n  return (\n    <>\n      {/* Google tag (gtag.js) */}\n      <Script\n        src={`https://www.googletagmanager.com/gtag/js?id=G-VLLZ5Z7B8F`}\n        strategy=\"afterInteractive\"\n      />\n"""
new = """export default function GoogleAnalytics() {\n  const measurementId = process.env.NEXT_PUBLIC_GA_MEASUREMENT_ID ?? \"G-VLLZ5Z7B8F\";\n\n  return (\n    <>\n      {/* Google tag (gtag.js) */}\n      <Script\n        src={`https://www.googletagmanager.com/gtag/js?id=${measurementId}`}\n        strategy=\"afterInteractive\"\n      />\n"""
if old not in text:
    raise SystemExit("expected GoogleAnalytics block not found")
text = text.replace(old, new, 1)
text = text.replace("          gtag('config', 'G-VLLZ5Z7B8F');", "          gtag('config', measurementId);", 1)
path.write_text(text)
PY
  git -C "$repo_dir" add src/components/GoogleAnalytics.tsx
  git -C "$repo_dir" commit -q -m "Make GA measurement id configurable"
  output="$(cd "$repo_dir" && bash "$HELPER_SCRIPT" "$base_branch")"
  write_output "dara-lab" "$repo_url" "Moved Google Analytics to a required NEXT_PUBLIC_GA_MEASUREMENT_ID env var without adding setup docs." "$output"
}

rm -rf "$WORK_ROOT"
mkdir -p "$WORK_ROOT" "$OUTPUT_DIR"

log "Running public validation examples into $WORK_ROOT"
run_my_portfolio
run_relam_homepage
run_dara_lab
log "Validation outputs written to $OUTPUT_DIR"
