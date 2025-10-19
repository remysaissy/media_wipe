import 'package:app/src/domain/entities/session.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/repositories/session_repository.dart';

class StartSessionUseCase {
  final SessionRepository _sessionRepository;
  final AssetRepository _assetRepository;

  StartSessionUseCase(this._sessionRepository, this._assetRepository);

  Future<Session> execute({
    required int year,
    required int month,
    required bool isWhiteListMode,
  }) async {
    final existingSession = await _sessionRepository.getActiveSession();

    if (existingSession != null &&
        existingSession.sessionYear == year &&
        existingSession.sessionMonth == month) {
      return await _restoreSession(
        year,
        month,
        existingSession,
        isWhiteListMode,
      );
    } else {
      return await _createSession(year, month);
    }
  }

  Future<Session> _createSession(int year, int month) async {
    final assets = await _assetRepository.getAssetsByYearAndMonth(year, month);
    final session = Session(
      id: 0,
      sessionYear: year,
      sessionMonth: month,
      assetsToDrop: [],
      refineAssetsToDrop: [],
      assetInReview: assets.isNotEmpty ? assets.first : null,
    );

    final id = await _sessionRepository.createSession(session);
    return session.copyWith(id: id);
  }

  Future<Session> _restoreSession(
    int year,
    int month,
    Session session,
    bool isWhiteListMode,
  ) async {
    if (isWhiteListMode) {
      final assets = await _assetRepository.getAssetsByYearAndMonth(
        year,
        month,
      );
      final allowedAssets = assets
          .where((asset) => session.assetsToDrop.any((d) => d.id == asset.id))
          .toList();

      final updatedSession = session.copyWith(
        refineAssetsToDrop: List.from(session.assetsToDrop),
        assetInReview: allowedAssets.isNotEmpty ? allowedAssets.first : null,
      );

      await _sessionRepository.updateSession(updatedSession);
      return updatedSession;
    }

    await _sessionRepository.updateSession(session);
    return session;
  }
}
