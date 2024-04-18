import 'package:sortmaster_photos/src/utils.dart';

enum AssetType {
  Image,
  Video,
  LivePhoto
}

extension IntToAssetTypeExt on int {
  AssetType toAssetType() {
    if (this == 1) return AssetType.Video;
    if (this == 2) return AssetType.LivePhoto;
    return AssetType.Image;
  }
}

extension AssetTypeToIntExt on AssetType {
  int toInt() {
    if (this == AssetType.Video) return 1;
    if (this == AssetType.LivePhoto) return 2;
    return 0;
  }
}

class Asset {
  final String id;
  final String assetUrl;
  final AssetType assetType;
  final DateTime creationDate;
  final int yearMonth;

  Asset({
    required this.id,
    required this.assetUrl,
    required this.assetType,
    required this.creationDate,
    required this.yearMonth
  });

  Asset.fromJson(Map<String, dynamic> json):
        id = json['id'] as String,
        assetUrl = json['asset_url'] as String,
        assetType = (json['asset_type'] as int).toAssetType(),
        creationDate = DateTime.fromMillisecondsSinceEpoch(json['creation_date'] as int),
        yearMonth = json['year_month'] as int;

  Map<String, dynamic> toJson() => {
    'id': id,
    'asset_url': assetUrl,
    'asset_type': assetType.toInt(),
    'creation_date': creationDate.millisecondsSinceEpoch,
    'year_month': yearMonth,
  };

  // Utility function when we need only a specific field.
  static DateTime creationDateFromJson(Map<String, dynamic> json) {
    return DateTime.fromMillisecondsSinceEpoch(json['creation_date'] as int);
  }

  // Utility function when we need only a specific field.
  static String idFromJson(Map<String, dynamic> json) {
    return json['id'] as String;
  }

  // Build the stored Asset model yearMonth field from the two separate values.
  static int toYearMonth({required int year, required int month}) {
    return int.parse('${Utils.yearFormatter.format(year)}${Utils.monthFormatter.format(month)}');
  }
}