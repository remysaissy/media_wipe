import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class CreateOrRecoverSessionCommand extends AbstractCommand {

  CreateOrRecoverSessionCommand(super.context);

  Future<void> run({required int year, required int month, bool}) async {
    final yearMonth = Utils.stringifyYearMonth(year: year, month: month);
    if (!sessionsModel.sessions.containsKey(yearMonth)) {
      final sessionData = SessionData(assetIdsToDrop: [], isFinished: false);
        sessionsModel.updateSession(yearMonth, sessionData);
    }
  }
}