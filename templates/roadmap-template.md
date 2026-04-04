# Roadmap: [PROJECT NAME]

## Spec Outlines

<!-- ACTION REQUIRED: One Spec Outline per /speckit.specify run.
     Number sequentially: SO-01, SO-02, SO-03, ...

     Status markers:
       [📋] Planned — default, not yet specified
       [🚧] In Progress — set by _roadmap-check when /speckit.specify starts; also set by _roadmap-sync for partial coverage
       [✅] Complete — after _roadmap-sync confirms completion
       [⏸️] Deferred — scope confirmed but execution postponed to a later roadmap
       [❌] Excluded — formally removed from the roadmap scope

     Summary: one sentence, user-facing. Bad: "Implement auth". Good: "Users can sign up and log in."
     Scope: free-form description of what this Spec Outline encompasses. Keep abstract — phase
       breakdown (P1/P2/P3) is determined later during /speckit.specify through a requirements interview.
     Deps: Spec Outline IDs this depends on, or — if none.
     Spec: spec file path once specified, or — until then. -->

- [📋] **SO-01** — [User-facing goal]
  - Scope: [What this Spec Outline encompasses, written at an abstract level. e.g. "Sign-up flow, login/logout, password reset, and session management."]
  - Deps: —
  - Spec: —

- [📋] **SO-02** — [User-facing goal]
  - Scope: [What this Spec Outline encompasses, written at an abstract level. e.g. "User profile page, avatar upload, notification preferences, and account deletion."]
  - Deps: SO-01
  - Spec: —

<!-- Add more Spec Outlines as needed. -->

---

## Execution Order

### Sequence (must be done in order)

<!-- ACTION REQUIRED: List only the critical path — Spec Outlines that must run serially. -->
SO-01 → SO-02 → ...

### Parallel Groups

<!-- Remove this section entirely if all Spec Outlines are sequential.
     Include only groups that can genuinely run concurrently.
     "Can start after" must name a specific Spec Outline ID. -->
| Group | Spec Outlines | Can start after |
| --- | --- | --- |
| A | SO-03, SO-05 | SO-01 complete |

---

## Summary

<!-- ACTION REQUIRED: Fill in after all Spec Outlines are confirmed. -->
- Total Spec Outlines: [N]
- Critical path: SO-01 → SO-02 → ...

---

## History

[YYYY-MM-DD HH:MM] | Initial roadmap created from vision.md
