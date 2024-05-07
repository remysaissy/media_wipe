import 'package:app/src/commands/sessions/cancel_session_command.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          const Center(child: Text('Nothing to delete!')),
          Center(
              child: TextButton(
                  onPressed: () async {
                    await CancelSessionCommand(context)
                        .run(year: year, month: month);
                    if (!context.mounted) return;
                    context.go('/');
                  },
                  child: const Text('Go to main screen')))
        ])));
  }
}
