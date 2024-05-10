import 'package:app/objectbox.g.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/services/assets_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([AssetsService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Store store;

  setUp(() async {
    store = Store(getObjectBoxModel(), directory: "memory:test-db");
  });

  tearDown(() async {
    store.close();
  });

  // when(mockPhotoManager.getAssetCount()).thenReturn(value);

  group('Standard usage', () {
    test('Count all media', () async {
      final box = store.box<Asset>();
      final model = AssetsModel(box);
      await model.load();
      final assets = model.listYears();
      expect(assets.length, 0);
    });
  });
}
