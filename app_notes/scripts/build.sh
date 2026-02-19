#!/bin/bash
#
# Build script for AppNotes
# Supports Windows, macOS, and Linux builds
#

set -e

echo "========================================="
echo "AppNotes Build Script"
echo "========================================="

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
BUILD_TYPE="release"
PLATFORM=""
CLEAN=0

while [[ $# -gt 0 ]]; do
  case $1 in
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    --debug)
      BUILD_TYPE="debug"
      shift
      ;;
    --clean)
      CLEAN=1
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --platform <platform>  Build for specific platform (windows, macos, linux)"
      echo "  --debug                 Build in debug mode"
      echo "  --clean                 Clean build directory before building"
      echo "  --help                  Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0                      Build for current platform (release)"
      echo "  $0 --platform windows   Build for Windows"
      echo "  $0 --platform macos     Build for macOS"
      echo "  $0 --platform linux     Build for Linux"
      echo "  $0 --clean              Clean and rebuild"
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

# Clean if requested
if [ $CLEAN -eq 1 ]; then
  echo -e "${YELLOW}Cleaning build directory...${NC}"
  flutter clean
fi

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Generate code if needed
echo -e "${YELLOW}Generating code...${NC}"
if [ -f "pubspec.yaml" ]; then
  dart run build_runner build --delete-conflicting-outputs || true
fi

# Run tests before building
echo -e "${YELLOW}Running tests...${NC}"
flutter test || {
  echo -e "${RED}Tests failed! Aborting build.${NC}"
  exit 1
}

# Build based on platform
echo -e "${GREEN}Building for $PLATFORM ($BUILD_TYPE)...${NC}"

case $PLATFORM in
  windows)
    flutter build windows --$BUILD_TYPE
    
    # Create distribution directory
    DIST_DIR="$PROJECT_DIR/dist/windows"
    mkdir -p "$DIST_DIR"
    
    # Copy build files
    cp -r "$PROJECT_DIR/build/windows/x64/runner/$BUILD_TYPE/"* "$DIST_DIR/" 2>/dev/null || \
    cp -r "$PROJECT_DIR/build/windows/runner/$BUILD_TYPE/"* "$DIST_DIR/"
    
    echo -e "${GREEN}Windows build completed: $DIST_DIR${NC}"
    ;;
    
  macos)
    flutter build macos --$BUILD_TYPE
    
    # Create distribution directory
    DIST_DIR="$PROJECT_DIR/dist/macos"
    mkdir -p "$DIST_DIR"
    
    # Copy app bundle
    cp -r "$PROJECT_DIR/build/macos/Build/Products/$BUILD_TYPE/AppNotes.app" "$DIST_DIR/" 2>/dev/null || \
    cp -r "$PROJECT_DIR/build/macos/Build/Products/$BUILD_TYPE/app_notes.app" "$DIST_DIR/"
    
    echo -e "${GREEN}macOS build completed: $DIST_DIR${NC}"
    ;;
    
  linux)
    flutter build linux --$BUILD_TYPE
    
    # Create distribution directory
    DIST_DIR="$PROJECT_DIR/dist/linux"
    mkdir -p "$DIST_DIR"
    
    # Copy build files
    cp -r "$PROJECT_DIR/build/linux/x64/$BUILD_TYPE/bundle/"* "$DIST_DIR/"
    
    echo -e "${GREEN}Linux build completed: $DIST_DIR${NC}"
    ;;
    
  *)
    echo -e "${RED}Unsupported platform: $PLATFORM${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${GREEN}========================================="
echo "Build completed successfully!"
echo "Output: $DIST_DIR"
echo "=========================================${NC}"
