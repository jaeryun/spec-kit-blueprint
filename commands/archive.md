---
description: "Archive a completed FT into the project's Knowledge Base under docs/."
---

# Blueprint Archive

Archive a completed Feature (FT) into the project's Knowledge Base under `docs/`.

## Purpose

When a Feature is fully specified and implemented, its technical decisions, ADRs, and context should be preserved as durable project knowledge — independent of delivery units (Stories). This command extracts durable technical content from an FT's spec directory and stores it under `docs/` as topic-based knowledge that survives Story closure.

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
3. If invalid or missing, warn: "Invalid Feature ID format. Expected FT-[N].[N].[N]."
   Stop.

---

### Step 2: Locate FT Spec

1. Find the spec directory for this FT. Search under the project's spec directory for a directory whose name contains the FT ID (e.g., `specs/ft-1.1.1-*/` or `specs/FT-1.1.1-*/` or similar naming conventions used by the project).
2. Verify `spec.md` exists in that directory. If not found, warn:
   > "No spec found for [FT-ID]. Run `/speckit.specify [FT-ID]` first."
   > Stop.
3. Read **all files** in that directory, not just `spec.md`. This includes:
   - `spec.md` (core)
   - `data-model.md`, `adr.md`, or any other markdown files
   - Files under subdirectories such as `contracts/`, `schemas/`, `diagrams/`, etc.
4. Extract durable technical content (exclude temporary workarounds, sprint assignments, unvalidated UI mockups, and implementation todo lists):
   - **Tech Context** section from `spec.md`
   - **ADR** section(s) from any files
   - Key architecture decisions, data models, API contracts, and other artifacts
   - List all artifact paths for reference

---

### Step 3: Identify Parent Story

1. Read `docs/blueprint/blueprint.md` and locate the FT in the Epic → Story → Feature hierarchy.
2. If the FT is not found in `blueprint.md`, warn: "FT-[ID] not found in `blueprint.md`. Run `/speckit.blueprint.design` first to define the hierarchy."
   Stop.
3. Extract the parent Story ID (e.g., `ST-1.1`) and Story title.
4. Note the spec directory name (e.g., `specs/ft-1.1.1-user-auth`) for use in Step 5b.

---

### Step 4: Propose Knowledge Base Location

1. Analyze the extracted content to identify the **topics** covered by this FT (e.g., `auth`, `database`, `messaging`, `api-contract`).
2. Scan `docs/` for any existing `.md` files and subdirectories that might serve as a topic-based knowledge base.
3. **Topic Convention**: Use short lowercase English words with hyphens (e.g., `auth`, `api-contracts`, `user-profile`). Prefer concise, recognizable names.

#### Directory Structure Configuration

The KB directory structure is managed in **the user's project** at `.specify/config-bp.yml`. This file is created on first archive and updated when the user changes the structure.

The **detailed descriptions** of the 5 structure options (A~E) plus Custom are maintained in **this extension's** `templates/archive-directory-guide.md`. Read that file when you need to present options to the user.

**Config file format (user's `.specify/config-bp.yml`):**
```yaml
blueprint:
  kb_structure: "A"        # A, B, C, D, E, or custom
  custom_description: ""   # Only used when kb_structure is "custom"
  last_updated: "YYYY-MM-DD"
```

**First-time setup (if user's `.specify/config-bp.yml` does not exist):**
1. Inform the user: "This appears to be the first archive for this project. Let's set up your Knowledge Base directory structure."
2. Read `templates/archive-directory-guide.md` from this extension to get the full option descriptions.
3. Present a concise summary:
   > **Choose a directory structure for your Knowledge Base:**
   >
   > **A. Category-Based** — domains/ (business) + systems/ (tech) + cross-cutting/ + decisions/
   > **B. Domain-Driven** — identity/, communication/, commerce/ (DDD bounded contexts) + decisions/
   > **C. Feature-Foundation Split** — features/ (user-facing) + foundations/ (tech) + operations/ + decisions/
   > **D. Layer-Based** — frontend/ + backend/ + infrastructure/ + decisions/
   > **E. Topic-Centric Flat** — topics/ + decisions/ + runbooks/ (minimal depth)
   > **Custom** — Define your own structure
   >
   > _Say "details" to see full descriptions with examples, or pick A~E/Custom._
   > _You can always change this later by saying "restructure" during any archive._
4. If the user says "details", read `templates/archive-directory-guide.md` and present the full option descriptions.
5. If the user chooses **A~E**: write `.specify/config-bp.yml` with `kb_structure: "X"`.
6. If the user chooses **Custom**:
   - Ask: "Describe your custom directory structure (e.g., 'docs/modules/, docs/shared/, docs/adrs/')"
   - Store in `.specify/config-bp.yml`:
     ```yaml
     blueprint:
       kb_structure: "custom"
       custom_description: "docs/modules/, docs/shared/, docs/adrs/"
       last_updated: "YYYY-MM-DD"
     ```

**Normal operation (user's config exists):**
1. Read `.specify/config-bp.yml` from the user's project.
2. Propose the KB location **within the configured structure**.
3. Always present the proposal with a visible "restructure" hint:
   > This FT covers topics: **[topic1, topic2, ...]**.
   >
   > **Proposed KB location(s):**
   > 1. `docs/[category]/[proposed-file].md` (recommended — fits your current structure)
   > 2. `docs/[alternative-category]/[alternative].md`
   > 3. Enter a custom path
   >
   > _Not happy with the structure? Say **"restructure"** to change your KB layout, **"details"** to see full option descriptions, or **"custom"** to use a one-off path._
   >
   > Confirm or specify your preferred path.

**Structure change request:**
If the user says "restructure", "change structure", "reorganize", "different pattern", or similar:
1. Read `templates/archive-directory-guide.md` to get the full option descriptions.
2. Present the 5 options (A~E) + Custom to the user.
3. If the user wants details, show the full descriptions from the guide file.
4. After selection, update `.specify/config-bp.yml`:
   - Update `blueprint.kb_structure`
   - Update `blueprint.last_updated`
   - If custom, update `blueprint.custom_description`
5. Inform the user: "Structure updated. Future archives will use this new layout."
6. Continue archiving with the new structure.

**One-off custom path:**
If the user says "custom" or provides a path outside the configured structure:
- Accept the path as a one-off exception.
- Do NOT update `.specify/config-bp.yml`.
- Archive the FT to the specified path.
- Note: "This is a one-off path. Your default structure remains unchanged."

**Ambiguous response:**
If the user replies with phrases like "you decide", "anywhere is fine", or gives an unclear answer, ask explicitly: "Where should I archive this FT's knowledge? (path under docs/, or say 'restructure' to change layout, or 'details' to see options)"

---

### Step 5: Create/Update Knowledge Base & blueprint.md

#### 5a: Prepare Knowledge Base changes

1. Read the target file if it already exists.
2. If the target file already contains a section for this FT (e.g., `## From FT-[ID]`), warn the user:

   > ⚠️ FT-[ID] is already archived in `docs/[file].md` (last updated: [date]).
   >
   > What would you like to do?
   > (1) Update existing section with new content
   > (2) Skip (no changes)
   > (3) Archive to a different file instead

   - If **(1)**: proceed to update the existing section.
   - If **(2)**: stop and report that no changes were made.
   - If **(3)**: return to Step 4 to reselect the KB file.

3. Merge the FT's technical content into the target file using this format:

   File header (new or updated):
   ```markdown
   <!--
   Topics: [comma-separated topics]
   Contributors: [list of FT-IDs already in this file, plus this one]
   Last updated: [YYYY-MM-DD]
   -->
   ```

   Content sections (appended or merged):
   ```markdown
   ## From FT-X.X.X — [FT Title]
   
   [Tech Context content from spec.md]
   
   ### ADRs
   [ADR content]
   
   ### Artifacts
   - [artifact description]: [relative path]
   ```

3. Preserve existing structure and ordering in the target file.
4. Avoid duplicate entries: if this FT was previously archived to this file, update the existing section rather than appending a new one.

#### 5b: Prepare blueprint.md changes

5. Read `docs/blueprint/blueprint.md`.
6. Locate the line for this FT in the hierarchy.
7. Append the spec directory name and a completion marker:
   - Before: `- FT-1.1.1 — Email/password sign-up`
   - After: `- FT-1.1.1 — Email/password sign-up (specs/ft-1.1.1-user-auth) ✅`
8. In the parent Story section, append a **Related KB** line if not already present:
   - Add under the Story's bullet: `  - **Related KB**: [docs/file.md](docs/file.md#from-ft-1-1-1)`
   - If a Related KB line already exists, append the new link.
9. Update the `_Last updated: [date]_` line.
10. Append a History entry: `[YYYY-MM-DD HH:MM] | blueprint.md | Archived FT-[ID] to docs/[file].md`.

#### 5c: Confirm and apply

11. Show a summary of changes:
    - Knowledge Base: new or updated sections in `docs/[file].md`
    - blueprint.md: FT completion marker + Related KB link
12. Ask the user:

    > "Apply these changes (Knowledge Base + `blueprint.md`)? (yes / no / KB-only)"
    >
    > Accepted responses (case-insensitive):
    > - Proceed: "yes", "y", "sure", "apply"
    > - Partial: "KB-only", "just KB", "knowledge base only"
    > - Cancel: "no", "n", "cancel", "abort"
    > - Review: "review", "show details", "preview"
    > - Change target: "change target", "different file"

    - If **yes** (or synonyms): write both the updated KB file and `blueprint.md`.
    - If **KB-only** (or synonyms): write only the KB file. Warn: "`blueprint.md` was not updated. FT-[ID] will appear as incomplete. Run `/speckit.blueprint.archive FT-[ID]` again to fix."
    - If **no** (or synonyms): stop here and report that no changes were made.
    - If **review** (or synonyms): show the exact diff/preview, then repeat the question.
    - If **change target** (or synonyms): return to Step 4 to reselect the KB file.
    - If the user replies with anything else or an ambiguous answer, ask for clarification: "Did you mean to apply all changes? (yes / no / KB-only / review / change target)" or repeat the prompt.

---

### Step 6: Completion

Confirm completion status:

| Step | Status |
| --- | --- |
| FT spec read | yes |
| Knowledge Base updated | [file path or skipped] |
| blueprint.md updated | [yes / no / skipped] |

Provide next steps:

> FT-[ID] archived into `docs/[file].md`. Next: pick another FT to specify, or archive the next completed FT.
>
> Suggest the next unarchived FT from the same Story (read `blueprint.md` to find the next sibling FT without a ✅ marker). If none remain in this Story, suggest the first unarchived FT from the next Story in dependency order.

## Output Files

| File | Purpose |
| --- | --- |
| `docs/[topic].md` | Topic-based Knowledge Base with merged FT technical content, ADRs, and artifact references. Survives Story closure. |
| `docs/blueprint/blueprint.md` | Master blueprint with FT completion markers and spec directory references. |
