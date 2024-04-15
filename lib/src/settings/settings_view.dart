import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/components/my_launch_url.dart';
import 'package:sortmaster_photos/src/components/my_rating.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';
import 'package:watch_it/watch_it.dart';

class SettingsView extends StatelessWidget with WatchItMixin {
  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = di<SettingsController>();
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      child: ListView(
        children: [
          _buildTheme(controller),
          _buildPurchase(context),
          _buildAuthorizePhotos(context, controller),
          _buildRateApp(context),
          _buildLink(context, 'Terms of service', 'https://www.app-privacy-policy.com/'),
          _buildLink(context, 'Privacy Policy', 'https://www.app-privacy-policy.com/'),
        ],
      )
  );
  }

  Widget _buildAuthorizePhotos(BuildContext context, SettingsController controller) {
    final isAuthorized = watchPropertyValue((SettingsController x) => x.isPhotosAuthorized);
    return ListTile(
        onTap: isAuthorized ? null : controller.authorizePhotos,
        leading: const Icon(Icons.camera),
        title: const Text('Authorize access to photos'),
        trailing: isAuthorized ? const Icon(Icons.check) : const Icon(Icons.arrow_forward_ios));
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

  Widget _buildTheme(SettingsController controller) {
    final themeMode = watchPropertyValue((SettingsController x) => x.themeMode);
    return ListTile(
      leading: const Icon(Icons.map),
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        // Read the selected themeMode from the controller
        value: themeMode,
        // Call the updateThemeMode method any time the user selects a theme.
        onChanged: controller.updateThemeMode,
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
