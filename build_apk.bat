@echo off
echo ==================================================
echo    Emmar Films ^& Music - OTT Platform Builder
echo ==================================================
echo.

:: Set Flutter PATH
set PATH=%PATH%;c:\Users\RIZWAN\Documents\OTT Platform\flutter\bin

:: Navigate to project directory
cd /d "c:\Users\RIZWAN\Documents\OTT Platform\emmar_ott_platform"

echo Checking Flutter installation...
flutter --version
echo.

echo Getting dependencies...
flutter pub get
echo.

echo Analyzing code...
flutter analyze --no-fatal-infos
echo.

echo Building APK (Debug)...
flutter build apk --debug
echo.

echo ==================================================
echo Build Complete!
echo.
echo APK Location: build\app\outputs\flutter-apk\
echo File: app-debug.apk
echo.
echo To build release APK, run:
echo flutter build apk --release
echo ==================================================

pause