import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/src/utils.dart';

abstract class AbstractModel extends ChangeNotifier {
  String? _fileName;
  File? _file;

  void reset([bool notify = true]) {
    copyFromJson({});
    if (notify) notifyListeners();
    scheduleSave();
  }

  //Make sure that we don't spam the file systems, cap saves to a max frequency
  bool _isSaveScheduled = false;

  //[SB] This is a helper method
  void scheduleSave() async {
    if (_isSaveScheduled) return;
    _isSaveScheduled = true;
    await Future.delayed(const Duration(seconds: 1));
    save();
    _isSaveScheduled = false;
  }

  //Loads a string from disk, and parses it into ourselves.
  Future<dynamic> load() async {
    final baseDirectory = await getLibraryDirectory();
    final fullPath = join(baseDirectory.path, _fileName);
    _file = File(fullPath);
    final file = _file;
    if (file == null) return copyFromJson(jsonDecode("{}"));

    String string = '{}';
    if (await file.exists()) {
      await file.readAsString().catchError((e, s) {
        Utils.logger.e("$e", stackTrace: s);
        return copyFromJson(jsonDecode("{}"));
      });
    }
    return copyFromJson(jsonDecode(string));
  }

  Future<void> save() async => _file?.writeAsString(jsonEncode(toJson()));

  //Enable file serialization, remember to override the to/from serialization methods as well
  void enableSerialization(String fileName) {
    _fileName = fileName;
  }

  Map<String, dynamic> toJson() {
    // This should be over-ridden in concrete class to enable serialization
    throw UnimplementedError();
  }

  dynamic copyFromJson(Map<String, dynamic> json) {
    // This should be over-ridden in concrete class to enable serialization
    throw UnimplementedError();
  }

  List<T> toList<T>(dynamic json, dynamic Function(dynamic) fromJson) {
    final List<T> list = (json as Iterable?)?.map((e) {
      return e == null ? e : fromJson(e) as T?;
    }).where((e) => e != null).whereType<T>().toList() ?? [];

    return list;
  }
}
