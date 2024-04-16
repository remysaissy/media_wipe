import 'package:flutter/material.dart';
import 'package:sortmaster_photos/src/app.dart';
import 'package:sortmaster_photos/src/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();
  di.allReady().then((value) => runApp(MyApp()));
}
