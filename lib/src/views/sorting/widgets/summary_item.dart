import 'package:app/src/models/asset.dart';
import 'package:app/src/utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

class SummaryItem extends StatelessWidget {
  final Asset asset;

  const SummaryItem({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Utils.futureBuilder(
            future: asset.loadEntity(),
            onReady: (data) {
              final assetEntity = data as AssetEntity;
              return Utils.futureBuilder(
                  future: assetEntity.thumbnailData,
                  onReady: (data) {
                    if (data == null) {
                      return Utils.buildLoading(context);
                    }
                    return ExtendedImage.memory(data);
                  });
            }));
  }
}
