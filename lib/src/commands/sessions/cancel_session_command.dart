import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/utils.dart';

class CancelSessionCommand extends AbstractCommand {
  CancelSessionCommand(super.context);

  Future<void> run({required int year, required int month}) async {
    final yearMonth = Utils.stringifyYearMonth(year: year, month: month);
    var sessions = sessionsModel.sessions;
    sessions.remove(yearMonth);
    sessionsModel.sessions = sessions;
  }
}
