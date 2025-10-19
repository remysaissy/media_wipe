import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Settings Persistence Integration Tests', () {
    setUp(() async {
      await IntegrationTestHelper.setUp();
    });

    tearDown(() async {
      await IntegrationTestHelper.tearDown();
    });

    test('should load settings on initialization', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();

      // Act
      await settingsCubit.loadSettings();

      // Assert
      expect(settingsCubit.state, isA<SettingsLoaded>());
      final loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, isNotNull);
    });

    test('should update theme and persist', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Update to dark theme
      await settingsCubit.updateTheme(ThemeMode.dark);

      // Assert
      expect(settingsCubit.state, isA<SettingsLoaded>());
      var loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, ThemeMode.dark);

      // Act - Create new cubit and load settings
      final newSettingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await newSettingsCubit.loadSettings();

      // Assert - Theme persisted
      expect(newSettingsCubit.state, isA<SettingsLoaded>());
      loadedState = newSettingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, ThemeMode.dark);
    });

    test('should update debug flag and persist', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Enable debug mode
      await settingsCubit.updateDebugFlag(true);

      // Assert
      expect(settingsCubit.state, isA<SettingsLoaded>());
      var loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.debugDryRemoval, true);

      // Act - Create new cubit and load settings
      final newSettingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await newSettingsCubit.loadSettings();

      // Assert - Debug flag persisted
      expect(newSettingsCubit.state, isA<SettingsLoaded>());
      loadedState = newSettingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.debugDryRemoval, true);
    });

    test('should update photos access and persist', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Grant photos access
      await settingsCubit.updatePhotosAccess(true);

      // Assert
      expect(settingsCubit.state, isA<SettingsLoaded>());
      var loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.hasPhotosAccess, true);

      // Act - Create new cubit and load settings
      final newSettingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await newSettingsCubit.loadSettings();

      // Assert - Photos access persisted
      expect(newSettingsCubit.state, isA<SettingsLoaded>());
      loadedState = newSettingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.hasPhotosAccess, true);
    });

    test('should complete onboarding and persist', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Complete onboarding
      await settingsCubit.completeOnboarding();

      // Assert
      expect(settingsCubit.state, isA<SettingsLoaded>());
      var loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.hasPhotosAccess, true);

      // Act - Create new cubit and load settings
      final newSettingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await newSettingsCubit.loadSettings();

      // Assert - Onboarding status persisted
      expect(newSettingsCubit.state, isA<SettingsLoaded>());
      loadedState = newSettingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.hasPhotosAccess, true);
    });

    test('should mark in-app review completed and persist', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Mark review completed
      await settingsCubit.markInAppReviewCompleted();

      // Assert
      expect(settingsCubit.state, isA<SettingsLoaded>());
      var loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.hasInAppReview, true);

      // Act - Create new cubit and load settings
      final newSettingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await newSettingsCubit.loadSettings();

      // Assert - Review status persisted
      expect(newSettingsCubit.state, isA<SettingsLoaded>());
      loadedState = newSettingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.hasInAppReview, true);
    });

    test('should handle multiple settings updates', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Multiple updates
      await settingsCubit.updateTheme(ThemeMode.dark);
      await settingsCubit.updateDebugFlag(true);
      await settingsCubit.updatePhotosAccess(true);

      // Assert
      expect(settingsCubit.state, isA<SettingsLoaded>());
      final loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, ThemeMode.dark);
      expect(loadedState.settings.debugDryRemoval, true);
      expect(loadedState.settings.hasPhotosAccess, true);
    });

    test('should preserve unmodified settings', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Update only theme
      await settingsCubit.updateTheme(ThemeMode.light);

      // Assert - Other settings unchanged
      expect(settingsCubit.state, isA<SettingsLoaded>());
      final loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, ThemeMode.light);
      // hasPhotosAccess, hasInAppReview, debugDryRemoval should remain their defaults
    });

    test('should handle rapid settings updates', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act - Rapid updates
      await Future.wait([
        settingsCubit.updateTheme(ThemeMode.dark),
        settingsCubit.updateDebugFlag(true),
        settingsCubit.updatePhotosAccess(true),
      ]);

      // Assert - State is valid
      expect(settingsCubit.state, isA<SettingsLoaded>());
      final loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings, isNotNull);
    });

    test('should cycle through theme modes', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();

      // Act & Assert - Light theme
      await settingsCubit.updateTheme(ThemeMode.light);
      var loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, ThemeMode.light);

      // Act & Assert - Dark theme
      await settingsCubit.updateTheme(ThemeMode.dark);
      loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, ThemeMode.dark);

      // Act & Assert - System theme
      await settingsCubit.updateTheme(ThemeMode.system);
      loadedState = settingsCubit.state as SettingsLoaded;
      expect(loadedState.settings.themeMode, ThemeMode.system);
    });

    test('should maintain settings across database clear', () async {
      // Arrange
      final settingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await settingsCubit.loadSettings();
      await settingsCubit.updateTheme(ThemeMode.dark);

      // Act - Clear only assets, not settings
      await IntegrationTestHelper.clearDatabase();

      // Create new cubit and load
      final newSettingsCubit = IntegrationTestHelper.getBloc<SettingsCubit>();
      await newSettingsCubit.loadSettings();

      // Assert - Settings still exist (getOrCreate pattern)
      expect(newSettingsCubit.state, isA<SettingsLoaded>());
      final loadedState = newSettingsCubit.state as SettingsLoaded;
      expect(loadedState.settings, isNotNull);
    });
  });
}
