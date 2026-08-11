# Golden System - latest source package

This package is based on the most recent uploaded `GoldenSystem_admin_controls_update.zip`,
using its nested `golden_system7/golden_system7` project as the canonical source because
that copy contains the social/chat, battle-code, redemption, and admin files together.

The supplied 1536x1536 Golden System dragon logo has been added as:
`assets/golden_system.png`

The Flutter asset declaration is present, and `flutter_launcher_icons` configuration is
included so a normal Flutter build environment can generate Android/iOS launcher icons.

Important:
- This environment does not have Flutter/Dart installed, so an actual `flutter build apk`
  could not be executed here.
- The project should be passed through `flutter pub get` and the launcher-icon generator
  before the final Android build if the build service does not invoke it automatically.


Code2Native preparation: Android platform is generated in CI via flutter create; GitHub Actions and Codemagic configs added. Redemption UI and settings/admin navigation added.
