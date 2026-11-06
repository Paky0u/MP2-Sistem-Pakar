import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Membatasi lebar konten agar tetap nyaman dibaca di tablet/desktop.
class ContentFrame extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ContentFrame({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
