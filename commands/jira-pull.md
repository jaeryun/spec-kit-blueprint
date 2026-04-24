---
description: "Fetch Jira FT comments and status for context injection before specify/plan/tasks."
tools:
  - mcp-jira/search
  - mcp-jira/get_issue
---

# Blueprint Jira Pull

Fetch Jira FT (Feature/Task) comments and status for context injection.

## Trigger

Automatically invoked by `before_specify`, `before_plan`, `before_tasks` hooks.

## Purpose

Check Jira for FT status changes, comments, and blockers before writing specs, plans, or tasks. Injects Jira context into the session so the AI can reference up-to-date issue state.

## Instructions

### Step 1: Identify Current FT

Determine the active FT from the following sources (in order):

1. **Branch name** — extract `FT-NNN` or numeric ID (e.g., `feature/ft-7-foo` -> `FT-7`)
2. **Directory** — check `.specify/memory/current-ft.yml` or current working directory for FT markers
3. **Prompt user** — if no FT can be determined, skip silently

If no FT is found, log:

> `[jira-pull] No active FT found. Skipping context fetch.`

Stop. Do not error.

---

### Step 2: Read Configuration

Read `.specify/memory/blueprint.yml` for:

- `project_key` — Jira project key

If `blueprint.yml` is missing or `project_key` is not set, log:

> `[jira-pull] Skipped: blueprint.yml not configured. Run /speckit.blueprint.setup.`

Stop.

---

### Step 3: Fetch Jira FT

Search Jira by label `blueprint-ft-[ID]` using `mcp-jira/search`.

If found, fetch full issue details with `mcp-jira/get_issue`.

Extract:

- **Status** — current workflow status (e.g., "To Do", "In Progress", "Done")
- **Assignee** — display name or email
- **Comments** — last 10 comments (date, author, body)
- **Linked issues** — blocks / is blocked by / relates to

If no Jira FT is found, log:

> `[jira-pull] No Jira issue found for FT-[ID]. Skipping context injection.`

Stop. Do not error.

On any tool error, log:

> `[jira-pull] Failed to fetch Jira FT-[ID]: [error message]. Skipping context injection.`

Stop. Do not block the calling command.

---

### Step 4: Inject Context

Output the following markdown block into the session context (e.g., via ` thinking` or system context injection):

```markdown
## Jira Context for FT-[ID]

**Status:** [To Do / In Progress / Done]
**Assignee:** [name]

**Recent Comments:**
- [date] [author]: [comment]
- ...

**Consider this context when writing [spec/plan/tasks].**
```

Replace `[spec/plan/tasks]` with the appropriate hook context (e.g., `spec` for `before_specify`, `plan` for `before_plan`, `tasks` for `before_tasks`).

Log:

> `[jira-pull] Injected Jira context for FT-[ID] ([STATUS]).`
