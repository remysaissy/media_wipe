import 'package:app/src/data/datasources/settings_local_datasource.dart';
import 'package:app/src/data/local/models/settings_entity.dart';
import 'package:app/src/data/repositories/settings_repository_impl.dart';
import 'package:app/src/domain/entities/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_repository_impl_test.mocks.dart';

@GenerateMocks([SettingsLocalDataSource])
void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(mockDataSource);
  });

  group('SettingsRepositoryImpl', () {
    final testEntity = SettingsEntity(
      id: 1,
      themeMode: ThemeMode.light,
      hasPhotosAccess: true,
      hasInAppReview: false,
      debugDryRemoval: true,
    );

    final testSettings = Settings(
      id: 1,
      themeMode: ThemeMode.light,
      hasPhotosAccess: true,
      hasInAppReview: false,
      debugDryRemoval: true,
    );

    group('getSettings', () {
      test('should return settings from datasource', () async {
        // Arrange
        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => testEntity);

        // Act
        final result = await repository.getSettings();

        // Assert
        expect(result.id, 1);
        expect(result.themeMode, ThemeMode.light);
        expect(result.hasPhotosAccess, true);
        expect(result.hasInAppReview, false);
        expect(result.debugDryRemoval, true);
        verify(mockDataSource.getOrCreateSettings()).called(1);
      });

      test('should map all entity fields to domain', () async {
        // Arrange
        final entity = SettingsEntity(
          id: 2,
          themeMode: ThemeMode.dark,
          hasPhotosAccess: false,
          hasInAppReview: true,
          debugDryRemoval: false,
        );
        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final result = await repository.getSettings();

        // Assert
        expect(result.id, 2);
        expect(result.themeMode, ThemeMode.dark);
        expect(result.hasPhotosAccess, false);
        expect(result.hasInAppReview, true);
        expect(result.debugDryRemoval, false);
      });
    });

    group('updateSettings', () {
      test('should update settings through datasource', () async {
        // Arrange
        when(
          mockDataSource.updateSettings(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.updateSettings(testSettings);

        // Assert
        verify(mockDataSource.updateSettings(any)).called(1);
      });

      test('should correctly map domain to entity when updating', () async {
        // Arrange
        when(
          mockDataSource.updateSettings(any),
        ).thenAnswer((_) async => Future.value());

        final settings = Settings(
          id: 3,
          themeMode: ThemeMode.system,
          hasPhotosAccess: true,
          hasInAppReview: true,
          debugDryRemoval: false,
        );

        // Act
        await repository.updateSettings(settings);

        // Assert
        final captured =
            verify(mockDataSource.updateSettings(captureAny)).captured.single
                as SettingsEntity;
        expect(captured.id, 3);
        expect(captured.themeMode, ThemeMode.system);
        expect(captured.hasPhotosAccess, true);
        expect(captured.hasInAppReview, true);
        expect(captured.debugDryRemoval, false);
      });
    });

    group('entity/domain mapping', () {
      test('should preserve all fields during round-trip mapping', () async {
        // Arrange
        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => testEntity);
        when(
          mockDataSource.updateSettings(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        final retrieved = await repository.getSettings();
        await repository.updateSettings(retrieved);

        // Assert
        final captured =
            verify(mockDataSource.updateSettings(captureAny)).captured.single
                as SettingsEntity;
        expect(captured.id, testEntity.id);
        expect(captured.themeMode, testEntity.themeMode);
        expect(captured.hasPhotosAccess, testEntity.hasPhotosAccess);
        expect(captured.hasInAppReview, testEntity.hasInAppReview);
        expect(captured.debugDryRemoval, testEntity.debugDryRemoval);
      });
    });
  });
}
