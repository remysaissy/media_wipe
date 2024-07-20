import 'package:app/settings/models/settings_model.dart';
import 'package:app/shared/router.dart';
import 'package:app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    _router = AppRouter.setupRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = context.watch<SettingsModel>().settings.themeMode;
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

      // Define routes available in the application.
      routerConfig: _router,
    );
  }
}
