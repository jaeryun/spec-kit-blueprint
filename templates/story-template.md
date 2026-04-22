# ST-[NN] — [Story Title]

<!-- story.md is the technical Source of Truth for this Story.
     It is NOT a union of FT spec files. It describes the CURRENT STATE
     of the feature — updated (not accumulated) with each merged FT.

     story.md manages its direct children (Features) only.
     Jira Story item manages: FT list, status, assignee, sprint, comments.

     Update triggers: when a merged FT changes behavior, interface,
     data model, or architecture decisions. If a FT changes nothing
     in these areas, story.md does not need to be updated. -->

> Source of Truth. Last updated by: — (no FT merged yet)
> Jira: —

---

## Overview

<!-- 2–3 sentences. What this feature is and why it exists.
     Written from the user's perspective, not the implementation's. -->
[What this feature does and why it exists]

## Current State

<!-- What the feature currently does, in plain language.
     Update this section with each merged FT to reflect real behavior.
     Do NOT copy acceptance criteria from FT spec files — synthesize current behavior. -->
[How the feature currently behaves — updated after each FT merge]

## Tech Context

<!-- Language, key dependencies, and core architectural structure.
     Include version constraints that matter (e.g., fastmcp >=2.14.4). -->

- **Language**: [e.g., Python 3.11+]
- **Key dependencies**: [e.g., fastmcp >=2.14.4, asyncssh >=2.22.0]
- **Architecture**: [1–2 sentences on the core structural approach]

## Non-Goals

<!-- What this Story intentionally does NOT do.
     Each item must be concrete enough that a developer would know
     if they were accidentally implementing it.
     Examples:
       - "Arbitrary shell command execution — read-only diagnostics only"
       - "Real LDAP/OTP auth — mock auth only until ST-03 completes" -->
- [Explicitly what this Story will NOT do — be specific]

## NFR

<!-- Current agreed non-functional requirements.
     If none, write "No specific NFRs identified."
     Update when FTs establish measured baselines (e.g., after performance test FT). -->
[Performance, security, availability targets — only what's been confirmed]

## ADR

<!-- Architecture Decision Records: WHY key decisions were made.
     This is the most important section for future FT authors.
     Add a row for each non-obvious architectural choice. -->

| Decision | Reason | FT |
| --- | --- | --- |
| [Decision made] | [Why — include constraints that forced the choice] | FT-[NN] |
