# Roadmap: [PROJECT NAME]

_Last updated: [DATE]_

---

## Spec Outlines

<!-- ACTION REQUIRED: One Spec Outline per Epic. Each maps to one /speckit.specify run.
     Number sequentially: 001, 002, 003, ...

     Status markers:
       [📋] Planned — default, not yet specified
       [🚧] In Progress — set by _roadmap-check when /speckit.specify starts; also set by _roadmap-sync for partial coverage
       [✅] Complete — after _roadmap-sync confirms completion

     Summary: one sentence, user-facing. Bad: "Implement auth". Good: "Users can sign up and log in."
     Scope: free-form description of what this Epic encompasses. Keep abstract — phase breakdown
       (P1/P2/P3) is determined later during /speckit.specify through a requirements interview.
     Size: sprint estimate, e.g. ~2. Do not write ranges.
     Deps: Spec Outline IDs this depends on, or — if none.
     Spec: spec file path once specified, or — until then. -->

- [📋] **Spec Outline 001** — [User-facing goal]
  - Scope: [What this Epic encompasses, written at an abstract level. e.g. "Sign-up flow, login/logout, password reset, and session management."]
  - Size: ~N sprints
  - Deps: —
  - Spec: —

- [📋] **Spec Outline 002** — [User-facing goal]
  - Scope: [What this Epic encompasses, written at an abstract level. e.g. "User profile page, avatar upload, notification preferences, and account deletion."]
  - Size: ~N sprints
  - Deps: Spec Outline 001
  - Spec: —

<!-- Add more Spec Outlines as needed. -->

---

## Execution Order

### Sequence (must be done in order)

<!-- ACTION REQUIRED: List only the critical path — Spec Outlines that must run serially. -->
Spec Outline 001 → Spec Outline 002 → ...

### Parallel Groups

<!-- Remove this section entirely if all Spec Outlines are sequential.
     Include only groups that can genuinely run concurrently.
     "Can start after" must name a specific Spec Outline ID. -->
| Group | Spec Outlines | Can start after |
| --- | --- | --- |
| A | Spec Outline 003, Spec Outline 005 | Spec Outline 001 complete |

---

## Summary

<!-- ACTION REQUIRED: Fill in after all Spec Outlines are confirmed. -->
- Total Spec Outlines: [N]
- Estimated total: [N sprints]
- Critical path: Spec Outline 001 → Spec Outline 002 → ...

---

## History

| Timestamp | Subject | Note |
| --- | --- | --- |
| [YYYY-MM-DD HH:MM] | roadmap.md | Created |
