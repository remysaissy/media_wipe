import 'dart:io';
import 'package:isar/isar.dart';
import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Isar isar;
  late AssetLocalDataSource dataSource;
  late Directory testDir;

  setUp(() async {
    // Create temporary directory for test database
    testDir = Directory.systemTemp.createTempSync('isar_test_');

    // Create Isar instance for testing
    isar = await Isar.open(
      [AssetEntitySchema],
      directory: testDir.path,
      name: 'test_db_${DateTime.now().millisecondsSinceEpoch}',
    );
    dataSource = AssetLocalDataSource(isar);
  });

  tearDown(() async {
    await isar.close();
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });

  group('AssetLocalDataSource', () {
    final testAsset1 = AssetEntity(
      assetId: 'asset1',
      creationDate: DateTime(2024, 1, 15),
    );

    final testAsset2 = AssetEntity(
      assetId: 'asset2',
      creationDate: DateTime(2024, 2, 10),
    );

    final testAsset3 = AssetEntity(
      assetId: 'asset3',
      creationDate: DateTime(2023, 12, 5),
    );

    group('getAllAssets', () {
      test('should return empty list when no assets exist', () async {
        // Act
        final result = await dataSource.getAllAssets();

        // Assert
        expect(result, isEmpty);
      });

      test('should return all assets from box', () async {
        // Arrange
        await dataSource.addAssets([testAsset1, testAsset2]);

        // Act
        final result = await dataSource.getAllAssets();

        // Assert
        expect(result.length, 2);
        expect(result.map((e) => e.assetId), contains('asset1'));
        expect(result.map((e) => e.assetId), contains('asset2'));
      });
    });

    group('getAssetById', () {
      test('should return asset when found by ID', () async {
        // Arrange
        final ids = await dataSource.addAssets([testAsset1]);

        // Act
        final result = await dataSource.getAssetById(ids[0]);

        // Assert
        expect(result, isNotNull);
        expect(result!.assetId, 'asset1');
      });

      test('should return null when asset not found', () async {
        // Act
        final result = await dataSource.getAssetById(999);

        // Assert
        expect(result, isNull);
      });
    });

    group('getAssetByAssetId', () {
      test('should return asset when found by assetId string', () async {
        // Arrange
        await dataSource.addAssets([testAsset1]);

        // Act
        final result = await dataSource.getAssetByAssetId('asset1');

        // Assert
        expect(result, isNotNull);
        expect(result!.assetId, 'asset1');
      });

      test('should return null when assetId not found', () async {
        // Act
        final result = await dataSource.getAssetByAssetId('nonexistent');

        // Assert
        expect(result, isNull);
      });
    });

    group('getAssetsByYear', () {
      test('should return assets filtered by year', () async {
        // Arrange
        await dataSource.addAssets([testAsset1, testAsset2, testAsset3]);

        // Act
        final result = await dataSource.getAssetsByYear(2024);

        // Assert
        expect(result.length, 2);
        expect(result.map((e) => e.assetId), contains('asset1'));
        expect(result.map((e) => e.assetId), contains('asset2'));
        expect(result.map((e) => e.assetId), isNot(contains('asset3')));
      });

      test('should return empty list when no assets in year', () async {
        // Arrange
        await dataSource.addAssets([testAsset1]);

        // Act
        final result = await dataSource.getAssetsByYear(2022);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getAssetsByYearAndMonth', () {
      test('should return assets filtered by year and month', () async {
        // Arrange
        await dataSource.addAssets([testAsset1, testAsset2, testAsset3]);

        // Act
        final result = await dataSource.getAssetsByYearAndMonth(2024, 1);

        // Assert
        expect(result.length, 1);
        expect(result[0].assetId, 'asset1');
      });

      test('should return empty list when no assets in month', () async {
        // Arrange
        await dataSource.addAssets([testAsset1]);

        // Act
        final result = await dataSource.getAssetsByYearAndMonth(2024, 6);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('addAssets', () {
      test('should add single asset and return generated ID', () async {
        // Act
        final ids = await dataSource.addAssets([testAsset1]);

        // Assert
        expect(ids.length, 1);
        expect(ids[0], greaterThan(0));

        final all = await dataSource.getAllAssets();
        expect(all.length, 1);
      });

      test('should add multiple assets and return generated IDs', () async {
        // Act
        final ids = await dataSource.addAssets([testAsset1, testAsset2]);

        // Assert
        expect(ids.length, 2);
        expect(ids[0], greaterThan(0));
        expect(ids[1], greaterThan(0));

        final all = await dataSource.getAllAssets();
        expect(all.length, 2);
      });
    });

    group('updateAssets', () {
      test('should update existing asset', () async {
        // Arrange
        final ids = await dataSource.addAssets([testAsset1]);
        final asset = await dataSource.getAssetById(ids[0]);
        asset!.assetId = 'updated_asset_id';

        // Act
        await dataSource.updateAssets([asset]);

        // Assert
        final updated = await dataSource.getAssetById(ids[0]);
        expect(updated!.assetId, 'updated_asset_id');
      });
    });

    group('deleteAssets', () {
      test('should delete assets by IDs', () async {
        // Arrange
        final ids = await dataSource.addAssets([testAsset1, testAsset2]);

        // Act
        await dataSource.deleteAssets(ids);

        // Assert
        final all = await dataSource.getAllAssets();
        expect(all, isEmpty);
      });

      test('should only delete specified assets', () async {
        // Arrange
        final ids = await dataSource.addAssets([testAsset1, testAsset2]);

        // Act
        await dataSource.deleteAssets([ids[0]]);

        // Assert
        final remaining = await dataSource.getAllAssets();
        expect(remaining.length, 1);
        expect(remaining[0].assetId, 'asset2');
      });
    });

    group('deleteAssetsByYear', () {
      test('should delete all assets for specified year', () async {
        // Arrange
        await dataSource.addAssets([testAsset1, testAsset2, testAsset3]);

        // Act
        await dataSource.deleteAssetsByYear(2024);

        // Assert
        final remaining = await dataSource.getAllAssets();
        expect(remaining.length, 1);
        expect(remaining[0].assetId, 'asset3');
      });
    });

    group('deleteAssetsByYearAndMonth', () {
      test('should delete assets for specific year and month', () async {
        // Arrange
        await dataSource.addAssets([testAsset1, testAsset2, testAsset3]);

        // Act
        await dataSource.deleteAssetsByYearAndMonth(2024, 1);

        // Assert
        final remaining = await dataSource.getAllAssets();
        expect(remaining.length, 2);
        expect(remaining.map((e) => e.assetId), isNot(contains('asset1')));
      });
    });

    group('deleteAssetsFromDevice', () {
      test('should simulate dry run deletion', () async {
        // Act
        final result = await dataSource.deleteAssetsFromDevice(
          assetIds: ['asset1', 'asset2'],
          isDry: true,
        );

        // Assert
        expect(result, ['asset1', 'asset2']);
      });

      test('should handle empty asset list', () async {
        // Act
        final result = await dataSource.deleteAssetsFromDevice(
          assetIds: [],
          isDry: true,
        );

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}
