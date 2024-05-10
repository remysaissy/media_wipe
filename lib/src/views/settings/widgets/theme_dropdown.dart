import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/settings/update_theme_command.dart';

class ThemeDropDown extends StatelessWidget {
  const ThemeDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = context.watch<SettingsModel>().settings.themeMode;
    final brigthness = MediaQuery.of(context).platformBrightness;
    var icon;
    if (themeMode == ThemeMode.dark || (themeMode == ThemeMode.system && brigthness == Brightness.dark)) {
      icon = const Icon(Icons.dark_mode);
    } else {
      icon = const Icon(Icons.light_mode);
    }
    return ListTile(
      leading: icon,
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
