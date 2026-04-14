#!/usr/bin/env bash
# blueprint-sync.sh — Atomic Spec: field update for a Spec Outline in roadmap.md
#
# Usage: blueprint-sync.sh --so-id SO-01 --spec-path docs/spec/auth.md [--message "summary"] [--json]
# Output (JSON mode):
#   {"SUCCESS":true,"SO_ID":"SO-01","SPEC_PATH":"docs/spec/auth.md","ROADMAP_PATH":"..."}
#   {"SUCCESS":false,"ERROR":"SO-01 not found in roadmap.md"}

set -euo pipefail

SO_ID=""
SPEC_PATH=""
MESSAGE=""
JSON_MODE=false

# shift-based arg parsing (POSIX-safe, no ${!i} indirect expansion)
while [ $# -gt 0 ]; do
    case "$1" in
        --so-id)
            SO_ID="${2:-}"; shift 2 ;;
        --spec-path)
            SPEC_PATH="${2:-}"; shift 2 ;;
        --message)
            MESSAGE="${2:-}"; shift 2 ;;
        --json)
            JSON_MODE=true; shift ;;
        --help|-h)
            echo "Usage: $0 --so-id SO-01 --spec-path docs/spec/auth.md [--message text] [--json]"
            exit 0 ;;
        *)
            echo "Unknown argument: $1" >&2; exit 1 ;;
    esac
done

if [ -z "$SO_ID" ] || [ -z "$SPEC_PATH" ]; then
    echo "Error: --so-id and --spec-path are required" >&2
    exit 1
fi

# Validate SO_ID format — prevent ERE injection in grep patterns below
if ! printf '%s' "$SO_ID" | grep -qE '^SO-[0-9]+$'; then
    echo "Error: --so-id must match SO-NN format (e.g. SO-01)" >&2; exit 1
fi

# Reject absolute paths — spec path must be relative to repo root
case "$SPEC_PATH" in
    /*) echo "Error: --spec-path must be a relative path (e.g. docs/spec/auth.md)" >&2; exit 1 ;;
esac

# Resolve repo root — trust only .git
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
while [ "$REPO_ROOT" != "/" ]; do
    if [ -d "$REPO_ROOT/.git" ]; then
        break
    fi
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done

if [ "$REPO_ROOT" = "/" ]; then
    echo '{"SUCCESS":false,"ERROR":"Could not find repo root (.git not found)"}' >&2
    exit 1
fi

ROADMAP_PATH="$REPO_ROOT/docs/blueprint/roadmap.md"

fail() {
    local msg="$1"
    if $JSON_MODE; then
        printf '{"SUCCESS":false,"ERROR":"%s"}\n' "$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g')"
    else
        echo "Error: $msg" >&2
    fi
    exit 1
}

[ -f "$ROADMAP_PATH" ] || fail "roadmap.md not found at $ROADMAP_PATH"

# Strict existence check: match actual SO declaration line
# Format: - **SO-01** — goal
if ! grep -qE "^- \*\*${SO_ID}\*\*" "$ROADMAP_PATH"; then
    fail "$SO_ID not found in roadmap.md"
fi

# Create temp file in same directory as roadmap (avoids cross-device mv)
TEMP_FILE=$(mktemp "$(dirname "$ROADMAP_PATH")/.blueprint-sync.XXXXXX")
trap 'rm -f "$TEMP_FILE"' EXIT

# Update Spec: field for the matched SO block
# Actual format:
#   - **SO-01** — goal
#     - Scope: ...
#     - Spec: —          ← update this line
#
# Strategy: state-machine line-by-line, replace the first "  - Spec:" inside the matched block
FOUND=false
IN_BLOCK=false

while IFS= read -r line; do
    # Entering the target SO block
    if printf '%s' "$line" | grep -qE "^- \*\*${SO_ID}\*\*"; then
        IN_BLOCK=true
        printf '%s\n' "$line" >> "$TEMP_FILE"
        continue
    fi

    # New SO block starts → exit previous block
    if $IN_BLOCK && printf '%s' "$line" | grep -qE '^- \*\*SO-[0-9]+\*\*'; then
        IN_BLOCK=false
    fi

    # Replace Spec: line inside the matched block (only first occurrence)
    if $IN_BLOCK && ! $FOUND && printf '%s' "$line" | grep -qE '^[[:space:]]+-[[:space:]]Spec:[[:space:]]'; then
        # Preserve original indentation
        indent=$(printf '%s' "$line" | sed 's/\(^[[:space:]]*\).*/\1/')
        printf '%s- Spec: %s\n' "$indent" "$SPEC_PATH" >> "$TEMP_FILE"
        FOUND=true
        continue
    fi

    printf '%s\n' "$line" >> "$TEMP_FILE"
done < "$ROADMAP_PATH"

$FOUND || fail "Spec: field not found for $SO_ID — check roadmap.md format"

# Append history entry immediately after "## History" header
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
if [ -n "$MESSAGE" ]; then
    HISTORY_ENTRY="$TIMESTAMP | $SO_ID spec linked: $SPEC_PATH — $MESSAGE"
else
    HISTORY_ENTRY="$TIMESTAMP | $SO_ID spec linked: $SPEC_PATH"
fi

TEMP_FILE2=$(mktemp "$(dirname "$ROADMAP_PATH")/.blueprint-sync2.XXXXXX")
trap 'rm -f "$TEMP_FILE" "$TEMP_FILE2"' EXIT

HISTORY_ENTRY="$HISTORY_ENTRY" awk '
    /^## History$/ { print; print ENVIRON["HISTORY_ENTRY"]; next }
    { print }
' "$TEMP_FILE" > "$TEMP_FILE2"

# If History section didn't exist, append it to TEMP_FILE2 (not ROADMAP_PATH)
if ! grep -q "^## History$" "$TEMP_FILE"; then
    printf '\n## History\n%s\n' "$HISTORY_ENTRY" >> "$TEMP_FILE2"
fi

# Atomic replace
mv "$TEMP_FILE2" "$ROADMAP_PATH"

if $JSON_MODE; then
    if command -v jq >/dev/null 2>&1; then
        jq -cn \
            --argjson success true \
            --arg so_id "$SO_ID" \
            --arg spec_path "$SPEC_PATH" \
            --arg roadmap_path "$ROADMAP_PATH" \
            '{SUCCESS:$success,SO_ID:$so_id,SPEC_PATH:$spec_path,ROADMAP_PATH:$roadmap_path}'
    else
        _escaped_roadmap=$(printf '%s' "$ROADMAP_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
        _escaped_spec=$(printf '%s' "$SPEC_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
        _escaped_so=$(printf '%s' "$SO_ID" | sed 's/\\/\\\\/g; s/"/\\"/g')
        cat <<EOF
{"SUCCESS":true,"SO_ID":"${_escaped_so}","SPEC_PATH":"${_escaped_spec}","ROADMAP_PATH":"${_escaped_roadmap}"}
EOF
    fi
else
    echo "[OK] $SO_ID -> Spec: $SPEC_PATH"
    echo "History: $HISTORY_ENTRY"
fi
