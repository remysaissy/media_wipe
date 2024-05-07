import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/bootstrap_command.dart';
import 'package:app/src/models/app_model.dart';
import 'package:app/src/router.dart';
import 'package:app/src/theme.dart';
import 'package:app/src/views/loading_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

/// The Widget that configures your application.
class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  Future<void> _initState() async {
    await BootstrapCommand(context).run(context);
  }

  @override
  void initState() {
    _router = setupRoutes();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool appReady = context.select<AppModel, bool>((value) => value.appReady);
    if (!appReady)
      return const Directionality(
          textDirection: TextDirection.ltr, child: LoadingView());

    ThemeMode themeMode = context.watch<SettingsModel>().settings.themeMode;
    bool touchMode = context.select((AppModel m) => m.touchMode);
    double densityAmt = touchMode ? 0.0 : -1.0;
    VisualDensity density =
        VisualDensity(horizontal: densityAmt, vertical: densityAmt);
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
      theme: MyTheme.light(density),
      darkTheme: MyTheme.dark(density),
      themeMode: themeMode,

      // Define routes available in the application.
      routerConfig: _router,
    );
  }
}
