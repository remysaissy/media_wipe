import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/local/models/session_entity.dart';
import 'package:app/src/data/repositories/session_repository_impl.dart';
import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/entities/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/session_repository_impl_test.mocks.dart';

void main() {
  late SessionRepositoryImpl repository;
  late MockSessionLocalDataSource mockDataSource;
  late MockAssetLocalDataSource mockAssetDataSource;

  setUp(() {
    mockDataSource = MockSessionLocalDataSource();
    mockAssetDataSource = MockAssetLocalDataSource();
    repository = SessionRepositoryImpl(mockDataSource, mockAssetDataSource);
  });

  group('Session Entity/Domain Mapper', () {
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

    group('entityToDomain mapping', () {
      test('should correctly map basic session fields', () async {
        // Arrange
        final entity = SessionEntity(id: 5, sessionYear: 2024, sessionMonth: 6);

        when(mockDataSource.getSessionById(5)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSessionById(5);

        // Assert
        expect(domain, isNotNull);
        expect(domain!.id, 5);
        expect(domain.sessionYear, 2024);
        expect(domain.sessionMonth, 6);
      });

      test('should correctly map assetsToDrop ToMany relation', () async {
        // Arrange
        final entity = SessionEntity(id: 1, sessionYear: 2024, sessionMonth: 1);
        entity.assetsToDrop.add(testAssetEntity);
        entity.assetsToDrop.add(testAssetEntity);

        when(mockDataSource.getSessionById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSessionById(1);

        // Assert
        expect(domain!.assetsToDrop.length, 2);
        expect(domain.assetsToDrop.first.assetId, 'asset1');
      });

      test('should correctly map refineAssetsToDrop ToMany relation', () async {
        // Arrange
        final entity = SessionEntity(id: 1, sessionYear: 2024, sessionMonth: 1);
        entity.refineAssetsToDrop.add(testAssetEntity);

        when(mockDataSource.getSessionById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSessionById(1);

        // Assert
        expect(domain!.refineAssetsToDrop.length, 1);
        expect(domain.refineAssetsToDrop.first.assetId, 'asset1');
      });

      test(
        'should correctly map assetInReview ToOne relation when present',
        () async {
          // Arrange
          final entity = SessionEntity(
            id: 1,
            sessionYear: 2024,
            sessionMonth: 1,
          );
          entity.assetInReview.value = testAssetEntity;

          when(
            mockDataSource.getSessionById(1),
          ).thenAnswer((_) async => entity);

          // Act
          final domain = await repository.getSessionById(1);

          // Assert
          expect(domain!.assetInReview, isNotNull);
          expect(domain.assetInReview!.assetId, 'asset1');
        },
      );

      test('should handle null assetInReview ToOne relation', () async {
        // Arrange
        final entity = SessionEntity(id: 1, sessionYear: 2024, sessionMonth: 1);
        // assetInReview.value is null by default

        when(mockDataSource.getSessionById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSessionById(1);

        // Assert
        expect(domain!.assetInReview, isNull);
      });

      test('should map empty ToMany collections', () async {
        // Arrange
        final entity = SessionEntity(id: 1, sessionYear: 2024, sessionMonth: 1);
        // Both ToMany relations are empty by default

        when(mockDataSource.getSessionById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSessionById(1);

        // Assert
        expect(domain!.assetsToDrop, isEmpty);
        expect(domain.refineAssetsToDrop, isEmpty);
      });
    });

    group('domainToEntity mapping', () {
      test('should correctly map basic session fields', () async {
        // Arrange
        final domain = Session(
          id: 10,
          sessionYear: 2023,
          sessionMonth: 12,
          assetsToDrop: [],
          refineAssetsToDrop: [],
        );

        when(mockDataSource.createSession(any)).thenAnswer((_) async => 10);

        // Act
        await repository.createSession(domain);

        // Assert
        final captured =
            verify(mockDataSource.createSession(captureAny)).captured.single
                as SessionEntity;
        expect(captured.id, 10);
        expect(captured.sessionYear, 2023);
        expect(captured.sessionMonth, 12);
      });

      test(
        'should correctly map assetsToDrop list to ToMany relation',
        () async {
          // Arrange
          final domain = Session(
            id: 1,
            sessionYear: 2024,
            sessionMonth: 1,
            assetsToDrop: [testAsset, testAsset],
            refineAssetsToDrop: [],
          );

          when(mockDataSource.createSession(any)).thenAnswer((_) async => 1);

          // Act
          await repository.createSession(domain);

          // Assert
          final captured =
              verify(mockDataSource.createSession(captureAny)).captured.single
                  as SessionEntity;
          expect(captured.assetsToDrop.length, 2);
        },
      );

      test(
        'should correctly map refineAssetsToDrop list to ToMany relation',
        () async {
          // Arrange
          final domain = Session(
            id: 1,
            sessionYear: 2024,
            sessionMonth: 1,
            assetsToDrop: [],
            refineAssetsToDrop: [testAsset],
          );

          when(mockDataSource.createSession(any)).thenAnswer((_) async => 1);

          // Act
          await repository.createSession(domain);

          // Assert
          final captured =
              verify(mockDataSource.createSession(captureAny)).captured.single
                  as SessionEntity;
          expect(captured.refineAssetsToDrop.length, 1);
        },
      );

      test(
        'should correctly map assetInReview to ToOne relation when present',
        () async {
          // Arrange
          final domain = Session(
            id: 1,
            sessionYear: 2024,
            sessionMonth: 1,
            assetsToDrop: [],
            refineAssetsToDrop: [],
            assetInReview: testAsset,
          );

          when(mockDataSource.createSession(any)).thenAnswer((_) async => 1);

          // Act
          await repository.createSession(domain);

          // Assert
          final captured =
              verify(mockDataSource.createSession(captureAny)).captured.single
                  as SessionEntity;
          expect(captured.assetInReview.value, isNotNull);
          expect(captured.assetInReview.value!.assetId, 'asset1');
        },
      );

      test('should handle null assetInReview in domain', () async {
        // Arrange
        final domain = Session(
          id: 1,
          sessionYear: 2024,
          sessionMonth: 1,
          assetsToDrop: [],
          refineAssetsToDrop: [],
          assetInReview: null,
        );

        when(mockDataSource.createSession(any)).thenAnswer((_) async => 1);

        // Act
        await repository.createSession(domain);

        // Assert
        final captured =
            verify(mockDataSource.createSession(captureAny)).captured.single
                as SessionEntity;
        expect(captured.assetInReview.value, isNull);
      });
    });

    group('asset mapper integration', () {
      test('should correctly map nested asset entities to domain', () async {
        // Arrange
        final asset1 = AssetEntity(
          id: 10,
          assetId: 'nested_asset_1',
          creationDate: DateTime(2024, 3, 15),
        );
        final asset2 = AssetEntity(
          id: 20,
          assetId: 'nested_asset_2',
          creationDate: DateTime(2024, 4, 20),
        );

        final entity = SessionEntity(id: 1, sessionYear: 2024, sessionMonth: 3);
        entity.assetsToDrop.addAll([asset1, asset2]);

        when(mockDataSource.getSessionById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getSessionById(1);

        // Assert
        expect(domain!.assetsToDrop.length, 2);
        expect(domain.assetsToDrop.first.id, 10);
        expect(domain.assetsToDrop.first.assetId, 'nested_asset_1');
        expect(domain.assetsToDrop[1].id, 20);
        expect(domain.assetsToDrop[1].assetId, 'nested_asset_2');
      });

      test('should correctly map nested domain assets to entities', () async {
        // Arrange
        final asset1 = Asset(
          id: 15,
          assetId: 'domain_nested_1',
          creationDate: DateTime(2024, 5, 10),
        );
        final asset2 = Asset(
          id: 25,
          assetId: 'domain_nested_2',
          creationDate: DateTime(2024, 6, 15),
        );

        final domain = Session(
          id: 1,
          sessionYear: 2024,
          sessionMonth: 5,
          assetsToDrop: [asset1],
          refineAssetsToDrop: [asset2],
        );

        when(
          mockDataSource.updateSession(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.updateSession(domain);

        // Assert
        final captured =
            verify(mockDataSource.updateSession(captureAny)).captured.single
                as SessionEntity;
        expect(captured.assetsToDrop.length, 1);
        expect(captured.assetsToDrop.first.id, 15);
        expect(captured.refineAssetsToDrop.length, 1);
        expect(captured.refineAssetsToDrop.first.id, 25);
      });
    });

    group('round-trip mapping', () {
      test('should preserve all data through entity->domain->entity', () async {
        // Arrange
        final originalEntity = SessionEntity(
          id: 99,
          sessionYear: 2024,
          sessionMonth: 8,
        );
        originalEntity.assetsToDrop.add(testAssetEntity);
        originalEntity.assetInReview.value = testAssetEntity;

        // entity -> domain
        when(
          mockDataSource.getSessionById(99),
        ).thenAnswer((_) async => originalEntity);
        final domain = await repository.getSessionById(99);

        // domain -> entity
        when(
          mockDataSource.updateSession(any),
        ).thenAnswer((_) async => Future.value());
        await repository.updateSession(domain!);

        // Assert
        final captured =
            verify(mockDataSource.updateSession(captureAny)).captured.single
                as SessionEntity;
        expect(captured.id, originalEntity.id);
        expect(captured.sessionYear, originalEntity.sessionYear);
        expect(captured.sessionMonth, originalEntity.sessionMonth);
        expect(captured.assetsToDrop.length, 1);
        expect(captured.assetInReview.value, isNotNull);
      });
    });

    group('edge cases', () {
      test(
        'should handle session with many assets in ToMany relations',
        () async {
          // Arrange
          final manyAssets = List.generate(
            100,
            (i) => testAsset.copyWith(id: i),
          );

          final domain = Session(
            id: 1,
            sessionYear: 2024,
            sessionMonth: 1,
            assetsToDrop: manyAssets,
            refineAssetsToDrop: manyAssets,
          );

          when(mockDataSource.createSession(any)).thenAnswer((_) async => 1);

          // Act
          await repository.createSession(domain);

          // Assert
          final captured =
              verify(mockDataSource.createSession(captureAny)).captured.single
                  as SessionEntity;
          expect(captured.assetsToDrop.length, 100);
          expect(captured.refineAssetsToDrop.length, 100);
        },
      );

      test('should handle month boundary values', () async {
        // Arrange
        final domainJan = Session(
          id: 1,
          sessionYear: 2024,
          sessionMonth: 1,
          assetsToDrop: [],
          refineAssetsToDrop: [],
        );
        final domainDec = Session(
          id: 2,
          sessionYear: 2024,
          sessionMonth: 12,
          assetsToDrop: [],
          refineAssetsToDrop: [],
        );

        when(
          mockDataSource.createSession(any),
        ).thenAnswer((_) async => Future.value(1));

        // Act & Assert
        await repository.createSession(domainJan);
        var captured =
            verify(mockDataSource.createSession(captureAny)).captured.single
                as SessionEntity;
        expect(captured.sessionMonth, 1);

        await repository.createSession(domainDec);
        captured =
            verify(mockDataSource.createSession(captureAny)).captured.last
                as SessionEntity;
        expect(captured.sessionMonth, 12);
      });
    });
  });
}
