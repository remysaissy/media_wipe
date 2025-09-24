import 'dart:developer';

import 'package:app/assets/commands/sessions/commit_refine_in_session_command.dart';
import 'package:app/assets/commands/sessions/start_session_command.dart';
import 'package:app/assets/commands/sessions/undo_last_operation_in_session_command.dart';
import 'package:app/assets/models/asset.dart';
import 'package:app/assets/models/asset_model.dart';
import 'package:app/assets/models/session.dart';
import 'package:app/assets/models/sessions_model.dart';
import 'package:app/assets/router.dart';
import 'package:app/assets/widgets/media_viewer.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/assets/commands/sessions/drop_asset_in_session_command.dart';
import 'package:app/assets/commands/sessions/keep_asset_in_session_command.dart';
import 'package:app/shared/utils.dart';

class SortSwipe extends StatefulWidget {
  final int year;
  final int month;
  final String mode;

  const SortSwipe({
    super.key,
    required this.year,
    required this.month,
    String? mode,
  }) : mode = mode ?? 'classic';

  @override
  State<StatefulWidget> createState() => _SortSwipeState();
}

class _SortSwipeState extends State<SortSwipe> {
  late List<Asset> _assets;
  late Session? _session;
  late AppinioSwiperController _controller;

  Asset? get _currentAsset => _session?.assetInReview.target;

  bool get _isFirst => _session?.assetInReview.target == _assets.firstOrNull;

  bool get _isLast => _session?.assetInReview.target == _assets.lastOrNull;

  int get _current =>
      _currentAsset != null ? _assets.indexOf(_currentAsset!) : 0;

  Future<void> _initState() async {
    await StartSessionCommand(context).run(
      year: widget.year,
      month: widget.month,
      isWhiteListMode: (widget.mode == 'refine'),
    );
  }

  @override
  void initState() {
    _assets = [];
    _session = null;
    _controller = AppinioSwiperController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _session = context.watch<SessionsModel>().getSession(
      year: widget.year,
      month: widget.month,
    );
    if (_session == null) {
      return Utils.buildLoading(context);
    }
    _assets = context.watch<AssetsModel>().listAssets(
      forYear: widget.year,
      forMonth: widget.month,
      withAllowList: (widget.mode == 'refine') ? _session?.assetsToDrop : null,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${Utils.monthNumberToMonthName(widget.month)} ${widget.year}',
        ),
        actions: [
          Text('${_current + 1}/${_assets.length}'),
          IconButton(
            onPressed: _isFirst ? null : _onUndo,
            icon: const Icon(Icons.undo_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: _currentAsset != null
            ? _buildContent()
            : Utils.buildLoading(context),
      ),
    );
  }

  Future<void> _onSwipeEnd(
    int previousIndex,
    int targetIndex,
    SwiperActivity activity,
  ) async {
    switch (activity) {
      case Swipe():
        await _onKeepPressed();
        log('The card was swiped to the : ${activity.direction}');
        log('previous index: $previousIndex, target index: $targetIndex');
        break;
      case Unswipe():
        await _onDropPressed();
        log('A ${activity.direction.name} swipe was undone.');
        log('previous index: $previousIndex, target index: $targetIndex');
        break;
      case CancelSwipe():
        log('A swipe was cancelled');
        break;
      case DrivenActivity():
        log('Driven Activity');
        break;
    }
  }

  Widget _buildContent() {
    return Stack(
      alignment: AlignmentGeometry.bottomCenter,
      children: [
        AppinioSwiper(
          swipeOptions: const SwipeOptions.only(left: true, right: true),
          loop: false,
          onEnd: _onEndPressed,
          onSwipeEnd: _onSwipeEnd,
          initialIndex: _current,
          controller: _controller,
          cardCount: _assets.length,
          cardBuilder: (context, index) {
            final asset = _assets[index];
            return Align(
              alignment: AlignmentGeometry.center,
              child: MediaViewer(asset: asset),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: _controller.swipeLeft,
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(Icons.close, size: 24),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            ),
            MaterialButton(
              onPressed: _controller.swipeRight,
              color: Colors.green,
              textColor: Colors.white,
              child: Icon(Icons.check, size: 24),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onUndo() async {
    await UndoLastOperationInSessionCommand(
      context,
    ).run(session: _session!, isWhiteListMode: (widget.mode == 'refine'));
    await _controller.unswipe();
  }

  Future<void> _onEndPressed() async {
    if (widget.mode == 'refine') {
      await CommitRefineInSessionCommand(context).run(session: _session!);
    }
    context.goNamed(
      AssetsRouter.sortSummary,
      pathParameters: {
        'year': widget.year.toString(),
        'month': widget.month.toString(),
      },
    );
  }

  Future<void> _onKeepPressed() async {
    bool wasLast = _isLast;
    if (!mounted) return;
    await KeepAssetInSessionCommand(
      context,
    ).run(session: _session!, isWhiteListMode: (widget.mode == 'refine'));
    if (wasLast) {
      if (widget.mode == 'refine') {
        await CommitRefineInSessionCommand(context).run(session: _session!);
      }
      context.goNamed(
        AssetsRouter.sortSummary,
        pathParameters: {
          'year': widget.year.toString(),
          'month': widget.month.toString(),
        },
      );
    }
  }

  Future<void> _onDropPressed() async {
    bool wasLast = _isLast;
    if (!mounted) return;
    await DropAssetInSessionCommand(
      context,
    ).run(session: _session!, isWhiteListMode: (widget.mode == 'refine'));
    if (wasLast) {
      if (widget.mode == 'refine') {
        await CommitRefineInSessionCommand(context).run(session: _session!);
      }
      context.goNamed(
        AssetsRouter.sortSummary,
        pathParameters: {
          'year': widget.year.toString(),
          'month': widget.month.toString(),
        },
      );
    }
  }
}
