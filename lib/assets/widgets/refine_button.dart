import 'package:app/assets/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

class RefineButton extends StatelessWidget {
  final int year;
  final int month;

  const RefineButton({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (!context.mounted) return;
        context.goNamed(
          AssetsRouter.sortSwipe,
          pathParameters: {'year': year.toString(), 'month': month.toString()},
          queryParameters: {'mode': 'refine'},
        );
      },
      child: Text(AppLocalizations.of(context)!.sortSummaryRefineCTA),
    );
  }
}
