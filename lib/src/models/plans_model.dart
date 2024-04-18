class Plan {
  final String productID;
  final DateTime subscribedAt;

  Plan({required this.productID, required this.subscribedAt});
  Plan.subscribe({required this.productID}): subscribedAt = DateTime.now();

  Plan.fromJson(Map<String, dynamic> json):
        productID = json['productID'] as String,
        subscribedAt = DateTime.fromMillisecondsSinceEpoch(json['subscribedAt'] as int);

  Map<String, dynamic> toJson() => {
    'productID': productID,
    'subscribedAt': subscribedAt.millisecondsSinceEpoch
  };
}