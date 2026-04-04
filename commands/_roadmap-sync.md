---
description: "Sync Spec Outline status in roadmap.md after a spec is completed."
---

# Blueprint Roadmap Sync

> Auto-invoked hook — fires automatically after `/speckit.specify`. Do not invoke directly.

Post-completion sync after `/speckit.specify`. Updates Spec Outline status in `roadmap.md`.

## Context

This command is invoked as an `after_specify` or `after_clarify` hook. The completed feature description is available from the current conversation context — it is the argument the user passed to `/speckit.specify` or `/speckit.clarify`.

When invoked via `after_clarify`, the argument is a change description for a specific spec file. Identify the spec file being clarified from the current conversation context, then match it against the `Spec:` field in `roadmap.md` to find the corresponding Spec Outline — do not rely on semantic matching or `[🚧]` status for this case.

**Fallback when spec file is not linked:** If the spec file being clarified does not match any `Spec:` field in `roadmap.md` (e.g., after an interrupted session, or after a single SO was reset via option (3)), fall back to matching against Spec Outline goals using the same STRICT match criteria defined in Step 2. Ask the user to confirm the match before writing.

**Recovery after interrupted session:** If the specify run was interrupted (session ended before `after_specify` fired), this hook will not have run. To recover manually: do NOT use `/speckit.blueprint.roadmap` option (3) — instead, open `docs/blueprint/roadmap.md` directly and update the Spec Outline status and `Spec:` field manually, following the format in Step 2 below.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap sync." and stop.

---

### Step 2: Identify the completed Spec Outline

Read `docs/blueprint/roadmap.md`.

Find all Spec Outline entries. Spec Outlines are identified by their ID (SO-01, SO-02...).

Using the completed feature description from the current conversation context, find the Spec Outline that was just specified.

**Match criteria:** The match must be STRICT — this is a write operation that modifies roadmap.md status:

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

To update manually, open docs/blueprint/roadmap.md and:
  1. Change the Spec Outline's status marker:
       [📋] → [🚧]  if this is a partial-coverage first run
       [📋] or [🚧] → [✅]  if coverage is complete
  2. Set the Spec: field to the path of the generated spec file.
```

---

### Step 3: Evaluate coverage and propose status update

Compare the completed feature description against the matched **SO-NN — [goal]** and its defined scope.

**Proactive Judgment:**
- If the spec fully addresses the Spec Outline's scope → Propose `[✅]` Complete.
- If the spec addresses only part of the scope or implies further work → Propose `[🚧]` In Progress.

Present your judgment and reasoning to the user:

```text
I've matched this spec to **SO-NN — [goal]**.
Based on the content, this covers the scope [fully / partially] because [brief reasoning].

I'll mark this as [✅ Complete / 🚧 In Progress]. Is this correct? (yes / no)
```

Wait for user response.

- **yes** → Apply the proposed status.
- **no** → Ask for clarification: "Should it be marked as [Complete / In Progress / Deferred / Excluded], or did I match the wrong Spec Outline?"
  - If the user provides a different status → Apply it and proceed.
  - If the user says it's the wrong Spec Outline → Ask: "Which Spec Outline should this be linked to?" — re-match and repeat from Step 3.

**Progressing from [🚧] to [✅]:** A Spec Outline marked [🚧] In Progress will be re-evaluated each time `_roadmap-sync` fires for that Spec Outline. To promote it to [✅] Complete, run `/speckit.specify` or `/speckit.clarify` on the remaining scope — this triggers `_roadmap-sync` again with updated coverage.

The status markers used in `roadmap.md` are (refer to `roadmap-template.md` for full definitions):

- `[📋]` Planned
- `[🚧]` In Progress
- `[✅]` Complete
- `[⏸️]` Deferred
- `[❌]` Excluded

**Spec file mapping:** Identify the spec file produced by this specify run from the current conversation context (typically the file path of the generated `spec.md`). The path must be relative to the project root (e.g., `docs/spec/auth.md`). Update the `Spec:` field of the matched Spec Outline:

```text
  - Spec: [spec file path]
```

If the spec file path cannot be determined, leave `Spec:` unchanged.

Append a new line to the History section reflecting the result of the sync:

Format: `[TIMESTAMP] | SO-[NN] [Outcome summary]`

Examples of concise summaries:
- `SO-01 status updated to Complete`
- `SO-02 status updated to In Progress`
- `SO-03 spec file updated`
- `SO-04 spec clarified: [one-line summary of change]`

**Before saving:** Verify the roadmap.md content is valid — check that no duplicate Spec Outline IDs exist and all status markers use the correct format (`[📋]`, `[🚧]`, `[✅]`, `[⏸️]`, or `[❌]`). If invalid content is detected, output an error and do not save.

Save the updated `docs/blueprint/roadmap.md`.

Output:

```text
✅ roadmap.md updated: [SO-NN] — [Spec Outline goal] → [new status]
   Spec: [spec file path]
```

---

### Step 4: Summary

Output a brief sync summary:

```text
Blueprint sync complete:
- Spec Outline: [SO-NN] → [new status]
```
