#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

./scripts/bootstrap.sh >/dev/null

SKILL="skills/natural-japanese"

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is required: https://docs.astral.sh/uv/" >&2
  exit 1
fi

if [[ "$#" -gt 0 ]]; then
  FILES=("$@")
else
  FILES=(
    "README.md"
    "AGENTS.md"
    "docs/design-principles.md"
    "docs/evidence-policy.md"
    "docs/research-plan.md"
    "docs/tooling.md"
    "docs/refinement-workflow.md"
    "data/source-register.md"
    "archetypes/mdf-30/README.md"
  )
fi

for file in "${FILES[@]}"; do
  [[ -f "$file" ]] || { echo "skip: $file (not found)" >&2; continue; }
  echo
  echo "=== natural-japanese: $file ==="
  uv run "$SKILL/scripts/lint.py" "$file"
  uv run "$SKILL/scripts/outline.py" "$file"
  uv run "$SKILL/scripts/terms.py" "$file"
done
