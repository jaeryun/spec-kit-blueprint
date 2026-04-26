---
description: "Archive completed FTs into story.md."
---

# Blueprint Archive

Archive completed FTs into the Story's technical Source of Truth (`story.md`).

## Purpose

Update a Story's technical Source of Truth after its linked FTs are complete. This command merges completed FT content into `story.md` so the Story-level documentation stays current as Features are delivered.

## User Input

`$ARGUMENTS`

Story ID, e.g., `"ST-1.1"`.

If `$ARGUMENTS` is not provided, ask: "Which Story should I archive? (e.g., ST-1.1)"

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_archive` and execute them in order.

After completing all steps, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_archive` and execute them in order.

## Instructions

### Step 1: Parse Input

1. Extract the Story ID from `$ARGUMENTS` (e.g., `ST-1.1`).
2. Validate the Story ID format: expected pattern is `ST-[N].[N]`.
3. Find the Story directory: `docs/blueprint/epics/[epic-slug]/[story-slug]/`. Search under each `epics/*/` directory to match the Story ID in the `story.md` title.
4. Verify `story.md` exists in that directory. If not, warn the user and stop.

---

### Step 2: Identify Completed FTs

1. Read `docs/blueprint/blueprint.md` and find the Story's **Features** list under its Epic.
2. For each FT, check if a completed spec exists (look for `specs/[ft-slug]/spec.md` or similar).
3. Build a status summary table:

   | FT ID | Title | Status | Done? |
   | --- | --- | --- | --- |
   | FT-XX | ... | Done | [x] |
   | FT-YY | ... | In Progress | [ ] |

4. Identify FTs with status **Done** (or equivalent terminal state).

---

### Step 3: Update story.md

1. For each completed FT, merge its technical content into `story.md`:
   - Append or update the **Tech Context** section
   - Append or update the **ADR** section
   - Preserve existing structure and ordering
2. Show a diff of the proposed changes to `story.md`.
3. Ask the user:

   > "Apply these changes to story.md? (yes / no)"

    - If **yes**: write the updated `story.md`, update the `_Last updated: [date]_` line, and append a History entry: `[YYYY-MM-DD HH:MM] | story.md | Archived completed FTs`.
   - If **no**: stop here and report that no changes were made.

---

### Step 4: Completion

Confirm completion status:

| Step | Status |
| --- | --- |
| story.md updated | [yes / no / skipped] |

Provide next steps:

> Story SoT updated. Next: pick another FT to specify, or archive the next Story.

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/epics/[epic-slug]/[story-slug]/story.md` | Updated Story technical Source of Truth with merged FT content |
