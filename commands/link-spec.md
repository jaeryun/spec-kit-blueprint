---
description: "Link a Feature (FT) to its spec directory in blueprint.md after /speckit.specify."
---

# Blueprint Link Spec

Link a Feature (FT) to its spec directory in `blueprint.md`.

This command is intended to be run **after** `/speckit.specify [FT-ID]` completes. It records the spec directory path in the master blueprint so that subsequent commands (e.g., `/speckit.blueprint.archive`) can locate the spec immediately without scanning.

## User Input

`$ARGUMENTS`

Expected format: `"FT-X.X.X [spec-directory]"`

Examples:
- `"FT-1.1.1 specs/001-auth"` — links FT-1.1.1 to `specs/001-auth`
- `"FT-1.1.1"` — links FT-1.1.1 by auto-detecting the spec directory in `specs/`

If `$ARGUMENTS` is not provided, ask: "Which FT should I link? (e.g., FT-1.1.1 specs/001-auth)"

## Hooks

Run `before_blueprint_link_spec` hooks before starting, and `after_blueprint_link_spec` hooks after completion.

## Instructions

### Step 1: Parse Input

1. Split `$ARGUMENTS` by whitespace.
   - First token: **Feature ID** (must match `FT-[N].[N].[N]`).
   - Second token (optional): **Spec directory path** (e.g., `specs/001-auth`).
2. Validate the Feature ID format. If invalid, warn: "Invalid Feature ID format. Expected FT-[N].[N].[N]." Stop.
3. If no spec directory path is provided, set a flag to auto-detect in Step 2.

---

### Step 2: Determine Spec Directory

**Case A — Spec path provided by user:**
- Verify the directory exists and contains `spec.md`.
- If not found, warn: "Directory `[path]` does not exist or has no `spec.md`." Stop.
- Use the provided path.

**Case B — Auto-detect:**
- Search the project's spec directory (e.g., `specs/`).
- Scan candidate directories. Read their `spec.md` to find which one belongs to the target FT.
- If exactly one match is found, use it.
- If multiple matches are found, list them and ask the user to pick one.
- If none are found, warn: "No spec directory found for [FT-ID]. Run `/speckit.specify [FT-ID]` first." Stop.

---

### Step 3: Update blueprint.md

1. Read `{docs_base_path}/blueprint/blueprint.md`.
2. Locate the target FT line (e.g., `- FT-1.1.1 — …`).
3. If the FT is not found, warn: "[FT-ID] not found in `blueprint.md`. Run `/speckit.blueprint.design` first." Stop.
4. Check if the FT already has a `**Spec Path**` sub-item.
   - **If yes** and the path is different:
     > "FT-[ID] already linked to `[old-path]`. Overwrite with `[new-path]`? (yes / no)"
     - **yes**: update the line.
     - **no**: stop and report no changes.
   - **If yes** and the path is identical:
     > "FT-[ID] is already linked to `[path]`. No changes needed."
     Stop.
    - **If no**: add new sub-items under the FT line:
      ```markdown
        - **Spec Path**: [path]
        - **Status**: InProgress
      ```
5. If the FT has a `**Status**` field and its value is `ToDo`, update it to `InProgress`.
6. Update the `_Last updated: [date]_` line.
7. Append a History entry: `[YYYY-MM-DD HH:MM] | blueprint.md | Linked [FT-ID] to [path] | Status: InProgress`.

---

### Step 4: Completion

- `blueprint.md`: updated

Output:

```text
FT-[ID] linked to `[path]`.

Next: /speckit.blueprint.archive [FT-ID] (when ready)
```

> Tip: Run this command immediately after `/speckit.specify [FT-ID]` so the spec directory is always recorded.
