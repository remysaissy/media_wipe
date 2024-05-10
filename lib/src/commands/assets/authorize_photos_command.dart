import 'package:app/src/commands/abstract_command.dart';

class AuthorizePhotosCommand extends AbstractCommand {
  AuthorizePhotosCommand(super.context);

  Future<void> run() async {
    if (await assetsService.isPhotosAuthorized() == false) {
      await assetsService.authorizePhotos();
    }
    final isGranted = await assetsService.isPhotosAuthorized();
    settingsModel.settings.hasPhotosAccess = isGranted;
    await settingsModel.updateSettings();
  }
}
