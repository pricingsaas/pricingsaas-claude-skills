#!/usr/bin/env bash
#
# bundle-skill.sh — Package a Claude Code skill directory into a portable .skill file.
#
# A .skill file is a ZIP archive containing:
#   manifest.json   — metadata (name, description, version, author, files list)
#   SKILL.md        — the skill definition
#   references/     — any supporting files (optional)
#   templates/      — any templates (optional)
#   ...             — any other files in the skill directory
#
# Usage:
#   ./bundle-skill.sh <skill-directory> [--version <ver>] [--author <author>] [--output <path>]
#
# Examples:
#   ./bundle-skill.sh plugins/pricingsaas/skills/pulse-explore
#   ./bundle-skill.sh plugins/pricingsaas/skills/pulse-explore --version 1.1.0 --author "PricingSaaS"
#   ./bundle-skill.sh plugins/pricingsaas/skills/pulse-explore --output dist/pulse-explore.skill

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────

VERSION=""
AUTHOR=""
OUTPUT=""

# ── Parse arguments ───────────────────────────────────────────────────────────

usage() {
  echo "Usage: $0 <skill-directory> [--version <ver>] [--author <author>] [--output <path>]"
  echo ""
  echo "Bundles a Claude Code skill directory into a portable .skill file (ZIP + manifest)."
  echo ""
  echo "Options:"
  echo "  --version <ver>     Version string (default: 1.0.0)"
  echo "  --author <author>   Author name (default: empty)"
  echo "  --output <path>     Output .skill file path (default: ./<skill-name>.skill)"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

SKILL_DIR="$1"
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) VERSION="$2"; shift 2 ;;
    --author)  AUTHOR="$2"; shift 2 ;;
    --output)  OUTPUT="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

# ── Validate ──────────────────────────────────────────────────────────────────

SKILL_DIR="${SKILL_DIR%/}"

if [[ ! -d "$SKILL_DIR" ]]; then
  echo "Error: '$SKILL_DIR' is not a directory." >&2
  exit 1
fi

SKILL_MD="$SKILL_DIR/SKILL.md"
if [[ ! -f "$SKILL_MD" ]]; then
  echo "Error: No SKILL.md found in '$SKILL_DIR'." >&2
  exit 1
fi

# ── Extract frontmatter from SKILL.md ─────────────────────────────────────────

# Read everything between the first pair of --- markers
FRONTMATTER=$(awk '/^---$/{if(++c==2)exit; next} c==1{print}' "$SKILL_MD")

# Extract name (single-line YAML value)
SKILL_NAME=$(echo "$FRONTMATTER" | awk -F': ' '/^name:/{print $2; exit}' | tr -d '[:space:]')

if [[ -z "$SKILL_NAME" ]]; then
  # Fall back to directory name
  SKILL_NAME=$(basename "$SKILL_DIR")
fi

# Extract description (handles multi-line YAML with | or > indicator)
SKILL_DESC=$(echo "$FRONTMATTER" | awk '
  /^description:/ {
    # Check for inline value (description: "some text")
    sub(/^description:[[:space:]]*/, "")
    if ($0 != "" && $0 != "|" && $0 != ">") {
      print $0
      exit
    }
    # Multi-line: collect indented lines
    getline
    while ($0 ~ /^[[:space:]]/) {
      sub(/^[[:space:]]+/, "")
      desc = desc (desc ? " " : "") $0
      if (!getline) break
    }
    print desc
    exit
  }
')

# Default version
if [[ -z "$VERSION" ]]; then
  VERSION="1.0.0"
fi

# Default output path
if [[ -z "$OUTPUT" ]]; then
  OUTPUT="./${SKILL_NAME}.skill"
fi

# ── Collect files ─────────────────────────────────────────────────────────────

# Get all files relative to the skill directory
FILES=()
while IFS= read -r -d '' file; do
  FILES+=("$file")
done < <(cd "$SKILL_DIR" && find . -type f -not -name '.*' -print0 | sort -z)

# Build JSON file list
FILES_JSON="["
first=true
for f in "${FILES[@]}"; do
  # Strip leading ./
  f="${f#./}"
  if $first; then
    FILES_JSON+="\"$f\""
    first=false
  else
    FILES_JSON+=",\"$f\""
  fi
done
FILES_JSON+="]"

# ── Build manifest.json ──────────────────────────────────────────────────────

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Escape description for JSON (handle quotes and newlines)
ESCAPED_DESC=$(printf '%s' "$SKILL_DESC" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')

MANIFEST=$(cat <<MANIFEST_EOF
{
  "format": "claude-skill",
  "format_version": "1.0",
  "name": "$SKILL_NAME",
  "description": $ESCAPED_DESC,
  "version": "$VERSION",
  "author": "$AUTHOR",
  "created_at": "$TIMESTAMP",
  "files": $FILES_JSON
}
MANIFEST_EOF
)

# ── Create .skill archive ────────────────────────────────────────────────────

# Ensure output directory exists
OUTPUT_DIR=$(dirname "$OUTPUT")
mkdir -p "$OUTPUT_DIR"

# Remove existing file
rm -f "$OUTPUT"

# Create a temp directory for staging
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

# Write manifest
echo "$MANIFEST" > "$STAGING/manifest.json"

# Copy skill files
for f in "${FILES[@]}"; do
  f="${f#./}"
  mkdir -p "$STAGING/$(dirname "$f")"
  cp "$SKILL_DIR/$f" "$STAGING/$f"
done

# Create ZIP (quiet, recurse, from staging dir)
(cd "$STAGING" && zip -qr - .) > "$OUTPUT"

# ── Summary ───────────────────────────────────────────────────────────────────

FILE_SIZE=$(wc -c < "$OUTPUT" | tr -d '[:space:]')
FILE_COUNT=${#FILES[@]}

echo "Bundled skill: $SKILL_NAME"
echo "  Version:  $VERSION"
echo "  Files:    $FILE_COUNT"
echo "  Size:     $FILE_SIZE bytes"
echo "  Output:   $OUTPUT"
echo ""
echo "Manifest:"
echo "$MANIFEST" | python3 -m json.tool 2>/dev/null || echo "$MANIFEST"
echo ""
echo "To inspect: unzip -l $OUTPUT"
echo "To install: unzip $OUTPUT -d ~/.claude/skills/$SKILL_NAME"
