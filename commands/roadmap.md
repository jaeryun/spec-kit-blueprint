---
description: "Generate a delivery roadmap of Spec Outlines from the confirmed vision."
---

# Blueprint Roadmap

Generate a delivery roadmap of Spec Outlines from the confirmed vision.

## Purpose

Using the confirmed `vision.md`, produce a single `roadmap.md` that:

- Analyzes the project vision and interviews the user to surface all work needed
- Defines Spec Outlines (Jira Epics, 2–4+ sprints each) with goals, scope, and size estimates
- Maps dependencies between Spec Outlines and produces an execution order

## What is a Spec Outline

A **Spec Outline** is the planning blueprint for one Jira Epic. It is defined at roadmap time — before detailed requirements are known — using only three components:

| Component | Description |
| --- | --- |
| **Summary** | One sentence describing what this Epic delivers, from the user's perspective |
| **Scope** | Free-form description of what this Epic encompasses — written at an abstract level based on vision analysis and user interview |
| **Deps** | Other Spec Outlines that must be completed before this one can start |

```
Spec Outline (roadmap.md) — planning time, abstract
    ├─ Summary: "Users can register and log in with email/password."
    ├─ Scope: "Sign-up flow, login/logout, password reset, session management."
    └─ Deps: —
         └─► /speckit.specify → requirements interview → spec.md
                 ├─ P1 User Story (must-have, built first)
                 ├─ P2 User Story (should-have, built second)
                 └─ P3 User Story (nice-to-have, built last / first to cut)
                         └─► /speckit.plan → /speckit.tasks → /speckit.implement
```

Key implications for generation:
- Each Spec Outline = one `/speckit.specify` run = one feature branch
- **Scope is intentionally abstract** — the exact phase breakdown (P1/P2/P3) is determined during `/speckit.specify` through a detailed requirements interview. Scope items written here may be decomposed into multiple phases, merged, or reframed during that interview.
- The **Size** estimate covers the full branch lifecycle: specify → clarify → plan → tasks → implement — not just spec writing time

## Scope Boundary

`roadmap.md` answers **what Spec Outlines exist, in what order, and what each covers** — nothing more.

**Belongs here:** Spec Outline summaries, abstract scope descriptions, size estimates, dependencies between Spec Outlines, execution order.

**Does NOT belong here:** implementation details, code snippets, task-level breakdowns, test cases, phase-level breakdowns (P1/P2/P3 belong in `spec.md`), sprint-by-sprint assignments, team member allocation. If any of these appear in a draft, they belong in a spec — remove them.

## User Input

$ARGUMENTS

If `$ARGUMENTS` names a specific Spec Outline (e.g., "Spec Outline 002"), re-run only that Spec Outline and leave all others unchanged. If `$ARGUMENTS` contains a general focus hint (e.g., "focus on the backend Spec Outlines"), apply it during generation.

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_roadmap` and execute them in order.

After saving `docs/blueprint/roadmap.md`, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_roadmap` and execute them in order.

## Instructions

### Step 0: Prerequisites Check

Check that `docs/blueprint/vision.md` exists.

If missing, stop and output: "Run `/speckit.blueprint.vision` first."

---

### Step 1: Check Existing Roadmap

Check if `docs/blueprint/roadmap.md` exists.

**If it exists:**

1. Read the file and output a brief summary: number of Spec Outlines, their IDs and statuses (📋 / 🚧 / ✅).
2. Ask: "Your existing roadmap is summarized above. What would you like to do?
   - (1) Update specific Spec Outlines
   - (2) Regenerate from scratch
   - (3) Reset a Spec Outline status
   - (4) Cancel"
3. If the user chooses (1): identify which Spec Outlines to update from `$ARGUMENTS` or from their reply. Spec Outlines marked ✅ Complete or 🚧 In Progress are **immutable** — do not re-analyze or overwrite them. For each skipped immutable Spec Outline, output: "Skipping Spec Outline [NNN] — status is [🚧 In Progress / ✅ Complete]. Use option (3) to reset it first." Proceed to Step 2 for only the targeted Spec Outlines.
4. If the user chooses (2): proceed to Step 2 for all Spec Outlines.
5. If the user chooses (3): ask "Which Spec Outline would you like to reset? (provide number or goal)" — find the matching Spec Outline, then ask:

   ```text
   Reset Spec Outline [NNN] — [goal]?

   Current status: [✅ Complete / 🚧 In Progress]
   Reset to: 📋 Planned

   This will allow it to be re-specified. Confirm? (yes / no)
   ```

   - **yes** → change the Spec Outline marker back to `[📋]`, clear the `Spec:` field back to `—`, append a `[TIMESTAMP] | Spec Outline [NNN] | ✅/🚧 → 📋 (reset)` row to the History table, save `docs/blueprint/roadmap.md`, and output: "✅ Spec Outline [NNN] reset to 📋 Planned. Note: the previously linked spec file (if any) is no longer referenced — archive or delete it manually if no longer needed."
   - **no** → return to the options menu.
6. If the user chooses (4): stop.

**If it does not exist:** proceed to Step 2.

---

### Step 2: Phase 1 — Spec Outline Definition

Output: `[Phase 1 of 2] Spec Outline Definition`

**Vision alignment check:** Before proceeding, assess whether the current roadmap change intent conflicts with `docs/blueprint/vision.md` across these four dimensions:

- **Core Features** — does the proposed change drop or significantly reduce a Core Feature?
- **Out of Scope** — does the proposed change introduce something vision explicitly marks as Out of Scope?
- **Target Users** — does the proposed change shift focus to a different user segment?
- **Non-Functional Requirements** — does the proposed change contradict a stated NFR?

If a conflict is found, present it specifically and ask the user to confirm before continuing:

```text
⚠️ Vision Conflict: [dimension]
"[specific conflict description]"

Proceed anyway? (yes / no)
```

- **yes** → continue.
- **no** → stop. Output: "Update `docs/blueprint/vision.md` first to reflect the intended change."

If no conflicts found, continue silently.

Read `docs/blueprint/vision.md`. Pay special attention to:

- Sprint cadence and team size (Execution Context section)
- Core features and out-of-scope items

**2-1. User Interview**

Before drafting anything, ask the user targeted questions one at a time to surface work not captured in vision.md. Wait for the answer to each question before asking the next.

Ask in this order:

1. "Are there any existing systems or services this project needs to integrate with? (e.g., legacy APIs, third-party services, internal tools)"
2. "Are there infrastructure or platform concerns to account for? (e.g., CI/CD setup, cloud provider, deployment targets)"
3. "Are there any non-functional requirements not covered in the vision? (e.g., performance targets, compliance, accessibility, i18n)"
4. "Is there any work that must happen before the first user-facing feature can ship? (e.g., repo setup, auth foundation, database schema)"
5. "Any known constraints, risks, or external dependencies I should factor in?"

After all five answers are collected, proceed to 2-2.

**2-2. Draft Spec Outlines**

Using vision.md + interview answers, draft the Spec Outlines. For each, determine:

- **Summary**: one sentence describing what this Epic delivers, from the user's perspective
- **Scope**: free-form description of what this Epic encompasses — write at an abstract level. This becomes the raw input for `/speckit.specify`, where the exact phase breakdown (P1/P2/P3) is determined through a requirements interview. Scope items may be decomposed, merged, or reframed at that point.
- **Size**: estimated sprint count — apply the Sizing Guide (For AI Generation section) including split/merge rules

Principles:

- Each Spec Outline delivers a cohesive, user-observable capability
- Earlier Spec Outlines cover foundational/blocking work; later ones add depth and polish
- Do not prescribe phases here — keep scope abstract
- After estimating size, explicitly apply the split/merge rules from the Sizing Guide:
  - If adjusted size > 4 sprints → split into two Spec Outlines
  - If adjusted size < 2 sprints AND doesn't block others → merge with adjacent

**2-3. User Confirmation**

Present the Spec Outline list to the user and ask: "Do the Spec Outlines make sense? Are the scopes and sizes realistic for your team?"

Incorporate feedback. Repeat until the user confirms.

---

### Step 3: Phase 2 — Dependency Mapping

Output: `[Phase 2 of 2] Dependency Mapping`

For each Spec Outline, identify which prior Spec Outlines it depends on (write `—` if none).

From the dependency graph, produce two outputs:

- **Sequence** — the linear chain of Spec Outlines that must be completed in strict order (the critical path)
- **Parallel Groups** — sets of Spec Outlines that can run concurrently, labeled Group A, B, C, …, and the condition under which each group can start

Present the execution order to the user and ask: "Does this dependency and parallelism plan look correct?"

Incorporate feedback, then proceed to write the output file.

---

### Step 4: Write Output File

Load `templates/roadmap-template.md` to understand the required sections.

Fill each Spec Outline with the confirmed output from Steps 2 and 3, following the **For AI Generation** guidelines at the end of this file.

Include a `_Last updated: [date]_` line with today's date.

If `docs/blueprint/roadmap.md` does not yet exist, the History section in the template will carry a `Created` entry. If it already exists (regenerate or update), preserve all existing History rows and append a new row: `[TIMESTAMP] | roadmap.md | Updated` (for full regeneration) or `[TIMESTAMP] | Spec Outline [NNN] | Updated` (for targeted update).

Save to `docs/blueprint/roadmap.md`.

---

### Step 5: Scope Check

After saving, review `docs/blueprint/roadmap.md` against the Scope Boundary defined above.

Flag each violation before confirming completion:

| Violation | Guidance |
| --- | --- |
| Scope written as a task list or step-by-step breakdown | Rewrite as abstract capability description — what the Epic covers, not how it will be built |
| Implementation detail in scope | Move to spec |
| Spec Outline sized under ~2 sprints | Consider merging with an adjacent Spec Outline |

For each violation found, output:

```text
[!] Scope issue in roadmap.md: "[excerpt]"
This level of detail belongs in [spec / project management]. Remove it from roadmap.md.
```

Ask the user: "Found [N] scope issue(s) above. Fix before proceeding? (yes / no / skip)"

- **yes** — apply fixes, re-save, and re-confirm the file
- **no / skip** — proceed as-is and note issues remain

If no violations are found, output: "Scope check passed."

---

### Step 6: Vision Sync

Read `docs/blueprint/vision.md`. Compare the finalized `roadmap.md` against the four vision dimensions:

- **Out of Scope violations** — do any Spec Outline summaries or scope descriptions introduce something vision marks as Out of Scope?
- **Core Feature drift** — are any Core Features absent or contradicted by the roadmap?
- **Target User drift** — does any scope description serve a user segment not defined in vision?
- **Non-Functional Requirements** — does any scope description conflict with a stated NFR?

If drift is detected, produce specific proposed changes to `vision.md`:

```text
⚠️ Vision Sync: Scope changes detected

[For each issue:]
Section: [Core Features / Out of Scope / Target Users / NFR]
Action:  [Add / Remove / Modify]
Item:    "[item text]"
Reason:  "[one-line explanation based on roadmap evidence]"
```

Ask: "Found [N] vision sync issue(s) above. Apply these updates to vision.md now? (yes / no)"

- **yes** → apply all proposed changes to `docs/blueprint/vision.md`, append a `Synced with roadmap.md` row to vision.md's History, save, and output: "✅ vision.md updated to reflect roadmap scope changes."
- **no** → output: "ℹ️ vision.md not updated. Re-run `/speckit.blueprint.vision` when ready to re-align."

If no drift found → output: "✅ Vision consistent with roadmap."

---

### Step 7: Completion

Confirm the file is saved:

- `docs/blueprint/roadmap.md` ✓

Output:

```text
Roadmap complete. [N] Spec Outlines defined.

Next: /speckit.specify [Spec Outline 001 goal]
After each Spec is complete, run the next Spec Outline in dependency order.
```

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/roadmap.md` | Delivery plan with Spec Outlines and dependencies |

---

## For AI Generation

When filling `templates/roadmap-template.md`:

### Spec Outline Field Rules

**Summary** — User-facing, one sentence. Bad: "Implement authentication". Good: "Users can register and log in with email/password."

**Scope** — Free-form prose describing what this Epic encompasses, at an abstract level. Write what the feature covers, not how it will be built or how many phases it will have. This is the raw input for `/speckit.specify` — phase breakdown happens there, not here.

**Size** — Use the Sizing Guide below. Round to the nearest sprint: `~2`, `~3`, `~4`. Do not write ranges.

**Deps** — List Spec Outline IDs (e.g., `Spec Outline 001`). Write `—` if no dependencies.

**Spec** — Write `—` until the spec file exists. Updated automatically by `_roadmap-sync` after `/speckit.specify`.

### Sizing Guide

Size represents the estimated total duration of one Spec Outline from `/speckit.specify` through `/speckit.implement` — the full Epic lifecycle, not just spec writing time.

**Step 1 — Baseline from scope complexity**

| Scope breadth | Baseline |
| --- | --- |
| Narrow: single, well-defined capability | ~2 sprints |
| Moderate: 2–3 related capabilities | ~3 sprints |
| Broad: cross-cutting or multi-capability | ~4 sprints |

**Step 2 — Adjust for context factors**

Read the `Execution Context` section of `vision.md` before adjusting:

| Factor | Adjustment |
| --- | --- |
| Solo developer | ×1.5 the baseline |
| First Spec Outline in the project | +1 sprint (environment setup, conventions, CI/CD) |
| Foundational / infrastructure work (auth, DB schema, core APIs) | +1 sprint (high uncertainty, blocks everything else) |
| External API or third-party integration | +0.5–1 sprint per external dependency |
| Unfamiliar domain or tech stack for the team | +1 sprint |
| UI/frontend-heavy work | base (UI polish tends to expand — watch P3) |
| Well-understood CRUD / business logic | base |

**Step 3 — Split or merge**

Split into two Spec Outlines if:

- Adjusted estimate exceeds 4 sprints
- Scope spans unrelated domains (e.g., payment processing + user profiles)
- Part of the scope clearly blocks the rest and is large enough to stand alone (~2 sprints)

Keep foundational work as its own Spec Outline even if small — auth, DB schema, and core infrastructure block all downstream Spec Outlines and must not be merged with feature work.

Merge with an adjacent Spec Outline if:

- Adjusted estimate is under 2 sprints AND the work does not block any other Spec Outline

### Status Markers

| Marker | Meaning | When to set |
| --- | --- | --- |
| `[📋]` | Planned | Default — not yet specified |
| `[🚧]` | In Progress | Set by `_roadmap-check` when specify starts; also set by `_roadmap-sync` for partial coverage |
| `[✅]` | Complete | After `_roadmap-sync` confirms completion |

Never change markers manually unless the user explicitly asks to reset a status.

### Execution Order Rules

**Sequence** — Critical path only. Spec Outlines that can run in parallel do not belong here.

**Parallel Groups** — Include only if two or more Spec Outlines can genuinely run concurrently. Remove the table entirely if everything is sequential. "Can start after" must name a specific Spec Outline ID.

### Scope Signals — Remove Before Saving

| Found in draft | Where it belongs instead |
| --- | --- |
| Code snippets or technical implementation details | `spec.md` |
| Scope written as a task list or phase breakdown | Rewrite as abstract capability description |
| Task-level breakdowns or test cases | `spec.md` |
| Sprint-by-sprint assignments or team member allocation | Project management tool |
