import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/components/my_cta_button.dart';
import 'package:sortmaster_photos/src/components/my_scaffold.dart';
import 'package:sortmaster_photos/src/permissions/permissions_controller.dart';
import 'package:watch_it/watch_it.dart';
import 'package:go_router/go_router.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = di<PermissionsController>();
    return MyScaffold(
        appBar: AppBar(
          title: const Text('Sort Master: Permissions'),
        ),
        child: Column(children: [
          _buildAuthorizeCameraRollRow(context, controller),
        ]
        )
    );
  }

  Widget _buildAuthorizeCameraRollRow(BuildContext context, PermissionsController controller) {
    return MyCTAButton(
        onPressed: () async {
          await controller.authorizeCameraRoll();
          // if (!context.mounted) return;
          // context.go('/home');
        },
        child: const Text(
            'Authorize Camera Roll',
            textAlign: TextAlign.center)
    );
  }
}