---
description: "Generate a staged delivery roadmap from the confirmed vision."
---

# Blueprint Roadmap

Generate a staged delivery roadmap from the confirmed vision.

## Purpose

Using the confirmed `vision.md`, create a staged roadmap that:
- Breaks the project into deliverable stages
- Fits stage sizes to the team's sprint cadence
- Establishes clear acceptance criteria per stage

The output feeds into `/speckit.blueprint.decompose`.

## Scope Boundary

`roadmap.md` answers **when and in what order** — not who does what or how.

**Belongs here:** stage names and goals, deliverables per stage, dependencies between stages, acceptance criteria per stage.

**Does NOT belong here:** Epic or story breakdowns, task lists, specific implementation approaches, code or architecture decisions, sprint-by-sprint assignments, team member allocation. If any of these appear in your draft, they belong in decompose or a spec — remove them from the roadmap.

## User Input

$ARGUMENTS

If `$ARGUMENTS` is provided, use it to focus on a specific concern (e.g., "focus on the backend stages" or "re-plan from Stage 3 onward").

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_roadmap` and execute them in order.

After saving `docs/blueprint/roadmap.md`, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_roadmap` and execute them in order.

## Instructions

### Step 0: Prerequisites Check

Check if `docs/blueprint/vision.md` exists.

If missing, stop and tell the user: "Run `/speckit.blueprint.vision` first."

---

### Step 1: Check Existing Roadmap

Check if `docs/blueprint/roadmap.md` exists.

**If it exists:**
1. Read and summarize the current roadmap (number of stages, goals, current progress)
2. Ask: "Your existing roadmap is summarized above. What would you like to do?
   - (1) Update specific stages
   - (2) Regenerate from scratch
   - (3) Cancel"
3. Proceed based on user choice.

**If it does not exist:**
Proceed to Step 2.

---

### Step 2: Generate roadmap.md Draft

Read `docs/blueprint/vision.md` — pay special attention to:
- Sprint cadence and team size (Execution Context section)
- Core features and out-of-scope items

**Principles:**
- Each stage delivers a demonstrable, locally-runnable version
- Stage size should fit the team's sprint cadence
- Earlier stages cover foundational/blocking work; later stages add depth and polish
- Each stage has clear acceptance criteria

```markdown
# Roadmap: [Project Name]

## Stage 1: [Name]
**Goal:** [What this stage delivers]
**Deliverables:**
- [Specific output 1]
- [Specific output 2]
**Dependencies:** [Prior stages or external prerequisites]
**Acceptance Criteria:**
- [ ] [Verifiable criterion]

## Stage 2: [Name]
...
```

Show the draft to the user and ask:
"Here's the proposed roadmap. Does the staging make sense? Are the stage sizes realistic for your team?"

Incorporate feedback. Repeat until the user confirms.

Save to `docs/blueprint/roadmap.md`.

---

### Step 3: Scope Check

Before confirming completion, review the saved `docs/blueprint/roadmap.md` against the Scope Boundary defined above.

Flag any content that does not belong at the roadmap level:

- Epic or user story breakdowns within a stage → belongs in decompose
- Task lists or sub-tasks → belongs in decompose or spec
- Specific implementation approaches or technology choices → belongs in spec
- Sprint-by-sprint or person-by-person assignments → belongs in project management tooling

For each violation found, output:
```
⚠️ Scope issue in roadmap.md: "[excerpt]"
This level of detail belongs in [decompose / spec / project management]. Remove it from roadmap.md or move it to the appropriate stage.
```

Ask the user: "Found [N] scope issue(s) above. Fix before proceeding? (yes / no / skip)"
- **yes** → apply fixes and re-confirm the file
- **no / skip** → proceed as-is, note issues remain

If no violations found → output: "✅ Scope check passed."

---

### Step 5: Completion

Confirm the file is saved:
- `docs/blueprint/roadmap.md` ✓

Tell the user:
"Roadmap defined. Next step: run `/speckit.blueprint.decompose` to break each stage into Epic-sized units ready for implementation."

## Output Files

| File | Purpose |
|------|---------|
| `docs/blueprint/roadmap.md` | Staged delivery plan — input for decompose |
