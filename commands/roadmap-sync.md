---
description: "Link generated spec file to Spec Outline in roadmap.md after a spec is completed."
---

# Blueprint Roadmap Sync

> Auto-invoked hook — fires automatically after `/speckit.specify`. Do not invoke directly.

Post-completion sync after `/speckit.specify`. Links the generated spec file to the matched Spec Outline in `roadmap.md`.

## Context

This command is invoked as an `after_specify` or `after_clarify` hook. The completed feature description is available from the current conversation context — it is the argument the user passed to `/speckit.specify` or `/speckit.clarify`.

When invoked via `after_clarify`, the argument is a change description for a specific spec file. Identify the spec file being clarified from the current conversation context, then match it against the `Spec:` field in `roadmap.md` to find the corresponding Spec Outline — do not rely on semantic matching for this case.

**Fallback when spec file is not linked (after_clarify only):** If the spec file being clarified does not match any `Spec:` field in `roadmap.md` (e.g., after an interrupted session, or after a single SO was reset via option (3)), fall back to matching against Spec Outline goals using the same STRICT match criteria defined in Step 2. Ask the user to confirm the match before writing.

**Recovery after interrupted session:** If the specify run was interrupted (session ended before `after_specify` fired), this hook will not have run. To recover manually, run the sync script directly:
`bash .specify/extensions/blueprint/scripts/bash/blueprint-sync.sh --so-id [SO_ID] --spec-path [path] --json`

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap sync." and stop.

---

### Step 2: Identify the completed Spec Outline

Read `docs/blueprint/roadmap.md`.

Find all Spec Outline entries. Spec Outlines are identified by their ID (SO-01, SO-02...).

Using the completed feature description from the current conversation context, find the Spec Outline that was just specified.

**Match criteria:** The match must be STRICT — this is a write operation that modifies roadmap.md:

- The feature description must clearly and specifically match the Spec Outline's user-facing goal
- Partial or ambiguous overlap is NOT enough — when in doubt, ask the user to confirm
- If match confidence is low, output the top candidate and ask: "Is this the Spec Outline you just specified? (yes / no)" — if no, treat as no match

If no matching Spec Outline is found:
→ Output the message below and stop.

```text
ℹ️ No matching Spec Outline found — skipping sync.

Top candidates (closest semantic match):
  - SO-[NN] — [goal]
  - SO-[NM] — [goal]

To update manually, open docs/blueprint/roadmap.md and set the Spec: field to the path of the generated spec file.
```

---

### Step 3: Link the spec file

Identify:

- `SO_ID` — matched Spec Outline ID from Step 2 (e.g., `SO-01`)
- `SPEC_FILE` — relative path to the spec file from this specify run (e.g., `docs/spec/auth.md`)
- `SUMMARY` — one-line description (e.g., `"auth spec created"`)

Run from repo root:

```bash
bash .specify/extensions/blueprint/scripts/bash/blueprint-sync.sh \
    --so-id [SO_ID] \
    --spec-path [SPEC_FILE] \
    --message "[SUMMARY]" \
    --json
```

Parse JSON response:

- `SUCCESS` is `true` → proceed to Step 4
- `SUCCESS` is `false` → output `ERROR` value and stop

**Do NOT manually edit roadmap.md.** The script handles atomic update and history entry insertion.

If `SPEC_FILE` cannot be determined from conversation context:

```text
⚠️ Spec file path could not be determined — skipping sync.
To update manually:
  bash .specify/extensions/blueprint/scripts/bash/blueprint-sync.sh \
    --so-id [SO_ID] --spec-path [path] --json
```

---

### Step 4: Summary

Output:

```text
✅ roadmap.md updated: [SO_ID] — [Spec Outline goal]
   Spec: [SPEC_FILE]
```

Then:

```text
Blueprint sync complete:
- Spec Outline: [SO_ID] — spec linked → [SPEC_FILE]
```
