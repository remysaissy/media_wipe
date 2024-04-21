import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/assets/refresh_photos_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/create_or_recover_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/drop_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/keep_asset_in_session_command.dart';
import 'package:sortmaster_photos/src/commands/sessions/reset_session_command.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/components/my_universal_card.dart';
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

  Future<void> _onKeepPressed(AssetData assetData) async {
    await KeepAssetInSessionCommand(context).run(assetData: assetData).then((value) => {
      setState(() {
        _currentSelectionIndex++;
      })
    });
  }

  Future<void> _onDropPressed(AssetData assetData) async {
    await DropAssetInSessionCommand(context).run(assetData: assetData).then((value) => {
      setState(() {
        _currentSelectionIndex++;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    final yearMonthKey = Utils.stringifyYearMonth(year: widget.year, month: widget.month);
    Map<String, List<AssetData>> allAssets = context.select<AssetsModel, Map<String, List<AssetData>>>((value) => value.assets);
    List<AssetData> assets = allAssets[yearMonthKey]!;
    Widget card = assets.isEmpty ? Utils.buildLoading(context) : MyUniversalCard(assetData: assets[_currentSelectionIndex]);
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
        child: Stack(
            alignment: Alignment.center,
            children: [
              card,
              Align(alignment: Alignment.bottomCenter,
                  child: Padding(padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FloatingActionButton(onPressed: () async {
                            await _onKeepPressed(assets[_currentSelectionIndex]).then((value) => {
                              if (_currentSelectionIndex+1 >= assets.length) {
                                if (context.mounted) {
                                  context.go('/assets/summary')
                                }
                              }
                            });
                          },
                              heroTag: null,
                              child: const Icon(Icons.check)),
                          FloatingActionButton(onPressed: () async {
                            await _onDropPressed(assets[_currentSelectionIndex]).then((value) => {
                              if (_currentSelectionIndex+1 >= assets.length) {
                                if (context.mounted) {
                                  context.go('/assets/summary')
                                }
                              }
                            });
                          },
                              heroTag: null,
                              child: const Icon(Icons.close)),
                        ]),
                  )
              )]
        )));
  }
}