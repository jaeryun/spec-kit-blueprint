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

- **Spec file reference** — argument looks like a file path (e.g., `specs/001-auth/`, `specs/001-auth/spec.md`)
  → Read the file. Extract the spec title and any feature description from its content to use as the match target in Step 3.

- **Spec Outline reference** — argument matches the SO-NN format (e.g., `SO-01`) or is a plain number (e.g., `1`)
  → Use the number to directly look up the matching Spec Outline in Step 3.

- **Feature description** — free-form text describing what to build
  → Use as-is for semantic matching in Step 3.

---

### Step 2: Check prerequisites

Run from repo root:

```bash
bash .specify/extensions/blueprint/scripts/bash/blueprint-prereqs.sh --json
```

Parse JSON output into:

- `ROADMAP_EXISTS` — boolean
- `ROADMAP_PATH` — absolute path to roadmap.md
- `SPEC_OUTLINES` — array of `{id, goal, scope, spec_linked}` objects

If `ROADMAP_EXISTS` is `false`:
→ Output: "ℹ️ Blueprint roadmap not found — skipping roadmap alignment check." and stop (allow specify to proceed).

If `SPEC_OUTLINES` is empty:
→ Output: "ℹ️ No Spec Outlines found in `docs/blueprint/roadmap.md` — skipping roadmap alignment check." and stop (allow specify to proceed).

Use `SPEC_OUTLINES` directly for matching in Step 3. Do **not** re-read roadmap.md manually.

---

### Step 3: Match to Spec Outline

Using the resolved match target from Step 1:

- **Spec Outline reference**: look up by number directly. If not found, treat as no match (Case C).
- **Spec file reference**: match the extracted spec title/description against Spec Outline summaries and scope.
- **Feature description**: match semantically against Spec Outline summaries and scope.

**Match criteria:** Always present the matched Spec Outline to the user and ask for confirmation before proceeding. Do not proceed silently even when the match appears clear.

---

### Step 4: Handle match result

#### Case A — Clear match, no existing spec linked (Spec: —)

Output:

```text
✅ Roadmap aligned: maps to SO-[NN] — [Spec Outline goal]

Scope: [Spec Outline scope field content]

Proceed with this Spec Outline? (yes / no)
```

Wait for user response.

- **yes** → Output: "Proceeding with specification." and allow specify to proceed.
- **no** → treat as Case C.

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
  Scope: [Spec Outline scope field content]

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

- **A** → Ask: "Which Spec Outline should this spec be linked to? (enter SO-ID, e.g. SO-02)" — wait for user to confirm a single SO. Once confirmed, output: "Proceeding with specification. Roadmap sync will link the spec to [SO-ID]." and allow specify to proceed. Store the confirmed SO-ID in conversation context so `roadmap-sync` can use it directly in its Step 2.
- **B** → stop. Output: "Run `/speckit.specify` once per Spec Outline to keep scopes clean."
