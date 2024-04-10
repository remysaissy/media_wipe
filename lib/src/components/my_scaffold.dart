import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {

  final PreferredSizeWidget? appBar;
  final Widget child;

  const MyScaffold({super.key, this.appBar, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
        child: child)
      ),
    );
  }
}
