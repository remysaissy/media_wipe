import 'package:permission_handler/permission_handler.dart';
import 'package:sortmaster_photos/src/permissions/permissions_model.dart';

class PermissionsService {

  Future<void> authorizePhotos() async {
    await Permission.photos.request();
  }

  Future<PermissionsModel> permissions() async {
    final photosStatus = await Permission.photos.status;
    return PermissionsModel(photos: photosStatus.isGranted);
  }
}
