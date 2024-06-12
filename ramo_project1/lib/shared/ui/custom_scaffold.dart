import 'dart:ui';

import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                ),
              ),
            ),
          ),
          if (appBar != null)
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                  stops: const [0.0, 1.0],
                  colors: <Color>[
                    Colors.transparent,
                    const Color(0xFF234D6C).withOpacity(.6),
                  ],
                ),
              ),
            ),
          SizedBox.expand(
            child: Material(
              color: Colors.transparent,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
