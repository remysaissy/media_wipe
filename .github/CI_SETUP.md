# CI/CD Setup Guide

This document explains the Continuous Integration setup for the media_wipe application.

## Overview

The CI pipeline is configured to run tests in multiple stages to handle Isar native library requirements:

1. **Analyze**: Code formatting and static analysis
2. **Unit Tests**: Tests that don't require Isar (76 tests)
3. **Full Test Suite**: All tests including Isar-dependent ones (236 tests)

## GitHub Actions Workflows

### Main Test Workflow (`test.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

**Jobs:**

#### 1. Analyze
- Runs on: Ubuntu Latest
- Checks code formatting with `dart format`
- Runs static analysis with `flutter analyze`

#### 2. Unit Tests (Without Isar)
- Runs on: Ubuntu Latest
- Tests: 76 tests (BLoC, Use Cases, Repositories, Mappers, Widgets)
- Excludes: Data source and integration tests (require Isar)
- Generates partial coverage report
- Uploads coverage to Codecov

#### 3. Full Test Suite (With Isar)
- Runs on: Ubuntu Latest and macOS Latest
- Tests: All 236 tests
- Includes: Data source tests (46) and integration tests (37)
- Isar native library is automatically provided by `isar_flutter_libs` package
- Generates full coverage report
- Uploads coverage to Codecov (Linux only)

#### 4. Test Summary
- Runs after all test jobs complete
- Generates summary in GitHub Actions UI
- Shows job status and test statistics

## Isar Database

### Why Isar Native Libraries are Needed

Tests that directly interact with Isar require platform-specific native libraries:
- **Data Source Tests** (46 tests): Direct database operations
- **Integration Tests** (37 tests): End-to-end workflows with database

### How Isar is Set Up in CI

Isar native libraries are automatically provided by the `isar_flutter_libs` package. The workflow optionally copies the native library to the project root for improved compatibility:

**Linux:**
```bash
cp ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-*/linux/libisar.so libisar.so || echo "Isar library will be loaded at runtime"
```

**macOS:**
```bash
cp ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-*/macos/libisar.dylib libisar.dylib || echo "Isar library will be loaded at runtime"
```

### Local Isar Setup

For local development, Isar is automatically set up when you run:

```bash
flutter pub get
```

The `isar_flutter_libs` package includes native libraries for all platforms. No additional setup is required.

To generate Isar schemas after modifying entity definitions:

```bash
dart run build_runner build
```

## Test Organization

### Tests Without Isar (76 tests)
These run in the "Unit Tests" job:
```
test/domain/          # Use cases (23 tests)
test/presentation/    # BLoCs, Cubits, Widgets (33 tests)
test/data/repositories/  # Repository implementations (20 tests)
test/data/mappers/       # Entity/Domain mappers (0 tests counted here)
```

### Tests With Isar (160 tests)
These run only in the "Full Test Suite" job:
```
test/data/datasources/  # Data source implementations (46 tests)
test/integration/       # Integration tests (37 tests)
```

## Coverage Reports

### Partial Coverage (Unit Tests Job)
- Line coverage: ~60-65%
- Excludes data sources and integration tests
- Fast execution (~1-2 minutes)
- Uploaded to Codecov with flag: `unittests`

### Full Coverage (Integration Tests Job)
- Line coverage: ~85-90%
- Includes all tests
- Moderate execution (~3-5 minutes)
- Uploaded to Codecov with flag: `all-tests`

## Running Tests Locally

### Quick Tests (No Special Setup Required)
```bash
flutter test test/domain/ test/presentation/ test/data/repositories/ test/data/mappers/
```

### Full Test Suite
```bash
# Ensure dependencies are installed
flutter pub get

# Run all tests
flutter test

# With coverage
flutter test --coverage
```

### Generate Coverage Report Locally
```bash
flutter test --coverage
./test/coverage_report.sh
open coverage/html/index.html
```

## Troubleshooting

### Isar Native Library Not Found

**Error:**
```
Invalid argument(s): Failed to load dynamic library 'libisar.dylib':
dlopen(...libisar.dylib, 0x0001): tried: '...libisar.dylib' (no such file)
```

**Solution:**
1. Ensure `isar_flutter_libs` is installed:
   ```bash
   flutter pub get
   ```

2. For macOS, you can copy the library to the project root:
   ```bash
   cp ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-*/macos/libisar.dylib .
   ```

3. For Linux, copy the Linux library:
   ```bash
   cp ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-*/linux/libisar.so .
   ```

### Schema Generation Issues

**Solution:**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### iOS/macOS CocoaPods Issues

**Solution:**
```bash
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
cd macos && rm -rf Pods Podfile.lock && pod install && cd ..
```

### Tests Hanging or Timing Out

**Solution:**
- Increase timeout in CI: Already set to 2 minutes
- Check for async operations without proper `await`
- Verify test cleanup in `tearDown()` methods
- Ensure Isar instances are properly closed in `tearDown()`

## CI Performance

### Expected Run Times

- **Analyze**: 30-60 seconds
- **Unit Tests**: 1-2 minutes
- **Full Test Suite (Linux)**: 3-5 minutes
- **Full Test Suite (macOS)**: 3-5 minutes
- **Total**: ~10-15 minutes

### Optimization Strategies

1. **Parallel Execution**: Jobs run in parallel when possible
2. **Caching**: Flutter SDK and dependencies are cached
3. **Matrix Strategy**: Linux and macOS tests run concurrently
4. **Selective Testing**: Unit tests run separately for faster feedback

## Adding New Tests

### Unit Tests (No Isar)
- Add to: `test/domain/`, `test/presentation/`, `test/data/repositories/`, `test/data/mappers/`
- Will run in both "Unit Tests" and "Full Test Suite" jobs
- Fast feedback (~1-2 minutes)

### Isar-Dependent Tests
- Add to: `test/data/datasources/` or `test/integration/`
- Will run only in "Full Test Suite" job
- Requires Isar native library (~3-5 minutes)

## Status Badges

Add to README.md:

```markdown
![Tests](https://github.com/YOUR_USERNAME/media_wipe/workflows/Tests/badge.svg)
[![codecov](https://codecov.io/gh/YOUR_USERNAME/media_wipe/branch/main/graph/badge.svg)](https://codecov.io/gh/YOUR_USERNAME/media_wipe)
```

## Future Improvements

- [ ] Add E2E tests (target: 24 tests for 10% coverage)
- [ ] Add platform-specific test jobs (iOS, Android, macOS builds)
- [ ] Add performance benchmarking
- [ ] Add golden file testing for widgets
- [ ] Setup automated deployment on successful tests

## References

- [Isar Documentation](https://isar.dev/)
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Codecov Documentation](https://docs.codecov.com/)
