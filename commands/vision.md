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

## Scope Boundary

`vision.md` answers **what and why** — not how or when.

**Belongs here:** problem statement, target users, core features, non-functional requirements, out-of-scope items, success criteria, team/timeline context.

**Does NOT belong here:** delivery stages or phases, Spec Outline breakdowns, sprint assignments, specific technology choices, implementation approaches, API or data model design. If any of these appear in your draft, move them to roadmap or remove them.

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
3. "What are the 3~5 most important things the product must do? (Core features, not nice-to-haves)"

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

Load `templates/vision-template.md` to understand the required sections.

Fill each section with the interview answers, following the **For AI Generation** guidelines below.

Show the draft to the user and ask:
"Here's the vision draft. Does this capture what you're building? What's missing or incorrect?"

Incorporate feedback. Repeat until the user confirms: "Yes, this is correct."

Save to `docs/blueprint/vision.md`.

---

## For AI Generation

When filling `templates/vision-template.md`:

### Section Rules

**Problem Statement** — State the problem only. No solution hints, no technology, no delivery phases.

**Target Users** — Be specific. "Small e-commerce teams of 2–5 people running Shopify stores" beats "business users". Include their context.

**Core Features** — User-facing capabilities only. If the user listed more than 5, ask which 3–5 are non-negotiable.

**Technical Context** — Record only what the user stated. Do not infer a tech stack.

**Non-Functional Requirements** — If not mentioned, write "No specific NFRs identified." Do not invent targets.

**Out of Scope** — Be specific. "No mobile app" is useful; "out of scope for v1" is not.

**Success Criteria** — Prefer measurable outcomes. If the user gave none, propose 2–3 based on Core Features and confirm before saving.

**Execution Context** — Use `TBD` for any unknown value. Never estimate team size, sprint cadence, or release target.

### When to Mark TBD

Use `TBD` when the user said "I don't know" or the question was skipped. Never infer a value for team size, sprint cadence, or release target.

### Scope Signals — Remove Before Saving

If any of the following appear in the draft, move or remove them before saving:

| Found in draft | Where it belongs instead |
| --- | --- |
| Delivery phases, stages, or milestones | `roadmap.md` |
| Spec Outline breakdowns or feature priority lists | `roadmap.md` |
| Specific technology or architecture choices | `roadmap.md` or `spec.md` |
| Sprint assignments, task lists, implementation steps | `roadmap.md` or `spec.md` |

---

### Step 4: Scope Check

Before confirming completion, review the saved `docs/blueprint/vision.md` against the Scope Boundary defined above.

Flag any content that does not belong at the vision level:

- Delivery stages, phases, or timelines broken into milestones → belongs in roadmap
- Spec Outline or feature breakdowns → belongs in roadmap
- Specific technology or architecture decisions → belongs in roadmap or spec
- Sprint assignments or task lists → belongs in roadmap or spec

For each violation found, output:

```text
⚠️ Scope issue in vision.md: "[excerpt]"
This level of detail belongs in [roadmap / spec]. Remove it from vision.md or move it to the appropriate stage.
```

Ask the user: "Found [N] scope issue(s) above. Fix before proceeding? (yes / no / skip)"

- **yes** → apply fixes and re-confirm the file
- **no / skip** → proceed as-is, note issues remain

If no violations found → output: "✅ Scope check passed."

---

### Step 5: Roadmap Alignment Check

Check if `docs/blueprint/roadmap.md` exists. If it does not exist, skip this step.

Read `docs/blueprint/roadmap.md`. Compare each of the following against the updated `vision.md`:

- **Stage goals** — do any stage goals contradict or no longer reflect the updated Core Features or Problem Statement?
- **Spec Outline objectives** — do any objectives reference features that are now Out of Scope, or miss features newly added to Core Features?
- **Out of Scope alignment** — does the roadmap include anything that vision now explicitly marks as Out of Scope?
- **Target Users** — do any Spec Outline objectives serve a user segment no longer in the vision?

For each misalignment found, produce a specific proposed change:

```text
⚠️ Roadmap alignment issue found:

[For each issue:]
Location: Stage [N] / Spec Outline [NNN]
Current:  "[current text]"
Proposed: "[updated text]"
Reason:   "[one-line explanation based on vision change]"
```

If issues are found, ask: "Found [N] roadmap alignment issue(s) above. Apply these updates now? (yes / no)"

- **yes** → apply all proposed changes to `docs/blueprint/roadmap.md`, save, and output: "✅ roadmap.md updated to reflect vision changes."
- **no** → output: "ℹ️ roadmap.md not updated. Run `/speckit.blueprint.roadmap` when ready to re-align."

If no issues found → output: "✅ Roadmap is consistent with updated vision."

---

### Step 6: Completion

Confirm the file is saved:

- `docs/blueprint/vision.md` ✓

Tell the user:
"Vision defined. Next step: run `/speckit.blueprint.roadmap` to create a staged delivery plan."

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/vision.md` | Project vision — foundation for all downstream work |
