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
    List<Widget> children = [
      _buildMetadataEntry(
          title: Utils.creationDateFormat.format(assetData.creationDate),
          leadingIcon: Icons.calendar_month_rounded),
      _buildMetadataEntry(
          title: '${assetEntity.width}x${assetEntity.height}',
          leadingIcon: Icons.photo_size_select_large_rounded),
    ];
    return SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.18
            : MediaQuery.of(context).size.height * 0.3,
        child: Stack(children: [
          Column(children: children),
          Align(
              alignment: Alignment.topRight,
              child: _buildFormatBadge(context, assetEntity)),
        ]));
  }

  Widget _buildMetadataEntry(
      {required String title, required IconData leadingIcon}) {
    return ListTile(leading: Icon(leadingIcon), title: Text(title));
  }

  Widget _buildFormatBadge(BuildContext context, AssetEntity assetEntity) {
    return Utils.futureBuilder(
        future: assetEntity.mimeTypeAsync,
        onReady: (data) {
          final typeName =
              data != null ? data.split('/')[1].toLowerCase() : 'other';
          return MyRoundedBox(title: typeName);
        });
  }
}
