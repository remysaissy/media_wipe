

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';

class MyImageCard extends StatelessWidget {

  final Asset asset;

  const MyImageCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final assetUri = Uri.parse(asset.assetUrl);
    final assetFile = File(assetUri.path);
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Image.file(assetFile, fit: BoxFit.fill),
    );
  }

}