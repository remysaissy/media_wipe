import 'package:app/src/domain/entities/session.dart';
import 'package:app/src/domain/repositories/session_repository.dart';

class CommitRefineInSessionUseCase {
  final SessionRepository _sessionRepository;

  CommitRefineInSessionUseCase(this._sessionRepository);

  Future<Session> execute({required Session session}) async {
    // Commit refined drop list to main drop list
    final updatedSession = session.copyWith(
      assetsToDrop: List.from(session.refineAssetsToDrop),
      refineAssetsToDrop: [],
    );

    await _sessionRepository.updateSession(updatedSession);
    return updatedSession;
  }
}
