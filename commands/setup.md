---
description: "Configure Jira/GitLab project settings for Blueprint. One-time setup per project."
tools:
  - mcp-jira/search
  - mcp-jira/get_issue
  - mcp-gitlab/projects
---

# Blueprint Setup

One-time setup to configure Jira/GitLab project settings for Blueprint.

## Purpose

Store integration configuration in `.specify/memory/blueprint.yml` so that downstream commands can:

- Sync EP/ST/FT hierarchy with Jira
- Link GitLab issues and merge requests
- Track project progress across tools

This command is idempotent — running it again updates the existing configuration.

## User Input

`$ARGUMENTS`

If `$ARGUMENTS` is provided, use it to pre-fill the Jira project key and skip the prompt when possible.

## Instructions

### Step 1: Check Existing Setup

Check if `.specify/memory/blueprint.yml` exists.

**If it exists:**

1. Read and display the existing configuration:

   ```yaml
   jira:
     project_key: "[existing value]"
     epic_issue_type: "[existing value]"
     story_issue_type: "[existing value]"
     ft_issue_type: "[existing value]"

   gitlab:
     project_path: "[existing value]"
   ```

2. Ask: "An existing configuration was found above. What would you like to do?
   - (1) Update configuration
   - (2) Keep as-is and exit
   - (3) Reset to defaults and re-configure"

3. Proceed based on user choice. For option (2), stop here. For option (3), clear the file and proceed as if it does not exist.

**If it does not exist:**

1. Ensure the `.specify/memory/` directory exists. Create it if needed.
2. Proceed to Step 2.

---

### Step 2: Jira Configuration

Collect the following Jira settings from the user.

**Jira Project Key**

Ask: "What is your Jira project key? (e.g., `PROJ`, `MYAPP`)"

- If `$ARGUMENTS` contains a value that looks like a project key (2–10 uppercase letters), suggest it as the default.
- Validate that the key is non-empty and contains only alphanumeric characters.

**Jira Issue Types**

For each issue type below, prompt the user with a sensible default. Accept freeform input or press Enter to use the default.

| Setting | Default | Question |
| --- | --- | --- |
| EP issue type | `Epic` | "What Jira issue type represents an Epic? (default: Epic)" |
| ST issue type | `Story` | "What Jira issue type represents a Story? (default: Story)" |
| FT issue type | `Task` | "What Jira issue type represents a Feature/Task? (default: Task)" |

Confirm the collected Jira settings:

```yaml
jira:
  project_key: "[value]"
  epic_issue_type: "[value]"
  story_issue_type: "[value]"
  ft_issue_type: "[value]"
```

"Are these Jira settings correct? (yes / no)"

- If **no**: return to the start of Step 2.
- If **yes**: proceed to Step 3.

---

### Step 3: GitLab Configuration

Collect the GitLab project path from the user.

**GitLab Project Path**

Ask: "What is your GitLab project path? (format: `group/project` or `namespace/project`, e.g., `myteam/myapp`)"

Validate that the path contains exactly one `/` and no leading or trailing slashes.

Confirm the collected GitLab setting:

```yaml
gitlab:
  project_path: "[value]"
```

"Is this GitLab project path correct? (yes / no)"

- If **no**: return to the start of Step 3.
- If **yes**: proceed to Step 4.

---

### Step 4: Save Configuration

Write the complete configuration to `.specify/memory/blueprint.yml`:

```yaml
jira:
  project_key: "[USER_INPUT]"
  epic_issue_type: "[USER_INPUT or Epic]"
  story_issue_type: "[USER_INPUT or Story]"
  ft_issue_type: "[USER_INPUT or Task]"

gitlab:
  project_path: "[USER_INPUT]"
```

Confirm: "Configuration saved. Proceed to verification? (yes / no)"

- If **no**: stop here and remind the user to run `/speckit.blueprint.setup` again to verify later.
- If **yes**: proceed to Step 5.

---

### Step 5: Verification

Test the configured integrations using MCP tools.

**Jira Verification:**

1. Use `mcp-jira/search` to query issues with `project = [project_key]` and a limit of 1.
2. If the call succeeds: output "Jira connection verified. Project `[project_key]` is accessible."
3. If the call fails: output the error and ask: "Jira verification failed. Check the project key and try again? (yes / no)"
   - If **yes**: return to Step 2.
   - If **no**: note that Jira integration may not work and continue.

**GitLab Verification:**

1. Use `mcp-gitlab/projects` to look up the project by `project_path`.
2. If the call succeeds: output "GitLab connection verified. Project `[project_path]` is accessible."
3. If the call fails: output the error and ask: "GitLab verification failed. Check the project path and try again? (yes / no)"
   - If **yes**: return to Step 3.
   - If **no**: note that GitLab integration may not work and continue.

---

### Step 6: Completion

Confirm the file is saved:

- `.specify/memory/blueprint.yml` ✓

Tell the user:

> Blueprint setup complete. Your Jira/GitLab configuration has been saved.
>
> **Next steps:**
> - Run `/speckit.blueprint.vision` to define your project vision.
> - Run `/speckit.blueprint.roadmap` to create a delivery roadmap.

## Output Files

| File | Purpose |
| --- | --- |
| `.specify/memory/blueprint.yml` | Jira/GitLab integration settings for Blueprint commands |
