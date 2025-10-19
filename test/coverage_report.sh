#!/bin/bash

# Test Coverage Report Generator
# Generates coverage report and validates 70/20/10 ratio

set -e

echo "========================================="
echo "Test Coverage Report"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Run tests with coverage
echo "Running tests with coverage..."
flutter test --coverage

# Check if lcov is installed
if ! command -v lcov &> /dev/null; then
    echo "${RED}lcov is not installed. Install it with: brew install lcov (macOS) or apt-get install lcov (Linux)${NC}"
    exit 1
fi

# Generate HTML report
echo ""
echo "Generating HTML coverage report..."
genhtml coverage/lcov.info -o coverage/html

# Extract coverage percentage
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')

echo ""
echo "========================================="
echo "Coverage Summary"
echo "========================================="
echo ""
echo "Overall Line Coverage: ${COVERAGE}%"

# Check if coverage meets minimum threshold (70%)
if (( $(echo "$COVERAGE < 70" | bc -l) )); then
    echo "${RED}⚠ Coverage is below 70% threshold${NC}"
    COVERAGE_STATUS="FAILED"
else
    echo "${GREEN}✓ Coverage meets 70% threshold${NC}"
    COVERAGE_STATUS="PASSED"
fi

echo ""
echo "========================================="
echo "Test Breakdown"
echo "========================================="
echo ""

# Count tests by type
UNIT_TESTS=$(find test -name "*_test.dart" ! -path "*/integration/*" ! -path "*/e2e/*" | wc -l | tr -d ' ')
INTEGRATION_TESTS=$(find test/integration -name "*_test.dart" 2>/dev/null | wc -l | tr -d ' ')
E2E_TESTS=$(find test/e2e -name "*_test.dart" 2>/dev/null | wc -l | tr -d ' ')

TOTAL_TESTS=$((UNIT_TESTS + INTEGRATION_TESTS + E2E_TESTS))

if [ $TOTAL_TESTS -eq 0 ]; then
    TOTAL_TESTS=1  # Avoid division by zero
fi

UNIT_PERCENT=$((UNIT_TESTS * 100 / TOTAL_TESTS))
INTEGRATION_PERCENT=$((INTEGRATION_TESTS * 100 / TOTAL_TESTS))
E2E_PERCENT=$((E2E_TESTS * 100 / TOTAL_TESTS))

echo "Unit Tests:        ${UNIT_TESTS} (${UNIT_PERCENT}%)"
echo "Integration Tests: ${INTEGRATION_TESTS} (${INTEGRATION_PERCENT}%)"
echo "E2E Tests:         ${E2E_TESTS} (${E2E_PERCENT}%)"
echo "Total Test Files:  ${TOTAL_TESTS}"

echo ""
echo "Target Ratio: 70% Unit / 20% Integration / 10% E2E"

# Check ratio compliance
if [ $UNIT_PERCENT -ge 60 ] && [ $UNIT_PERCENT -le 80 ]; then
    echo "${GREEN}✓ Unit test ratio in acceptable range (60-80%)${NC}"
else
    echo "${YELLOW}⚠ Unit test ratio outside target range (current: ${UNIT_PERCENT}%)${NC}"
fi

echo ""
echo "========================================="
echo "Detailed Test Count"
echo "========================================="
echo ""

# Count actual test cases
echo "Running test suite to count test cases..."
TEST_OUTPUT=$(flutter test --reporter json 2>&1 | grep -E "\"type\":\"done\"" | tail -1)

if [ -n "$TEST_OUTPUT" ]; then
    PASSED_TESTS=$(echo "$TEST_OUTPUT" | grep -o '"success":[0-9]*' | grep -o '[0-9]*')
    FAILED_TESTS=$(echo "$TEST_OUTPUT" | grep -o '"failure":[0-9]*' | grep -o '[0-9]*')
    SKIPPED_TESTS=$(echo "$TEST_OUTPUT" | grep -o '"skipped":[0-9]*' | grep -o '[0-9]*')

    echo "Passed:  ${PASSED_TESTS}"
    echo "Failed:  ${FAILED_TESTS}"
    echo "Skipped: ${SKIPPED_TESTS}"
    echo "Total:   $((PASSED_TESTS + FAILED_TESTS + SKIPPED_TESTS))"
else
    echo "Could not parse test results. Run 'flutter test' manually for details."
fi

echo ""
echo "========================================="
echo "Coverage by Layer"
echo "========================================="
echo ""

# Check coverage by architecture layer
if [ -f "coverage/lcov.info" ]; then
    echo "Presentation Layer (lib/src/presentation/):"
    lcov --list coverage/lcov.info 2>/dev/null | grep "src/presentation" | awk '{sum+=$3; count++} END {if (count>0) print "  Average: " sum/count "%"; else print "  No files found"}'

    echo ""
    echo "Domain Layer (lib/src/domain/):"
    lcov --list coverage/lcov.info 2>/dev/null | grep "src/domain" | awk '{sum+=$3; count++} END {if (count>0) print "  Average: " sum/count "%"; else print "  No files found"}'

    echo ""
    echo "Data Layer (lib/src/data/):"
    lcov --list coverage/lcov.info 2>/dev/null | grep "src/data" | awk '{sum+=$3; count++} END {if (count>0) print "  Average: " sum/count "%"; else print "  No files found"}'
fi

echo ""
echo "========================================="
echo "HTML Report Location"
echo "========================================="
echo ""
echo "Open: coverage/html/index.html"
echo ""

if command -v open &> /dev/null; then
    read -p "Open HTML report in browser? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open coverage/html/index.html
    fi
fi

echo ""
echo "========================================="
echo "Final Status: ${COVERAGE_STATUS}"
echo "========================================="
echo ""

if [ "$COVERAGE_STATUS" = "FAILED" ]; then
    exit 1
fi

exit 0
