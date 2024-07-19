import 'package:app/src/commands/sessions/finish_session_command.dart';
import 'package:app/src/views/routing_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SummaryEmpty extends StatelessWidget {
  final int year;
  final int month;

  const SummaryEmpty({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Center(
              child: Text(AppLocalizations.of(context)!.sortSummaryEmptyTitle)),
          Center(
              child: TextButton(
                  onPressed: () async {
                    await FinishSessionCommand(context)
                        .run(year: year, month: month, cancel: true);
                    if (!context.mounted) return;
                    context.goNamed(RoutingView.routeName);
                  },
                  child:
                      Text(AppLocalizations.of(context)!.sortSummaryEmptyCTA)))
        ])));
  }
}
