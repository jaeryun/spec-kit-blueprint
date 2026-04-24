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

**Belongs here:** problem statement, target users, core features, non-functional requirements, out-of-scope items, success criteria, team/timeline context, existing stack and integrations.

**Does NOT belong here:** delivery stages or phases, Story/Feature breakdowns, sprint assignments, specific technology choices, implementation approaches, API or data model design. If any of these appear in your draft, move them to roadmap or remove them.

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

1. Read and summarize the existing vision (project name, problem, core features, current state)
2. Ask: "Your existing vision is summarized above. What would you like to do?
   - (1) Update specific sections
   - (2) Start over
   - (3) Cancel"
3. Proceed based on user choice. For option (1), ask which sections to update. For each section, accept the user's freeform input describing the desired change, apply it to the draft, and show the revised section for confirmation before saving.
4. If vision changes, ask: "Your vision has changed. Should I update the roadmap to reflect this?" If yes, suggest running `/speckit.blueprint.roadmap`.

**If it does not exist:**
Proceed to Step 2.

---

### Step 2: Adaptive Interview

Begin the interview with an introduction that explains what will happen:

> **Starting Blueprint Vision Interview**
>
> This conversation defines the **essence of your project (What & Why)**. Technical choices and implementation plans (How & When) come in later steps.
>
> **We'll cover 8 areas** in order:
>
> - **Overview** — What you're building and why it matters
> - **Goals** — What success looks like
> - **Users** — Who will use this and their context
> - **Features** — Core capabilities users need
> - **Out of Scope** — What you're **intentionally** excluding
> - **Constraints** — Technical/business/timeline boundaries
> - **Technical Context** — Existing stack, hosting, and integrations
> - **NFRs & Success** — Quality standards and measurable outcomes
>
> I'll ask one question at a time, skipping areas you've already covered. If you're unsure about something, simply say "I don't know" and I'll mark it as `TBD` and move on.

Then conduct the conversational interview covering the areas below. Ask **one question at a time**, adapt follow-ups based on answers, and skip areas already covered.

| Area | Intent | Template Section | Guidance |
| --- | --- | --- | --- |
| **Overview** | What is being built and why | Project Overview | Start with open-ended questions. Adjust depth based on user response. Example: "What are you building?" → "Why does this matter?" → "What led to this?" |
| **Goals** | What success looks like | Goals & Objectives | Focus on outcomes, not features. Probe for business value. Example: "What are you trying to achieve?" → "What would make this successful?" |
| **Users** | Who it's for and their context | Target Users | Get specific. Avoid generic roles. Example: "Who will use this?" → "What are they trying to do?" → "What frustrates them today?" |
| **Features** | What capabilities it must provide | Core Features | Ask from user perspective. Example: "What should users be able to do?" → "Which 3–5 are most important?" |
| **Out of Scope** | What is explicitly excluded | Out of Scope | Be concrete. Example: "What are you intentionally NOT building?" → "Are there features commonly assumed but excluded?" |
| **Constraints** | Technical, business, timeline, and architectural boundaries | Constraints | Hard limits shaping the solution. Example: "What constraints exist?" → "Technical? Business? Timeline?" → "Any architectural preferences? (cloud-native, etc.)" |
| **Technical Context** | Existing systems, hosting environment, and integrations to consider | Technical Context | Context, not constraints — what exists, not what limits. Example: "What does your current stack look like?" → "Any existing systems or services this needs to integrate with?" → "Where will this be hosted?" |
| **NFRs** | Quality attributes | Non-Functional Requirements | Focus on needs over targets. Example: "What quality aspects matter? (speed, security, scale)" → "Any specific requirements?" |
| **Success** | How to measure success | Success Criteria | Push for measurability. Example: "How will you know this worked?" → "Any metrics in mind?" |

**Interview Rules (Strict):**

1. **ONE question at a time** — Never ask multiple questions in one turn. After each user response, provide feedback before asking the next question.

2. **Immediate scope guard** — After receiving each answer, check for content that belongs elsewhere:
   - Technology choices ("We'll use React", "PostgreSQL"), implementation methods, architecture decisions → belongs in roadmap/spec
   - Delivery phases, milestones, sprint plans → belongs in roadmap
   - Detailed API design, data models, UI mockups → belongs in spec

   If detected: "That detail belongs in [roadmap/spec]. We'll cover How & When later. For now, let's focus on What & Why — [rephrase original question focusing on essence only]"

3. **Confirm and get approval** — After each valid answer:
   - Summarize what was understood: "**[Area]**: [1-2 sentence summary]"
   - Ask for confirmation: "Is this correct? (yes / no / add more)"
   - Wait for explicit approval before proceeding to the next area
   - If the user says "add more", prompt: "What else should I capture?"
   - If the user says "no", ask: "What would you like to change?"

4. **Single-threaded flow**:
   - Ask one question → Wait for answer → Provide scope feedback if needed → Confirm/get approval → Ask next question
   - Never stack questions like "What are you building? Who is it for? What's the timeline?"

5. **Skip answered areas** — If a previous response already covered an area, mark it complete and move to the next

6. **Handle "I don't know"** — Record as `TBD` and proceed to the next area

7. **Progress check** — After covering 4–6 areas, briefly reflect back and ask: "Is that a fair summary so far?"

---

### Step 3: Generate vision.md Draft

Load `templates/vision-template.md` to understand the required sections.

Fill each section with the interview answers, following the **Filling Rules** from the table above.

Include a `_Last updated: [date]_` line with today's date.

Show the draft to the user and ask:
"Here's the vision draft. Does this capture what you're building? What's missing or incorrect?"

Incorporate feedback. Repeat until the user confirms: "Yes, this is correct."

Save to `docs/blueprint/vision.md`.

**History:** If the file did not yet exist, the History section is already in the template with a `Created` entry — update the `[YYYY-MM-DD HH:MM]` placeholder with the current timestamp. If the file already existed, append a new row: `[YYYY-MM-DD HH:MM] | vision.md | Updated`.

---

### Step 4: Scope Check

Before confirming completion, review the saved `docs/blueprint/vision.md` against the Scope Boundary defined above.

Flag any content that does not belong at the vision level:

- Delivery stages, phases, or timelines broken into milestones → belongs in roadmap
- Story/Feature breakdowns → belongs in blueprint.md
- Specific technology or architecture decisions → belongs in roadmap or spec
- Sprint assignments or task lists → belongs in roadmap or spec

For each violation found, output:

```text
⚠️ Scope issue in vision.md: "[excerpt]"
This level of detail belongs in [roadmap / spec]. Remove it from vision.md or move it to the appropriate file (`blueprint.md` or `spec.md`).
```

Ask the user: "Found [N] scope issue(s) above. Fix before proceeding? (yes / no / skip)"

- **yes** → apply fixes and re-confirm the file
- **no / skip** → proceed as-is, note issues remain

If no violations found → output: "✅ Scope check passed."

---

### Step 5: Roadmap Alignment Check (re-run only)

> This step only applies when vision is being **updated** and a roadmap already exists. On first run, skip this step.

Check if `docs/blueprint/blueprint.md` exists. If it does not exist, skip this step.

Read `docs/blueprint/blueprint.md`. Check at a high level whether the existing Stories and Features are still consistent with the updated vision:

- Do any Story or Feature goals contradict the updated Problem Statement or Core Features?
- Does the roadmap include work that vision now explicitly marks as Out of Scope?
- Does the roadmap omit any Core Feature that vision now considers essential?

If conflicts are found, output:

```text
⚠️ Vision change affects existing roadmap.

[For each conflict:]
ST-[NN] / FT-[NN] — [title]
Issue: [one-line description of the conflict]
```

Then output:

```text
The roadmap needs to be re-run to reflect the updated vision.
Run `/speckit.blueprint.roadmap` to regenerate or update affected Stories and Features.

Note: if any conflicting Story or Feature has already been specified or implemented,
those downstream steps (specify, plan, tasks, implement) may also need to be re-run
depending on the extent of the vision change.
```

If no conflicts found → output: "✅ Roadmap is consistent with updated vision."

---

### Step 6: Completion

Confirm the file is saved:

- `docs/blueprint/vision.md` ✓

Tell the user:
"Vision defined. Next step: run `/speckit.blueprint.roadmap` to create a delivery roadmap."

If Step 0 found no constitution and the user chose to proceed anyway, append this reminder:

```text
⚠️ Note: constitution setup is still pending. Run `/speckit.constitution` before writing specs to ensure coding standards are applied.
```

## Output Files

| File | Purpose |
| --- | --- |
| `docs/blueprint/vision.md` | Project vision — foundation for all downstream work |

---

## Reference: When to Mark TBD

Use `TBD` when the user said "I don't know" or the question was skipped. Never infer a value for team size, sprint cadence, or release target.

## Reference: Scope Signals — Remove Before Saving

If any of the following appear in the draft, move or remove them before saving:

| Found in draft | Where it belongs instead |
| --- | --- |
| Delivery phases, stages, or milestones | `blueprint.md` |
| Feature breakdowns or priority lists | `blueprint.md` |
| Specific technology or architecture choices | `blueprint.md` or `spec.md` |
| Sprint assignments, task lists, implementation steps | `blueprint.md` or `spec.md` |
