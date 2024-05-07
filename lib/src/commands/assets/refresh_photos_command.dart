import 'package:app/src/commands/abstract_command.dart';

class RefreshPhotosCommand extends AbstractCommand {
  RefreshPhotosCommand(super.context);

  Future<void> run({int? year}) async {
    if (year != null) {
      final assets = await assetsService.listAssets(year: year);
      await assetsModel.removeAssets(forYear: year);
      await assetsModel.addAssets(assets: assets);
    } else {
      final mediaTotalCount = await assetsService.getAssetsCount();
      var mediaCount = 0;
      var year = DateTime.now().year;
      while (year > 0) {
        final assets = await assetsService.listAssets(year: year);
        mediaCount += assets.length;
        await assetsModel.removeAssets(forYear: year);
        await assetsModel.addAssets(assets: assets);
        if (mediaTotalCount == mediaCount) {
          break;
        }
        year--;
      }
    }
  }
}
