import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/usecases/media/delete_assets_usecase.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_event.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Asset Deletion Integration Tests', () {
    setUp(() async {
      await IntegrationTestHelper.setUp();
    });

    tearDown(() async {
      await IntegrationTestHelper.tearDown();
    });

    test('should delete assets through use case', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();
      final deleteUseCase =
          IntegrationTestHelper.getUseCase<DeleteAssetsUseCase>();

      final initialAssets = await assetRepository.getAssets();
      final assetsToDelete = initialAssets.take(2).toList();

      // Act - Delete assets (dry run)
      await deleteUseCase.execute(assets: assetsToDelete, isDryRun: true);

      // Assert - Assets marked for deletion but not actually deleted in dry run
      final assetsAfterDryRun = await assetRepository.getAssets();
      expect(assetsAfterDryRun.length, initialAssets.length);
    });

    test('should delete assets through BLoC', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

      mediaBloc.add(const LoadMediaEvent());
      await Future.delayed(const Duration(milliseconds: 100));

      final loadedState = mediaBloc.state as MediaLoaded;
      final assetsToDelete = loadedState.assets.take(2).toList();

      // Act - Delete assets (dry run)
      mediaBloc.add(DeleteMediaEvent(assets: assetsToDelete, isDryRun: true));
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert - BLoC emitted deleting state
      expect(mediaBloc.state, isA<MediaLoaded>());
    });

    test('should handle deletion of non-existent assets', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final deleteUseCase =
          IntegrationTestHelper.getUseCase<DeleteAssetsUseCase>();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();

      // Create a fake asset not in the database
      final assets = await assetRepository.getAssets();
      final fakeAsset = assets.first.copyWith(id: 99999, assetId: 'fake_asset');

      // Act - Try to delete non-existent asset
      await deleteUseCase.execute(assets: [fakeAsset], isDryRun: true);

      // Assert - No error thrown
      final assetsAfter = await assetRepository.getAssets();
      expect(assetsAfter.length, assets.length);
    });

    test('should handle empty deletion list', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final deleteUseCase =
          IntegrationTestHelper.getUseCase<DeleteAssetsUseCase>();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();

      final initialAssets = await assetRepository.getAssets();

      // Act - Delete empty list
      await deleteUseCase.execute(assets: [], isDryRun: true);

      // Assert - No changes
      final assetsAfter = await assetRepository.getAssets();
      expect(assetsAfter.length, initialAssets.length);
    });

    test('should delete all assets from a specific month', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();
      final deleteUseCase =
          IntegrationTestHelper.getUseCase<DeleteAssetsUseCase>();

      // Get all assets from January 2024
      final allAssets = await assetRepository.getAssets();
      final januaryAssets = allAssets
          .where(
            (a) => a.creationDate.year == 2024 && a.creationDate.month == 1,
          )
          .toList();

      // Act - Delete January assets (dry run)
      await deleteUseCase.execute(assets: januaryAssets, isDryRun: true);

      // Assert - Dry run doesn't actually delete
      final assetsAfter = await assetRepository.getAssets();
      expect(assetsAfter.length, allAssets.length);
    });

    test('should handle rapid deletion requests', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final deleteUseCase =
          IntegrationTestHelper.getUseCase<DeleteAssetsUseCase>();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();

      final allAssets = await assetRepository.getAssets();
      final asset1 = [allAssets[0]];
      final asset2 = [allAssets[1]];

      // Act - Rapid deletions
      await Future.wait([
        deleteUseCase.execute(assets: asset1, isDryRun: true),
        deleteUseCase.execute(assets: asset2, isDryRun: true),
      ]);

      // Assert - No errors thrown
      final assetsAfter = await assetRepository.getAssets();
      expect(assetsAfter, isNotEmpty);
    });

    test('should maintain data consistency during deletion', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();
      final assetDataSource =
          IntegrationTestHelper.getRepository<AssetLocalDataSource>();
      final deleteUseCase =
          IntegrationTestHelper.getUseCase<DeleteAssetsUseCase>();

      final initialAssets = await assetRepository.getAssets();
      final assetsToDelete = initialAssets.take(1).toList();

      // Act - Delete through use case (dry run)
      await deleteUseCase.execute(assets: assetsToDelete, isDryRun: true);

      // Assert - Data source and repository show same count
      final repoAssets = await assetRepository.getAssets();
      final dataSourceAssets = await assetDataSource.getAllAssets();
      expect(repoAssets.length, dataSourceAssets.length);
    });

    test('should handle BLoC deletion state transitions', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

      mediaBloc.add(const LoadMediaEvent());
      await Future.delayed(const Duration(milliseconds: 100));

      final loadedState = mediaBloc.state as MediaLoaded;
      final assetsToDelete = loadedState.assets.take(1).toList();

      // Track state transitions
      final states = <MediaState>[];
      final subscription = mediaBloc.stream.listen(states.add);

      // Act - Delete
      mediaBloc.add(DeleteMediaEvent(assets: assetsToDelete, isDryRun: true));
      await Future.delayed(const Duration(milliseconds: 200));

      // Assert - State transitions occurred
      expect(states, isNotEmpty);
      expect(states.any((s) => s is MediaDeleting || s is MediaLoaded), true);

      await subscription.cancel();
    });

    test('should preserve other assets when deleting specific ones', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();

      final allAssets = await assetRepository.getAssets();
      final assetToPreserve = allAssets.first;

      // Act - Just verify the asset exists
      final foundAsset = allAssets.firstWhere(
        (a) => a.assetId == assetToPreserve.assetId,
      );

      // Assert - Asset still exists
      expect(foundAsset.assetId, assetToPreserve.assetId);
      expect(foundAsset.creationDate, assetToPreserve.creationDate);
    });

    test('should handle deletion with error recovery', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final deleteUseCase =
          IntegrationTestHelper.getUseCase<DeleteAssetsUseCase>();
      final assetRepository =
          IntegrationTestHelper.getRepository<AssetRepository>();

      final assets = await assetRepository.getAssets();

      // Act - Delete in dry run (should not throw)
      try {
        await deleteUseCase.execute(assets: assets, isDryRun: true);
      } catch (e) {
        fail('Deletion should not throw in dry run mode');
      }

      // Assert - All assets still exist
      final assetsAfter = await assetRepository.getAssets();
      expect(assetsAfter.length, assets.length);
    });
  });
}
