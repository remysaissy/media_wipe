import 'package:app/assets/models/asset.dart';
import 'package:flutter/material.dart';
import 'package:app/assets/widgets/my_format_badge.dart';
import 'package:app/shared/utils.dart';

class MyViewerMetadata extends StatelessWidget {
  final Asset asset;
  final AssetData assetData;

  const MyViewerMetadata(
      {super.key, required this.asset, required this.assetData});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      _buildMetadataEntry(
          title: Utils.creationDateFormat.format(asset.creationDate),
          leadingIcon: Icons.calendar_month_rounded),
      _buildMetadataEntry(
          title:
              '${assetData.assetEntity?.width}x${assetData.assetEntity?.height}',
          leadingIcon: Icons.photo_size_select_large_rounded),
    ];
    return SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.18
            : MediaQuery.of(context).size.height * 0.3,
        child: Stack(children: [
          Column(children: children),
          Align(
              alignment: Alignment.topRight, child: _buildFormatBadge(context)),
        ]));
  }

  Widget _buildMetadataEntry(
      {required String title, required IconData leadingIcon}) {
    return ListTile(leading: Icon(leadingIcon), title: Text(title));
  }

  Widget _buildFormatBadge(BuildContext context) {
    final typeName = assetData.mimeType != null
        ? assetData.mimeType!.split('/')[1].toLowerCase()
        : 'other';
    return MyFormatBadge(title: typeName);
  }
}
