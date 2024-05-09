import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Year extends StatelessWidget {
  final String year;

  const Year({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            onTap: () async {
              if (!context.mounted) return;
              context.pushNamed('listMonths', pathParameters: {'year': year});
            },
            title: Text(year),
            trailing: Icon(Icons.adaptive.arrow_forward)));
  }
}
