import 'dart:convert';

import 'package:app/src/models/abstract_model.dart';
import 'package:app/src/utils.dart';

class SessionData {

  late List<String> assetIdsToDrop;
  final bool isFinished;

  SessionData({required this.assetIdsToDrop, required this.isFinished});

  SessionData.empty():
      assetIdsToDrop = [],
      isFinished = false;

  SessionData.fromJson(Map<String, dynamic> json):
        isFinished = json['isFinished'] as bool,
        assetIdsToDrop = jsonDecode(json['assetIdsToDrop'] as String);

  Map<String, dynamic> toJson() => {
    'isFinished': isFinished,
    'assetIdsToDrop': jsonEncode(assetIdsToDrop)
  };
}

class SessionsModel extends AbstractModel {

  SessionsModel() {
    enableSerialization('sessions.dat');
  }

  Map<String, SessionData> _sessions = {};
  Map<String, SessionData> get sessions => _sessions;
  set sessions(Map<String, SessionData> sessions) {
    _sessions = sessions;
    _updatedAt = DateTime.now();
    scheduleSave();
    notifyListeners();
  }

  DateTime _updatedAt = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime get updatedAt => _updatedAt;

  @override
  void reset([bool notify = true]) {
    Utils.logger.i("[SessionsModel] Reset");
    copyFromJson({});
    super.reset(notify);
  }

  /////////////////////////////////////////////////////////////////////
  // Define serialization methods

  //Json Serialization
  @override
  SessionsModel copyFromJson(Map<String, dynamic> json) {
    _sessions = json.containsKey('_sessions') ? jsonDecode(json['_sessions']) : {};
    _updatedAt = json.containsKey('_updatedAt') ? DateTime.fromMillisecondsSinceEpoch(json['_updatedAt']) : DateTime.fromMillisecondsSinceEpoch(0);
    return this;
  }

  @override
  Map<String, dynamic> toJson() => {
    '_sessions': jsonEncode(_sessions),
    '_updatedAt': _updatedAt.millisecondsSinceEpoch,
  };
}
