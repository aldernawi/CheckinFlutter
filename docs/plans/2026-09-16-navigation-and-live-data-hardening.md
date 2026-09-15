# Navigation and live-data hardening

## Goal

Eliminate the iOS resume `Page Not Found` failure, restore predictable back
navigation, and remove demo values from authenticated screens so displayed
identity and attendance data always comes from the official API (with only a
validated cached employee snapshot as an offline fallback).

## Implementation

1. Register an explicit `/` route and keep session/role redirects deterministic.
2. Add regression coverage for the root route and persisted employee JSON.
3. Fetch `GET /api/v1/employees/me`, cache valid JSON, refresh after profile edits,
   and bind profile/home/edit screens to that state.
4. Replace leaf-screen `go` navigation with `push` so iOS receives a real back
   stack, while retaining safe route-level fallbacks.
5. Replace attendance-detail indices and static values with the real attendance
   ID and DTO returned by the history endpoint.
6. Replace static team-member detail content with the selected live team
   attendance DTO; omit statistics for which the backend exposes no contract.
7. Run formatting, focused tests, the full test suite, analyzer, and platform
   validation available on this host; then commit and push the verified result.
