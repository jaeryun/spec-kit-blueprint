# Vision: Simple SaaS App

_Last updated: 2026-04-15_

---

## Overview

A simple SaaS web application for small teams. Users can sign up and log in with their email, manage their profiles, and administrators can monitor overall usage through an analytics dashboard.

## Problem Statement

Teams lack a unified entry point for user management and usage tracking, forcing administrators to aggregate usage data manually.

## Goals & Objectives

- Users can self-service create accounts and maintain their profiles.
- Administrators can view key usage metrics at a glance from a dashboard.

## Target Users

- **End users**: Team members who sign up and manage their own accounts.
- **Administrators**: Team leaders who monitor overall user activity and usage data.

## Core Features

1. Email/password-based sign-up, login, logout, and password reset.
2. User profile view and edit (name, avatar, notification preferences).
3. Admin analytics dashboard (user count, activity summary, key usage metrics).

## Constraints

- Team size: 1–2 developers.
- Target timeline: MVP within 3 months.
- No external integrations (third-party API connections excluded).

## Technical Context

- Frontend: React (SPA)
- Backend: Node.js + Express, REST API
- Database: PostgreSQL
- Hosting: AWS (EC2 + RDS)

## Non-Functional Requirements

- **Performance**: Page load under 2 seconds on a standard broadband connection.
- **Security**: Passwords hashed with bcrypt; sessions expire after 30 minutes of inactivity.
- **Scalability**: Supports up to 500 concurrent users without degradation.
- **Accessibility**: Meets WCAG 2.1 AA standards for core user flows.

## Out of Scope

- Social login (OAuth)
- Billing and subscription management
- Mobile app
- Real-time notifications

## Success Criteria

- New users can complete sign-up and profile setup in under 5 minutes.
- Administrators can access the analytics dashboard within 1 minute of logging in.

---

## History

| Timestamp | Subject | Note |
| --- | --- | --- |
| 2026-04-15 00:00 | vision.md | Created |
