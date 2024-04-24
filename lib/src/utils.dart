import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

typedef FutureBuilderErrorCallback = Widget Function(Object? error);
typedef FutureBuilderReadyCallback<T> = Widget Function(T? data);

class Utils {
  static final DateFormat creationDateFormat =
      DateFormat("yyyy:MM:dd HH:mm:ss");
  static final NumberFormat monthFormatter = NumberFormat("00");
  static final NumberFormat yearFormatter = NumberFormat("0000");
  static final DateFormat _monthNumberToMonthName = DateFormat('MMMM');

  static String monthNumberToMonthName(int month) {
    return _monthNumberToMonthName.format(DateTime(0, month));
  }

  static String stringifyYearMonth({required int year, required int month}) {
    return '${year.toString().padLeft(4, '0')}${month.toString().padLeft(2, '0')}';
  }

  static final Logger _logger = Logger();

  static Logger get logger => _logger;

  static Widget buildLoading(BuildContext context) {
    return const Align(
        alignment: Alignment.center,
        // This will horizontally center from the top
        child: CircularProgressIndicator());
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
}
