
class Permissions {
  bool   cameraRoll;

  Permissions({required this.cameraRoll});
}

class PermissionsService {

  Future<Permissions> permissions() async {
    return Permissions(cameraRoll: false);
  }
}
