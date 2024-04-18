class Session {
  late int? id;
  late String? currentAssetId;
  final int yearMonth;
  late List<String> assetIdsToDrop;

  Session({
    this.id,
    required this.yearMonth,
    required this.currentAssetId,
    required this.assetIdsToDrop,
  });

  Session.fromJson(Map<String, dynamic> json):
        id = json['id'] as int,
        currentAssetId = json['current_asset_id'] as String,
        assetIdsToDrop = (json['asset_ids_to_drop'] as String).split(',').toList(),
        yearMonth = json['year_month'] as int;

  Map<String, dynamic> toJson() => {
    'id': id,
    'current_asset_id': currentAssetId,
    'asset_ids_to_drop': assetIdsToDrop.join(','),
    'year_month': yearMonth,
  };
}