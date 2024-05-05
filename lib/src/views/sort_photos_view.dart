import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:app/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:app/src/components/my_viewer.dart';
import 'package:app/src/components/my_viewer_controls.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/utils.dart';

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
    _currentSelectionIndex = 0;
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
    List<AssetsData> allAssets =
        context.select<AssetsModel, List<AssetsData>>((value) => value.assets);
    _assets = allAssets
        .where((e) => e.year == widget.year && e.month == widget.month)
        .first
        .assets;
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
    return Utils.futureBuilder(
        future: _assetData.loadEntity(),
        onReady: (data) {
          final assetEntity = data as AssetEntity;
          return SingleChildScrollView(
              child: Column(children: [
            MyViewer(assetEntity: assetEntity),
            MyViewerControls(
                assetData: _assetData,
                assetEntity: assetEntity,
                onDropPressed: _onDropPressed,
                onKeepPressed: _onKeepPressed)
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
        context.goNamed('sortPhotosSummary', pathParameters: {
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
        context.goNamed('sortPhotosSummary', pathParameters: {
          'year': widget.year.toString(),
          'month': widget.month.toString()
        });
      }
    } else {
      setState(() => _currentSelectionIndex++);
    }
  }
}
