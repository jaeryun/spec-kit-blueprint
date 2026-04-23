---
description: "Generate the Epic→Story hierarchy and story.md drafts from the confirmed vision."
tools:
  - mcp-jira/create_issue
  - mcp-jira/update_issue
---

# Blueprint Roadmap

Generate the Epic→Story hierarchy and story.md drafts from the confirmed vision.

## Purpose

Defining specs one at a time — without a shared view of the whole project — leads to specs that are too large or too small. There's no basis for calibrating scope when each spec is written in isolation.

This command addresses that by building the full 3-level hierarchy before any Feature spec is written. Through a user interview, it decomposes the vision into:

| Level | ID Pattern | What It Represents |
| --- | --- | --- |
| **Epic (EP)** | EP-01, EP-02, ... | A coherent delivery goal, typically 1–2 months of work |
| **Story (ST)** | ST-01, ST-02, ... | A user-facing feature area that may span multiple PRs |
| **Feature (FT)** | FT-01, FT-02, ... | One unit of work = one `/speckit.specify` run |

The output is a hierarchy of right-sized Epics and Stories in execution order — each Story the input to future `/speckit.specify` runs (via `/speckit.blueprint.sync-story`).

```
EP-01 — Foundation
  ├─ ST-01 — Authentication core
  │     ├─ FT-01 — Email/password sign-up
  │     └─ FT-02 — Session management
  └─ ST-02 — API scaffolding
        └─ FT-03 — Core API endpoints
```

Key implications for generation:
- Each **Feature (FT)** = one `/speckit.specify` run.
- **Story scope is calibrated as a set** — sizes are adjusted relative to each other across the whole roadmap, factoring in priority and team capacity.
- **Story scope is intentionally abstract** — the exact phase breakdown (P1/P2/P3) is determined during `/speckit.specify` through a detailed requirements interview.

## User Input

`$ARGUMENTS`

If provided, interpret `$ARGUMENTS` as user intent and apply it during generation (e.g., "focus on backend", "exclude mobile").

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_roadmap` and execute them in order.

After saving all output files, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_roadmap` and execute them in order.

## Instructions

### Step 0: Prerequisites Check

Check that `docs/blueprint/vision.md` exists.

If missing, stop and output: "Run `/speckit.blueprint.vision` first."

Also check if `.specify/memory/blueprint.yml` exists. If missing, warn:

> "⚠️ Blueprint setup not found. Jira integration will not be available during this session.
> Run `/speckit.blueprint.setup` to enable Jira sync.
> Proceed without Jira integration? (yes / no)"

- If **no**: stop here.
- If **yes**: continue, and note at the end that Jira setup is pending.

---

### Step 1: Check Existing Roadmap

If `docs/blueprint/blueprint.md` does not exist, proceed to Step 2.

If it exists, read it and summarize (Epic count, IDs, Stories with FT counts, Jira links). Then ask:

"What would you like to do?
  (1) Update — re-analyze specific Epics or Stories
  (2) Regenerate — start from scratch
  (3) Cancel"

- **(1)** Identify targets from `$ARGUMENTS` or user reply. For Epics/Stories with linked Jira issues, warn: "A Jira issue is already linked to this Epic/Story. Proceed with the scope update anyway? (yes / no)" — skip if no, include if yes. Proceed to Step 2 for confirmed targets only.
- **(2)** Proceed to Step 2 for all Epics and Stories.
- **(3)** Stop.

---

### Step 2: Interview & Draft

Read `docs/blueprint/vision.md`. Pay special attention to sprint cadence, team size, core features, and out-of-scope items.

Begin with an introduction:

> **Starting Blueprint Roadmap Interview**
>
> This conversation builds a **delivery roadmap** from your vision. We'll define a 3-level hierarchy: **Epics** (delivery goals), **Stories** (feature areas), and **Features** (spec-sized units).
>
> **We cover:**
> - Work not explicitly captured in vision.md
> - External integrations and foundational requirements
> - MVP vs. deferrable scope
> - Execution order and dependencies
>
> **Scope for this step:** We define **what** gets built and **in what order** — not **how** (architecture, tech stack, API design). Those details come in `/speckit.specify`.
>
> I'll ask one question at a time. After each answer, I'll confirm my understanding before moving on.

**Interview Rules (Strict):**

1. **ONE question at a time** — Never ask multiple questions in one turn.

2. **Immediate scope guard** — After each answer, check for content that belongs in `/speckit.specify`:
   - Specific technology choices, frameworks, libraries
   - API design details, data models, schema definitions
   - Implementation approaches, architectural patterns
   - Phase breakdowns (P1/P2/P3), sprint assignments

   If detected: "Those details belong in `/speckit.specify`. For now, let's focus on what this Story delivers from the user's perspective. [Rephrase question focusing on outcomes only]"

3. **Confirm and get approval** — After each valid answer:
   - Summarize: "**[Topic]**: [1-2 sentence summary]"
   - Ask: "Is this correct? (yes / no / add more)"
   - Wait for explicit approval before the next question

**Topics to cover** (adapt based on vision.md, skip already answered):

- Team size, sprint cadence, target timeline
- External integrations (legacy APIs, third-party services, internal tools)
- Non-functional requirements not in vision (performance, compliance, accessibility)
- Foundational work required before the first user-facing feature can ship
- Known constraints and risks
- MVP scope — which capabilities are essential for initial release vs. deferrable
- Anything the user expects to be included that hasn't come up yet

**Work Breakdown Questions** (after general topics):

1. **Epic decomposition** — What are the major delivery goals? Group related work into Epics.
2. **Stories per Epic** — For each Epic, what user-facing feature areas (Stories) does it contain?
3. **Feature list per Story** — For each Story, what are the spec-sized Features? Each Feature should map to one `/speckit.specify` run.
4. **Execution order** — Which Epics/Stories must come before others? What can be parallelized?

Using vision.md + interview answers, draft the initial hierarchy. Apply the **Epic/Story Boundary Principles** and **Scope Guide** when deciding boundaries and sizing. Do not present the draft yet — proceed to Step 3.

---

### Step 3: Validate & Calibrate

Present the full initial hierarchy to the user. Then validate across all three dimensions and include findings in the same response:

- **Vision alignment** — does any scope contradict core features, out-of-scope items, target users, or NFRs in vision.md? **Strict adherence is mandatory.** If the user wants to introduce goals outside the current vision, they must stop and run `/speckit.blueprint.vision` first to update the core project definition.
- **Scope sizing** — is any Story too broad or too narrow? (See Scope Guide)
- **Dependency logic** — is the execution order sound? Flag circular dependencies or Stories that require foundational work not yet planned.

If issues are found, propose specific adjustments alongside the draft. Ask: "Does this look correct? Any changes?"

Incorporate feedback and repeat until the user confirms.

---

### Step 4: Generate Output Files

Load the templates to understand required sections:
- `templates/blueprint-template.md` for `docs/blueprint/blueprint.md`
- `templates/epic-template.md` for each `docs/blueprint/epic-NN.md`
- `templates/story-template.md` for the structure of each `docs/blueprint/story-NN.md` (lightweight draft)

Fill each file with the confirmed output from Steps 2 and 3, following the **For AI Generation** guidelines below.

#### 4a: blueprint.md

Create or update `docs/blueprint/blueprint.md` with the Epic list.

If the file did not yet exist, include the initial history entry from the template. If it already existed, preserve all existing history entries and append a new line: `[YYYY-MM-DD HH:MM] | [Summary]`.

Keep summaries concise (one line) and descriptive of the specific action taken (e.g., "Full regeneration from vision.md", "EP-02 updated to include API requirements").

#### 4b: epic.md files

Create or update one `docs/blueprint/epic-[NN].md` per Epic, following `templates/epic-template.md`.

Each Epic file lists its Stories with scope summaries and Jira links.

#### 4c: story.md lightweight drafts

Create or update one `docs/blueprint/story-[NN].md` per Story. This is a **lightweight draft** (not the full technical SoT — that is built incrementally via `/speckit.blueprint.sync-story` after each FT is merged).

Use this format:

```markdown
# ST-XX — [Story Title]

> Source of Truth. Last updated: [date]
> Jira: —

## Overview
[2-3 sentences from interview]

## Scope
- FT-XX — ... [To Do]
- FT-XX — ... [To Do]

## Tech Context
(TBD — filled after FT completion)

## Non-Goals
(TBD — filled after FT completion)

## NFR
(TBD — filled after FT completion)

## ADR
(TBD — filled after FT completion)
```

Save all files.

---

### Step 5: Completion

Confirm all files are saved:

- `docs/blueprint/blueprint.md` ✓
- `docs/blueprint/epic-*.md` ([N] files) ✓
- `docs/blueprint/story-*.md` ([N] files) ✓

Output:

```text
Roadmap complete. [N] Epics, [M] Stories, [P] Features defined.

Hierarchy:
[EP-01] — [Epic Title]
  [ST-01] — [Story Title] ([P] FTs)
  [ST-02] — [Story Title] ([P] FTs)
[EP-02] — [Epic Title]
  ...

Next: /speckit.specify [first Feature with no linked spec]
```

If Step 0 found no `blueprint.yml` and the user chose to proceed anyway, append this reminder:

```text
⚠️ Note: Jira setup is still pending. Run `/speckit.blueprint.setup` before syncing to Jira.
```

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/blueprint.md` | Entry point — Epic list and project overview |
| `docs/blueprint/epic-*.md` | One per Epic — Story list with scope and Jira links |
| `docs/blueprint/story-*.md` | One per Story — lightweight draft, evolves into technical SoT via `sync-story` |

---

## For AI Generation

### Field Rules

**Epic Summary** — User-facing, one sentence. Bad: "Implement authentication". Good: "Users can register and log in securely."

**Story Summary** — User-facing, one sentence describing the feature area. Bad: "Build auth API". Good: "Users can authenticate via email and manage their sessions."

**Story Scope** — Free-form prose. Write what this Story covers at an abstract level — not how it will be built, not how many phases it will have. Phase breakdown happens during `/speckit.specify`.

**Feature List** — Brief bullet per FT. Each FT is a single `/speckit.specify` run. FTs are placeholders at roadmap time; their detailed specs are written later.

**Jira** — Write `—` until the Jira issue is created. Linked automatically by `jira-sync-hierarchy-hook` after roadmap generation, or via manual Jira sync.

### Epic/Story Boundary Principles

Apply these when deciding where one Epic/Story ends and the next begins:

- **Vertical slice, not horizontal layer** — one Story covers a complete capability end-to-end (e.g., "user authentication" including both API and UI), not a technical layer in isolation (e.g., "auth API" and "auth UI" as separate Stories). Horizontal cuts produce Stories that cannot be demoed or shipped independently.
- **One complete user journey** — do not split a single user journey across two Stories unless one part genuinely blocks the other and is large enough to stand alone. A user who can't complete the flow after this Story ships gets no value.
- **Independent demo-ability** — when a Story is complete, there must be something meaningful to show a stakeholder. If completing it requires another Story to be useful, reconsider the boundary.
- **Foundational work is the exception** — auth, DB schema, core infrastructure, and CI/CD setup are legitimately separate even if they don't deliver user-visible value alone, because everything downstream depends on them.

### Epic/Story Scope Guide

**Target Epic size: 1–2 months** — a coherent delivery goal that a small team can commit to.

**Target Story size: Jira Epic-level** — the standard unit of work that fits in a software development roadmap, decomposable into 3–8 Features.

| Dimension | Epic Guideline | Story Guideline |
|-----------|----------------|-----------------|
| **Duration** | 1–2 months | 2–6 weeks |
| **Team** | 1–3 people | 1–2 people |
| **Decomposition** | 2–5 Stories | 3–8 Features |

**Epic too broad — consider splitting if:**

- Estimated duration exceeds 2 months
- Scope spans unrelated domains (e.g., payment processing + user profiles in one Epic)
- Contains multiple independent delivery goals that don't need each other

**Epic too narrow — consider merging if:**

- Estimated duration is under 3 weeks
- Contains only one Story that doesn't stand alone as a major milestone

**Story too broad — consider splitting if:**

- Estimated duration exceeds 6 weeks
- Scope spans unrelated user journeys
- Contains more than 8 Features

**Story too narrow — consider merging if:**

- Estimated duration is under 2 weeks
- Contains fewer than 3 Features
- Completing this Story requires another to be useful (and they're not a dependency)

**Context signals to weigh when assessing scope balance:**

Read `vision.md` and interview answers before judging:

| Signal | What it means for scope |
| --- | --- |
| Solo developer | Err toward narrower Epics/Stories — less parallelism available |
| First Epic/Story | Keep scope tighter — environment setup adds hidden work |
| External API / third-party integration | Each integration adds uncertainty; factor in when judging breadth |
| Unfamiliar domain or tech stack | Narrower scope reduces risk of underestimating |
| Well-understood CRUD / business logic | Broader scope acceptable |
