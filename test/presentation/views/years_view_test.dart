import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_bloc.dart';
import 'package:app/src/presentation/features/media/blocs/media/media_state.dart';
import 'package:app/src/presentation/features/media/views/years_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'years_view_test.mocks.dart';

@GenerateMocks([MediaBloc])
void main() {
  late MockMediaBloc mockMediaBloc;

  setUp(() {
    mockMediaBloc = MockMediaBloc();
    when(mockMediaBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<MediaBloc>.value(
        value: mockMediaBloc,
        child: const YearsView(),
      ),
    );
  }

  group('YearsView', () {
    testWidgets('displays loading indicator when state is MediaLoading', (
      tester,
    ) async {
      // Arrange
      when(mockMediaBloc.state).thenReturn(const MediaLoading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays years list when state is MediaLoaded', (
      tester,
    ) async {
      // Arrange
      final assets = [
        Asset(id: 1, assetId: 'asset1', creationDate: DateTime(2024, 1, 15)),
        Asset(id: 2, assetId: 'asset2', creationDate: DateTime(2024, 2, 10)),
        Asset(id: 3, assetId: 'asset3', creationDate: DateTime(2023, 12, 5)),
      ];
      when(mockMediaBloc.state).thenReturn(MediaLoaded(assets));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('2024'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget);
      expect(find.text('2 items'), findsOneWidget);
      expect(find.text('1 item'), findsOneWidget);
    });

    testWidgets('displays empty state when no assets', (tester) async {
      // Arrange
      when(mockMediaBloc.state).thenReturn(const MediaLoaded([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('No media found'), findsOneWidget);
      expect(
        find.text('Pull to refresh or check your permissions'),
        findsOneWidget,
      );
    });

    testWidgets('displays error message when state is MediaError', (
      tester,
    ) async {
      // Arrange
      when(mockMediaBloc.state).thenReturn(const MediaError('Failed to load'));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Error: Failed to load'), findsOneWidget);
    });

    testWidgets('displays AppBar with correct title', (tester) async {
      // Arrange
      when(mockMediaBloc.state).thenReturn(const MediaLoaded([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Media Years'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('groups assets by year correctly', (tester) async {
      // Arrange
      final assets = [
        Asset(id: 1, assetId: 'asset1', creationDate: DateTime(2024, 1, 15)),
        Asset(id: 2, assetId: 'asset2', creationDate: DateTime(2024, 6, 10)),
        Asset(id: 3, assetId: 'asset3', creationDate: DateTime(2024, 12, 5)),
        Asset(id: 4, assetId: 'asset4', creationDate: DateTime(2023, 3, 20)),
      ];
      when(mockMediaBloc.state).thenReturn(MediaLoaded(assets));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('2024'), findsOneWidget);
      expect(find.text('3 items'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget);
      expect(find.text('1 item'), findsOneWidget);
    });
  });
}
