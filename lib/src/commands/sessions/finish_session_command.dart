import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/utils.dart';

class FinishSessionCommand extends AbstractCommand {
  FinishSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final yearMonth = Utils.stringifyYearMonth(year: year, month: month);
    if (sessionsModel.sessions.containsKey(yearMonth)) {
      final sessionData = sessionsModel.sessions[yearMonth]!;
      await assetsService.deleteAssetsPerId(sessionData.assetIdsToDrop);
      // Remove assets that were deleted just now from the model.
      var assets = assetsModel.assets;
      for (var idToDrop in sessionData.assetIdsToDrop) {
        final toBeRemoved = assets[yearMonth]?.where((element) => element.id == idToDrop).first;
        assets[yearMonth]?.remove(toBeRemoved);
      }
      assetsModel.assets = assets;
    }
    sessionsModel.sessions.remove(yearMonth);
  }
}
