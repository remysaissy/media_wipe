import 'package:app/src/commands/sessions/start_session_command.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/sessions_model.dart';
import 'package:app/src/views/viewer/my_viewer.dart';
import 'package:app/src/views/sorting/sort_photos_controls.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:app/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:app/src/utils.dart';

class SortPhotosView extends StatefulWidget {
  final int year;
  final int month;
  final String mode;

  const SortPhotosView(
      {super.key, required this.year, required this.month, required this.mode});

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
    await StartSessionCommand(context)
        .run(year: widget.year, month: widget.month);
  }

  @override
  void initState() {
    _assets = [];
    _currentSelectionIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final session = context
        .watch<SessionsModel>()
        .getSession(year: widget.year, month: widget.month);
    final whiteList = (widget.mode == 'refine') ? session?.assetsToDrop : null;
    _assets = context.watch<AssetsModel>().listAssets(
        forYear: widget.year, forMonth: widget.month, withAllowList: whiteList);
    _currentSelectionIndex = (session?.assetIdInReview != null)
        ? _assets.indexWhere((e) => e.id == session?.assetIdInReview)
        : 0;
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
        body: SafeArea(
            child: _assets.isNotEmpty
                ? _buildContent()
                : Utils.buildLoading(context)));
  }

  Widget _buildContent() {
    return Utils.futureBuilder(
        future: _assetData.loadEntity(),
        onReady: (data) {
          final assetEntity = data as AssetEntity;
          return SingleChildScrollView(
              child: Column(children: [
            MyViewer(assetEntity: assetEntity),
            SortPhotosControls(
                assetData: _assetData,
                assetEntity: assetEntity,
                onDropPressed: _onDropPressed,
                onKeepPressed: _onKeepPressed)
          ]));
        });
  }

  Future<void> _onUndo() async {
    await KeepAssetInSessionCommand(context).run(
        year: widget.year,
        month: widget.month,
        assetId: _assetData.id,
        nextAssetId: _isFirst ? _assetData.id : _assets[_currentSelectionIndex - 1].id);
    setState(() => _isFirst ? _currentSelectionIndex = 0 : _currentSelectionIndex--);
  }

  Future<void> _onKeepPressed() async {
    if (!mounted) return;
    await KeepAssetInSessionCommand(context).run(
        year: widget.year,
        month: widget.month,
        assetId: _assetData.id,
        nextAssetId: _isLast ? null : _assets[_currentSelectionIndex + 1].id);
    if (_isLast) {
      context.goNamed('sortPhotosSummary', pathParameters: {
        'year': widget.year.toString(),
        'month': widget.month.toString()
      });
    } else {
      setState(() => _currentSelectionIndex++);
    }
  }

  Future<void> _onDropPressed() async {
    if (!mounted) return;
    await DropAssetInSessionCommand(context).run(
        year: widget.year,
        month: widget.month,
        assetId: _assetData.id,
        nextAssetId: _isLast ? null : _assets[_currentSelectionIndex + 1].id);
    if (_isLast) {
      context.goNamed('sortPhotosSummary', pathParameters: {
        'year': widget.year.toString(),
        'month': widget.month.toString()
      });
    } else {
      setState(() => _currentSelectionIndex++);
    }
  }
}
