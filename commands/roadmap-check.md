---
description: "Validate that the feature being specified aligns with the current roadmap and epics."
---

# Blueprint Roadmap Check

Pre-flight validation before `/speckit.specify`. Detects roadmap divergence before a spec branch is created.

## Context

This command is invoked as a `before_specify` hook. The feature description is available from the current conversation context — it is the argument the user passed to `/speckit.specify`.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap alignment check." and stop (allow specify to proceed).

If `docs/blueprint/epics.md` does not exist:
→ Output: "ℹ️ Blueprint epics not found — skipping roadmap alignment check." and stop (allow specify to proceed).

---

### Step 2: Read roadmap and epics

Read both files:
- `docs/blueprint/roadmap.md`
- `docs/blueprint/epics.md`

---

### Step 3: Match feature to Epic

Using the feature description from the current conversation context, determine which Epic(s) in `epics.md` this feature falls under.

**Match criteria:** The feature clearly falls within an Epic's user-facing goal and its listed stories. Partial or ambiguous overlap counts as a match — prefer false positives over false negatives.

---

### Step 4: Handle match result

#### Case A — Clear match, Epic is 📋 Planned

Output:
```
✅ Roadmap aligned: maps to **[ENNN]** — [Epic goal]
Proceeding with specification.
```

Stop. Allow specify to proceed.

---

#### Case B — Clear match, Epic is 🚧 In Progress or ✅ Complete

Output:
```
⚠️ Epic [ENNN] is already [in progress / complete].

Confirm this is an extension or fix within that Epic's scope, not a duplicate or scope creep.

Proceed? (yes / no)
```

Wait for user response.
- **yes** → allow specify to proceed.
- **no** → stop. Suggest: "Consider running `/speckit.blueprint.decompose` to add a new Epic first."

---

#### Case C — No matching Epic found

Output:
```
⚠️ Roadmap Divergence Detected

"[feature description]" does not map to any Epic in the current roadmap.

Options:
  A) Update roadmap first — run `/speckit.blueprint.decompose` to add this as a new Epic, then re-run specify.
  B) Proceed anyway — this is a minor addition not worth a separate Epic.
  C) Cancel.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.decompose` to update the Epic plan first."
- **B** → allow specify to proceed. Output: "⚠️ Proceeding without roadmap entry. Consider updating `docs/blueprint/epics.md` manually after this spec is complete."
- **C** → stop.

---

#### Case D — Ambiguous match (feature spans multiple Epics)

Output:
```
⚠️ This feature overlaps multiple Epics: [ENNN, ENNM, ...]

Spanning multiple Epics in a single spec risks scope creep and unclear ownership.

Options:
  A) Proceed — I'll scope this spec tightly to one Epic.
  B) Cancel — I'll split this feature into separate specify runs.
```

Wait for user response.
- **A** → allow specify to proceed.
- **B** → stop. Output: "Run `/speckit.specify` once per Epic to keep scopes clean."
