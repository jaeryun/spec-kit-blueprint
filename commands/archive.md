---
description: "Archive a completed FT into the project's archive location under the configured base path."
---

# Blueprint Archive

Archive a completed Feature (FT) into `{docs_base_path}/` as durable project knowledge.

All archive paths use `docs_base_path` from `.specify/config-bp.yml` (default: `docs`). Read this value at the start of Step 4 and use it in place of `{docs_base_path}/` throughout this command.

## User Input

`$ARGUMENTS`

Accepted forms:
- **Feature ID**: `FT-1.1.1`
- **Spec directory path**: `specs/001-auth`
- **Spec directory ID**: `001-auth`

If `$ARGUMENTS` is not provided, ask: "Which Feature should I archive? (FT ID, spec path, or spec ID)"

## Hooks

Run `before_blueprint_archive` hooks before starting, and `after_blueprint_archive` hooks after completion.

## Instructions

### Step 1: Parse Input

1. Examine `$ARGUMENTS`.
   - If it matches `FT-[N].[N].[N]`, treat it as a **Feature ID**.
   - Otherwise, treat it as a **spec directory path or ID** (e.g., `specs/001-auth` or `001-auth`).
2. If `$ARGUMENTS` is empty, ask for input. Stop if still empty.

---

### Step 2: Locate FT via blueprint.md

1. Read `{docs_base_path}/blueprint/blueprint.md`.
2. **If input is a Feature ID:**
   - Locate the FT line in the hierarchy.
   - If not found, warn: "FT-[ID] not found in `blueprint.md`. Run `/speckit.blueprint.design` first." Stop.
   - Read the FT's `**Spec Path**` value.
3. **If input is a spec path or ID:**
   - Scan all FT entries in blueprint.md for a matching `**Spec Path**`.
   - If the input lacks a directory prefix (e.g., `001-auth`), also try matching against `specs/[input]`.
   - If no match is found, warn: "No FT linked to `[input]` in `blueprint.md`. Run `/speckit.blueprint.link-spec` first." Stop.
   - If multiple matches are found, list them and ask the user to pick one.
   - Extract the FT ID from the matched entry.
4. Verify the spec directory exists and contains `spec.md`. If not, warn: "Spec directory `[path]` not found or missing `spec.md`." Stop.
5. Read all `.md` files in that directory and subdirectories. List non-markdown artifact paths for reference, but do not read them.
6. Extract durable technical content (exclude temporary workarounds, sprint assignments, unvalidated mockups, and todo lists): Tech Context, ADRs, architecture decisions, data models, API contracts, and artifact paths.

---

### Step 3: Identify Parent Story

1. From the blueprint.md already read in Step 2, locate the FT in the Epic → Story → Feature hierarchy.
2. Extract the parent Story ID (e.g., `ST-1.1`) and Story title.
3. Note the spec directory name for use in Step 5.

---

### Step 4: Propose Archive Location

1. Analyze the extracted content to identify the **topics** covered by this FT (e.g., `auth`, `database`, `messaging`).
2. Scan `{docs_base_path}/` for existing `.md` files and subdirectories.
3. **Topic Convention**: Use short lowercase English words with hyphens (e.g., `auth`, `api-contracts`).

#### Directory Structure

The archive structure is configured in `.specify/config-bp.yml`:

```yaml
blueprint:
  docs_structure: ""           # category_based, domain_driven, etc., or custom
  custom_structure_description: ""
  last_updated: "YYYY-MM-DD"
```

On first archive or when `docs_structure` is empty, read `docs/archive-directory-guide.md` and present a concise summary with an AI recommendation:

> **Choose a directory structure:**
>
> **category_based** — business domains + tech systems + cross-cutting + decisions
> **domain_driven** — DDD bounded contexts + decisions
> **feature_foundation_split** — user-facing features + tech foundations + operations + decisions
> **layer_based** — frontend + backend + infrastructure + decisions
> **topic_centric_flat** — flat topics + decisions + runbooks
> **custom** — define your own layout
>
> Based on this FT's content, I recommend: **[type]** — [1-sentence reason].

After the user picks a type, write `.specify/config-bp.yml` and continue.

**Normal operation:**

Propose the archive location within the configured structure:

> This FT covers topics: **[topic1, topic2, ...]**.
>
> **Proposed location:** `{docs_base_path}/[category]/[proposed-file].md`
>
> Confirm, specify a different path, or say **restructure** to change your layout, **custom** for a one-off path.

If the user says "restructure", present the 5 structure types + custom again, update `.specify/config-bp.yml`, and continue.

If the user says "custom" or provides a path outside the configured structure, accept it as a one-off exception. Do NOT update `.specify/config-bp.yml`.

---

### Step 5: Apply Changes

1. Read the target file if it already exists.
2. If the target file already contains a section for this FT (e.g., `## From FT-[ID]`):
   > "FT-[ID] is already archived in `{docs_base_path}/[file].md`. I'll update it with the latest content. (Say 'skip' to do nothing, or 'new file' to archive elsewhere.)"
   - If **skip**: stop and report no changes.
   - If **new file**: return to Step 4 to reselect.
   - Otherwise (default): update the existing `## From FT-[ID]` section. All other sections are preserved.
3. Merge the FT's technical content using this format:
   ```markdown
   <!--
   Topics: [comma-separated topics]
   Contributors: [list of FT-IDs in this file]
   Last updated: [YYYY-MM-DD]
   -->

   ## From FT-X.X.X — [FT Title]

   [Tech Context content from spec.md]

   ### ADRs
   [ADR content]

   ### Artifacts
   - [artifact description]: [relative path]
   ```
4. Read `{docs_base_path}/blueprint/blueprint.md`.
5. Update the FT's `**Status**` to `Done`.
   - If no `**Status**` field exists, add it under the FT line.
6. In the parent Story section, append a **Related KB** line if the same link doesn't already exist:
   - `  - **Related KB**: [{docs_base_path}/file.md](../file.md#from-ft-1-1-1)`
7. Update the `_Last updated: [date]_` line.
8. Append a History entry: `[YYYY-MM-DD HH:MM] | blueprint.md | Archived FT-[ID] to {docs_base_path}/[file].md`.

#### Confirm

> Apply these changes? (yes / review / no)

- **yes**: write both files.
- **review**: show a diff/preview, then repeat the question.
- **no** (or anything else): stop and report no changes.

---

### Step 6: Completion

- FT spec read: yes
- Knowledge Base: `{docs_base_path}/[file].md` [new / updated / skipped]
- blueprint.md: [updated / skipped]

> ✅ FT-[ID] archived to `{docs_base_path}/[file].md`. Next: `/speckit.blueprint.archive [next-FT]`
