import 'package:objectbox/objectbox.dart';

@Entity()
class Session {
  @Id()
  int id;

  List<int> assetsToDrop;

  // Used only when dealing with the whitelist mode to avoid mutations to assetsToDrop to impact the refine process.
  List<int>? refineAssetsToDrop;

  int? assetIdInReview;

  int sessionYear;

  int sessionMonth;

  Session({this.id = 0, required this.assetsToDrop, this.assetIdInReview, required this.sessionYear, required this.sessionMonth});
}