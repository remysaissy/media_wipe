import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/bootstrap_command.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/models/settings_model.dart';
import 'package:sortmaster_photos/src/router.dart';
import 'package:sortmaster_photos/src/theme.dart';
import 'package:sortmaster_photos/src/views/routing_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

/// The Widget that configures your application.
class _MyAppState extends State<MyApp> {

  late GoRouter _router;
  bool _settingsLoaded = false;

  @override
  void initState() {
    _router = setupRoutes();
    context.read<SettingsModel>().load().then((value) async {
      context.read<AssetsModel>().load();
      context.read<SessionsModel>().load();

      await BootstrapCommand(context).run();
    });
    /// Rebuild now that we have our loaded settings
    setState(() => _settingsLoaded = true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// If we've not loaded settings,
    if (!_settingsLoaded) return const RoutingView();

    ThemeMode themeMode = context.select<SettingsModel, ThemeMode>((value) => value.themeMode);
     return Provider.value(value: themeMode,
         child: MaterialApp.router(
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
         )
     );
  }
}
