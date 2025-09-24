import 'package:app/shared/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

import '../commands/authorize_photos_command.dart';

class AuthorizeView extends StatelessWidget {
  const AuthorizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildContent(context)));
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text(
            AppLocalizations.of(context)!.authorizeWelcome,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text(
            AppLocalizations.of(context)!.authorizeDescription,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            await AuthorizePhotosCommand(context).run();
            if (context.mounted) {
              context.goNamed(AppRouter.root);
            }
          },
          child: Text(AppLocalizations.of(context)!.authorizeCTA),
        ),
      ],
    );
  }
}
