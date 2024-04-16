import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/assets/assets_controller.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
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

  Future<void> _initState() async {
    if (widget.assetsViewMode == AssetsViewMode.YearMonth) {
      await di<AssetsController>().loadWithYearMonth(widget.year!, widget.month!);
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
    // final yearMonths = watchPropertyValue((HomeController x) => x.yearMonths);
    return MyScaffold(
        appBar: AppBar(),
        child: Text('Mode: ${widget.assetsViewMode} ${widget.year} ${widget.month}')
    );
  }
}