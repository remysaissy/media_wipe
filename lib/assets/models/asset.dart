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

  @override
  List<Object?> get props => [id, assetId, creationDate];
}

class AssetData {
  final AssetEntity? assetEntity;

  final typed_data.Uint8List? thumbnailData;

  final String? mimeType;

  final File? file;

  final String? mediaUrl;

  AssetData({required this.assetEntity, required this.thumbnailData, required this.mimeType, required this.file, required this.mediaUrl});

  static Future<AssetData> fromAsset({required Asset asset}) async {
    final assetEntity = await AssetEntity.fromId(asset.assetId);
    final thumbnailData = await assetEntity?.thumbnailData;
    final mimeType = await assetEntity?.mimeTypeAsync;
    File? file;
    String? mediaUrl;
    if (assetEntity?.type == AssetType.image) {
      file = await assetEntity?.file;
    } else {
      mediaUrl = await assetEntity?.getMediaUrl();
    }
    return AssetData(assetEntity: assetEntity, thumbnailData: thumbnailData, mimeType: mimeType, file: file, mediaUrl: mediaUrl);
  }
}