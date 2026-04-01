# Design: Blueprint Output Templates

**Date**: 2026-04-01
**Status**: Approved

## Problem

Output formats for `vision.md` and `roadmap.md` are embedded inline inside command files as fenced code blocks. This mixes two concerns in the same file: *how to run the command* and *what the output looks like*. When the format needs to change, editors must hunt through command prose to find the right block.

## Goal

Separate output format (template) from authoring guidance (command), following the pattern established by SpecKit's `.specify/templates/spec-template.md`.

## Scope

**In scope:**
- Extract `vision.md` output format → `templates/vision-template.md`
- Extract `roadmap.md` output format → `templates/roadmap-template.md`
- Update `commands/vision.md` Step 3 to load the template and apply "For AI Generation" guidelines
- Update `commands/roadmap.md` Step 5 to load the template and apply "For AI Generation" guidelines

**Out of scope:**
- Hook commands (`_roadmap-check`, `_roadmap-sync`) — they do not produce new files
- Any changes to extension.yml or README

## Architecture

```
templates/
├── vision-template.md     ← pure output format
└── roadmap-template.md    ← pure output format

commands/
├── vision.md              ← updated: load template + "For AI Generation" section
└── roadmap.md             ← updated: load template + "For AI Generation" section
```

## Template File Convention

Follows SpecKit's `spec-template.md` style:

- Placeholders use `[Title Case]` bracket notation
- HTML comments `<!-- -->` provide AI authoring guidance per section
- Comments begin with `ACTION REQUIRED:` when the AI must fill content, or describe constraints/scope rules

Example:

```markdown
## Problem Statement

<!-- ACTION REQUIRED: 1–2 sentences. What problem this solves and why it matters.
     Do NOT include solution details, technology choices, or delivery stages. -->
[What problem this solves and why it matters]
```

## Command File Changes

### commands/vision.md — Step 3

Replace the inline template block with:

```
Load `templates/vision-template.md` to understand the required sections and fill
each section following the "For AI Generation" guidelines below.
```

Add a **"For AI Generation"** section after Step 3 (before Step 4) consolidating the existing Scope Boundary rules into actionable writing guidance:

- What belongs in each section (restate scope boundary as per-section rules)
- What to mark `TBD` vs what to infer
- Scope violation signals (delivery stages, tech choices → remove from vision)

### commands/roadmap.md — Step 5

Replace the inline template block with:

```
Load `templates/roadmap-template.md` to understand the required sections and fill
each stage using the "For AI Generation" guidelines below.
```

Add a **"For AI Generation"** section consolidating:

- Stage sizing rules (one Spec Outline per stage, 2–4+ sprints)
- Spec Outline field rules (1–3 objectives, user-facing language, outcome-oriented)
- Status marker meanings (`[📋]` / `[🚧]` / `[✅]`)
- Dependency and parallel group formatting rules

## Files Changed

| File | Change |
|------|--------|
| `templates/vision-template.md` | **New** — vision.md output format |
| `templates/roadmap-template.md` | **New** — roadmap.md output format |
| `commands/vision.md` | **Updated** — Step 3: template reference + "For AI Generation" section |
| `commands/roadmap.md` | **Updated** — Step 5: template reference + "For AI Generation" section |
