# API Contract: Auth Endpoints — ST-01

> Last updated by: FT-02 (2026-04-23)

---

## POST /auth/register

**Description**: Create a new user account and send email verification.

**Parameters**:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `email` | `string` | yes | User email address |
| `password` | `string` | yes | Minimum 8 characters |

**Returns**:

```json
{ "message": "Verification email sent." }
```

**Errors**:

| Code | Condition |
| --- | --- |
| 409 | Email already registered |
| 422 | Password too short |

---

## POST /auth/login

**Description**: Authenticate and receive a session token.

**Parameters**:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `email` | `string` | yes | Registered email |
| `password` | `string` | yes | Account password |

**Returns**:

```json
{ "token": "<session-token>", "expires_in": 1800 }
```

**Errors**:

| Code | Condition |
| --- | --- |
| 401 | Invalid credentials |
| 403 | Email not yet verified |
