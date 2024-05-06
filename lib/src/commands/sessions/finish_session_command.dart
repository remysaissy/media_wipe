import 'package:app/src/commands/abstract_command.dart';

class FinishSessionCommand extends AbstractCommand {
  FinishSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final index = assetsModel.assets
        .indexWhere((e) => e.year == year && e.month == month);
    if (index >= 0) {
      var assets = assetsModel.assets[index];
      await assetsService.deleteAssetsPerId(assets.assetIdsToDrop);
      for (var id in assets.assetIdsToDrop) {
        assets.assets.removeWhere((e) => e.assetId == id);
      }
      assets.assetIdsToDrop = [];
      assetsModel.setAssetsAt(index, assets);
    }
  }
}
