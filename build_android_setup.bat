@echo off
echo ========================================
echo Flutter OTT Platform - Android Setup
echo ========================================

echo.
echo Step 1: Adding Flutter to PATH...
set PATH=%PATH%;C:\Users\RIZWAN\Documents\OTT Platform\flutter\bin

echo.
echo Step 2: Checking Flutter installation...
flutter --version

echo.
echo Step 3: Checking Flutter doctor...
flutter doctor

echo.
echo ========================================
echo ANDROID SDK SETUP REQUIRED
echo ========================================
echo.
echo To build APK, you need Android SDK. Here are your options:
echo.
echo Option 1 - Install Android Studio (Recommended):
echo   1. Download from: https://developer.android.com/studio
echo   2. Install Android Studio
echo   3. Open Android Studio and install SDK
echo   4. Run this script again
echo.
echo Option 2 - Manual SDK Setup:
echo   1. Download Android SDK Command Line Tools
echo   2. Extract to C:\Android\sdk
echo   3. Set ANDROID_HOME environment variable
echo   4. Install platform-tools and build-tools
echo.
echo Option 3 - Use Flutter Web (No Android SDK needed):
echo   Run: flutter build web
echo   Then serve the web build on your phone's browser
echo.

echo Press any key to continue with web build...
pause >nul

echo.
echo Building Flutter Web version...
flutter build web

echo.
echo Web build completed! 
echo You can find the web build in: build\web\
echo.
echo To run on phone:
echo 1. Copy the build\web folder to a web server
echo 2. Or use: python -m http.server 8000 (in build\web folder)
echo 3. Access from phone: http://your-computer-ip:8000
echo.

pause