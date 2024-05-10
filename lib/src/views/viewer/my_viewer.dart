import 'package:app/src/models/asset.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:app/src/views/viewer/widgets/my_video_viewer_card.dart';

class MyViewer extends StatelessWidget {
  final Asset asset;

  const MyViewer({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (asset.assetEntity?.type == AssetType.image) {
      child = ExtendedImage.file(asset.file!);
    } else {
      child = MyVideoViewerCard(asset: asset);
    }
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75, child: child);
  }
}
