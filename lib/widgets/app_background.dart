import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'content_frame.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool withGrid;
  final bool withGlow;
  final bool constrainContent;

  const AppBackground({
    super.key,
    required this.child,
    this.withGrid = true,
    this.withGlow = true,
    this.constrainContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.background, AppColors.backgroundEnd],
        ),
      ),
      child: Stack(
        children: [
          if (withGlow) ...[
            Positioned(
              top: -100,
              right: -100,
              child: _GlowOrb(color: AppColors.primary.withValues(alpha: 0.05), size: 300),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _GlowOrb(color: AppColors.secondary.withValues(alpha: 0.05), size: 250),
            ),
          ],
          if (withGrid)
            const Positioned.fill(
              child: _GridPainter(),
            ),
          if (constrainContent)
            ContentFrame(child: child)
          else
            child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size / 2,
            spreadRadius: size / 4,
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends StatelessWidget {
  const _GridPainter();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: GridPainter(),
    );
  }
}

class GridPainter extends CustomPainter {
  const GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
