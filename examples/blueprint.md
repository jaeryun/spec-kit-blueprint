# Blueprint: Simple Messenger

_Last updated: 2026-04-25_

---

## Epics

### EP-1 — Users can send and receive real-time 1:1 messages reliably

- **Scope**: Core 1:1 messaging infrastructure, message delivery guarantees, conversation history, and presence indicators.
- **Out of Scope**: End-to-end encryption (Phase 2), message editing, disappearing messages.
- **Success Criteria**: 99.9% message delivery success rate. Delivery latency < 500ms for 95th percentile.
- **External**: —

#### Stories

- **ST-1.1** — Users can exchange text messages in real-time with delivery status.
  - **Scope**: Send/receive text via WebSocket, persistent conversation threads, delivery/read receipt tracking.
  - **Key AC**: Given an open conversation, a sent message appears in the recipient's client within 1 second. Given a sent message, sender sees "delivered" when the server acknowledges, and "read" when recipient opens the conversation.
  - **External**: —
  - **Features**:
    - FT-1.1.1 — WebSocket connection management and message routing
      - **Spec Path**: specs/ft-1.1.1-websocket-routing
      - **External**: —
      - **Status**: InProgress
    - FT-1.1.2 — Message persistence and conversation history API
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-1.1.3 — Delivery and read receipt state machine
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo

- **ST-1.2** — Users can share rich media and voice messages in 1:1 chats.
  - **Scope**: Image/video upload with compression, file attachments, voice message recording and playback.
  - **Key AC**: User can upload an image up to 10MB, which is compressed to < 2MB for preview. User can record a voice message up to 5 minutes and playback with seek support.
  - **External**: —
  - **Features**:
    - FT-1.2.1 — Media upload pipeline (compression, thumbnail generation, S3 storage)
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-1.2.2 — File attachment with type-based preview (PDF, DOCX)
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-1.2.3 — Voice message recording, upload, and progressive playback
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo

### EP-2 — Users can create and collaborate in group conversations

- **Scope**: Group lifecycle management, member roles, advanced messaging features within groups.
- **Out of Scope**: Public channels, broadcast lists, threaded replies in 1:1 chats.
- **Success Criteria**: Groups support up to 500 members with < 2s load time for last 50 messages. Admin actions apply within 1 second.
- **External**: —

#### Stories

- **ST-2.1** — Users can create groups and manage membership with roles.
  - **Scope**: Group creation flow, member invitation (link / direct add), admin/member role distinction, group metadata management.
  - **Key AC**: A user can create a group with up to 256 initial members. Group creators are auto-assigned admin role and can promote/demote others. Members can leave or be removed by admins.
  - **External**: —
  - **Features**:
    - FT-2.1.1 — Group creation and member invitation flow
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-2.1.2 — Role-based permission model (admin vs member)
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-2.1.3 — Group profile metadata (name, avatar, description, rules)
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo

- **ST-2.2** — Group members can use advanced collaboration features.
  - **Scope**: Message reactions, pin/announcement messages, @mentions with notification routing.
  - **Key AC**: Any member can react with emoji to a message. Admins can pin up to 3 messages visible at the top. @mentions trigger push notifications to offline members.
  - **External**: —
  - **Features**:
    - FT-2.2.1 — Emoji reactions aggregation and display
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-2.2.2 — Pin messages and admin announcements banner
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-2.2.3 — @mention parsing and targeted push notification routing
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo

### EP-3 — Users can discover contacts and manage their social graph

- **Scope**: Contact discovery, friend connection lifecycle, blocking, and address book sync.
- **Out of Scope**: Public user directories, "people you may know" recommendations.
- **Success Criteria**: New users can find and message an existing contact within 3 minutes. Contact sync completes within 30 seconds for < 1000 contacts.
- **External**: —

#### Stories

- **ST-3.1** — Users can find other users and manage connection requests.
  - **Scope**: Username/phone number search, QR code sharing, friend request send/accept/decline, blocking/unblocking.
  - **Key AC**: User can search by exact username or partial phone number. Sending a friend request notifies the recipient. Blocked users cannot send messages or view online status.
  - **External**: —
  - **Features**:
    - FT-3.1.1 — User search by username and phone number
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-3.1.2 — Friend request state machine (pending, accepted, declined)
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-3.1.3 — Block list and privacy-enforced access control
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo

- **ST-3.2** — Users can sync and organize their address book contacts.
  - **Scope**: Phone contact upload and matching, auto-suggest existing users, contact labeling (favorites).
  - **Key AC**: User can optionally upload address book; the app matches phone hashes to existing users without exposing raw numbers. Matched contacts appear in a dedicated "Contacts" tab.
  - **External**: —
  - **Features**:
    - FT-3.2.1 — Privacy-preserving contact matching (hashed phone numbers)
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-3.2.2 — Contact import UI and matched user suggestion list
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo
    - FT-3.2.3 — Favorite contacts and quick-access recents
      - **Spec Path**: <!-- Populated by /speckit.blueprint.link-spec -->
      - **External**: —
      - **Status**: ToDo

---

## History

| Timestamp | Subject | Note |
| --- | --- | --- |
| 2026-04-25 00:00 | blueprint.md | Created from vision.md |
