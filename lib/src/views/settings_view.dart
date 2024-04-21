import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/settings/authorize_photos_command.dart';
import 'package:sortmaster_photos/src/commands/settings/update_theme_command.dart';
import 'package:sortmaster_photos/src/components/my_launch_url.dart';
import 'package:sortmaster_photos/src/components/my_rating.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      child: ListView(
        children: [
          _buildTheme(context),
          _buildPurchase(context),
          _buildAuthorizePhotos(context),
          _buildRateApp(context),
          _buildLink(context, 'Terms of service', 'https://www.app-privacy-policy.com/'),
          _buildLink(context, 'Privacy Policy', 'https://www.app-privacy-policy.com/'),
        ],
      )
  );
  }

  Widget _buildAuthorizePhotos(BuildContext context) {
    bool canAccessPhotoLibrary = context.select<SettingsModel, bool>((value) => value.canAccessPhotoLibrary);
    return Provider.value(value: canAccessPhotoLibrary,
        child: ListTile(
            onTap: () async {
              if (!canAccessPhotoLibrary) {
                await AuthorizePhotosCommand(context).run();
              }
            },
            leading: const Icon(Icons.camera),
            title: const Text('Authorize access to photos'),
            trailing: canAccessPhotoLibrary ? const Icon(Icons.check) : const Icon(Icons.arrow_forward_ios))
    );
  }

  Widget _buildRateApp(BuildContext context) {
    return ListTile(
        onTap: () async {
          await myRating(context);
        },
        leading: const Icon(Icons.star),
        title: const Text('Rate the app!'),
        trailing: const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildLink(BuildContext context, String title, String targetURL) {
    return ListTile(
      onTap: () async {
        await myLaunchURL(context, targetURL);
      },
      leading: const Icon(Icons.web),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildPurchase(BuildContext context) {
    return ListTile(
      onTap: () {
        if (!context.mounted) return;
        context.push('/plans');
      },
      leading: const Icon(Icons.shopping_cart),
      title: const Text('Purchase'),
      trailing: const Icon(Icons.arrow_forward_ios));
  }

  Widget _buildTheme(BuildContext context) {
    ThemeMode themeMode = context.select<SettingsModel, ThemeMode>((value) => value.themeMode);
    return Provider.value(value: themeMode,
        child: ListTile(
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
        )
    );
  }


}
