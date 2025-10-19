import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/repositories/asset_repository_impl.dart';
import 'package:app/src/domain/entities/asset.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'asset_repository_impl_test.mocks.dart';

@GenerateMocks([AssetLocalDataSource])
void main() {
  late AssetRepositoryImpl repository;
  late MockAssetLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAssetLocalDataSource();
    repository = AssetRepositoryImpl(mockDataSource);
  });

  group('AssetRepositoryImpl', () {
    final testEntities = [
      AssetEntity(
        id: 1,
        assetId: 'asset1',
        creationDate: DateTime(2024, 1, 15),
      ),
      AssetEntity(
        id: 2,
        assetId: 'asset2',
        creationDate: DateTime(2024, 2, 10),
      ),
    ];

    final testAssets = [
      Asset(id: 1, assetId: 'asset1', creationDate: DateTime(2024, 1, 15)),
      Asset(id: 2, assetId: 'asset2', creationDate: DateTime(2024, 2, 10)),
    ];

    group('getAssets', () {
      test('should return list of assets from datasource', () async {
        // Arrange
        when(
          mockDataSource.getAllAssets(),
        ).thenAnswer((_) async => testEntities);

        // Act
        final result = await repository.getAssets();

        // Assert
        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[0].assetId, 'asset1');
        expect(result[1].id, 2);
        verify(mockDataSource.getAllAssets()).called(1);
      });

      test('should return empty list when no assets', () async {
        // Arrange
        when(mockDataSource.getAllAssets()).thenAnswer((_) async => []);

        // Act
        final result = await repository.getAssets();

        // Assert
        expect(result, isEmpty);
        verify(mockDataSource.getAllAssets()).called(1);
      });
    });

    group('getAssetById', () {
      test('should return asset when found', () async {
        // Arrange
        when(
          mockDataSource.getAssetById(1),
        ).thenAnswer((_) async => testEntities[0]);

        // Act
        final result = await repository.getAssetById(1);

        // Assert
        expect(result, isNotNull);
        expect(result!.id, 1);
        expect(result.assetId, 'asset1');
        verify(mockDataSource.getAssetById(1)).called(1);
      });

      test('should return null when asset not found', () async {
        // Arrange
        when(mockDataSource.getAssetById(999)).thenAnswer((_) async => null);

        // Act
        final result = await repository.getAssetById(999);

        // Assert
        expect(result, isNull);
        verify(mockDataSource.getAssetById(999)).called(1);
      });
    });

    group('getAssetByAssetId', () {
      test('should return asset when found by assetId', () async {
        // Arrange
        when(
          mockDataSource.getAssetByAssetId('asset1'),
        ).thenAnswer((_) async => testEntities[0]);

        // Act
        final result = await repository.getAssetByAssetId('asset1');

        // Assert
        expect(result, isNotNull);
        expect(result!.assetId, 'asset1');
        verify(mockDataSource.getAssetByAssetId('asset1')).called(1);
      });

      test('should return null when asset not found by assetId', () async {
        // Arrange
        when(
          mockDataSource.getAssetByAssetId('nonexistent'),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getAssetByAssetId('nonexistent');

        // Assert
        expect(result, isNull);
      });
    });

    group('getAssetsByYear', () {
      test('should return assets filtered by year', () async {
        // Arrange
        when(
          mockDataSource.getAssetsByYear(2024),
        ).thenAnswer((_) async => testEntities);

        // Act
        final result = await repository.getAssetsByYear(2024);

        // Assert
        expect(result.length, 2);
        verify(mockDataSource.getAssetsByYear(2024)).called(1);
      });
    });

    group('getAssetsByYearAndMonth', () {
      test('should return assets filtered by year and month', () async {
        // Arrange
        when(
          mockDataSource.getAssetsByYearAndMonth(2024, 1),
        ).thenAnswer((_) async => [testEntities[0]]);

        // Act
        final result = await repository.getAssetsByYearAndMonth(2024, 1);

        // Assert
        expect(result.length, 1);
        expect(result[0].creationDate.month, 1);
        verify(mockDataSource.getAssetsByYearAndMonth(2024, 1)).called(1);
      });
    });

    group('addAssets', () {
      test('should add assets and return generated IDs', () async {
        // Arrange
        when(mockDataSource.addAssets(any)).thenAnswer((_) async => [1, 2]);

        // Act
        final result = await repository.addAssets(testAssets);

        // Assert
        expect(result, [1, 2]);
        verify(mockDataSource.addAssets(any)).called(1);
      });
    });

    group('updateAssets', () {
      test('should update assets through datasource', () async {
        // Arrange
        when(
          mockDataSource.updateAssets(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.updateAssets(testAssets);

        // Assert
        verify(mockDataSource.updateAssets(any)).called(1);
      });
    });

    group('deleteAssets', () {
      test('should delete assets by IDs', () async {
        // Arrange
        when(
          mockDataSource.deleteAssets([1, 2]),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.deleteAssets([1, 2]);

        // Assert
        verify(mockDataSource.deleteAssets([1, 2])).called(1);
      });
    });

    group('deleteAssetsByYear', () {
      test('should delete all assets for a specific year', () async {
        // Arrange
        when(
          mockDataSource.deleteAssetsByYear(2024),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.deleteAssetsByYear(2024);

        // Assert
        verify(mockDataSource.deleteAssetsByYear(2024)).called(1);
      });
    });

    group('deleteAssetsByYearAndMonth', () {
      test('should delete assets for specific year and month', () async {
        // Arrange
        when(
          mockDataSource.deleteAssetsByYearAndMonth(2024, 1),
        ).thenAnswer((_) async => Future.value());

        // Act
        await repository.deleteAssetsByYearAndMonth(2024, 1);

        // Assert
        verify(mockDataSource.deleteAssetsByYearAndMonth(2024, 1)).called(1);
      });
    });

    group('deleteAssetsFromDevice', () {
      test('should delete assets from device and return deleted IDs', () async {
        // Arrange
        when(
          mockDataSource.deleteAssetsFromDevice(
            assetIds: ['asset1', 'asset2'],
            isDry: false,
          ),
        ).thenAnswer((_) async => ['asset1', 'asset2']);

        // Act
        final result = await repository.deleteAssetsFromDevice(
          assetIds: ['asset1', 'asset2'],
          isDry: false,
        );

        // Assert
        expect(result, ['asset1', 'asset2']);
        verify(
          mockDataSource.deleteAssetsFromDevice(
            assetIds: ['asset1', 'asset2'],
            isDry: false,
          ),
        ).called(1);
      });

      test('should handle dry run mode', () async {
        // Arrange
        when(
          mockDataSource.deleteAssetsFromDevice(
            assetIds: ['asset1'],
            isDry: true,
          ),
        ).thenAnswer((_) async => <String>[]);

        // Act
        final result = await repository.deleteAssetsFromDevice(
          assetIds: ['asset1'],
          isDry: true,
        );

        // Assert
        expect(result, isEmpty);
        verify(
          mockDataSource.deleteAssetsFromDevice(
            assetIds: ['asset1'],
            isDry: true,
          ),
        ).called(1);
      });
    });

    group('refreshPhotosFromDevice', () {
      test('should fetch and return assets from device', () async {
        // Arrange
        when(
          mockDataSource.listDeviceAssets(year: 2024),
        ).thenAnswer((_) async => testEntities);

        // Act
        final result = await repository.refreshPhotosFromDevice(year: 2024);

        // Assert
        expect(result.length, 2);
        expect(result[0].assetId, 'asset1');
        verify(mockDataSource.listDeviceAssets(year: 2024)).called(1);
      });
    });
  });
}
