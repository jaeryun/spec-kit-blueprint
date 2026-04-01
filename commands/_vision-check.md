---
description: "Validate that roadmap changes align with the confirmed project vision."
---

# Blueprint Vision Check

> Auto-invoked hook — fires automatically before `/speckit.blueprint.roadmap`. Do not invoke directly.

Pre-flight validation before `/speckit.blueprint.roadmap`. Detects vision divergence before the roadmap is modified.

## Context

This command is invoked as a `before_blueprint_roadmap` hook. The roadmap change intent is available from the current conversation context — it is the argument the user passed to `/speckit.blueprint.roadmap`.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/vision.md` does not exist:
→ Output: "ℹ️ Blueprint vision not found — skipping vision alignment check." and stop (allow roadmap to proceed).

---

### Step 2: Read vision

Read `docs/blueprint/vision.md` — extract and hold in context:
- **Core Features** — must-have features the product must deliver
- **Out of Scope** — items explicitly excluded from the initial version
- **Target Users** — specific user personas and their context
- **Non-Functional Requirements** — performance, security, accessibility targets

---

### Step 3: Analyze roadmap change intent

**First-run check:** If no roadmap change intent is present in the current conversation context (the user ran `/speckit.blueprint.roadmap` with no arguments and no prior roadmap exists), output:
```
✅ First roadmap run — skipping vision alignment check.
Proceeding with roadmap generation.
```
Stop. Allow roadmap to proceed.

Using the roadmap change intent from the current conversation context, assess the proposed change against each of the four vision dimensions.

**Check A — Core Features coverage**
Are all Core Features still represented in the proposed roadmap direction? Flag any Core Feature that appears to be dropped or significantly de-scoped.

**Check B — Out of Scope creep**
Does the proposed change introduce anything that vision explicitly lists as Out of Scope? Flag any direct overlap.

**Check C — Target User alignment**
Does the proposed change serve the same Target Users defined in vision, or does it shift focus to a different user segment?

**Check D — Non-Functional Requirements**
Does the proposed change conflict with any non-functional requirement (e.g., adding a heavy dependency that breaks a performance target, or removing an accessibility-critical flow)?

---

### Step 4: Handle check result

#### Case A — All checks pass

Output:
```
✅ Vision aligned: proposed roadmap change is consistent with the project vision.
Proceeding with roadmap update.
```

Stop. Allow roadmap to proceed.

---

#### Case B — Out of Scope violation detected

Output:
```
⚠️ Vision Conflict: Out of Scope

The proposed change includes "[item]", which is explicitly out of scope in the current vision.

Options:
  A) Update vision first — run `/speckit.blueprint.vision` to revise the Out of Scope section, then re-run roadmap.
  B) Proceed anyway — this is intentional scope expansion and vision will be updated separately.
  C) Cancel.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.vision` to update the vision first."
- **B** → allow roadmap to proceed. Output: "⚠️ Proceeding with scope expansion. Remember to update `docs/blueprint/vision.md` to stay in sync."
- **C** → stop.

---

#### Case C — Core Feature dropped

Output:
```
⚠️ Vision Conflict: Core Feature at Risk

"[feature]" is listed as a Core Feature in the vision but appears to be dropped or significantly reduced in this roadmap change.

Options:
  A) Confirm removal — update vision first via `/speckit.blueprint.vision`, then re-run roadmap.
  B) Proceed anyway — this feature will be addressed in a later stage not covered by this change.
  C) Cancel.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.vision` to update Core Features first."
- **B** → allow roadmap to proceed.
- **C** → stop.

---

#### Case D — Target User drift detected

Output:
```
⚠️ Vision Conflict: Target User Drift

The proposed change appears to shift focus toward "[inferred user segment]", while the vision defines the primary user as "[vision target user]".

Is this intentional?
  A) Yes, the target user is evolving — update vision first via `/speckit.blueprint.vision`.
  B) No, this is not a user shift — proceed with roadmap.
  C) Cancel.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.vision` to update Target Users first."
- **B** → allow roadmap to proceed.
- **C** → stop.

---

#### Case E — Non-Functional Requirements conflict

Output:
```
⚠️ Vision Conflict: Non-Functional Requirement

The proposed change may conflict with the following non-functional requirement from the vision:
"[NFR statement]"

Options:
  A) Proceed anyway — NFR impact is acceptable and will be tracked separately.
  B) Cancel — I'll revise the proposed change first.
```

Wait for user response.
- **A** → allow roadmap to proceed. Output: "⚠️ Proceeding. Verify that the NFR impact is acceptable before finalizing the roadmap."
- **B** → stop. Output: "Revise the proposed change to satisfy the non-functional requirement, or update the vision first."
