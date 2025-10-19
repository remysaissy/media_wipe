import 'dart:io';
import 'package:isar/isar.dart';
import 'package:app/src/data/datasources/settings_local_datasource.dart';
import 'package:app/src/data/local/models/settings_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Isar isar;
  late SettingsLocalDataSource dataSource;
  late Directory testDir;

  setUp(() async {
    // Create temporary directory for test database
    testDir = Directory.systemTemp.createTempSync('isar_test_');

    // Create Isar instance for testing
    isar = await Isar.open(
      [SettingsEntitySchema],
      directory: testDir.path,
      name: 'test_db_${DateTime.now().millisecondsSinceEpoch}',
    );
    dataSource = SettingsLocalDataSource(isar);
  });

  tearDown(() async {
    await isar.close();
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });

  group('SettingsLocalDataSource', () {
    group('getSettings', () {
      test('should return null when no settings exist', () async {
        // Act
        final result = await dataSource.getSettings();

        // Assert
        expect(result, isNull);
      });

      test('should return first settings when exists', () async {
        // Arrange
        await dataSource.createSettings(
          SettingsEntity(themeMode: ThemeMode.dark, hasPhotosAccess: true),
        );

        // Act
        final result = await dataSource.getSettings();

        // Assert
        expect(result, isNotNull);
        expect(result!.themeMode, ThemeMode.dark);
        expect(result.hasPhotosAccess, true);
      });
    });

    group('getOrCreateSettings', () {
      test('should create new settings when none exist', () async {
        // Act
        final result = await dataSource.getOrCreateSettings();

        // Assert
        expect(result, isNotNull);
        expect(result.id, greaterThan(0));
        expect(result.themeMode, ThemeMode.system);
        expect(result.hasPhotosAccess, false);
        expect(result.debugDryRemoval, true);
      });

      test('should return existing settings when available', () async {
        // Arrange
        final created = SettingsEntity(
          themeMode: ThemeMode.light,
          hasPhotosAccess: true,
          hasInAppReview: true,
        );
        await dataSource.createSettings(created);

        // Act
        final result = await dataSource.getOrCreateSettings();

        // Assert
        expect(result.id, created.id);
        expect(result.themeMode, ThemeMode.light);
        expect(result.hasPhotosAccess, true);
        expect(result.hasInAppReview, true);
      });

      test('should return first settings when multiple exist', () async {
        // Arrange
        final first = SettingsEntity(themeMode: ThemeMode.light);
        final second = SettingsEntity(themeMode: ThemeMode.dark);
        await dataSource.createSettings(first);
        await dataSource.createSettings(second);

        // Act
        final result = await dataSource.getOrCreateSettings();

        // Assert
        expect(result.id, first.id);
      });
    });

    group('updateSettings', () {
      test('should update existing settings', () async {
        // Arrange
        final settings = await dataSource.getOrCreateSettings();
        settings.themeMode = ThemeMode.dark;
        settings.hasPhotosAccess = true;

        // Act
        await dataSource.updateSettings(settings);

        // Assert
        final updated = await dataSource.getSettings();
        expect(updated!.themeMode, ThemeMode.dark);
        expect(updated.hasPhotosAccess, true);
      });

      test('should update all fields', () async {
        // Arrange
        final settings = await dataSource.getOrCreateSettings();
        settings.themeMode = ThemeMode.light;
        settings.hasPhotosAccess = true;
        settings.hasInAppReview = true;
        settings.debugDryRemoval = false;

        // Act
        await dataSource.updateSettings(settings);

        // Assert
        final updated = await dataSource.getSettings();
        expect(updated!.themeMode, ThemeMode.light);
        expect(updated.hasPhotosAccess, true);
        expect(updated.hasInAppReview, true);
        expect(updated.debugDryRemoval, false);
      });
    });

    group('createSettings', () {
      test('should create settings with provided values', () async {
        // Arrange
        final settings = SettingsEntity(
          themeMode: ThemeMode.dark,
          hasPhotosAccess: true,
          hasInAppReview: false,
          debugDryRemoval: false,
        );

        // Act
        await dataSource.createSettings(settings);

        // Assert
        final created = await dataSource.getSettings();
        expect(created, isNotNull);
        expect(created!.themeMode, ThemeMode.dark);
        expect(created.hasPhotosAccess, true);
        expect(created.hasInAppReview, false);
        expect(created.debugDryRemoval, false);
      });

      test('should create settings with default values', () async {
        // Arrange
        final settings = SettingsEntity();

        // Act
        await dataSource.createSettings(settings);

        // Assert
        final created = await dataSource.getSettings();
        expect(created, isNotNull);
        expect(created!.themeMode, ThemeMode.system);
        expect(created.hasPhotosAccess, false);
        expect(created.hasInAppReview, false);
        expect(created.debugDryRemoval, true);
      });
    });

    group('themeMode persistence', () {
      test('should persist light theme mode', () async {
        // Arrange
        final settings = SettingsEntity(themeMode: ThemeMode.light);
        await dataSource.createSettings(settings);

        // Act
        final retrieved = await dataSource.getSettings();

        // Assert
        expect(retrieved!.themeMode, ThemeMode.light);
      });

      test('should persist dark theme mode', () async {
        // Arrange
        final settings = SettingsEntity(themeMode: ThemeMode.dark);
        await dataSource.createSettings(settings);

        // Act
        final retrieved = await dataSource.getSettings();

        // Assert
        expect(retrieved!.themeMode, ThemeMode.dark);
      });

      test('should persist system theme mode', () async {
        // Arrange
        final settings = SettingsEntity(themeMode: ThemeMode.system);
        await dataSource.createSettings(settings);

        // Act
        final retrieved = await dataSource.getSettings();

        // Assert
        expect(retrieved!.themeMode, ThemeMode.system);
      });
    });
  });
}
