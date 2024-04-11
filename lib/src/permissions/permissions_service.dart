
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  bool   photos;

  Permissions({required this.photos});
}

class PermissionsService {

  Future<void> authorizeCameraRoll() async {
    await Permission.photos.request();
  }

  Future<Permissions> permissions() async {
    final photosStatus = await Permission.photos.status;
    return Permissions(photos: photosStatus.isGranted);
  }
}
