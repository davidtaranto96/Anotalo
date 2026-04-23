import 'package:flutter/material.dart';

import '../feedback/feedback_service.dart';
import '../theme/anotalo_tokens.dart';

/// FAB del sistema 1.6 — 52×52, radio 14pt, sombra doble (glow del acento
/// + drop negro). Color dinámico: usa `colorScheme.primary`, que ya está
/// sincronizado con el acento elegido por el usuario.
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
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
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
    final scheme = Theme.of(context).colorScheme;
    final primary = widget.color ?? scheme.primary;
    final bgColor = _longPressed
        ? scheme.error
        : _pressed
            ? scheme.secondary // primaryDark del acento
            : primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        FeedbackService.instance.tick();
        widget.onTap();
      },
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              FeedbackService.instance.warn();
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
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(context.radii.xl),
              boxShadow: context.shadowsX.fab,
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
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
