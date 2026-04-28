# Flutter Dart 3 Migration & 16 KB Page Size Compliance - Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the 9Coin Flutter app to Dart 3.x and regenerate the Android folder so the app builds with Flutter 3.38.5 and supports 16 KB memory page sizes (Google Play deadline: May 31, 2026).

**Architecture:** Incremental migration on a feature branch. Each task is independently committable. Phase order: SDK constraint -> Dart code fixes -> dependency upgrades -> Android regeneration -> config re-apply -> icons -> build verification.

**Tech Stack:** Flutter 3.38.5, Dart 3.10.4, AGP 8.x, Gradle 8.x, Kotlin 1.9+

---

### Task 1: Create Feature Branch

**Files:** None (git only)

- [ ] **Step 1: Create and switch to the feature branch**

```bash
git checkout -b feature/flutter-dart3-migration
```

Expected: Branch created, switched to `feature/flutter-dart3-migration`.

---

### Task 2: Bump SDK Constraint to Dart 3

**Files:**
- Modify: `pubspec.yaml:7-8`

- [ ] **Step 1: Update the SDK constraint in pubspec.yaml**

In `pubspec.yaml`, change:

```yaml
environment:
  sdk: ">=2.17.0 <3.0.0"
```

To:

```yaml
environment:
  sdk: ">=3.0.0 <4.0.0"
```

- [ ] **Step 2: Commit**

```bash
git add pubspec.yaml
git commit -m "chore: bump SDK constraint to Dart 3.x"
```

---

### Task 3: Fix Deprecated APIs in apptheme.dart

**Files:**
- Modify: `lib/apptheme/apptheme.dart:34,43`

- [ ] **Step 1: Replace MaterialStateProperty with WidgetStateProperty**

In `lib/apptheme/apptheme.dart`, line 34, change:

```dart
      labelTextStyle: MaterialStateProperty.all(CoinTextStyle.title4),
```

To:

```dart
      labelTextStyle: WidgetStateProperty.all(CoinTextStyle.title4),
```

- [ ] **Step 2: Replace deprecated `primary` with `backgroundColor`**

In `lib/apptheme/apptheme.dart`, line 43, change:

```dart
        primary: CoinColors.orange,
```

To:

```dart
        backgroundColor: CoinColors.orange,
```

- [ ] **Step 3: Commit**

```bash
git add lib/apptheme/apptheme.dart
git commit -m "fix: replace deprecated MaterialStateProperty and primary in apptheme"
```

---

### Task 4: Fix Deprecated API in helps_page.dart

**Files:**
- Modify: `lib/features/profile/ui/helps_page.dart:61`

- [ ] **Step 1: Replace deprecated `primary` with `backgroundColor`**

In `lib/features/profile/ui/helps_page.dart`, line 60-61, change:

```dart
                style: ElevatedButton.styleFrom(
                  primary: CoinColors.green,
                ),
```

To:

```dart
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoinColors.green,
                ),
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/profile/ui/helps_page.dart
git commit -m "fix: replace deprecated primary parameter in helps_page"
```

---

### Task 5: Upgrade Dependencies

**Files:**
- Modify: `pubspec.yaml` (dependency versions)
- Regenerated: `pubspec.lock`

- [ ] **Step 1: Remove duplicate/unnecessary dependencies**

In `pubspec.yaml`, remove these two lines from the `dependencies:` section:

```yaml
  in_app_webview: ^0.0.9
```

and:

```yaml
  change_app_package_name: ^1.1.0
```

- [ ] **Step 2: Run major version upgrade**

```bash
flutter pub upgrade --major-versions
```

This will update `pubspec.yaml` version constraints and regenerate `pubspec.lock`. Review the output for any packages that failed to resolve.

- [ ] **Step 3: If pub upgrade fails to resolve, manually fix constraints**

If there are resolution conflicts, manually set these known-compatible versions in `pubspec.yaml`:

```yaml
  dio: ^5.4.0
  firebase_core: ^3.3.0
  firebase_messaging: ^15.0.0
  flutter_inappwebview: ^6.0.0
  webview_flutter: ^4.8.0
  image_picker: ^1.1.0
  shared_preferences: ^2.3.0
  cached_network_image: ^3.4.0
  url_launcher: ^6.3.0
  flutter_launcher_icons: ^0.14.0
```

Then run:

```bash
flutter pub get
```

- [ ] **Step 4: Run flutter analyze to check for compile errors**

```bash
flutter analyze
```

Review errors. Most will be from API changes in upgraded packages (handled in Tasks 6-8).

- [ ] **Step 5: Commit dependency changes**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: upgrade all dependencies to Dart 3-compatible versions"
```

---

### Task 6: Fix Dio 5.x API Changes

**Files:**
- Modify: `lib/features/point/api/transaction.dart:3,19`

Dio 5.x renames `DioError` to `DioException` and changes some constructor signatures. The `transaction` class in this file uses `Dio()` and `dio.download()`.

- [ ] **Step 1: Check if Dio usage still compiles**

The usage in `lib/features/point/api/transaction.dart` uses basic `Dio()` constructor and `dio.download()`. These APIs are stable across Dio 4->5. The file also catches generic `catch (e)`, not `DioError`, so no rename is needed.

Verify with:

```bash
flutter analyze lib/features/point/api/transaction.dart
```

Expected: No errors from this file. If there are errors, the error message will indicate what changed.

- [ ] **Step 2: Check edit_profile_page.dart Dio import**

`lib/features/profile/ui/edit_profile_page.dart` imports `dio` but never uses any Dio class directly — it only uses `http` package. The import is unused.

Remove the unused import on line 4:

```dart
import 'package:dio/dio.dart';
```

- [ ] **Step 3: Commit if changes were needed**

```bash
git add lib/features/point/api/transaction.dart lib/features/profile/ui/edit_profile_page.dart
git commit -m "fix: update Dio usage for v5 compatibility, remove unused import"
```

---

### Task 7: Fix flutter_inappwebview 6.x API Changes

**Files:**
- Modify: `lib/features/point/ui/in_app_webview_page.dart`
- Modify: `lib/features/point/ui/package_buy_page.dart:10`

- [ ] **Step 1: Update InAppWebView constructor in in_app_webview_page.dart**

In `lib/features/point/ui/in_app_webview_page.dart`, `initialOptions` was renamed to `initialSettings` and the options classes changed. Replace the full file content:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  final String url;

  const InAppWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('9Com'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            initialSettings: InAppWebViewSettings(
              useOnDownloadStart: true,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
            onDownloadStartRequest: (controller, request) async {
              // Handle file downloads here if needed
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
```

Key changes:
- `Uri.parse(widget.url)` -> `WebUri(widget.url)`
- `initialOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(...))` -> `initialSettings: InAppWebViewSettings(...)`
- `onDownloadStart` -> `onDownloadStartRequest` with `DownloadStartRequest` parameter

- [ ] **Step 2: Remove the `in_app_webview` import from package_buy_page.dart**

In `lib/features/point/ui/package_buy_page.dart`, line 10, remove:

```dart
import 'package:in_app_webview/in_app_webview.dart';
```

This import was for the removed `in_app_webview` package (duplicate of `flutter_inappwebview`). It's not used in the file — the file uses the local `InAppWebViewPage` widget from `in_app_webview_page.dart`.

- [ ] **Step 3: Verify**

```bash
flutter analyze lib/features/point/ui/in_app_webview_page.dart lib/features/point/ui/package_buy_page.dart
```

Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/point/ui/in_app_webview_page.dart lib/features/point/ui/package_buy_page.dart
git commit -m "fix: update flutter_inappwebview to v6 API, remove duplicate in_app_webview"
```

---

### Task 8: Fix webview_flutter 4.x API Changes

**Files:**
- Modify: `lib/features/point/services/url_launcher.dart`

In webview_flutter 4.x, the `WebView` widget was replaced with `WebViewWidget` + `WebViewController`.

- [ ] **Step 1: Rewrite url_launcher.dart for webview_flutter 4.x**

Replace the full content of `lib/features/point/services/url_launcher.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);
  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

launchUrl(String url, BuildContext context) {
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => WebViewScreen(url: url)));
}
```

Key changes:
- Removed `WebView.platform = AndroidWebView()` (no longer needed)
- Removed `dart:io` import (no longer needed)
- `WebView(initialUrl:)` widget replaced with `WebViewWidget(controller:)`
- `WebViewController` created in `initState` with URL loaded via `loadRequest()`

- [ ] **Step 2: Verify**

```bash
flutter analyze lib/features/point/services/url_launcher.dart
```

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/point/services/url_launcher.dart
git commit -m "fix: update webview_flutter to v4 API (WebViewWidget + controller)"
```

---

### Task 9: Run Full Analysis and Fix Remaining Errors

**Files:** Any files flagged by `flutter analyze`

- [ ] **Step 1: Run full analysis**

```bash
flutter analyze
```

- [ ] **Step 2: Fix any remaining errors**

Review each error. Common issues at this point:
- Unused imports from removed packages
- Type mismatches from upgraded package APIs
- Deprecated constructors

Fix each error based on the specific message.

- [ ] **Step 3: Commit all remaining fixes**

```bash
git add -A
git commit -m "fix: resolve remaining Dart 3 analysis errors"
```

---

### Task 10: Regenerate Android Folder

**Files:**
- Delete: `android/` (current empty/deleted tracked state)
- Create: entire `android/` directory (via flutter create)

- [ ] **Step 1: Remove the stale android directory tracking**

```bash
git rm -r android/ 2>/dev/null || true
```

- [ ] **Step 2: Regenerate android folder**

```bash
flutter create --platforms android .
```

This generates a fresh `android/` folder with modern tooling (AGP 8.x, Gradle 8.x, Kotlin 1.9+).

- [ ] **Step 3: Verify the new android folder was created**

```bash
ls android/app/build.gradle.kts 2>/dev/null || ls android/app/build.gradle
```

Expected: One of these files exists (newer Flutter uses `.kts` Kotlin DSL).

- [ ] **Step 4: Commit the regenerated android folder**

```bash
git add android/
git commit -m "chore: regenerate android folder with Flutter 3.38.5"
```

---

### Task 11: Re-apply Android Configuration

**Files:**
- Modify: `android/app/build.gradle` or `android/app/build.gradle.kts`
- Modify: `android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Set applicationId**

In the new `android/app/build.gradle` (or `.kts`), find the `defaultConfig` block and set:

```
applicationId = "com.evoweb.ninecoms"
```

- [ ] **Step 2: Set SDK versions**

In the same `defaultConfig` block, set:

```
minSdk = 34
targetSdk = 35
compileSdk = 35
```

Note: `compileSdk` may be in the `android {}` block above `defaultConfig`.

- [ ] **Step 3: Add signing config**

Add the signing configuration. For Groovy (`build.gradle`):

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

For Kotlin DSL (`.kts`), adjust syntax accordingly:

```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

- [ ] **Step 4: Update AndroidManifest.xml**

In `android/app/src/main/AndroidManifest.xml`, add the following attributes and elements from the original manifest:

1. Add permissions before `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

2. Add `<queries>` block before `<application>`:

```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="sms" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="tel" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" />
  </intent>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="http" />
  </intent>
</queries>
```

3. On the `<application>` tag, add:

```xml
android:usesCleartextTraffic="true"
android:label="9Com"
android:icon="@mipmap/launcher_icon"
```

4. On the main `<activity>` tag, add deep linking config:

```xml
<meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="http" />
    <data android:scheme="https" />
</intent-filter>
```

- [ ] **Step 5: Commit**

```bash
git add android/
git commit -m "chore: re-apply applicationId, signing, permissions, and manifest config"
```

---

### Task 12: Re-apply Firebase Configuration

**Files:**
- Copy: `android_Ori/app/google-services.json` -> `android/app/google-services.json`
- Modify: `android/build.gradle` or `android/settings.gradle.kts`
- Modify: `android/app/build.gradle` or `android/app/build.gradle.kts`

- [ ] **Step 1: Copy google-services.json**

```bash
cp android_Ori/app/google-services.json android/app/google-services.json
```

- [ ] **Step 2: Add google-services plugin**

For newer Flutter projects, the plugin may need to be added to `android/app/build.gradle` (or `.kts`).

Check if the generated project already includes Firebase plugin support. If not, add at the end of `android/app/build.gradle`:

```groovy
apply plugin: 'com.google.gms.google-services'
```

Or for `.kts`:

```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

And in `android/build.gradle` (root), add to `buildscript.dependencies`:

```groovy
classpath 'com.google.gms:google-services:4.4.0'
```

Or in `android/settings.gradle.kts`, add to `plugins {}`:

```kotlin
id("com.google.gms.google-services") version "4.4.0" apply false
```

Note: The exact location depends on whether Flutter generated Groovy or Kotlin DSL files. Read the generated files first and follow their pattern.

- [ ] **Step 3: Add Firebase BOM to app dependencies**

In `android/app/build.gradle` (or `.kts`), add to `dependencies`:

```groovy
implementation platform('com.google.firebase:firebase-bom:33.0.0')
implementation 'com.google.firebase:firebase-analytics'
```

Or for `.kts`:

```kotlin
implementation(platform("com.google.firebase:firebase-bom:33.0.0"))
implementation("com.google.firebase:firebase-analytics")
```

- [ ] **Step 4: Verify build compiles**

```bash
flutter build apk --debug 2>&1 | head -30
```

Expected: Build starts without Gradle configuration errors.

- [ ] **Step 5: Commit**

```bash
git add android/
git commit -m "chore: re-apply Firebase config (google-services.json + plugins)"
```

---

### Task 13: Regenerate Launcher Icons

**Files:**
- Modified: `android/app/src/main/res/mipmap-*/` directories

- [ ] **Step 1: Verify flutter_launcher_icons config**

Read `flutter_launcher_icons.yaml` (embedded in `pubspec.yaml`). It should still reference:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/logos/9-com-3.png"
```

Verify the image file exists:

```bash
ls assets/logos/9-com-3.png
```

Expected: File exists.

- [ ] **Step 2: Generate icons**

```bash
dart run flutter_launcher_icons
```

Expected: Icons generated for Android mipmap directories.

- [ ] **Step 3: Verify icons were created**

```bash
ls android/app/src/main/res/mipmap-hdpi/launcher_icon.png
```

Expected: File exists.

- [ ] **Step 4: Commit**

```bash
git add android/app/src/main/res/
git commit -m "chore: regenerate launcher icons for new android folder"
```

---

### Task 14: Build Verification

**Files:** None (verification only)

- [ ] **Step 1: Run full static analysis**

```bash
flutter analyze
```

Expected: No errors (warnings are acceptable).

- [ ] **Step 2: Build release APK**

```bash
flutter build apk --release
```

Expected: `BUILD SUCCESSFUL`. APK output at `build/app/outputs/flutter-apk/app-release.apk`.

- [ ] **Step 3: Verify 16 KB page size support**

On a machine with Android SDK build tools:

```bash
zipalign -c -P 16 -v 4 build/app/outputs/flutter-apk/app-release.apk
```

Expected: `Verification successful` — confirms native libraries are 16 KB page-aligned.

If `zipalign` is not available, this can be verified after uploading to Google Play Console — the console will report 16 KB compliance status.

- [ ] **Step 4: Final commit if any files changed during build**

```bash
git add -A
git status
```

If there are changes (e.g., generated plugin registrant files):

```bash
git commit -m "chore: update generated files after successful build"
```
