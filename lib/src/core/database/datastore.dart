import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/src/data/local/models/asset_entity.dart';
import 'package:app/src/data/local/models/session_entity.dart';
import 'package:app/src/data/local/models/settings_entity.dart';

class Datastore {
  Datastore._(this._isar);

  final Isar _isar;

  Isar get isar => _isar;

  static Completer<Datastore>? _completer;

  static Future<Datastore> getInstance() async {
    if (_completer == null) {
      final Completer<Datastore> completer = Completer<Datastore>();
      _completer = completer;
      try {
        final docsDir = await getApplicationSupportDirectory();

        // Handle macOS application group path
        String dbPath;
        if (Platform.isMacOS) {
          // For macOS, use application group directory
          dbPath = p.join(
            docsDir.path,
            'io.weavly.apps.media_wipe.8D96AS3ZME',
            'MediaWipe',
          );
        } else {
          dbPath = p.join(docsDir.path, 'MediaWipe');
        }

        // Create directory if it doesn't exist
        final directory = Directory(dbPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final isar = await Isar.open(
          [AssetEntitySchema, SessionEntitySchema, SettingsEntitySchema],
          directory: dbPath,
          name: 'media_wipe',
        );
        completer.complete(Datastore._(isar));
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
