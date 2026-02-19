#!/bin/bash
#
# Test runner script for AppNotes
# Runs all unit, widget, and integration tests
#

set -e

echo "========================================="
echo "AppNotes Test Runner"
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
COVERAGE=0
FILTER=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --coverage)
      COVERAGE=1
      shift
      ;;
    --filter)
      FILTER="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --coverage    Generate coverage report"
      echo "  --filter <pattern>  Run only tests matching pattern"
      echo "  --help        Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

# Get dependencies
echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Generate code
echo -e "${YELLOW}Generating code...${NC}"
dart run build_runner build --delete-conflicting-outputs || true

# Run unit and widget tests
echo ""
echo -e "${BLUE}Running tests...${NC}"

if [ $COVERAGE -eq 1 ]; then
  # Run with coverage
  if [ -n "$FILTER" ]; then
    flutter test --coverage --name "$FILTER"
  else
    flutter test --coverage
  fi
  
  # Generate HTML coverage report
  if command -v genhtml >/dev/null 2>&1; then
    echo -e "${YELLOW}Generating coverage report...${NC}"
    genhtml coverage/lcov.info -o coverage/html
    echo -e "${GREEN}Coverage report: coverage/html/index.html${NC}"
  fi
  
  # Show coverage summary
  if command -v lcov >/dev/null 2>&1; then
    echo ""
    echo -e "${BLUE}Coverage Summary:${NC}"
    lcov --summary coverage/lcov.info 2>&1 | grep -E '(lines|functions|branches)'
  fi
else
  # Run without coverage
  if [ -n "$FILTER" ]; then
    flutter test --name "$FILTER"
  else
    flutter test
  fi
fi

echo ""
echo -e "${GREEN}========================================="
echo "All tests completed!"
echo "=========================================${NC}"
