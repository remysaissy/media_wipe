# Platform Testing Checklist

This checklist provides a step-by-step guide for manual platform testing after the Clean Architecture refactoring. Use this document to track testing progress across iOS, Android, and macOS.

## Testing Status

- [ ] **iOS Testing Complete** (Task 23.7)
- [ ] **Android Testing Complete** (Task 23.8)
- [ ] **macOS Testing Complete** (Task 23.9)
- [ ] **All Features Verified** (Task 23.10)

---

## Pre-Testing Validation

Before starting manual platform testing, verify that all automated tests pass:

```bash
# Run automated validation
./test/run_platform_tests.sh

# Or manually:
flutter analyze                    # Should show 4 acceptable warnings
dart format --set-exit-if-changed . # Should pass
flutter test test/                 # Run unit tests (76 passing in CI)
flutter test test/integration/     # Run integration tests (require ObjectBox)
flutter test test_e2e/             # Run E2E tests
```

**Automated Test Status:**
- [ ] Flutter analyze passes (4 acceptable warnings)
- [ ] Code formatting validated
- [ ] Unit tests passing (76/76 in CI, 199/199 with ObjectBox)
- [ ] Integration tests passing (37/37 with ObjectBox)
- [ ] E2E tests passing (12/12)

---

## iOS Testing (Task 23.7)

### Setup
```bash
# Clean and prepare
flutter clean
flutter pub get
cd ios && pod install && cd ..

# Build and run
flutter build ios --debug --simulator
flutter run -d <ios-simulator-id>
```

### Test Execution

#### Core Functionality
- [ ] **App Launch**: App launches without crashes
- [ ] **Loading Screen**: Initial loading view displays properly
- [ ] **Theme System**: Theme (light/dark/system) applies correctly
- [ ] **DI Container**: All BLoCs/Cubits initialized successfully (check logs)
- [ ] **ObjectBox**: Database initializes without errors

#### Authorization Flow
- [ ] Navigate to Settings successfully
- [ ] "Authorize Photos" button visible and tappable
- [ ] iOS permission dialog appears on tap
- [ ] Permission status updates after granting
- [ ] App can access photo library after authorization
- [ ] Permission persists after app restart

#### Media Management
- [ ] Years view displays with photo library data
- [ ] Can navigate to a specific year
- [ ] Can navigate to a specific month
- [ ] Photos load and display correctly
- [ ] Thumbnails render smoothly
- [ ] Asset counts are accurate

#### Review Session Workflow
- [ ] Can start a new review session
- [ ] Session state persists correctly
- [ ] Swipe gestures work (keep/drop)
- [ ] "Undo" operation works
- [ ] Asset counter updates in real-time
- [ ] Can finish session successfully
- [ ] Summary view displays correct counts

#### Deletion Flow
- [ ] Deletion confirmation dialog appears
- [ ] Deletion progress overlay shows
- [ ] Assets removed from local database
- [ ] **Dry-run mode ON**: Device assets preserved
- [ ] **Dry-run mode OFF**: Device assets deleted
- [ ] UI updates after deletion complete

#### Settings Management
- [ ] Theme dropdown accessible
- [ ] Can switch between Light/Dark/System themes
- [ ] Theme changes apply immediately
- [ ] Debug dry-removal toggle works
- [ ] Settings persist after app restart
- [ ] Back navigation from settings works

#### iOS-Specific Validation
- [ ] Photo library permission handled via PHPhotoLibrary
- [ ] App handles background/foreground transitions
- [ ] Memory usage reasonable (< 100MB for normal usage)
- [ ] No memory leaks (check Xcode Instruments)
- [ ] App works on iPhone and iPad simulators

### Issues Found
```
Document any issues discovered during iOS testing:

1. [Issue description]
   - Steps to reproduce:
   - Expected behavior:
   - Actual behavior:
   - Severity: [Critical/High/Medium/Low]

```

---

## Android Testing (Task 23.8)

### Setup
```bash
# Clean and prepare
flutter clean
flutter pub get

# Build and run
flutter build apk --debug
flutter run -d <android-emulator-id>
```

### Test Execution

#### Core Functionality
- [ ] **App Launch**: App launches without crashes
- [ ] **Loading Screen**: Initial loading view displays properly
- [ ] **Theme System**: Material Design theme applies correctly
- [ ] **DI Container**: All BLoCs/Cubits initialized successfully
- [ ] **ObjectBox**: Database initializes without errors

#### Permission Flow
- [ ] Navigate to Settings successfully
- [ ] "Authorize Photos" button visible
- [ ] Android storage permission dialog appears
- [ ] Permission status updates after granting
- [ ] Can access MediaStore after authorization
- [ ] Permission persists after app restart
- [ ] Handles permission denial gracefully

#### Media Management
- [ ] Years view displays with MediaStore data
- [ ] Can navigate to a specific year
- [ ] Can navigate to a specific month
- [ ] Photos load from MediaStore correctly
- [ ] Thumbnails render smoothly
- [ ] Asset counts match MediaStore

#### Review Session Workflow
- [ ] Can start a new review session
- [ ] Session persists across screen rotations
- [ ] Swipe gestures work smoothly
- [ ] "Undo" operation works
- [ ] Asset counter updates correctly
- [ ] Can finish session successfully
- [ ] Summary view displays correctly

#### Deletion Flow
- [ ] Deletion confirmation dialog appears
- [ ] Deletion progress shows
- [ ] Assets removed from local database
- [ ] **Dry-run mode ON**: Device assets preserved
- [ ] **Dry-run mode OFF**: Device assets deleted via MediaStore
- [ ] UI updates after deletion

#### Settings Management
- [ ] Theme dropdown accessible
- [ ] Can switch themes
- [ ] Theme changes apply immediately
- [ ] Debug dry-removal toggle works
- [ ] Settings persist after restart
- [ ] Back button navigation works

#### Android-Specific Validation
- [ ] Storage permission handled correctly (API 29+)
- [ ] MediaStore queries work correctly
- [ ] App handles screen rotations
- [ ] Back button navigation works system-wide
- [ ] Scoped storage compliance (Android 10+)
- [ ] Works on different API levels (test on API 29 and 33+)

### Issues Found
```
Document any issues discovered during Android testing:

1. [Issue description]
   - Steps to reproduce:
   - Expected behavior:
   - Actual behavior:
   - Severity: [Critical/High/Medium/Low]

```

---

## macOS Testing (Task 23.9)

### Setup
```bash
# Clean and prepare
flutter clean
flutter pub get

# Build and run
flutter build macos --debug
flutter run -d macos
```

### Test Execution

#### Core Functionality
- [ ] **App Launch**: App launches without crashes
- [ ] **Window Management**: Main window displays correctly
- [ ] **Loading Screen**: Initial loading view displays
- [ ] **Theme System**: macOS theme integration works
- [ ] **DI Container**: All BLoCs/Cubits initialized
- [ ] **ObjectBox**: Database initializes without errors

#### Authorization Flow
- [ ] Navigate to Settings
- [ ] "Authorize Photos" button visible
- [ ] macOS photo library permission dialog appears
- [ ] Permission status updates
- [ ] Can access Photos library after authorization
- [ ] Permission persists after app restart

#### Media Management
- [ ] Years view displays with Photos library data
- [ ] Can navigate through years and months
- [ ] Photos load correctly
- [ ] Thumbnails render properly
- [ ] Mouse/trackpad interactions work
- [ ] Keyboard shortcuts work (if implemented)

#### Review Session Workflow
- [ ] Can start review session
- [ ] Session state persists
- [ ] Click/keyboard navigation works
- [ ] "Undo" operation works
- [ ] Can finish session successfully
- [ ] Summary displays correctly

#### Deletion Flow
- [ ] Deletion confirmation appears
- [ ] Deletion progress shows
- [ ] Assets removed from database
- [ ] **Dry-run mode**: Device assets handling correct
- [ ] UI updates properly

#### Settings Management
- [ ] Theme dropdown accessible
- [ ] Theme switching works
- [ ] Settings persist
- [ ] Window resize handling works

#### macOS-Specific Validation
- [ ] Photos library framework integration works
- [ ] Menu bar integration (if present)
- [ ] Window management (minimize/maximize/close)
- [ ] App follows macOS HIG guidelines
- [ ] Native file dialogs work (if used)
- [ ] Retina display rendering correct

### Issues Found
```
Document any issues discovered during macOS testing:

1. [Issue description]
   - Steps to reproduce:
   - Expected behavior:
   - Actual behavior:
   - Severity: [Critical/High/Medium/Low]

```

---

## Feature Verification (Task 23.10)

### Verify All Features Work as Before Refactoring

This section ensures that the Clean Architecture refactoring hasn't broken any existing functionality.

#### Pre-Refactoring Feature List
- [ ] Photo library access and authorization
- [ ] Year-based photo organization
- [ ] Month-based photo browsing
- [ ] Swipe-based review sessions
- [ ] Keep/Drop decision making
- [ ] Undo last operation
- [ ] Session summary view
- [ ] Asset deletion (with dry-run mode)
- [ ] Theme switching (Light/Dark/System)
- [ ] Settings persistence
- [ ] Debug mode toggle
- [ ] In-app review prompts (if applicable)

#### Cross-Platform Consistency
- [ ] UI renders consistently across platforms
- [ ] Core workflows identical on iOS/Android/macOS
- [ ] Settings sync correctly
- [ ] Theme behavior consistent

#### Performance Verification
- [ ] App launch time < 3 seconds
- [ ] Photo loading smooth (no jank)
- [ ] Swipe gestures responsive
- [ ] Database queries fast (< 100ms for typical operations)
- [ ] Memory usage stable (no leaks)

#### BLoC/Cubit State Management Verification
- [ ] MediaBloc: LoadMediaEvent triggers correctly
- [ ] MediaBloc: RefreshMediaEvent works
- [ ] MediaBloc: DeleteMediaEvent completes successfully
- [ ] SessionCubit: startSession() works
- [ ] SessionCubit: keepAsset()/dropAsset() update state
- [ ] SessionCubit: undoLastOperation() reverts correctly
- [ ] SessionCubit: finishSession() completes
- [ ] SettingsCubit: loadSettings() initializes
- [ ] SettingsCubit: updateTheme() applies immediately
- [ ] SettingsCubit: toggles persist

#### Clean Architecture Validation
- [ ] Presentation layer doesn't import data layer directly
- [ ] Domain layer has no Flutter dependencies
- [ ] Use cases properly orchestrate business logic
- [ ] Repositories abstract data source details
- [ ] Dependency injection works correctly
- [ ] All layers testable in isolation

---

## Post-Testing Summary

### Overall Results

**Platforms Tested:**
- iOS: [Pass/Fail/Partial] - [Date]
- Android: [Pass/Fail/Partial] - [Date]
- macOS: [Pass/Fail/Partial] - [Date]

**Critical Issues Found:** [Number]
**High Priority Issues:** [Number]
**Medium/Low Issues:** [Number]

**Test Coverage Achieved:**
- Unit Tests: 199/199 (100%)
- Integration Tests: 37/37 (100%)
- E2E Tests: 12/12 (100%)
- Manual Platform Tests: [X]/3 platforms

**Refactoring Success Criteria:**
- [ ] All automated tests passing
- [ ] All platforms tested successfully
- [ ] No critical bugs found
- [ ] Performance maintained or improved
- [ ] Clean Architecture principles validated
- [ ] All features working as before refactoring

### Sign-Off

**Tested By:** ___________________
**Date:** ___________________
**Architecture Validated:** Yes / No
**Ready for Production:** Yes / No

### Notes

```
Additional observations, recommendations, or follow-up actions:



```

---

## Quick Reference Commands

```bash
# Run all automated tests
./test/run_platform_tests.sh

# Run specific test types
flutter test test/                     # Unit tests
flutter test test/integration/         # Integration tests
flutter test test_e2e/                 # E2E tests

# Generate coverage report
./test/coverage_report.sh

# Platform builds
flutter build ios --debug --simulator  # iOS
flutter build apk --debug              # Android
flutter build macos --debug            # macOS

# Run on specific platform
flutter run -d <device-id>

# Clean build
flutter clean && flutter pub get
```

For detailed platform-specific instructions, see `test/PLATFORM_TESTING_GUIDE.md`.
