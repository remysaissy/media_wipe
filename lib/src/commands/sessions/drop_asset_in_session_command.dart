import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class DropAssetInSessionCommand extends AbstractCommand {

  DropAssetInSessionCommand(super.context);

  Future<bool> run({required AssetData assetData}) async {
    final yearMonth = Utils.stringifyYearMonth(year: assetData.creationDate.year, month: assetData.creationDate.month);
    if (!sessionsModel.sessions.containsKey(yearMonth)) {
      return false;
    }
    final sessionData = sessionsModel.sessions[yearMonth]!;
    final assetIdsToDropSet = sessionData.assetIdsToDrop.toSet();
    assetIdsToDropSet.add(assetData.id);
    sessionsModel.sessions[yearMonth] = SessionData(assetIdsToDrop: assetIdsToDropSet.toList(), isFinished: sessionData.isFinished);
    return true;
  }
}