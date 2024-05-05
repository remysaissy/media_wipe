import 'package:flutter/material.dart';
import 'package:app/src/constants.dart';

class MyScaffold extends StatelessWidget {

  final PreferredSizeWidget? appBar;
  final Widget child;

  const MyScaffold({super.key, this.appBar, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(minimum: const EdgeInsets.all(Insets.medium), child: child));
  }
}
