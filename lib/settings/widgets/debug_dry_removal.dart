import 'package:app/settings/commands/update_debug_flag_command.dart';
import 'package:app/settings/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/l10n/app_localizations.dart';

class DebugDryRemoval extends StatelessWidget {
  const DebugDryRemoval({super.key});

  @override
  Widget build(BuildContext context) {
    bool debugDryRemoval =
        context.watch<SettingsModel>().settings.debugDryRemoval;
    return ListTile(
      leading: const Icon(Icons.warning_outlined),
      title: Text(AppLocalizations.of(context)!.settingsDryRemoval),
      trailing: Switch.adaptive(
          value: debugDryRemoval,
          onChanged: (bool value) async {
            await UpdateDebugFlagCommand(context).run(debugDryRemoval: value);
          }),
    );
  }
}
