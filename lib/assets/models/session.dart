import 'package:app/objectbox.g.dart';
import 'package:app/assets/models/asset.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Session {
  @Id()
  int id;

  ToMany<Asset> assetsToDrop = ToMany<Asset>();

  // Used only when dealing with the whitelist mode to avoid mutations to assetsToDrop to impact the refine process.
  ToMany<Asset> refineAssetsToDrop = ToMany<Asset>();

  ToOne<Asset> assetInReview = ToOne<Asset>();

  int sessionYear;

  int sessionMonth;

  Session({this.id = 0, required this.sessionYear, required this.sessionMonth});
}
