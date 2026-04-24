---
description: "Archive completed FTs into story.md, optionally create MR, and update Jira Story."
tools:
  - mcp-jira/search
  - mcp-jira/get_issue
  - mcp-jira/update_issue
  - mcp-gitlab/merge_requests
  - mcp-gitlab/create_merge_request
---

# Blueprint Archive

Archive completed FTs into the Story's technical Source of Truth (`story.md`). Optionally create a GitLab Merge Request and update the Jira Story description.

## Purpose

Update a Story's technical Source of Truth after its linked FTs are complete. This command:

- Merges completed FT content into `story.md`
- Commits and pushes the updated `story.md`
- Creates a GitLab MR for review
- Updates the Jira Story description with completion status

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
3. Optionally, search Jira for FTs linked to this Story using `mcp-jira/search`:
   - Query: `parent = [ST-ID] AND issuetype = FT`
4. Build a status summary table:

   | FT ID | Title | Status | Done? |
   | --- | --- | --- | --- |
   | FT-XX | ... | Done | [x] |
   | FT-YY | ... | In Progress | [ ] |

5. Identify FTs with status **Done** (or equivalent terminal state).

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

### Step 4: Git Commit & Push

1. Stage the updated `story.md`.
2. Propose a commit message: `docs(blueprint): archive [ST-ID] story.md with completed FTs`
3. Ask the user:

   > "Commit and push the updated story.md? (yes / no)"

   - If **yes**: commit and push to the current branch.
   - If **no**: skip to Step 5 without committing. Note that the MR in Step 5 will include uncommitted changes if any.

---

### Step 5: Create GitLab MR

1. Prepare MR details:
    - **Title**: `docs(blueprint): archive [ST-ID] story.md with completed FTs`
   - **Description**: summarize which FTs were merged and link to the Story directory.
2. Ask the user:

   > "Create a GitLab Merge Request? (yes / no)"

   - If **yes**: create the MR using `mcp-gitlab/create_merge_request`.
   - If **no**: skip this step.

---

### Step 6: Update Jira Story Description

1. Build the updated Story description in this format:

   ```markdown
   📌 Blueprint Story: [ST-ID] — [Title]

   🔗 Blueprint: [link to story.md]

   ## Completed Features
   - [x] FT-XX — ...
   - [ ] FT-XX — ...

   ## Tech Context
   [merged from story.md]

   ## ADR
   [merged from story.md]
   ```

2. Ask the user:

   > "Update the Jira Story description? (yes / no)"

   - If **yes**: update the Story issue using `mcp-jira/update_issue` with the new description.
   - If **no**: skip this step.

---

### Step 7: Completion

Confirm completion status:

| Step | Status |
| --- | --- |
| story.md updated | [yes / no / skipped] |
| Git commit & push | [yes / no / skipped] |
| GitLab MR created | [yes / no / skipped] |
| Jira Story updated | [yes / no / skipped] |

Provide next steps based on what was done:

- If MR was created: "MR is ready for review. Once merged, the Story's Source of Truth is finalized."
- If no MR was created: "story.md has been updated locally. Commit and push manually when ready."
- If Jira Story was not updated: "Remember to update the Jira Story description manually to reflect FT completion status."

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/epics/[epic-slug]/[story-slug]/story.md` | Updated Story technical Source of Truth with merged FT content |
