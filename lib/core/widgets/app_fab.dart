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
  bool _pressed = false;
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
        : _pressed
            ? AppTheme.colorPrimaryDark
            : (widget.color ?? AppTheme.colorPrimary);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
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
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppTheme.r16,
              boxShadow: AppTheme.shadowMd,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                widget.icon,
                key: ValueKey(widget.icon),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
