import 'package:app/src/commands/sessions/commit_refine_in_session_command.dart';
import 'package:app/src/commands/sessions/start_session_command.dart';
import 'package:app/src/commands/sessions/undo_last_operation_in_session_command.dart';
import 'package:app/src/models/asset.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/models/session.dart';
import 'package:app/src/models/sessions_model.dart';
import 'package:app/src/views/sorting/sort_photos_summary_view.dart';
import 'package:app/src/views/viewer/my_viewer.dart';
import 'package:app/src/views/sorting/widgets/sort_photos_controls.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:app/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:app/src/utils.dart';

class SortPhotosView extends StatefulWidget {
  static String routeName = 'sortPhotos';
  final int year;
  final int month;
  final String mode;

  const SortPhotosView(
      {super.key, required this.year, required this.month, required this.mode});

  @override
  State<StatefulWidget> createState() => _SortPhotosViewState();
}

class _SortPhotosViewState extends State<SortPhotosView> {
  late List<Asset> _assets;
  late Session? _session;

  Asset? get _currentAsset => _session?.assetInReview.target;

  bool get _isFirst => _session?.assetInReview.target == _assets.firstOrNull;

  bool get _isLast => _session?.assetInReview.target == _assets.lastOrNull;

  Future<void> _initState() async {
    await StartSessionCommand(context).run(
        year: widget.year,
        month: widget.month,
        isWhiteListMode: (widget.mode == 'refine'));
  }

  @override
  void initState() {
    _assets = [];
    _session = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _session = context
        .watch<SessionsModel>()
        .getSession(year: widget.year, month: widget.month);
    if (_session == null) {
      return Utils.buildLoading(context);
    }
    _assets = context.watch<AssetsModel>().listAssets(
        forYear: widget.year,
        forMonth: widget.month,
        withAllowList:
            (widget.mode == 'refine') ? _session?.assetsToDrop : null);
    final currentSelectionIndex =
        _currentAsset != null ? _assets.indexOf(_currentAsset!) : 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${Utils.monthNumberToMonthName(widget.month)} ${widget.year}'),
          actions: [
            Text('${currentSelectionIndex + 1}/${_assets.length}'),
            IconButton(
              onPressed: _isFirst ? null : _onUndo,
              icon: const Icon(Icons.undo_outlined),
            ),
          ],
        ),
        body: SafeArea(
            child: _currentAsset != null
                ? _buildContent()
                : Utils.buildLoading(context)));
  }

  Widget _buildContent() {
    return Utils.futureBuilder(
        future: AssetData.fromAsset(asset: _currentAsset!),
        onReady: (data) {
          final assetData = data as AssetData;
          return SingleChildScrollView(
              child: Column(children: [
            MyViewer(asset: _currentAsset!, assetData: assetData),
            SortPhotosControls(
                asset: _currentAsset!,
                assetData: assetData,
                onDropPressed: _onDropPressed,
                onKeepPressed: _onKeepPressed)
          ]));
        });
  }

  Future<void> _onUndo() async {
    await UndoLastOperationInSessionCommand(context)
        .run(session: _session!, isWhiteListMode: (widget.mode == 'refine'));
  }

  Future<void> _onKeepPressed() async {
    bool wasLast = _isLast;
    if (!mounted) return;
    await KeepAssetInSessionCommand(context)
        .run(session: _session!, isWhiteListMode: (widget.mode == 'refine'));
    if (wasLast) {
      if (widget.mode == 'refine') {
        await CommitRefineInSessionCommand(context).run(session: _session!);
      }
      context.goNamed(SortPhotosSummaryView.routeName, pathParameters: {
        'year': widget.year.toString(),
        'month': widget.month.toString()
      });
    }
  }

  Future<void> _onDropPressed() async {
    bool wasLast = _isLast;
    if (!mounted) return;
    await DropAssetInSessionCommand(context)
        .run(session: _session!, isWhiteListMode: (widget.mode == 'refine'));
    if (wasLast) {
      if (widget.mode == 'refine') {
        await CommitRefineInSessionCommand(context).run(session: _session!);
      }
      context.goNamed(SortPhotosSummaryView.routeName, pathParameters: {
        'year': widget.year.toString(),
        'month': widget.month.toString()
      });
    }
  }
}
