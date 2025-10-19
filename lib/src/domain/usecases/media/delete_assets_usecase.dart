import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';

class DeleteAssetsUseCase {
  final AssetRepository _repository;

  DeleteAssetsUseCase(this._repository);

  Future<void> execute({
    required List<Asset> assets,
    required bool isDryRun,
  }) async {
    final removedAssetIds = await _repository.deleteAssetsFromDevice(
      assetIds: assets.map((e) => e.assetId).toList(),
      isDry: isDryRun,
    );

    final idsToRemove = assets
        .where((e) => removedAssetIds.contains(e.assetId))
        .map((e) => e.id)
        .toList();

    if (idsToRemove.isNotEmpty) {
      await _repository.deleteAssets(idsToRemove);
    }
  }
}
