import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RadarScan extends StatefulWidget {
  const RadarScan({super.key});

  @override
  State<RadarScan> createState() => _RadarScanState();
}

class _RadarScanState extends State<RadarScan> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isReducedMotion(context)) {
      if (_ctrl.isAnimating) _ctrl.stop();
    } else if (!_ctrl.isAnimating) {
      _ctrl.repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isReducedMotion(context)) {
      return CustomPaint(
        painter: RadarPainter(angle: 0),
        size: const Size.square(200),
      );
    }

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return CustomPaint(
          painter: RadarPainter(angle: _ctrl.value * 2 * math.pi),
          size: const Size.square(200),
        );
      },
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle;
  RadarPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paintCircle = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Circles
    canvas.drawCircle(center, radius * 0.3, paintCircle);
    canvas.drawCircle(center, radius * 0.65, paintCircle);
    canvas.drawCircle(center, radius, paintCircle);

    // Crosshairs
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), paintCircle);
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), paintCircle);

    // Sweep line & Gradient
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          AppColors.primary.withValues(alpha: 0.0),
          AppColors.primary.withValues(alpha: 0.4),
        ],
        stops: const [0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, math.pi / 2, false)
      ..close();

    canvas.drawPath(path, sweepPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}
