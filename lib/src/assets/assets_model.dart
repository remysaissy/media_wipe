class AssetModel {
  final String id;
  final DateTime creationDate;
  final int yearMonth;

  AssetModel({
    required this.id,
    required this.creationDate,
    required this.yearMonth,
  });

  AssetModel.fromJson(Map<String, dynamic> json):
        id = json['id'] as String,
        creationDate = DateTime.fromMillisecondsSinceEpoch(json['creationDate'] as int),
        yearMonth = json['yearMonth'] as int;

  Map<String, dynamic> toJson() => {
    'id': id,
    'creationDate': creationDate.millisecondsSinceEpoch,
    'yearMonth': yearMonth,
  };
}