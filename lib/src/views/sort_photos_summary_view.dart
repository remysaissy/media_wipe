import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/sessions/cancel_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/finish_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/components/my_cta_text_button.dart';
import 'package:sortmaster_photos/src/components/my_photo_viewer_card.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/models/sessions_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class SortPhotosSummaryView extends StatelessWidget {
  final int year;
  final int month;

  const SortPhotosSummaryView({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    final yearMonthKey = Utils.stringifyYearMonth(year: year, month: month);
    Map<String, List<AssetData>> allAssets = context.select<AssetsModel, Map<String, List<AssetData>>>((value) => value.assets);
    List<AssetData> assets = allAssets[yearMonthKey]!;
    Map<String, SessionData> allSessions = context.select<SessionsModel, Map<String, SessionData>>((value) => value.sessions);
    SessionData session = allSessions[yearMonthKey]!;
    return Provider.value(value: allSessions,
    child: MyScaffold(
              appBar: AppBar(
                leading: null,
                title: const Text('Review of photos to delete'),
                actions: [
                  MyCTATextButton(onPressed: () async {
                    await CancelSessionCommand(context).run(year: year, month: month);
                    if (!context.mounted) return;
                    context.go('/home');
                  }, text: 'Cancel'),
                  MyCTATextButton(onPressed: () async {
                    await FinishSessionCommand(context).run(year: year, month: month);
                    if (!context.mounted) return;
                    context.go('/home');
                  }, text: 'Validate'),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(session.assetIdsToDrop.length, (index) {
                  final currentAssetId = session.assetIdsToDrop[index];
                  final currentAsset = assets.where((element) => element.id == currentAssetId).first;

                  return GestureDetector(onTap: () async {
                    print('Gesture');
                    await KeepAssetInSessionCommand(context).run(assetData: currentAsset);
                    },
                      child: Center(child: MyPhotoViewerCard(assetData: currentAsset)),
                  );
                }),
              ))
    );
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