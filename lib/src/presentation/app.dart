import 'package:app/src/core/routing/app_router.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_state.dart';
import 'package:app/src/presentation/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  @override
  void initState() {
    _router = AppRouter.setupRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final themeMode = state is SettingsLoaded
            ? state.settings.themeMode
            : ThemeMode.system;

        return MaterialApp.router(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: MyTheme.light(),
          darkTheme: MyTheme.dark(),
          themeMode: themeMode,
          routerConfig: _router,
        );
      },
    );
  }
}
