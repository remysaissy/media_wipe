import 'package:objectbox/objectbox.dart';
import 'package:photo_manager/photo_manager.dart';

@Entity()
class Asset {
  @Id()
  int id;

  String assetId;

  bool toDrop;

  @Property(type: PropertyType.date)
  DateTime creationDate;

  @Transient()
  AssetEntity? entity;

  Asset({this.id = 0, required this.assetId, required this.creationDate, this.toDrop = false});

  Future<AssetEntity?> loadEntity() async {
    entity = await AssetEntity.fromId(assetId);
    return entity;
  }
}