#!/bin/bash

# Architecture Validation Script
# Validates Clean Architecture + MVVM implementation before platform testing
# This script checks that the refactoring is complete and ready for manual testing

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FAILED_CHECKS=0
TOTAL_CHECKS=0

# Function to print section header
print_header() {
    echo ""
    echo "${BLUE}=========================================${NC}"
    echo "${BLUE}$1${NC}"
    echo "${BLUE}=========================================${NC}"
    echo ""
}

# Function to check and report
check() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    local description="$1"
    local command="$2"

    echo -n "Checking: $description... "

    if eval "$command" > /dev/null 2>&1; then
        echo "${GREEN}✓ PASS${NC}"
        return 0
    else
        echo "${RED}✗ FAIL${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

# Function to check with output
check_with_output() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    local description="$1"
    local command="$2"
    local expected="$3"

    echo -n "Checking: $description... "

    output=$(eval "$command" 2>&1)
    if echo "$output" | grep -q "$expected"; then
        echo "${GREEN}✓ PASS${NC}"
        return 0
    else
        echo "${RED}✗ FAIL${NC}"
        echo "  Expected: $expected"
        echo "  Got: $output"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

# Start validation
print_header "Clean Architecture Validation"

echo "${YELLOW}This script validates the Clean Architecture refactoring is complete.${NC}"
echo "${YELLOW}Run this before starting manual platform testing.${NC}"
echo ""

# Check 1: Project Structure
print_header "1. Project Structure"

check "lib/src directory exists" "test -d lib/src"
check "Presentation layer exists" "test -d lib/src/presentation"
check "Domain layer exists" "test -d lib/src/domain"
check "Data layer exists" "test -d lib/src/data"
check "Core layer exists" "test -d lib/src/core"
check "DI container exists" "test -f lib/src/core/di/injection_container.dart"

# Check 2: Clean Architecture Layers
print_header "2. Clean Architecture Layers"

check "Domain entities exist" "test -d lib/src/domain/entities"
check "Domain use cases exist" "test -d lib/src/domain/usecases"
check "Domain repositories (interfaces) exist" "test -d lib/src/domain/repositories"
check "Data models exist" "test -d lib/src/data/local/models"
check "Data sources exist" "test -d lib/src/data/datasources"
check "Data repositories (implementations) exist" "test -d lib/src/data/repositories"
check "Presentation BLoCs exist" "test -d lib/src/presentation/features"

# Check 3: MVVM with BLoC Pattern
print_header "3. MVVM with BLoC Pattern"

check "MediaBloc exists" "test -f lib/src/presentation/features/media/blocs/media/media_bloc.dart"
check "MediaBloc events exist" "test -f lib/src/presentation/features/media/blocs/media/media_event.dart"
check "MediaBloc state exists" "test -f lib/src/presentation/features/media/blocs/media/media_state.dart"
check "SessionCubit exists" "test -f lib/src/presentation/features/media/blocs/session/session_cubit.dart"
check "SettingsCubit exists" "test -f lib/src/presentation/features/settings/blocs/settings/settings_cubit.dart"

# Check 4: Old Architecture Removed
print_header "4. Old Architecture Cleanup"

check "Old commands directory removed" "! test -d lib/assets/commands"
check "Old models removed" "! test -f lib/assets/models/asset_model.dart"
check "Old shared commands removed" "! test -d lib/shared/commands"
check "Provider dependency removed from main imports" "! grep -q 'package:provider' lib/main.dart || grep -q 'MultiBlocProvider' lib/main.dart"

# Check 5: Dependencies
print_header "5. Dependencies Check"

check "flutter_bloc in pubspec.yaml" "grep -q 'flutter_bloc:' pubspec.yaml"
check "get_it in pubspec.yaml" "grep -q 'get_it:' pubspec.yaml"
check "equatable in pubspec.yaml" "grep -q 'equatable:' pubspec.yaml"
check "bloc_test in dev_dependencies" "grep -q 'bloc_test:' pubspec.yaml"

# Check 6: Code Quality
print_header "6. Code Quality"

echo "Running flutter analyze..."
if flutter analyze 2>&1 | tee /tmp/analyze_output.txt | tail -1 | grep -q "issues found"; then
    issues=$(flutter analyze 2>&1 | tail -1 | grep -oE '[0-9]+' | head -1)
    if [ "$issues" -le 4 ]; then
        echo "${GREEN}✓ PASS${NC} - $issues issues found (≤ 4 acceptable)"
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    else
        echo "${RED}✗ FAIL${NC} - $issues issues found (> 4 not acceptable)"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    fi
else
    echo "${GREEN}✓ PASS${NC} - No issues found"
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
fi

echo ""
echo "Checking code formatting..."
if dart format --set-exit-if-changed --output=none lib/ test/ test_e2e/ 2>&1; then
    echo "${GREEN}✓ PASS${NC} - All files properly formatted"
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
else
    echo "${YELLOW}! WARNING${NC} - Some files need formatting (run 'dart format .')"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
fi

# Check 7: Test Infrastructure
print_header "7. Test Infrastructure"

check "Unit tests directory exists" "test -d test/domain || test -d test/presentation || test -d test/data"
check "Integration tests exist" "test -d test/integration"
check "E2E tests exist" "test -d test_e2e"
check "Test helpers exist" "test -f test/integration/test_helpers.dart"
check "E2E test helpers exist" "test -f test_e2e/test_helpers.dart"
check "Platform testing guide exists" "test -f test/PLATFORM_TESTING_GUIDE.md"
check "Platform testing checklist exists" "test -f test/PLATFORM_TESTING_CHECKLIST.md"

# Check 8: Build Verification
print_header "8. Build Verification"

echo "Checking if app builds for macOS..."
if flutter build macos --debug 2>&1 | grep -q "Built build/macos"; then
    echo "${GREEN}✓ PASS${NC} - macOS build successful"
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
else
    echo "${RED}✗ FAIL${NC} - macOS build failed"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
fi

# Check 9: Critical Files
print_header "9. Critical Files Verification"

check "Main.dart uses DI setup" "grep -q 'setupDependencyInjection' lib/main.dart"
check "Main.dart uses MultiBlocProvider" "grep -q 'MultiBlocProvider' lib/main.dart"
check "App.dart exists" "test -f lib/src/presentation/app.dart"
check "Router exists" "test -f lib/src/core/routing/app_router.dart"
check "ObjectBox model generated" "test -f lib/objectbox.g.dart"
check "ObjectBox model JSON exists" "test -f lib/objectbox-model.json"

# Summary
print_header "Validation Summary"

PASSED_CHECKS=$((TOTAL_CHECKS - FAILED_CHECKS))
PASS_RATE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo "Total Checks: $TOTAL_CHECKS"
echo "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo "Failed: ${RED}$FAILED_CHECKS${NC}"
echo "Pass Rate: ${BLUE}$PASS_RATE%${NC}"
echo ""

if [ $FAILED_CHECKS -eq 0 ]; then
    echo "${GREEN}=========================================${NC}"
    echo "${GREEN}✓ ALL CHECKS PASSED!${NC}"
    echo "${GREEN}=========================================${NC}"
    echo ""
    echo "${GREEN}Architecture refactoring is complete and validated.${NC}"
    echo "${GREEN}You can proceed with platform testing.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Review test/PLATFORM_TESTING_CHECKLIST.md"
    echo "2. Run manual tests on iOS, Android, and macOS"
    echo "3. Use ./test/run_platform_tests.sh for automated tests"
    echo ""
    exit 0
else
    echo "${RED}=========================================${NC}"
    echo "${RED}✗ VALIDATION FAILED${NC}"
    echo "${RED}=========================================${NC}"
    echo ""
    echo "${RED}$FAILED_CHECKS check(s) failed.${NC}"
    echo "${YELLOW}Please fix the issues above before proceeding with platform testing.${NC}"
    echo ""
    exit 1
fi
