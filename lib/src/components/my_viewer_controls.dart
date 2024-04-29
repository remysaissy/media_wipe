import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';

class MyViewerControls extends StatelessWidget {
  final AsyncCallback? onKeepPressed;
  final AsyncCallback? onDropPressed;

  const MyViewerControls({super.key, this.onKeepPressed, this.onDropPressed});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: onKeepPressed, child: const Icon(Icons.check)),
    ));
    children.add(Flexible(
      child: ElevatedButton(
          onPressed: onDropPressed, child: const Icon(Icons.close)),
    ));
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: children);
  }
}
