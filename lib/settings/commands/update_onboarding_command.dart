import 'package:app/shared/commands/abstract_command.dart';

class UpdateOnboardingCommand extends AbstractCommand {
  UpdateOnboardingCommand(super.context);

  Future<void> run({required bool isOnboarded}) async {
    // settings42Model.isOnboarded = isOnboarded;
  }
}
