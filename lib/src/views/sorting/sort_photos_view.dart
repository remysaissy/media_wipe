import 'package:app/src/models/asset.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:app/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:app/src/components/my_viewer.dart';
import 'package:app/src/components/my_viewer_controls.dart';
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
  late List<Asset> _assets;

  Asset get _assetData => _assets[_currentSelectionIndex];

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
    _assets = context
        .read<AssetsModel>()
        .listAssets(forYear: widget.year, forMonth: widget.month);
    context.watch<AssetsModel>();
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
    await KeepAssetInSessionCommand(context).run(id: _assetData.id);
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
    await DropAssetInSessionCommand(context).run(id: _assetData.id);
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
