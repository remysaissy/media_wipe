import 'package:flutter/material.dart';

class AssetsByYearMonthView extends StatefulWidget {

  final int year;
  final int month;

  const AssetsByYearMonthView({super.key, required this.year, required this.month});

  @override
  State<StatefulWidget> createState() => _AssetsByYearMonthViewState();
}

class _AssetsByYearMonthViewState extends State<AssetsByYearMonthView> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  // final AssetsController _assetsController = di<AssetsController>();
  //
  // Future<void> _initState() async {
  //   final yearMonth = Asset.toYearMonth(year: widget.year, month: widget.month);
  //   await _assetsController.init(yearMonth: yearMonth);
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
  //   final currentSelectionAsset = watchPropertyValue((AssetsController x) => x.currentSelectionAsset);
  //   final currentSelectionIndex = watchPropertyValue((AssetsController x) => x.currentSelectionIndex);
  //   final totalAssetsForMonth = watchPropertyValue((AssetsController x) => x.totalAssetsForMonth);
  //   Widget card;
  //   if (currentSelectionAsset != null) {
  //     if (currentSelectionAsset.assetType == AssetType.Video) {
  //       card = MyVideoCard(asset: currentSelectionAsset);
  //     } else {
  //       card = MyImageCard(asset: currentSelectionAsset);
  //     }
  //   } else {
  //     card = _buildLoading(context);
  //   }
  //   return MyScaffold(
  //       appBar: AppBar(
  //         title: Text('${Utils.monthNumberToMonthName(widget.month)} ${widget.year}'),
  //         actions: [
  //           Text('${currentSelectionIndex+1}/${totalAssetsForMonth}'),
  //           IconButton(
  //             onPressed: _assetsController.onRestart,
  //             icon: const Icon(Symbols.refresh),
  //           ),
  //         ],
  //       ),
  //       child: Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             card,
  //             Align(alignment: Alignment.bottomCenter,
  //             child: Padding(padding: const EdgeInsets.all(8.0),
  //                     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       FloatingActionButton(onPressed: () async {
  //                         await _assetsController.onKeepPressed(onEnd: () {
  //                           if (!context.mounted) return;
  //                           _assetsController.assetsToDrop.isNotEmpty ? context.go('/assets/summary') : context.go('/home');
  //                         });
  //                       },
  //                           heroTag: null,
  //                           child: const Icon(Symbols.check)),
  //                       FloatingActionButton(onPressed: () async {
  //                         await _assetsController.onDropPressed(onEnd: () {
  //                           if (!context.mounted) return;
  //                           _assetsController.assetsToDrop.isNotEmpty ? context.go('/assets/summary') : context.go('/home');
  //                         });
  //                       },
  //                           heroTag: null,
  //                           child: const Icon(Symbols.close)),
  //                     ]),
  //             )
  //             )]
  //       ));
  // }
  //
  // Widget _buildLoading(BuildContext context) {
  //   return Card(
  //     semanticContainer: true,
  //     clipBehavior: Clip.antiAliasWithSaveLayer,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     elevation: 5,
  //     margin: const EdgeInsets.all(10),
  //     child: const CircularProgressIndicator(),
  //   );
  // }
}