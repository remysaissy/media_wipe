import 'package:objectbox/objectbox.dart';

@Entity()
class Session {
  @Id()
  int id;

  List<int> assetsToDrop;

  int? assetIdInReview;

  int sessionYear;

  int sessionMonth;

  Session({this.id = 0, required this.assetsToDrop, this.assetIdInReview, required this.sessionYear, required this.sessionMonth});
}