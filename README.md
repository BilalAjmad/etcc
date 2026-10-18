# Smart AI CCTV Camera App (Turn Old Mobile Phones into AI CCTV)

A high-performance, 100% offline, local edge AI surveillance camera application designed to repurpose old Android mobile devices into hyper-smart CCTV security cameras.

## Features
- **100% Offline & Local Execution**: Zero API keys or cloud dependencies needed. Works completely offline to protect privacy and save network bandwidth.
- **Advanced AI Vision Models (15/10/2026 Edge Standard)**:
  - **Ultra CCTV Security Pro**: Human detection, intruder alerts, face recognition, and motion tracking.
  - **Hyper YOLOv8 Nano Vision**: Ultra-fast multi-object detection.
  - **Edge Lightweight MobileNetV4 Micro**: Optimized for smooth performance on low-end or old mobile hardware.
- **Smart Live Surveillance HUD**: Dynamic FPS tracking, Night Vision enhancement filter, custom bounding box painter with corner HUD accents, and automated siren triggers.
- **Intruder & Security Threat Logs**: Automated history logging of high-confidence threats with timestamps and alert levels.
- **Custom Sensitivity Settings**: Adjustable confidence thresholds and motion vector tracking.

## Direct APK Download & GitHub Release
This project includes a **GitHub Actions CI/CD Workflow** (`.github/workflows/release.yml`).

Whenever you push to the `main` branch or publish a new version tag (e.g., `v1.0.0`), GitHub automatically builds `app-release.apk` and uploads it directly to your **GitHub Releases** page so users can download and install the APK directly on their mobile phones!

### How to Build Release APK Locally
If you want to compile the release APK on your machine:
```bash
flutter pub get
flutter build apk --release
```
The compiled APK file will be located at:
`build/app/outputs/flutter-apk/app-release.apk`
