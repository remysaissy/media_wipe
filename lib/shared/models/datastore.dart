import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:app/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class Datastore {
  Datastore._(this._store);

  final Store _store;

  Store get store => _store;

  static Completer<Datastore>? _completer;

  static Future<Datastore> getInstance() async {
    if (_completer == null) {
      final Completer<Datastore> completer = Completer<Datastore>();
      _completer = completer;
      try {
        final directory = p.join(
          (await getApplicationDocumentsDirectory()).path,
          "db",
        );
        // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
        final store = await openStore(
          directory: directory,
          macosApplicationGroup: "db",
        );
        completer.complete(Datastore._(store));
      } catch (e) {
        // If there's an error, explicitly return the future with an error.
        // then set the completer to null so we can retry.
        completer.completeError(e);
        final Future<Datastore> datastoreFuture = completer.future;
        _completer = null;
        return datastoreFuture;
      }
    }
    return _completer!.future;
  }
}
