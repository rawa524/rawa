# Rozhana Android

Offline Android wrapper for the Kurdish task manager. Requires Android 8.0+ (API 26) with a current Android System WebView. Tasks are stored locally in the app's WebView storage. Uninstalling the app or clearing its data removes tasks. Browser tasks do not migrate into the app.

The APK requests no Internet or storage permissions. Its HTTPS origin is intercepted locally; no remote content is loaded. Deletion confirmations use an Android dialog.

## Build

Requirements: Java 21, Android SDK platform 35, build-tools 35.0.0, and Eclipse ECJ 3.40.0. Set `ANDROID_HOME` and `ECJ_JAR` if installed outside the defaults in `build.sh`.

```sh
bash build.sh
```

Output: `../dist/rozhana.apk`. The script signs with a local development key outside the repository (`ROZHANA_SIGNING_DIR`). This is a personal-install development build, not a Play Store release. Retain the same key for future upgrades; production distribution needs a protected release signing key.

Validated: Java compilation, Android packaging, alignment, APK v2/v3 signature verification, package identity, minimum SDK, embedded HTML matching source, and absence of requested permissions. Web task operations were previously exercised in a DOM environment. Device/emulator behavior has not been validated in this environment.
