---
description: "Link generated spec file to Spec Outline in roadmap.md after a spec is completed."
---

# Blueprint Roadmap Sync

> Auto-invoked hook — fires automatically after `/speckit.specify` and `/speckit.clarify`. Can also be run directly to recover unlinked specs.

Scans all spec files in `specs/`, finds those not yet linked in `roadmap.md`, and links each one to its matching Spec Outline. Prompts the user when a match is ambiguous.

## Context

This command is invoked as an `after_specify` or `after_clarify` hook, or directly by the user. In all cases, it operates the same way: scan `specs/` for unlinked spec files and sync them into `roadmap.md`.

**When invoked via `after_clarify`:** The spec file being clarified is already linked. This command will find it has no new unlinked specs to process and exit cleanly — unless the spec link was previously cleared or the session was interrupted.

**Recovery after interrupted session:** Run this command directly. It will detect any spec files that were created but never linked and sync them.

## Instructions

### Step 1: Check prerequisites

Run from repo root:

```bash
bash .specify/extensions/blueprint/scripts/bash/blueprint-prereqs.sh --json
```

Parse JSON output into:

- `ROADMAP_EXISTS` — boolean
- `ROADMAP_PATH` — absolute path to roadmap.md
- `SPEC_OUTLINES` — array of `{id, goal, scope, spec_linked}` objects
- `UNTRACKED_SPECS` — array of spec path strings intentionally excluded from sync

If `ROADMAP_EXISTS` is `false`:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap sync." and stop.

---

### Step 2: Find unlinked spec files

Scan the `specs/` directory at repo root for all spec directories (format: `specs/NNN-<topic>/`).

Build the list of already-linked paths from `SPEC_OUTLINES` — collect all non-empty `spec_linked` values.

**Unlinked spec** = a file in `specs/` whose path does not appear in any SO's `spec_linked` field.

Filter out any paths that appear in `UNTRACKED_SPECS` — these have been intentionally excluded and must not be presented again.

If no unlinked specs remain after filtering:
→ Output: "✅ All specs are linked — roadmap is up to date." and stop.

---

### Step 3: Match each unlinked spec to a Spec Outline

For each unlinked spec file:

1. Read the file and extract its title and a brief description of what it covers.
2. Find candidate Spec Outlines: SOs whose `spec_linked` is empty and whose goal/scope semantically matches the spec content.

Apply the following match rules:

#### Clear match

One SO with an empty `spec_linked` clearly matches the spec content.

→ Present to user:

```text
📎 [spec file path]
   → SO-[NN] — [Spec Outline goal]
   Proceed with this link? (yes / no / skip)
```

- **yes** → add to confirmed link list
- **no** → treat as ambiguous (ask user to pick)
- **skip** → ask: "Add to Untracked Specs so future syncs skip it? (yes / no)" — if yes, call `blueprint-sync.sh --untrack`; note in summary either way

#### Ambiguous match

Multiple SOs are plausible candidates, or the spec content does not clearly align with any single SO.

→ Present to user:

```text
⚠️ [spec file path] — ambiguous match.

Candidates:
  A) SO-[NN] — [goal]
  B) SO-[NM] — [goal]
  C) None of these — skip for now

Which Spec Outline does this spec belong to?
```

Wait for user selection. If C → ask: "Add to Untracked Specs so future syncs skip it? (yes / no)" — if yes, call `blueprint-sync.sh --untrack`; note in summary either way.

#### No match

No SO has an empty `spec_linked` that fits the spec content.

→ Output:

```text
ℹ️ [spec file path] — no matching Spec Outline found.
   Add to Untracked Specs so future syncs skip it? (yes / no)
```

- **yes** → call `blueprint-sync.sh --untrack`; note in summary as untracked
- **no** → note in summary as skipped (will appear again next sync)

**Special case — Case D SO-ID in context:** If `roadmap-check` stored a confirmed SO-ID in conversation context during Case D Option A handling, apply that SO-ID directly to the matching spec file without semantic matching.

---

### Step 4: Apply all roadmap.md updates

**For each confirmed (spec file, SO-ID) link pair**, run from repo root:

```bash
bash .specify/extensions/blueprint/scripts/bash/blueprint-sync.sh \
    --so-id [SO_ID] \
    --spec-path [SPEC_FILE] \
    --message "[SUMMARY]" \
    --json
```

**For each spec file the user chose to untrack**, run from repo root:

```bash
bash .specify/extensions/blueprint/scripts/bash/blueprint-sync.sh \
    --untrack \
    --spec-path [SPEC_FILE] \
    --message "[REASON]" \
    --json
```

For both: `SUCCESS` is `true` → proceed to next. `SUCCESS` is `false` → output `ERROR` value, skip this entry, continue with remaining.

**Do NOT manually edit roadmap.md.** The script handles atomic update and history entry insertion.

---

### Step 5: Summary

After processing all unlinked specs, output:

```text
Blueprint sync complete.

Linked ([N]):
  - SO-[NN] → [spec file path]
  - SO-[NM] → [spec file path]

Untracked ([N]):
  - [spec file path] — added to Untracked Specs (future syncs will skip)

Skipped ([N]):
  - [spec file path] — [reason: no match / user skipped — will reappear next sync]
```

If all specs were either linked or untracked (nothing left floating):

```text
✅ roadmap.md is up to date.
```
