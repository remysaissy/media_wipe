import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/utils.dart';

class ListMonthsView extends StatefulWidget {
  final int year;

  const ListMonthsView({super.key, required this.year});

  @override
  State<StatefulWidget> createState() => ListMonthsViewState();
}

class ListMonthsViewState extends State<ListMonthsView> {
  Future<void> _pullRefresh() async {
    await RefreshPhotosCommand(context).run();
  }

  @override
  Widget build(BuildContext context) {
    final assets =
        context.select<AssetsModel, Map<String, Map<String, List<AssetData>>>>(
            (value) => value.assetsPerYearMonth);
    Widget child = assets.isEmpty
        ? Utils.buildLoading(context)
        : _buildContent(context, assets);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.year.toString()),
        ),
        body: SafeArea(child: child));
  }

  Widget _buildContent(
      BuildContext context, Map<String, Map<String, List<AssetData>>> assets) {
    // Keep months order consistent.
    var monthsAssets = assets[widget.year.toString()];
    var monthsKeys = monthsAssets?.keys.toList();
    monthsKeys?.sort((a, b) {
      final aInt = int.parse(a);
      final bInt = int.parse(b);
      return aInt.compareTo(bInt);
    });
    return RefreshIndicator.adaptive(
        onRefresh: _pullRefresh,
        child: ListView.builder(
            itemCount: monthsKeys?.length,
            itemBuilder: (BuildContext context, int index) {
              final month = monthsKeys?[index];
              return Card(
                  child: ListTile(
                      onTap: () async {
                        if (!context.mounted) return;
                        context.pushNamed('sortPhotos', pathParameters: {
                          'year': widget.year.toString(),
                          'month': month
                        });
                      },
                      title:
                          Text(Utils.monthNumberToMonthName(int.parse(month!))),
                      trailing: Icon(Icons.adaptive.arrow_forward)));
            }));
  }
}
