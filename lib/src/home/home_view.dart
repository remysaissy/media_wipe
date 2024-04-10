import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/home/home_controller.dart';
import 'package:sortmaster_photos/src/ioc.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController _controller = getIt<HomeController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child)
        {
          return MyScaffold(
              appBar: AppBar(
                title: const Text('Sort Master: Photos'),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.push("/settings");
                    },
                    icon: const Icon(Icons.settings),
                  )
                ],
              ),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item ${index + 1}'),
                  );
                },
              )
          );
        });
  }
}