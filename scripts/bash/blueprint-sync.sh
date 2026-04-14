#!/usr/bin/env bash
# blueprint-sync.sh — Atomic roadmap.md updater
#
# Mode 1 — Link spec to SO:
#   blueprint-sync.sh --so-id SO-01 --spec-path specs/001-auth/ [--message "summary"] [--json]
#   {"SUCCESS":true,"SO_ID":"SO-01","SPEC_PATH":"specs/001-auth/","ROADMAP_PATH":"..."}
#
# Mode 2 — Mark spec as untracked:
#   blueprint-sync.sh --untrack --spec-path specs/004-auth-spike/ [--message "reason"] [--json]
#   {"SUCCESS":true,"ACTION":"untrack","SPEC_PATH":"specs/004-auth-spike/","ROADMAP_PATH":"..."}
#
# Error output (both modes):
#   {"SUCCESS":false,"ERROR":"..."}

set -euo pipefail

SO_ID=""
SPEC_PATH=""
MESSAGE=""
JSON_MODE=false
UNTRACK_MODE=false

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
        --untrack)
            UNTRACK_MODE=true; shift ;;
        --help|-h)
            echo "Usage:"
            echo "  $0 --so-id SO-01 --spec-path specs/001-auth/ [--message text] [--json]"
            echo "  $0 --untrack --spec-path specs/004-auth-spike/ [--message reason] [--json]"
            exit 0 ;;
        *)
            echo "Unknown argument: $1" >&2; exit 1 ;;
    esac
done

if $UNTRACK_MODE; then
    if [ -z "$SPEC_PATH" ]; then
        echo "Error: --spec-path is required" >&2; exit 1
    fi
else
    if [ -z "$SO_ID" ] || [ -z "$SPEC_PATH" ]; then
        echo "Error: --so-id and --spec-path are required" >&2
        exit 1
    fi
fi

# Validate SO_ID format — prevent ERE injection in grep patterns below
if ! $UNTRACK_MODE; then
    if ! printf '%s' "$SO_ID" | grep -qE '^SO-[0-9]+$'; then
        echo "Error: --so-id must match SO-NN format (e.g. SO-01)" >&2; exit 1
    fi
fi

# Reject absolute paths — spec path must be relative to repo root
case "$SPEC_PATH" in
    /*) echo "Error: --spec-path must be a relative path (e.g. specs/001-auth/)" >&2; exit 1 ;;
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

# ── UNTRACK MODE ────────────────────────────────────────────────────────────
if $UNTRACK_MODE; then
    # Idempotency: check if already listed under ## Untracked Specs
    _already=false
    _in_ut=false
    while IFS= read -r _line; do
        if printf '%s' "$_line" | grep -qE '^## Untracked Specs$'; then
            _in_ut=true; continue
        fi
        if $_in_ut && printf '%s' "$_line" | grep -qE '^## '; then
            _in_ut=false
        fi
        if $_in_ut && [ "$_line" = "- $SPEC_PATH" ]; then
            _already=true; break
        fi
    done < "$ROADMAP_PATH"

    if $_already; then
        if $JSON_MODE; then
            _esc_spec=$(printf '%s' "$SPEC_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
            _esc_roadmap=$(printf '%s' "$ROADMAP_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
            printf '{"SUCCESS":true,"ACTION":"untrack","NOTE":"already untracked","SPEC_PATH":"%s","ROADMAP_PATH":"%s"}\n' \
                "$_esc_spec" "$_esc_roadmap"
        else
            echo "[OK] $SPEC_PATH is already in Untracked Specs"
        fi
        exit 0
    fi

    # Append entry at end of ## Untracked Specs section (before next heading or EOF)
    TEMP_FILE=$(mktemp "$(dirname "$ROADMAP_PATH")/.blueprint-sync.XXXXXX")
    trap 'rm -f "$TEMP_FILE"' EXIT

    _in_ut=false
    _inserted=false
    while IFS= read -r line; do
        if printf '%s' "$line" | grep -qE '^## Untracked Specs$'; then
            _in_ut=true
            printf '%s\n' "$line" >> "$TEMP_FILE"
            continue
        fi
        if $_in_ut && ! $_inserted && printf '%s' "$line" | grep -qE '^## '; then
            # Next section starts — flush our entry first
            printf '- %s\n' "$SPEC_PATH" >> "$TEMP_FILE"
            _inserted=true
            _in_ut=false
        fi
        printf '%s\n' "$line" >> "$TEMP_FILE"
    done < "$ROADMAP_PATH"

    # Section found but EOF came before next heading
    if $_in_ut && ! $_inserted; then
        printf '- %s\n' "$SPEC_PATH" >> "$TEMP_FILE"
        _inserted=true
    fi

    # Section missing entirely — create it
    if ! $_inserted; then
        printf '\n## Untracked Specs\n\n- %s\n' "$SPEC_PATH" >> "$TEMP_FILE"
    fi

    # Append history entry
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
    if [ -n "$MESSAGE" ]; then
        HISTORY_ENTRY="$TIMESTAMP | $SPEC_PATH marked as untracked — $MESSAGE"
    else
        HISTORY_ENTRY="$TIMESTAMP | $SPEC_PATH marked as untracked"
    fi

    TEMP_FILE2=$(mktemp "$(dirname "$ROADMAP_PATH")/.blueprint-sync2.XXXXXX")
    trap 'rm -f "$TEMP_FILE" "$TEMP_FILE2"' EXIT

    HISTORY_ENTRY="$HISTORY_ENTRY" awk '
        /^## History$/ { print; print ENVIRON["HISTORY_ENTRY"]; next }
        { print }
    ' "$TEMP_FILE" > "$TEMP_FILE2"

    if ! grep -q "^## History$" "$TEMP_FILE"; then
        printf '\n## History\n%s\n' "$HISTORY_ENTRY" >> "$TEMP_FILE2"
    fi

    mv "$TEMP_FILE2" "$ROADMAP_PATH"

    if $JSON_MODE; then
        if command -v jq >/dev/null 2>&1; then
            jq -cn \
                --argjson success true \
                --arg action "untrack" \
                --arg spec_path "$SPEC_PATH" \
                --arg roadmap_path "$ROADMAP_PATH" \
                '{SUCCESS:$success,ACTION:$action,SPEC_PATH:$spec_path,ROADMAP_PATH:$roadmap_path}'
        else
            _esc_spec=$(printf '%s' "$SPEC_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
            _esc_roadmap=$(printf '%s' "$ROADMAP_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
            printf '{"SUCCESS":true,"ACTION":"untrack","SPEC_PATH":"%s","ROADMAP_PATH":"%s"}\n' \
                "$_esc_spec" "$_esc_roadmap"
        fi
    else
        echo "[OK] $SPEC_PATH added to Untracked Specs"
        echo "History: $HISTORY_ENTRY"
    fi
    exit 0
fi
# ── END UNTRACK MODE ─────────────────────────────────────────────────────────

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
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
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
