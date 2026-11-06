import 'package:flutter/material.dart';

Route<T> fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.05);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
