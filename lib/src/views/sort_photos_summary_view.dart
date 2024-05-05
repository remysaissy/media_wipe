import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/commands/sessions/cancel_session_command.dart';
import 'package:app/src/commands/sessions/finish_session_command.dart';
import 'package:app/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:app/src/components/my_photo_viewer_card.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/utils.dart';

class SortPhotosSummaryView extends StatefulWidget {
  final int year;
  final int month;

  const SortPhotosSummaryView(
      {super.key, required this.year, required this.month});

  @override
  State<StatefulWidget> createState() => _SortPhotosSummaryState();
}

class _SortPhotosSummaryState extends State<SortPhotosSummaryView> {
  Widget _buildNothingToValidate(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          const Center(child: Text('Nothing to delete!')),
          Center(
              child: TextButton(
                  onPressed: () async {
                    await CancelSessionCommand(context)
                        .run(year: widget.year, month: widget.month);
                    if (!context.mounted) return;
                    context.go('/');
                  },
                  child: const Text('Go to main screen')))
        ])));
  }

  @override
  Widget build(BuildContext context) {
    var assets = context
        .read<AssetsModel>()
        .assets
        .where((e) => e.year == widget.year && e.month == widget.month)
        .firstOrNull;
    context.watch<AssetsModel>();
    if (assets == null || assets.assetIdsToDrop.isEmpty) {
      return _buildNothingToValidate(context);
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: null,
            title: const Text('Review of photos to delete'),
            actions: [
              IconButton(
                  onPressed: () async {
                    if (!context.mounted) return;
                    await FinishSessionCommand(context)
                        .run(year: widget.year, month: widget.month);
                    await RefreshPhotosCommand(context).run(year: widget.year);
                    context.go('/');
                  },
                  icon: const Icon(Icons.check)),
            ],
          ),
          body: SafeArea(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: assets.assetIdsToDrop.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentAssetId = assets.assetIdsToDrop[index];
                    final currentAsset = assets.assets
                        .where((element) => element.id == currentAssetId)
                        .first;

                    return GestureDetector(
                      onTap: () async {
                        await KeepAssetInSessionCommand(context)
                            .run(assetData: currentAsset);
                      },
                      child: Center(
                          child: Utils.futureBuilder(
                              future: currentAsset.loadEntity(),
                              onReady: (data) {
                                final assetEntity = data as AssetEntity;
                                return MyPhotoViewerCard(
                                    assetEntity: assetEntity);
                              })),
                    );
                  })));
    }
  }
}
