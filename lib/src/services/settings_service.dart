import 'package:permission_handler/permission_handler.dart';

class SettingsService {
  Future<void> authorizePhotos() async {
    final photosStatus = await Permission.photos.status;
    if (photosStatus.isDenied) {
      await Permission.photos.request();
    } else if (!photosStatus.isGranted) {
      openAppSettings();
    }
  }

  Future<bool> isPhotosAuthorized() async {
    final photosStatus = await Permission.photos.status;
    return photosStatus.isGranted;
  }
}
