---
description: "Generate a delivery roadmap of Spec Outlines from the confirmed vision."
---

# Blueprint Roadmap

Generate a delivery roadmap of Spec Outlines from the confirmed vision.

## Purpose

Defining specs one at a time — without a shared view of the whole project — leads to specs that are too large or too small. There's no basis for calibrating scope when each spec is written in isolation.

This command addresses that by building the full roadmap before any spec is written. Through a user interview, it surfaces all work at the Spec Outline level, calibrates each scope as a set — weighing priority and parallelism — and determines the execution order. The output is a roadmap of right-sized Spec Outlines in execution order — each one the input to a single `/speckit.specify` run.

## What is a Spec Outline

A **Spec Outline** is the planning blueprint for one `/speckit.specify` run. The spec it produces covers work comparable to a Jira Epic — a cohesive, independently deliverable unit of work. It is defined at roadmap time — before detailed requirements are known — using only two components:

| Component | Description |
| --- | --- |
| **Summary** | One sentence describing what this Spec Outline delivers, from the user's perspective |
| **Scope** | Free-form description of what this Spec Outline encompasses — written at an abstract level based on vision analysis and user interview |

```
Spec Outline (roadmap.md) — planning time, abstract
    ├─ Summary: "Users can register and log in with email/password."
    └─ Scope: "Sign-up flow, login/logout, password reset, session management."
```

Key implications for generation:
- Each Spec Outline = one `/speckit.specify` run.
- **Scope is calibrated as a set** — sizes are adjusted relative to each other across the whole roadmap, factoring in priority and team capacity.
- **Scope is intentionally abstract** — the exact phase breakdown (P1/P2/P3) is determined during `/speckit.specify` through a detailed requirements interview. Scope items written here may be decomposed into multiple phases, merged, or reframed during that interview.

## User Input

$ARGUMENTS

If provided, interpret `$ARGUMENTS` as user intent and apply it during generation.

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_roadmap` and execute them in order.

After saving `docs/blueprint/roadmap.md`, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_roadmap` and execute them in order.

## Instructions

### Step 0: Prerequisites Check

Check that `docs/blueprint/vision.md` exists.

If missing, stop and output: "Run `/speckit.blueprint.vision` first."

---

### Step 1: Check Existing Roadmap

If `docs/blueprint/roadmap.md` does not exist, proceed to Step 2.

If it exists, summarize it (Spec Outline count, IDs, linked specs) and ask:

"What would you like to do?
  (1) Update — re-analyze specific Spec Outlines
  (2) Regenerate — start from scratch
  (3) Clear a Spec Outline's spec link (reset Spec: to —)
  (4) Cancel"

- **(1)** Identify targets from `$ARGUMENTS` or user reply. For Spec Outlines with a linked spec (Spec: field is not —), warn: "A spec file is already linked to this Spec Outline. Proceed with the scope update anyway? (yes / no)" — skip if no, include if yes. Proceed to Step 2 for confirmed targets only.
- **(2)** Proceed to Step 2 for all Spec Outlines.
- **(3)** Ask which Spec Outline to clear. Confirm with the user, then set `Spec:` to `—`, append a reset row to History, and save.
- **(4)** Stop.

---

### Step 2: Interview & Initial Draft

Read `docs/blueprint/vision.md`. Pay special attention to sprint cadence, team size, core features, and out-of-scope items.

Begin with an introduction:

> **Starting Blueprint Roadmap Interview**
>
> This conversation builds a **delivery roadmap** from your vision. We'll define Spec Outlines (think: Jira Epic-sized units of work) and their execution order.
>
> **We cover:**
> - Work not explicitly captured in vision.md
> - External integrations and foundational requirements
> - MVP vs. deferrable scope
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
   
   If detected: "Those details belong in `/speckit.specify`. For now, let's focus on what this Spec Outline delivers from the user's perspective. [Rephrase question focusing on outcomes only]"

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

Using vision.md + interview answers, draft an initial set of Spec Outlines. Apply the **Spec Outline Boundary Principles** and **Scope Guide** when deciding scope boundaries and sizing. Do not present the draft yet — proceed to Step 3.

---

### Step 3: Validate & Calibrate

Present the full initial draft to the user. Then validate across all three dimensions and include findings in the same response:

- **Vision alignment** — does any scope contradict core features, out-of-scope items, target users, or NFRs in vision.md? **Strict adherence is mandatory.** If the user wants to introduce goals outside the current vision, they must stop and run `/speckit.blueprint.vision` first to update the core project definition.
- **Scope sizing** — is any Spec Outline too broad or too narrow? (See Scope Guide)
- **Scope placement** — is each scope item in the right Spec Outline? Flag anything that would fit better elsewhere or that logically belongs with another Spec Outline.

If issues are found, propose specific adjustments alongside the draft. Ask: "Does this look correct? Any changes?"

Incorporate feedback and repeat until the user confirms.

---

### Step 4: Write Output File

Load `templates/roadmap-template.md` to understand the required sections.

Fill each Spec Outline with the confirmed output from Steps 2 and 3, following the **For AI Generation** guidelines at the end of this file.

If `docs/blueprint/roadmap.md` does not yet exist, include the initial history entry from the template. If it already exists, preserve all existing history entries and append a new line: `[TIMESTAMP] | [Summary]`.

Keep summaries concise (one line) and descriptive of the specific action taken (e.g., "Full regeneration from vision.md", "SO-02 updated to include API requirements", "SO-01 spec link cleared").

Save to `docs/blueprint/roadmap.md`.

---

### Step 5: Completion

Confirm the file is saved:

- `docs/blueprint/roadmap.md` ✓

Output:

```text
Roadmap complete. [N] Spec Outlines defined.

Next: /speckit.specify [first Spec Outline with no linked spec — use its ID and goal]
```

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/roadmap.md` | Delivery plan with Spec Outlines |

---

## For AI Generation

When filling `templates/roadmap-template.md`:

### Spec Outline Field Rules

**Summary** — User-facing, one sentence. Bad: "Implement authentication". Good: "Users can register and log in with email/password."

**Scope** — Free-form prose. Write what this Spec Outline covers at an abstract level — not how it will be built, not how many phases it will have. Phase breakdown happens during `/speckit.specify`.

**Spec** — Write `—` until the spec file exists. Linked automatically by `roadmap-sync` after `/speckit.specify`, or run `/speckit.blueprint.roadmap-sync` directly to sync all unlinked specs at once.

### Spec Outline Boundary Principles

Apply these when deciding where one Spec Outline ends and the next begins:

- **Vertical slice, not horizontal layer** — one Spec Outline covers a complete capability end-to-end (e.g., "user authentication" including both API and UI), not a technical layer in isolation (e.g., "auth API" and "auth UI" as separate Spec Outlines). Horizontal cuts produce Spec Outlines that cannot be demoed or shipped independently.
- **One complete user journey** — do not split a single user journey across two Spec Outlines unless one part genuinely blocks the other and is large enough to stand alone. A user who can't complete the flow after this Spec Outline ships gets no value.
- **Independent demo-ability** — when a Spec Outline is complete, there must be something meaningful to show a stakeholder. If completing it requires another Spec Outline to be useful, reconsider the boundary.
- **Foundational work is the exception** — auth, DB schema, core infrastructure, and CI/CD setup are legitimately separate even if they don't deliver user-visible value alone, because everything downstream depends on them.

### Spec Outline Scope Guide

**Target size: Jira Epic-level** — the standard unit of work that fits in a software development roadmap.

| Dimension | Guideline |
|-----------|-----------|
| **Duration** | 1–3 months from start to delivery |
| **Team** | 1–2 people owning the work |
| **Decomposition** | Decomposable into 5–15 subtasks |

The goal is ensuring each Spec Outline is scoped appropriately: not too broad to manage in a single `/speckit.specify` run, and not so narrow it doesn't warrant its own spec.

**Too broad — consider splitting if:**

- Estimated duration exceeds 3 months
- Scope spans unrelated domains (e.g., payment processing + user profiles in one Spec Outline)
- Scope contains multiple independent user journeys that don't need each other
- Part of the scope clearly blocks the rest and is substantial enough to stand alone

**Too narrow — consider merging if:**

- Estimated duration is under 1 month
- Scope is a trivial capability that doesn't stand alone as a deliverable
- Completing this Spec Outline requires another one to be useful (and they're not a dependency — they're just incomplete without each other)

**Context signals to weigh when assessing scope balance:**

Read `vision.md` and interview answers before judging:

| Signal | What it means for scope |
| --- | --- |
| Solo developer | Err toward narrower scopes — less parallelism available |
| First Spec Outline | Keep scope tighter — environment setup adds hidden work |
| External API / third-party integration | Each integration adds uncertainty; factor in when judging breadth |
| Unfamiliar domain or tech stack | Narrower scope reduces risk of underestimating |
| Well-understood CRUD / business logic | Broader scope acceptable |
