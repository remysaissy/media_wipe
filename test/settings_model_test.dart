import 'dart:ffi';

import 'package:objectbox/objectbox.dart';
import 'package:app/objectbox.g.dart';
import 'package:app/src/models/settings.dart';
import 'package:app/src/models/settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Store store;

  setUpAll(() async {
    store = Store(getObjectBoxModel(), directory: "memory:test-db");
  });

  tearDownAll(() async {
    store.close();
  });

  group('Basic operations', () {
    test('Work properly', () async {
      final box = store.box<Settings>();
      final model = SettingsModel(box);
      await model.fetchSettings();
      final settingsRead = box.get(model.settings.id);
      expect(settingsRead?.debugDryRemoval, true);
    });
  });
}
