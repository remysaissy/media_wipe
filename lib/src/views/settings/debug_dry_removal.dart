import 'package:app/src/commands/settings/request_in_app_review_command.dart';
import 'package:app/src/commands/settings/update_debug_flag_command.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugDryRemoval extends StatelessWidget {
  const DebugDryRemoval({super.key});

  @override
  Widget build(BuildContext context) {

    bool debugDryRemoval =
        context.watch<SettingsModel>().settings.debugDryRemoval;
    return ListTile(
        leading: const Icon(Icons.warning),
        title: const Text('[DEBUG] Dry removal of assets'),
        trailing: Switch.adaptive(value: debugDryRemoval, onChanged: (bool value) async { await UpdateDebugFlagCommand(context).run(debugDryRemoval: value); }),
    );
  }

}