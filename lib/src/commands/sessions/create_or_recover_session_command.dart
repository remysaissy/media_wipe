import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class CreateOrRecoverSessionCommand extends AbstractCommand {

  CreateOrRecoverSessionCommand(super.context);

  Future<SessionData> run({required int year, required int month, bool reset = false}) async {
    final yearMonth = Utils.stringifyYearMonth(year: year, month: month);
    if (!sessionsModel.sessions.containsKey(yearMonth) || reset) {
        sessionsModel.sessions[yearMonth] = SessionData(assetIdsToDrop: [], isFinished: false);
    }
    return sessionsModel.sessions[yearMonth]!;
  }
}