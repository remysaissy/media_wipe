import 'package:app/assets/models/asset.dart';
import 'package:app/assets/widgets/my_viewer_metadata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SortPhotosControls extends StatelessWidget {
  final AsyncCallback? onKeepPressed;
  final AsyncCallback? onDropPressed;
  final Asset asset;
  final AssetData assetData;

  const SortPhotosControls(
      {super.key,
      this.onKeepPressed,
      this.onDropPressed,
      required this.asset, required this.assetData});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: onKeepPressed, child: const Icon(Icons.check_outlined)),
    ));
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return MyViewerMetadata(asset: asset, assetData: assetData);
              }),
          child: const Icon(Icons.info_outline)),
    ));
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: onDropPressed, child: const Icon(Icons.close_outlined)),
    ));
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: children);
  }
}
