import 'package:app/src/views/settings/authorize_photos.dart';
import 'package:app/src/views/settings/debug_dry_removal.dart';
import 'package:app/src/views/settings/link.dart';
import 'package:app/src/views/settings/purchase.dart';
import 'package:app/src/views/settings/rate_app.dart';
import 'package:flutter/material.dart';
import 'package:app/src/components/my_scaffold.dart';
import 'package:app/src/views/settings/theme_dropdown.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
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
        ));
  }
}
