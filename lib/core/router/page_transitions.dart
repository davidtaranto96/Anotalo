import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Página con transición shared-axis X sutil del sistema 1.6.
/// El entrante fade + slide 2% desde la derecha, el saliente fade out.
/// Curve `easeOutCubic` para ambos; duración 300ms.
CustomTransitionPage<void> sharedAxisXPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    child: child,
    transitionsBuilder: (ctx, anim, secAnim, child) {
      final curve = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.02, 0),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        ),
      );
    },
  );
}
