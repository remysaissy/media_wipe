import 'package:app/src/commands/abstract_command.dart';
import 'package:app/src/models/session.dart';

class StartSessionCommand extends AbstractCommand {
  StartSessionCommand(super.context);

  Future<void> run(
      {required int year,
      required int month}) async {
    var session = sessionsModel.getSession(year: year, month: month);
    if (session != null) {
      await sessionsModel.updateSessions(sessions: [session]);
    } else {
      session = Session(
          assetsToDrop: [],
          sessionYear: year,
          sessionMonth: month);
      await sessionsModel.addSessions(sessions: [session]);
    }
  }
}
