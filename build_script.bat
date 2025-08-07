@echo off
REM NASA Explorer Build Script for Windows
REM This script helps build the app with proper configurations

echo 🚀 NASA Explorer Build Script
echo ==============================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    pause
    exit /b 1
)

REM Get Flutter version
for /f "tokens=*" %%i in ('flutter --version') do (
    echo 📱 Flutter Version: %%i
    goto :continue
)
:continue

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Generate code
echo 🔧 Generating code...
flutter packages pub run build_runner build --delete-conflicting-outputs

REM Build for different platforms
echo 🏗️  Building for different platforms...

REM Android build
echo 📱 Building for Android...
flutter build apk --release

REM Web build
echo 🌐 Building for Web...
flutter build web --release

REM Windows build
echo 🪟 Building for Windows...
flutter build windows --release

echo ✅ Build completed successfully!
echo 📁 Build outputs:
echo    - Android APK: build\app\outputs\flutter-apk\app-release.apk
echo    - Web: build\web\
echo    - Windows: build\windows\runner\Release\

echo.
echo 🎉 NASA Explorer app is ready for deployment!
pause 