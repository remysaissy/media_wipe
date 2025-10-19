import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/entities/session.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/repositories/session_repository.dart';
import 'package:app/src/domain/usecases/media/sessions/start_session_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'start_session_usecase_test.mocks.dart';

@GenerateMocks([SessionRepository, AssetRepository])
void main() {
  late StartSessionUseCase useCase;
  late MockSessionRepository mockSessionRepository;
  late MockAssetRepository mockAssetRepository;

  setUp(() {
    mockSessionRepository = MockSessionRepository();
    mockAssetRepository = MockAssetRepository();
    useCase = StartSessionUseCase(mockSessionRepository, mockAssetRepository);
  });

  group('StartSessionUseCase', () {
    final testAssets = [
      Asset(id: 1, assetId: 'asset1', creationDate: DateTime(2024, 1, 15)),
      Asset(id: 2, assetId: 'asset2', creationDate: DateTime(2024, 1, 20)),
      Asset(id: 3, assetId: 'asset3', creationDate: DateTime(2024, 1, 25)),
    ];

    test('should create new session when no existing session found', () async {
      // Arrange
      when(
        mockSessionRepository.getActiveSession(),
      ).thenAnswer((_) async => null);
      when(
        mockAssetRepository.getAssetsByYearAndMonth(2024, 1),
      ).thenAnswer((_) async => testAssets);
      when(
        mockSessionRepository.createSession(any),
      ).thenAnswer((_) async => 123);

      // Act
      final result = await useCase.execute(
        year: 2024,
        month: 1,
        isWhiteListMode: false,
      );

      // Assert
      expect(result.id, 123);
      expect(result.sessionYear, 2024);
      expect(result.sessionMonth, 1);
      expect(result.assetsToDrop, isEmpty);
      expect(result.assetInReview, testAssets.first);
      verify(mockSessionRepository.createSession(any)).called(1);
    });

    test(
      'should create session with null asset when no assets available',
      () async {
        // Arrange
        when(
          mockSessionRepository.getActiveSession(),
        ).thenAnswer((_) async => null);
        when(
          mockAssetRepository.getAssetsByYearAndMonth(2024, 1),
        ).thenAnswer((_) async => []);
        when(
          mockSessionRepository.createSession(any),
        ).thenAnswer((_) async => 456);

        // Act
        final result = await useCase.execute(
          year: 2024,
          month: 1,
          isWhiteListMode: false,
        );

        // Assert
        expect(result.assetInReview, isNull);
        expect(result.assetsToDrop, isEmpty);
      },
    );

    test(
      'should restore existing session when matching year and month',
      () async {
        // Arrange
        final existingSession = Session(
          id: 789,
          sessionYear: 2024,
          sessionMonth: 1,
          assetsToDrop: [testAssets[0]],
          refineAssetsToDrop: const [],
          assetInReview: testAssets[1],
        );

        when(
          mockSessionRepository.getActiveSession(),
        ).thenAnswer((_) async => existingSession);
        when(
          mockSessionRepository.updateSession(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await useCase.execute(
          year: 2024,
          month: 1,
          isWhiteListMode: false,
        );

        // Assert
        expect(result.id, 789);
        expect(result.assetsToDrop.length, 1);
        expect(result.assetInReview, testAssets[1]);
        verify(mockSessionRepository.updateSession(existingSession)).called(1);
        verifyNever(mockSessionRepository.createSession(any));
      },
    );

    test(
      'should create new session when existing session has different period',
      () async {
        // Arrange
        final existingSession = Session(
          id: 789,
          sessionYear: 2023, // Different year
          sessionMonth: 12,
          assetsToDrop: [testAssets[0]],
          refineAssetsToDrop: const [],
          assetInReview: testAssets[1],
        );

        when(
          mockSessionRepository.getActiveSession(),
        ).thenAnswer((_) async => existingSession);
        when(
          mockAssetRepository.getAssetsByYearAndMonth(2024, 1),
        ).thenAnswer((_) async => testAssets);
        when(
          mockSessionRepository.createSession(any),
        ).thenAnswer((_) async => 999);

        // Act
        final result = await useCase.execute(
          year: 2024,
          month: 1,
          isWhiteListMode: false,
        );

        // Assert
        expect(result.id, 999);
        expect(result.sessionYear, 2024);
        expect(result.sessionMonth, 1);
        verify(mockSessionRepository.createSession(any)).called(1);
        verifyNever(mockSessionRepository.updateSession(any));
      },
    );

    test(
      'should restore session in whitelist mode with filtered assets from drop list',
      () async {
        // Arrange
        final existingSession = Session(
          id: 789,
          sessionYear: 2024,
          sessionMonth: 1,
          assetsToDrop: [testAssets[0], testAssets[2]],
          refineAssetsToDrop: const [],
          assetInReview: testAssets[1],
        );

        when(
          mockSessionRepository.getActiveSession(),
        ).thenAnswer((_) async => existingSession);
        when(
          mockAssetRepository.getAssetsByYearAndMonth(2024, 1),
        ).thenAnswer((_) async => testAssets);
        when(
          mockSessionRepository.updateSession(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await useCase.execute(
          year: 2024,
          month: 1,
          isWhiteListMode: true,
        );

        // Assert
        expect(result.refineAssetsToDrop.length, 2);
        expect(result.assetInReview, testAssets[0]); // First from drop list
        verify(mockSessionRepository.updateSession(any)).called(1);
      },
    );

    test(
      'should restore session in whitelist mode with null asset when no dropped assets',
      () async {
        // Arrange
        final existingSession = Session(
          id: 789,
          sessionYear: 2024,
          sessionMonth: 1,
          assetsToDrop: const [],
          refineAssetsToDrop: const [],
          assetInReview: null,
        );

        when(
          mockSessionRepository.getActiveSession(),
        ).thenAnswer((_) async => existingSession);
        when(
          mockAssetRepository.getAssetsByYearAndMonth(2024, 1),
        ).thenAnswer((_) async => testAssets);
        when(
          mockSessionRepository.updateSession(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await useCase.execute(
          year: 2024,
          month: 1,
          isWhiteListMode: true,
        );

        // Assert
        expect(result.assetInReview, isNull);
        expect(result.refineAssetsToDrop, isEmpty);
      },
    );
  });
}
