import 'package:app/src/domain/repositories/asset_repository.dart';

class RefreshPhotosUseCase {
  final AssetRepository _repository;

  RefreshPhotosUseCase(this._repository);

  Future<void> execute({int? year, int? month}) async {
    if (year != null) {
      await _refreshYear(year: year, month: month);
    } else {
      await _refreshAll();
    }
  }

  Future<void> _refreshAll() async {
    var year = DateTime.now().year;

    while (year > 0) {
      final onDeviceAssets = (await _repository.refreshPhotosFromDevice(
        year: year,
      )).toSet();
      final storedAssets = (await _repository.getAssetsByYear(year)).toSet();

      final assetsToRemove = storedAssets.difference(onDeviceAssets).toList();
      final assetsToAdd = onDeviceAssets.difference(storedAssets).toList();

      // Order matters: add before removing avoids flaky listing on the UI.
      if (assetsToAdd.isNotEmpty) {
        await _repository.addAssets(assetsToAdd);
      }
      if (assetsToRemove.isNotEmpty) {
        await _repository.deleteAssets(
          assetsToRemove.map((e) => e.id).toList(),
        );
      }

      // Break if no more assets (reached oldest year with media)
      if (onDeviceAssets.isEmpty) {
        break;
      }

      year--;
    }
  }

  Future<void> _refreshYear({required int year, int? month}) async {
    final assets = await _repository.refreshPhotosFromDevice(year: year);
    final filteredAssets = month != null
        ? assets.where((e) => e.creationDate.month == month).toList()
        : assets;

    await _repository.deleteAssetsByYearAndMonth(year, month ?? 0);
    if (filteredAssets.isNotEmpty) {
      await _repository.addAssets(filteredAssets);
    }
  }
}
