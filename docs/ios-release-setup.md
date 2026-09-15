# iOS release setup

This project is ready for an Xcode/macOS validation pass, but signing and Apple
account resources must be configured on a Mac.

1. Open `ios/Runner.xcworkspace` in Xcode and set the final Apple Team,
   provisioning profile, and production bundle identifier.
2. In the Runner target's Build Settings, add `GOOGLE_MAPS_API_KEY` from the
   organisation's secret store. The key is deliberately not stored in this
   repository.
3. Enable the Location When In Use capability and confirm the Arabic location,
   camera, and photo-library purpose strings in `Runner/Info.plist` meet the
   release policy.
4. Run `flutter pub get`, `pod install` from `ios`, then build and test on a
   physical iPhone. Verify login, location permission, attendance, an offline
   replay, visits, and device revocation.
5. Build an Archive in Xcode and submit it through the authorised Apple
   distribution workflow.

For Android development builds, set `GOOGLE_MAPS_API_KEY` in the host's private
`~/.gradle/gradle.properties`, then run the normal Flutter build. Do not commit
that value to this repository.
