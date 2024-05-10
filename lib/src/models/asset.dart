import 'dart:io';

import 'package:equatable/equatable.dart';
import 'dart:typed_data' as typed_data;
import 'package:objectbox/objectbox.dart';
import 'package:photo_manager/photo_manager.dart';

@Entity()
class Asset extends Equatable {
  @Id()
  int id;

  String assetId;

  @Property(type: PropertyType.date)
  DateTime creationDate;

  Asset({this.id = 0, required this.assetId, required this.creationDate});

  @Transient()
  AssetEntity? assetEntity;

  @Transient()
  typed_data.Uint8List? thumbnailData;

  @Transient()
  String? mimeType;

  @Transient()
  File? file;

  @Transient()
  String? mediaUrl;

  Future<Asset> loadEntity() async {
    assetEntity = await AssetEntity.fromId(assetId);
    thumbnailData = await assetEntity?.thumbnailData;
    mimeType = await assetEntity?.mimeTypeAsync;
    if (assetEntity?.type == AssetType.image) {
      file = await assetEntity?.file;
    } else {
      mediaUrl = await assetEntity?.getMediaUrl();
    }
    return this;
  }

  @override
  List<Object?> get props => [id, assetId, creationDate];
}
