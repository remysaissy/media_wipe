import 'package:app/src/domain/entities/asset.dart';
import 'package:app/src/domain/repositories/asset_repository.dart';
import 'package:app/src/domain/usecases/media/delete_assets_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_assets_usecase_test.mocks.dart';

@GenerateMocks([AssetRepository])
void main() {
  late DeleteAssetsUseCase useCase;
  late MockAssetRepository mockRepository;

  setUp(() {
    mockRepository = MockAssetRepository();
    useCase = DeleteAssetsUseCase(mockRepository);
  });

  group('DeleteAssetsUseCase', () {
    final testAssets = [
      Asset(id: 1, assetId: 'asset1', creationDate: DateTime(2024, 1, 1)),
      Asset(id: 2, assetId: 'asset2', creationDate: DateTime(2024, 1, 2)),
      Asset(id: 3, assetId: 'asset3', creationDate: DateTime(2024, 1, 3)),
    ];

    test(
      'should delete assets from device and database when not dry run',
      () async {
        // Arrange
        when(
          mockRepository.deleteAssetsFromDevice(
            assetIds: anyNamed('assetIds'),
            isDry: anyNamed('isDry'),
          ),
        ).thenAnswer((_) async => ['asset1', 'asset2', 'asset3']);

        when(
          mockRepository.deleteAssets(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await useCase.execute(assets: testAssets, isDryRun: false);

        // Assert
        verify(
          mockRepository.deleteAssetsFromDevice(
            assetIds: ['asset1', 'asset2', 'asset3'],
            isDry: false,
          ),
        ).called(1);
        verify(mockRepository.deleteAssets([1, 2, 3])).called(1);
      },
    );

    test('should only call device deletion when in dry run mode', () async {
      // Arrange
      when(
        mockRepository.deleteAssetsFromDevice(
          assetIds: anyNamed('assetIds'),
          isDry: anyNamed('isDry'),
        ),
      ).thenAnswer((_) async => <String>[]);

      // Act
      await useCase.execute(assets: testAssets, isDryRun: true);

      // Assert
      verify(
        mockRepository.deleteAssetsFromDevice(
          assetIds: ['asset1', 'asset2', 'asset3'],
          isDry: true,
        ),
      ).called(1);
      verifyNever(mockRepository.deleteAssets(any));
    });

    test(
      'should only delete assets that were successfully removed from device',
      () async {
        // Arrange
        when(
          mockRepository.deleteAssetsFromDevice(
            assetIds: anyNamed('assetIds'),
            isDry: anyNamed('isDry'),
          ),
        ).thenAnswer((_) async => ['asset1', 'asset3']); // Only 2 removed

        when(
          mockRepository.deleteAssets(any),
        ).thenAnswer((_) async => Future.value());

        // Act
        await useCase.execute(assets: testAssets, isDryRun: false);

        // Assert
        verify(mockRepository.deleteAssets([1, 3])).called(1);
      },
    );

    test(
      'should not call database deletion if no assets were removed',
      () async {
        // Arrange
        when(
          mockRepository.deleteAssetsFromDevice(
            assetIds: anyNamed('assetIds'),
            isDry: anyNamed('isDry'),
          ),
        ).thenAnswer((_) async => <String>[]);

        // Act
        await useCase.execute(assets: testAssets, isDryRun: false);

        // Assert
        verifyNever(mockRepository.deleteAssets(any));
      },
    );

    test('should handle empty asset list', () async {
      // Arrange
      when(
        mockRepository.deleteAssetsFromDevice(
          assetIds: anyNamed('assetIds'),
          isDry: anyNamed('isDry'),
        ),
      ).thenAnswer((_) async => <String>[]);

      // Act
      await useCase.execute(assets: [], isDryRun: false);

      // Assert
      verify(
        mockRepository.deleteAssetsFromDevice(assetIds: [], isDry: false),
      ).called(1);
      verifyNever(mockRepository.deleteAssets(any));
    });
  });
}
