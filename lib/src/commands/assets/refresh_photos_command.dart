import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:collection/collection.dart';

class RefreshPhotosCommand extends AbstractCommand {
  RefreshPhotosCommand(super.context);

  Future<void> run({int? year}) async {
    if (year != null) {
      var newAssets = await assetsService.listMedia(year: year);
      var currentAssets =
          assetsModel.assets.where((element) => element.year != year).toList();
      currentAssets.addAll(newAssets);
      assetsModel.assets = currentAssets;
    } else {
      assetsModel.assets = [];
      List<AssetsData> assets = [];
      final mediaTotalCount = await assetsService.getMediaCount();
      var mediaCount = 0;
      var year = DateTime.now().year;
      while (year > 0) {
        var line = await assetsService.listMedia(year: year);
        mediaCount += line.map((e) => e.assets.length).sum;
        assets.addAll(line);
        assetsModel.assets = assets;
        if (mediaTotalCount == mediaCount) {
          break;
        }
        year--;
      }
    }
  }
}
