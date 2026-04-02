# Roadmap: [PROJECT NAME]

_Last updated: [DATE]_

---

## Stage 1: [STAGE NAME]

<!-- ACTION REQUIRED: One sentence — what does this stage deliver as a user-observable increment?
     Bad: "Set up the backend". Good: "Users can register and log in with email/password." -->
**Goal:** [What this stage delivers]

<!-- ACTION REQUIRED: List prior stage names this depends on, or write "None". -->
**Dependencies:** [Prior stages or None]

<!-- ACTION REQUIRED: 2–4 verifiable, binary criteria. Each must be testable as pass/fail.
     Bad: "System feels fast". Good: "Login completes in under 2 seconds on a standard connection." -->
**Acceptance Criteria:**
- [ ] [Verifiable criterion]
- [ ] [Verifiable criterion]

<!-- ACTION REQUIRED: Exactly one Spec Outline per stage — no exceptions.
     If this stage needs two Spec Outlines, split it into two stages instead.

     Status markers:
       [📋] Planned — default, not yet specified
       [🚧] In Progress — after /speckit.specify starts
       [✅] Complete — after _roadmap-sync confirms completion

     Goal: one sentence, user-facing. Bad: "Implement auth". Good: "Users can sign up and log in."
     Objectives: 1–3 only. Phrase as outcomes ("Users can X"), not tasks ("Implement X").
       Each objective becomes a P1/P2/P3 section in spec.md.
     Size: sprint estimate, e.g. ~2. Do not write ranges.
     Deps: Spec Outline IDs this depends on, or — if none.
     Spec: spec file path once specified, or — until then. -->
**Spec Outline:**
- [📋] **Spec Outline 001** [User-facing goal]
  - Objectives: [objective 1], [objective 2]
  - Size: ~N sprints
  - Deps: —
  - Spec: —

**Status:** 📋 Planned <!-- 🚧 In Progress after first Spec Outline starts; ✅ Complete after all Spec Outlines done -->

---

## Stage 2: [STAGE NAME]

<!-- See Stage 1 comments above for full field guidance. -->
**Goal:** [What this stage delivers]

**Dependencies:** Stage 1

**Acceptance Criteria:**
- [ ] [Verifiable criterion]

**Spec Outline:**
- [📋] **Spec Outline 002** [User-facing goal]
  - Objectives: [objective 1], [objective 2]
  - Size: ~N sprints
  - Deps: Spec Outline 001
  - Spec: —

**Status:** 📋 Planned <!-- 🚧 In Progress after first Spec Outline starts; ✅ Complete after all Spec Outlines done -->

---

<!-- Repeat the Stage block above for each additional stage. -->

---

## Execution Order

### Sequence (must be done in order)

<!-- ACTION REQUIRED: List only the critical path — Spec Outlines that must run serially. -->
Spec Outline 001 → Spec Outline 002 → ...

### Parallel Groups

<!-- Remove this section entirely if all Spec Outlines are sequential.
     Include only groups that can genuinely run concurrently.
     "Can start after" must name a specific Spec Outline, not a stage name. -->
| Group | Spec Outlines | Can start after |
| --- | --- | --- |
| A | Spec Outline 003, Spec Outline 005 | Spec Outline 001 complete |

---

## Summary

<!-- ACTION REQUIRED: Fill in after all stages are confirmed. -->
- Total Spec Outlines: [N]
- Estimated total: [N sprints]
- Critical path: Spec Outline 001 → Spec Outline 002 → ...
