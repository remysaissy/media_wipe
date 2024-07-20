import 'package:app/settings/commands/authorize_photos_command.dart';
import 'package:app/settings/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.settingsAuthorizeAccess),
        trailing: hasPhotosAccess
            ? const Icon(Icons.check)
            : const Icon(Icons.arrow_forward_ios));
  }
}
