# Android APK Build Guide for Flutter OTT Platform

## Quick Setup Options

### Option 1: Android Studio (Recommended - Easy Setup)

1. **Download Android Studio:**
   - Go to: https://developer.android.com/studio
   - Download and install Android Studio

2. **Setup Android SDK:**
   - Open Android Studio
   - Go to Tools > SDK Manager
   - Install:
     - Android SDK Platform-Tools
     - Android SDK Build-Tools (latest version)
     - Android API 34 (or latest)

3. **Build APK:**
   ```bash
   flutter build apk --release
   ```

### Option 2: Command Line Tools Only (Advanced)

1. **Download SDK Command Line Tools:**
   - Download from: https://developer.android.com/studio#command-tools
   - Extract to: `C:\Android\sdk`

2. **Set Environment Variables:**
   ```cmd
   setx ANDROID_HOME "C:\Android\sdk"
   setx PATH "%PATH%;%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools"
   ```

3. **Install Required Components:**
   ```cmd
   sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
   ```

4. **Accept Licenses:**
   ```cmd
   flutter doctor --android-licenses
   ```

5. **Build APK:**
   ```cmd
   flutter build apk --release
   ```

### Option 3: Web Build for Mobile (No Android SDK Required)

1. **Build for Web:**
   ```cmd
   flutter build web
   ```

2. **Serve on Local Network:**
   ```cmd
   cd build\web
   python -m http.server 8080
   ```

3. **Access on Phone:**
   - Find your computer's IP: `ipconfig`
   - Open browser on phone: `http://YOUR_IP:8080`

## APK Installation on Phone

Once you have the APK built:

1. **Enable Unknown Sources:**
   - Settings > Security > Unknown Sources (Enable)

2. **Transfer APK:**
   - Copy `build\app\outputs\flutter-apk\app-release.apk` to phone
   - Or use USB/ADB: `adb install app-release.apk`

3. **Install:**
   - Tap the APK file on phone to install

## Troubleshooting

### Common Issues:

1. **Flutter Doctor Issues:**
   ```cmd
   flutter doctor -v
   ```

2. **Android License Issues:**
   ```cmd
   flutter doctor --android-licenses
   ```

3. **Build Failures:**
   - Check `android/build.gradle` for correct versions
   - Ensure internet connection for dependency downloads

### Build Commands:

- **Debug APK:** `flutter build apk --debug`
- **Release APK:** `flutter build apk --release`
- **Split APKs:** `flutter build apk --split-per-abi`
- **App Bundle:** `flutter build appbundle`

## File Locations

After successful build:
- **APK Location:** `build\app\outputs\flutter-apk\app-release.apk`
- **App Bundle:** `build\app\outputs\bundle\release\app-release.aab`
- **Web Build:** `build\web\`

## Next Steps

1. Test the APK on your phone
2. For Play Store: Use `flutter build appbundle`
3. Sign APK for distribution (if needed)

---

*Generated for Emmar OTT Platform Flutter App*