# AppNotes Packaging Guide

This document describes how to create installable packages for AppNotes on all supported platforms.

## Prerequisites

- Flutter SDK 3.11.0+
- Dart SDK 3.0+
- Platform-specific tools (see below)

## Quick Start

```bash
# Build and package for current platform
./scripts/build.sh && ./scripts/package.sh

# Build and package for all platforms
./scripts/build.sh --platform all && ./scripts/package.sh --platform all
```

## Platform-Specific Packaging

### Windows

#### Requirements
- Windows 10/11 or Wine on Linux
- Inno Setup 6 (for installer)
- Optional: MSIX packaging tools

#### Output Formats
1. **ZIP Archive**: Portable version
2. **Setup.exe**: Inno Setup installer
3. **MSIX**: Microsoft Store package

#### Commands
```bash
./scripts/build.sh --platform windows
./scripts/package.sh --platform windows --version 1.0.0
```

#### Manual Steps

**Create ZIP:**
```powershell
Compress-Archive -Path "build/windows/x64/runner/Release/*" -DestinationPath "appnotes-1.0.0-windows.zip"
```

**Create MSIX:**
```bash
flutter pub run msix:create
```

### macOS

#### Requirements
- macOS 10.14+
- Xcode 12+
- create-dmg (optional, for DMG creation)

#### Output Formats
1. **App Bundle**: .app directory
2. **DMG**: Disk image with installer
3. **ZIP**: Compressed app bundle

#### Commands
```bash
./scripts/build.sh --platform macos
./scripts/package.sh --platform macos --version 1.0.0
```

#### Manual Steps

**Create DMG:**
```bash
create-dmg \
  --volname "AppNotes Installer" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --app-drop-link 600 185 \
  "appnotes-1.0.0.dmg" \
  "build/macos/Build/Products/Release/AppNotes.app"
```

**Sign and Notarize:**
```bash
# Sign
codesign --deep --force --verify --verbose --sign "Developer ID" AppNotes.app

# Create DMG
create-dmg ...

# Notarize
xcrun altool --notarize-app --primary-bundle-id "com.appnotes.editor" --username "apple@id.com" --password "@keychain:AC_PASSWORD" --file appnotes-1.0.0.dmg
```

### Linux

#### Requirements
- Ubuntu 20.04+ or compatible
- dpkg-deb (for .deb packages)
- appimagetool (optional, for AppImage)

#### Output Formats
1. **Tarball**: .tar.gz archive
2. **DEB**: Debian/Ubuntu package
3. **AppImage**: Universal Linux package

#### Commands
```bash
./scripts/build.sh --platform linux
./scripts/package.sh --platform linux --version 1.0.0
```

#### Manual Steps

**Create Tarball:**
```bash
cd build/linux/x64/release
tar -czf appnotes-1.0.0-linux-x64.tar.gz bundle/
```

**Create DEB Package:**
```bash
# Create package structure
mkdir -p deb_build/appnotes/DEBIAN
mkdir -p deb_build/appnotes/usr/share/appnotes
mkdir -p deb_build/appnotes/usr/share/applications
mkdir -p deb_build/appnotes/usr/share/icons/hicolor/256x256/apps
mkdir -p deb_build/appnotes/usr/bin

# Copy files
cp -r build/linux/x64/release/bundle/* deb_build/appnotes/usr/share/appnotes/
cp linux/appnotes.desktop deb_build/appnotes/usr/share/applications/
cp assets/icons/app_icon.png deb_build/appnotes/usr/share/icons/hicolor/256x256/apps/appnotes.png

# Create launcher
cat > deb_build/appnotes/usr/bin/appnotes << 'EOF'
#!/bin/bash
exec /usr/share/appnotes/app_notes "$@"
EOF
chmod +x deb_build/appnotes/usr/bin/appnotes

# Create control file
cat > deb_build/appnotes/DEBIAN/control << EOF
Package: appnotes
Version: 1.0.0
Section: editors
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libblkid1, liblzma5
Maintainer: AppNotes Team <support@appnotes.dev>
Description: AppNotes Markdown Editor
 A modern, fast, and beautiful Markdown editor
 for desktop platforms.
EOF

# Build package
dpkg-deb --build deb_build/appnotes appnotes-1.0.0.deb
```

## Version Numbering

AppNotes follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible API changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

Format: `MAJOR.MINOR.PATCH` (e.g., `1.0.0`)

## Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update version in `scripts/package.sh`
- [ ] Update `CHANGELOG.md`
- [ ] Run all tests
- [ ] Build for all platforms
- [ ] Test on all platforms
- [ ] Create packages
- [ ] Sign packages (macOS, Windows)
- [ ] Create GitHub release
- [ ] Upload packages to release
- [ ] Update download links
- [ ] Announce release

## Automated CI/CD

### GitHub Actions Workflow

Create `.github/workflows/release.yml`:

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.11.0'
      - name: Build
        run: |
          flutter pub get
          flutter build windows --release
      - name: Package
        run: |
          Compress-Archive -Path build/windows/x64/runner/Release/* -DestinationPath appnotes-windows.zip
      - name: Upload
        uses: actions/upload-artifact@v3
        with:
          name: windows-package
          path: appnotes-windows.zip

  build-macos:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.11.0'
      - name: Build
        run: |
          flutter pub get
          flutter build macos --release
      - name: Package
        run: |
          brew install create-dmg
          create-dmg --volname "AppNotes" --window-size 800 400 --icon-size 100 --app-drop-link 600 185 appnotes-macos.dmg build/macos/Build/Products/Release/AppNotes.app
      - name: Upload
        uses: actions/upload-artifact@v3
        with:
          name: macos-package
          path: appnotes-macos.dmg

  build-linux:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.11.0'
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y ninja-build libgtk-3-dev
      - name: Build
        run: |
          flutter pub get
          flutter build linux --release
      - name: Package
        run: |
          cd build/linux/x64/release
          tar -czf ../../../appnotes-linux.tar.gz bundle/
      - name: Upload
        uses: actions/upload-artifact@v3
        with:
          name: linux-package
          path: appnotes-linux.tar.gz

  release:
    needs: [build-windows, build-macos, build-linux]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v3
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: |
            **/appnotes-*.zip
            **/appnotes-*.dmg
            **/appnotes-*.tar.gz
```

## Troubleshooting

### Windows

**Issue**: Build fails with missing Visual Studio
- **Solution**: Install Visual Studio 2019 or 2022 with "Desktop development with C++" workload

**Issue**: MSIX creation fails
- **Solution**: Ensure you have the msix package in dev_dependencies

### macOS

**Issue**: Codesign fails
- **Solution**: Ensure you have a valid Developer ID certificate installed

**Issue**: App won't open (damaged)
- **Solution**: Notarization is required for distribution outside App Store

### Linux

**Issue**: Missing GTK dependencies
- **Solution**: Install libgtk-3-dev package

**Issue**: DEB package conflicts
- **Solution**: Check dependencies in control file

## Resources

- [Flutter Desktop Documentation](https://docs.flutter.dev/desktop)
- [Inno Setup Documentation](http://www.jrsoftware.org/isinfo.php)
- [Apple Code Signing](https://developer.apple.com/support/code-signing/)
- [Debian Packaging Guide](https://www.debian.org/doc/manuals/debian-faq/pkg-basics.en.html)
