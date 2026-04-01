---
description: "Sync Spec Outline and roadmap stage status after a spec is completed."
---

# Blueprint Roadmap Sync

> Auto-invoked hook — fires automatically after `/speckit.specify`. Do not invoke directly.

Post-completion sync after `/speckit.specify`. Updates Spec Outline status in `roadmap.md` and promotes roadmap stage status when all Spec Outlines in a stage are complete.

## Context

This command is invoked as an `after_specify` hook. The completed feature description is available from the current conversation context — it is the argument the user passed to `/speckit.specify`.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap sync." and stop.

---

### Step 2: Identify the completed Spec Outline

Read `docs/blueprint/roadmap.md`.

Find all Spec Outline entries. Spec Outlines are identified by their Spec Outline identifier (Spec Outline 001, Spec Outline 002...) and appear under `**Spec Outline:**` sections within each Stage.

Using the completed feature description from the current conversation context, find the Spec Outline that was just specified.

**Match criteria:** The match must be STRICT — this is a write operation that modifies roadmap.md status:
- The feature description must clearly and specifically match the Spec Outline's user-facing goal
- Partial or ambiguous overlap is NOT enough — when in doubt, ask the user to confirm
- If match confidence is low, output the top candidate and ask: "Is this the Spec Outline you just specified? (yes / no)" — if no, treat as no match

If no matching Spec Outline is found:
→ Output the message below and stop.

```
ℹ️ No matching Spec Outline found — skipping sync.

To update manually, open docs/blueprint/roadmap.md and change the Spec Outline's status marker:
  [📋] → [🚧] for In Progress
  [📋] or [🚧] → [✅] for Complete

If all Spec Outlines in a Stage are ✅ Complete, also add to the end of that Stage:
  **Status:** ✅ Complete
```

---

### Step 3: Confirm coverage and update Spec Outline status

Ask the user:
```
This spec appears to match **Spec Outline NNN — [goal]**.

Did this spec cover it?
  (yes) → Mark ✅ Complete
  (partial) → Mark 🚧 In Progress
  (wrong) → Let me identify the correct Spec Outline
```

Wait for user response.
- **yes** → mark the Spec Outline as `[✅]` Complete
- **partial** → mark the Spec Outline as `[🚧]` In Progress
- **wrong** → ask: "Which Spec Outline did this spec cover? (provide number or goal)" — re-match against the user's answer and proceed from Step 3 with the corrected Spec Outline

The status markers used in `roadmap.md` are:
- `[📋]` Planned
- `[🚧]` In Progress
- `[✅]` Complete

Save the updated `docs/blueprint/roadmap.md`.

Output:
```
✅ roadmap.md updated: [Spec Outline NNN] — [Spec Outline goal] → [✅ Complete / 🚧 In Progress]
```

---

### Step 4: Check roadmap stage completion

Find the Stage that the updated Spec Outline belongs to.

Check all Spec Outlines within that Stage:
- If **all Spec Outlines** in the Stage are `[✅]` Complete → the Stage is complete. Proceed to Step 5.
- If **any Spec Outline** in the Stage is `[📋]` Planned or `[🚧]` In Progress → output: "ℹ️ Stage [stage name] still has incomplete Spec Outlines — stage status not updated." and proceed to Step 6.

---

### Step 5: Update roadmap stage status

Mark the completed Stage in `roadmap.md` as done. Add or update the status line at the end of the stage's section:

```
**Status: ✅ Complete**
```

Save the updated `docs/blueprint/roadmap.md`.

Output:
```
✅ roadmap.md updated: Stage "[stage name]" → ✅ Complete (all Spec Outlines done)
```

---

### Step 6: Summary

Output a brief sync summary:

```
Blueprint sync complete:
- Spec Outline: [Spec Outline NNN] → [✅ Complete / 🚧 In Progress]
- Stage "[stage name]": [✅ Complete (all Spec Outlines done) / incomplete Spec Outlines remain]
```
