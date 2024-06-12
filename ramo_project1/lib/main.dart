import 'package:flutter/material.dart';
import 'models/shared_prefs_helper.dart';
import 'views/shared/wrapper_page/wrapper_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(const Wrapper());
}
