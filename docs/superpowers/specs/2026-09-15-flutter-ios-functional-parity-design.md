# Flutter iOS Functional-Parity Design

## Goal

Make `Checkin.Flutter` a production iOS client with the same employee, manager,
and field-representative workflows as the Android MAUI client, using the live
official API at `https://checkin.nmc.ly`.

## Sources of truth

1. The live API host is `https://checkin.nmc.ly`.
2. `Checkin.Api` controllers and request/response contracts are the API source
   of truth. The live host is used to confirm route availability.
3. `Checkin.Maui` is the source of truth for user-facing behaviour, including
   roles, location checks, device registration, offline actions, and flows.
4. No compatibility endpoints will be added to the API. Flutter will call the
   official endpoint for each workflow.

## Contract decisions

| Workflow | Official Flutter contract |
|---|---|
| Login / refresh / device registration | `auth/login`, `auth/refresh`, `auth/register-device` |
| Devices | `auth/devices`, `auth/devices/{deviceId}` to match MAUI ownership semantics |
| Password / profile / account deletion | `auth/change-password`, `employees/me`, `employees/me/account` |
| Attendance and manager attendance | `attendance/status`, `attendance/checkin`, `attendance/checkout`, `attendance/history`, `attendance/team`, `attendance/sync` |
| Requests and approvals | `requests`, `requests/{id}`, `requests/{id}/cancel`, `requests/pending`, `requests/{id}/approve`, `requests/{id}/reject` |
| Visits | `visits`, `visits/{id}/end`, `visits/today`, `visits/history` |
| Stores | `stores/my`, `stores/{id}`, `stores`, `stores/unvisited` |
| Calendar | Attendance history for the selected month; the API has no calendar endpoint |
| Legal | `legal/privacy-policy`, `legal/terms-of-service` |

`auth/forgot-password` is not exposed by the official API. The Flutter UI must
report an explicit unsupported-service error rather than call a non-existent
route. Adding password-reset support requires a backend product decision.

## Architecture

Flutter repositories remain the feature boundary. A new API-contract layer
holds route construction and keeps feature repositories free of invented
paths. Feature DTOs map the official `ApiResponse<T>` payloads. A stable,
securely stored installation identifier is sent at login, attendance, visits,
and device registration.

Offline records are stored durably as request method, official relative route,
JSON payload, retry count, and next attempt. The synchronizer sends the real
HTTP request only when online. A record becomes synced only after a successful
API response; failed requests use exponential retry scheduling.

## Behaviour requirements

- Resolve manager and field-representative roles case-insensitively, matching
  MAUI. Field-representative classification takes precedence over manager only
  where MAUI does so.
- Obtain real device location before attendance or field-visit actions. Never
  use hard-coded coordinates.
- Use the nearby-locations result and the location radius to determine the
  visible range state. Send the actual position and shared installation ID.
- Register the device after successful login using available platform and app
  metadata. Do not expose hardware identifiers.
- Preserve the user session during a successful refresh and redirect to login
  only after a failed refresh.
- Configure iOS permissions and release metadata, while leaving certificate,
  provisioning profile, App Store bundle identifier, and production signing as
  manual Apple-account tasks.

## Test strategy

- Unit/contract tests assert every migrated endpoint and payload shape.
- Device-identity tests assert persistence and platform labels.
- Offline tests assert enqueue, real replay dispatch, success marking, and
  retry behaviour.
- Router tests assert employee, manager, and field-representative destinations
  after a session change.
- Existing widget tests, `flutter analyze`, Android APK build, and iOS project
  validation run after implementation. iOS compilation is reported separately
  because this Windows host cannot run Xcode.

## Explicit non-goals

- No backend compatibility aliases.
- No attempt to create or use Apple signing credentials.
- No use of real customer data or destructive live API actions in automated
  verification.
