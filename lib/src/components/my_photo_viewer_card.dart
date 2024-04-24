import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class MyPhotoViewerCard extends StatelessWidget {
  final AssetData assetData;

  const MyPhotoViewerCard({super.key, required this.assetData});

  @override
  Widget build(BuildContext context) {
    return Utils.futureBuilder(
        future: assetData.loadEntity(),
        onError: (error) {
          return Utils.buildLoading(context);
        },
        onReady: (data) {
          final entity = data as AssetEntity;
          return _buildViewer(context, entity);
        });
  }

  Widget _buildViewer(BuildContext context, AssetEntity entity) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: AssetEntityImage(entity),
    );
  }
}
