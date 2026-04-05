import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../../core/theme/app_theme.dart';

class TimerRing extends StatelessWidget {
  final double progress;
  final String timeDisplay;
  final bool isRunning;

  const TimerRing({
    super.key,
    required this.progress,
    required this.timeDisplay,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _RingPainter(progress: progress, isRunning: isRunning),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  timeDisplay,
                  key: ValueKey(timeDisplay),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: isRunning ? AppTheme.colorPrimary : const Color(0xFFF0F0FF),
                    letterSpacing: -1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool isRunning;

  _RingPainter({required this.progress, required this.isRunning});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 8.0;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppTheme.surfaceCard
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = isRunning ? AppTheme.colorPrimary : AppTheme.colorAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.isRunning != isRunning;
}
