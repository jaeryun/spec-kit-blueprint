---
description: "Generate a staged delivery roadmap with Spec Outlines from the confirmed vision."
---

# Blueprint Roadmap

Generate a staged delivery roadmap with one Spec Outline per stage from the confirmed vision.

## Purpose

Using the confirmed `vision.md`, produce a single `roadmap.md` that:
- Breaks the project into deliverable stages
- Attaches exactly one Spec Outline to each stage (sized to a Jira Epic, 2–4+ sprints)
- Maps dependencies between Spec Outlines and produces an execution order

This command replaces both the old `roadmap` and `decompose` commands. The output file contains stage definitions and Spec Outlines in one document.

## Scope Boundary

`roadmap.md` answers **what stages exist, in what order, and what each Spec Outline covers** — nothing more.

**Belongs here:** stage names and goals, acceptance criteria per stage, one Spec Outline per stage (user-facing goal, 1–3 objectives, size estimate), dependencies between Spec Outlines, execution order.

**Does NOT belong here:** implementation details, code snippets, task-level breakdowns, test cases, more than 3 objectives per Spec Outline, sprint-by-sprint assignments, team member allocation. If any of these appear in a draft, they belong in a spec — remove them.

## Stage : Spec Outline Ratio

Each stage has **exactly one** Spec Outline. If a stage is too large to fit into a single Epic (2–4+ sprints), split it into two stages rather than adding a second Spec Outline.

Spec Outline objectives map directly to the P1/P2/P3 priority sections that `/speckit.specify` will generate inside `spec.md`. Keep objectives user-facing and outcome-oriented.

## User Input

$ARGUMENTS

If `$ARGUMENTS` names a specific stage (e.g., "Stage 2"), re-run only that stage and leave all others unchanged. If `$ARGUMENTS` contains a general focus hint (e.g., "focus on the backend stages"), apply it during generation.

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
1. Read the file and output a brief summary: number of stages, Spec Outline IDs, and any stages marked Complete (✅) or In Progress (🚧).
2. Ask: "Your existing roadmap is summarized above. What would you like to do?
   - (1) Update specific stages
   - (2) Regenerate from scratch
   - (3) Reset a Spec Outline status
   - (4) Cancel"
3. If the user chooses (1): identify which stages to update from `$ARGUMENTS` or from their reply. Stages whose Spec Outline is marked ✅ Complete or 🚧 In Progress are **immutable** — do not re-analyze or overwrite them. Proceed to Step 2 for only the targeted stages.
4. If the user chooses (2): proceed to Step 2 for all stages.
5. If the user chooses (3): ask "Which Spec Outline would you like to reset? (provide number or goal)" — find the matching Spec Outline, then ask:
   ```
   Reset Spec Outline [NNN] — [goal]?

   Current status: [✅ Complete / 🚧 In Progress]
   Reset to: 📋 Planned

   This will allow it to be re-specified. Confirm? (yes / no)
   ```
   - **yes** → change the Spec Outline marker back to `[📋]`, remove or reset any `**Status:**` line on the Stage if it was set to Complete, save `docs/blueprint/roadmap.md`, and output: "✅ Spec Outline [NNN] reset to 📋 Planned."
   - **no** → return to the options menu.
6. If the user chooses (4): stop.

**If it does not exist:** proceed to Step 2.

---

### Step 2: Phase 1 — Stage Boundary Definition

Output: `[Phase 1 of 3] Stage Boundary Definition`

**Vision alignment check:** Before proceeding, assess whether the current roadmap change intent (what the user wants to update or generate) conflicts with `docs/blueprint/vision.md` across these four dimensions:

- **Core Features** — does the proposed change drop or significantly reduce a Core Feature?
- **Out of Scope** — does the proposed change introduce something vision explicitly marks as Out of Scope?
- **Target Users** — does the proposed change shift focus to a different user segment?
- **Non-Functional Requirements** — does the proposed change contradict a stated NFR?

If a conflict is found, present it specifically and ask the user to confirm before continuing:
```
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

Define stages. For each stage, determine:
- **Name**: short, delivery-oriented label
- **Goal**: one sentence describing what this stage delivers
- **Acceptance Criteria**: 2–4 verifiable, binary criteria (checkbox format)

Principles:
- Each stage delivers a demonstrable, locally-runnable increment
- Stage size should produce a Spec Outline of 2–4+ sprints
- Earlier stages cover foundational/blocking work; later stages add depth and polish
- If a stage feels too large for one Epic, split it into two stages now

Present the stage list to the user and ask: "Do the stage boundaries make sense? Are the sizes realistic for your team?"

Incorporate feedback. Repeat until the user confirms the stage list.

---

### Step 3: Phase 2 — Spec Outline Sizing

Output: `[Phase 2 of 3] Spec Outline Sizing`

For each confirmed stage, define its Spec Outline:
- **Spec Outline ID**: sequential, zero-padded (Spec Outline 001, Spec Outline 002, …)
- **User-facing goal**: one sentence from the user's perspective
- **Objectives**: 1–3 objectives that will become P1/P2/P3 sections in `spec.md` — phrase as outcomes, not tasks
- **Size**: estimated sprint count (~N sprints)

One Spec Outline per stage, no exceptions. If objectives exceed 3 or the size estimate exceeds what fits one Epic, split the stage instead.

Present the Spec Outlines to the user and ask: "Do the Spec Outlines correctly capture what each stage delivers? Are the objective counts and sizes realistic?"

Incorporate feedback. Repeat until the user confirms.

---

### Step 4: Phase 3 — Dependency Mapping

Output: `[Phase 3 of 3] Dependency Mapping`

For each Spec Outline, identify which prior Spec Outlines it depends on (write `—` if none).

From the dependency graph, derive:
- **Sequence**: the linear chain of Spec Outlines that must be completed in strict order (the critical path)
- **Parallel Groups**: sets of Spec Outlines that can run concurrently, labeled Group A, B, C, …, and the condition under which each group can start

Present the execution order to the user and ask: "Does this dependency and parallelism plan look correct?"

Incorporate feedback, then proceed to write the output file.

---

### Step 5: Write Output File

Load `templates/roadmap-template.md` to understand the required sections.

Fill each Stage and Spec Outline with the confirmed output from Phases 1–3, following the **For AI Generation** guidelines below.

Include a `_Last updated:_` line with today's date.

Save to `docs/blueprint/roadmap.md`.

---

### Step 6: Scope Check

After saving, review `docs/blueprint/roadmap.md` against the Scope Boundary defined above.

Flag each violation before confirming completion:

| Violation | Guidance |
| --- | --- |
| Multiple Spec Outlines per Stage | Merge into one Spec Outline or split the Stage |
| More than 3 objectives in a Spec Outline | Trim to 3 or split the Stage |
| Implementation detail in an objective | Move to spec |
| Spec Outline sized under ~1 sprint | Consider merging with an adjacent stage |
| Stage Deliverables section present (old format) | Remove — the Spec Outline covers this |

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

### Step 7: Vision Sync

Read `docs/blueprint/vision.md`. Compare the finalized `roadmap.md` against the four vision dimensions:

- **Out of Scope violations** — do any stage goals or Spec Outline objectives introduce something vision marks as Out of Scope?
- **Core Feature drift** — are any Core Features absent or contradicted by the roadmap structure?
- **Target User drift** — do any objectives serve a user segment not defined in vision?
- **Non-Functional Requirements** — do any objectives conflict with a stated NFR?

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

- **yes** → apply all proposed changes to `docs/blueprint/vision.md`, save, and output: "✅ vision.md updated to reflect roadmap scope changes."
- **no** → output: "ℹ️ vision.md not updated. Re-run `/speckit.blueprint.vision` when ready to re-align."

If no drift found → output: "✅ Vision consistent with roadmap."

---

### Step 8: Completion

Confirm the file is saved:

- `docs/blueprint/roadmap.md` ✓

Output:

```text
Roadmap complete. [N] stages, [N] Spec Outlines defined.

Next: /speckit.specify [Spec Outline 001 goal]
After each Spec is complete, run the next Spec Outline in dependency order.
```

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/roadmap.md` | Staged delivery plan with Spec Outlines and dependencies |

---

## For AI Generation

When filling `templates/roadmap-template.md`:

### Stage Rules

- Each stage delivers a demonstrable, locally-runnable increment — not an internal milestone
- One Spec Outline per stage, no exceptions. If a stage needs two Spec Outlines, split the stage instead
- Stage size must produce a Spec Outline of 2–4+ sprints. If smaller, merge with an adjacent stage

### Spec Outline Field Rules

**Goal** — User-facing, one sentence. Bad: "Implement authentication". Good: "Users can register and log in with email/password."

**Objectives** — 1–3 only. Each becomes a P1/P2/P3 section in `spec.md`. Phrase as outcomes ("Users can X"), not tasks ("Implement X").

**Size** — Round to nearest sprint. Use `~1`, `~2`, `~3`. Do not write ranges.

**Deps** — List Spec Outline IDs (e.g., `Spec Outline 001`). Write `—` if no dependencies.

**Spec** — Write `—` until the spec file exists. Updated automatically by `_roadmap-sync` after `/speckit.specify`.

### Status Markers

| Marker | Meaning | When to set |
| --- | --- | --- |
| `[📋]` | Planned | Default — not yet specified |
| `[🚧]` | In Progress | After `/speckit.specify` starts |
| `[✅]` | Complete | After `_roadmap-sync` confirms completion |

Never change markers manually unless the user explicitly asks to reset a status.

### Execution Order Rules

**Sequence** — Critical path only. Spec Outlines that can run in parallel do not belong here.

**Parallel Groups** — Include only if two or more Spec Outlines can genuinely run concurrently. Remove the table entirely if everything is sequential. "Can start after" must name a specific Spec Outline ID, not a stage name.

### Scope Signals — Remove Before Saving

| Found in draft | Where it belongs instead |
| --- | --- |
| Code snippets or technical implementation details | `spec.md` |
| More than 3 objectives in a Spec Outline | Split the stage |
| Task-level breakdowns or test cases | `spec.md` |
| Sprint-by-sprint assignments or team member allocation | Project management tool |
| Multiple Spec Outlines in one stage | Split the stage |

