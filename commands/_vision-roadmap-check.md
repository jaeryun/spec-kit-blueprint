---
description: "Notify user if roadmap.md may need updating after vision changes."
---

# Blueprint Vision–Roadmap Check

> Auto-invoked hook — fires automatically after `/speckit.blueprint.vision`. Do not invoke directly.

Post-vision check. If a roadmap already exists, alerts the user that it may be out of sync with the updated vision.

## Context

This command is invoked as an `after_blueprint_vision` hook. It fires after `vision.md` has been confirmed and saved.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ No roadmap found — nothing to sync." and stop.

---

### Step 2: Check for vision changes

Compare the update date of `docs/blueprint/vision.md` against the `_Last updated:` line in `docs/blueprint/roadmap.md`.

If vision.md was updated after the roadmap's last update date, the roadmap may be out of sync.

---

### Step 3: Notify

Output:
```
⚠️ Vision Updated — Roadmap May Be Out of Sync

vision.md has been updated, but roadmap.md was last generated on [roadmap date].

Changes to vision (goals, scope, users, constraints) may affect your stage breakdown and Spec Outlines.

Options:
  A) Update roadmap now — run `/speckit.blueprint.roadmap` to review and revise.
  B) Skip — the vision change is minor and does not affect the roadmap.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.roadmap` to update the roadmap."
- **B** → stop. Output: "ℹ️ Roadmap not updated. If scope has shifted, re-run `/speckit.blueprint.roadmap` before the next specify."
