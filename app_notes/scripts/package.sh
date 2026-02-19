#!/bin/bash
#
# Package creation script for AppNotes
# Creates installable packages for all platforms
#

set -e

echo "========================================="
echo "AppNotes Packaging Script"
echo "========================================="

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
PLATFORM=""
VERSION="1.0.0"

while [[ $# -gt 0 ]]; do
  case $1 in
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    --version)
      VERSION="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --platform <platform>  Package for specific platform (windows, macos, linux, all)"
      echo "  --version <version>    Version number (default: 1.0.0)"
      echo "  --help                 Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0 --platform windows  Package for Windows"
      echo "  $0 --platform all      Package for all platforms"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Detect platform if not specified
if [ -z "$PLATFORM" ]; then
  case "$(uname -s)" in
    Linux*)     PLATFORM=linux ;;
    Darwin*)    PLATFORM=macos ;;
    CYGWIN*|MINGW*|MSYS*) PLATFORM=windows ;;
    *)          echo -e "${RED}Unknown platform${NC}"; exit 1 ;;
  esac
  echo -e "${YELLOW}Auto-detected platform: $PLATFORM${NC}"
fi

# Create output directory
OUTPUT_DIR="$PROJECT_DIR/packages"
mkdir -p "$OUTPUT_DIR"

package_windows() {
  echo -e "${BLUE}Packaging for Windows...${NC}"
  
  local BUILD_DIR="$PROJECT_DIR/build/windows/x64/runner/Release"
  if [ ! -d "$BUILD_DIR" ]; then
    BUILD_DIR="$PROJECT_DIR/build/windows/runner/Release"
  fi
  
  if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}Windows build not found. Run build.sh first.${NC}"
    return 1
  fi
  
  # Create ZIP archive
  local ZIP_NAME="appnotes-$VERSION-windows.zip"
  cd "$BUILD_DIR"
  zip -r "$OUTPUT_DIR/$ZIP_NAME" . -x "*.pdb"
  cd "$PROJECT_DIR"
  
  echo -e "${GREEN}Created: $OUTPUT_DIR/$ZIP_NAME${NC}"
  
  # Create MSIX if tool is available
  if command -v flutter >/dev/null 2>&1; then
    echo -e "${BLUE}Creating MSIX package...${NC}"
    flutter pub run msix:create || echo -e "${YELLOW}MSIX creation skipped${NC}"
    
    if [ -f "$PROJECT_DIR/build/windows/x64/runner/Release/app_notes.msix" ]; then
      cp "$PROJECT_DIR/build/windows/x64/runner/Release/app_notes.msix" "$OUTPUT_DIR/appnotes-$VERSION.msix"
      echo -e "${GREEN}Created: $OUTPUT_DIR/appnotes-$VERSION.msix${NC}"
    fi
  fi
  
  # Create Inno Setup installer if available
  if command -v iscc >/dev/null 2>&1 || [ -f "/c/Program Files (x86)/Inno Setup 6/ISCC.exe" ]; then
    echo -e "${BLUE}Creating installer with Inno Setup...${NC}"
    
    # Generate Inno Setup script
    cat > "$PROJECT_DIR/scripts/installer.iss" << 'EOF'
#define MyAppName "AppNotes"
#define MyAppVersion "VERSION"
#define MyAppPublisher "AppNotes Team"
#define MyAppExeName "app_notes.exe"

[Setup]
AppId={{8F5B5E1A-5C8B-4D5E-9F2A-3B4C5D6E7F8A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=LICENSE
OutputDir=packages
OutputBaseFilename=appnotes-VERSION-setup
SetupIconFile=windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\\ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\\windows\\x64\\runner\\Release\\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\\{#MyAppName}"; Filename: "{app}\\{#MyAppExeName}"
Name: "{autodesktop}\\{#MyAppName}"; Filename: "{app}\\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
EOF
    
    # Replace version placeholder
    sed -i "s/VERSION/$VERSION/g" "$PROJECT_DIR/scripts/installer.iss"
    
    # Run Inno Setup
    if command -v iscc >/dev/null 2>&1; then
      iscc "$PROJECT_DIR/scripts/installer.iss"
    else
      "/c/Program Files (x86)/Inno Setup 6/ISCC.exe" "$PROJECT_DIR/scripts/installer.iss"
    fi
    
    rm "$PROJECT_DIR/scripts/installer.iss"
  fi
  
  echo -e "${GREEN}Windows packaging completed!${NC}"
}

package_macos() {
  echo -e "${BLUE}Packaging for macOS...${NC}"
  
  local BUILD_DIR="$PROJECT_DIR/build/macos/Build/Products/Release"
  
  if [ ! -d "$BUILD_DIR/AppNotes.app" ] && [ ! -d "$BUILD_DIR/app_notes.app" ]; then
    echo -e "${RED}macOS build not found. Run build.sh first.${NC}"
    return 1
  fi
  
  local APP_NAME=$(ls "$BUILD_DIR" | grep -E '\.app$' | head -1)
  
  # Create DMG
  if command -v create-dmg >/dev/null 2>&1; then
    echo -e "${BLUE}Creating DMG...${NC}"
    create-dmg \
      --volname "AppNotes Installer" \
      --window-pos 200 120 \
      --window-size 800 400 \
      --icon-size 100 \
      --app-drop-link 600 185 \
      "$OUTPUT_DIR/appnotes-$VERSION.dmg" \
      "$BUILD_DIR/$APP_NAME"
  else
    # Fallback: create ZIP
    echo -e "${YELLOW}create-dmg not found, creating ZIP instead...${NC}"
    cd "$BUILD_DIR"
    zip -r "$OUTPUT_DIR/appnotes-$VERSION-macos.zip" "$APP_NAME"
    cd "$PROJECT_DIR"
  fi
  
  echo -e "${GREEN}macOS packaging completed!${NC}"
}

package_linux() {
  echo -e "${BLUE}Packaging for Linux...${NC}"
  
  local BUILD_DIR="$PROJECT_DIR/build/linux/x64/release/bundle"
  
  if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${RED}Linux build not found. Run build.sh first.${NC}"
    return 1
  fi
  
  # Create tar.gz archive
  local ARCHIVE_NAME="appnotes-$VERSION-linux-x64.tar.gz"
  
  echo -e "${BLUE}Creating tar.gz archive...${NC}"
  cd "$PROJECT_DIR/build/linux/x64/release"
  tar -czf "$OUTPUT_DIR/$ARCHIVE_NAME" bundle/
  cd "$PROJECT_DIR"
  
  echo -e "${GREEN}Created: $OUTPUT_DIR/$ARCHIVE_NAME${NC}"
  
  # Create .deb package if dpkg-deb is available
  if command -v dpkg-deb >/dev/null 2>&1; then
    echo -e "${BLUE}Creating .deb package...${NC}"
    
    local DEB_DIR="$PROJECT_DIR/scripts/deb_build/appnotes"
    mkdir -p "$DEB_DIR/DEBIAN"
    mkdir -p "$DEB_DIR/usr/share/appnotes"
    mkdir -p "$DEB_DIR/usr/share/applications"
    mkdir -p "$DEB_DIR/usr/share/icons/hicolor/256x256/apps"
    mkdir -p "$DEB_DIR/usr/bin"
    
    # Create control file
    cat > "$DEB_DIR/DEBIAN/control" << EOF
Package: appnotes
Version: $VERSION
Section: editors
Priority: optional
Architecture: amd64
Depends: libgtk-3-0, libblkid1, liblzma5
Maintainer: AppNotes Team <support@appnotes.dev>
Description: AppNotes Markdown Editor
 A modern, fast, and beautiful Markdown editor
 for desktop platforms.
EOF
    
    # Copy build files
    cp -r "$BUILD_DIR/"* "$DEB_DIR/usr/share/appnotes/"
    
    # Create desktop entry
    cat > "$DEB_DIR/usr/share/applications/appnotes.desktop" << 'EOF'
[Desktop Entry]
Name=AppNotes
Comment=A modern Markdown editor
Exec=/usr/share/appnotes/app_notes
Icon=/usr/share/icons/hicolor/256x256/apps/appnotes.png
Type=Application
Categories=Office;TextEditor;
Terminal=false
StartupNotify=true
EOF
    
    # Copy icon (use a placeholder or actual icon)
    if [ -f "$PROJECT_DIR/assets/icons/app_icon.png" ]; then
      cp "$PROJECT_DIR/assets/icons/app_icon.png" "$DEB_DIR/usr/share/icons/hicolor/256x256/apps/appnotes.png"
    fi
    
    # Create launcher script
    cat > "$DEB_DIR/usr/bin/appnotes" << 'EOF'
#!/bin/bash
exec /usr/share/appnotes/app_notes "$@"
EOF
    chmod +x "$DEB_DIR/usr/bin/appnotes"
    
    # Build package
    dpkg-deb --build "$DEB_DIR" "$OUTPUT_DIR/appnotes-$VERSION.deb"
    
    # Cleanup
    rm -rf "$DEB_DIR"
    
    echo -e "${GREEN}Created: $OUTPUT_DIR/appnotes-$VERSION.deb${NC}"
  fi
  
  # Create AppImage if appimagetool is available
  if command -v appimagetool >/dev/null 2>&1; then
    echo -e "${BLUE}Creating AppImage...${NC}"
    echo -e "${YELLOW}AppImage creation requires additional setup${NC}"
  fi
  
  echo -e "${GREEN}Linux packaging completed!${NC}"
}

# Execute packaging based on platform
case $PLATFORM in
  windows)
    package_windows
    ;;
  macos)
    package_macos
    ;;
  linux)
    package_linux
    ;;
  all)
    echo -e "${YELLOW}Packaging for all platforms...${NC}"
    package_windows || echo -e "${YELLOW}Windows packaging skipped${NC}"
    package_macos || echo -e "${YELLOW}macOS packaging skipped${NC}"
    package_linux || echo -e "${YELLOW}Linux packaging skipped${NC}"
    ;;
  *)
    echo -e "${RED}Unknown platform: $PLATFORM${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${GREEN}========================================="
echo "Packaging completed!"
echo "Output directory: $OUTPUT_DIR"
echo "=========================================${NC}"
ls -lh "$OUTPUT_DIR/"
