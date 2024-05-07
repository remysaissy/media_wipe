
import 'package:app/src/commands/assets/refresh_photos_command.dart';
import 'package:app/src/commands/sessions/finish_session_command.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteButton extends StatelessWidget {
  final int year;
  final int month;

  const DeleteButton({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          await FinishSessionCommand(context)
              .run(year: year, month: month);
          await RefreshPhotosCommand(context).run(year: year);
          if (!context.mounted) return;
          context.go('/');
        },
        child: const Text('Delete'));
  }

}