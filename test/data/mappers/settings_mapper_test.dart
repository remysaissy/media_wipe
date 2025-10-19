import 'package:app/src/data/local/models/settings_entity.dart';
import 'package:app/src/data/repositories/settings_repository_impl.dart';
import 'package:app/src/domain/entities/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/settings_repository_impl_test.mocks.dart';

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(mockDataSource);
  });

  group('Settings Entity/Domain Mapper', () {
    group('entityToDomain mapping', () {
      test(
        'should correctly map all fields from SettingsEntity to Settings',
        () async {
          // Arrange
          final entity = SettingsEntity(
            id: 1,
            themeMode: ThemeMode.dark,
            hasPhotosAccess: true,
            hasInAppReview: false,
            debugDryRemoval: true,
          );

          when(
            mockDataSource.getOrCreateSettings(),
          ).thenAnswer((_) async => entity);

          // Act
          final domain = await repository.getSettings();

          // Assert
          expect(domain.id, 1);
          expect(domain.themeMode, ThemeMode.dark);
          expect(domain.hasPhotosAccess, true);
          expect(domain.hasInAppReview, false);
          expect(domain.debugDryRemoval, true);
        },
      );

      test('should correctly map ThemeMode.light', () async {
        // Arrange
        final entity = SettingsEntity(themeMode: ThemeMode.light);

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSettings();

        // Assert
        expect(domain.themeMode, ThemeMode.light);
      });

      test('should correctly map ThemeMode.dark', () async {
        // Arrange
        final entity = SettingsEntity(themeMode: ThemeMode.dark);

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSettings();

        // Assert
        expect(domain.themeMode, ThemeMode.dark);
      });

      test('should correctly map ThemeMode.system', () async {
        // Arrange
        final entity = SettingsEntity(themeMode: ThemeMode.system);

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSettings();

        // Assert
        expect(domain.themeMode, ThemeMode.system);
      });

      test('should map boolean flags correctly', () async {
        // Arrange
        final entity = SettingsEntity(
          hasPhotosAccess: true,
          hasInAppReview: true,
          debugDryRemoval: false,
        );

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSettings();

        // Assert
        expect(domain.hasPhotosAccess, true);
        expect(domain.hasInAppReview, true);
        expect(domain.debugDryRemoval, false);
      });

      test('should handle default entity values', () async {
        // Arrange
        final entity = SettingsEntity(); // Uses default constructor values

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSettings();

        // Assert
        expect(domain.id, 0);
        expect(domain.themeMode, ThemeMode.system);
        expect(domain.hasPhotosAccess, false);
        expect(domain.hasInAppReview, false);
        expect(domain.debugDryRemoval, true);
      });
    });

    group('domainToEntity mapping', () {
      test(
        'should correctly map all fields from Settings to SettingsEntity',
        () async {
          // Arrange
          final domain = Settings(
            id: 42,
            themeMode: ThemeMode.light,
            hasPhotosAccess: false,
            hasInAppReview: true,
            debugDryRemoval: false,
          );

          when(
            mockDataSource.updateSettings(any),
          ).thenAnswer((_) async => Future.value());

          // Act
          await repository.updateSettings(domain);

          // Assert
          final captured =
              verify(mockDataSource.updateSettings(captureAny)).captured.single
                  as SettingsEntity;
          expect(captured.id, 42);
          expect(captured.themeMode, ThemeMode.light);
          expect(captured.hasPhotosAccess, false);
          expect(captured.hasInAppReview, true);
          expect(captured.debugDryRemoval, false);
        },
      );

      test('should map each ThemeMode value correctly', () async {
        // Test light mode
        when(
          mockDataSource.updateSettings(any),
        ).thenAnswer((_) async => Future.value());

        await repository.updateSettings(
          Settings(
            id: 1,
            themeMode: ThemeMode.light,
            hasPhotosAccess: false,
            hasInAppReview: false,
            debugDryRemoval: true,
          ),
        );

        var captured =
            verify(mockDataSource.updateSettings(captureAny)).captured.single
                as SettingsEntity;
        expect(captured.themeMode, ThemeMode.light);

        // Test dark mode
        await repository.updateSettings(
          Settings(
            id: 1,
            themeMode: ThemeMode.dark,
            hasPhotosAccess: false,
            hasInAppReview: false,
            debugDryRemoval: true,
          ),
        );

        captured =
            verify(mockDataSource.updateSettings(captureAny)).captured.last
                as SettingsEntity;
        expect(captured.themeMode, ThemeMode.dark);

        // Test system mode
        await repository.updateSettings(
          Settings(
            id: 1,
            themeMode: ThemeMode.system,
            hasPhotosAccess: false,
            hasInAppReview: false,
            debugDryRemoval: true,
          ),
        );

        captured =
            verify(mockDataSource.updateSettings(captureAny)).captured.last
                as SettingsEntity;
        expect(captured.themeMode, ThemeMode.system);
      });

      test('should map boolean flags correctly', () async {
        // Arrange
        final domain = Settings(
          id: 1,
          themeMode: ThemeMode.system,
          hasPhotosAccess: true,
          hasInAppReview: false,
          debugDryRemoval: true,
        );

        when(
          mockDataSource.updateSettings(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.updateSettings(domain);

        // Assert
        final captured =
            verify(mockDataSource.updateSettings(captureAny)).captured.single
                as SettingsEntity;
        expect(captured.hasPhotosAccess, true);
        expect(captured.hasInAppReview, false);
        expect(captured.debugDryRemoval, true);
      });
    });

    group('round-trip mapping', () {
      test(
        'should preserve all data through entity->domain->entity mapping',
        () async {
          // Arrange
          final originalEntity = SettingsEntity(
            id: 123,
            themeMode: ThemeMode.dark,
            hasPhotosAccess: true,
            hasInAppReview: true,
            debugDryRemoval: false,
          );

          // entity -> domain
          when(
            mockDataSource.getOrCreateSettings(),
          ).thenAnswer((_) async => originalEntity);
          final domain = await repository.getSettings();

          // domain -> entity
          when(
            mockDataSource.updateSettings(any),
          ).thenAnswer((_) async => Future.value());
          await repository.updateSettings(domain);

          // Assert
          final captured =
              verify(mockDataSource.updateSettings(captureAny)).captured.single
                  as SettingsEntity;
          expect(captured.id, originalEntity.id);
          expect(captured.themeMode, originalEntity.themeMode);
          expect(captured.hasPhotosAccess, originalEntity.hasPhotosAccess);
          expect(captured.hasInAppReview, originalEntity.hasInAppReview);
          expect(captured.debugDryRemoval, originalEntity.debugDryRemoval);
        },
      );

      test('should preserve default values through round-trip', () async {
        // Arrange
        final defaultEntity = SettingsEntity(); // Default values

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => defaultEntity);
        final domain = await repository.getSettings();

        when(
          mockDataSource.updateSettings(any),
        ).thenAnswer((_) async => Future.value());
        await repository.updateSettings(domain);

        // Assert
        final captured =
            verify(mockDataSource.updateSettings(captureAny)).captured.single
                as SettingsEntity;
        expect(captured.themeMode, ThemeMode.system);
        expect(captured.hasPhotosAccess, false);
        expect(captured.hasInAppReview, false);
        expect(captured.debugDryRemoval, true);
      });

      test('should handle multiple round-trip conversions', () async {
        // Arrange
        var entity = SettingsEntity(
          id: 1,
          themeMode: ThemeMode.light,
          hasPhotosAccess: false,
          hasInAppReview: false,
          debugDryRemoval: true,
        );

        for (int i = 0; i < 5; i++) {
          // entity -> domain
          when(
            mockDataSource.getOrCreateSettings(),
          ).thenAnswer((_) async => entity);
          final domain = await repository.getSettings();

          // Modify domain
          final modified = domain.copyWith(
            themeMode: i % 2 == 0 ? ThemeMode.dark : ThemeMode.light,
          );

          // domain -> entity
          when(
            mockDataSource.updateSettings(any),
          ).thenAnswer((_) async => Future.value());
          await repository.updateSettings(modified);

          final captured =
              verify(mockDataSource.updateSettings(captureAny)).captured.single
                  as SettingsEntity;
          entity = captured;

          // Assert consistency
          expect(captured.id, 1);
          expect(
            captured.themeMode,
            i % 2 == 0 ? ThemeMode.dark : ThemeMode.light,
          );
        }
      });
    });

    group('edge cases', () {
      test('should handle ID value of 0', () async {
        // Arrange
        final entity = SettingsEntity(id: 0);

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSettings();

        // Assert
        expect(domain.id, 0);
      });

      test('should handle large ID values', () async {
        // Arrange
        final entity = SettingsEntity(id: 999999999);

        when(
          mockDataSource.getOrCreateSettings(),
        ).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSettings();

        // Assert
        expect(domain.id, 999999999);
      });

      test('should handle all boolean combinations', () async {
        // Test all 8 combinations of 3 boolean flags
        final combinations = [
          [false, false, false],
          [false, false, true],
          [false, true, false],
          [false, true, true],
          [true, false, false],
          [true, false, true],
          [true, true, false],
          [true, true, true],
        ];

        when(
          mockDataSource.updateSettings(any),
        ).thenAnswer((_) async => Future.value());

        for (final combo in combinations) {
          final domain = Settings(
            id: 1,
            themeMode: ThemeMode.system,
            hasPhotosAccess: combo[0],
            hasInAppReview: combo[1],
            debugDryRemoval: combo[2],
          );

          await repository.updateSettings(domain);

          final captured =
              verify(mockDataSource.updateSettings(captureAny)).captured.last
                  as SettingsEntity;
          expect(captured.hasPhotosAccess, combo[0]);
          expect(captured.hasInAppReview, combo[1]);
          expect(captured.debugDryRemoval, combo[2]);
        }
      });
    });
  });
}
