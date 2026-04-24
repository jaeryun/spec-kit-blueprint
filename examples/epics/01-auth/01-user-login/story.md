# ST-01 — Users can register and log in with email/password

> Source of Truth. Last updated: 2026-04-23
> Jira: —

<!-- Related artifacts in this directory:
     - data-model.md
     - contracts/auth-api.md
-->

---

## Overview

Users can create an account with their email and password, log in to access the platform, and reset their password if forgotten. Sessions are managed server-side with sliding expiry.

## Current State

- **FT-01 (Done)**: Email/password registration with email verification implemented.
- **FT-02 (Done)**: Server-side session management (Redis) and logout implemented.
- **FT-03 (To Do)**: Password reset flow pending.

## Tech Context

- **Language**: Node.js 20+
- **Key dependencies**: bcrypt >=5.1.0, jsonwebtoken >=9.0.0, nodemailer >=6.9.0
- **Architecture**: Session tokens stored server-side in Redis. Passwords hashed with bcrypt (cost factor 12). Email verification and password reset use signed short-lived JWTs.

## Non-Goals

- OAuth / social login (Google, GitHub) — deferred to ST-03
- Multi-factor authentication — not in scope for this Epic
- Session management UI (active sessions list, remote logout) — not in scope

## NFR

- Password hashing: bcrypt cost factor 12 minimum
- Session expiry: 30 minutes sliding
- Password reset link expiry: 1 hour

## ADR

| Decision | Reason | FT |
| --- | --- | --- |
| Server-side sessions in Redis (not JWT stateless) | Enables immediate session invalidation on logout — stateless JWT cannot be revoked without a blocklist | FT-01 |
| bcrypt cost factor 12 | Balances security (brute-force resistance) with login latency (<300ms on target hardware) — tested at FT-02 | FT-02 |
