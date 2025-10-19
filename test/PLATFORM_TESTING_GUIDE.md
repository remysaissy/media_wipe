# Platform Testing Guide

This guide provides comprehensive instructions for manual testing across iOS, Android, and macOS platforms after the Clean Architecture refactoring.

## Prerequisites

Before starting manual testing:
- [ ] All unit tests passing (`flutter test`)
- [ ] No compilation errors (`flutter analyze`)
- [ ] Code formatted (`dart format .`)
- [ ] All BLoCs/Cubits properly registered in DI container
- [ ] Build succeeds on target platform

## Test Coverage Status

Current automated test coverage:
- **Unit Tests**: 199 tests (76 passing in CI, 123 require ObjectBox runtime)
  - BLoC/Cubit tests: 16/16 ✓
  - Use Case tests: 23/23 ✓
  - Repository tests: 33/33 ✓
  - Mapper tests: 43/43 ✓
  - Data source tests: 57/57 (require native ObjectBox)
  - Widget tests: 17/17 ✓

Target: 70% unit / 20% integration / 10% E2E

---

## iOS Testing (Task 23.7)

### Build & Launch
```bash
# Clean build
flutter clean
flutter pub get
cd ios && pod install && cd ..

# Build for iOS simulator
flutter build ios --debug --simulator

# Run on simulator (select device first)
flutter devices
flutter run -d <ios-simulator-id>
```

### Critical Path Tests

#### 1. App Initialization
- [ ] App launches without crashes
- [ ] Loading view displays correctly
- [ ] No ObjectBox initialization errors in logs
- [ ] Theme applies correctly (system/light/dark)

#### 2. Photo Authorization (Settings → Authorize Photos)
- [ ] Navigate to Settings
- [ ] Tap "Authorize Photos" button
- [ ] iOS permission dialog appears
- [ ] After granting permission, status updates to "Granted"
- [ ] BLoC state properly reflects authorization status

#### 3. Photo Refresh (Home → Year View)
- [ ] Select a year from the list
- [ ] Tap refresh button
- [ ] Loading indicator displays
- [ ] Photos load and display in grid/list
- [ ] Correct asset count shown
- [ ] Navigation to month view works

#### 4. Session Management (Review Flow)
- [ ] Start a new review session
- [ ] Session state shows "In Progress"
- [ ] Swipe gestures work (keep/drop)
- [ ] Undo last operation works
- [ ] Asset counter updates correctly
- [ ] Finish session completes successfully

#### 5. Media Deletion
- [ ] Select assets to delete
- [ ] Confirm deletion dialog appears
- [ ] Deletion in progress overlay shows
- [ ] Assets removed from local DB
- [ ] If debugDryRemoval=true, device assets preserved
- [ ] If debugDryRemoval=false, device assets deleted

#### 6. Settings Management
- [ ] Theme dropdown shows all options (Light/Dark/System)
- [ ] Changing theme updates UI immediately
- [ ] Debug dry removal switch toggles
- [ ] Settings persist after app restart
- [ ] In-app review prompt works (if applicable)

### iOS-Specific Checks
- [ ] Photo library permission status persists
- [ ] Background/foreground transitions work
- [ ] Memory usage reasonable (check Instruments)
- [ ] No retain cycles (check Xcode memory graph)
- [ ] PHAsset access works correctly
- [ ] Thumbnail loading is smooth

### Known Issues to Verify
- [ ] No Provider-related errors in logs
- [ ] All BLoC events properly handled
- [ ] No missing route errors
- [ ] ObjectBox queries execute successfully

---

## Android Testing (Task 23.8)

### Build & Launch
```bash
# Clean build
flutter clean
flutter pub get

# Build for Android emulator
flutter build apk --debug

# Run on emulator
flutter devices
flutter run -d <android-emulator-id>
```

### Critical Path Tests

#### 1. App Initialization
- [ ] App launches without crashes
- [ ] Loading view displays correctly
- [ ] No ObjectBox initialization errors
- [ ] Theme applies correctly
- [ ] Material Design components render properly

#### 2. Storage Permission (Settings → Authorize Photos)
- [ ] Navigate to Settings
- [ ] Tap "Authorize Photos" button
- [ ] Android storage permission dialog appears
- [ ] After granting permission, status updates
- [ ] Permission persists after app restart

#### 3. Media Access (Home → Year View)
- [ ] Select a year from the list
- [ ] Photos load from MediaStore
- [ ] Thumbnails display correctly
- [ ] Scroll performance is smooth
- [ ] Navigation to month/detail views works

#### 4. Session Management (Review Flow)
- [ ] Start a new review session
- [ ] Session persists across screen rotations
- [ ] Keep/drop operations work
- [ ] Undo functionality works
- [ ] Session summary displays correctly
- [ ] Finish session completes

#### 5. Media Deletion
- [ ] Select multiple assets
- [ ] Deletion confirmation dialog
- [ ] Progress indicator shows
- [ ] MediaStore deletion works (if debugDryRemoval=false)
- [ ] Local DB updated correctly
- [ ] No orphaned records

#### 6. Settings Persistence
- [ ] Change theme to Dark
- [ ] Restart app → theme persists
- [ ] Toggle debug switch
- [ ] Restart app → setting persists
- [ ] ObjectBox database maintains data

### Android-Specific Checks
- [ ] Back button navigation works
- [ ] Screen rotation preserves BLoC state
- [ ] Memory usage acceptable (check Android Profiler)
- [ ] No ANR (Application Not Responding) dialogs
- [ ] MediaStore queries efficient
- [ ] No Scoped Storage issues (Android 10+)

### Known Issues to Verify
- [ ] No Provider dependency injection errors
- [ ] GetIt service locator working
- [ ] All routes properly configured
- [ ] ObjectBox native library loaded

---

## macOS Testing (Task 23.9)

### Build & Launch
```bash
# Clean build
flutter clean
flutter pub get
cd macos && pod install && cd ..

# Build for macOS
flutter build macos --debug

# Run on macOS
flutter run -d macos
```

### Critical Path Tests

#### 1. App Initialization
- [ ] App launches without crashes
- [ ] Window appears with correct size
- [ ] Menu bar items present
- [ ] Loading view displays
- [ ] Theme applies correctly

#### 2. File System Access (Settings → Authorize Photos)
- [ ] Navigate to Settings
- [ ] Tap "Authorize Photos" button
- [ ] macOS file access permission dialog appears
- [ ] After granting permission, can access photos
- [ ] Permission persists in System Preferences

#### 3. Photo Library Access (Home → Year View)
- [ ] Select a year from the list
- [ ] Photos load from Photos.app library
- [ ] Thumbnails render correctly
- [ ] Smooth scrolling performance
- [ ] Click navigation works

#### 4. Session Management (Review Flow)
- [ ] Start a new review session
- [ ] Keyboard shortcuts work (if implemented)
- [ ] Session state persists
- [ ] Undo operation works
- [ ] Finish session completes

#### 5. Media Operations
- [ ] Select assets for deletion
- [ ] Confirmation dialog appears
- [ ] Deletion executes (respects debugDryRemoval)
- [ ] Local DB updates
- [ ] No file permission errors

#### 6. Settings & Preferences
- [ ] Theme changes apply immediately
- [ ] Settings persist across launches
- [ ] ObjectBox database location correct
- [ ] Preferences window works (if applicable)

### macOS-Specific Checks
- [ ] Window resizing works smoothly
- [ ] Full-screen mode works
- [ ] Menu items functional
- [ ] Keyboard shortcuts work
- [ ] Mouse/trackpad interactions smooth
- [ ] Sandbox entitlements correct
- [ ] Photo library entitlement working
- [ ] No Gatekeeper issues

### Known Issues to Verify
- [ ] ObjectBox library compatible with macOS architecture
- [ ] Photo library access via PhotoKit works
- [ ] No sandboxing violations
- [ ] All native dependencies linked

---

## Cross-Platform Regression Tests

### Core Functionality (All Platforms)
- [ ] App launches successfully
- [ ] Initial loading completes
- [ ] Navigation between screens works
- [ ] BLoC state management working
- [ ] GetIt dependency injection working
- [ ] ObjectBox database operations succeed

### State Management
- [ ] MediaBloc handles LoadMedia event
- [ ] MediaBloc handles RefreshMedia event
- [ ] MediaBloc handles DeleteMedia event
- [ ] SessionCubit manages session lifecycle
- [ ] SettingsCubit persists settings
- [ ] No Provider-related errors

### Data Layer
- [ ] AssetRepository operations work
- [ ] SessionRepository operations work
- [ ] SettingsRepository operations work
- [ ] Entity/domain mapping correct
- [ ] ObjectBox queries execute

### UI/UX Consistency
- [ ] Theme switching works on all platforms
- [ ] Loading states display correctly
- [ ] Error states handled gracefully
- [ ] Empty states show appropriate messages
- [ ] Animations smooth (if any)

---

## Performance Benchmarks

### Memory Usage
- iOS: Target < 150 MB during photo browsing
- Android: Target < 200 MB during photo browsing
- macOS: Target < 250 MB during photo browsing

### Load Times
- App launch: < 2 seconds
- Photo year list: < 1 second
- Photo month list: < 1 second
- Thumbnail loading: < 500ms per batch

### Database Operations
- Insert 1000 assets: < 1 second
- Query by year: < 100ms
- Delete batch: < 500ms
- ObjectBox initialization: < 300ms

---

## Troubleshooting Guide

### Common Issues

#### "Provider.of() called with a context that does not contain a Provider"
- **Cause**: Old Provider code still referenced
- **Fix**: Search codebase for `Provider.of` and replace with BLoC/GetIt
- **Verification**: `rg "Provider\.of" lib/`

#### "GetIt: Object/factory with type X is not registered"
- **Cause**: Missing DI registration in injection_container.dart
- **Fix**: Add registration in `lib/src/core/di/injection_container.dart`
- **Verification**: Check all BLoCs/Cubits/UseCases registered

#### "Cannot find module 'objectbox'" (iOS)
- **Cause**: CocoaPods not installed or outdated
- **Fix**: `cd ios && pod install && cd ..`
- **Verification**: Check `ios/Pods/` directory exists

#### ObjectBox initialization fails
- **Cause**: Database file corrupted or permissions issue
- **Fix**: Clear app data or reinstall
- **Verification**: Check app logs for ObjectBox errors

#### Photos not loading
- **Cause**: Permission not granted or photo library access issue
- **Fix**: Check Settings → authorize photos
- **Verification**: Verify permission status in system settings

---

## Sign-Off Checklist

Before marking platform testing complete, ensure:

### iOS (Task 23.7)
- [ ] All critical path tests passed
- [ ] No crashes or ANR during 30-minute session
- [ ] Memory usage acceptable
- [ ] Photos authorization works
- [ ] Photo operations work
- [ ] Settings persist
- [ ] Theme switching works

### Android (Task 23.8)
- [ ] All critical path tests passed
- [ ] No crashes or ANR during 30-minute session
- [ ] Memory usage acceptable
- [ ] Storage permission works
- [ ] MediaStore access works
- [ ] Settings persist
- [ ] Theme switching works

### macOS (Task 23.9)
- [ ] All critical path tests passed
- [ ] No crashes during 30-minute session
- [ ] Memory usage acceptable
- [ ] Photo library access works
- [ ] File operations work
- [ ] Settings persist
- [ ] Theme switching works

### Cross-Platform
- [ ] Same BLoC logic produces consistent behavior
- [ ] Same UI layouts render correctly
- [ ] Same features available on all platforms
- [ ] Performance comparable across platforms

---

## Reporting Issues

When reporting issues found during manual testing:

1. **Platform**: iOS/Android/macOS
2. **Device/Version**: e.g., iPhone 14 Pro / iOS 17.2
3. **Steps to Reproduce**:
   - Step 1: ...
   - Step 2: ...
   - Step 3: ...
4. **Expected Behavior**: What should happen
5. **Actual Behavior**: What actually happened
6. **Logs**: Relevant console output
7. **Screenshots/Video**: If applicable
8. **Severity**: Critical/High/Medium/Low

---

## Completion Criteria

Platform testing is complete when:
- All critical path tests pass on all three platforms
- No critical or high-severity bugs remain
- Performance benchmarks met
- All BLoCs/Cubits functioning correctly
- State management working consistently
- Data persistence verified
- Settings synchronization confirmed

**Next Steps**: After platform testing completion, update tasks.md and proceed to integration/E2E tests if needed.
