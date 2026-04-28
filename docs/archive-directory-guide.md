# Archive Directory Structure Guide

Reference for the 5 predefined directory structure patterns available in `/speckit.blueprint.archive`.

---

## Category-Based

**Type:** `category_based`

```
docs/
├── domains/           # Business capabilities / Bounded Contexts
│   ├── auth.md
│   ├── messaging.md
│   └── payments.md
├── systems/           # Technical infrastructure
│   ├── database.md
│   ├── websocket.md
│   └── caching.md
├── cross-cutting/     # Shared concerns (observability, security)
│   ├── observability.md
│   └── security.md
└── decisions/         # Architecture Decision Records
    ├── 001-websocket-protocol.md
    └── 002-database-selection.md
```

- **Best for**: Most teams (5~50 people). Separates business domain, tech stack, and cross-cutting concerns.
- **Trade-off**: Requires initial categorization agreement.

---

## Domain-Driven

**Type:** `domain_driven`

```
docs/
├── identity/          # Bounded Context: Identity & Access
│   ├── auth.md
│   └── user-profile.md
├── communication/     # Bounded Context: Communication
│   ├── messaging.md
│   └── notifications.md
├── commerce/          # Bounded Context: Commerce
│   ├── payments.md
│   └── catalog.md
└── decisions/
    └── ...
```

- **Best for**: DDD-practicing teams, MSA/modular monoliths. Mirrors bounded context boundaries.
- **Trade-off**: Cross-domain decisions may be hard to place.

---

## Feature-Foundation Split

**Type:** `feature_foundation_split`

```
docs/
├── features/          # User-facing capabilities
│   ├── messaging.md
│   ├── media-sharing.md
│   └── group-management.md
├── foundations/       # Underlying technical infrastructure
│   ├── auth.md
│   ├── database.md
│   └── websocket.md
├── operations/        # DevOps / Observability
│   ├── monitoring.md
│   └── deployment.md
└── decisions/
    └── ...
```

- **Best for**: Product-centric teams. Intuitive separation between "what users see" and "what powers it".
- **Trade-off**: Some topics span both (e.g., real-time messaging = feature + websocket foundation).

---

## Layer-Based

**Type:** `layer_based`

```
docs/
├── frontend/          # Presentation layer
│   ├── ui-components.md
│   └── state-management.md
├── backend/           # Application/Business logic layer
│   ├── api-contracts.md
│   ├── auth-logic.md
│   └── database-schema.md
├── infrastructure/    # Infrastructure layer
│   ├── messaging-pipeline.md
│   └── observability.md
└── decisions/
    └── ...
```

- **Best for**: Teams with clear role separation (frontend/backend/infra), multi-platform projects.
- **Trade-off**: Cross-layer features (e.g., authentication) appear in multiple layers.

---

## Topic-Centric Flat

**Type:** `topic_centric_flat`

```
docs/
├── topics/            # All design knowledge by topic
│   ├── auth.md
│   ├── messaging.md
│   ├── database.md
│   └── payments.md
├── decisions/         # Architecture Decision Records
│   ├── 001-websocket-protocol.md
│   └── 002-database-selection.md
└── runbooks/          # Operational guides (optional)
    └── incident-response.md
```

- **Best for**: Teams wanting minimal depth (max 2 levels) with clear separation between topics, ADRs, and runbooks.
- **Trade-off**: `topics/` directory can become large; relies on good naming conventions.

---

## Custom

**Type:** `custom`

Define your own directory structure. You will be asked to describe your layout (e.g., `docs/modules/, docs/shared/, docs/adrs/`), stored in `custom_structure_description`.

- **Best for**: Projects with unique organizational needs or existing structures.
- **Trade-off**: No predefined conventions are enforced; consistency is manual.
