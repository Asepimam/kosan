import 'package:flutter/material.dart';
import 'package:kosan_kan/app.dart';
import 'package:kosan_kan/app/di/getIt.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Hive.initFlutter();
  await Hive.openBox('app_preferences');
  runApp(const MyApp());
}
