/// E2E Test Helpers for Integration Testing
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/core/di/injection_container.dart';
import 'package:app/src/presentation/app.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';

/// Initialize the app for E2E testing with all dependencies
///
/// This mounts the full app widget tree and waits for it to settle
/// Mirrors the initialization in main.dart
Future<void> initializeAppForE2E(WidgetTester tester) async {
  // Setup dependency injection (only if not already initialized)
  if (!getIt.isRegistered<SettingsCubit>()) {
    await setupDependencyInjection();
  }

  // Load initial settings
  final settingsCubit = getIt<SettingsCubit>();
  await settingsCubit.loadSettings();

  // Pump the full app with BLoC providers
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: settingsCubit),
        BlocProvider<MediaBloc>(create: (_) => getIt<MediaBloc>()),
        BlocProvider<SessionCubit>(create: (_) => getIt<SessionCubit>()),
      ],
      child: const MyApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Common test cleanup
Future<void> cleanupAfterE2E() async {
  // Cleanup if needed - currently nothing to clean
}

/// Helper to wait for navigation to complete
Future<void> waitForNavigation(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}

/// Helper to simulate user delay (makes tests more realistic)
Future<void> userDelay([Duration? duration]) async {
  await Future.delayed(duration ?? const Duration(milliseconds: 300));
}
