import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/entities/session.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/repositories/session_repository.dart';

class KeepAssetInSessionUseCase {
  final SessionRepository _sessionRepository;
  final AssetRepository _assetRepository;

  KeepAssetInSessionUseCase(this._sessionRepository, this._assetRepository);

  Future<Session> execute({
    required Session session,
    required bool isWhiteListMode,
  }) async {
    if (session.assetInReview == null) return session;

    final assets = await _assetRepository.getAssetsByYearAndMonth(
      session.assetInReview!.creationDate.year,
      session.assetInReview!.creationDate.month,
    );

    final filteredAssets = isWhiteListMode
        ? assets
              .where(
                (a) =>
                    session.assetsToDrop.any((dropped) => dropped.id == a.id),
              )
              .toList()
        : assets;

    final nextAsset = _findNextAsset(filteredAssets, session);

    final updatedAssetsToDrop = List<Asset>.from(
      isWhiteListMode ? session.refineAssetsToDrop : session.assetsToDrop,
    );
    updatedAssetsToDrop.removeWhere((a) => a.id == session.assetInReview!.id);

    final updatedSession = isWhiteListMode
        ? session.copyWith(
            refineAssetsToDrop: updatedAssetsToDrop,
            assetInReview: nextAsset,
          )
        : session.copyWith(
            assetsToDrop: updatedAssetsToDrop,
            assetInReview: nextAsset,
          );

    await _sessionRepository.updateSession(updatedSession);
    return updatedSession;
  }

  Asset? _findNextAsset(List<Asset> assets, Session session) {
    for (int i = 0; i < assets.length; i++) {
      if (assets[i].id == session.assetInReview!.id) {
        return (i + 1 < assets.length) ? assets[i + 1] : null;
      }
    }
    return null;
  }
}
