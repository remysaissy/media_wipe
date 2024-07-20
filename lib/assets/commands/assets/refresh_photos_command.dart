import 'package:app/shared/commands/abstract_command.dart';

class RefreshPhotosCommand extends AbstractCommand {
  RefreshPhotosCommand(super.context);

  Future<void> run({int? year, int? month}) async {
    if (year != null) {
      await _refreshYear(year: year, month: month);
    } else {
      await _refreshAll();
    }
  }

  Future<void> _refreshAll() async {
    final mediaTotalCount = await assetsService.getAssetsCount();
    var mediaCount = 0;
    var year = DateTime.now().year;
    while (year > 0) {
      final onDeviceAssets =
          (await assetsService.listAssets(year: year)).toSet();
      var identifiedAssets = assetsModel.listAssets(forYear: year).toSet();
      mediaCount += onDeviceAssets.length;
      final identifiedDropList =
          identifiedAssets.difference(onDeviceAssets).toList();
      final identifiedAddList =
          onDeviceAssets.difference(identifiedAssets).toList();
      identifiedAssets.removeAll(identifiedDropList);
      identifiedAssets.addAll(identifiedAddList);
      // Order matters: add before removing avoids flaky listing on the UI.
      await assetsModel.addAssets(assets: identifiedAddList);
      await assetsModel.removeAssetsFromList(
          ids: identifiedDropList.map((e) => e.id).toList());
      if (mediaTotalCount == mediaCount) {
        break;
      }
      year--;
    }
  }

  Future<void> _refreshYear({required int year, int? month}) async {
    final assets = (await assetsService.listAssets(year: year))
        .where((e) => (month == null || e.creationDate.month == month))
        .toList();
    await assetsModel.removeAssets(forYear: year, forMonth: month);
    await assetsModel.addAssets(assets: assets);
  }
}
