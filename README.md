# local ai cam for mobile

Turn any old unused mobile phone into a hyper-smart, 100% offline, local Edge-AI CCTV camera! Features real-time human/intruder detection, YOLOv8/MobileNetV4 vision engines, motion vector tracking, night vision HUD, and automated siren alerts — Zero cloud, zero subscription, 100% private.

## Direct Release Installers & Platform Downloads

When a release tag (e.g. `v1.0.0`) is published on GitHub, the automated GitHub Actions CI pipeline builds and uploads individual platform installers to **GitHub Releases Assets**:

- 📱 **Android Direct APK**: `local-ai-cam-android-installer.apk` (Direct one-click APK installation on mobile)
- 🌐 **Web App Bundle**: `local-ai-cam-web.zip`
- 🐧 **Linux Desktop App**: `local-ai-cam-linux.zip`

## Features
- **100% Offline & Local Execution**: Zero API keys or cloud dependencies needed. Works completely offline to protect privacy and save network bandwidth.
- **Advanced AI Vision Models (15/10/2026 Edge Standard)**:
  - **Ultra CCTV Security Pro**: Human detection, intruder alerts, face recognition, and motion tracking.
  - **Hyper YOLOv8 Nano Vision**: Ultra-fast multi-object detection.
  - **Edge Lightweight MobileNetV4 Micro**: Optimized for smooth performance on low-end or old mobile hardware.
- **Smart Live Surveillance HUD**: Dynamic FPS tracking, Night Vision enhancement filter, custom bounding box painter with corner HUD accents, and automated siren triggers.
- **Intruder & Security Threat Logs**: Automated history logging of high-confidence threats with timestamps and alert levels.
- **Custom Sensitivity Settings**: Adjustable confidence thresholds and motion vector tracking.

## How to Build Release APK Locally
If you want to compile the release APK manually on your machine:
```bash
flutter pub get
flutter build apk --release
```
The compiled APK file will be located at:
`build/app/outputs/flutter-apk/app-release.apk`
