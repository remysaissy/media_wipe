

import 'package:intl/intl.dart';

class Utils {
  static final DateFormat creationDateFormat = DateFormat("yyyy:MM:dd HH:mm:ss");
  static final NumberFormat monthFormatter = NumberFormat("00");
  static final NumberFormat yearFormatter = NumberFormat("0000");
  static final DateFormat _monthNumberToMonthName = DateFormat('MMMM');

  static String monthNumberToMonthName(int month) {
    return _monthNumberToMonthName.format(DateTime(0, month));
  }
}