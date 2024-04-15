import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showAlertDialog(BuildContext context, String title, String description) {

  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      context.pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(description),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
