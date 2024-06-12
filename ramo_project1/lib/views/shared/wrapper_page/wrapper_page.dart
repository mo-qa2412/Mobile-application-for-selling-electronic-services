import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../configs/theme.dart';
import '../loader_page/loader_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoaderPage(),
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      defaultTransition: Transition.fadeIn,
    );
  }
}
