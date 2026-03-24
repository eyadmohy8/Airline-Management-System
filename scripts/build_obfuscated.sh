#!/bin/bash

# Build script for obfuscated Flutter APK/IPA
# Usage: ./scripts/build_obfuscated.sh [android|ios]

TARGET_OS=$1

if [ -z "$TARGET_OS" ]; then
  echo "Usage: ./build_obfuscated.sh [android|ios]"
  exit 1
fi

# Create directory for debug info if it doesn't exist
mkdir -p build/debug-info

if [ "$TARGET_OS" == "android" ]; then
  echo "Building obfuscated Android APK..."
  flutter build apk --obfuscate --split-debug-info=build/debug-info
elif [ "$TARGET_OS" == "ios" ]; then
  echo "Building obfuscated iOS IPA..."
  flutter build ios --obfuscate --split-debug-info=build/debug-info
else
  echo "Invalid target OS. Use 'android' or 'ios'."
  exit 1
fi

echo "Build complete. Debug info saved to build/debug-info"
