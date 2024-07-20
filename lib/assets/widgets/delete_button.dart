import 'package:app/assets/commands/sessions/finish_session_command.dart';
import 'package:app/assets/overlays/deletion_in_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteButton extends StatelessWidget {
  final int year;
  final int month;

  const DeleteButton({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          if (!context.mounted) return;
          final entry = DeletionInProgress.getOverlayEntry();
          Overlay.of(context).insert(entry);
          await FinishSessionCommand(context).run(year: year, month: month);
          entry.remove();
        },
        child: Text(AppLocalizations.of(context)!.sortSummaryDeleteCTA));
  }
}
