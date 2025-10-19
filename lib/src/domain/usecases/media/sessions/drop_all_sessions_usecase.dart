import 'package:app/src/domain/repositories/session_repository.dart';

class DropAllSessionsUseCase {
  final SessionRepository _sessionRepository;

  DropAllSessionsUseCase(this._sessionRepository);

  Future<void> execute() async {
    await _sessionRepository.deleteAllSessions();
  }
}
