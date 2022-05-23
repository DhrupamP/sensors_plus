import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  runApp(MaterialApp(home: SqliteApp()));
}
