import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:isar/isar.dart';

part 'session_entity.g.dart';

@collection
class SessionEntity {
  Id id = Isar.autoIncrement;

  final assetsToDrop = IsarLinks<AssetEntity>();

  // Used only when dealing with the whitelist mode to avoid mutations to assetsToDrop to impact the refine process.
  final refineAssetsToDrop = IsarLinks<AssetEntity>();

  final assetInReview = IsarLink<AssetEntity>();

  int sessionYear;

  int sessionMonth;

  SessionEntity({
    this.id = Isar.autoIncrement,
    required this.sessionYear,
    required this.sessionMonth,
  });
}
