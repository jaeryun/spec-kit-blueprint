---
description: "Sync vision.md if roadmap planning revealed scope changes."
---

# Blueprint Vision Sync

> Auto-invoked hook — fires automatically after `/speckit.blueprint.roadmap`. Do not invoke directly.

Post-completion sync after `/speckit.blueprint.roadmap`. Checks whether roadmap planning introduced stage goals or Spec Outline stories that contradict or extend what `vision.md` defines as Out of Scope or Core Features.

## Context

This command is invoked as an `after_blueprint_roadmap` hook. The completed roadmap is available at `docs/blueprint/roadmap.md`. The hook runs after `roadmap.md` has been confirmed and saved.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/vision.md` does not exist:
→ Output: "ℹ️ Blueprint vision not found — skipping vision sync." and stop.

---

### Step 2: Read roadmap and vision

Read `docs/blueprint/roadmap.md` — extract and hold in context:
- All stage goals
- All Spec Outline goals and their listed stories

Read `docs/blueprint/vision.md` — extract and hold in context:
- **Core Features** — must-have features the product must deliver
- **Out of Scope** — items explicitly excluded from the initial version
- **Target Users** — specific user personas and their context
- **Non-Functional Requirements** — performance, security, accessibility targets

---

### Step 3: Detect drift

Compare the roadmap content against the four vision dimensions.

**Check A — Out of Scope violations**
Do any stage goals or Spec Outline stories introduce something that `vision.md` explicitly lists as Out of Scope? Flag each direct overlap with a brief description of where in the roadmap it appears.

**Check B — Core Feature drift**
Do any Core Features from `vision.md` appear to be absent, significantly reduced, or contradicted by the roadmap's stage structure and Spec Outline stories? Flag each missing or contradicted Core Feature.

**Check C — Target User drift**
Do any stage goals or Spec Outline stories shift focus toward a user segment not defined in `vision.md`? Flag any stage or story that appears to serve a different user persona than those listed in the vision.

**Check D — Non-Functional Requirements**
Do any stage goals or Spec Outline stories conflict with the non-functional requirements in `vision.md`? Flag any story that introduces a dependency or design decision that contradicts a stated performance, security, or accessibility target.

---

### Step 4: Handle check result

#### Case A — No drift detected

Output:
```
✅ Vision consistent with roadmap.
```

Stop.

---

#### Case B — Drift detected

Output a summary of what changed, in this format:

```
⚠️ Vision Sync: Potential Scope Changes Detected

The following items from the roadmap may reflect scope changes that are not yet reflected in vision.md:

[list each item with a brief description, e.g.:
- Spec Outline 003 includes "[story]", which overlaps with the Out of Scope item "[vision item]".
- Core Feature "[feature]" from vision.md is not represented in any Spec Outline or stage goal.]

The following may reflect scope changes from roadmap planning: [list]. Update vision.md to stay in sync? (yes / no / review)
```

Wait for user response.

- **yes** → apply targeted updates to `vision.md`:
  - Move items from Out of Scope to Core Features (or add new Core Features) where the roadmap has introduced them as real deliverables.
  - Remove or qualify Core Features that have been dropped or explicitly deferred in the roadmap.
  - Preserve all other content in `vision.md` unchanged.
  - Save the updated `docs/blueprint/vision.md`.
  - Output:
    ```
    ✅ vision.md updated to reflect roadmap scope changes.
    ```

- **review** → show a diff-style summary of each proposed change before saving:
  ```
  Proposed changes to vision.md:

  [For each change:]
  Section: [Core Features / Out of Scope]
  Action: [Add / Remove / Modify]
  Item: "[item text]"
  Reason: "[one-line explanation based on the roadmap evidence]"
  ```
  Ask: "Apply these changes? (yes / no)"
  - **yes** → apply the changes, save `docs/blueprint/vision.md`, and output:
    ```
    ✅ vision.md updated with confirmed changes.
    ```
  - **no** → stop. Output: "ℹ️ No changes applied. vision.md may be out of sync with the current roadmap."

- **no** → stop. Output:
  ```
  ℹ️ vision.md not updated. Note that vision.md may be out of sync with the current roadmap.
  ```
