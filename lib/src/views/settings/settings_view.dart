import 'package:app/src/views/settings/widgets/authorize_photos.dart';
import 'package:app/src/views/settings/widgets/debug_dry_removal.dart';
import 'package:app/src/views/settings/widgets/link.dart';
import 'package:app/src/views/settings/widgets/rate_app.dart';
import 'package:app/src/views/settings/widgets/theme_dropdown.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SafeArea(
            child: ListView(
          children: const [
            ThemeDropDown(),
            // Purchase(),
            AuthorizePhotos(),
            RateApp(),
            Link(
                title: 'Terms of service',
                targetURL:
                    'https://www.app-privacy-policy.com/live.php?token=VfE77oxBRFx6OkYfJSXYOBZ8LDOznlSe'),
            Link(
                title: 'Privacy Policy',
                targetURL:
                    'https://www.app-privacy-policy.com/live.php?token=9ho9lvMLJc5wOXUooQJoLjgN4taT04eC'),
            DebugDryRemoval(),
          ],
        )));
  }
}
