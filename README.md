<div align="center">

# Spec Kit Blueprint

**Vision-first project planning for [Spec Kit](https://github.com/github/spec-kit).**

*Start with vision. Shape it into a roadmap.*  
*Then write specs that never lose sight of the big picture.*

[![Version](https://img.shields.io/badge/version-1.2.1-blue?style=flat-square)](https://github.com/jaeryun/spec-kit-blueprint/releases)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Requires SpecKit](https://img.shields.io/badge/requires%20SpecKit-%3E%3D0.4.0-orange?style=flat-square)](https://github.com/github/spec-kit)

</div>

## Quick Start

```bash
# 1. Install the extension
specify extension add blueprint --from https://github.com/jaeryun/spec-kit-blueprint/archive/refs/tags/v1.2.1.zip

# 2. Define your vision
/speckit.blueprint.vision

# 3. Design the Epic → Story → Feature hierarchy
/speckit.blueprint.design

# 4. Pick a Feature and specify it
/speckit.specify FT-1.1.1
#    → /speckit.plan → /speckit.tasks → /speckit.implement

# 5. Archive completed features into your Knowledge Base
/speckit.blueprint.archive FT-1.1.1

# Repeat 4-5 for each Feature
```

## What It Does

Blueprint adds three slash commands to SpecKit that enforce a **"Big Picture First"** workflow:

1. **Vision** — Define the problem, target users, and goals before writing any spec.
2. **Design** — Break the vision into an Epic → Story → Feature hierarchy so every spec maps to exactly one Feature.
3. **Archive** — Extract durable technical decisions from completed specs into topic-based knowledge files under `docs/` so they stay discoverable after delivery.

> **Familiar with Jira?** This hierarchy mirrors the Jira structure you already know:
> **Epic** → **Story** → **Feature** (think *Story → Sub-task*).
> Each Feature gets its own spec, so work is scoped to exactly one deliverable.

```mermaid
flowchart TD
    B["/speckit.blueprint.vision<br/>Define problem, users, goals"]

    subgraph BP ["Blueprint - Workflow"]
        direction TB
        B --> V["vision.md<br/>Problem / Users / Goals / Constraints"]
        V --> C["/speckit.blueprint.design<br/>Design draft: Epic → Story → Feature"]
        C --> R["blueprint.md<br/>Epic / Story / Feature Draft"]

        subgraph HIER ["blueprint.md"]
            direction TB
            R -.-> EP1["EP-01 — Real-time 1:1 Messaging"]
            EP1 -.-> ST1["ST-1.1 — Text messaging with delivery status"]
            ST1 -.-> FT_1_1_1["FT-1.1.1 WebSocket connection management and message routing"]
            ST1 -.-> FT_1_1_2["FT-1.1.2 Message persistence and conversation history API"]

            R -.-> EP2["EP-02 — Group Conversations"]
            EP2 -.-> ST2["ST-2.1 — Group creation and management"]
            ST2 -.-> FT_2_1_1["FT-2.1.1 Group creation and member invitation flow"]
            EP2 -.-> ST3["ST-2.2 — Advanced collaboration features"]
            ST3 -.-> FT_2_2_1["FT-2.2.1 Emoji reactions aggregation and display"]
        end
    end

    subgraph DEV1 ["Person A picks FT-1.1.1"]
        direction LR
        S_1_1_1["/speckit.specify FT-1.1.1"] --> N_1_1_1["/speckit.plan<br/>/speckit.tasks<br/>/speckit.implement"] --> A_1_1_1["/speckit.blueprint.archive FT-1.1.1"]
    end

    subgraph DEV2 ["Person B picks FT-1.1.2"]
        direction LR
        S_1_1_2["/speckit.specify FT-1.1.2"] --> N_1_1_2["/speckit.plan<br/>/speckit.tasks<br/>/speckit.implement"] --> A_1_1_2["/speckit.blueprint.archive FT-1.1.2"]
    end

    subgraph DEV3 ["Person A picks FT-2.1.1"]
        direction LR
        S_2_1_1["/speckit.specify FT-2.1.1"] --> N_2_1_1["/speckit.plan<br/>/speckit.tasks<br/>/speckit.implement"] --> A_2_1_1["/speckit.blueprint.archive FT-2.1.1"]
    end

    subgraph DEV4 ["Person A picks FT-2.2.1"]
        direction LR
        S_2_2_1["/speckit.specify FT-2.2.1"] --> N_2_2_1["/speckit.plan<br/>/speckit.tasks<br/>/speckit.implement"] --> A_2_2_1["/speckit.blueprint.archive FT-2.2.1"]
    end

    FT_1_1_1 -.-> S_1_1_1
    FT_1_1_2 -.-> S_1_1_2
    FT_2_1_1 -.-> S_2_1_1
    FT_2_2_1 -.-> S_2_2_1

    style BP fill:#e8edf5,stroke:#1e40af,stroke-width:2px,color:#1e3a5f
    style HIER fill:#ffffff,stroke:#93c5fd,stroke-dasharray: 5 5,color:#1e3a5f
    style DEV1 fill:#e6f2ee,stroke:#0f766e,stroke-width:2px,color:#134e4a
    style DEV2 fill:#e6f2ee,stroke:#0f766e,stroke-width:2px,color:#134e4a
    style DEV3 fill:#e6f2ee,stroke:#0f766e,stroke-width:2px,color:#134e4a
    style DEV4 fill:#e6f2ee,stroke:#0f766e,stroke-width:2px,color:#134e4a
    style B fill:#1e40af,stroke:#1e40af,color:#f8fafc
    style C fill:#1e40af,stroke:#1e40af,color:#f8fafc
    style V fill:#ffffff,stroke:#93c5fd,color:#1e3a5f
    style R fill:#ffffff,stroke:#93c5fd,color:#1e3a5f
    style EP1 fill:#dbeafe,stroke:#3b82f6,color:#1e3a5f
    style EP2 fill:#dbeafe,stroke:#3b82f6,color:#1e3a5f
    style ST1 fill:#eff6ff,stroke:#93c5fd,color:#1e3a5f
    style ST2 fill:#eff6ff,stroke:#93c5fd,color:#1e3a5f
    style ST3 fill:#eff6ff,stroke:#93c5fd,color:#1e3a5f
    style FT_1_1_1 fill:#f8fafc,stroke:#cbd5e1,color:#334155
    style FT_1_1_2 fill:#f8fafc,stroke:#cbd5e1,color:#334155
    style FT_2_1_1 fill:#f8fafc,stroke:#cbd5e1,color:#334155
    style FT_2_2_1 fill:#f8fafc,stroke:#cbd5e1,color:#334155
    style S_1_1_1 fill:#0f766e,stroke:#0f766e,color:#f0fdf4
    style S_1_1_2 fill:#0f766e,stroke:#0f766e,color:#f0fdf4
    style S_2_1_1 fill:#0f766e,stroke:#0f766e,color:#f0fdf4
    style S_2_2_1 fill:#0f766e,stroke:#0f766e,color:#f0fdf4
    style N_1_1_1 fill:#134e4a,stroke:#134e4a,color:#f0fdf4
    style N_1_1_2 fill:#134e4a,stroke:#134e4a,color:#f0fdf4
    style N_2_1_1 fill:#134e4a,stroke:#134e4a,color:#f0fdf4
    style N_2_2_1 fill:#134e4a,stroke:#134e4a,color:#f0fdf4
    style A_1_1_1 fill:#c2410c,stroke:#9a3412,color:#fff7ed
    style A_1_1_2 fill:#c2410c,stroke:#9a3412,color:#fff7ed
    style A_2_1_1 fill:#c2410c,stroke:#9a3412,color:#fff7ed
    style A_2_2_1 fill:#c2410c,stroke:#9a3412,color:#fff7ed
```

## Outputs

Running the commands produces these files:

```text
docs/
├── blueprint/
│   ├── vision.md          # Project vision
│   └── blueprint.md       # Master roadmap: Epic → Story → Feature hierarchy
├── auth.md                # Knowledge Base: authentication decisions
├── messaging.md           # Knowledge Base: messaging architecture
└── ...
```

See [`examples/vision.md`](examples/vision.md) and [`examples/blueprint.md`](examples/blueprint.md) for full worked examples.

## Commands

| Command | Description | Requires |
|---------|-------------|---------|
| `/speckit.blueprint.vision` | Defines the problem, users, and goals — outputs `vision.md` | — |
| `/speckit.blueprint.design` | Breaks vision into Epic → Story → Feature — outputs `blueprint.md` | `vision.md` |
| `/speckit.blueprint.archive` | Archives a completed FT into topic-based knowledge under `docs/` | `blueprint.md` + spec |

> **Auto-run via hooks:** `/speckit.blueprint.link-spec` — Records the spec directory path in `blueprint.md` after `/speckit.specify` completes. Usually triggered automatically by hooks; not a core command you run manually.

Each command accepts an optional free-text argument that pre-populates the interview or narrows its focus.

**Example:**

```text
/speckit.blueprint.vision We're building a SaaS analytics dashboard for small e-commerce teams
```

> **Why archive?** Feature specs go stale and scatter knowledge across directories. Archiving extracts durable decisions into topic-based `docs/` files that survive delivery closure.

## Installation

Requires Spec Kit 0.4.0 or later.

```bash
specify extension add blueprint --from https://github.com/jaeryun/spec-kit-blueprint/archive/refs/tags/v1.2.1.zip
```

For local development:

```bash
specify extension add --dev /path/to/spec-kit-blueprint
```

## Non-Goals

- **Not a spec writer**: Blueprint produces the hierarchy as input to `/speckit.specify` — it does not replace SpecKit's core workflow.
- **No orchestration or tracking**: Scheduling and progress tracking are out of scope.

## Uninstalling

```bash
specify extension remove blueprint
```

## License

MIT — see [LICENSE](LICENSE)
