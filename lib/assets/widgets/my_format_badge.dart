import 'package:flutter/material.dart';

class MyFormatBadge extends StatelessWidget {
  final String title;

  const MyFormatBadge({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.black : Colors.white;
    final backgroundColor = isDarkMode ? Colors.white : Colors.black;
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: backgroundColor),
      padding: const EdgeInsets.all(16.0),
      child: Text(title, style: TextStyle(color: textColor)),
    );
  }
}
