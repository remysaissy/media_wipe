import 'package:app/src/models/asset.dart';
import 'package:app/src/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

class SummaryItem extends StatelessWidget {
  final Asset asset;

  const SummaryItem({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Utils.futureBuilder(
            future: AssetData.fromAsset(asset: asset),
            onReady: (data) {
              final assetData = data as AssetData;
              return ExtendedImage.memory(assetData.thumbnailData!);
            }));
  }
}
