import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/controllers/permissions_controller.dart';
import 'package:watch_it/watch_it.dart';

class PermissionsView extends StatelessWidget {

  final _permissionsController = di<PermissionsController>();

  PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(
          title: const Text('Sort Master: Permissions'),
        ),
        child: Column(children: [
          _buildAuthorizeCameraRollRow(context),
        ]
        )
    );
  }

  Widget _buildAuthorizeCameraRollRow(BuildContext context) {
    return MyCTAButton(
        onPressed: () async {
          await _permissionsController.authorizeCameraRoll();
          // if (!context.mounted) return;
          // context.go('/home');
        },
        child: const Text(
            'Authorize Camera Roll',
            textAlign: TextAlign.center)
    );
  }
}