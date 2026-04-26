# ST-3.2 — Users can sync and organize their address book contacts

> Source of Truth. Last updated: 2026-04-25
> External: —

---

## Overview

Phone address book upload with privacy-preserving matching (hashed phone numbers), auto-suggest existing users, and favorite contacts for quick access.

## Current State

(TBD — filled incrementally after each FT is specified and merged)

## Tech Context

(TBD)

## Non-Goals

- Continuous background sync (manual upload only)
- Contact detail enrichment from external sources
- Social relationship inference

## NFR

- Contact sync completes within 30 seconds for < 1000 contacts
- Phone hashes are never stored in raw form
- Matched contacts appear in UI within 2 seconds of sync completion

## ADR

(TBD)
