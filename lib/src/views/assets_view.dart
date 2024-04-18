import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sortmaster_photos/src/components/my_image_card.dart';
import 'package:sortmaster_photos/src/components/my_video_card.dart';
import 'package:sortmaster_photos/src/controllers/assets_controller.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';
import 'package:watch_it/watch_it.dart';

enum AssetsViewMode {
  YearMonth,
}

class AssetsView extends StatefulWidget with WatchItStatefulWidgetMixin {

  final AssetsViewMode assetsViewMode;
  final int? year;
  final int? month;

  const AssetsView({super.key, required this.assetsViewMode, this.year, this.month});

  @override
  State<StatefulWidget> createState() => _AssetsViewState();
}

class _AssetsViewState extends State<AssetsView> {

  final AssetsController _assetsController = di<AssetsController>();

  Future<void> _initState() async {
    if (widget.assetsViewMode == AssetsViewMode.YearMonth) {
      await _assetsController.loadWithYearMonth(year: widget.year!, month: widget.month!);
      await _assetsController.startSession(year: widget.year!, month: widget.month!);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSelectionAsset = watchPropertyValue((AssetsController x) => x.currentSelectionAsset);
    final currentSelectionIndex = watchPropertyValue((AssetsController x) => x.currentSelectionIndex);
    final totalAssetsForMonth = watchPropertyValue((AssetsController x) => x.totalAssetsForMonth);
    final isCurrentMonthFinished = watchPropertyValue((AssetsController x) => x.isCurrentMonthFinished);
    Widget card;
    if (isCurrentMonthFinished) {
      card = _buildSessionSummary(context);
    } else {
      if (currentSelectionAsset != null) {
        if (currentSelectionAsset.assetType == AssetType.Video) {
          card = MyVideoCard(asset: currentSelectionAsset);
        } else {
          card = MyImageCard(asset: currentSelectionAsset);
        }
      } else {
        card = _buildLoading(context);
      }
    }
    return MyScaffold(
        appBar: AppBar(
          title: Text('${Utils.monthNumberToMonthName(widget.month!)} ${widget.year}'),
          actions: [
            Text('${currentSelectionIndex+1}/${totalAssetsForMonth}'),
            IconButton(
              onPressed: _assetsController.onRestart,
              icon: const Icon(Symbols.refresh),
            ),
          ],
        ),
        child: Stack(
            alignment: Alignment.center,
            children: [
              card,
              Align(alignment: Alignment.bottomCenter,
              child: Padding(padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(onPressed: () async {
                          await _assetsController.onKeepPressed(onEnd: () {
                            if (!context.mounted) return;
                            context.pop();
                          });
                        },
                            heroTag: null,
                            child: const Icon(Symbols.check)),
                        // FloatingActionButton(onPressed: () async {
                        //   await _assetsController.onInfoPressed();
                        //   if (!context.mounted) return;
                        // },
                        //     heroTag: null,
                        //     child: const Icon(Symbols.info)),
                        FloatingActionButton(onPressed: () async {
                          await _assetsController.onDropPressed(onEnd: () {
                            if (!context.mounted) return;
                            context.pop();
                          });
                        },
                            heroTag: null,
                            child: const Icon(Symbols.close)),
                      ]),
              )
              )]
        ));
  }

  Widget _buildLoading(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildSessionSummary(BuildContext context) {
    return Text('Session finished');
  }
}