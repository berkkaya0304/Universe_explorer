#!/bin/bash

# NASA Explorer Build Script
# This script helps build the app with proper configurations

echo "🚀 NASA Explorer Build Script"
echo "=============================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Get Flutter version
echo "📱 Flutter Version: $(flutter --version | head -n 1)"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code
echo "🔧 Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build for different platforms
echo "🏗️  Building for different platforms..."

# Android build
echo "📱 Building for Android..."
flutter build apk --release

# iOS build (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building for iOS..."
    flutter build ios --release --no-codesign
else
    echo "⚠️  Skipping iOS build (not on macOS)"
fi

# Web build
echo "🌐 Building for Web..."
flutter build web --release

# Windows build (if on Windows)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "🪟 Building for Windows..."
    flutter build windows --release
else
    echo "⚠️  Skipping Windows build (not on Windows)"
fi

# Linux build (if on Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Building for Linux..."
    flutter build linux --release
else
    echo "⚠️  Skipping Linux build (not on Linux)"
fi

echo "✅ Build completed successfully!"
echo "📁 Build outputs:"
echo "   - Android APK: build/app/outputs/flutter-apk/app-release.apk"
echo "   - Web: build/web/"
echo "   - iOS: build/ios/archive/Runner.xcarchive"
echo "   - Windows: build/windows/runner/Release/"
echo "   - Linux: build/linux/x64/release/bundle/"

echo ""
echo "🎉 NASA Explorer app is ready for deployment!" 