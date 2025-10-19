# Quick Test Reference Card

Quick commands for testing the media_wipe app after Clean Architecture refactoring.

## Quick Start

```bash
# Install dependencies (first time only)
flutter pub get

# Interactive platform testing menu
./test/run_platform_tests.sh

# Generate coverage report
./test/coverage_report.sh

# Run all tests
flutter test

# Run quick tests (no Isar needed)
flutter test test/domain/ test/presentation/ test/data/repositories/ test/data/mappers/

# Run specific test file
flutter test test/data/repositories/asset_repository_impl_test.dart

# Run tests with coverage
flutter test --coverage
```

## Platform-Specific Commands

### iOS
```bash
# List iOS simulators
flutter devices | grep ios

# Run on specific iOS simulator
flutter run -d <simulator-id> --debug

# Build iOS app
flutter build ios --debug --simulator

# CocoaPods
cd ios && pod install && cd ..
```

### Android
```bash
# List Android devices/emulators
flutter devices | grep android

# Run on specific Android device
flutter run -d <device-id> --debug

# Build Android APK
flutter build apk --debug

# Build Android App Bundle
flutter build appbundle
```

### macOS
```bash
# Run on macOS
flutter run -d macos --debug

# Build macOS app
flutter build macos --debug

# CocoaPods
cd macos && pod install && cd ..
```

## Quick Checks

### Pre-Testing Checklist
```bash
# Clean and prepare
flutter clean && flutter pub get

# Format code
dart format .

# Analyze code
flutter analyze

# Run all tests
flutter test

# Check for compilation errors
flutter build <platform> --debug
```

### Critical Path Testing (All Platforms)
1. **Launch**: App starts without crashes
2. **Authorization**: Photo permissions work
3. **Loading**: Photos load and display
4. **Session**: Review flow completes
5. **Deletion**: Asset deletion works
6. **Settings**: Theme and preferences persist

### BLoC/State Management Checks
```bash
# Search for any remaining Provider usage (should return nothing)
rg "Provider\.of" lib/

# Verify GetIt registrations
rg "getIt\.registerSingleton" lib/src/core/di/

# Check BLoC usage
rg "BlocProvider" lib/
rg "BlocBuilder" lib/
```

## Test Coverage

### Current Status (as of refactoring)
- **Unit Tests**: 199 total
  - Passing in CI: 76 (BLoC/Cubit, Use Cases, Repositories, Mappers, Widgets)
  - Require Isar: 123 (Data Sources - require native runtime)
- **Integration Tests**: 37 (COMPLETED)
- **E2E Tests**: 0 (TODO)

### Target Ratio
- 70% Unit Tests
- 20% Integration Tests
- 10% E2E Tests

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
```

## Common Issues & Fixes

### "Provider.of() called with context..."
**Fix**: Old Provider code still present - replace with BLoC/GetIt
```bash
rg "Provider\.of" lib/  # Find and replace
```

### "GetIt: Object not registered"
**Fix**: Missing DI registration
```bash
# Check: lib/src/core/di/injection_container.dart
# Ensure all BLoCs/UseCases/Repositories registered
```

### Isar initialization error
**Fix**: Ensure Isar native libraries are installed
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### CocoaPods issues (iOS/macOS)
**Fix**: Reinstall pods
```bash
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
cd macos && rm -rf Pods Podfile.lock && pod install && cd ..
```

## Architecture Layers

### File Structure
```
lib/src/
├── core/           # DI, routing, database, services
├── data/           # Repositories, datasources, models
├── domain/         # Entities, usecases, repository interfaces
└── presentation/   # BLoCs, views, widgets
```

### Testing Structure
```
test/
├── data/           # Repository, datasource, mapper tests
├── domain/         # Use case tests
├── presentation/   # BLoC, cubit, widget tests
├── integration/    # Integration tests (TODO)
└── e2e/           # End-to-end tests (TODO)
```

## Key Files

### DI Container
`lib/src/core/di/injection_container.dart` - All dependency registrations

### Main Entry
`lib/main.dart` - App initialization with GetIt

### App Widget
`lib/src/presentation/app.dart` - Root widget with BlocProviders

### Router
`lib/src/core/routing/app_router.dart` - Navigation configuration

## Test Documentation

- **Full Platform Guide**: `test/PLATFORM_TESTING_GUIDE.md`
- **Coverage Script**: `test/coverage_report.sh`
- **Platform Runner**: `test/run_platform_tests.sh`
- **CI/CD Setup**: `.github/CI_SETUP.md`
- **OpenSpec Tasks**: `openspec/changes/refactor-architecture-to-clean-mvvm/tasks.md`

## CI/CD

### GitHub Actions
- **Workflow**: `.github/workflows/test.yml`
- **Quick tests**: No Isar setup needed (76 tests)
- **Full tests**: Isar automatically provided by `isar_flutter_libs` (236 tests)

### Local Setup
```bash
# First time setup
flutter pub get

# Verify setup
flutter test
```

## Quick Verification

### Verify Architecture Refactoring
```bash
# No Provider usage
! rg "Provider\.of" lib/ || echo "❌ Provider still in use"

# GetIt properly used
rg "GetIt.instance" lib/src/core/di/ && echo "✅ GetIt configured"

# BLoC pattern in use
rg "BlocProvider" lib/src/presentation/ && echo "✅ BLoC providers present"

# Clean Architecture structure
ls lib/src/{core,data,domain,presentation} && echo "✅ Clean structure"
```

### Verify Tests
```bash
# Run all unit tests
flutter test && echo "✅ All unit tests passing"

# Check test coverage
flutter test --coverage && \
  lcov --summary coverage/lcov.info && \
  echo "✅ Coverage report generated"
```

## Performance Targets

- **App Launch**: < 2 seconds
- **Photo Loading**: < 1 second per view
- **Database Operations**: < 500ms for batch operations
- **Memory Usage**: < 150MB (iOS), < 200MB (Android), < 250MB (macOS)

## Next Steps

After platform testing completion:
1. Mark tasks 23.7, 23.8, 23.9 as complete
2. Document any platform-specific issues found
3. Implement integration tests (Task 23.4)
4. Implement E2E tests (Task 23.5)
5. Verify 70/20/10 coverage ratio (Task 23.6)

---

**For detailed testing procedures, see**: `test/PLATFORM_TESTING_GUIDE.md`
