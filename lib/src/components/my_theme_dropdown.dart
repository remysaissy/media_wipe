import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/settings/update_theme_command.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class MyThemeDropDown extends StatelessWidget {
  const MyThemeDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode =
        context.select<SettingsModel, ThemeMode>((value) => value.themeMode);
    return ListTile(
      leading: const Icon(Icons.map),
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        // Read the selected themeMode from the controller
        value: themeMode,
        // Call the updateThemeMode method any time the user selects a theme.
        onChanged: (ThemeMode? newThemeMode) async {
          if (context.mounted && newThemeMode != null) {
            await UpdateThemeCommand(context).run(newThemeMode: newThemeMode);
          }
        },
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System Theme'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light Theme'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark Theme'),
          )
        ],
      ),
    );
  }
}
