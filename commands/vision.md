---
description: "Define project vision through an adaptive interview."
---

# Blueprint Vision

Define the project vision through an adaptive interview.

## Purpose

Establish the foundation before writing any spec:
- **What** you're building and **why**
- **Who** it's for
- **What's in scope** and explicitly what's not

The output feeds into `/speckit.blueprint.roadmap`.

## User Input

$ARGUMENTS

If `$ARGUMENTS` is provided, use it as the initial project description and skip to Round 2 of the interview after confirming the basics.

## Hooks

Before starting, check `.specify/extensions.yml` for any handlers registered under `before_blueprint_vision` and execute them in order.

After saving `docs/blueprint/vision.md`, check `.specify/extensions.yml` for any handlers registered under `after_blueprint_vision` and execute them in order.

## Instructions

### Step 0: Constitution Check

Check if `.specify/memory/constitution.md` exists.

**If it does not exist**, warn the user:

> "⚠️ No constitution found. SpecKit's `constitution` defines your project's coding standards and conventions — it should be set up before planning begins.
>
> Run `/speckit.constitution` first, then come back to Blueprint.
>
> Proceed anyway without a constitution? (yes / no)"

- If **no**: stop here.
- If **yes**: continue, and note at the end that constitution setup is still pending.

---

### Step 1: Check Existing Vision

Check if `docs/blueprint/vision.md` exists.

**If it exists:**
1. Read and summarize the existing vision (project name, problem, core features, current stage)
2. Ask: "Your existing vision is summarized above. What would you like to do?
   - (1) Update specific sections
   - (2) Start over
   - (3) Cancel"
3. Proceed based on user choice. For option (1), ask which sections to update, then apply changes and re-confirm.
4. If vision changes, ask: "Your vision has changed. Should I update the roadmap to reflect this?" If yes, suggest running `/speckit.blueprint.roadmap`.

**If it does not exist:**
Proceed to Step 2.

---

### Step 2: Adaptive Interview

Conduct a conversational interview in **3 rounds**. Do not present all questions at once — ask, listen, then adapt the next question based on the answer.

#### Round 1 — Core Understanding (always ask these)

1. "What problem are you solving? Describe it in one or two sentences."
2. "Who are the primary users? Be specific — not just 'developers' but what kind, what context."
3. "What are the 3 most important things the product must do? (Core features, not nice-to-haves)"

After Round 1, briefly reflect back what you heard and ask: "Is that a fair summary so far?"

#### Round 2 — Scope & Constraints (adapt based on Round 1)

4. "What is explicitly OUT of scope for the initial version? What are you intentionally deferring?"
5. "Are there any hard technical constraints? (existing stack, hosting environment, must-use libraries, etc.)"
6. "What are the non-functional requirements? Think about: performance targets, security requirements, accessibility, offline support, etc."

If the user says "I don't know" or "not sure" for any answer — record it as `TBD` and move on. Do not block progress.

#### Round 3 — Execution Context (adapt based on rounds 1-2)

7. "Is this a new project or an existing codebase?"
8. "What's the team size and rough sprint cadence? (e.g., 3 devs, 2-week sprints)"
9. "What's the target timeline for a first working version?"

---

### Step 3: Generate vision.md Draft

Using the interview answers, create a draft `docs/blueprint/vision.md` following this structure:

```markdown
# Vision: [Project Name]

## Problem Statement
[What problem this solves and why it matters]

## Target Users
[Specific user personas and their context]

## Core Features
[The 3-5 must-have features, described from the user's perspective]

## Technical Context
[Stack constraints, hosting, existing systems to integrate with]

## Non-Functional Requirements
[Performance, security, accessibility, scalability targets]

## Out of Scope
[Explicitly what this project will NOT do — be specific]

## Success Criteria
[How we know this project succeeded — measurable outcomes]

## Execution Context
- Team size: [N]
- Sprint cadence: [N weeks]
- Target first release: [timeline or TBD]
```

Show the draft to the user and ask:
"Here's the vision draft. Does this capture what you're building? What's missing or incorrect?"

Incorporate feedback. Repeat until the user confirms: "Yes, this is correct."

Save to `docs/blueprint/vision.md`.

---

### Step 4: Completion

Confirm the file is saved:
- `docs/blueprint/vision.md` ✓

Tell the user:
"Vision defined. Next step: run `/speckit.blueprint.roadmap` to create a staged delivery plan."

## Output Files

| File | Purpose |
|------|---------|
| `docs/blueprint/vision.md` | Project vision — foundation for all downstream work |
