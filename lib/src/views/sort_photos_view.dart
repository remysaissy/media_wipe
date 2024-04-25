import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/sessions/create_or_recover_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/reset_session_command.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/components/my_viewer.dart';
import 'package:sortmaster_photos/src/components/my_viewer_controls.dart';
import 'package:sortmaster_photos/src/components/my_viewer_metadata.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class SortPhotosView extends StatefulWidget {
  final int year;
  final int month;

  const SortPhotosView({super.key, required this.year, required this.month});

  @override
  State<StatefulWidget> createState() => _SortPhotosViewState();
}

class _SortPhotosViewState extends State<SortPhotosView> {
  late int _currentSelectionIndex;
  late List<AssetData> _assets;

  AssetData get assetData => _assets[_currentSelectionIndex];

  Future<void> _initState() async {
    await CreateOrRecoverSessionCommand(context)
        .run(year: widget.year, month: widget.month);
  }

  @override
  void initState() {
    _currentSelectionIndex = 0;
    _assets = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });
    super.initState();
  }

  Future<void> _onRestart() async {
    await ResetSessionCommand(context)
        .run(year: widget.year, month: widget.month)
        .then((value) => {
              setState(() {
                _currentSelectionIndex = 0;
              })
            });
  }

  Future<void> _onKeepPressed() async {
    bool isNotLastIndex = (_currentSelectionIndex + 1 < _assets.length);
    await KeepAssetInSessionCommand(context)
        .run(assetData: assetData)
        .then((value) => {
              if (isNotLastIndex)
                {
                  setState(() {
                    _currentSelectionIndex++;
                  })
                }
            });
    if (!isNotLastIndex) {
      Utils.logger.i('Move on');
      if (context.mounted) {
        context.pushNamed('sortPhotosSummary', pathParameters: {
          'year': widget.year.toString(),
          'month': widget.month.toString()
        });
      }
    }
  }

  Future<void> _onDropPressed() async {
    bool isNotLastIndex = (_currentSelectionIndex + 1 < _assets.length);
    await DropAssetInSessionCommand(context)
        .run(assetData: assetData)
        .then((value) => {
              if (isNotLastIndex)
                {
                  setState(() {
                    _currentSelectionIndex++;
                  })
                }
            });
    if (!isNotLastIndex) {
      Utils.logger.i('Move on');
      if (context.mounted) {
        context.pushNamed('sortPhotosSummary', pathParameters: {
          'year': widget.year.toString(),
          'month': widget.month.toString()
        });
      }
    }
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
    final yearMonthKey =
        Utils.stringifyYearMonth(year: widget.year, month: widget.month);
    Map<String, List<AssetData>> allAssets =
        context.select<AssetsModel, Map<String, List<AssetData>>>(
            (value) => value.assets);
    _assets = allAssets[yearMonthKey]!;
    return MyScaffold(
        appBar: AppBar(
          title: Text(
              '${Utils.monthNumberToMonthName(widget.month)} ${widget.year}'),
          actions: [
            Text('${_currentSelectionIndex + 1}/${_assets.length}'),
            IconButton(
              onPressed: _onRestart,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder(
        future: assetData.loadEntity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              Utils.logger.e('Error ${snapshot.error} occurred');
              return Utils.buildLoading(context);
            } else if (snapshot.hasData) {
              final assetEntity = snapshot.data as AssetEntity;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  MyViewer(assetData: assetData, assetEntity: assetEntity),
                  const Spacer(),
                  MyViewerMetadata(
                      assetData: assetData, assetEntity: assetEntity),
                  MyViewerControls(
                      assetData: assetData,
                      assetEntity: assetEntity,
                      onDropPressed: _onDropPressed,
                      onKeepPressed: _onKeepPressed),
                ],
              );
            }
          }
          return Utils.buildLoading(context);
        });
  }
}
