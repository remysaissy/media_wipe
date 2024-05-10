import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RefineButton extends StatelessWidget {
  final int year;
  final int month;

  const RefineButton({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (!context.mounted) return;
          context.goNamed('sortPhotos', pathParameters: {
            'year': year.toString(),
            'month': month.toString(),
            'mode': 'refine',
          });
        },
        child: const Text('Refine'));
  }
}
