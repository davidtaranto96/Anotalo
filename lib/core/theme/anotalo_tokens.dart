import 'package:flutter/material.dart';

/// Tokens de diseño del sistema 1.6. Se exponen como ThemeExtension
/// para que se resuelvan con `Theme.of(context).extension<...>()!`
/// o via las shortcuts de `AnotaloThemeContext`.

@immutable
class AnotaloSpacing extends ThemeExtension<AnotaloSpacing> {
  final double xxs; // 2
  final double xs;  // 4
  final double sm;  // 8
  final double md;  // 12
  final double lg;  // 16
  final double xl;  // 20
  final double xxl; // 24
  final double xxxl; // 32
  final double screenPadding; // 22

  const AnotaloSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.screenPadding,
  });

  static const standard = AnotaloSpacing(
    xxs: 2, xs: 4, sm: 8, md: 12, lg: 16, xl: 20, xxl: 24, xxxl: 32,
    screenPadding: 22,
  );

  @override
  AnotaloSpacing copyWith() => this;
  @override
  AnotaloSpacing lerp(ThemeExtension<AnotaloSpacing>? other, double t) => this;
}

@immutable
class AnotaloRadii extends ThemeExtension<AnotaloRadii> {
  final double xs;   // 6
  final double sm;   // 8
  final double md;   // 10
  final double lg;   // 12
  final double xl;   // 14
  final double xxl;  // 18
  final double sheet; // 24
  final double circle; // 999

  const AnotaloRadii({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.sheet,
    required this.circle,
  });

  static const standard = AnotaloRadii(
    xs: 6, sm: 8, md: 10, lg: 12, xl: 14, xxl: 18, sheet: 24, circle: 999,
  );

  @override
  AnotaloRadii copyWith() => this;
  @override
  AnotaloRadii lerp(ThemeExtension<AnotaloRadii>? other, double t) => this;
}

@immutable
class AnotaloShadows extends ThemeExtension<AnotaloShadows> {
  final bool isDark;
  final Color accent;
  const AnotaloShadows({required this.isDark, required this.accent});

  List<BoxShadow> get card => isDark
      ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ]
      : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          )
        ];

  List<BoxShadow> get fab => [
        BoxShadow(
          color: accent.withValues(alpha: isDark ? 0.35 : 0.25),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  List<BoxShadow> get sheet => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
          blurRadius: 60,
          offset: const Offset(0, -20),
        ),
      ];

  List<BoxShadow> get navBarTop => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
          blurRadius: 24,
          offset: const Offset(0, -8),
        ),
      ];

  @override
  AnotaloShadows copyWith({bool? isDark, Color? accent}) =>
      AnotaloShadows(isDark: isDark ?? this.isDark, accent: accent ?? this.accent);
  @override
  AnotaloShadows lerp(ThemeExtension<AnotaloShadows>? other, double t) => this;
}

@immutable
class AnotaloMotion extends ThemeExtension<AnotaloMotion> {
  final Duration fast;
  final Duration base;
  final Duration slow;
  final Duration pageTransition;
  final Curve emphasized;
  // Renombrado para no colisionar con el miembro estático `standard` del
  // mismo nombre (Dart prohíbe static y field con el mismo identificador).
  final Curve standardCurve;
  final Curve decelerate;

  const AnotaloMotion({
    required this.fast,
    required this.base,
    required this.slow,
    required this.pageTransition,
    required this.emphasized,
    required this.standardCurve,
    required this.decelerate,
  });

  static const AnotaloMotion standard = AnotaloMotion(
    fast: Duration(milliseconds: 160),
    base: Duration(milliseconds: 240),
    slow: Duration(milliseconds: 360),
    pageTransition: Duration(milliseconds: 300),
    emphasized: Cubic(0.2, 0.0, 0.0, 1.0),
    standardCurve: Cubic(0.2, 0.0, 0.0, 1.0),
    decelerate: Cubic(0.0, 0.0, 0.2, 1.0),
  );

  @override
  AnotaloMotion copyWith() => this;
  @override
  AnotaloMotion lerp(ThemeExtension<AnotaloMotion>? other, double t) => this;
}

/// Short-hand accessors. Importá este archivo y usá
/// `context.space.md`, `context.radii.lg`, `context.shadowsX.fab`, etc.
/// (Uso `shadowsX` para no chocar con el `shadows` existente en otros módulos.)
extension AnotaloThemeContext on BuildContext {
  AnotaloSpacing get space => Theme.of(this).extension<AnotaloSpacing>()!;
  AnotaloRadii get radii => Theme.of(this).extension<AnotaloRadii>()!;
  AnotaloShadows get shadowsX => Theme.of(this).extension<AnotaloShadows>()!;
  AnotaloMotion get motion => Theme.of(this).extension<AnotaloMotion>()!;
}
