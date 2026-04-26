# Blueprint: [PROJECT NAME]

_Last updated: [DATE]_

<!-- Blueprint is the single master document for your project's delivery hierarchy.
     It contains all Epics, their Stories, and each Story's Features in one place.
      Use this as the draft for external tracking tool integration.

     Story directories are organized under their parent Epic:
       docs/blueprint/epics/<epic-slug>/<story-slug>/story.md

     This file is designed to be re-run when scope changes. Preserve existing History
     entries and append a new row for each update.

     Number Epics sequentially: EP-01, EP-02, ...
      Number Stories under each Epic: ST-1.1, ST-1.2, ST-2.1, ... (Epic number . Story sequence)
      Number Features under each Story: FT-1.1.1, FT-1.1.2, FT-1.2.1, ... (Epic . Story . Feature sequence) -->

---

## Epics

### EP-01 — [User-facing outcome]

<!-- ACTION REQUIRED: One sentence describing the user-facing outcome of this Epic.
     Bad: "Implement authentication"
     Good: "Users can register and log in securely" -->

- **Scope**: <!-- ACTION REQUIRED: What this Epic encompasses at an abstract level.
     Keep it high-level — detailed specs come later in /speckit.specify. -->
- **Out of Scope**: <!-- ACTION REQUIRED: What is explicitly NOT included in this Epic?
     Be specific. "No OAuth" is useful. "Nice-to-haves" is not. -->
- **Success Criteria**: <!-- ACTION REQUIRED: How do we know this Epic is done?
     Prefer measurable outcomes: "X% of users can do Y in under Z minutes". -->
- **External**: — <!-- Reserved for future tracker integration (Jira, Linear, etc.). Leave as — unless manually linking to an external ticket. -->

#### Stories

- **ST-1.1** — [User-facing outcome]
  - **Scope**: <!-- ACTION REQUIRED: What this Story encompasses — a feature area that may span multiple PRs -->
  - **Key AC**: <!-- ACTION REQUIRED: 1–2 lines of core acceptance criteria.
       This is the business-level "done" definition, not technical implementation details. -->
  - **External**: — <!-- Reserved for future tracker integration (Jira, Linear, etc.). Leave as — unless manually linking to an external ticket. -->
  - **Features**:
    - FT-1.1.1 — <!-- ACTION REQUIRED: Summary of the spec-sized unit. Each FT = one /speckit.specify run. -->
    - FT-1.1.2 — [Summary]

- **ST-1.2** — [User-facing outcome]
  - **Scope**: [What this Story encompasses]
  - **Key AC**: [1–2 lines of core acceptance criteria]
  - **External**: — <!-- Reserved for future tracker integration (Jira, Linear, etc.). Leave as — unless manually linking to an external ticket. -->
  - **Features**:
    - FT-1.2.1 — [Summary]

### EP-02 — [User-facing outcome]

- **Scope**: [What this Epic encompasses at an abstract level]
- **Out of Scope**: [What is explicitly NOT included]
- **Success Criteria**: [How we know this Epic is done]
- **External**: — <!-- Reserved for future tracker integration (Jira, Linear, etc.). Leave as — unless manually linking to an external ticket. -->

#### Stories

- **ST-2.1** — [User-facing outcome]
  - **Scope**: [What this Story encompasses]
  - **Key AC**: [1–2 lines of core acceptance criteria]
  - **External**: — <!-- Reserved for future tracker integration (Jira, Linear, etc.). Leave as — unless manually linking to an external ticket. -->
  - **Features**:
    - FT-2.1.1 — [Summary]

<!-- Add more Epics as needed. -->

---

## History

| Timestamp | Subject | Note |
| --- | --- | --- |
| [YYYY-MM-DD HH:MM] | blueprint.md | Created from vision.md |
