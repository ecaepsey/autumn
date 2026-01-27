import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  static const int totalSeconds = 25 * 60; // Pomodoro default
  int remaining = totalSeconds;

  Timer? _timer;
  bool get isRunning => _timer?.isActive ?? false;

  void start() {
    if (isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining <= 0) {
        stop();
        return;
      }
      setState(() => remaining -= 1);
    });
    setState(() {});

    
  }

  void stop() {
    _timer?.cancel();
    setState(() {});
  }

  void reset() {
    stop();
    setState(() => remaining = totalSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get mmss {
    final m = (remaining ~/ 60).toString().padLeft(2, '0');
    final s = (remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get progress {
    // 1.0 at start, 0.0 at end
    return remaining / totalSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CircleTimer(
                progress: progress,
                label: mmss,
                strokeWidth: 4,
                size: 280,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    onPressed: isRunning ? null : start,
                    child: const Text('Start'),
                  ),
                  OutlinedButton(
                    onPressed: isRunning ? stop : null,
                    child: const Text('Stop'),
                  ),
                  TextButton(
                    onPressed: reset,
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleTimer extends StatelessWidget {
  final double progress; // 0..1
  final String label;
  final double strokeWidth;
  final double size;

  const _CircleTimer({
    required this.progress,
    required this.label,
    required this.strokeWidth,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
        );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              progressColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: textStyle),
              const SizedBox(height: 6),
              Text(
                progress >= 1 ? 'Ready' : 'Focus',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress; // 0..1 (remaining/total)
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Full track circle
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc: start at top (-90deg). We show "remaining", so it shrinks.
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
