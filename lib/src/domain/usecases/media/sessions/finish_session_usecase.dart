import 'package:app/src/domain/entities/session.dart';
import 'package:app/src/domain/repositories/session_repository.dart';

class FinishSessionUseCase {
  final SessionRepository _sessionRepository;

  FinishSessionUseCase(this._sessionRepository);

  Future<void> execute({required Session session}) async {
    // Finish session - keep it in database for refining later
    await _sessionRepository.updateSession(session);
  }

  Future<void> deleteSession({required int sessionId}) async {
    await _sessionRepository.deleteSession(sessionId);
  }
}
