import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StaggeredEntrance extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration? delay;

  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.delay,
  });

  @override
  Widget build(BuildContext context) {
    if (isReducedMotion(context)) return child;

    final base = delay ?? const Duration(milliseconds: 60);
    final duration = Duration(milliseconds: 400 + base.inMilliseconds * index);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
