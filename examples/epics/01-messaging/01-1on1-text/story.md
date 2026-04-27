# ST-1.1 — Users can exchange text messages in real-time with delivery status

> Source of Truth. Last updated: 2026-04-25
> External: —

<!-- This file lives at docs/blueprint/epics/<epic-slug>/<story-slug>/story.md
     You can add related artifacts (data-model.md, contracts/, etc.)
     in the same directory as this Story evolves.

     This is the technical Source of Truth — updated incrementally via
     /speckit.blueprint.archive after each FT is merged. -->

---

## Overview

Core real-time 1:1 messaging capability. Users send and receive text messages with reliable delivery, read receipts, and persistent conversation history.

## Current State

(TBD — filled incrementally after each FT is specified and merged)

## Tech Context

(TBD)

## Non-Goals

- Group messaging (covered in EP-2)
- End-to-end encryption (Phase 2)
- Message editing or deletion after send

## NFR

- Message delivery latency < 500ms for 95th percentile
- 99.9% delivery success rate
- Support 10,000 concurrent WebSocket connections per node

## ADR

(TBD)
