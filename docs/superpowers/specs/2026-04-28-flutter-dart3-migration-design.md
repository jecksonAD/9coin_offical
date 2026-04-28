# Flutter Dart 3 Migration & 16 KB Page Size Compliance

**Date:** 2026-04-28
**Branch:** `feature/flutter-dart3-migration`
**Deadline:** May 31, 2026 (Google Play 16 KB page size enforcement)

## Goal

Migrate the 9Coin Flutter app from Dart 2.x to Dart 3.x and regenerate the Android build folder so the app supports 16 KB memory page sizes as required by Google Play policy. Flutter 3.22+ handles 16 KB alignment natively — the project just needs to be buildable with the modern toolchain.

## Approach: Incremental Migration

Upgrade in controlled phases on a single feature branch. Each phase is independently verifiable.

## Phase 1: SDK Constraint & Dart 3 Code Fixes

**pubspec.yaml change:**
```yaml
# Before
environment:
  sdk: ">=2.17.0 <3.0.0"

# After
environment:
  sdk: ">=3.0.0 <4.0.0"
```

**Dart code fixes (2 files, 3 changes):**

| File | Line | Change |
|------|------|--------|
| `lib/apptheme/apptheme.dart` | 43 | `primary:` → `backgroundColor:` in `ElevatedButton.styleFrom()` |
| `lib/apptheme/apptheme.dart` | 34 | `MaterialStateProperty` → `WidgetStateProperty` |
| `lib/features/profile/ui/helps_page.dart` | 61 | `primary:` → `backgroundColor:` in `ElevatedButton.styleFrom()` |

**Not breaking (no fix needed):**
- `CoinTextStyle.headline1` — custom getter, not a Flutter `TextTheme` API. Safe in Dart 3.
- `fixedSize:` in `ElevatedButton.styleFrom()` — valid parameter, not deprecated.

## Phase 2: Dependency Upgrades

Run `flutter pub upgrade --major-versions`, then manually resolve failures.

**High-risk packages (API changes expected):**

| Package | Current | Target | Code Impact |
|---------|---------|--------|-------------|
| `dio` | ^4.0.6 | ^5.x | `DioError` → `DioException`, interceptor API changes. Check all files importing dio. |
| `firebase_core` | ^2.3.0 | ^3.x | Firebase BoM restructured. Regenerate `firebase_options.dart` via FlutterFire CLI. |
| `firebase_messaging` | ^14.1.1 | ^15.x | Follows firebase_core upgrade. |
| `flutter_inappwebview` | ^5.7.2 | ^6.x | Android embedding changes. Check `in_app_webview_page.dart`. |
| `webview_flutter` | ^3.0.4 | ^4.x | Platform interface changed. Check webview usages. |
| `image_picker` | ^0.8.5 | ^1.x | Method signature changes. Check `get_image.dart`, `upload_image.dart`. |

**Medium-risk (should resolve cleanly):**
- `cached_network_image` ^3.2.3 → ^3.4+
- `shared_preferences` ^2.0.15 → ^2.3+
- `url_launcher` ^6.1.6 → ^6.3+
- `qr_flutter` ^4.0.0 → ^4.1+
- `syncfusion_flutter_barcodes` ^20.3.60 → ^27+
- `flutter_lints` ^2.0.0 → ^3.x (or replace with `lints`)

**Low-risk (version bump only):**
`badges`, `barcode_widget`, `cupertino_icons`, `flutter_pdfview`, `flutter_spinkit`, `http`, `path`, `path_provider`, `toast`, `carousel_slider`, `pull_to_refresh`, `modal_progress_hud_nsn`, `font_awesome_flutter`, `auto_size_text`, `barcode`, `network_handler`, `json_annotation`, `full_screen_image`, `http_parser`

**Candidates for removal:**
- `in_app_webview` (^0.0.9) — duplicate of `flutter_inappwebview`
- `change_app_package_name` — one-time dev tool, not needed at runtime

## Phase 3: Regenerate Android Folder

1. Delete current (empty) `android/` tracked state
2. Run `flutter create --platforms android .` to generate fresh Android folder
3. This gives: modern AGP 8.x, Gradle 8.x, Kotlin 1.9+, declarative gradle setup

**Re-apply from `android_Ori/`:**

| Config | Source | Destination |
|--------|--------|-------------|
| applicationId | `android_Ori/app/build.gradle` → `com.evoweb.ninecoms` | New `android/app/build.gradle` |
| Signing config | `android_Ori/app/build.gradle` (keystore block) | New `android/app/build.gradle` |
| Firebase | `android_Ori/app/google-services.json` | New `android/app/google-services.json` |
| google-services plugin | `android_Ori/build.gradle` | New `android/build.gradle` |
| minSdkVersion | 34 (from `android_Ori`) | Verify appropriate for target audience |
| targetSdkVersion | Set to **35** | Required by Google Play |
| compileSdkVersion | Set to **35** | Match targetSdk |

**16 KB page size:** Flutter 3.22+ builds with page-aligned native libraries by default. No manual `android:extractNativeLibs` config needed — it's handled by the engine.

## Phase 4: Launcher Icons

After Android folder is regenerated:
1. Verify `flutter_launcher_icons.yaml` config still correct
2. Run `flutter pub run flutter_launcher_icons:main`
3. Verify icons in `android/app/src/main/res/mipmap-*` directories

## Phase 5: Build Verification

1. `flutter analyze` — zero errors
2. `flutter build apk --release` — successful APK
3. Verify APK supports 16 KB page sizes: `zipalign -c -P 16 -v 4 app-release.apk`
4. Test on device/emulator — app launches, login works, core flows functional

## Out of Scope

- iOS changes (iOS folder is intact and not affected by this policy)
- State management refactor
- Code quality improvements beyond what's needed for Dart 3 compatibility
- New features

## Risk Mitigation

- Work on a dedicated branch (`feature/flutter-dart3-migration`)
- `android_Ori/` preserved as reference for config values
- Each phase can be committed independently for easy rollback
- If a dependency can't be upgraded, evaluate if it can be replaced or removed

## Files Changed (Estimated)

- `pubspec.yaml` — SDK constraint + dependency versions
- `pubspec.lock` — regenerated
- `lib/apptheme/apptheme.dart` — deprecated API fixes (3 changes)
- `lib/features/profile/ui/helps_page.dart` — deprecated API fix (1 change)
- `lib/firebase_options.dart` — potentially regenerated
- `android/` — entirely regenerated
- Any files using dio, image_picker, webview if APIs changed
