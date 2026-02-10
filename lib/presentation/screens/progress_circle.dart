import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  final double progress; // 0.0 → 1.0
  final double size;
  final double strokeWidth;
  final Widget center;

  const ProgressCircle({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 4,
    required this.center,
  }); 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      width: size,
      height: size,
      child: Stack(
        
        alignment: Alignment.center,
        children: [
          CustomPaint(
            
            size: Size(size, size),
            painter: _ProgressPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              backgroundColor:
                  Theme.of(context).colorScheme.outlineVariant,
              progressColor:
                  Theme.of(context).colorScheme.primary,
            ),
          ),
          center,






        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth / 2;

    final trackPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // background circle
    canvas.drawCircle(center, radius, trackPaint);

    // progress arc (starts from top)
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
