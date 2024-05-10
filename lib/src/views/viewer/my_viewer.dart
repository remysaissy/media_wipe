import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:app/src/views/viewer/widgets/my_photo_viewer_card.dart';
import 'package:app/src/views/viewer/widgets/my_video_viewer_card.dart';

class MyViewer extends StatelessWidget {
  final AssetEntity assetEntity;

  const MyViewer({super.key, required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (assetEntity.type == AssetType.image) {
      child = MyPhotoViewerCard(assetEntity: assetEntity);
    } else {
      child = MyVideoViewerCard(assetEntity: assetEntity);
    }
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75, child: child);
  }
}
