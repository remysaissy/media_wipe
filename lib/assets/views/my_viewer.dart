import 'package:app/assets/models/asset.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:app/assets/widgets/my_video_viewer_card.dart';

class MyViewer extends StatelessWidget {
  final Asset asset;
  final AssetData assetData;

  const MyViewer({super.key, required this.asset, required this.assetData});

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (assetData.assetEntity?.type == AssetType.image) {
      child = ExtendedImage.file(assetData.file!);
    } else {
      child = MyVideoViewerCard(asset: asset, assetData: assetData);
    }
    return child;
    // return SizedBox(
    //   // width: MediaQuery.sizeOf(context).width,
    //   height: MediaQuery.sizeOf(context).height * 0.75,
    //   child: child,
    // );
  }
}
