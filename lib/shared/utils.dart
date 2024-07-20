import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

typedef FutureBuilderErrorCallback = Widget Function(Object? error);
typedef FutureBuilderReadyCallback<T> = Widget Function(T? data);

class Utils {
  static final DateFormat creationDateFormat = DateFormat(
      "yyyy:MM:dd HH:mm:ss");
  static final NumberFormat monthFormatter = NumberFormat("00");
  static final NumberFormat yearFormatter = NumberFormat("0000");
  static final DateFormat _monthNumberToMonthName = DateFormat('MMMM');

  static String monthNumberToMonthName(int month) {
    return _monthNumberToMonthName.format(DateTime(0, month));
  }

  static String stringifyYearMonth({required int year, required int month}) {
    return '${year.toString().padLeft(4, '0')}${month.toString().padLeft(
        2, '0')}';
  }

  static final Logger _logger = Logger();

  static Logger get logger => _logger;

  static Widget buildLoading(BuildContext context) {
    return const Align(
        alignment: Alignment.center,
        // This will horizontally center from the top
        child: CircularProgressIndicator.adaptive());
  }

  static Widget futureBuilder<T>({
    required Future<T> future,
    FutureBuilderErrorCallback? onError,
    FutureBuilderReadyCallback<T>? onReady}) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              Utils.logger.e('Error ${snapshot.error} occurred');
              if (onError != null) {
                return onError(snapshot.error);
              }
            } else if (snapshot.hasData) {
              if (onReady != null) {
                return onReady(snapshot.data);
              }
            }
          }
          return Utils.buildLoading(context);
        });
  }

  static Future<void> openURL(BuildContext context, String targetURL) async {
    final url = Uri.tryParse(targetURL);
    if (url == null) {
      if (!context.mounted) return;
      _showAlertDialog(context, 'Error', 'Could not open the link.');
    } else {
      final success = await launchUrl(url);
      if (!success) {
        if (!context.mounted) return;
        _showAlertDialog(context, 'Error', 'Could not open the link.');
      }
    }
  }

  static void _showAlertDialog(BuildContext context, String title, String description) {

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
}
