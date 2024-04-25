import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';

class MyViewerControls extends StatelessWidget {
  final AssetData assetData;
  final AssetEntity assetEntity;
  final AsyncCallback? onKeepPressed;
  final AsyncCallback? onDropPressed;

  const MyViewerControls(
      {super.key,
      required this.assetData,
      required this.assetEntity,
      this.onKeepPressed,
      this.onDropPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            FloatingActionButton(
                onPressed: onKeepPressed,
                heroTag: null,
                child: const Icon(Icons.check)),
            FloatingActionButton(
                onPressed: onDropPressed,
                heroTag: null,
                child: const Icon(Icons.close)),
          ]),
        ));
  }
}
