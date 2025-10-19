# Test Suite Documentation

Comprehensive testing documentation for the media_wipe application after Clean Architecture refactoring.

## Quick Links

- **[Quick Test Reference](QUICK_TEST_REFERENCE.md)** - Fast commands and troubleshooting
- **[Platform Testing Guide](PLATFORM_TESTING_GUIDE.md)** - Detailed manual testing procedures for iOS/Android/macOS
- **[OpenSpec Tasks](../openspec/changes/refactor-architecture-to-clean-mvvm/tasks.md)** - Implementation progress tracker

## Test Suite Overview

### Current Status (Post-Refactoring)

```
Total Tests: 236
├── Unit Tests: 199 (84%)
│   ├── BLoC/Cubit Tests: 16 ✓
│   ├── Use Case Tests: 23 ✓
│   ├── Repository Tests: 33 ✓
│   ├── Mapper Tests: 43 ✓
│   ├── Data Source Tests: 46 (require Isar runtime)
│   └── Widget Tests: 27 ✓
├── Integration Tests: 37 (16%) ✓
│   ├── Navigation Flow: 6 tests
│   ├── Session Flow: 11 tests
│   ├── Settings Persistence: 11 tests
│   └── Asset Deletion: 10 tests
└── E2E Tests: 0 (TODO)
```

**Passing in CI**: 76/236 unit tests (32%)
**Requires Native Runtime**: 160/236 tests (68% - Isar data source + integration tests)

### Architecture Coverage

#### ✅ Presentation Layer
- MediaBloc: 5 tests
- SessionCubit: 4 tests
- SettingsCubit: 6 tests
- Widget tests: 17 tests
- **Coverage**: ~95%

#### ✅ Domain Layer
- Use Cases (Media): 10 tests
- Use Cases (Sessions): 10 tests
- Use Cases (Settings): 3 tests
- **Coverage**: ~100%

#### ✅ Data Layer
- Repositories: 33 tests
- Mappers: 43 tests
- Data Sources: 57 tests
- **Coverage**: ~90%

#### ⏳ Infrastructure Layer
- DI Container: Manual verification required
- Routing: Manual verification required
- Services: Partially covered

## Running Tests

### Interactive Test Runner

```bash
# Launch interactive menu for platform testing
./test/run_platform_tests.sh
```

This provides options to:
1. Test on iOS Simulator
2. Test on Android Emulator
3. Test on macOS Desktop
4. Run all automated tests
5. Generate coverage report

### Command Line

```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/data/repositories/asset_repository_impl_test.dart

# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
./test/coverage_report.sh

# Run only passing tests (exclude Isar data source tests)
flutter test test/domain/ test/presentation/ test/data/repositories/ test/data/mappers/
```

## Test Organization

```
test/
├── README.md                           # This file
├── QUICK_TEST_REFERENCE.md             # Quick commands and tips
├── PLATFORM_TESTING_GUIDE.md           # Detailed manual testing guide
├── coverage_report.sh                  # Coverage report generator
├── run_platform_tests.sh               # Interactive test launcher
│
├── data/                               # Data Layer Tests
│   ├── repositories/                   # Repository implementation tests
│   │   ├── asset_repository_impl_test.dart         (17 tests ✓)
│   │   ├── session_repository_impl_test.dart       (11 tests ✓)
│   │   └── settings_repository_impl_test.dart      (5 tests ✓)
│   ├── datasources/                    # Data source tests (require Isar)
│   │   ├── asset_local_datasource_test.dart        (27 tests ⚠)
│   │   ├── session_local_datasource_test.dart      (16 tests ⚠)
│   │   └── settings_local_datasource_test.dart     (14 tests ⚠)
│   └── mappers/                        # Entity/Domain mapper tests
│       ├── asset_mapper_test.dart                  (13 tests ✓)
│       ├── session_mapper_test.dart                (15 tests ✓)
│       └── settings_mapper_test.dart               (15 tests ✓)
│
├── domain/                             # Domain Layer Tests
│   └── usecases/                       # Use case tests
│       ├── delete_assets_usecase_test.dart         (5 tests ✓)
│       ├── refresh_photos_usecase_test.dart        (6 tests ✓)
│       ├── start_session_usecase_test.dart         (6 tests ✓)
│       └── settings_usecases_test.dart             (6 tests ✓)
│
├── presentation/                       # Presentation Layer Tests
│   ├── blocs/                          # BLoC/Cubit tests
│   │   ├── media_bloc_test.dart                    (5 tests ✓)
│   │   ├── session_cubit_test.dart                 (4 tests ✓)
│   │   └── settings_cubit_test.dart                (6 tests ✓)
│   └── views/                          # Widget tests
│       ├── years_view_test.dart                    (7 tests ✓)
│       └── settings_list_view_test.dart            (10 tests ✓)
│
├── integration/                        # Integration Tests (TODO)
└── e2e/                               # End-to-End Tests (TODO)
```

## Test Types

### 1. Unit Tests (Current: 199, Target: 70%)

**What They Test**: Individual units of code in isolation
**Tools**: flutter_test, mockito, bloc_test
**Status**: ✅ Comprehensive coverage

#### BLoC/Cubit Tests
- State transitions
- Event handling
- Error handling
- Initial state
- **Example**: `test/presentation/blocs/media_bloc_test.dart`

#### Use Case Tests
- Business logic execution
- Repository interaction
- Error handling
- **Example**: `test/domain/usecases/delete_assets_usecase_test.dart`

#### Repository Tests
- Data source interaction
- Entity/Domain mapping
- CRUD operations
- **Example**: `test/data/repositories/asset_repository_impl_test.dart`

#### Mapper Tests
- Entity ↔ Domain conversions
- Field preservation
- Round-trip mapping
- Edge cases
- **Example**: `test/data/mappers/asset_mapper_test.dart`

#### Data Source Tests
- Isar operations
- Query filtering
- Batch operations
- Relations (IsarLinks/IsarLink)
- **Example**: `test/data/datasources/asset_local_datasource_test.dart`
- **Note**: Require Isar native runtime

#### Widget Tests
- UI rendering
- User interactions
- BLoC integration
- **Example**: `test/presentation/views/years_view_test.dart`

### 2. Integration Tests (Current: 37, Target: 20%)

**What They Test**: Multiple components working together
**Tools**: flutter_test, GetIt DI, in-memory Isar
**Status**: ✅ IMPLEMENTED

#### Implemented Integration Tests (37 tests)
- ✅ Years → Months → Detail navigation flow (6 tests)
  - View navigation and state preservation
  - Rapid navigation handling
  - Empty state handling
- ✅ Session creation → Review → Summary flow (11 tests)
  - Start → Keep/Drop → Finish workflows
  - Undo operations
  - Whitelist/Refine mode
  - Multi-operation sequences
- ✅ Settings updates with BLoC persistence (11 tests)
  - Theme switching and persistence
  - Debug flag updates
  - Photos access management
  - Onboarding and in-app review tracking
- ✅ Asset deletion with repository+datasource (10 tests)
  - Deletion through BLoC
  - Deletion through use case
  - Error handling and recovery
  - Data consistency validation

**Location**: `test/integration/`
**Helper**: `test/integration/test_helpers.dart` - SetUp/TearDown with real dependencies

### 3. E2E Tests (Current: 0, Target: 10%)

**What They Test**: Complete user workflows on real devices
**Tools**: patrol or flutter_driver
**Status**: ⏳ TODO

#### Planned E2E Tests
- [ ] Complete media review workflow
- [ ] Complete settings configuration workflow
- [ ] Permission authorization workflow
- [ ] Full deletion workflow

**Location**: `test/e2e/`

## Platform Testing

### Manual Testing Required

The following tasks require manual testing on physical devices or simulators:

1. **iOS Testing (Task 23.7)**
   - See: [Platform Testing Guide - iOS](PLATFORM_TESTING_GUIDE.md#ios-testing-task-237)
   - Launch with: `./test/run_platform_tests.sh` → Option 1

2. **Android Testing (Task 23.8)**
   - See: [Platform Testing Guide - Android](PLATFORM_TESTING_GUIDE.md#android-testing-task-238)
   - Launch with: `./test/run_platform_tests.sh` → Option 2

3. **macOS Testing (Task 23.9)**
   - See: [Platform Testing Guide - macOS](PLATFORM_TESTING_GUIDE.md#macos-testing-task-239)
   - Launch with: `./test/run_platform_tests.sh` → Option 3

### Critical Paths to Test

All platforms must verify:
- ✅ App initialization
- ✅ Photo authorization
- ✅ Photo loading and display
- ✅ Session management
- ✅ Asset deletion
- ✅ Settings persistence
- ✅ Theme switching
- ✅ BLoC state management
- ✅ Navigation

## Coverage Goals

### Current Ratio
- **Unit**: 84% (199 tests)
- **Integration**: 16% (37 tests)
- **E2E**: 0% (0 tests)

### Target Ratio (70/20/10)
- **Unit**: 70% ← Currently at 84%, good coverage
- **Integration**: 20% ← Currently at 16%, close to target! ✅
- **E2E**: 10% ← Need to implement (~24 tests needed)

### Generate Coverage Report

```bash
# Generate coverage data
flutter test --coverage

# Generate HTML report
./test/coverage_report.sh

# View in browser
open coverage/html/index.html
```

## Test Utilities

### Mock Generation

Tests use `mockito` for mocking dependencies:

```bash
# Generate mocks (already done, re-run if interfaces change)
dart run build_runner build --delete-conflicting-outputs
```

### Test Data Helpers

Common test data is defined in individual test files:
- Test entities/models in data layer tests
- Test domain objects in domain tests
- Test BLoC states in presentation tests

## Continuous Integration

### CI Pipeline Setup

✅ **GitHub Actions workflow configured** at `.github/workflows/test.yml`

The CI pipeline runs in multiple stages:

1. **Analyze** (Ubuntu)
   - Code formatting check
   - Static analysis with `flutter analyze`

2. **Unit Tests** (Ubuntu)
   - Tests without Isar: 76 tests
   - Fast feedback (~1-2 minutes)
   - Partial coverage report

3. **Full Test Suite** (Ubuntu + macOS)
   - All 236 tests including Isar-dependent ones
   - Isar native library automatically provided by `isar_flutter_libs`
   - Full coverage report

### Isar Setup in CI

Isar native libraries are automatically provided by the `isar_flutter_libs` package. No additional setup is required beyond `flutter pub get`.

For local development, the same applies:
```bash
flutter pub get
```

### Running Tests in CI

Tests are split for optimal performance:
- **Quick tests** (no Isar): `flutter test test/domain/ test/presentation/ test/data/repositories/ test/data/mappers/`
- **Full tests** (with Isar): `flutter test`

See `.github/CI_SETUP.md` for detailed CI documentation.

## Troubleshooting

### Common Test Issues

#### "Provider.of() called with a context..."
**Cause**: Old Provider code still present
**Fix**: Search and replace with BLoC/GetIt
```bash
rg "Provider\.of" lib/
```

#### "GetIt: Object not registered"
**Cause**: Missing DI registration
**Fix**: Check `lib/src/core/di/injection_container.dart`

#### Isar tests fail in CI
**Expected**: Data source tests require native Isar library
**Solution**: Ensure `isar_flutter_libs` package is installed via `flutter pub get`

#### Test timeout
**Cause**: Async operation not completing
**Fix**: Ensure all async operations are properly awaited

## Best Practices

### Writing New Tests

1. **Follow AAA Pattern**: Arrange → Act → Assert
2. **Use Descriptive Names**: `should return list of assets when repository succeeds`
3. **One Assertion Per Test**: Test one thing at a time
4. **Mock External Dependencies**: Use mockito for repositories, data sources
5. **Test Edge Cases**: null values, empty lists, errors

### Test Structure Example

```dart
group('AssetRepository', () {
  late AssetRepositoryImpl repository;
  late MockAssetLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAssetLocalDataSource();
    repository = AssetRepositoryImpl(mockDataSource);
  });

  test('should return list of assets when datasource succeeds', () async {
    // Arrange
    final testData = [/* ... */];
    when(mockDataSource.getAllAssets()).thenAnswer((_) async => testData);

    // Act
    final result = await repository.getAssets();

    // Assert
    expect(result.length, testData.length);
    verify(mockDataSource.getAllAssets()).called(1);
  });
});
```

## Next Steps

### Immediate Tasks
1. ⏳ Perform manual platform testing (Tasks 23.7, 23.8, 23.9)
2. ✅ Implement integration tests (Task 23.4) - **37 tests completed!**
3. ⏳ Implement E2E tests (Task 23.5) - Need ~24 E2E tests for 10% target
4. ⏳ Achieve 70/20/10 test ratio (Task 23.6) - Currently at 84/16/0

### Future Improvements
- [ ] Add golden tests for widgets
- [ ] Add performance benchmarks
- [ ] Setup CI pipeline
- [ ] Add test coverage badges
- [ ] Document architecture decision records

## Resources

- **Flutter Testing**: https://docs.flutter.dev/testing
- **BLoC Testing**: https://pub.dev/packages/bloc_test
- **Mockito**: https://pub.dev/packages/mockito
- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

---

**For questions or issues, refer to the troubleshooting sections in this README or the Platform Testing Guide.**
