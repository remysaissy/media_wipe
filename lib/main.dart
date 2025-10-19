import 'package:app/src/core/di/injection_container.dart';
import 'package:app/src/presentation/app.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencyInjection();

  // Load initial settings
  final settingsCubit = getIt<SettingsCubit>();
  await settingsCubit.loadSettings();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: settingsCubit),
        BlocProvider<MediaBloc>(create: (_) => getIt<MediaBloc>()),
        BlocProvider<SessionCubit>(create: (_) => getIt<SessionCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}
