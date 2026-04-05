---
description: "Validate that the feature being specified aligns with a Spec Outline in the roadmap."
---

# Blueprint Roadmap Check

> Auto-invoked hook — fires automatically before `/speckit.specify`. Do not invoke directly.

Pre-flight validation before `/speckit.specify`. Checks the argument, resolves it to a Spec Outline, and validates roadmap alignment.

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
  - Spec Outline number or goal: /speckit.specify "SO-01" or /speckit.specify "user authentication"
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

- **Spec Outline reference** — argument matches the SO-NN format (e.g., `SO-01`) or is a plain number (e.g., `1`)
  → Use the number to directly look up the matching Spec Outline in Step 3.

- **Feature description** — free-form text describing what to build
  → Use as-is for semantic matching in Step 3.

---

### Step 2: Check prerequisites

If `docs/blueprint/roadmap.md` does not exist:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap alignment check." and stop (allow specify to proceed).

Read `docs/blueprint/roadmap.md`. Find all Spec Outline entries.

If no Spec Outlines are found:
→ Output: "ℹ️ No Spec Outlines found in `docs/blueprint/roadmap.md` — skipping roadmap alignment check." and stop (allow specify to proceed).

---

### Step 3: Match to Spec Outline

Using the resolved match target from Step 1:

- **Spec Outline reference**: look up by number directly. If not found, treat as no match (Case C).
- **Spec file reference**: match the extracted spec title/description against Spec Outline summaries and scope.
- **Feature description**: match semantically against Spec Outline summaries and scope.

**Match criteria:** When confidence is low or the match is ambiguous, ask the user to confirm before proceeding.

---

### Step 4: Handle match result

#### Case A — Clear match, no existing spec linked (Spec: —)

Output:

```text
✅ Roadmap aligned: maps to SO-[NN] — [Spec Outline goal]

Spec Outline scope (use as context for the requirements interview):
[Spec Outline scope field content]

Proceeding with specification.
```

Stop. Allow specify to proceed.

---

#### Case B — Clear match, spec already linked

Output:

```text
⚠️ SO-[NN] already has a linked spec: [existing spec file path]

Options:
  A) Proceed with specify — extend or rewrite the spec for this Spec Outline
  B) Use /speckit.clarify instead — for targeted changes to the existing spec
  C) Add a new Spec Outline first — run /speckit.blueprint.roadmap if this is new scope
  D) Cancel
```

Wait for user response.

- **A** → Output:
  ```text
  Spec Outline scope (use as context for the requirements interview):
  [Spec Outline scope field content]

  Proceeding with specification.
  ```
  Allow specify to proceed.
- **B** → stop. Output: "Re-run as `/speckit.clarify` to make targeted changes to the existing spec."
- **C** → stop. Output: "Run `/speckit.blueprint.roadmap` to add a new Spec Outline, then specify it."
- **D** → stop.

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
- **B** → allow specify to proceed. Output: "⚠️ Proceeding without a Spec Outline entry. Roadmap will not be updated automatically for this run."
- **C** → stop.

---

#### Case D — Ambiguous match (argument spans multiple Spec Outlines)

Output:

```text
⚠️ This argument overlaps multiple Spec Outlines: [SO-NN, SO-NM, ...]

Spanning multiple Spec Outlines in a single spec risks scope creep and unclear ownership.

Options:
  A) Proceed — I'll scope this spec tightly to one Spec Outline.
  B) Cancel — I'll split this feature into separate specify runs.
```

Wait for user response.

- **A** → allow specify to proceed.
- **B** → stop. Output: "Run `/speckit.specify` once per Spec Outline to keep scopes clean."
