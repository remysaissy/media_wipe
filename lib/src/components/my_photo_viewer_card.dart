import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/utils.dart';

class MyPhotoViewerCard extends StatelessWidget {
  final AssetEntity assetEntity;

  const MyPhotoViewerCard({super.key, required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    return Utils.futureBuilder(
        future: assetEntity.file,
        onReady: (file) {
          if (file != null) {
            return ExtendedImage.file(file);
          }
          return Utils.buildLoading(context);
        });
  }
}
