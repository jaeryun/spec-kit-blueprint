---
description: "Generate the Epic→Story→Feature hierarchy and story.md drafts from the confirmed vision."
---

# Blueprint

Generate the Epic→Story→Feature hierarchy and story.md drafts from the confirmed vision.

## Purpose

Defining specs (result of `/speckit.specify`) one at a time — without a shared view of the whole project — leads to specs that are too large or too small. There's no basis for calibrating scope when each spec is written in isolation.

This command addresses that by building the 3-level hierarchy before any Feature spec is written. Through a user interview, it decomposes the vision into:

| Level | Jira Analog | ID Pattern | Typical Scope | Represents |
|-------|-------------|------------|---------------|------------|
| **Epic (EP)** | Epic | EP-1, EP-2, ... | 2–5 Stories | A strategic initiative — a coherent business goal or major user journey. |
| **Story (ST)** | Story | ST-1.1, ST-1.2, ... | 3–8 Features | A user-facing capability delivered as a vertical slice — end-to-end value that can be demoed and shipped independently. Equivalent to a Jira Story. |
| **Feature (FT)** | Task | FT-1.1.1, FT-1.1.2, ... | 1 specify run | A spec-sized implementation unit — exactly one `/speckit.specify` run. Equivalent to a Jira Task. |

The output is a hierarchy of right-sized Epics, Stories, and Features.

```
EP-1 — Foundation
  ├─ ST-1.1 — Authentication core
  │     ├─ FT-1.1.1 — Email/password sign-up
  │     └─ FT-1.1.2 — Session management
  └─ ST-1.2 — API scaffolding
        └─ FT-1.2.1 — Core API endpoints
```

- Each **Feature (FT)** is the starting point for one `/speckit.specify` run.
- **Story scope is calibrated as a set** — sizes are adjusted relative to each other across the whole blueprint, factoring in priority and team capacity.

## User Input

`$ARGUMENTS`

If provided, interpret `$ARGUMENTS` as user intent and apply it during generation (e.g., "focus on backend", "exclude mobile", "update EP-2", "add a Story to EP-1", "reorder FT-1.2.1 and FT-1.2.2").

## Hooks

Before starting, **must** check `.specify/extensions.yml` for any handlers registered under `before_blueprint_design` and execute them in order.

After saving all output files, **must** check `.specify/extensions.yml` for any handlers registered under `after_blueprint_design` and execute them in order.

## Instructions

### Step 0: Prerequisites Check

Check that `docs/blueprint/vision.md` exists.

If missing, stop and output: "Run `/speckit.blueprint.vision` first."

---

### Step 1: Check Existing Blueprint

If `docs/blueprint/blueprint.md` does not exist, proceed to Step 2.

If it exists, read it and summarize (Epic count, IDs, Stories with FT counts). Then ask:

"What would you like to do?
  (1) Update — re-analyze specific Epics or Stories
  (2) Regenerate — start from scratch
  (3) Cancel"

- **(1)** Identify targets from `$ARGUMENTS` or user reply. Proceed to Step 2 for confirmed targets only.
- **(2)** Proceed to Step 2 for all Epics and Stories.
- **(3)** Stop.

---

### Step 2: Interview & Draft

Read `docs/blueprint/vision.md`. Pay special attention to team size, core features, and out-of-scope items.

Begin with an introduction:

> **Starting Blueprint Interview**
>
> This conversation builds a **delivery blueprint** from your vision. We'll define a 3-level hierarchy: **Epics** (delivery goals), **Stories** (feature areas), and **Features** (spec-sized units).
>
> **Important:** You don't need to get everything perfect immediately. This is an initial design — you can re-run `/speckit.blueprint.design` anytime to add, remove, or reorder Epics and Stories as your understanding evolves.
>
> **We cover:**
> - Work not explicitly captured in vision.md
> - External integrations and foundational requirements
> - MVP vs. deferrable scope
> - Dependencies and sequencing
>
> **Scope for this step:** We define **what** gets built and **in what order** — not **how** (architecture, tech stack, API design). Those details come in `/speckit.specify`.
>
> I'll ask 1–3 questions at a time. After each answer, I'll confirm my understanding before moving on.

**Interview Rules (Strict):**

1. **Ask 1–3 questions at a time** — Adapt based on question length and complexity. A single broad question warrants one at a time. A set of tightly related, short follow-ups can be grouped up to three.

2. **Immediate scope guard** — After each answer, check for content that belongs in `/speckit.specify`:
   - Specific technology choices, frameworks, libraries
   - API design details, data models, schema definitions
   - Implementation approaches, architectural patterns
   - Sprint assignments

   If detected: "Those details belong in `/speckit.specify`. For now, let's focus on what this Story delivers from the user's perspective. [Rephrase question focusing on outcomes only]"

3. **Confirm and get approval** — After each valid answer:
   - Summarize: "**[Topic]**: [1-2 sentence summary]"
   - Ask: "Is this correct? (yes / no / add more)"
   - Wait for explicit approval before the next question

**Topics to cover** (adapt based on vision.md, skip already answered):

- Team size, project constraints
- External integrations (legacy APIs, third-party services, internal tools)
- Non-functional requirements not in vision (performance, compliance, accessibility)
- Foundational work required before user-facing Stories can be implemented
- Known constraints and risks
- MVP scope — which capabilities are essential for initial release vs. deferrable
- Anything the user expects to be included that hasn't come up yet

**Work Breakdown Questions** (after general topics):

1. **Epic decomposition** — What are the major delivery goals? Group related work into Epics.
2. **Stories per Epic** — For each Epic, what user-facing feature areas (Stories) does it contain?
3. **Feature list per Story** — For each Story, what are the spec-sized Features? Each Feature should map to one `/speckit.specify` run.
4. **Dependency order** — Which Epics/Stories must come before others? What can be parallelized?

Using vision.md + interview answers, draft the initial hierarchy. Apply the **Epic/Story Boundary Principles** and **Scope Guide** when deciding boundaries and sizing. Do not present the draft yet — proceed to Step 3.

---

### Step 3: Validate & Calibrate

Present the full initial hierarchy to the user. Then validate across all three dimensions and include findings in the same response:

- **Vision alignment** — does any scope contradict core features, out-of-scope items, target users, or NFRs in vision.md? **Strict adherence is mandatory.** If the user wants to introduce goals outside the current vision, they must stop and run `/speckit.blueprint.vision` first to update the core project definition.
- **Scope sizing** — is any Story too broad or too narrow? (See Scope Guide)
- **Dependency logic** — is the dependency order sound? Flag circular dependencies or Stories that require foundational work not yet planned.

If issues are found, propose specific adjustments alongside the draft. Ask: "Does this look correct? Any changes?"

Incorporate feedback and repeat until the user confirms.

---

### Step 4: Generate Output Files

Load the templates to understand required sections:
- `templates/blueprint-template.md` for `docs/blueprint/blueprint.md`
- `templates/story-template.md` for the structure of each Story's `story.md`

Fill each file with the confirmed output from Steps 2 and 3, following the **For AI Generation** guidelines below.

#### 4a: blueprint.md

Create or update `docs/blueprint/blueprint.md` with the full Epic → Story → Feature hierarchy.

This is the **single master document** for the delivery blueprint. It replaces the old per-Epic files.

Ensure every Epic and Story entry includes the `External: —` field (reserved for future tracker integration).

If the file did not yet exist, include the initial history entry from the template. If it already existed, preserve all existing history entries and append a new line: `[YYYY-MM-DD HH:MM] | [Subject] | [Summary]`.

Keep summaries concise (one line) and descriptive of the specific action taken (e.g., "Full regeneration from vision.md", "EP-2 updated to include API requirements").

#### 4b: story.md lightweight drafts

For each Story, create a directory at `docs/blueprint/epics/[epic-slug]/[story-slug]/` and place a lightweight `story.md` inside it.

This is **not** the full technical SoT — that is built incrementally via `/speckit.blueprint.archive` after each FT is merged. Additional artifacts (data-model.md, contracts/, etc.) can be added to the same directory as the Story evolves.

Use this format (matches `templates/story-template.md`):

```markdown
# ST-X.X — [Story Title]

> Source of Truth.
> External: —

## Overview
[2-3 sentences from interview]

## Current State
(TBD — filled incrementally after each FT is specified and merged)

## Tech Context
(TBD)

## Non-Goals
(TBD)

## NFR
(TBD)

## ADR
(TBD)
```

Save all files.

---

### Step 5: Completion

Confirm all files are saved:

- `docs/blueprint/blueprint.md` ✓
- `docs/blueprint/epics/[epic-slug]/[story-slug]/story.md` ([N] files) ✓

Output:

```text
Blueprint complete. [N] Epics, [M] Stories, [P] Features defined.

Hierarchy:
[EP-1] — [Epic Title]
  [ST-1.1] — [Story Title] ([P] FTs)
  [ST-1.2] — [Story Title] ([P] FTs)
[EP-2] — [Epic Title]
  ...

Next: /speckit.specify [first Feature not yet specified]

> This is your initial blueprint. Re-run `/speckit.blueprint.design` anytime your plans change — add new Epics, split Stories, or reorder Features.
```



## Output Files

| File / Directory | Purpose |
| --- | --- |
| `docs/blueprint/blueprint.md` | **Master blueprint** — full Epic → Story → Feature hierarchy in one document. |
| `docs/blueprint/epics/[epic-slug]/[story-slug]/` | One Story directory per Epic — contains `story.md` (lightweight draft → evolves into technical SoT via `archive`) and any related artifacts. |

---

## For AI Generation

### Field Rules

**Epic Summary** — User-facing, one sentence. Bad: "Implement authentication". Good: "Users can register and log in securely."

**Story Summary** — User-facing, one sentence describing the feature area. Bad: "Build auth API". Good: "Users can authenticate via email and manage their sessions."

**Story Scope** — Free-form prose. Write what this Story covers at an abstract level — not how it will be built, not implementation sequencing or work assignments. Detailed breakdown happens during `/speckit.specify`.

**Feature List** — Brief bullet per FT. Each FT is a single `/speckit.specify` run. FTs are placeholders at this stage; their detailed specs are written later.

**External** — Write `—` until an external tracking issue is linked. This can be updated by an integration extension or manually.

### Epic/Story Boundary Principles

Apply these when deciding where one Epic/Story ends and the next begins:

- **Vertical slice, not horizontal layer** — a Story covers a complete capability end-to-end (e.g., "user authentication" with API + UI), not a technical layer in isolation (e.g., "auth API" and "auth UI" as separate Stories).
- **One complete user journey** — do not split a single user journey across two Stories unless one part genuinely blocks the other and is large enough to stand alone.
- **Independent demo-ability** — when a Story is complete, there must be something meaningful to show a stakeholder. Foundational work (auth, DB schema, CI/CD) is the exception.

### Epic/Story Scope Guide

> **Why no durations?** The time required to implement a Feature or Story varies dramatically depending on whether an AI agent or a human team does the work — an AI may complete a Feature in hours while a human team takes days. Because this blueprint is consumed by both AI (`/speckit.specify` → `/speckit.implement`) and human teams (e.g., Jira), we size by **structural decomposition** (how many child units fit inside a parent) rather than calendar time. This keeps the model stable regardless of who implements it.

**Structural targets**

| Level | Guideline |
|-------|-----------|
| **Epic** | 2–5 Stories, grouped around a single coherent business goal |
| **Story** | 3–8 Features, one vertical slice that can be demoed independently |
| **Feature** | 1 `/speckit.specify` run, the smallest testable increment of its parent Story |

**Scope Red Flags — stop and reconsider:**

- Epic with only 1 Story, or mixing unrelated domains (e.g., payments + profiles) → split or reclassify
- Story with >8 Features, or spanning unrelated user journeys → too broad, split
- Story with <3 Features, or not demoable without another Story → too narrow, merge
- Feature that is a horizontal task (e.g., "write tests", "add DB index") rather than a user-observable increment → restructure

#### Context Modifiers

Read `vision.md` and interview answers before judging:

| Signal | Adjustment |
| --- | --- |
| Solo developer | Epic max **3** Stories; Story max **4** Features |
| Initial Epic/Story | Story max **4** Features — environment setup adds hidden work |
| External API / third-party integration | Story max **4** Features; Feature must include integration contract |
| Unfamiliar domain or tech stack | Story max **4** Features |
| Well-understood CRUD / business logic | Story up to **8** Features acceptable |