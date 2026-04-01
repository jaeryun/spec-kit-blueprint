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

**Belongs here:** stage names and goals, acceptance criteria per stage, one Spec Outline per stage (user-facing goal, 1–3 user stories, size estimate), dependencies between Spec Outlines, execution order.

**Does NOT belong here:** implementation details, code snippets, task-level breakdowns, test cases, more than 3 stories per Spec Outline, sprint-by-sprint assignments, team member allocation. If any of these appear in a draft, they belong in a spec — remove them.

## Stage : Spec Outline Ratio

Each stage has **exactly one** Spec Outline. If a stage is too large to fit into a single Epic (2–4+ sprints), split it into two stages rather than adding a second Spec Outline.

Spec Outline stories map directly to the P1/P2/P3 priority sections that `/speckit.specify` will generate inside `spec.md`. Keep stories user-facing and outcome-oriented.

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
   - (3) Cancel"
3. If the user chooses (1): identify which stages to update from `$ARGUMENTS` or from their reply. Stages whose Spec Outline is marked ✅ Complete or 🚧 In Progress are **immutable** — do not re-analyze or overwrite them. Proceed to Step 2 for only the targeted stages.
4. If the user chooses (2): proceed to Step 2 for all stages.
5. If the user chooses (3): stop.

**If it does not exist:** proceed to Step 2.

---

### Step 2: Phase 1 — Stage Boundary Definition

Output: `[Phase 1 of 3] Stage Boundary Definition`

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
- **Stories**: 1–3 user stories that will become P1/P2/P3 sections in `spec.md` — phrase as outcomes, not tasks
- **Size**: estimated sprint count (~N sprints)

One Spec Outline per stage, no exceptions. If stories exceed 3 or the size estimate exceeds what fits one Epic, split the stage instead.

Present the Spec Outlines to the user and ask: "Do the Spec Outlines correctly capture what each stage delivers? Are the story counts and sizes realistic?"

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

Assemble and save `docs/blueprint/roadmap.md` using the format below. Include a `_Last updated:_` line with today's date.

```markdown
# Roadmap: [Project Name]

_Last updated: [date]_

---

## Stage 1: [Name]

**Goal:** [What this stage delivers]
**Dependencies:** [Prior stages or None]
**Acceptance Criteria:**
- [ ] [Verifiable criterion]

**Spec Outline:**
- [📋] **Spec Outline 001** [User-facing goal]
  - Stories: [story 1], [story 2]
  - Size: ~N sprints
  - Deps: —

**Status:** 📋 Planned

---

## Stage 2: [Name]

**Goal:** ...
**Dependencies:** Stage 1
**Acceptance Criteria:**
- [ ] ...

**Spec Outline:**
- [📋] **Spec Outline 002** [User-facing goal]
  - Stories: [story 1], [story 2]
  - Size: ~N sprints
  - Deps: Spec Outline 001

**Status:** 📋 Planned

---

## Execution Order

### Sequence (must be done in order)
Spec Outline 001 → Spec Outline 002 → Spec Outline 004 → ...

### Parallel Groups
| Group | Spec Outlines                       | Can start after         |
|-------|-------------------------------------|-------------------------|
| A     | Spec Outline 003, Spec Outline 005  | Spec Outline 001 complete |

---

## Summary
- Total Spec Outlines: [N]
- Estimated total: [N sprints]
- Critical path: Spec Outline 001 → Spec Outline 002 → ...
```

The `[📋]` marker on each Spec Outline indicates it is ready to specify. When a Spec is in progress, change `[📋]` to `[🚧]`; when complete, change it to `[✅]`.

---

### Step 6: Scope Check

After saving, review `docs/blueprint/roadmap.md` against the Scope Boundary defined above.

Flag each violation before confirming completion:

| Violation | Guidance |
|-----------|----------|
| Multiple Spec Outlines per Stage | Merge into one Spec Outline or split the Stage |
| More than 3 stories in a Spec Outline | Trim to 3 or split the Stage |
| Implementation detail in a story | Move to spec |
| Spec Outline sized under ~1 sprint | Consider merging with an adjacent stage |
| Stage Deliverables section present (old format) | Remove — the Spec Outline covers this |

For each violation found, output:

```
[!] Scope issue in roadmap.md: "[excerpt]"
This level of detail belongs in [spec / project management]. Remove it from roadmap.md.
```

Ask the user: "Found [N] scope issue(s) above. Fix before proceeding? (yes / no / skip)"
- **yes** — apply fixes, re-save, and re-confirm the file
- **no / skip** — proceed as-is and note issues remain

If no violations are found, output: "Scope check passed."

---

### Step 7: Completion

Confirm the file is saved:
- `docs/blueprint/roadmap.md` ✓

Output:

```
Roadmap complete. [N] stages, [N] Spec Outlines defined.

Next: /speckit.specify [Spec Outline 001 goal]
After each Spec is complete, run the next Spec Outline in dependency order.
```

## Output Files

| File | Purpose |
|------|---------|
| `docs/blueprint/roadmap.md` | Staged delivery plan with Spec Outlines and dependencies |
