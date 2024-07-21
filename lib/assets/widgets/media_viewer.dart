import 'package:app/assets/models/asset.dart';
import 'package:app/assets/views/my_viewer.dart';
import 'package:app/shared/utils.dart';
import 'package:flutter/material.dart';

class MediaViewer extends StatelessWidget {
  final Asset asset;

  const MediaViewer({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    if (asset.assetData != null) {
      return SingleChildScrollView(
          child: MyViewer(asset: asset, assetData: asset.assetData!));
    } else {
      return Utils.futureBuilder(
          future: AssetData.fromAsset(asset: asset),
          onReady: (data) {
            final assetData = data as AssetData;
            return SingleChildScrollView(
                child: MyViewer(asset: asset, assetData: assetData));
          });
    }
  }
}
