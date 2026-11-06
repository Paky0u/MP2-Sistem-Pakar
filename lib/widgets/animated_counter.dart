import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    if (isReducedMotion(context)) {
      return Text('$value$suffix', style: style);
    }

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, val, child) {
        return Text('$val$suffix', style: style);
      },
    );
  }
}
