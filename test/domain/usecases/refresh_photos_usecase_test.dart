import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/usecases/media/refresh_photos_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'refresh_photos_usecase_test.mocks.dart';

@GenerateMocks([AssetRepository])
void main() {
  late RefreshPhotosUseCase useCase;
  late MockAssetRepository mockRepository;

  setUp(() {
    mockRepository = MockAssetRepository();
    useCase = RefreshPhotosUseCase(mockRepository);
  });

  group('RefreshPhotosUseCase', () {
    final testAssets2024 = [
      Asset(id: 1, assetId: 'asset1', creationDate: DateTime(2024, 1, 15)),
      Asset(id: 2, assetId: 'asset2', creationDate: DateTime(2024, 2, 10)),
    ];

    final testAssets2023 = [
      Asset(id: 3, assetId: 'asset3', creationDate: DateTime(2023, 12, 5)),
    ];

    test('should refresh specific year when year parameter provided', () async {
      // Arrange
      when(
        mockRepository.refreshPhotosFromDevice(year: 2024),
      ).thenAnswer((_) async => testAssets2024);
      when(
        mockRepository.deleteAssetsByYearAndMonth(any, any),
      ).thenAnswer((_) async => Future.value());
      when(mockRepository.addAssets(any)).thenAnswer((_) async => []);

      // Act
      await useCase.execute(year: 2024);

      // Assert
      verify(mockRepository.refreshPhotosFromDevice(year: 2024)).called(1);
      verify(mockRepository.deleteAssetsByYearAndMonth(2024, 0)).called(1);
      verify(mockRepository.addAssets(testAssets2024)).called(1);
    });

    test(
      'should refresh specific month when both year and month provided',
      () async {
        // Arrange
        when(
          mockRepository.refreshPhotosFromDevice(year: 2024),
        ).thenAnswer((_) async => testAssets2024);
        when(
          mockRepository.deleteAssetsByYearAndMonth(any, any),
        ).thenAnswer((_) async => Future.value());
        when(mockRepository.addAssets(any)).thenAnswer((_) async => []);

        // Act
        await useCase.execute(year: 2024, month: 1);

        // Assert
        verify(mockRepository.refreshPhotosFromDevice(year: 2024)).called(1);
        verify(mockRepository.deleteAssetsByYearAndMonth(2024, 1)).called(1);
        // Should only add assets from January
        final capturedAssets =
            verify(mockRepository.addAssets(captureAny)).captured.single
                as List;
        expect(capturedAssets.length, 1);
        expect((capturedAssets[0] as Asset).creationDate.month, 1);
      },
    );

    test('should not add assets if filtered list is empty', () async {
      // Arrange
      when(
        mockRepository.refreshPhotosFromDevice(year: 2024),
      ).thenAnswer((_) async => testAssets2024);
      when(
        mockRepository.deleteAssetsByYearAndMonth(any, any),
      ).thenAnswer((_) async => Future.value());

      // Act
      await useCase.execute(year: 2024, month: 5); // No assets in May

      // Assert
      verify(mockRepository.deleteAssetsByYearAndMonth(2024, 5)).called(1);
      verifyNever(mockRepository.addAssets(any));
    });

    test('should refresh all years when no year parameter provided', () async {
      // Arrange
      final currentYear = DateTime.now().year;

      when(
        mockRepository.refreshPhotosFromDevice(year: currentYear),
      ).thenAnswer((_) async => testAssets2024);
      when(mockRepository.getAssetsByYear(any)).thenAnswer((_) async => []);
      when(
        mockRepository.refreshPhotosFromDevice(year: currentYear - 1),
      ).thenAnswer((_) async => testAssets2023);
      when(
        mockRepository.refreshPhotosFromDevice(year: currentYear - 2),
      ).thenAnswer((_) async => []);

      when(mockRepository.addAssets(any)).thenAnswer((_) async => []);
      when(mockRepository.deleteAssets(any)).thenAnswer((_) async => []);

      // Act
      await useCase.execute();

      // Assert
      verify(
        mockRepository.refreshPhotosFromDevice(year: currentYear),
      ).called(1);
      verify(
        mockRepository.refreshPhotosFromDevice(year: currentYear - 1),
      ).called(1);
      verify(
        mockRepository.refreshPhotosFromDevice(year: currentYear - 2),
      ).called(1);
    });

    test(
      'should add new assets and remove deleted assets when refreshing all',
      () async {
        // Arrange
        final currentYear = DateTime.now().year;
        final deviceAssets = [
          Asset(id: 1, assetId: 'asset1', creationDate: DateTime(currentYear)),
          Asset(id: 2, assetId: 'asset2', creationDate: DateTime(currentYear)),
        ];
        final storedAssets = [
          Asset(id: 2, assetId: 'asset2', creationDate: DateTime(currentYear)),
          Asset(id: 3, assetId: 'asset3', creationDate: DateTime(currentYear)),
        ];

        when(
          mockRepository.refreshPhotosFromDevice(year: anyNamed('year')),
        ).thenAnswer((invocation) async {
          final year = invocation.namedArguments[#year] as int;
          return year == currentYear ? deviceAssets : [];
        });
        when(mockRepository.getAssetsByYear(any)).thenAnswer((
          invocation,
        ) async {
          final year = invocation.positionalArguments[0] as int;
          return year == currentYear ? storedAssets : [];
        });

        when(mockRepository.addAssets(any)).thenAnswer((_) async => []);
        when(mockRepository.deleteAssets(any)).thenAnswer((_) async => []);

        // Act
        await useCase.execute();

        // Assert
        // Should add asset1 (new)
        final addedAssets =
            verify(mockRepository.addAssets(captureAny)).captured.single
                as List;
        expect(addedAssets.length, 1);
        expect((addedAssets[0] as Asset).assetId, 'asset1');

        // Should remove asset3 (deleted from device)
        final removedIds =
            verify(mockRepository.deleteAssets(captureAny)).captured.single
                as List;
        expect(removedIds.length, 1);
        expect(removedIds[0], 3);
      },
    );

    test('should stop iterating when reaching year with no assets', () async {
      // Arrange
      final currentYear = DateTime.now().year;

      when(
        mockRepository.refreshPhotosFromDevice(year: currentYear),
      ).thenAnswer((_) async => testAssets2024);
      when(mockRepository.getAssetsByYear(any)).thenAnswer((_) async => []);
      when(
        mockRepository.refreshPhotosFromDevice(year: currentYear - 1),
      ).thenAnswer((_) async => []);

      when(mockRepository.addAssets(any)).thenAnswer((_) async => []);

      // Act
      await useCase.execute();

      // Assert
      verify(
        mockRepository.refreshPhotosFromDevice(year: currentYear),
      ).called(1);
      verify(
        mockRepository.refreshPhotosFromDevice(year: currentYear - 1),
      ).called(1);
      // Should not check further years
      verifyNever(
        mockRepository.refreshPhotosFromDevice(year: currentYear - 2),
      );
    });
  });
}
