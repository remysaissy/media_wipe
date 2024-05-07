import 'package:app/src/models/assets_model.dart';
import 'package:app/src/views/listing/month.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
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
    final months =
        context.read<AssetsModel>().listAssetsMonths(forYear: widget.year, isAsc: true);
    context.watch<AssetsModel>();
    Widget child = months.isEmpty
        ? Utils.buildLoading(context)
        : _buildContent(context, months);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.year.toString()),
        ),
        body: SafeArea(child: child));
  }

  Widget _buildContent(BuildContext context, List<int> months) {
    return RefreshIndicator.adaptive(
        onRefresh: _pullRefresh,
        child: ListView.builder(
            itemCount: months.length,
            itemBuilder: (BuildContext context, int index) {
              final month = months[index];
              return Month(
                  year: widget.year.toString(), month: month.toString());
            }));
  }
}
