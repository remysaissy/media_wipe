import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class MyPhotoViewerCard extends StatelessWidget {
  final AssetEntity assetEntity;

  const MyPhotoViewerCard({super.key, required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    return AssetEntityImage(assetEntity);
  }
}
