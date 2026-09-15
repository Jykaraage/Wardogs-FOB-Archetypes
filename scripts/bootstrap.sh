#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

git submodule sync --recursive
git submodule update --init --recursive

EXPECTED="9a78a42964096da509b8f3e011f0085a5f080151"
ACTUAL="$(git -C vendor/natural-japanese rev-parse HEAD)"

if [[ "$ACTUAL" != "$EXPECTED" ]]; then
  echo "natural-japanese commit mismatch: expected $EXPECTED, got $ACTUAL" >&2
  exit 1
fi

if [[ ! -f skills/natural-japanese/SKILL.md ]]; then
  echo "skills/natural-japanese/SKILL.md is unavailable." >&2
  echo "Check submodule initialization and symlink support." >&2
  exit 1
fi

echo "natural-japanese ready at $ACTUAL"
