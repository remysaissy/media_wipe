import 'package:app/src/commands/settings/authorize_photos_command.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorizePhotos extends StatelessWidget {
  const AuthorizePhotos({super.key});

  @override
  Widget build(BuildContext context) {
    bool canAccessPhotoLibrary = context
        .select<SettingsModel, bool>((value) => value.canAccessPhotoLibrary);
    return ListTile(
        onTap: canAccessPhotoLibrary
            ? null
            : () async {
          if (!canAccessPhotoLibrary) {
            await AuthorizePhotosCommand(context).run();
          }
        },
        leading: const Icon(Icons.camera),
        title: const Text('Authorize access to photos'),
        trailing: canAccessPhotoLibrary
            ? const Icon(Icons.check)
            : const Icon(Icons.arrow_forward_ios));
  }

}