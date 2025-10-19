#!/bin/bash

# Platform Testing Runner Script
# Helps automate platform-specific test builds and launches

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================="
echo "Platform Testing Runner"
echo "========================================="
echo ""

# Function to display menu
show_menu() {
    echo "Select platform to test:"
    echo "1) iOS Simulator"
    echo "2) Android Emulator"
    echo "3) macOS Desktop"
    echo "4) Run all automated tests"
    echo "5) Generate coverage report"
    echo "6) Exit"
    echo ""
}

# Function to check prerequisites
check_prerequisites() {
    echo "${BLUE}Checking prerequisites...${NC}"

    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        echo "${RED}Flutter is not installed or not in PATH${NC}"
        exit 1
    fi

    # Check if project is valid
    if [ ! -f "pubspec.yaml" ]; then
        echo "${RED}Not in a Flutter project directory${NC}"
        exit 1
    fi

    echo "${GREEN}✓ Prerequisites check passed${NC}"
    echo ""
}

# Function to prepare build
prepare_build() {
    echo "${BLUE}Preparing build...${NC}"
    flutter clean
    flutter pub get
    echo "${GREEN}✓ Build preparation complete${NC}"
    echo ""
}

# Function to test iOS
test_ios() {
    echo "========================================="
    echo "iOS Testing"
    echo "========================================="
    echo ""

    # Check for Xcode
    if ! command -v xcodebuild &> /dev/null; then
        echo "${RED}Xcode is not installed${NC}"
        return 1
    fi

    prepare_build

    # Install CocoaPods dependencies
    echo "${BLUE}Installing iOS dependencies...${NC}"
    cd ios && pod install && cd ..

    # List available simulators
    echo ""
    echo "${BLUE}Available iOS Simulators:${NC}"
    flutter devices | grep "ios"
    echo ""

    read -p "Enter simulator device ID (or press Enter to use default): " DEVICE_ID

    if [ -z "$DEVICE_ID" ]; then
        # Use first available iOS simulator
        DEVICE_ID=$(flutter devices | grep "ios" | head -1 | awk '{print $NF}' | tr -d '()')
    fi

    if [ -z "$DEVICE_ID" ]; then
        echo "${RED}No iOS simulators found. Please start one from Xcode.${NC}"
        return 1
    fi

    echo ""
    echo "${BLUE}Building and launching on iOS...${NC}"
    echo "Device ID: $DEVICE_ID"
    echo ""
    echo "Opening test checklist..."
    echo "Refer to: test/PLATFORM_TESTING_GUIDE.md#ios-testing-task-237"
    echo ""

    # Launch app
    flutter run -d "$DEVICE_ID" --debug
}

# Function to test Android
test_android() {
    echo "========================================="
    echo "Android Testing"
    echo "========================================="
    echo ""

    # Check for Android SDK
    if [ -z "$ANDROID_HOME" ]; then
        echo "${YELLOW}⚠ ANDROID_HOME not set${NC}"
    fi

    prepare_build

    # List available emulators
    echo ""
    echo "${BLUE}Available Android Devices:${NC}"
    flutter devices | grep "android"
    echo ""

    read -p "Enter device ID (or press Enter to use default): " DEVICE_ID

    if [ -z "$DEVICE_ID" ]; then
        # Use first available Android device
        DEVICE_ID=$(flutter devices | grep "android" | head -1 | awk '{print $NF}' | tr -d '()')
    fi

    if [ -z "$DEVICE_ID" ]; then
        echo "${RED}No Android devices found. Please start an emulator.${NC}"
        return 1
    fi

    echo ""
    echo "${BLUE}Building and launching on Android...${NC}"
    echo "Device ID: $DEVICE_ID"
    echo ""
    echo "Opening test checklist..."
    echo "Refer to: test/PLATFORM_TESTING_GUIDE.md#android-testing-task-238"
    echo ""

    # Launch app
    flutter run -d "$DEVICE_ID" --debug
}

# Function to test macOS
test_macos() {
    echo "========================================="
    echo "macOS Testing"
    echo "========================================="
    echo ""

    # Check if on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "${RED}macOS testing is only available on macOS${NC}"
        return 1
    fi

    prepare_build

    # Install CocoaPods dependencies
    echo "${BLUE}Installing macOS dependencies...${NC}"
    cd macos && pod install && cd ..

    echo ""
    echo "${BLUE}Building and launching on macOS...${NC}"
    echo ""
    echo "Opening test checklist..."
    echo "Refer to: test/PLATFORM_TESTING_GUIDE.md#macos-testing-task-239"
    echo ""

    # Launch app
    flutter run -d macos --debug
}

# Function to run all automated tests
run_all_tests() {
    echo "========================================="
    echo "Running All Automated Tests"
    echo "========================================="
    echo ""

    echo "${BLUE}1. Running unit tests...${NC}"
    flutter test

    echo ""
    echo "${BLUE}2. Running analyzer...${NC}"
    flutter analyze

    echo ""
    echo "${BLUE}3. Checking formatting...${NC}"
    dart format --output=none --set-exit-if-changed lib/ test/

    echo ""
    echo "${GREEN}✓ All automated checks passed${NC}"
    echo ""
    echo "Note: Manual platform testing still required."
    echo "See test/PLATFORM_TESTING_GUIDE.md for details."
}

# Function to generate coverage report
generate_coverage() {
    echo "========================================="
    echo "Generating Coverage Report"
    echo "========================================="
    echo ""

    if [ -f "test/coverage_report.sh" ]; then
        ./test/coverage_report.sh
    else
        echo "${YELLOW}Coverage report script not found.${NC}"
        echo "Running basic coverage..."
        flutter test --coverage
        echo ""
        echo "Coverage data generated in coverage/lcov.info"
    fi
}

# Main script
cd "$(dirname "$0")/.."  # Navigate to project root

check_prerequisites

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [1-6]: " choice
    echo ""

    case $choice in
        1)
            test_ios
            ;;
        2)
            test_android
            ;;
        3)
            test_macos
            ;;
        4)
            run_all_tests
            ;;
        5)
            generate_coverage
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "${RED}Invalid option. Please try again.${NC}"
            echo ""
            ;;
    esac

    echo ""
    read -p "Press Enter to continue..."
    echo ""
done
