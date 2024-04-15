import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/di.dart';
import 'package:sortmaster_photos/src/permissions/permissions_service.dart';

class PermissionsController with ChangeNotifier {

  final _permissionsService = di<PermissionsService>();

  Future<void> authorizeCameraRoll() async {
    await _permissionsService.authorizePhotos();
    notifyListeners();
  }

  Future<bool> shouldSkipPermissions() async {
    final status = await _permissionsService.permissions();
    return status.photos;
  }
}