import 'package:app/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Month extends StatelessWidget {
  final String year;
  final String month;

  const Month({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            onTap: () async {
              if (!context.mounted) return;
              context.pushNamed('sortPhotos', pathParameters: {
                'year': year,
                'month': month,
                'mode': 'classic',
              });
            },
            title: Text(Utils.monthNumberToMonthName(int.parse(month))),
            trailing: Icon(Icons.adaptive.arrow_forward)));
  }
}
