import 'package:app/src/domain/repositories/session_repository.dart';
import 'package:app/src/domain/usecases/media/sessions/commit_refine_in_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/drop_asset_in_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/finish_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/keep_asset_in_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/start_session_usecase.dart';
import 'package:app/src/domain/usecases/media/sessions/undo_last_operation_usecase.dart';
import 'package:app/src/presentation/features/media/blocs/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCubit extends Cubit<SessionState> {
  final StartSessionUseCase startSessionUseCase;
  final FinishSessionUseCase finishSessionUseCase;
  final KeepAssetInSessionUseCase keepAssetInSessionUseCase;
  final DropAssetInSessionUseCase dropAssetInSessionUseCase;
  final UndoLastOperationUseCase undoLastOperationUseCase;
  final CommitRefineInSessionUseCase commitRefineInSessionUseCase;
  final SessionRepository sessionRepository;

  SessionCubit({
    required this.startSessionUseCase,
    required this.finishSessionUseCase,
    required this.keepAssetInSessionUseCase,
    required this.dropAssetInSessionUseCase,
    required this.undoLastOperationUseCase,
    required this.commitRefineInSessionUseCase,
    required this.sessionRepository,
  }) : super(const SessionInitial());

  Future<void> startSession({
    required int year,
    required int month,
    bool isWhiteListMode = false,
  }) async {
    try {
      final session = await startSessionUseCase.execute(
        year: year,
        month: month,
        isWhiteListMode: isWhiteListMode,
      );
      emit(SessionActive(session: session, isWhiteListMode: isWhiteListMode));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> keepAsset() async {
    final currentState = state;
    if (currentState is! SessionActive) return;

    try {
      final updatedSession = await keepAssetInSessionUseCase.execute(
        session: currentState.session,
        isWhiteListMode: currentState.isWhiteListMode,
      );
      emit(
        SessionActive(
          session: updatedSession,
          isWhiteListMode: currentState.isWhiteListMode,
        ),
      );
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> dropAsset() async {
    final currentState = state;
    if (currentState is! SessionActive) return;

    try {
      final updatedSession = await dropAssetInSessionUseCase.execute(
        session: currentState.session,
        isWhiteListMode: currentState.isWhiteListMode,
      );
      emit(
        SessionActive(
          session: updatedSession,
          isWhiteListMode: currentState.isWhiteListMode,
        ),
      );
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> undoLastOperation() async {
    final currentState = state;
    if (currentState is! SessionActive) return;

    try {
      final updatedSession = await undoLastOperationUseCase.execute(
        session: currentState.session,
      );
      emit(
        SessionActive(
          session: updatedSession,
          isWhiteListMode: currentState.isWhiteListMode,
        ),
      );
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> finishSession() async {
    final currentState = state;
    if (currentState is! SessionActive) return;

    try {
      await finishSessionUseCase.execute(session: currentState.session);
      emit(SessionFinished(currentState.session));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> commitRefine() async {
    final currentState = state;
    if (currentState is! SessionActive) return;

    try {
      final updatedSession = await commitRefineInSessionUseCase.execute(
        session: currentState.session,
      );
      emit(
        SessionActive(
          session: updatedSession,
          isWhiteListMode: false, // Exit whitelist mode after committing
        ),
      );
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> loadActiveSession() async {
    try {
      final session = await sessionRepository.getActiveSession();
      if (session != null) {
        emit(SessionActive(session: session));
      }
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }
}
