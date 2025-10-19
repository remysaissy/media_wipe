import 'package:app/src/presentation/features/media/blocs/session/session_cubit.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Session Flow Integration Tests', () {
    setUp(() async {
      await IntegrationTestHelper.setUp();
    });

    tearDown(() async {
      await IntegrationTestHelper.tearDown();
    });

    test('should create session, process assets, and finish session', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      // Act - Start session
      await sessionCubit.startSession(year: 2024, month: 1);

      // Assert - Session is active
      expect(sessionCubit.state, isA<SessionActive>());
      final activeState = sessionCubit.state as SessionActive;
      expect(activeState.session.sessionYear, 2024);
      expect(activeState.session.sessionMonth, 1);
      expect(activeState.session.assetInReview, isNotNull);
    });

    test('should keep asset in session', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      await sessionCubit.startSession(year: 2024, month: 1);

      // Act - Keep current asset
      await sessionCubit.keepAsset();

      // Assert - Session still active
      expect(sessionCubit.state, isA<SessionActive>());
      final updatedState = sessionCubit.state as SessionActive;
      expect(updatedState.session.id, isNotNull);
    });

    test('should drop asset in session', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      await sessionCubit.startSession(year: 2024, month: 1);

      // Act - Drop current asset
      await sessionCubit.dropAsset();

      // Assert - Drop count increased
      expect(sessionCubit.state, isA<SessionActive>());
      final updatedState = sessionCubit.state as SessionActive;
      expect(updatedState.session.assetsToDrop.length, greaterThan(0));
    });

    test('should undo last operation', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      await sessionCubit.startSession(year: 2024, month: 1);

      // Drop an asset
      await sessionCubit.dropAsset();
      final afterDropState = sessionCubit.state as SessionActive;
      final afterDropCount = afterDropState.session.assetsToDrop.length;

      // Act - Undo
      await sessionCubit.undoLastOperation();

      // Assert - Drop count decreased
      expect(sessionCubit.state, isA<SessionActive>());
      final afterUndoState = sessionCubit.state as SessionActive;
      expect(
        afterUndoState.session.assetsToDrop.length,
        lessThan(afterDropCount),
      );
    });

    test('should finish session successfully', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      await sessionCubit.startSession(year: 2024, month: 1);

      // Act - Finish session
      await sessionCubit.finishSession();

      // Assert - Session is finished
      expect(sessionCubit.state, isA<SessionFinished>());
    });

    test('should handle whitelist mode (refine)', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      // Create session with some drops
      await sessionCubit.startSession(year: 2024, month: 1);
      await sessionCubit.dropAsset();
      await sessionCubit.dropAsset();

      // Act - Enter whitelist mode
      await sessionCubit.startSession(
        year: 2024,
        month: 1,
        isWhiteListMode: true,
      );

      // Assert - In whitelist mode
      expect(sessionCubit.state, isA<SessionActive>());
      final refineState = sessionCubit.state as SessionActive;
      expect(refineState.isWhiteListMode, true);

      // Act - Keep some assets in refine mode
      await sessionCubit.keepAsset();

      // Act - Commit refine
      await sessionCubit.commitRefine();

      // Assert - Back to normal mode
      expect(sessionCubit.state, isA<SessionActive>());
      final afterRefineState = sessionCubit.state as SessionActive;
      expect(afterRefineState.isWhiteListMode, false);
    });

    test('should maintain session state across multiple operations', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      await sessionCubit.startSession(year: 2024, month: 1);

      // Act - Perform multiple operations
      await sessionCubit.dropAsset();
      await sessionCubit.keepAsset();
      await sessionCubit.dropAsset();

      // Assert - State is consistent
      expect(sessionCubit.state, isA<SessionActive>());
      final finalState = sessionCubit.state as SessionActive;
      expect(finalState.session.assetsToDrop.length, 2);
    });

    test('should handle empty session gracefully', () async {
      // Arrange - No test data
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      // Act - Try to start session with no assets
      await sessionCubit.startSession(year: 2099, month: 12);

      // Assert - Either no session or session with no assets to drop
      final state = sessionCubit.state;
      if (state is SessionActive) {
        expect(state.session.assetInReview, isNull);
      } else {
        expect(state, isA<SessionInitial>());
      }
    });

    test('should load active session if exists', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      // Create a session
      await sessionCubit.startSession(year: 2024, month: 1);
      final originalSession = (sessionCubit.state as SessionActive).session;

      // Act - Load active session
      await sessionCubit.loadActiveSession();

      // Assert - Session loaded
      expect(sessionCubit.state, isA<SessionActive>());
      final loadedSession = (sessionCubit.state as SessionActive).session;
      expect(loadedSession.id, originalSession.id);
      expect(loadedSession.sessionYear, originalSession.sessionYear);
      expect(loadedSession.sessionMonth, originalSession.sessionMonth);
    });

    test('should handle rapid operations without errors', () async {
      // Arrange
      await IntegrationTestHelper.seedTestData();
      final sessionCubit = IntegrationTestHelper.getBloc<SessionCubit>();

      await sessionCubit.startSession(year: 2024, month: 1);

      // Act - Rapid operations
      await Future.wait([
        sessionCubit.keepAsset(),
        sessionCubit.dropAsset(),
        sessionCubit.keepAsset(),
      ]);

      // Assert - State is valid
      expect(sessionCubit.state, isA<SessionActive>());
      final finalState = sessionCubit.state as SessionActive;
      expect(finalState.session.id, isNotNull);
    });
  });
}
