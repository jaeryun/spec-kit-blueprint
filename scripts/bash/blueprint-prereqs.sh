#!/usr/bin/env bash
# blueprint-prereqs.sh — Blueprint prerequisites check
# Returns JSON with vision/roadmap status and parsed Spec Outlines
#
# Usage: blueprint-prereqs.sh [--json] [--help]
# Output (JSON mode):
# {
#   "VISION_EXISTS": true,
#   "VISION_PATH": "/abs/path/docs/blueprint/vision.md",
#   "ROADMAP_EXISTS": true,
#   "ROADMAP_PATH": "/abs/path/docs/blueprint/roadmap.md",
#   "SPEC_OUTLINES": [
#     {"id": "SO-01", "goal": "Users can register...", "scope": "Sign-up flow, login/logout...", "spec_linked": "docs/spec/auth.md"},
#     {"id": "SO-02", "goal": "...", "scope": "...", "spec_linked": ""}
#   ]
# }
#
# Note: SO goal text is single-line only. If a goal spans multiple lines in roadmap.md,
#       only the first line is captured. This is a known limitation.

set -euo pipefail

JSON_MODE=false

while [ $# -gt 0 ]; do
    case "$1" in
        --json) JSON_MODE=true; shift ;;
        --help|-h)
            echo "Usage: $0 [--json]"
            echo "  --json    Output in JSON format"
            exit 0 ;;
        *) shift ;;
    esac
done

# Resolve repo root — walk up from script location, trust only .git
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
while [ "$REPO_ROOT" != "/" ]; do
    if [ -d "$REPO_ROOT/.git" ]; then
        break
    fi
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done

if [ "$REPO_ROOT" = "/" ]; then
    echo '{"ERROR":"Could not find repo root (.git not found)"}' >&2
    exit 1
fi

VISION_PATH="$REPO_ROOT/docs/blueprint/vision.md"
ROADMAP_PATH="$REPO_ROOT/docs/blueprint/roadmap.md"

VISION_EXISTS=false
ROADMAP_EXISTS=false

[ -f "$VISION_PATH" ] && VISION_EXISTS=true
[ -f "$ROADMAP_PATH" ] && ROADMAP_EXISTS=true

# Flush current SO entry into _so_outlines.
# Note: goal text is single-line only (multi-line goals are not supported;
#       only the first line is captured). This is a known limitation.
_emit_so_entry() {
    if [ -z "$_so_id" ]; then return; fi
    local escaped_id escaped_goal escaped_scope escaped_spec
    escaped_id=$(printf '%s' "$_so_id" | sed 's/\\/\\\\/g; s/"/\\"/g')
    escaped_goal=$(printf '%s' "$_so_goal" | sed 's/\\/\\\\/g; s/"/\\"/g')
    escaped_scope=$(printf '%s' "$_so_scope" | sed 's/\\/\\\\/g; s/"/\\"/g')
    escaped_spec=$(printf '%s' "$_so_spec" | sed 's/\\/\\\\/g; s/"/\\"/g')
    if [ "$_so_first" = true ]; then
        _so_first=false
    else
        _so_outlines="${_so_outlines},"
    fi
    _so_outlines="${_so_outlines}{\"id\":\"${escaped_id}\",\"goal\":\"${escaped_goal}\",\"scope\":\"${escaped_scope}\",\"spec_linked\":\"${escaped_spec}\"}"
}

# Parse Spec Outlines from roadmap.md
# Actual format (bullet list, NOT pipe table):
#   - **SO-01** — User-facing goal
#     - Scope: ...
#     - Spec: — (or docs/spec/auth.md)
parse_spec_outlines() {
    local roadmap="$1"
    # Use module-level globals prefixed with _so_ to avoid nested-function scope issues
    _so_outlines="["
    _so_first=true
    _so_id="" _so_goal="" _so_scope="" _so_spec=""

    while IFS= read -r line; do
        # Match: - **SO-01** — goal text  (SO-NN requires one or more digits)
        if printf '%s' "$line" | grep -qE '^- \*\*SO-[0-9]+\*\*'; then
            _emit_so_entry
            _so_id=$(printf '%s' "$line" | sed 's/^- \*\*\(SO-[0-9][0-9]*\)\*\*.*/\1/')
            _so_goal=$(printf '%s' "$line" | sed 's/^- \*\*SO-[0-9][0-9]*\*\* — //')
            _so_scope=""
            _so_spec=""
        # Match:   - Scope: value (indented)
        elif printf '%s' "$line" | grep -qE '^[[:space:]]+-[[:space:]]Scope:[[:space:]]'; then
            _so_scope=$(printf '%s' "$line" | sed 's/^[[:space:]]*-[[:space:]]Scope:[[:space:]]*//')
        # Match:   - Spec: value (indented)
        elif printf '%s' "$line" | grep -qE '^[[:space:]]+-[[:space:]]Spec:[[:space:]]'; then
            _so_spec=$(printf '%s' "$line" | sed 's/^[[:space:]]*-[[:space:]]Spec:[[:space:]]*//')
            # Normalize "—" or "-" to empty (not linked)
            case "$_so_spec" in
                "—"|"-") _so_spec="" ;;
            esac
        fi
    done < "$roadmap"
    _emit_so_entry  # flush last entry

    _so_outlines="${_so_outlines}]"
    printf '%s' "$_so_outlines"
}

if $JSON_MODE; then
    SPEC_OUTLINES_JSON="[]"
    if [ "$ROADMAP_EXISTS" = true ]; then
        SPEC_OUTLINES_JSON=$(parse_spec_outlines "$ROADMAP_PATH")
    fi

    if command -v jq >/dev/null 2>&1; then
        jq -cn \
            --argjson vision_exists "$VISION_EXISTS" \
            --arg vision_path "$VISION_PATH" \
            --argjson roadmap_exists "$ROADMAP_EXISTS" \
            --arg roadmap_path "$ROADMAP_PATH" \
            --argjson spec_outlines "$SPEC_OUTLINES_JSON" \
            '{
                VISION_EXISTS: $vision_exists,
                VISION_PATH: $vision_path,
                ROADMAP_EXISTS: $roadmap_exists,
                ROADMAP_PATH: $roadmap_path,
                SPEC_OUTLINES: $spec_outlines
            }'
    else
        # printf fallback when jq is unavailable — avoids heredoc $() command substitution risk
        _escaped_vision=$(printf '%s' "$VISION_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
        _escaped_roadmap=$(printf '%s' "$ROADMAP_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
        printf '%s\n' "{\"VISION_EXISTS\":${VISION_EXISTS},\"VISION_PATH\":\"${_escaped_vision}\",\"ROADMAP_EXISTS\":${ROADMAP_EXISTS},\"ROADMAP_PATH\":\"${_escaped_roadmap}\",\"SPEC_OUTLINES\":${SPEC_OUTLINES_JSON}}"
    fi
else
    echo "VISION_EXISTS: $VISION_EXISTS"
    echo "VISION_PATH: $VISION_PATH"
    echo "ROADMAP_EXISTS: $ROADMAP_EXISTS"
    echo "ROADMAP_PATH: $ROADMAP_PATH"
fi
