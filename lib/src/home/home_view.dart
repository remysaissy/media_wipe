import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/home/home_controller.dart';
import 'package:watch_it/watch_it.dart';

class HomeView extends StatefulWidget with WatchItStatefulWidgetMixin {

  HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {

  final _homeController = di<HomeController>();
  final _monthNumberToMonthName = DateFormat('MMMM');

  Future<void> _initState() async {
    await _homeController.refresh();
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
    List<Widget> children = _buildYearMonths(context);
    return MyScaffold(
        appBar: AppBar(
          title: const Text('Sort Master: Photos'),
          actions: [
            IconButton(
              onPressed: () {
                context.push("/settings");
              },
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () async {
                await _homeController.refresh();
              },
              icon: const Icon(Icons.get_app),
            )
          ],
        ),
        child: ListView(children: children)
    );
  }

  List<Widget> _buildYearMonths(BuildContext context) {
    final yearMonths = watchPropertyValue((HomeController x) => x.yearMonths);
    return yearMonths.map((e) => ListTile(
            onTap: () async {
              if (!context.mounted) return;
              context.pushNamed('assetsByYearMonth', pathParameters: {'year': e.year.toString(), 'month': e.month.toString()});
            },
            title: Text('${e.year} ${_monthNumberToMonthName.format(DateTime(0, e.month))}'),
            trailing: const Icon(Icons.arrow_forward_ios))
    ).toList();
  }
}