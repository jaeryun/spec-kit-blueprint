# Data Model: ST-01 — Users can register and log in

> Last updated by: FT-02 (2026-04-23)

---

## Entities

### User (PostgreSQL — `users` table)

Represents a registered user account.

| Field | Type | Description |
| --- | --- | --- |
| `id` | `uuid` | Primary key |
| `email` | `varchar(255)` | Unique, lowercase-normalized |
| `password_hash` | `varchar(60)` | bcrypt hash, cost factor 12 |
| `email_verified` | `boolean` | False until email verification link clicked |
| `created_at` | `timestamptz` | Account creation time |

### Session (Redis — key: `session:{token}`)

Active user session. Expires after 30 minutes of inactivity (sliding).

| Field | Type | Description |
| --- | --- | --- |
| `user_id` | `uuid` | Reference to User.id |
| `created_at` | `ISO8601 string` | Session creation time |

### PasswordReset (Redis — key: `reset:{token}`)

Temporary token for password reset. Expires after 1 hour.

| Field | Type | Description |
| --- | --- | --- |
| `user_id` | `uuid` | Reference to User.id |
| `created_at` | `ISO8601 string` | Token creation time |

---

## Relationships

- User → Session: one-to-many (a user may have multiple active sessions across devices).
- User → PasswordReset: one-to-many (a user may have multiple pending reset requests).
