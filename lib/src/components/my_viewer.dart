import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/components/my_photo_viewer_card.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';

class MyViewer extends StatelessWidget {

  final AssetData assetData;
  final AssetEntity assetEntity;

  const MyViewer({super.key, required this.assetData, required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    return MyPhotoViewerCard(assetData: assetData);
  }
}