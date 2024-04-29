import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/assets/refresh_photos_command.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class ListYearsView extends StatefulWidget {
  const ListYearsView({super.key});

  @override
  State<StatefulWidget> createState() => ListYearsViewState();
}

class ListYearsViewState extends State<ListYearsView> {
  late bool _isSortAsc;

  @override
  void initState() {
    _isSortAsc = false;
    super.initState();
  }

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
          title: const Text('Sort Master: Photos'),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  _isSortAsc = !_isSortAsc;
                });
              },
              icon: Transform.flip(
                  flipY: _isSortAsc, child: const Icon(Icons.filter_list)),
            ),
            IconButton(
              onPressed: () {
                if (!context.mounted) return;
                context.push("/settings");
              },
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: SafeArea(child: child));
  }

  Widget _buildContent(
      BuildContext context, Map<String, Map<String, List<AssetData>>> assets) {
    // Keep years order consistent.
    var yearKeys = assets.keys.toList();
    yearKeys.sort((a, b) {
      final aInt = int.parse(a);
      final bInt = int.parse(b);
      if (_isSortAsc) {
        return aInt.compareTo(bInt);
      } else {
        return bInt.compareTo(aInt);
      }
    });
    return RefreshIndicator.adaptive(
        onRefresh: _pullRefresh,
        child: ListView.builder(
            itemCount: yearKeys.length,
            itemBuilder: (BuildContext context, int index) {
              final year = yearKeys[index];
              return Card(
                  child: ListTile(
                      onTap: () async {
                        if (!context.mounted) return;
                        context.pushNamed('listMonths',
                            pathParameters: {'year': year});
                      },
                      title: Text(year),
                      trailing: Icon(Icons.adaptive.arrow_forward)));
            }));
  }
}
