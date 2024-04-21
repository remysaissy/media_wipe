import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class FinishSessionCommand extends AbstractCommand {

  FinishSessionCommand(super.context);

  Future<bool> run({required int year, required int month}) async {
    final yearMonth = Utils.stringifyYearMonth(year: year, month: month);
    if (!sessionsModel.sessions.containsKey(yearMonth)) {
      return false;
    }
    final sessionData = sessionsModel.sessions[yearMonth]!;
    await assetsService.deleteAssetsPerId(sessionData.assetIdsToDrop);
    sessionsModel.sessions[yearMonth] = SessionData(assetIdsToDrop: sessionData.assetIdsToDrop, isFinished: true);
    final assetsForYearMonth = assetsModel.assets[yearMonth]!;
    if (sessionData.assetIdsToDrop.isNotEmpty) {
      for (var id in sessionData.assetIdsToDrop) {
        assetsForYearMonth.remove(id);
      }
      assetsModel.updateAssetEntry(yearMonth, assetsForYearMonth);
    }
    return true;
  }
}