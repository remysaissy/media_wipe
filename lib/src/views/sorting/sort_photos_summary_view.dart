import 'package:app/src/models/sessions_model.dart';
import 'package:app/src/views/sorting/widgets/delete_button.dart';
import 'package:app/src/views/sorting/widgets/refine_button.dart';
import 'package:app/src/views/sorting/widgets/summary_empty.dart';
import 'package:app/src/views/sorting/widgets/summary_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/src/models/assets_model.dart';

class SortPhotosSummaryView extends StatelessWidget {
  final int year;
  final int month;

  const SortPhotosSummaryView(
      {super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    final session =
        context.watch<SessionsModel>().getSession(year: year, month: month);
    if (session == null) {
      return SummaryEmpty(year: year, month: month);
    }
    final assets = context.watch<AssetsModel>().listAssets(
        forYear: year, forMonth: month, withAllowList: session.assetsToDrop);
    if (assets.isEmpty) {
      return SummaryEmpty(year: year, month: month);
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: null,
            title: Text('${assets.length} photos to delete'),
            actions: [
              RefineButton(year: year, month: month),
              DeleteButton(year: year, month: month)
            ],
          ),
          body: SafeArea(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: assets.length,
                  itemBuilder: (BuildContext context, int index) =>
                      SummaryItem(asset: assets[index]))));
    }
  }
}
