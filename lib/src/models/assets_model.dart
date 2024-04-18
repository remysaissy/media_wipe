import 'package:sortmaster_photos/src/utils.dart';

class Asset {
  final String id;
  final String assetUrl;
  final DateTime creationDate;
  final int yearMonth;

  Asset({
    required this.id,
    required this.assetUrl,
    required this.creationDate,
    required this.yearMonth
  });

  Asset.fromJson(Map<String, dynamic> json):
        id = json['id'] as String,
        assetUrl = json['asset_url'] as String,
        creationDate = DateTime.fromMillisecondsSinceEpoch(json['creation_date'] as int),
        yearMonth = json['year_month'] as int;

  Map<String, dynamic> toJson() => {
    'id': id,
    'asset_url': assetUrl,
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