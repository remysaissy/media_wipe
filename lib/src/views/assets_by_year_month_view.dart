import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/sessions/create_or_recover_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/reset_session_command.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/components/my_photo_viewer_card.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class AssetsByYearMonthView extends StatefulWidget {

  final int year;
  final int month;

  const AssetsByYearMonthView({super.key, required this.year, required this.month});

  @override
  State<StatefulWidget> createState() => _AssetsByYearMonthViewState();
}

class _AssetsByYearMonthViewState extends State<AssetsByYearMonthView> {

  late int _currentSelectionIndex;

  Future<void> _initState() async {
    await CreateOrRecoverSessionCommand(context).run(year: widget.year, month: widget.month);
  }

  @override
  void initState() {
    _currentSelectionIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initState();
      });
    super.initState();
  }

    Future<void> _onRestart() async {
      await ResetSessionCommand(context).run(year: widget.year, month: widget.month).then((value) => {
        setState(() {
          _currentSelectionIndex = 0;
        })
      });
  }

  Future<void> _onKeepPressed({required AssetData assetData, required bool updateIndex}) async {
    await KeepAssetInSessionCommand(context).run(assetData: assetData).then((value) => {
      if (updateIndex) {
        setState(() {
          _currentSelectionIndex++;
        })
      }
    });
  }

  Future<void> _onDropPressed({required AssetData assetData, required bool updateIndex}) async {
    await DropAssetInSessionCommand(context).run(assetData: assetData).then((value) => {
      if (updateIndex) {
        setState(() {
          _currentSelectionIndex++;
        })
      }
    });
  }

  // Future<void> _onInfoPressed({required AssetData assetData, required AssetEntity assetEntity}) async {
  //   _overlayEntry = OverlayEntry(
  //     builder: (context) {
  //       return _buildOverlayContent(context, assetData, assetEntity);
  //     },
  //   );
  //   Overlay.of(context).insert(_overlayEntry!);
  // }

  // OverlayEntry? _overlayEntry;
  //
  // Widget _buildOverlayContent(BuildContext context, AssetData assetData, AssetEntity assetEntity) {
  //   return Container(color: Colors.black12, child: Center(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Text('Created on ${assetData.creationDate..toLocal()}'),
  //         MyCTAButton(
  //           onPressed: () => _overlayEntry?.remove(),
  //           child: Text('Dismiss'),
  //         )
  //       ],
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    final yearMonthKey = Utils.stringifyYearMonth(year: widget.year, month: widget.month);
    Map<String, List<AssetData>> allAssets = context.select<AssetsModel, Map<String, List<AssetData>>>((value) => value.assets);
    List<AssetData> assets = allAssets[yearMonthKey]!;
    return Provider.value(value: allAssets,
        child: MyScaffold(
        appBar: AppBar(
          title: Text('${Utils.monthNumberToMonthName(widget.month)} ${widget.year}'),
          actions: [
            Text('${_currentSelectionIndex+1}/${assets.length}'),
            IconButton(
              onPressed: _onRestart,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        child: _buildContent(context, assets)));
  }

  Widget _buildContent(BuildContext context, List<AssetData> assets) {
    return FutureBuilder(future: assets[_currentSelectionIndex].loadEntity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              Utils.logger.e('Error ${snapshot.error} occurred');
              return Utils.buildLoading(context);
            } else if (snapshot.hasData) {
              final entity = snapshot.data as AssetEntity;
              return Stack(
                  alignment: Alignment.center,
                  children: [
                  _buildViewer(context, assets, entity),
                  _buildControls(context, assets, entity)]
              );
            }
          }
          return Utils.buildLoading(context);
        });
  }

  Widget _buildViewer(BuildContext context, List<AssetData> assets, AssetEntity assetEntity) {
    return assets.isEmpty ? Utils.buildLoading(context) : MyPhotoViewerCard(assetData: assets[_currentSelectionIndex]);
  }

  Widget _buildControls(BuildContext context, List<AssetData> assets, AssetEntity entity) {
    return Align(alignment: Alignment.bottomCenter,
        child: Padding(padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(onPressed: () async {
                  bool isNotLastIndex = (_currentSelectionIndex+1 < assets.length);
                  await _onKeepPressed(assetData: assets[_currentSelectionIndex], updateIndex: isNotLastIndex);
                  if (!isNotLastIndex) {
                    Utils.logger.i('Move on');
                    if (context.mounted) {
                      context.pushNamed('summaryByYearMonth', pathParameters: {'year': widget.year.toString(), 'month': widget.month.toString()});
                    }
                  }
                },
                    heroTag: null,
                    child: const Icon(Icons.check)),
                // FloatingActionButton(onPressed: () async {
                //  await _onInfoPressed(assetData: assets[_currentSelectionIndex], assetEntity: entity);
                // },
                //     heroTag: null,
                //     child: const Icon(Icons.info)),
                FloatingActionButton(onPressed: () async {
                  bool isNotLastIndex = (_currentSelectionIndex+1 < assets.length);
                  await _onDropPressed(assetData: assets[_currentSelectionIndex], updateIndex: isNotLastIndex);
                  if (!isNotLastIndex) {
                    Utils.logger.i('Move on');
                    if (context.mounted) {
                      context.pushNamed('summaryByYearMonth', pathParameters: {'year': widget.year.toString(), 'month': widget.month.toString()});
                    }
                  }
                },
                    heroTag: null,
                    child: const Icon(Icons.close)),
              ]),
        )
    );
  }

}