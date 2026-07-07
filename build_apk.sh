#!/bin/bash
set -e

# Define directories
WORKSPACE_DIR="/workspaces/HTML-games"
SDK_DIR="$WORKSPACE_DIR/android-sdk"
WWW_DIR="$WORKSPACE_DIR/www"

echo "=== Step 1: Preparing web files ==="
mkdir -p "$WWW_DIR"
cp "$WORKSPACE_DIR/index.html" "$WWW_DIR/index.html"

echo "=== Step 2: Initializing NPM package ==="
if [ ! -f "$WORKSPACE_DIR/package.json" ]; then
  npm init -y
fi

echo "=== Step 3: Installing Capacitor dependencies ==="
npm install @capacitor/core@latest @capacitor/cli@latest @capacitor/android@latest

echo "=== Step 4: Initializing Capacitor project ==="
if [ ! -f "$WORKSPACE_DIR/capacitor.config.json" ] && [ ! -f "$WORKSPACE_DIR/capacitor.config.ts" ]; then
  npx cap init "Contacts Manager" "com.example.contactsmanager" --web-dir=www
fi

echo "=== Step 5: Adding Android platform ==="
if [ ! -d "$WORKSPACE_DIR/android" ]; then
  npx cap add android
fi

echo "=== Step 6: Syncing web assets to Android project ==="
npx cap sync android

echo "=== Step 7: Compiling APK using Gradle ==="
export ANDROID_HOME="$SDK_DIR"
export JAVA_HOME="/usr/local/sdkman/candidates/java/21.0.10-ms"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$JAVA_HOME/bin:$PATH"

cd "$WORKSPACE_DIR/android"
chmod +x gradlew
./gradlew assembleDebug

echo "=== Success! ==="
echo "The APK has been generated successfully!"
find app/build/outputs/apk/ -name "*.apk" -print
