# Vision: Simple Messenger

_Last updated: 2026-04-25_

---

## Overview

A cross-platform instant messaging application focused on speed, reliability, and rich media sharing. Users can send real-time messages, create group conversations, and stay connected through a unified contact system.

## Problem Statement

Existing messaging apps are either too bloated with unnecessary features or lack reliable media sharing and group collaboration tools for everyday communication.

## Goals & Objectives

- Users can send and receive messages with sub-second latency.
- Users can seamlessly share images, videos, and files without quality loss.
- Users can create and manage group conversations with clear roles and permissions.
- Users can easily find and connect with contacts through multiple discovery methods.

## Target Users

- **Individual users**: People who want fast, reliable 1:1 and group messaging.
- **Team leads**: Users who need organized group chats with announcements and pinned content.
- **Content sharers**: Users who frequently exchange photos, videos, and documents.

## Core Features

1. Real-time 1:1 text messaging with read receipts and typing indicators.
2. Rich media sharing (images, videos, files, voice messages) with preview and compression.
3. Group chat creation and management (invitation, admin roles, announcements).
4. Contact discovery via username, phone number, and address book sync.
5. Message reactions, threading, and pinned messages for group collaboration.

## Constraints

- Team size: 3–4 developers (backend, frontend, infra).
- Target timeline: MVP within 4 months.
- Must support iOS, Android, and Web from day one (React Native + Web).
- Message history retained for 90 days on free tier.

## Technical Context

- **Frontend**: React (Web), React Native (Mobile)
- **Backend**: Node.js + WebSocket (Socket.io), REST API
- **Database**: PostgreSQL (metadata), Redis (presence/sessions), S3-compatible (media)
- **Real-time**: WebSocket for messaging, push notifications via FCM/APNs

## Non-Functional Requirements

- **Performance**: Message delivery latency < 500ms for 95th percentile.
- **Reliability**: Message delivery guarantee (at-least-once) with idempotency keys.
- **Scalability**: Support 10,000 concurrent connections per node; horizontal scaling ready.
- **Security**: End-to-end encryption for 1:1 messages (Signal Protocol); TLS 1.3 for transport.
- **Accessibility**: WCAG 2.1 AA for web; VoiceOver/TalkBack support for mobile.

## Out of Scope

- Video/voice calling (Phase 2).
- Stories / ephemeral content (Snapchat-style).
- In-app payments or stickers marketplace.
- Chatbots or third-party integrations.
- Message editing after 5 minutes.

## Success Criteria

- Users can send a message and receive a delivery confirmation within 1 second under normal network conditions.
- Group chats support up to 500 members without performance degradation.
- 99.9% message delivery success rate over a 30-day period.
- New users can find and message an existing contact within 3 minutes of signing up.

---

## History

| Timestamp | Subject | Note |
| --- | --- | --- |
| 2026-04-25 00:00 | vision.md | Created |
