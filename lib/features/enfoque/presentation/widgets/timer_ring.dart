import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../../core/theme/app_theme.dart';

class TimerRing extends StatefulWidget {
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
  State<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isRunning) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TimerRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning && !oldWidget.isRunning) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isRunning && oldWidget.isRunning) {
      _glowController.stop();
      _glowController.value = 0;
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(end: widget.progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            builder: (context, smoothProgress, _) {
              return ListenableBuilder(
                listenable: _glowController,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(220, 220),
                    painter: _RingPainter(
                      progress: smoothProgress,
                      isRunning: widget.isRunning,
                      glowIntensity: _glowController.value,
                    ),
                  );
                },
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  widget.timeDisplay,
                  key: ValueKey(widget.timeDisplay),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: widget.isRunning
                        ? AppTheme.colorPrimary
                        : AppTheme.textPrimary,
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
  final double glowIntensity;

  _RingPainter({
    required this.progress,
    required this.isRunning,
    required this.glowIntensity,
  });

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
        ..color = AppTheme.surfaceElevated
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    if (progress > 0) {
      final arcRect = Rect.fromCircle(center: center, radius: radius);
      final sweepAngle = 2 * math.pi * progress;

      // Glow layer when running
      if (isRunning && glowIntensity > 0) {
        canvas.drawArc(
          arcRect,
          -math.pi / 2,
          sweepAngle,
          false,
          Paint()
            ..color = AppTheme.colorPrimary.withValues(alpha: 0.4 * glowIntensity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 6
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      // Main progress arc
      canvas.drawArc(
        arcRect,
        -math.pi / 2,
        sweepAngle,
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
      old.progress != progress ||
      old.isRunning != isRunning ||
      old.glowIntensity != glowIntensity;
}
