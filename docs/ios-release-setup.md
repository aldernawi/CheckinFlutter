# iOS release setup

This project is ready for an Xcode/macOS validation pass, but signing and Apple
account resources must be configured on a Mac.

The app minimum is iOS 14.0 because its maps and background-work dependencies
require it.

1. Open `ios/Runner.xcworkspace` in Xcode and set the final Apple Team,
   provisioning profile, and production bundle identifier.
2. `ios/Flutter/Secrets.xcconfig` provides `GOOGLE_MAPS_API_KEY` locally and
   is deliberately excluded from Git. Keep it in the organisation's secret
   store and recreate it on each signing machine if required.
3. Enable the Location When In Use capability and confirm the Arabic location,
   camera, and photo-library purpose strings in `Runner/Info.plist` meet the
   release policy.
4. Run `flutter pub get`, `pod install` from `ios`, then build and test on a
   physical iPhone. Verify login, location permission, attendance, an offline
   replay, visits, and device revocation.
5. Build an Archive in Xcode and submit it through the authorised Apple
   distribution workflow.

For Android, `android/keys.properties` provides the same private setting and is
excluded from Git. Do not commit that value to this repository.
