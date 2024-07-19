import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/router.dart';
import 'package:app/src/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

/// The Widget that configures your application.
class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  @override
  void initState() {
    _router = setupRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = context.watch<SettingsModel>().settings.themeMode;
    final debugDryRemoval =
        context.watch<SettingsModel>().settings.debugDryRemoval;
    return MaterialApp.router(
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: MyTheme.light(),
      darkTheme: MyTheme.dark(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: debugDryRemoval,

      // Define routes available in the application.
      routerConfig: _router,
    );
  }
}
