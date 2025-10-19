import 'package:app/src/domain/entities/asset.dart';
import 'package:equatable/equatable.dart';

class Session extends Equatable {
  final int id;
  final List<Asset> assetsToDrop;
  final List<Asset> refineAssetsToDrop;
  final Asset? assetInReview;
  final int sessionYear;
  final int sessionMonth;

  const Session({
    required this.id,
    required this.assetsToDrop,
    required this.refineAssetsToDrop,
    this.assetInReview,
    required this.sessionYear,
    required this.sessionMonth,
  });

  Session copyWith({
    int? id,
    List<Asset>? assetsToDrop,
    List<Asset>? refineAssetsToDrop,
    Asset? assetInReview,
    int? sessionYear,
    int? sessionMonth,
  }) {
    return Session(
      id: id ?? this.id,
      assetsToDrop: assetsToDrop ?? this.assetsToDrop,
      refineAssetsToDrop: refineAssetsToDrop ?? this.refineAssetsToDrop,
      assetInReview: assetInReview ?? this.assetInReview,
      sessionYear: sessionYear ?? this.sessionYear,
      sessionMonth: sessionMonth ?? this.sessionMonth,
    );
  }

  @override
  List<Object?> get props => [
    id,
    assetsToDrop,
    refineAssetsToDrop,
    assetInReview,
    sessionYear,
    sessionMonth,
  ];
}
