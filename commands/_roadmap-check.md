---
description: "Validate that the feature being specified aligns with a Spec Outline in the roadmap."
---

# Blueprint Roadmap Check

> Auto-invoked hook — fires automatically before `/speckit.specify`. Do not invoke directly.

Pre-flight validation before `/speckit.specify`. Checks the argument, resolves it to a Spec Outline, and validates roadmap alignment and dependency order.

## Context

This command is invoked as a `before_specify` hook. The argument the user passed to `/speckit.specify` is available from the current conversation context.

This hook intentionally does not fire before `/speckit.clarify` — clarify operates on an existing spec within an already-matched Spec Outline and does not require re-validation.

## Instructions

### Step 1: Check argument

Inspect the argument passed to `/speckit.specify`.

**If no argument was provided:**
→ Output:
```text
⚠️ No argument passed to /speckit.specify.

Roadmap alignment and spec file tracking require knowing what you are specifying.
Accepted forms:
  - Spec Outline number or goal: /speckit.specify "Spec Outline 001" or /speckit.specify "user authentication"
  - Spec file name: /speckit.specify auth.md

Proceed without a Spec Outline or spec file? (yes / no)
```

Wait for user response.
- **yes** → allow specify to proceed, skip Steps 2–4.
- **no** → stop. Output: "Re-run with a Spec Outline or spec file argument."

---

**If an argument was provided**, determine its type:

- **Spec file reference** — argument ends with `.md` or looks like a file path (e.g., `auth.md`, `docs/spec/auth.md`)
  → Read the file. Extract the spec title and any feature description from its content to use as the match target in Step 3.

- **Spec Outline reference** — argument contains "Spec Outline" followed by a number, or is a plain number (e.g., `001`, `1`)
  → Use the number to directly look up the matching Spec Outline in Step 3.

- **Feature description** — free-form text describing what to build
  → Use as-is for semantic matching in Step 3.

---

### Step 2: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap alignment check." and stop (allow specify to proceed).

Read `docs/blueprint/roadmap.md`. Find all Spec Outline entries (under `**Spec Outline:**` sections, identified by Spec Outline 001, 002...).

If no Spec Outlines are found:
→ Output: "ℹ️ No Spec Outlines found in `docs/blueprint/roadmap.md` — skipping roadmap alignment check." and stop (allow specify to proceed).

---

### Step 3: Match to Spec Outline

Using the resolved match target from Step 1:

- **Spec Outline reference**: look up by number directly. If not found, treat as no match (Case C).
- **Spec file reference**: match the extracted spec title/description against Spec Outline goals and objectives.
- **Feature description**: match semantically against Spec Outline goals and objectives.

**Match criteria:** Prefer false positives over false negatives — partial or ambiguous overlap counts as a match.

---

### Step 4: Handle match result

#### Case A — Clear match, Spec Outline is [📋] Planned

Check the `Deps:` field of the matched Spec Outline.

**If deps is `—` (none):** proceed directly.

**If deps lists one or more Spec Outlines:** check the status of each listed dependency in `roadmap.md`.

- If all listed dependencies are `[✅]` Complete → proceed.
- If any listed dependency is `[📋]` Planned or `[🚧]` In Progress → output:

```text
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
```text
✅ Roadmap aligned: maps to Spec Outline [NNN] — [Spec Outline goal]
Proceeding with specification.
```

Stop. Allow specify to proceed.

---

#### Case B — Clear match, Spec Outline is [🚧] In Progress or [✅] Complete

Run the same dependency check as Case A. If any dep is incomplete, output the Dependency Not Ready warning and wait for user response. If the user chooses A or C (stop), stop entirely. If the user chooses B (proceed), continue to the Case B confirmation prompt below.

If dependency check passes (or deps are `—`), output:
```text
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
```text
⚠️ Roadmap Divergence Detected

"[argument]" does not map to any Spec Outline in the current roadmap.

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

#### Case D — Ambiguous match (argument spans multiple Spec Outlines)

Output:
```text
⚠️ This argument overlaps multiple Spec Outlines: [Spec Outline NNN, Spec Outline NNM, ...]

Spanning multiple Spec Outlines in a single spec risks scope creep and unclear ownership.

Options:
  A) Proceed — I'll scope this spec tightly to one Spec Outline.
  B) Cancel — I'll split this feature into separate specify runs.
```

Wait for user response.
- **A** → allow specify to proceed.
- **B** → stop. Output: "Run `/speckit.specify` once per Spec Outline to keep scopes clean."
