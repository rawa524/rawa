#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
SDK="${ANDROID_HOME:-/workspace/.android-tools/sdk}"
ECJ="${ECJ_JAR:-/workspace/.android-tools/ecj.jar}"
TOOLS="$SDK/build-tools/35.0.0"
PLATFORM="$SDK/platforms/android-35/android.jar"
BUILD="$(pwd)/build"
SIGNING="${ROZHANA_SIGNING_DIR:-/workspace/.android-tools/signing}"
mkdir -p "$BUILD/classes" "$BUILD/assets" ../dist "$SIGNING"
cp ../index.html "$BUILD/assets/index.html"
"$TOOLS/aapt2" compile --dir res -o "$BUILD/resources.zip"
"$TOOLS/aapt2" link -o "$BUILD/base.apk" -I "$PLATFORM" --manifest AndroidManifest.xml -A "$BUILD/assets" "$BUILD/resources.zip"
java -jar "$ECJ" -8 -encoding UTF-8 -bootclasspath "$PLATFORM" -d "$BUILD/classes" src/com/rozhana/tasks/MainActivity.java
(cd "$BUILD/classes" && zip -q -r "$BUILD/classes.jar" .)
"$TOOLS/d8" --lib "$PLATFORM" --min-api 26 --output "$BUILD" "$BUILD/classes.jar"
cp "$BUILD/base.apk" "$BUILD/unsigned.apk"
(cd "$BUILD" && zip -q unsigned.apk classes.dex)
"$TOOLS/zipalign" -f -p 4 "$BUILD/unsigned.apk" "$BUILD/aligned.apk"
if [ ! -f "$SIGNING/development.jks" ]; then
  keytool -genkeypair -keystore "$SIGNING/development.jks" -storepass android -keypass android -alias androiddebugkey -dname 'CN=Rozhana Development' -keyalg RSA -keysize 2048 -validity 10000
fi
"$TOOLS/apksigner" sign --ks "$SIGNING/development.jks" --ks-pass pass:android --key-pass pass:android --out ../dist/rozhana.apk "$BUILD/aligned.apk"
"$TOOLS/apksigner" verify --verbose ../dist/rozhana.apk
"$TOOLS/aapt2" dump badging ../dist/rozhana.apk
sha256sum ../dist/rozhana.apk
