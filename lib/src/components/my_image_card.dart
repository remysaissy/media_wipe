

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';

class MyImageCard extends StatelessWidget {

  final Asset asset;

  const MyImageCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final assetUri = Uri.parse(asset.assetUrl);
    final assetFile = File(assetUri.path);
    return FutureBuilder(
        future: AssetEntity.fromId(asset.id),
        builder: (context, snapshot) {
          return Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: snapshot.data != null ? AssetEntityImage(snapshot.data!) : const Center(child: CircularProgressIndicator()),
            //Image.file(assetFile, fit: BoxFit.fill),
          );
        });
  }

}