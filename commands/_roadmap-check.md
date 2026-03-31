---
description: "Validate roadmap-to-epics coherence and protect immutable epics before decomposition."
---

# Blueprint Roadmap Check

Pre-flight validation before `/speckit.blueprint.decompose`. Detects roadmap drift and protects in-progress or complete epics from accidental re-decomposition.

## Context

This command is invoked as a `before_blueprint_decompose` hook. The target stage (if any) is available from the current conversation context — it is the argument the user passed to `/speckit.blueprint.decompose`.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap check." and stop (allow decompose to proceed).

If `docs/blueprint/vision.md` does not exist:
→ Output: "ℹ️ Blueprint vision not found — skipping vision alignment check." Continue to Step 2 (skip Check A).

---

### Step 2: Determine target stages

Read `docs/blueprint/roadmap.md`.

If a specific stage was provided in the current conversation context (e.g., "Stage 2"):
- Verify it exists in the roadmap.
- If it does **not** exist → Output: "❌ Stage '[name]' not found in `docs/blueprint/roadmap.md`. Check the stage name and try again." and stop.
- If it exists → set target to that stage only.

If no stage argument was provided → set target to all stages in the roadmap.

---

### Step 3: Check immutable epics

If `docs/blueprint/epics.md` exists, read it.

For each target stage, check if any existing Epics are marked 🚧 In Progress or ✅ Complete.

#### Case A — No immutable epics in target stages

Continue to Step 4.

#### Case B — Immutable epics found in target stages

Output:
```
⚠️ Immutable Epics Detected

The following Epics in the target stage(s) are already in progress or complete and cannot be re-decomposed:

[List each: E[NNN] — [goal] — [🚧 In Progress / ✅ Complete]]

Re-running decompose on these stages will only process 📋 Planned epics and add new ones.
Immutable epics will not be modified.

Proceed? (yes / no)
```

Wait for user response.
- **yes** → continue to Step 4.
- **no** → stop.

---

### Step 4: Vision alignment check (skip if vision.md not found)

Read `docs/blueprint/vision.md` — extract:
- **Core Features** — must-have features the product must deliver
- **Out of Scope** — items explicitly excluded

For each target stage in the roadmap, assess:

**Check A — Core Feature coverage**
Do the target stages collectively cover the Core Features listed in vision? Flag any Core Feature with no corresponding stage or deliverable.

**Check B — Out of Scope creep**
Do any target stage deliverables overlap with items explicitly listed as Out of Scope in vision?

#### Case A — All checks pass

Output:
```
✅ Roadmap aligned: target stages are consistent with the project vision.
Proceeding with decomposition.
```

Stop. Allow decompose to proceed.

---

#### Case B — Core Feature gap detected

Output:
```
⚠️ Vision Gap: Uncovered Core Feature

The following Core Feature from the vision has no corresponding stage or deliverable in the roadmap:
"[feature]"

This may result in Epics that don't deliver the full product vision.

Options:
  A) Update roadmap first — run `/speckit.blueprint.roadmap` to add coverage, then re-run decompose.
  B) Proceed anyway — this feature will be handled outside the current roadmap scope.
  C) Cancel.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.roadmap` to update the roadmap first."
- **B** → allow decompose to proceed. Output: "⚠️ Proceeding. Note that the Epic breakdown will not fully cover all vision Core Features."
- **C** → stop.

---

#### Case C — Out of Scope creep in roadmap

Output:
```
⚠️ Vision Conflict: Out of Scope Item in Roadmap

Stage "[stage name]" includes "[deliverable]", which is explicitly out of scope in the current vision.

Decomposing this stage will generate Epics for out-of-scope work.

Options:
  A) Update vision first — run `/speckit.blueprint.vision` to revise Out of Scope, then re-run decompose.
  B) Skip this stage — decompose other stages only.
  C) Proceed anyway — the scope expansion is intentional.
  D) Cancel.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.vision` to update the vision first."
- **B** → remove the conflicting stage from the target list and continue with remaining stages. If no stages remain after removal, output: "No stages remain after skipping conflicting ones — cancelling decompose." and stop.
- **C** → allow decompose to proceed. Output: "⚠️ Proceeding with scope expansion. Remember to update `docs/blueprint/vision.md` to stay in sync."
- **D** → stop.
