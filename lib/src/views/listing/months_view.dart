import 'package:app/src/views/listing/month.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/utils.dart';

class MonthsView extends StatefulWidget {
  final int year;

  const MonthsView({super.key, required this.year});

  @override
  State<StatefulWidget> createState() => MonthsViewState();
}

class MonthsViewState extends State<MonthsView> {
  Future<void> _pullRefresh() async {
    await RefreshPhotosCommand(context).run();
  }

  @override
  Widget build(BuildContext context) {
    final assets =
        context.select<AssetsModel, List<AssetsData>>((value) => value.assets);
    Widget child = assets.isEmpty
        ? Utils.buildLoading(context)
        : _buildContent(context, assets);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.year.toString()),
        ),
        body: SafeArea(child: child));
  }

  Widget _buildContent(BuildContext context, List<AssetsData> assets) {
    // Keep months order consistent.
    var monthsKeys = assets
        .where((e) => e.year == widget.year)
        .map((e) => e.month)
        .toSet()
        .toList();
    monthsKeys.sort((a, b) {
      return a.compareTo(b);
    });
    return RefreshIndicator.adaptive(
        onRefresh: _pullRefresh,
        child: ListView.builder(
            itemCount: monthsKeys.length,
            itemBuilder: (BuildContext context, int index) {
              final month = monthsKeys[index];
              return Month(
                  year: widget.year.toString(), month: month.toString());
            }));
  }
}
