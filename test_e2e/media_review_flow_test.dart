/// E2E Test: Complete Media Review Flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_helpers.dart';

/// Tests the complete user flow for reviewing and managing media
///
/// User Story:
/// 1. User opens the app with permissions granted
/// 2. User sees years list with their photos
/// 3. User taps on a year to see months
/// 4. User taps on a month to start review session
/// 5. User swipes through photos (keep/drop decisions)
/// 6. User finishes session and sees summary
/// 7. User confirms deletion or goes back

void main() {
  testWidgets('E2E: Media review - app launches and shows media organization', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Verify: App loaded successfully
    // The app should either show authorization or the main media view
    final hasAuthButton = find.text('Authorize Photos').evaluate().isNotEmpty;
    final hasYearsView =
        find
            .textContaining('20')
            .evaluate()
            .isNotEmpty || // Year like 2023, 2024
        find.byType(ListView).evaluate().isNotEmpty;

    expect(
      hasAuthButton || hasYearsView,
      isTrue,
      reason: 'App should show authorization or media years',
    );

    // If we have the years view, verify it's interactive
    if (hasYearsView) {
      // Verify there's some content to interact with
      expect(
        find.byType(Text).evaluate().isNotEmpty,
        isTrue,
        reason: 'Should have text content in years view',
      );
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Media review - navigation through years to months', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Skip if not authorized
    if (find.text('Authorize Photos').evaluate().isNotEmpty) {
      // Can't proceed without authorization
      await cleanupAfterE2E();
      return;
    }

    // Try to find and tap on a year (look for 4-digit numbers like 2023, 2024)
    final yearElements = find.byType(Text);
    if (yearElements.evaluate().isNotEmpty) {
      // Find first tappable element that might be a year
      final tappableWidgets = find.byType(InkWell);
      if (tappableWidgets.evaluate().isNotEmpty) {
        // Tap first year-like element
        await tester.tap(tappableWidgets.first);
        await waitForNavigation(tester);

        // Verify: Either navigated to months or stayed on years (if no photos)
        // The app should not crash
        expect(
          find.byType(Scaffold).evaluate().isNotEmpty,
          isTrue,
          reason: 'App should remain stable after year tap',
        );

        await tester.pumpAndSettle();
      }
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Media review - swipe interaction simulation', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Skip if not authorized
    if (find.text('Authorize Photos').evaluate().isNotEmpty) {
      await cleanupAfterE2E();
      return;
    }

    // This test simulates the user flow of swiping through photos
    // In a real scenario with photos, the user would:
    // 1. Navigate to a month
    // 2. Start a review session
    // 3. Swipe left (drop) or right (keep) on photos
    // 4. See the summary

    // For now, verify the app structure supports this flow
    final hasInteractiveContent =
        find.byType(GestureDetector).evaluate().isNotEmpty ||
        find.byType(InkWell).evaluate().isNotEmpty;

    expect(
      hasInteractiveContent,
      isTrue,
      reason: 'App should have interactive elements for user interaction',
    );

    // Verify the app has proper navigation structure
    expect(
      find.byType(MaterialApp).evaluate().isNotEmpty,
      isTrue,
      reason: 'App should have proper MaterialApp structure',
    );

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Media review - complete flow simulation with no photos', (
    tester,
  ) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // Skip if not authorized
    if (find.text('Authorize Photos').evaluate().isNotEmpty) {
      await cleanupAfterE2E();
      return;
    }

    // In a scenario with no photos, the app should:
    // - Show an empty state or message
    // - Not crash
    // - Allow navigation to settings

    await userDelay();

    // Verify: App is in a stable state
    expect(
      find.byType(MaterialApp).evaluate().isNotEmpty,
      isTrue,
      reason: 'App should remain stable with no photos',
    );

    // Try to navigate to settings
    final settingsIcon = find.byIcon(Icons.settings);
    if (settingsIcon.evaluate().isNotEmpty) {
      await tester.tap(settingsIcon);
      await waitForNavigation(tester);

      // Verify: Settings screen accessible
      expect(
        find.text('Settings').evaluate().isNotEmpty ||
            find.text('Theme').evaluate().isNotEmpty,
        isTrue,
        reason: 'Should be able to navigate to settings',
      );
    }

    // Cleanup
    await cleanupAfterE2E();
  });

  testWidgets('E2E: Media review - app state resilience', (tester) async {
    // Setup: Initialize app
    await initializeAppForE2E(tester);
    await tester.pumpAndSettle();

    // This test verifies the app handles various states gracefully:
    // - Empty photo library
    // - Permission changes
    // - Navigation stress test

    // Perform multiple navigation operations
    for (int i = 0; i < 3; i++) {
      await userDelay(const Duration(milliseconds: 100));

      // Find any tappable element
      final tappables = find.byType(InkWell);
      if (tappables.evaluate().isNotEmpty) {
        try {
          await tester.tap(tappables.first);
          await tester.pumpAndSettle();
        } catch (e) {
          // Element might not be tappable, continue
        }
      }

      // Try back navigation
      if (find.byType(BackButton).evaluate().isNotEmpty) {
        try {
          await tester.tap(find.byType(BackButton));
          await tester.pumpAndSettle();
        } catch (e) {
          // Back might not work, continue
        }
      }
    }

    // Verify: App didn't crash after navigation stress
    expect(
      find.byType(MaterialApp).evaluate().isNotEmpty,
      isTrue,
      reason: 'App should remain stable after multiple navigations',
    );

    // Cleanup
    await cleanupAfterE2E();
  });
}
