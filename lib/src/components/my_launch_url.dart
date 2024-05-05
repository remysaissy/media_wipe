import 'package:flutter/material.dart';
import 'package:app/src/components/dialog.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> myLaunchURL(BuildContext context, String targetURL) async {
  try {
    final Uri url = Uri.parse(targetURL);
    if (!await launchUrl(url)) {
      showAlertDialog(context, 'Error', 'Could not open the link.');
    }
  } on Exception catch (_) {
    showAlertDialog(context, 'Error', 'Could not open the link.');
  }
}