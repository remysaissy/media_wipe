import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/datasources/session_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/local/models/session_entity.dart';
import 'package:app/src/data/repositories/session_repository_impl.dart';
import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/entities/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_repository_impl_test.mocks.dart';

@GenerateMocks([SessionLocalDataSource, AssetLocalDataSource])
void main() {
  late SessionRepositoryImpl repository;
  late MockSessionLocalDataSource mockDataSource;
  late MockAssetLocalDataSource mockAssetDataSource;

  setUp(() {
    mockDataSource = MockSessionLocalDataSource();
    mockAssetDataSource = MockAssetLocalDataSource();
    repository = SessionRepositoryImpl(mockDataSource, mockAssetDataSource);
  });

  group('SessionRepositoryImpl', () {
    final testAssetEntity = AssetEntity(
      id: 1,
      assetId: 'asset1',
      creationDate: DateTime(2024, 1, 15),
    );

    final testAsset = Asset(
      id: 1,
      assetId: 'asset1',
      creationDate: DateTime(2024, 1, 15),
    );

    SessionEntity createTestSessionEntity() {
      final entity = SessionEntity(id: 1, sessionYear: 2024, sessionMonth: 1);
      entity.assetsToDrop.add(testAssetEntity);
      entity.assetInReview.value = testAssetEntity;
      return entity;
    }

    final testSession = Session(
      id: 1,
      sessionYear: 2024,
      sessionMonth: 1,
      assetsToDrop: [testAsset],
      refineAssetsToDrop: [],
      assetInReview: testAsset,
    );

    group('getAllSessions', () {
      test('should return list of sessions from datasource', () async {
        // Arrange
        when(
          mockDataSource.getAllSessions(),
        ).thenAnswer((_) async => [createTestSessionEntity()]);

        // Act
        final result = await repository.getAllSessions();

        // Assert
        expect(result.length, 1);
        expect(result[0].id, 1);
        expect(result[0].sessionYear, 2024);
        expect(result[0].sessionMonth, 1);
        verify(mockDataSource.getAllSessions()).called(1);
      });

      test('should return empty list when no sessions', () async {
        // Arrange
        when(mockDataSource.getAllSessions()).thenAnswer((_) async => []);

        // Act
        final result = await repository.getAllSessions();

        // Assert
        expect(result, isEmpty);
        verify(mockDataSource.getAllSessions()).called(1);
      });
    });

    group('getSessionById', () {
      test('should return session when found', () async {
        // Arrange
        when(
          mockDataSource.getSessionById(1),
        ).thenAnswer((_) async => createTestSessionEntity());

        // Act
        final result = await repository.getSessionById(1);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 1);
        expect(result.sessionYear, 2024);
        verify(mockDataSource.getSessionById(1)).called(1);
      });

      test('should return null when session not found', () async {
        // Arrange
        when(mockDataSource.getSessionById(999)).thenAnswer((_) async => null);

        // Act
        final result = await repository.getSessionById(999);

        // Assert
        expect(result, isNull);
        verify(mockDataSource.getSessionById(999)).called(1);
      });
    });

    group('getActiveSession', () {
      test('should return active session when exists', () async {
        // Arrange
        when(
          mockDataSource.getActiveSession(),
        ).thenAnswer((_) async => createTestSessionEntity());

        // Act
        final result = await repository.getActiveSession();

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 1);
        verify(mockDataSource.getActiveSession()).called(1);
      });

      test('should return null when no active session', () async {
        // Arrange
        when(mockDataSource.getActiveSession()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getActiveSession();

        // Assert
        expect(result, isNull);
        verify(mockDataSource.getActiveSession()).called(1);
      });
    });

    group('createSession', () {
      test('should create session and return generated ID', () async {
        // Arrange
        when(mockDataSource.createSession(any)).thenAnswer((_) async => 1);

        // Act
        final result = await repository.createSession(testSession);

        // Assert
        expect(result, 1);
        verify(mockDataSource.createSession(any)).called(1);
      });
    });

    group('updateSession', () {
      test('should update session through datasource', () async {
        // Arrange
        when(
          mockDataSource.updateSession(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.updateSession(testSession);

        // Assert
        verify(mockDataSource.updateSession(any)).called(1);
      });
    });

    group('deleteSession', () {
      test('should delete session by ID', () async {
        // Arrange
        when(
          mockDataSource.deleteSession(1),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.deleteSession(1);

        // Assert
        verify(mockDataSource.deleteSession(1)).called(1);
      });
    });

    group('deleteAllSessions', () {
      test('should delete all sessions', () async {
        // Arrange
        when(
          mockDataSource.deleteAllSessions(),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.deleteAllSessions();

        // Assert
        verify(mockDataSource.deleteAllSessions()).called(1);
      });
    });

    group('entity/domain mapping', () {
      test(
        'should correctly map entity to domain with ToMany relations',
        () async {
          // Arrange
          final entity = SessionEntity(
            id: 2,
            sessionYear: 2024,
            sessionMonth: 6,
          );
          entity.assetsToDrop.addAll([testAssetEntity, testAssetEntity]);
          entity.refineAssetsToDrop.add(testAssetEntity);

          when(
            mockDataSource.getSessionById(2),
          ).thenAnswer((_) async => entity);

          // Act
          final result = await repository.getSessionById(2);

          // Assert
          expect(result, isNotNull);
          expect(result!.assetsToDrop.length, 2);
          expect(result.refineAssetsToDrop.length, 1);
        },
      );

      test(
        'should correctly map domain to entity with ToOne relation',
        () async {
          // Arrange
          when(mockDataSource.createSession(any)).thenAnswer((_) async => 1);

          // Act
          await repository.createSession(testSession);

          // Assert
          final captured =
              verify(mockDataSource.createSession(captureAny)).captured.single
                  as SessionEntity;
          expect(captured.sessionYear, 2024);
          expect(captured.assetInReview.value, isNotNull);
        },
      );
    });
  });
}
