import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/router.dart';
import 'package:sortmaster_photos/src/settings/settings_controller.dart';
import 'package:sortmaster_photos/src/theme.dart';
import 'package:watch_it/watch_it.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget with WatchItMixin {

  final GoRouter _router;

  MyApp({super.key}):
        _router = setupRoutes();

  @override
  Widget build(BuildContext context) {
    final themeMode = watchPropertyValue((SettingsController x) => x.themeMode);
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    // return AnimatedBuilder(
    //   animation: di<SettingsController>(),
    //   builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: MyTheme.light(),
          darkTheme: MyTheme.dark(),
          themeMode: themeMode,

          // Define routes available in the application.
          routerConfig: _router,
        );
    //   },
    // );
  }
}
