import 'package:app/src/commands/abstract_command.dart';

class RefreshPhotosCommand extends AbstractCommand {
  RefreshPhotosCommand(super.context);

  Future<void> run({int? year}) async {
    var assets = await assetsService.listAssets(year: year);
    if (year != null) {
      var currentAssets = assetsModel.assets;
      for (var key in currentAssets.keys) {
        if (!assets.containsKey(key)) {
          assets[key] = currentAssets[key]!;
        }
      }
    }
    assetsModel.assets = assets;
  }
}
