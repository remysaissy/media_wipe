import 'package:app/src/models/asset.dart';
import 'package:flutter/material.dart';
import 'package:app/src/views/viewer/widgets/my_format_badge.dart';
import 'package:app/src/utils.dart';

class MyViewerMetadata extends StatelessWidget {
  final Asset asset;

  const MyViewerMetadata({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      _buildMetadataEntry(
          title: Utils.creationDateFormat.format(asset.creationDate),
          leadingIcon: Icons.calendar_month_rounded),
      _buildMetadataEntry(
          title: '${asset.assetEntity?.width}x${asset.assetEntity?.height}',
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
    final typeName = asset.mimeType != null
        ? asset.mimeType!.split('/')[1].toLowerCase()
        : 'other';
    return MyFormatBadge(title: typeName);
  }
}
