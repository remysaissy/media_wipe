import 'package:permission_handler/permission_handler.dart';

class PermissionsService {

  Future<void> authorizePhotos() async {
    await Permission.photos.request();
  }

  Future<bool> isPhotosAuthorized() async {
    final photosStatus = await Permission.photos.status;
    return photosStatus.isGranted;
  }
}