import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/components/my_rounded_box.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class MyViewerMetadata extends StatelessWidget {
  final AssetData assetData;
  final AssetEntity assetEntity;

  const MyViewerMetadata(
      {super.key, required this.assetData, required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    return Utils.futureBuilder(
        future: assetEntity.mimeTypeAsync,
        onReady: (data) {
          final typeName =
              data != null ? data.split('/')[1].toLowerCase() : 'other';
          List<Widget> children = [
            Text(
                'Created on ${Utils.creationDateFormat.format(assetData.creationDate)}'),
            Text('${assetEntity.width}x${assetEntity.height}'),
          ];
          // No geolocation for now.
          // if (assetEntity.latitude != 0) {
          //   Text('${assetEntity.latitude}x${assetEntity.longitude}');
          // }
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children),
                MyRoundedBox(title: typeName)
              ]);
        });
  }
}
