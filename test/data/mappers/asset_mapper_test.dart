import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/repositories/asset_repository_impl.dart';
import 'package:app/src/domain/entities/asset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/asset_repository_impl_test.mocks.dart';

void main() {
  late AssetRepositoryImpl repository;

  group('Asset Entity/Domain Mapper', () {
    group('entityToDomain mapping', () {
      test(
        'should correctly map all fields from AssetEntity to Asset',
        () async {
          // Arrange
          final entity = AssetEntity(
            id: 42,
            assetId: 'test_asset_123',
            creationDate: DateTime(2024, 6, 15, 14, 30),
          );

          final dataSource = MockAssetLocalDataSource();
          repository = AssetRepositoryImpl(dataSource);
          when(dataSource.getAssetById(42)).thenAnswer((_) async => entity);

          // Act
          final domain = await repository.getAssetById(42);

          // Assert
          expect(domain, isNotNull);
          expect(domain!.id, entity.id);
          expect(domain.assetId, entity.assetId);
          expect(domain.creationDate, entity.creationDate);
        },
      );

      test('should handle entity with ID 0', () async {
        // Arrange
        final entity = AssetEntity(
          id: 0,
          assetId: 'new_asset',
          creationDate: DateTime(2024, 1, 1),
        );

        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);
        when(dataSource.getAllAssets()).thenAnswer((_) async => [entity]);

        // Act
        final domains = await repository.getAssets();

        // Assert
        expect(domains.length, 1);
        expect(domains[0].id, 0);
        expect(domains[0].assetId, 'new_asset');
      });

      test('should map list of entities to list of domain objects', () async {
        // Arrange
        final entities = [
          AssetEntity(
            id: 1,
            assetId: 'asset1',
            creationDate: DateTime(2024, 1, 1),
          ),
          AssetEntity(
            id: 2,
            assetId: 'asset2',
            creationDate: DateTime(2024, 2, 1),
          ),
          AssetEntity(
            id: 3,
            assetId: 'asset3',
            creationDate: DateTime(2024, 3, 1),
          ),
        ];

        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);
        when(dataSource.getAllAssets()).thenAnswer((_) async => entities);

        // Act
        final domains = await repository.getAssets();

        // Assert
        expect(domains.length, 3);
        for (int i = 0; i < entities.length; i++) {
          expect(domains[i].id, entities[i].id);
          expect(domains[i].assetId, entities[i].assetId);
          expect(domains[i].creationDate, entities[i].creationDate);
        }
      });

      test('should preserve DateTime precision during mapping', () async {
        // Arrange
        final preciseDate = DateTime(2024, 6, 15, 14, 30, 45, 123, 456);
        final entity = AssetEntity(
          id: 1,
          assetId: 'asset1',
          creationDate: preciseDate,
        );

        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);
        when(dataSource.getAssetById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getAssetById(1);

        // Assert
        expect(domain!.creationDate, preciseDate);
        expect(
          domain.creationDate.millisecondsSinceEpoch,
          preciseDate.millisecondsSinceEpoch,
        );
      });
    });

    group('domainToEntity mapping', () {
      test(
        'should correctly map all fields from Asset to AssetEntity',
        () async {
          // Arrange
          final domain = Asset(
            id: 99,
            assetId: 'domain_asset_456',
            creationDate: DateTime(2024, 12, 25, 10, 15),
          );

          final dataSource = MockAssetLocalDataSource();
          repository = AssetRepositoryImpl(dataSource);
          when(dataSource.addAssets(any)).thenAnswer((_) async => [99]);

          // Act
          await repository.addAssets([domain]);

          // Assert
          final captured =
              verify(dataSource.addAssets(captureAny)).captured.single as List;
          final entity = captured[0] as AssetEntity;
          expect(entity.id, domain.id);
          expect(entity.assetId, domain.assetId);
          expect(entity.creationDate, domain.creationDate);
        },
      );

      test('should map list of domain objects to list of entities', () async {
        // Arrange
        final domains = [
          Asset(id: 1, assetId: 'asset1', creationDate: DateTime(2024, 1, 1)),
          Asset(id: 2, assetId: 'asset2', creationDate: DateTime(2024, 2, 1)),
        ];

        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);
        when(dataSource.updateAssets(any)).thenAnswer((_) async => {});

        // Act
        await repository.updateAssets(domains);

        // Assert
        final captured =
            verify(dataSource.updateAssets(captureAny)).captured.single as List;
        expect(captured.length, 2);
        for (int i = 0; i < domains.length; i++) {
          final entity = captured[i] as AssetEntity;
          expect(entity.id, domains[i].id);
          expect(entity.assetId, domains[i].assetId);
          expect(entity.creationDate, domains[i].creationDate);
        }
      });

      test(
        'should handle domain object with special characters in assetId',
        () async {
          // Arrange
          final domain = Asset(
            id: 1,
            assetId: 'asset-with-special_chars.123!@#',
            creationDate: DateTime(2024, 1, 1),
          );

          final dataSource = MockAssetLocalDataSource();
          repository = AssetRepositoryImpl(dataSource);
          when(dataSource.addAssets(any)).thenAnswer((_) async => [1]);

          // Act
          await repository.addAssets([domain]);

          // Assert
          final captured =
              verify(dataSource.addAssets(captureAny)).captured.single as List;
          final entity = captured[0] as AssetEntity;
          expect(entity.assetId, 'asset-with-special_chars.123!@#');
        },
      );
    });

    group('round-trip mapping', () {
      test(
        'should preserve all data through entity->domain->entity mapping',
        () async {
          // Arrange
          final originalEntity = AssetEntity(
            id: 123,
            assetId: 'roundtrip_asset',
            creationDate: DateTime(2024, 7, 4, 12, 0, 0),
          );

          final dataSource = MockAssetLocalDataSource();
          repository = AssetRepositoryImpl(dataSource);

          // Convert entity -> domain
          when(
            dataSource.getAssetById(123),
          ).thenAnswer((_) async => originalEntity);
          final domain = await repository.getAssetById(123);

          // Convert domain -> entity (via update)
          when(dataSource.updateAssets(any)).thenAnswer((_) async => {});
          await repository.updateAssets([domain!]);

          // Assert
          final captured =
              verify(dataSource.updateAssets(captureAny)).captured.single
                  as List;
          final resultEntity = captured[0] as AssetEntity;
          expect(resultEntity.id, originalEntity.id);
          expect(resultEntity.assetId, originalEntity.assetId);
          expect(resultEntity.creationDate, originalEntity.creationDate);
        },
      );

      test('should handle empty list round-trip', () async {
        // Arrange
        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);

        when(dataSource.getAllAssets()).thenAnswer((_) async => []);

        // Act
        final domains = await repository.getAssets();

        // Assert
        expect(domains, isEmpty);
      });
    });

    group('edge cases', () {
      test('should handle far future dates', () async {
        // Arrange
        final futureDate = DateTime(2999, 12, 31, 23, 59, 59);
        final entity = AssetEntity(
          id: 1,
          assetId: 'future_asset',
          creationDate: futureDate,
        );

        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);
        when(dataSource.getAssetById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getAssetById(1);

        // Assert
        expect(domain!.creationDate, futureDate);
      });

      test('should handle far past dates', () async {
        // Arrange
        final pastDate = DateTime(1970, 1, 1, 0, 0, 0);
        final entity = AssetEntity(
          id: 1,
          assetId: 'past_asset',
          creationDate: pastDate,
        );

        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);
        when(dataSource.getAssetById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getAssetById(1);

        // Assert
        expect(domain!.creationDate, pastDate);
      });

      test('should handle very long assetId strings', () async {
        // Arrange
        final longAssetId = 'a' * 1000;
        final entity = AssetEntity(
          id: 1,
          assetId: longAssetId,
          creationDate: DateTime(2024, 1, 1),
        );

        final dataSource = MockAssetLocalDataSource();
        repository = AssetRepositoryImpl(dataSource);
        when(dataSource.getAssetById(1)).thenAnswer((_) async => entity);

        // Act
        final domain = await repository.getAssetById(1);

        // Assert
        expect(domain!.assetId, longAssetId);
        expect(domain.assetId.length, 1000);
      });
    });
  });
}
