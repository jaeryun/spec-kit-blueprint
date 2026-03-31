---
description: "Sync Epic and roadmap stage status after a spec is completed."
---

# Blueprint Epic Sync

Post-completion sync after `/speckit.specify`. Updates Epic status in `epics.md` and promotes roadmap stage status in `roadmap.md` when all Epics in a stage are complete.

## Context

This command is invoked as an `after_specify` hook. The completed feature description is available from the current conversation context — it is the argument the user passed to `/speckit.specify`.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/epics.md` does not exist:
→ Output: "ℹ️ Blueprint epics not found — skipping epic sync." and stop.

---

### Step 2: Identify the completed Epic

Read `docs/blueprint/epics.md`.

Using the completed feature description from the current conversation context, find the Epic that was just specified.

**Match criteria:** Same as `_decompose-check` — the feature clearly falls within an Epic's user-facing goal and its listed stories.

If no matching Epic is found:
→ Output: "ℹ️ No matching Epic found in epics.md — skipping sync. If this feature belongs to an Epic, update `docs/blueprint/epics.md` manually." and stop.

---

### Step 3: Update Epic status in epics.md

Update the matched Epic's status marker:

- If the spec covers the Epic's full scope → mark as **✅ Complete**
- If the spec covers part of the Epic's scope (more specify runs expected) → mark as **🚧 In Progress**

When in doubt, ask:
"Did this spec fully cover **[ENNN] — [Epic goal]**? (yes / no)"
- **yes** → mark ✅ Complete
- **no** → mark 🚧 In Progress

Save the updated `docs/blueprint/epics.md`.

Output:
```
✅ epics.md updated: [ENNN] — [Epic goal] → [✅ Complete / 🚧 In Progress]
```

---

### Step 4: Check roadmap stage completion

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping stage sync." and stop.

Read `docs/blueprint/roadmap.md`.

Find the roadmap Stage that the updated Epic belongs to (via the Epic's `Stage:` field in epics.md).

Check all Epics in that Stage:
- If **all Epics** in the Stage are ✅ Complete → the Stage is complete. Proceed to Step 5.
- If **any Epic** in the Stage is 📋 Planned or 🚧 In Progress → output: "ℹ️ Stage [stage name] still has incomplete Epics — roadmap not updated." and stop.

---

### Step 5: Update roadmap stage status

Mark the completed Stage in `roadmap.md` as done. Add a completion marker at the end of the stage's section:

```
**Status: ✅ Complete**
```

Save the updated `docs/blueprint/roadmap.md`.

Output:
```
✅ roadmap.md updated: Stage "[stage name]" → ✅ Complete (all Epics done)
```

---

### Step 6: Summary

Output a brief sync summary:

```
Blueprint sync complete:
- epics.md:   [ENNN] → [✅ Complete / 🚧 In Progress]
- roadmap.md: [updated stage name / no change]
```
