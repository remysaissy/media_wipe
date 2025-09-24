import 'package:app/settings/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/settings/commands/update_theme_command.dart';
import 'package:app/l10n/app_localizations.dart';

class ThemeDropDown extends StatelessWidget {
  const ThemeDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = context.watch<SettingsModel>().settings.themeMode;
    final brigthness = MediaQuery.of(context).platformBrightness;
    Icon icon;
    if (themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brigthness == Brightness.dark)) {
      icon = const Icon(Icons.dark_mode);
    } else {
      icon = const Icon(Icons.light_mode);
    }
    return ListTile(
      leading: icon,
      title: Text(AppLocalizations.of(context)!.settingsThemeTitle),
      trailing: DropdownButton<ThemeMode>(
        // Read the selected themeMode from the controller
        value: themeMode,
        // Call the updateThemeMode method any time the user selects a theme.
        onChanged: (ThemeMode? newThemeMode) async {
          if (context.mounted && newThemeMode != null) {
            await UpdateThemeCommand(context).run(newThemeMode: newThemeMode);
          }
        },
        items: [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text(AppLocalizations.of(context)!.settingsThemeSystem),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text(AppLocalizations.of(context)!.settingsThemeLight),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text(AppLocalizations.of(context)!.settingsThemeDark),
          )
        ],
      ),
    );
  }
}
