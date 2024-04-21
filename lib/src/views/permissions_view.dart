import 'package:flutter/material.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  // final _permissionsController = di<PermissionsController>();
  //
  // PermissionsView({super.key});
  //
  // @override
  // Widget build(BuildContext context) {
  //   return MyScaffold(
  //       appBar: AppBar(
  //         title: const Text('Sort Master: Permissions'),
  //       ),
  //       child: Column(children: [
  //         _buildAuthorizeCameraRollRow(context),
  //       ]
  //       )
  //   );
  // }
  //
  // Widget _buildAuthorizeCameraRollRow(BuildContext context) {
  //   return MyCTAButton(
  //       onPressed: () async {
  //         await _permissionsController.authorizeCameraRoll();
  //         // if (!context.mounted) return;
  //         // context.go('/home');
  //       },
  //       child: const Text(
  //           'Authorize Camera Roll',
  //           textAlign: TextAlign.center)
  //   );
  // }
}