class Session {
  late int? id;
  final bool isDone;
  final String currentAssetId;
  final int yearMonth;

  Session({
    this.id,
    required this.isDone,
    required this.currentAssetId,
    required this.yearMonth
  });

  Session.fromJson(Map<String, dynamic> json):
        id = json['id'] as int,
        isDone = json['is_done'] as bool,
        currentAssetId = json['current_asset_id'] as String,
        yearMonth = json['year_month'] as int;

  Map<String, dynamic> toJson() => {
    'id': id,
    'is_done': isDone,
    'current_asset_id': currentAssetId,
    'year_month': yearMonth,
  };
}