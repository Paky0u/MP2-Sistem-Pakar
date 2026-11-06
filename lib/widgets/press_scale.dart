import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/app_haptics.dart';

class PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const PressScale({super.key, required this.child, this.onTap});

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isReducedMotion(context)) {
      return GestureDetector(
        onTap: () {
          AppHaptics.selection();
          widget.onTap?.call();
        },
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        AppHaptics.selection();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
