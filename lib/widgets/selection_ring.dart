import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SelectionRing extends StatelessWidget {
  final bool selected;
  final Widget child;
  final VoidCallback? onTap;

  const SelectionRing({
    super.key,
    required this.selected,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.surfaceBorder,
          width: selected ? 2.0 : 1.0,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: child,
    );
  }
}
