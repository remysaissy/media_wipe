import 'package:app/src/models/assets_model.dart';
import 'package:app/src/views/listing/month.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/utils.dart';

class MonthsView extends StatelessWidget {
  final int year;

  const MonthsView({super.key, required this.year});

  Future<void> _pullRefresh(BuildContext context) async {
    if (!context.mounted) return;
    await RefreshPhotosCommand(context).run();
  }

  @override
  Widget build(BuildContext context) {
    final months = context
        .watch<AssetsModel>()
        .listAssetsMonths(forYear: year, isAsc: true);
    Widget child = months.isEmpty
        ? Utils.buildLoading(context)
        : _buildContent(context, months);
    return Scaffold(
        appBar: AppBar(
          title: Text(year.toString()),
        ),
        body: SafeArea(child: child));
  }

  Widget _buildContent(BuildContext context, List<int> months) {
    return RefreshIndicator.adaptive(
        onRefresh: () async {
          await _pullRefresh(context);
        },
        child: ListView.builder(
            itemCount: months.length,
            itemBuilder: (BuildContext context, int index) {
              final month = months[index];
              return Month(year: year.toString(), month: month.toString());
            }));
  }
}
