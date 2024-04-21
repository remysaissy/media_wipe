import 'package:flutter/material.dart';

class AssetsSummaryView extends StatefulWidget {
  const AssetsSummaryView({super.key});

  @override
  State<StatefulWidget> createState() => _AssetsSummaryViewState();
}

class _AssetsSummaryViewState extends State<AssetsSummaryView> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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