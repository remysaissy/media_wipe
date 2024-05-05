import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/commands/sessions/cancel_session_command.dart';
import 'package:app/src/commands/sessions/finish_session_command.dart';
import 'package:app/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:app/src/components/my_photo_viewer_card.dart';
import 'package:app/src/components/my_scaffold.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/sessions_model.dart';
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
    final allSessions = context.read<SessionsModel>().sessions;
    final yearMonthKey =
        Utils.stringifyYearMonth(year: widget.year, month: widget.month);
    SessionData? session = allSessions[yearMonthKey];
    context.watch<SessionsModel>();
    if (session == null || session.assetIdsToDrop.isEmpty) {
      return _buildNothingToValidate(context);
    } else {
      final allAssets = context.read<AssetsModel>().assets;
      List<AssetData> assets = allAssets[yearMonthKey]!;
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
                  itemCount: session.assetIdsToDrop.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentAssetId = session.assetIdsToDrop[index];
                    final currentAsset = assets
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

// final AssetsController _assetsController = di<AssetsController>();
//
// Future<void> _initState() async {
// }
//
// @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     _initState();
//   });
// }
//
// @override
// Widget build(BuildContext context) {
//   final assetsToDrop = watchPropertyValue((AssetsController x) => x.assetsToDrop);
//   final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//   return MyScaffold(
//       appBar: AppBar(
//         leading: null,
//         title: const Text('Review of photos to delete'),
//         actions: [
//           MyCTATextButton(onPressed: () async {
//             await _assetsController.finishSession(isCanceled: true);
//             if (!context.mounted) return;
//             context.go('/home');
//           }, text: 'Cancel'),
//           MyCTATextButton(onPressed: () async {
//             await _assetsController.finishSession();
//             if (!context.mounted) return;
//             context.go('/home');
//           }, text: 'Validate'),
//         ],
//       ),
//       child: GridView.count(
//         // Create a grid with 2 columns. If you change the scrollDirection to
//         // horizontal, this produces 2 rows.
//         crossAxisCount: isPortrait ? 2 : 3,
//         // Generate 100 widgets that display their index in the List.
//         children: List.generate(assetsToDrop.length, (index) {
//           final currentAsset = assetsToDrop[index];
//           return GestureDetector(onTap: () async {
//             await _assetsController.onKeepPressed(asset: currentAsset);
//               if (_assetsController.assetsToDrop.isEmpty) {
//                 await _assetsController.finishSession(isCanceled: true);
//                 if (!context.mounted) return;
//                 context.go('/home');
//               }
//             },
//               child: Center(
//               child: (currentAsset.assetType == AssetType.Video) ? MyVideoCard(asset: currentAsset) :  MyImageCard(asset: currentAsset)),
//           );
//         }),
//       ));
// }
}
