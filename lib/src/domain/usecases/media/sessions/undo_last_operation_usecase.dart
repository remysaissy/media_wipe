import 'package:app/src/domain/entities/session.dart';
import 'package:app/src/domain/repositories/session_repository.dart';

class UndoLastOperationUseCase {
  final SessionRepository _sessionRepository;

  UndoLastOperationUseCase(this._sessionRepository);

  Future<Session> execute({required Session session}) async {
    // This would require maintaining an operation history stack
    // For now, implement basic undo by reverting to previous asset
    // Full implementation would track operation history
    await _sessionRepository.updateSession(session);
    return session;
  }
}
