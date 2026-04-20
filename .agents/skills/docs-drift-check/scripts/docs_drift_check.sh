#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-main}"

section() {
  printf '\n== %s ==\n' "$1"
}

die() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

print_matches() {
  local title="$1"
  local regex="$2"

  section "$title"

  if ! git --no-pager diff --unified=0 "$DIFF_RANGE" | grep -E "$regex"; then
    echo "(none)"
  fi
}

print_config_matches() {
  section "Likely config changes"

  if ! git --no-pager diff --unified=0 "$DIFF_RANGE" -- '*.json' '*.yaml' '*.yml' '*.toml' '*.ini' '*.env*' \
    | grep -E '^[+-][^+-].*([A-Za-z0-9_.-]+[[:space:]]*[:=]|"[A-Za-z0-9_.-]+"[[:space:]]*:)' ; then
    echo "(none)"
  fi
}

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  die "Not a git repository. Run this inside the repo you want to inspect."
fi

if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  die "Repository has no commits yet."
fi

if git rev-parse --verify --quiet "$BASE_REF" >/dev/null 2>&1; then
  RESOLVED_BASE="$BASE_REF"
elif git rev-parse --verify --quiet "origin/$BASE_REF" >/dev/null 2>&1; then
  RESOLVED_BASE="origin/$BASE_REF"
else
  die "Base ref '$BASE_REF' was not found locally. Pass an existing branch, tag, or commit."
fi

DIFF_RANGE="${RESOLVED_BASE}...HEAD"

echo "Base ref: $RESOLVED_BASE"
echo "Diff range: $DIFF_RANGE"

STATUS_OUTPUT="$(git status --short)"
section "Working tree status"
if [ -n "$STATUS_OUTPUT" ]; then
  printf '%s\n' "$STATUS_OUTPUT"
  echo
  echo "Note: uncommitted changes are not included in $DIFF_RANGE."
else
  echo "(clean)"
fi

section "Changed files"
if ! git --no-pager diff --name-only "$DIFF_RANGE"; then
  echo "(none)"
fi

section "Changed docs files"
if ! git --no-pager diff --name-only "$DIFF_RANGE" \
  | grep -E '(^|/)(README|CHANGELOG|CONTRIBUTING|SETUP)\.md$|(^|/)(docs|doc|examples)/|\.mdx?$'; then
  echo "(none)"
fi

section "Potential renames"
if ! git --no-pager diff --name-status --find-renames "$DIFF_RANGE" | grep -E '^R[0-9]+'; then
  echo "(none)"
fi

print_matches \
  "Likely env var changes" \
  '^[+-][^+-].*(process\.env(\.[A-Z][A-Z0-9_]*|\[[^]]+\])|os\.getenv\(|getenv\(|ENV\[|NEXT_PUBLIC_[A-Z0-9_]+|[A-Z][A-Z0-9_]{2,}_(URL|HOST|PORT|TOKEN|SECRET|KEY|ID|NAME|PATH|BUCKET|REGION|DEBUG|MODE)\b)'

print_matches \
  "Likely CLI flag changes" \
  '^[+-][^+-].*(--[a-z0-9][a-z0-9-]*\b|argparse|click\.(command|option)|commander\.option|yargs|cobra\.Command|flag\.(String|Bool|Int|Duration))'

print_matches \
  "Likely route or endpoint changes" \
  '^[+-][^+-].*((router|app)\.(get|post|put|patch|delete)\b|@app\.(get|post|put|patch|delete)\b|FastAPI\b|APIRouter\b|/api/[A-Za-z0-9._:/-]+)'

print_config_matches

