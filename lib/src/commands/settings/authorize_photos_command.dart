
import 'package:sortmaster_photos/src/commands/abstract_command.dart';
import 'package:sortmaster_photos/src/utils.dart';

class AuthorizePhotosCommand extends AbstractCommand {

  AuthorizePhotosCommand(super.context);

  Future<bool> run() async {
    if (await permissionsService.isPhotosAuthorized() == false) {
      await permissionsService.authorizePhotos();
    }
    final isGranted = await permissionsService.isPhotosAuthorized();
    settingsModel.canAccessPhotoLibrary = isGranted;
    return isGranted;
  }
}