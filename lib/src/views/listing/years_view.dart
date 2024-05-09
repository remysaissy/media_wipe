import 'package:app/src/models/assets_model.dart';
import 'package:app/src/views/listing/year.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/utils.dart';

class YearsView extends StatefulWidget {
  const YearsView({super.key});

  @override
  State<StatefulWidget> createState() => YearsViewState();
}

class YearsViewState extends State<YearsView> {
  late bool _isSortAsc;
  late List<int> _years;

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

  void _onToggleSort() {
    setState(() {
      _isSortAsc = !_isSortAsc;
    });
  }

  void _onSettings() {
    if (!mounted) return;
    context.push("/settings");
  }

  @override
  Widget build(BuildContext context) {
    _years = context.watch<AssetsModel>().listYears(isAsc: _isSortAsc);
    Widget child =
        _years.isEmpty ? Utils.buildLoading(context) : _buildContent(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('MediaWipe'),
          actions: [
            IconButton(
              onPressed: _onToggleSort,
              icon: Transform.flip(
                  flipY: _isSortAsc, child: const Icon(Icons.filter_list)),
            ),
            IconButton(
              onPressed: _onSettings,
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: SafeArea(child: child));
  }

  Widget _buildContent(BuildContext context) {
    return RefreshIndicator.adaptive(
        onRefresh: _pullRefresh,
        child: ListView.builder(
            itemCount: _years.length,
            itemBuilder: (BuildContext context, int index) {
              final year = _years[index];
              return Year(year: year.toString());
            }));
  }
}
