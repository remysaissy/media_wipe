import 'package:app/shared/utils.dart';
import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String title;
  final String targetURL;

  const Link({super.key, required this.title, required this.targetURL});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () async {
          if (!context.mounted) return;
          await Utils.openURL(context, targetURL);
        },
        leading: const Icon(Icons.open_in_new),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios));
  }
}
