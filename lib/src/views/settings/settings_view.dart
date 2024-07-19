import 'package:app/src/views/settings/widgets/authorize_photos.dart';
import 'package:app/src/views/settings/widgets/debug_dry_removal.dart';
import 'package:app/src/views/settings/widgets/link.dart';
import 'package:app/src/views/settings/widgets/rate_app.dart';
import 'package:app/src/views/settings/widgets/theme_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsView extends StatelessWidget {
  static String routeName = 'settings';

  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsTitle),
        ),
        body: SafeArea(
            child: ListView(
          children: [
            const ThemeDropDown(),
            // Purchase(),
            const AuthorizePhotos(),
            const RateApp(),
            Link(
                title: AppLocalizations.of(context)!.settingsToS,
                targetURL:
                    'https://www.app-privacy-policy.com/live.php?token=VfE77oxBRFx6OkYfJSXYOBZ8LDOznlSe'),
            Link(
                title: AppLocalizations.of(context)!.settingsPrivacyPolicy,
                targetURL:
                    'https://www.app-privacy-policy.com/live.php?token=9ho9lvMLJc5wOXUooQJoLjgN4taT04eC'),
            const DebugDryRemoval(),
          ],
        )));
  }
}
