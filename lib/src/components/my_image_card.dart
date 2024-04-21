import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';

class MyImageCard extends StatelessWidget {

  final AssetData assetData;
  final AssetEntity assetEntity;

  const MyImageCard({super.key, required this.assetData, required this.assetEntity});

  @override
  Widget build(BuildContext context) {
    return Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: AssetEntityImage(assetEntity),
            //Image.file(assetFile, fit: BoxFit.fill),
    );
  }
}