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

  Future<void> _initState() async {
    await RefreshPhotosCommand(context).run();
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
    Map<String, List<AssetData>> assets = context.select<AssetsModel, Map<String, List<AssetData>>>((value) => value.assets);
    Widget child = assets.isEmpty ? Utils.buildLoading(context) : _buildYearMonths(context, assets);
    return MyScaffold(
            appBar: AppBar(
              title: const Text('Sort Master: Photos'),
              actions: [
                IconButton(
                  onPressed: () {
                    if (!context.mounted) return;
                    context.push("/settings");
                  },
                  icon: const Icon(Icons.settings),
                ),
                IconButton(
                  onPressed: () async {
                    await RefreshPhotosCommand(context).run();
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            child: child
        );
  }

  Widget _buildYearMonths(BuildContext context, Map<String, List<AssetData>> assets) {
    final yearMonths = assets.entries.map((entry) => entry.value.first.creationDate).toList();
    final children = yearMonths.map((e) => ListTile(
            onTap: () async {
              if (!context.mounted) return;
              context.pushNamed('sortPhotos', pathParameters: {'year': e.year.toString(), 'month': e.month.toString()});
            },
            title: Text('${e.year} ${Utils.monthNumberToMonthName(e.month)}'),
            trailing: const Icon(Icons.arrow_forward_ios))
    ).toList();
    return ListView(children: children);
  }
}