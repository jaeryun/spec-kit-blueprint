---
description: "Archive a completed FT into its parent Story's story.md."
---

# Blueprint Archive

Archive a completed Feature (FT) into its parent Story's technical Source of Truth (`story.md`).

## Purpose

When a Feature is fully specified and implemented, its technical decisions, ADRs, and context should be merged into the Story-level `story.md` so the Story's Source of Truth stays current. This command handles that merge one FT at a time.

## User Input

`$ARGUMENTS`

Feature ID, e.g., `"FT-1.1.1"`.

If `$ARGUMENTS` is not provided, ask: "Which Feature should I archive? (e.g., FT-1.1.1)"

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_archive` and execute them in order.

After completing all steps, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_archive` and execute them in order.

## Instructions

### Step 1: Parse Input

1. Extract the Feature ID from `$ARGUMENTS` (e.g., `FT-1.1.1`).
2. Validate the Feature ID format: expected pattern is `FT-[N].[N].[N]`.
3. If invalid or missing, warn the user and stop.

---

### Step 2: Locate FT Spec

1. Find the spec directory for this FT. Search under `specs/` for a directory whose name contains the FT ID (e.g., `specs/ft-1.1.1-*/` or `specs/FT-1.1.1-*/`).
2. Verify `spec.md` exists in that directory. If not found, warn:
   > "No spec found for [FT-ID]. Run `/speckit.specify [FT-ID]` first."
   > Stop.
3. Read `spec.md` and extract:
   - **Tech Context** section
   - **ADR** section (if any)
   - Any linked artifacts (data-model.md, contracts/, etc.) — list their paths only

---

### Step 3: Identify Parent Story

1. Read `docs/blueprint/blueprint.md` and locate the FT in the Epic → Story → Feature hierarchy.
2. Extract the parent Story ID (e.g., `ST-1.1`) and Story title.
3. Find the Story directory: `docs/blueprint/epics/[epic-slug]/[story-slug]/`. Search under each `epics/*/` directory to match the Story ID in the `story.md` title.
4. Verify `story.md` exists in that directory. If not found, warn the user and stop.

---

### Step 4: Update story.md

1. Read the current `story.md`.
2. Merge the FT's technical content into `story.md`:
   - Append or update the **Tech Context** section with content from `spec.md`
   - Append or update the **ADR** section with ADRs from `spec.md`
   - Preserve existing structure and ordering
   - Avoid duplicate entries if this FT was previously archived
3. Update the Story's **Current State** section to mark this FT as completed.
4. Show a diff of the proposed changes to `story.md`.
5. Ask the user:

   > "Apply these changes to story.md? (yes / no)"

   - If **yes**: write the updated `story.md`, update the `_Last updated: [date]_` line, and append a History entry: `[YYYY-MM-DD HH:MM] | story.md | Archived FT-[ID]`.
   - If **no**: stop here and report that no changes were made.

---

### Step 5: Completion

Confirm completion status:

| Step | Status |
| --- | --- |
| story.md updated | [yes / no / skipped] |

Provide next steps:

> FT-[ID] archived into [ST-ID]. Next: pick another FT to specify, or archive the next completed FT.

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/epics/[epic-slug]/[story-slug]/story.md` | Updated Story technical Source of Truth with merged FT content |
