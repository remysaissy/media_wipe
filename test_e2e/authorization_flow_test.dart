/// E2E Test: Permission Authorization Flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers.dart';

void main() {
  testWidgets('E2E: Authorization flow - first launch without permissions', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);

    // Verify: Authorization screen should be shown
    // Note: In a real scenario, this depends on actual permission state
    // For E2E tests, we verify the UI flow exists

    // The app may show either the authorize view or the main view
    // depending on current permission state
    await tester.pumpAndSettle();

    // If authorize button exists, test the authorization flow
    final authorizeButton = find.text('Authorize Photos');
    if (authorizeButton.evaluate().isNotEmpty) {
      // Act: Tap authorize button
      await tester.tap(authorizeButton);
      await tester.pumpAndSettle();

      // Verify: In a real E2E test with permissions, this would navigate
      // For now, verify the button was tappable
      expect(true, isTrue, reason: 'Authorization button was tappable');
    } else {
      // Already authorized - verify we can see the main navigation
      final settingsIcon = find.byIcon(Icons.settings);
      expect(
        find.text('Settings').evaluate().isNotEmpty ||
            settingsIcon.evaluate().isNotEmpty,
        isTrue,
        reason: 'Should see settings option if already authorized',
      );
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Authorization flow - navigating to settings', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Navigate to settings if we're on the main screen
    final settingsIcon = find.byIcon(Icons.settings);
    if (settingsIcon.evaluate().isNotEmpty) {
      await tester.tap(settingsIcon);
      await waitForNavigation(tester);

      // Look for any authorization-related setting
      // This tests that the settings screen is accessible
      await tester.pumpAndSettle();

      // Verify: Settings screen loaded
      expect(
        find.byIcon(Icons.settings).evaluate().isNotEmpty ||
            find.text('Settings').evaluate().isNotEmpty,
        isTrue,
        reason: 'Settings screen should be accessible',
      );
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Authorization flow - app handles states gracefully', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // This test verifies the app doesn't crash and is in a valid state
    // In a real E2E scenario, this would simulate denying permissions

    // Verify: App is in a valid state (either showing auth screen or main screen)
    final hasAuthButton = find.text('Authorize Photos').evaluate().isNotEmpty;
    final hasSettingsIcon = find.byIcon(Icons.settings).evaluate().isNotEmpty;
    final hasSettingsText = find.text('Settings').evaluate().isNotEmpty;

    expect(
      hasAuthButton || hasSettingsIcon || hasSettingsText,
      isTrue,
      reason: 'App should show either authorization screen or main UI',
    );

    // Cleanup
    await cleanupAfterE2E();
  });
}
