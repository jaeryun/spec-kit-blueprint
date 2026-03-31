---
description: "Decompose roadmap into Epic-sized specs with dependency ordering."
---

# Blueprint Decompose

Decompose the roadmap into Epic-sized units ready for `/speckit.specify`.

## Purpose

This is Step 3 of the Blueprint workflow. It reads the confirmed vision and roadmap, then:
1. Breaks each roadmap stage into right-sized Epics
2. Validates each Epic fits within a single `/speckit.specify` run
3. Identifies dependencies between Epics
4. Groups Epics that can be worked on in parallel

The output is `docs/blueprint/epics.md` — the authoritative list of what to build and in what order.

## Scope Boundary

`epics.md` answers **what to build in each unit** — not how to build it.

**Belongs here:** Epic user-facing goals, 1–3 user stories per Epic, hard/soft dependencies, size estimates, parallel groupings.

**Does NOT belong here:** spec-level detail, implementation approaches, code snippets, UI wireframes, more than 3 user stories per Epic, task-level breakdowns, test cases. If any of these appear in your draft, they belong in a spec (`/speckit.specify`) — remove them from epics.

## User Input

$ARGUMENTS

If `$ARGUMENTS` is provided, use it to focus the breakdown on a specific stage (e.g., "Stage 2" re-runs breakdown for that stage only).

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_decompose` and execute them in order.

After saving `docs/blueprint/epics.md`, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_decompose` and execute them in order.

## Instructions

### Step 0: Prerequisites Check

Verify both files exist:
- `docs/blueprint/vision.md`
- `docs/blueprint/roadmap.md`

If `vision.md` is missing, stop and tell the user: "Run `/speckit.blueprint.vision` first."
If `roadmap.md` is missing, stop and tell the user: "Run `/speckit.blueprint.roadmap` first."

### Step 1: Check Existing Epics

Check if `docs/blueprint/epics.md` exists.

**If it exists:**
1. Read the current epics.md
2. Identify which Epics are ✅ Complete or 🚧 In Progress — these are **immutable**, do not re-analyze them
3. Identify which roadmap stages have no corresponding Epics yet (new stages added after last breakdown)
4. Ask: "Found [N] existing Epics ([X] complete, [Y] in progress, [Z] planned). I'll only re-analyze the pending stages. Proceed?"
5. On confirmation, only process stages that have 📋 Epics or no Epics yet

**If it does not exist:**
Process all roadmap stages.

---

### Step 2: Epic Decomposition

For each roadmap stage being processed:

**Size calibration** — Before decomposing, read `docs/blueprint/vision.md` and extract:
- Sprint cadence (e.g., 2-week sprints)
- Team size

Use these to set a target Epic size. A well-sized Epic should be:
- Deliverable and demonstrable on its own
- Completable without losing context or momentum
- Large enough to represent a coherent user-facing outcome — not a micro-task

There is no fixed sprint count. Let the team's cadence and the nature of the work determine the right size. When in doubt, err toward larger Epics that can be split later rather than too-fine decomposition upfront.

**Size Validation Test** — For each candidate Epic, ask:
> "Can this be expressed as a single `spec.md` with a clear user-facing goal, covered by 1-3 User Stories, and deliverable as a standalone increment given this team's cadence?"

- If **yes** → it's one Epic
- If **no** → split further and re-test each part
- If **too small** (trivial, disproportionate to team cadence) → consider merging with a related Epic

**Each Epic must have:**
- A clear user-facing goal (not a technical task)
- 1-3 User Stories that together define "done"
- An identifiable boundary (what's in, what's out)

**Epic format in epics.md:**
```
E[NNN]: [User-facing goal]
  Stories: [Brief list of 1-3 user stories]
  Stage: [Parent roadmap stage]
  Size: [estimated sprints based on team cadence from vision.md, e.g. ~2 sprints / ~4 sprints / ~6 sprints]
```

---

### Step 3: Dependency Analysis

After decomposing all Epics, analyze dependencies:

**Types of dependencies:**
- **Hard dependency**: Epic B cannot start until Epic A is merged (shares data model, API contract, auth layer, etc.)
- **Soft dependency**: Epic B is easier after Epic A but can technically start in parallel (shared UI components, similar patterns)

For each Epic, determine:
- Which other Epics must be complete before it can start (hard deps)
- Which Epics it blocks

**Rules:**
- Keep dependency chains short — if everything depends on everything, the breakdown is too fine-grained
- Foundation Epics (auth, data model, core infrastructure) should be early with many dependents
- Feature Epics should have at most 1-2 hard dependencies

---

### Step 4: Parallel Group Analysis

From the dependency graph, identify groups of Epics that can be worked on simultaneously:

- **Sequential**: must be done one after another (hard dep chain)
- **Parallel group**: no hard dependencies between them, can start at the same time

---

### Step 5: Generate epics.md

Create `docs/blueprint/epics.md`:

```markdown
# Blueprint Epics

_Generated from roadmap. ✅ Complete and 🚧 In Progress epics are immutable._
_Last updated: [date]_

---

## Stage 1: [Stage Name]

- [📋] **E001** [User-facing goal]
  - Stories: [story 1], [story 2]
  - Size: ~2 sprints
  - Deps: —

- [📋] **E002** [User-facing goal]
  - Stories: [story 1]
  - Size: ~4 sprints
  - Deps: E001

## Stage 2: [Stage Name]

- [📋] **E003** [User-facing goal]
  - Stories: [story 1], [story 2], [story 3]
  - Size: ~3 sprints
  - Deps: E001

---

## Execution Order

### Sequence (must be done in order)
E001 → E002 → E004 → ...

### Parallel Groups
| Group | Epics | Can start after |
|-------|-------|-----------------|
| A     | E003, E005 | E001 complete |
| B     | E006, E007 | E003 complete |

---

## Summary
- Total Epics: [N]
- Estimated total: [N sprints based on sizes]
- Critical path: E001 → E002 → E005 → E008
```

Show the epics.md draft to the user and ask:
"Here's the Epic breakdown. Does the granularity feel right? Any Epics that should be split or merged?"

Incorporate feedback and save to `docs/blueprint/epics.md`.

---

### Step 6: Scope Check

Before confirming completion, review the saved `docs/blueprint/epics.md` against the Scope Boundary defined above.

Flag any content that does not belong at the Epic level:

- More than 3 user stories in a single Epic → split the Epic or trim stories
- Implementation detail within a story (how to build it) → belongs in spec
- Code snippets, data models, or UI wireframes → belongs in spec
- Task-level breakdowns or sub-tasks → belongs in spec
- Test cases or acceptance test scripts → belongs in spec

For each violation found, output:
```
⚠️ Scope issue in epics.md: "[excerpt]"
This level of detail belongs in [spec / specify]. Remove it from epics.md or defer it to the relevant /speckit.specify run.
```

Ask the user: "Found [N] scope issue(s) above. Fix before proceeding? (yes / no / skip)"
- **yes** → apply fixes and re-confirm the file
- **no / skip** → proceed as-is, note issues remain

If no violations found → output: "✅ Scope check passed."

---

### Step 8: Completion

Tell the user:
"Breakdown complete. [N] Epics defined across [N] stages.

To start implementing:
1. Pick the first 📋 Epic (or the first parallel group)
2. Run `/speckit.specify [Epic goal]`
3. After specify → plan → tasks → implement cycle completes, update E[NNN] status to ✅ in `docs/blueprint/epics.md`
4. Run `/speckit.blueprint.decompose [next stage]` when ready for the next batch"

## Output Files

| File | Purpose |
|------|---------|
| `docs/blueprint/epics.md` | Epic list with status, dependencies, and execution order |
