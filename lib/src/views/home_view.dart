import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sortmaster_photos/src/commands/assets/refresh_photos_command.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/models/assets_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late bool _isSortAsc;

  Future<void> _initState() async {
    await RefreshPhotosCommand(context).run();
  }

  @override
  void initState() {
    _isSortAsc = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initState();
    });
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
    return MyScaffold(
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
        child: child);
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
    return RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView.builder(
        itemCount: yearKeys.length,
        itemBuilder: (BuildContext context, int index) {
          final year = yearKeys[index];
          // Keep months order consistent.
          var months = assets[year]!.keys.toList();
          months.sort((a, b) {
            final aInt = int.parse(a);
            final bInt = int.parse(b);
            return aInt.compareTo(bInt);
          });
          return Card(
            child: ExpansionTile(
              title: Text(year),
              children: months.map((month) {
                return ListTile(
                    onTap: () async {
                      if (!context.mounted) return;
                      context.pushNamed('sortPhotos',
                          pathParameters: {'year': year, 'month': month});
                    },
                    title: Text(Utils.monthNumberToMonthName(int.parse(month))),
                    trailing: const Icon(Icons.keyboard_arrow_right));
              }).toList(),
            ),
          );
        }));
  }
}
