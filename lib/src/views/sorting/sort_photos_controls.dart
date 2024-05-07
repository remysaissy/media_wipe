import 'package:app/src/models/asset.dart';
import 'package:app/src/views/viewer/my_viewer_metadata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class SortPhotosControls extends StatelessWidget {
  final AsyncCallback? onKeepPressed;
  final AsyncCallback? onDropPressed;
  final Asset assetData;
  final AssetEntity assetEntity;

  const SortPhotosControls(
      {super.key,
      this.onKeepPressed,
      this.onDropPressed,
      required this.assetData,
      required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: onKeepPressed, child: const Icon(Icons.check)),
    ));
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return MyViewerMetadata(
                    assetData: assetData, assetEntity: assetEntity);
              }),
          child: const Icon(Icons.add_card_rounded)),
    ));
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: onDropPressed, child: const Icon(Icons.close)),
    ));
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: children);
  }
}
