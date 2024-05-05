import 'package:app/src/views/listing/year.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/models/assets_model.dart';
import 'package:app/src/utils.dart';

class YearsView extends StatefulWidget {
  const YearsView({super.key});

  @override
  State<StatefulWidget> createState() => YearsViewState();
}

class YearsViewState extends State<YearsView> {
  late bool _isSortAsc;

  Future<void> _initState() async {
    await RefreshPhotosCommand(context).run();
  }

  @override
  void initState() {
    _isSortAsc = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initState());
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await RefreshPhotosCommand(context).run();
  }

  @override
  Widget build(BuildContext context) {
    final assets =
        context.select<AssetsModel, List<AssetsData>>((value) => value.assets);
    context.watch<AssetsModel>();
    Widget child = assets.isEmpty
        ? Utils.buildLoading(context)
        : _buildContent(context, assets);
    return Scaffold(
        appBar: AppBar(
          title: const Text('MediaWipe'),
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

  Widget _buildContent(BuildContext context, List<AssetsData> assets) {
    // Keep years order consistent.
    var yearKeys =
        assets.map((e) => e.year).toSet().toList();
    yearKeys.sort((a, b) {
      if (_isSortAsc) {
        return a.compareTo(b);
      } else {
        return b.compareTo(a);
      }
    });
    return RefreshIndicator.adaptive(
        onRefresh: _pullRefresh,
        child: ListView.builder(
            itemCount: yearKeys.length,
            itemBuilder: (BuildContext context, int index) {
              final year = yearKeys[index];
              return Year(year: year.toString());
            }));
  }
}
