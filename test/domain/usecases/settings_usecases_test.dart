import 'package:app/src/domain/entities/settings.dart';
import 'package:app/src/domain/repositories/settings_repository.dart';
import 'package:app/src/domain/usecases/settings/load_settings_usecase.dart';
import 'package:app/src/domain/usecases/settings/update_settings_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_usecases_test.mocks.dart';

@GenerateMocks([SettingsRepository])
void main() {
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
  });

  group('LoadSettingsUseCase', () {
    late LoadSettingsUseCase useCase;

    setUp(() {
      useCase = LoadSettingsUseCase(mockRepository);
    });

    test('should return settings from repository', () async {
      // Arrange
      const testSettings = Settings(
        id: 1,
        themeMode: ThemeMode.dark,
        hasPhotosAccess: true,
        hasInAppReview: false,
        debugDryRemoval: true,
      );

      when(mockRepository.getSettings()).thenAnswer((_) async => testSettings);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, testSettings);
      verify(mockRepository.getSettings()).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(mockRepository.getSettings()).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => useCase.execute(), throwsA(isA<Exception>()));
    });
  });

  group('UpdateSettingsUseCase', () {
    late UpdateSettingsUseCase useCase;

    setUp(() {
      useCase = UpdateSettingsUseCase(mockRepository);
    });

    test(
      'should call repository updateSettings with provided settings',
      () async {
        // Arrange
        const testSettings = Settings(
          id: 1,
          themeMode: ThemeMode.system,
          hasPhotosAccess: false,
          hasInAppReview: true,
          debugDryRemoval: false,
        );

        when(
          mockRepository.updateSettings(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await useCase.execute(testSettings);

        // Assert
        verify(mockRepository.updateSettings(testSettings)).called(1);
      },
    );

    test('should handle theme mode changes', () async {
      // Arrange
      const lightSettings = Settings(
        id: 1,
        themeMode: ThemeMode.light,
        hasPhotosAccess: true,
        hasInAppReview: false,
        debugDryRemoval: false,
      );

      when(
        mockRepository.updateSettings(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      await useCase.execute(lightSettings);

      // Assert
      final captured = verify(
        mockRepository.updateSettings(captureAny),
      ).captured.single;
      expect((captured as Settings).themeMode, ThemeMode.light);
    });

    test('should handle debug flag changes', () async {
      // Arrange
      const debugSettings = Settings(
        id: 1,
        themeMode: ThemeMode.system,
        hasPhotosAccess: true,
        hasInAppReview: false,
        debugDryRemoval: true,
      );

      when(
        mockRepository.updateSettings(any),
      ).thenAnswer((_) async => Future.value());

      // Act
      await useCase.execute(debugSettings);

      // Assert
      final captured = verify(
        mockRepository.updateSettings(captureAny),
      ).captured.single;
      expect((captured as Settings).debugDryRemoval, true);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      const testSettings = Settings(
        id: 1,
        themeMode: ThemeMode.system,
        hasPhotosAccess: true,
        hasInAppReview: false,
        debugDryRemoval: false,
      );

      when(
        mockRepository.updateSettings(any),
      ).thenThrow(Exception('Update failed'));

      // Act & Assert
      expect(() => useCase.execute(testSettings), throwsA(isA<Exception>()));
    });
  });
}
