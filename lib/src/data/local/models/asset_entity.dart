import 'dart:io';

import 'dart:typed_data' as typed_data;
import 'package:isar/isar.dart';
import 'package:photo_manager/photo_manager.dart' as pm;

part 'asset_entity.g.dart';

@collection
class AssetEntity {
  Id id = Isar.autoIncrement;

  String assetId;

  DateTime creationDate;

  AssetEntity({
    this.id = Isar.autoIncrement,
    required this.assetId,
    required this.creationDate,
  });

  @ignore
  AssetData? assetData;
}

class AssetData {
  final pm.AssetEntity? assetEntity;

  final typed_data.Uint8List? thumbnailData;

  final String? mimeType;

  final File? file;

  final String? mediaUrl;

  AssetData({
    required this.assetEntity,
    required this.thumbnailData,
    required this.mimeType,
    required this.file,
    required this.mediaUrl,
  });

  static Future<AssetData> fromAsset({required AssetEntity asset}) async {
    final assetEntity = await pm.AssetEntity.fromId(asset.assetId);
    final thumbnailData = await assetEntity?.thumbnailData;
    final mimeType = await assetEntity?.mimeTypeAsync;
    File? file;
    String? mediaUrl;
    if (assetEntity?.type == pm.AssetType.image) {
      file = await assetEntity?.file;
    } else {
      mediaUrl = await assetEntity?.getMediaUrl();
    }
    final assetData = AssetData(
      assetEntity: assetEntity,
      thumbnailData: thumbnailData,
      mimeType: mimeType,
      file: file,
      mediaUrl: mediaUrl,
    );
    asset.assetData = assetData;
    return assetData;
  }
}
