import 'package:app/src/data/datasources/asset_local_datasource.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_event.dart';
import 'package:app/src/presentation/features/media/views/years_view.dart';
import 'package:app/src/presentation/features/media/views/months_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Navigation Flow Integration Tests', () {
    setUp(() async {
      await IntegrationTestHelper.setUp();
    });

    tearDown(() async {
      await IntegrationTestHelper.tearDown();
    });

    testWidgets(
      'should navigate from Years view to Months view when year is tapped',
      (tester) async {
        // Arrange - Seed test data
        await IntegrationTestHelper.seedTestData();

        final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

        // Build the widget tree
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: mediaBloc,
              child: const YearsView(),
            ),
          ),
        );

        // Trigger photo refresh
        mediaBloc.add(const LoadMediaEvent());
        await tester.pumpAndSettle();

        // Act - Find and tap on a year tile
        final yearFinder = find.text('2024');
        expect(yearFinder, findsOneWidget);

        await tester.tap(yearFinder);
        await tester.pumpAndSettle();

        // Assert - Should navigate to MonthsView
        expect(find.byType(MonthsView), findsOneWidget);
      },
    );

    testWidgets('should display correct months for selected year', (
      tester,
    ) async {
      // Arrange
      await IntegrationTestHelper.seedTestData();

      final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(value: mediaBloc, child: const YearsView()),
        ),
      );

      mediaBloc.add(const LoadMediaEvent());
      await tester.pumpAndSettle();

      // Act - Navigate to 2024
      await tester.tap(find.text('2024'));
      await tester.pumpAndSettle();

      // Assert - Should show January and February
      expect(find.text('January'), findsOneWidget);
      expect(find.text('February'), findsOneWidget);
      expect(find.text('March'), findsNothing); // No March data
    });

    testWidgets('should maintain state when navigating back from Months view', (
      tester,
    ) async {
      // Arrange
      await IntegrationTestHelper.seedTestData();

      final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(value: mediaBloc, child: const YearsView()),
        ),
      );

      mediaBloc.add(const LoadMediaEvent());
      await tester.pumpAndSettle();

      // Act - Navigate to 2024 and back
      await tester.tap(find.text('2024'));
      await tester.pumpAndSettle();

      expect(find.byType(MonthsView), findsOneWidget);

      // Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Assert - Should be back at YearsView with same data
      expect(find.byType(YearsView), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget);
    });

    testWidgets('should handle navigation with empty data gracefully', (
      tester,
    ) async {
      // Arrange - No test data seeded
      final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(value: mediaBloc, child: const YearsView()),
        ),
      );

      mediaBloc.add(const LoadMediaEvent());
      await tester.pumpAndSettle();

      // Assert - Should show empty state
      expect(find.byType(YearsView), findsOneWidget);
      // No years should be displayed
      expect(find.text('2024'), findsNothing);
    });

    testWidgets(
      'should update view when new photos are added during navigation',
      (tester) async {
        // Arrange
        await IntegrationTestHelper.seedTestData();

        final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: mediaBloc,
              child: const YearsView(),
            ),
          ),
        );

        mediaBloc.add(const LoadMediaEvent());
        await tester.pumpAndSettle();

        // Act - Add new asset while on YearsView
        final assetDataSource =
            IntegrationTestHelper.getRepository<AssetLocalDataSource>();
        await assetDataSource.addAssets([
          AssetEntity(
            assetId: 'new_asset_2024_03',
            creationDate: DateTime(2024, 3, 15),
          ),
        ]);

        // Refresh
        mediaBloc.add(const LoadMediaEvent());
        await tester.pumpAndSettle();

        // Navigate to 2024
        await tester.tap(find.text('2024'));
        await tester.pumpAndSettle();

        // Assert - Should now show March
        expect(find.text('March'), findsOneWidget);
      },
    );

    testWidgets('should handle rapid navigation without errors', (
      tester,
    ) async {
      // Arrange
      await IntegrationTestHelper.seedTestData();

      final mediaBloc = IntegrationTestHelper.getBloc<MediaBloc>();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(value: mediaBloc, child: const YearsView()),
        ),
      );

      mediaBloc.add(const LoadMediaEvent());
      await tester.pumpAndSettle();

      // Act - Rapid navigation
      await tester.tap(find.text('2024'));
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pageBack();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('2023'));
      await tester.pumpAndSettle();

      // Assert - Should end up at 2023 MonthsView
      expect(find.byType(MonthsView), findsOneWidget);
      expect(find.text('December'), findsOneWidget);
    });
  });
}
