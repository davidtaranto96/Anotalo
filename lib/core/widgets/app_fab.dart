import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';

class AppFab extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? color;

  const AppFab({
    super.key,
    required this.icon,
    required this.onTap,
    this.onLongPress,
    this.color,
  });

  @override
  State<AppFab> createState() => _AppFabState();
}

class _AppFabState extends State<AppFab> with SingleTickerProviderStateMixin {
  bool _longPressed = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _longPressed
        ? AppTheme.colorDanger
        : (widget.color ?? AppTheme.colorPrimary);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onLongPress: widget.onLongPress == null ? null : () {
        HapticFeedback.mediumImpact();
        setState(() => _longPressed = true);
        _pulseController.repeat(reverse: true);
        widget.onLongPress!();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _longPressed = false);
            _pulseController.stop();
            _pulseController.reset();
          }
        });
      },
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: bgColor.withAlpha((0.9 * 255).round()),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withAlpha((0.12 * 255).round()),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: RotationTransition(
                    turns: animation,
                    child: child,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  key: ValueKey(widget.icon),
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
