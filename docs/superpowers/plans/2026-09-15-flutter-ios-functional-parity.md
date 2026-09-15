# Flutter iOS Functional Parity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align Flutter iOS workflows with MAUI behaviour and the official NMC API.

**Architecture:** Use official route constants and feature repositories to isolate contract mapping. Persist a privacy-safe installation ID, enqueue official API operations when offline, and replay them through the existing Dio client only after network recovery.

**Tech Stack:** Flutter, Riverpod, Dio, Drift, flutter_secure_storage, geolocator, Workmanager.

**Spec:** `docs/superpowers/specs/2026-09-15-flutter-ios-functional-parity-design.md`

## Global Constraints

- The production host is `https://checkin.nmc.ly`.
- `Checkin.Api` owns request and response contracts; do not add compatibility routes.
- Do not use hard-coded device identifiers or coordinates.
- Every production behaviour change has a test written and observed failing first.
- Apple signing and provisioning remain manual tasks.

---

### Task 1: Official API contracts and session routing

**Files:**
- Create: `lib/core/network/api_routes.dart`
- Modify: `lib/core/network/api_client.dart`, `lib/core/network/auth_session_manager.dart`, `lib/app/router/app_router.dart`
- Test: `test/core/network/api_routes_test.dart`, `test/app/router/auth_routing_test.dart`

- [ ] Write tests asserting official route constants and the three role landing routes.
- [ ] Run the tests and observe failures because route constants and stable route refresh behaviour are absent.
- [ ] Add route constants, route construction helpers, and stable session-driven router refresh.
- [ ] Run the focused tests and `flutter analyze`.

### Task 2: Authentication, profile, and devices

**Files:**
- Modify: `lib/features/auth/*`, `lib/features/profile/*`, `lib/features/devices/*`, `lib/core/services/device_identity_service.dart`
- Create: `test/features/auth/auth_contract_test.dart`, `test/core/services/device_identity_service_test.dart`

- [ ] Write tests for a persisted installation ID, login metadata, self-registration branch ID, and official profile/device paths.
- [ ] Run the tests and observe failures.
- [ ] Add device registration after login and replace obsolete profile/device paths with official calls.
- [ ] Make unsupported password reset explicit because no official endpoint exists.
- [ ] Run focused tests, widget tests, and analyzer.

### Task 3: Attendance, location, and geographic range

**Files:**
- Modify: `lib/features/home/*`, `lib/features/attendance/*`, `lib/core/services/location_service.dart`
- Create: `test/features/attendance/attendance_flow_test.dart`

- [ ] Write tests for selected nearby location range and attendance requests using real supplied coordinates and installation ID.
- [ ] Run the tests and observe failures from fixed coordinates / incomplete range state.
- [ ] Inject location and identity services, use live location, and preserve check-in/check-out state.
- [ ] Run focused tests and analyzer.

### Task 4: Offline queue and replay

**Files:**
- Modify: `lib/offline/queue/*`, `lib/offline/sync/*`, `lib/features/attendance/*`, `lib/features/field_visits/*`
- Create: `test/offline/offline_sync_orchestrator_test.dart`

- [ ] Write tests for a queued official request, successful replay, and failed replay retry scheduling.
- [ ] Run the tests and observe the current no-op synchronizer failure.
- [ ] Add a dispatching gateway, durable payload schema, enqueue-on-network-failure, and exponential retry.
- [ ] Run focused tests and analyzer.

### Task 5: Visits, stores, calendar, and maps

**Files:**
- Modify: `lib/features/field_visits/*`, `lib/features/stores/*`, `lib/features/calendar/*`
- Create: `test/features/field_visits/visit_contract_test.dart`, `test/features/calendar/calendar_repository_test.dart`

- [ ] Write tests for official visits paths, end-visit request, store-filtered history, required unvisited dates, and month history calendar queries.
- [ ] Run the tests and observe obsolete route failures.
- [ ] Migrate visit/store/calendar repositories and UI actions to official contracts.
- [ ] Run focused tests and analyzer.

### Task 6: Requests and manager workflows

**Files:**
- Modify: `lib/features/requests/*`, `lib/features/team/*`, `lib/app/router/*`
- Create: `test/features/team/team_contract_test.dart`, `test/app/router/route_coverage_test.dart`

- [ ] Write tests for manager attendance, pending requests, approval/rejection, and every application navigation target.
- [ ] Run the tests and observe old team route and navigation failures.
- [ ] Move calls to official requests/attendance endpoints and correct navigation destinations.
- [ ] Run focused tests, widget tests, and analyzer.

### Task 7: iOS configuration and end-to-end verification

**Files:**
- Modify: `ios/Runner/Info.plist`, `ios/Runner.xcodeproj/project.pbxproj`, `pubspec.yaml`
- Test: `test/contract/navigation_contract_test.dart`

- [ ] Write contract/navigation tests for all migrated route constants and application role destinations.
- [ ] Run the tests and observe the expected pre-change failure where applicable.
- [ ] Set official display metadata and iOS privacy descriptions; retain placeholder signing values for manual Apple setup.
- [ ] Run `flutter analyze`, `flutter test`, `flutter build apk --release`, and `flutter build ios --no-codesign` where host tooling permits.
