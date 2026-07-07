#!/bin/bash
set -e

SDK_DIR="/workspaces/HTML-games/android-sdk"
mkdir -p "$SDK_DIR/cmdline-tools"

echo "Downloading Android Command Line Tools..."
wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O "$SDK_DIR/cmdline-tools.zip"

echo "Unzipping Command Line Tools..."
unzip -q "$SDK_DIR/cmdline-tools.zip" -d "$SDK_DIR/cmdline-tools"
rm "$SDK_DIR/cmdline-tools.zip"

# The unzip creates cmdline-tools/cmdline-tools. We must move its contents to cmdline-tools/latest
mv "$SDK_DIR/cmdline-tools/cmdline-tools" "$SDK_DIR/cmdline-tools/latest"

export ANDROID_HOME="$SDK_DIR"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

echo "Accepting licenses..."
yes | sdkmanager --licenses > /dev/null

echo "Installing platform-tools, platforms;android-34, and build-tools;34.0.0..."
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

echo "Android SDK setup completed successfully!"
