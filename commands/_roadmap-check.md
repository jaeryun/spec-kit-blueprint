---
description: "Validate that the feature being specified aligns with a Spec Outline in the roadmap."
---

# Blueprint Roadmap Check

> Auto-invoked hook — fires automatically before `/speckit.specify`. Do not invoke directly.

Pre-flight validation before `/speckit.specify`. Detects Spec Outline divergence before a spec branch is created.

## Context

This command is invoked as a `before_specify` hook. The feature description is available from the current conversation context — it is the argument the user passed to `/speckit.specify`.

## Instructions

### Step 1: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap alignment check." and stop (allow specify to proceed).

---

### Step 2: Read Spec Outlines from roadmap

Read `docs/blueprint/roadmap.md`.

Find all Spec Outline entries. Spec Outlines appear under `**Spec Outline:**` sections within each Stage, identified by their number (Spec Outline 001, Spec Outline 002...). Each Spec Outline has a user-facing goal and a list of stories.

If no Spec Outlines are found in `roadmap.md`:
→ Output: "ℹ️ No Spec Outlines found in `docs/blueprint/roadmap.md` — skipping roadmap alignment check." and stop (allow specify to proceed).

---

### Step 3: Match feature to Spec Outline

Using the feature description from the current conversation context, determine which Spec Outline(s) in `roadmap.md` this feature falls under.

**Match criteria:** The feature clearly falls within a Spec Outline's user-facing goal and its listed stories. Partial or ambiguous overlap counts as a match — prefer false positives over false negatives.

---

### Step 4: Handle match result

#### Case A — Clear match, Spec Outline is [📋] Planned

Check the `Deps:` field of the matched Spec Outline.

**If deps is `—` (none):** proceed directly.

**If deps lists one or more Spec Outlines:** check the status of each listed dependency in `roadmap.md`.

- If all listed dependencies are `[✅]` Complete → proceed.
- If any listed dependency is `[📋]` Planned or `[🚧]` In Progress → output:

```
⚠️ Dependency Not Ready

Spec Outline [NNN] depends on [Spec Outline MMM — goal], which is not yet complete ([📋 Planned / 🚧 In Progress]).

Proceeding out of order risks building on an incomplete foundation.

Options:
  A) Complete Spec Outline [MMM] first — run `/speckit.specify [MMM goal]` first.
  B) Proceed anyway — I understand the dependency risk.
  C) Cancel.
```

Wait for user response.
- **A** → stop.
- **B** → allow specify to proceed. Output: "⚠️ Proceeding out of dependency order. Ensure Spec Outline [MMM] is completed before integrating."
- **C** → stop.

If all dependency checks pass, output:
```
✅ Roadmap aligned: maps to Spec Outline [NNN] — [Spec Outline goal]
Proceeding with specification.
```

Stop. Allow specify to proceed.

---

#### Case B — Clear match, Spec Outline is [🚧] In Progress or [✅] Complete

Run the same dependency check as Case A: verify all deps of this Spec Outline are `[✅]` Complete. If any dep is incomplete, output the Dependency Not Ready warning (same as Case A) and wait for user response before proceeding.

If dependency check passes (or deps are `—`), output:
```
⚠️ Spec Outline [NNN] is already [in progress / complete].

Confirm this is an extension or fix within that Spec Outline's scope, not a duplicate or scope creep.

Proceed? (yes / no)
```

Wait for user response.
- **yes** → allow specify to proceed.
- **no** → stop. Suggest: "Consider running `/speckit.blueprint.roadmap` to add a new Spec Outline first."

---

#### Case C — No matching Spec Outline found

Output:
```
⚠️ Roadmap Divergence Detected

"[feature description]" does not map to any Spec Outline in the current roadmap.

Options:
  A) Update roadmap first — run `/speckit.blueprint.roadmap` to add this as a new Spec Outline, then re-run specify.
  B) Proceed anyway — this is a minor addition not worth a separate Spec Outline.
  C) Cancel.
```

Wait for user response.
- **A** → stop. Output: "Run `/speckit.blueprint.roadmap` to update the Spec Outline plan first."
- **B** → allow specify to proceed. Output: "⚠️ Proceeding without a Spec Outline entry. Consider updating `docs/blueprint/roadmap.md` manually after this spec is complete."
- **C** → stop.

---

#### Case D — Ambiguous match (feature spans multiple Spec Outlines)

Output:
```
⚠️ This feature overlaps multiple Spec Outlines: [Spec Outline NNN, Spec Outline NNM, ...]

Spanning multiple Spec Outlines in a single spec risks scope creep and unclear ownership.

Options:
  A) Proceed — I'll scope this spec tightly to one Spec Outline.
  B) Cancel — I'll split this feature into separate specify runs.
```

Wait for user response.
- **A** → allow specify to proceed.
- **B** → stop. Output: "Run `/speckit.specify` once per Spec Outline to keep scopes clean."
