class SessionAsset {
  final String assetId;
  final bool shouldDrop;
  final int sessionId;

  SessionAsset({
    required this.assetId,
    required this.shouldDrop,
    required this.sessionId,
  });

  SessionAsset.fromJson(Map<String, dynamic> json):
        assetId = json['asset_id'] as String,
        shouldDrop = json['should_drop'] as bool,
        sessionId = json['session_id'] as int;

  Map<String, dynamic> toJson() => {
    'asset_id': assetId,
    'should_drop': shouldDrop,
    'session_id': sessionId,
  };
}