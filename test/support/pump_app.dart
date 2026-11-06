import 'package:flutter/material.dart';

class PumpApp {
  static Widget widget({
    required Widget child,
    Size size = const Size(390, 844),
    double textScaleFactor = 1.0,
    bool disableAnimations = true,
  }) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070B14),
      ),
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScaleFactor),
          disableAnimations: disableAnimations,
        ),
        child: child,
      ),
    );
  }
}
