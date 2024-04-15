import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/home/home_controller.dart';
import 'package:watch_it/watch_it.dart';

class HomeView extends StatelessWidget with WatchItMixin {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = di<HomeController>();
    List<Widget> children = _buildYearMonths(context, controller);
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
                await di<HomeController>().refresh();
              },
              icon: const Icon(Icons.get_app),
            )
          ],
        ),
        child: ListView(children: children)
    );
  }

  final _monthNumberToMonthName = DateFormat('MMMM');

  List<Widget> _buildYearMonths(BuildContext context, HomeController controller) {
    final yearMonths = watchPropertyValue((HomeController x) => x.yearMonths);
    return yearMonths.map((e) => ListTile(
            onTap: () {
              print('Yolo');
            },
            title: Text('${e.year} ${_monthNumberToMonthName.format(DateTime(0, e.month))}'),
            trailing: const Icon(Icons.arrow_forward_ios))
    ).toList();
  }
}