import 'package:app/src/commands/assets/authorize_photos_command.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorizePhotos extends StatelessWidget {
  const AuthorizePhotos({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasPhotosAccess =
        context.watch<SettingsModel>().settings.hasPhotosAccess;
    return ListTile(
        onTap: hasPhotosAccess
            ? null
            : () async {
                if (!hasPhotosAccess) {
                  await AuthorizePhotosCommand(context).run();
                }
              },
        leading: const Icon(Icons.camera),
        title: const Text('Authorize access to photos'),
        trailing: hasPhotosAccess
            ? const Icon(Icons.check)
            : const Icon(Icons.arrow_forward_ios));
  }
}
