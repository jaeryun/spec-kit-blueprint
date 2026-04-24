# Blueprint: Simple SaaS App

_Last updated: 2026-04-24_

---

## Epics

### EP-01 — Users can register, log in, and manage their account securely

- **Scope**: Authentication core, user profile management, and account lifecycle.
- **Out of Scope**: OAuth/social login, multi-factor authentication, billing integration.
- **Success Criteria**: Users can complete sign-up and log in with <5% error rate. Session management handles 500 concurrent users without degradation.
- **Jira**: —

#### Stories

- **ST-01** — Users can register and log in with email/password.
  - **Scope**: Sign-up flow, login/logout, password reset, session management.
  - **Key AC**: Given a valid email and password, user can register and receive a verification email. Given valid credentials, user receives a session token valid for 30 minutes.
  - **Jira**: —
  - **Features**:
    - FT-01 — Email/password sign-up with verification
    - FT-02 — Session management and logout
    - FT-03 — Password reset flow

- **ST-02** — Users can manage their profile and account settings.
  - **Scope**: Profile page (name, avatar upload), notification preferences, account deletion.
  - **Key AC**: User can update profile info and upload avatar up to 2MB. User can permanently delete their account and all associated data.
  - **Jira**: —
  - **Features**:
    - FT-04 — Profile view and edit (name, avatar)
    - FT-05 — Notification preferences
    - FT-06 — Account deletion

### EP-02 — Admins can monitor platform usage and manage users

- **Scope**: Admin-facing analytics and user management capabilities.
- **Out of Scope**: Real-time analytics, data export, custom report builder.
- **Success Criteria**: Admin dashboard loads in under 2 seconds. Key metrics update within 5 minutes of data changes.
- **Jira**: —

#### Stories

- **ST-03** — Admins can view analytics dashboard.
  - **Scope**: Admin dashboard showing user count, activity summary, and key usage metrics.
  - **Key AC**: Given admin role, user can view total user count, daily active users, and sign-up trend over last 30 days.
  - **Jira**: —
  - **Features**:
    - FT-07 — Analytics data aggregation API
    - FT-08 — Admin dashboard UI

---

## History

| Timestamp | Subject | Note |
| --- | --- | --- |
| 2026-04-24 00:00 | blueprint.md | Created from vision.md |
