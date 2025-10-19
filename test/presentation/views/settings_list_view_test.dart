import 'package:app/src/domain/entities/settings.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_cubit.dart';
import 'package:app/src/presentation/features/settings/blocs/settings/settings_state.dart';
import 'package:app/src/presentation/features/settings/views/settings_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_list_view_test.mocks.dart';

@GenerateMocks([SettingsCubit])
void main() {
  late MockSettingsCubit mockSettingsCubit;

  setUp(() {
    mockSettingsCubit = MockSettingsCubit();
    when(mockSettingsCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SettingsCubit>.value(
        value: mockSettingsCubit,
        child: const SettingsListView(),
      ),
    );
  }

  group('SettingsListView', () {
    const testSettings = Settings(
      id: 1,
      themeMode: ThemeMode.system,
      hasPhotosAccess: true,
      hasInAppReview: false,
      debugDryRemoval: false,
    );

    testWidgets('displays loading indicator when state is SettingsLoading', (
      tester,
    ) async {
      // Arrange
      when(mockSettingsCubit.state).thenReturn(const SettingsLoading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays settings list when state is SettingsLoaded', (
      tester,
    ) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Permissions'), findsOneWidget);
      expect(find.text('Developer'), findsOneWidget);
      expect(find.text('Feedback'), findsOneWidget);
    });

    testWidgets('displays correct theme mode value', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('System default'), findsOneWidget);
    });

    testWidgets('displays photo access granted status', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Photo Library Access'), findsOneWidget);
      expect(find.text('Granted'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('displays grant button when photo access not granted', (
      tester,
    ) async {
      // Arrange
      const noAccessSettings = Settings(
        id: 1,
        themeMode: ThemeMode.system,
        hasPhotosAccess: false,
        hasInAppReview: false,
        debugDryRemoval: false,
      );
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(noAccessSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Not granted'), findsOneWidget);
      expect(find.text('Grant'), findsOneWidget);
    });

    testWidgets('debug mode switch displays correct state', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Debug Mode (Dry Run)'), findsOneWidget);
      expect(
        find.text('Simulate deletions without actually removing files'),
        findsOneWidget,
      );
      final switchWidget = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchWidget.value, false);
    });

    testWidgets('tapping debug switch calls updateDebugFlag', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byType(SwitchListTile));
      await tester.pump();

      // Assert
      verify(mockSettingsCubit.updateDebugFlag(true)).called(1);
    });

    testWidgets('displays theme dropdown with options', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byType(DropdownButton<ThemeMode>));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('System'),
        findsNWidgets(2),
      ); // One in button, one in menu
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('changing theme calls updateTheme', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byType(DropdownButton<ThemeMode>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark').last);
      await tester.pumpAndSettle();

      // Assert
      verify(mockSettingsCubit.updateTheme(ThemeMode.dark)).called(1);
    });

    testWidgets('displays rate app option', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Rate This App'), findsOneWidget);
      expect(find.text('Help us improve with your feedback'), findsOneWidget);
    });

    testWidgets('displays version info', (tester) async {
      // Arrange
      when(
        mockSettingsCubit.state,
      ).thenReturn(const SettingsLoaded(testSettings));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
    });
  });
}
