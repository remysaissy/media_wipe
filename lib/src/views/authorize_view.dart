import 'package:app/src/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/src/commands/settings/authorize_photos_command.dart';

class AuthorizeView extends StatelessWidget {
  const AuthorizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildContent(context)));
  }

  Widget _buildContent(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text('Welcome on MediaWipe!',
              style: Theme.of(context).textTheme.headlineLarge)),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Text('Sort your photos in an easy and convenient way',
              style: Theme.of(context).textTheme.titleLarge)),
      const Spacer(),
      ElevatedButton(
        onPressed: () async {
          await AuthorizePhotosCommand(context).run();
          if (context.mounted) {
            context.go('/');
          }
        },
        child: const Text('Authorize'),
      )
    ]);
  }
}
