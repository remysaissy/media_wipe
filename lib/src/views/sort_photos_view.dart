import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/sessions/create_or_recover_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/keep_asset_in_session_command.dart';
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

  AssetData get _assetData => _assets[_currentSelectionIndex];

  bool get _isFirst => _currentSelectionIndex == 0;

  bool get _isLast => (_currentSelectionIndex + 1 == _assets.length);

  Future<void> _initState() async {
    await CreateOrRecoverSessionCommand(context)
        .run(year: widget.year, month: widget.month);
  }

  @override
  void initState() {
    _currentSelectionIndex = 0;
    _assets = [];
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final yearMonthKey =
        Utils.stringifyYearMonth(year: widget.year, month: widget.month);
    Map<String, List<AssetData>> allAssets =
        context.select<AssetsModel, Map<String, List<AssetData>>>(
            (value) => value.assets);
    _assets = allAssets[yearMonthKey]!;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${Utils.monthNumberToMonthName(widget.month)} ${widget.year}'),
          actions: [
            Text('${_currentSelectionIndex + 1}/${_assets.length}'),
            IconButton(
              onPressed: _isFirst ? null : _onUndo,
              icon: const Icon(Icons.undo),
            ),
          ],
        ),
        body: SafeArea(child: _buildContent()));
  }

  Widget _buildContent() {
    final controls = MyViewerControls(
        onDropPressed: _onDropPressed, onKeepPressed: _onKeepPressed);
    return Utils.futureBuilder(
        future: _assetData.loadEntity(),
        onReady: (data) {
          final assetEntity = data as AssetEntity;
          return SingleChildScrollView(
              child: Column(children: [
            MyViewer(assetEntity: assetEntity),
            MyViewerMetadata(assetData: _assetData, assetEntity: assetEntity),
            controls,
          ]));
        });
  }

  Future<void> _onUndo() async {
    if (_isFirst) return;
    setState(() => _currentSelectionIndex--);
  }

  Future<void> _onKeepPressed() async {
    await KeepAssetInSessionCommand(context).run(assetData: _assetData);
    if (_isLast) {
      if (context.mounted) {
        context.pushNamed('sortPhotosSummary', pathParameters: {
          'year': widget.year.toString(),
          'month': widget.month.toString()
        });
      }
    } else {
      setState(() => _currentSelectionIndex++);
    }
  }

  Future<void> _onDropPressed() async {
    await DropAssetInSessionCommand(context).run(assetData: _assetData);
    if (_isLast) {
      if (context.mounted) {
        context.pushNamed('sortPhotosSummary', pathParameters: {
          'year': widget.year.toString(),
          'month': widget.month.toString()
        });
      }
    } else {
      setState(() => _currentSelectionIndex++);
    }
  }
}
