import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/components/my_photo_viewer_card.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';

class MyViewer extends StatelessWidget {
  final AssetEntity assetEntity;

  const MyViewer({super.key, required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.6
            : MediaQuery.of(context).size.height * 0.35,
        child: MyPhotoViewerCard(assetEntity: assetEntity));
  }
}
