#!/usr/bin/env bash
# scripts/setup/init-project.sh
#
# Rename the template from template-api-java to your project name.
# Run once after cloning. Does NOT rename the local directory.
#
# Usage:
#   ./scripts/setup/init-project.sh --name <project-name> --owner <github-owner> [--dry-run]
#
# Arguments:
#   --name      New project name  (e.g. my-api)
#   --owner     GitHub username or org (e.g. acme-corp)
#   --dry-run   Print what would change without modifying any files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

NAME=""
OWNER=""
DRY_RUN=false

# ── Argument parsing ─────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)    NAME="$2";  shift 2 ;;
    --owner)   OWNER="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) printf "Unknown argument: %s\n" "$1" >&2; exit 1 ;;
  esac
done

if [[ -z "$NAME" || -z "$OWNER" ]]; then
  printf "Usage: %s --name <project-name> --owner <github-owner> [--dry-run]\n\n" "$0" >&2
  printf "  --name    New project name  (e.g. my-api)\n" >&2
  printf "  --owner   GitHub username or org (e.g. acme-corp)\n" >&2
  exit 1
fi

# Allow alphanumeric, hyphens, underscores, and dots only — safe for perl substitution
if [[ "$NAME" =~ [^a-zA-Z0-9._-] ]]; then
  printf "Error: --name '%s' contains unsupported characters.\n" "$NAME" >&2
  printf "       Use only: a-z A-Z 0-9 . _ -\n" >&2
  exit 1
fi
if [[ "$OWNER" =~ [^a-zA-Z0-9._-] ]]; then
  printf "Error: --owner '%s' contains unsupported characters.\n" "$OWNER" >&2
  printf "       Use only: a-z A-Z 0-9 . _ -\n" >&2
  exit 1
fi

# ── Target files ─────────────────────────────────────────────────────────────

TARGET_FILES=(
  "helm/app/Chart.yaml"
  "helm/app/values.yaml"
  "README.md"
  "build.gradle"
  "docs/phases/ROADMAP.md"
  ".vars.example"
  "src/main/resources/application.properties"
  "make/30-interface.mk"
)

# ── Helpers ──────────────────────────────────────────────────────────────────

_replace() {
  local rel_path="$1"
  local from="$2"
  local to="$3"
  local abs_path="$REPO_ROOT/$rel_path"

  [[ -f "$abs_path" ]] || return 0
  grep -qF "$from" "$abs_path" 2>/dev/null || return 0

  if $DRY_RUN; then
    printf "  %-45s  '%s' → '%s'\n" "$rel_path" "$from" "$to"
  else
    perl -pi -e "s/\Q${from}\E/${to}/g" "$abs_path"
    printf "  updated  %s\n" "$rel_path"
  fi
}

# ── Run replacements ─────────────────────────────────────────────────────────

printf "\n"
if $DRY_RUN; then
  printf "Dry run — no files will be modified.\n"
fi
printf "Project : template-api-java → %s\n" "$NAME"
printf "Owner   : jazicorn-tw / your-org → %s\n\n" "$OWNER"

for file in "${TARGET_FILES[@]}"; do
  # Order matters: replace the most specific strings first
  _replace "$file" "template-api-java" "$NAME"
  _replace "$file" "jazicorn-tw"       "$OWNER"
  _replace "$file" "your-org"          "$OWNER"
done

# ── Summary ──────────────────────────────────────────────────────────────────

printf "\n"
if $DRY_RUN; then
  printf "Done (dry run). Re-run without --dry-run to apply.\n"
else
  printf "Done.\n"
fi

DIR_NAME="$(basename "$REPO_ROOT")"

printf "\nNext steps:\n"
printf "  1. Review changes         git diff\n"
printf "  2. Rename the directory   mv ../%s ../%s\n" "$DIR_NAME" "$NAME"
printf "  3. Set repo variables in  Settings → Secrets and variables → Actions\n"
printf "       CANONICAL_REPOSITORY = %s/%s\n" "$OWNER" "$NAME"
printf "  4. Commit                 git add -A && git commit -m 'chore: rename template to %s'\n" "$NAME"
printf "\n"
