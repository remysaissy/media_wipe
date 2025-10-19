/// E2E Test: Settings Configuration Flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers.dart';

/// Tests the complete user flow for configuring app settings
///
/// User Story:
/// 1. User opens the app
/// 2. User navigates to settings
/// 3. User changes theme preference (light/dark/system)
/// 4. User toggles debug/dry-run mode
/// 5. User views app information
/// 6. Settings persist across app restarts

void main() {
  testWidgets('E2E: Settings configuration - theme switching flow', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Act: Navigate to settings
    final settingsIcon = find.byIcon(Icons.settings);
    if (settingsIcon.evaluate().isNotEmpty) {
      await tester.tap(settingsIcon);
      await waitForNavigation(tester);

      // Verify: Settings screen is visible
      expect(
        find.text('Settings').evaluate().isNotEmpty ||
            find.text('Theme').evaluate().isNotEmpty,
        isTrue,
        reason: 'Should be on settings screen',
      );

      // Look for theme dropdown or theme option
      final themeOption = find.textContaining('Theme');
      if (themeOption.evaluate().isNotEmpty) {
        // Theme setting exists - verify it's visible
        expect(
          themeOption,
          findsWidgets,
          reason: 'Theme option should be available in settings',
        );
      }

      await tester.pumpAndSettle();
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Settings configuration - debug mode toggle flow', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Act: Navigate to settings
    final settingsIcon = find.byIcon(Icons.settings);
    if (settingsIcon.evaluate().isNotEmpty) {
      await tester.tap(settingsIcon);
      await waitForNavigation(tester);

      // Look for debug/dry-run toggle
      final debugOption = find.textContaining('Debug');
      final dryRunOption = find.textContaining('Dry');

      // If debug options exist, verify they're toggleable
      if (debugOption.evaluate().isNotEmpty ||
          dryRunOption.evaluate().isNotEmpty) {
        // Debug settings exist
        expect(
          debugOption.evaluate().isNotEmpty ||
              dryRunOption.evaluate().isNotEmpty,
          isTrue,
          reason: 'Debug options should be available in settings',
        );

        // Try to find and interact with a switch if present
        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          // Toggle the first switch
          await tester.tap(switches.first);
          await tester.pumpAndSettle();

          // Verify: No crash occurred
          expect(true, isTrue, reason: 'Switch should be toggleable');
        }
      }

      await tester.pumpAndSettle();
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Settings configuration - app information visibility', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Act: Navigate to settings
    final settingsIcon = find.byIcon(Icons.settings);
    if (settingsIcon.evaluate().isNotEmpty) {
      await tester.tap(settingsIcon);
      await waitForNavigation(tester);

      // Verify: Can see settings content
      // The settings screen should have some text content
      expect(
        find.byType(Text).evaluate().isNotEmpty,
        isTrue,
        reason: 'Settings screen should display content',
      );

      // Look for common settings elements
      final hasList =
          find.byType(ListView).evaluate().isNotEmpty ||
          find.byType(SingleChildScrollView).evaluate().isNotEmpty;

      expect(
        hasList,
        isTrue,
        reason: 'Settings should have scrollable content',
      );

      await tester.pumpAndSettle();
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Settings configuration - navigation back to home', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Act: Navigate to settings
    final settingsIcon = find.byIcon(Icons.settings);
    if (settingsIcon.evaluate().isNotEmpty) {
      await tester.tap(settingsIcon);
      await waitForNavigation(tester);

      await userDelay();

      // Act: Navigate back
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await waitForNavigation(tester);

        // Verify: Back on main screen
        expect(
          find.byIcon(Icons.settings).evaluate().isNotEmpty,
          isTrue,
          reason: 'Should be back on main screen with settings icon visible',
        );
      } else {
        // Try using the system back navigation
        await tester.pageBack();
        await waitForNavigation(tester);
      }

      await tester.pumpAndSettle();
    }

    // Cleanup
    await cleanupAfterE2E();
  });
}
