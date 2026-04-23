// lib/theme/anotalo_theme.dart
//
// Anótalo — Design System (Flutter)
// ──────────────────────────────────
// Material 3 theme with light + dark variants, custom ThemeExtensions
// for tokens that don't fit in ColorScheme/TextTheme (spacing, radius,
// elevation, area colors).
//
// Usage in main.dart:
//   MaterialApp(
//     theme: AnotaloTheme.light(),
//     darkTheme: AnotaloTheme.dark(),
//     themeMode: ThemeMode.dark, // user preference
//     home: ...,
//   )
//
// Access tokens inside widgets:
//   final colors = Theme.of(context).colorScheme;
//   final spacing = Theme.of(context).extension<AnotaloSpacing>()!;
//   final radii = Theme.of(context).extension<AnotaloRadii>()!;
//   final areas = Theme.of(context).extension<AnotaloAreaColors>()!;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnotaloTheme {
  AnotaloTheme._();

  // ─── SEED COLORS (shared across light/dark) ─────────────────────
  // Primary is the terracotta/orange from the current brand.
  // We keep identity, change the chrome around it.
  static const Color _primary = Color(0xFFE07856);
  static const Color _primaryDark = Color(0xFFC45A38);

  // Area colors — used across pills, task accents, chips.
  // Muted so they coexist with the primary without fighting it.
  static const Color areaWork     = Color(0xFF7AAED4); // slate blue
  static const Color areaStudy    = Color(0xFFB890D4); // dusty violet
  static const Color areaPersonal = Color(0xFF7FB069); // sage green
  static const Color areaHealth   = Color(0xFFD96A6A); // muted red
  static const Color areaTravel   = Color(0xFFE8B77A); // warm tan

  // Semantic colors
  static const Color _success = Color(0xFF7FB069);
  static const Color _warning = Color(0xFFE8B77A);
  static const Color _error   = Color(0xFFD96A6A);

  // ─── LIGHT THEME ────────────────────────────────────────────────
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFFDECE2),
      onPrimaryContainer: Color(0xFF6B2D15),
      secondary: Color(0xFF6E6659),
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFF0EAE0),
      onSecondaryContainer: Color(0xFF3A342B),
      tertiary: areaWork,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFDDE9F4),
      onTertiaryContainer: Color(0xFF1A3A58),
      error: _error,
      onError: Colors.white,
      errorContainer: Color(0xFFFAD9D9),
      onErrorContainer: Color(0xFF6B1A1A),
      surface: Color(0xFFFBF7EE),        // Warm paper
      onSurface: Color(0xFF1A1814),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Color(0xFFF8F2E6),
      surfaceContainer: Color(0xFFF3EDDF),
      surfaceContainerHigh: Color(0xFFEDE7D9),
      surfaceContainerHighest: Color(0xFFE7E0D0),
      onSurfaceVariant: Color(0xFF6E6659),
      outline: Color(0xFFC9C0AD),
      outlineVariant: Color(0xFFE0D8C5),
      shadow: Colors.black,
      scrim: Color(0xDD000000),
      inverseSurface: Color(0xFF1A1814),
      onInverseSurface: Color(0xFFFBF7EE),
      inversePrimary: Color(0xFFFF9B7A),
    );
    return _build(scheme, Brightness.light);
  }

  // ─── DARK THEME (default for Anótalo) ───────────────────────────
  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF4A1E10),
      onPrimaryContainer: Color(0xFFFDCBB8),
      secondary: Color(0xFFA89E8E),
      onSecondary: Color(0xFF1A1814),
      secondaryContainer: Color(0xFF2A251D),
      onSecondaryContainer: Color(0xFFE7E0D0),
      tertiary: areaWork,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF1A3A58),
      onTertiaryContainer: Color(0xFFDDE9F4),
      error: _error,
      onError: Colors.white,
      errorContainer: Color(0xFF4A1515),
      onErrorContainer: Color(0xFFFAD9D9),
      surface: Color(0xFF0E0D0B),         // App background — obsidiana
      onSurface: Color(0xFFF5F1E8),
      surfaceContainerLowest: Color(0xFF080706),
      surfaceContainerLow: Color(0xFF16140F),
      surfaceContainer: Color(0xFF1C1914),
      surfaceContainerHigh: Color(0xFF24201A),
      surfaceContainerHighest: Color(0xFF2E2921),
      onSurfaceVariant: Color(0xFFA89E8E),
      outline: Color(0xFF3A3328),
      outlineVariant: Color(0xFF2A251D),
      shadow: Colors.black,
      scrim: Color(0xDD000000),
      inverseSurface: Color(0xFFFBF7EE),
      onInverseSurface: Color(0xFF1A1814),
      inversePrimary: _primaryDark,
    );
    return _build(scheme, Brightness.dark);
  }

  // ─── SHARED THEME BUILDER ───────────────────────────────────────
  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Typography pair:
    //  - Display: Instrument Serif (editorial, matches current "¿Qué vas a lograr?")
    //  - Body:    Inter (neutral, high legibility, replaces SF default)
    //  - Mono:    JetBrains Mono (timers, numbers, keyboard shortcuts)
    final displayFont = GoogleFonts.instrumentSerif(color: scheme.onSurface);
    final bodyFont = GoogleFonts.inter(color: scheme.onSurface);

    final textTheme = TextTheme(
      // Display — serif, italic-capable, editorial
      displayLarge: displayFont.copyWith(
        fontSize: 40, fontWeight: FontWeight.w400, height: 1.1, letterSpacing: -0.6,
      ),
      displayMedium: displayFont.copyWith(
        fontSize: 32, fontWeight: FontWeight.w400, height: 1.1, letterSpacing: -0.4,
      ),
      displaySmall: displayFont.copyWith(
        fontSize: 26, fontWeight: FontWeight.w400, height: 1.15, letterSpacing: -0.3,
      ),

      // Headline
      headlineLarge: displayFont.copyWith(
        fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: -0.2,
      ),
      headlineMedium: bodyFont.copyWith(
        fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.1,
      ),
      headlineSmall: bodyFont.copyWith(
        fontSize: 18, fontWeight: FontWeight.w600,
      ),

      // Title — section headers
      titleLarge: bodyFont.copyWith(
        fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.1,
      ),
      titleMedium: bodyFont.copyWith(
        fontSize: 14, fontWeight: FontWeight.w600,
      ),
      titleSmall: bodyFont.copyWith(
        fontSize: 13, fontWeight: FontWeight.w600,
      ),

      // Body
      bodyLarge: bodyFont.copyWith(
        fontSize: 16, fontWeight: FontWeight.w400, height: 1.45,
      ),
      bodyMedium: bodyFont.copyWith(
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.45,
      ),
      bodySmall: bodyFont.copyWith(
        fontSize: 12, fontWeight: FontWeight.w400, height: 1.4,
        color: scheme.onSurfaceVariant,
      ),

      // Label — chips, buttons, overlines
      labelLarge: bodyFont.copyWith(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1,
      ),
      labelMedium: bodyFont.copyWith(
        fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.2,
      ),
      labelSmall: bodyFont.copyWith(
        fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.4,
        // Used for ALL-CAPS overlines — always combine with textTransform.uppercase
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      fontFamily: bodyFont.fontFamily,

      // Splash/Ink — subtle on dark
      splashColor: scheme.primary.withValues(alpha: 0.08),
      highlightColor: scheme.primary.withValues(alpha: 0.05),

      // AppBar — flat, merges with surface
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),

      // Cards — rounded, low elevation, warm container
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),

      // Filled (primary) button — terracotta, white text, soft shadow
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          elevation: 0,
        ),
      ),

      // Outlined button — ghost
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline, width: 1),
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),

      // Input fields — subtle fill, focus ring matches primary
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),

      // FAB — rounded square (14pt radius), no shadow (use boxShadow manually)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        focusElevation: 0, hoverElevation: 0, highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Bottom nav — surface with blur (apply BackdropFilter at widget level)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(letterSpacing: 0.2, fontSize: 10),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.primary, size: 20);
          }
          return IconThemeData(color: scheme.onSurfaceVariant, size: 20);
        }),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Chips — used for pills, area tags
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer,
        selectedColor: scheme.primaryContainer,
        labelStyle: textTheme.labelMedium,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surfaceContainerHigh,
        modalBarrierColor: scheme.scrim,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 0,
        modalElevation: 0,
      ),

      // ThemeExtensions — design tokens that don't fit in Material
      extensions: <ThemeExtension<dynamic>>[
        AnotaloSpacing.standard,
        AnotaloRadii.standard,
        AnotaloAreaColors.defaultColors,
        AnotaloShadows(isDark: isDark),
        AnotaloMotion.standard,
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// THEME EXTENSIONS
// ═══════════════════════════════════════════════════════════════

/// Spacing scale — use these constants instead of raw numbers.
/// Based on 4pt grid. Most gaps = 8/12/16/20/24.
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
  final double screenPadding; // 22 — matches the HTML mockups

  const AnotaloSpacing({
    required this.xxs, required this.xs, required this.sm,
    required this.md, required this.lg, required this.xl,
    required this.xxl, required this.xxxl, required this.screenPadding,
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

/// Corner radius scale.
@immutable
class AnotaloRadii extends ThemeExtension<AnotaloRadii> {
  final double xs;  // 6  — tags, small pills
  final double sm;  // 8  — inline chips
  final double md;  // 10 — buttons, input chips, cards small
  final double lg;  // 12 — cards, inputs
  final double xl;  // 14 — FAB, primary buttons
  final double xxl; // 18 — large cards
  final double sheet; // 24 — bottom sheets, full-screen modals
  final double circle; // 999

  const AnotaloRadii({
    required this.xs, required this.sm, required this.md,
    required this.lg, required this.xl, required this.xxl,
    required this.sheet, required this.circle,
  });

  static const standard = AnotaloRadii(
    xs: 6, sm: 8, md: 10, lg: 12, xl: 14, xxl: 18, sheet: 24, circle: 999,
  );

  @override
  AnotaloRadii copyWith() => this;
  @override
  AnotaloRadii lerp(ThemeExtension<AnotaloRadii>? other, double t) => this;
}

/// Area colors — used to tint tasks/chips/icons by category.
@immutable
class AnotaloAreaColors extends ThemeExtension<AnotaloAreaColors> {
  final Color work;
  final Color study;
  final Color personal;
  final Color health;
  final Color travel;

  const AnotaloAreaColors({
    required this.work, required this.study, required this.personal,
    required this.health, required this.travel,
  });

  static const defaultColors = AnotaloAreaColors(
    work: AnotaloTheme.areaWork,
    study: AnotaloTheme.areaStudy,
    personal: AnotaloTheme.areaPersonal,
    health: AnotaloTheme.areaHealth,
    travel: AnotaloTheme.areaTravel,
  );

  /// Resolve a color by area name (case-insensitive).
  Color? byName(String name) {
    switch (name.toLowerCase()) {
      case 'trabajo':
      case 'work':
      case 'profesional': return work;
      case 'facultad':
      case 'estudio':
      case 'study': return study;
      case 'personal': return personal;
      case 'salud':
      case 'health': return health;
      case 'viaje':
      case 'travel': return travel;
      default: return null;
    }
  }

  @override
  AnotaloAreaColors copyWith() => this;
  @override
  AnotaloAreaColors lerp(ThemeExtension<AnotaloAreaColors>? other, double t) => this;
}

/// Pre-built BoxShadows — use instead of Material elevation where
/// you need warmer, softer shadows that match the aesthetic.
@immutable
class AnotaloShadows extends ThemeExtension<AnotaloShadows> {
  final bool isDark;
  const AnotaloShadows({required this.isDark});

  List<BoxShadow> get card => isDark
      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))]
      : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 2))];

  List<BoxShadow> get fab => [
        BoxShadow(
          color: AnotaloTheme._primary.withValues(alpha: isDark ? 0.35 : 0.25),
          blurRadius: 20, offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
          blurRadius: 6, offset: const Offset(0, 2),
        ),
      ];

  List<BoxShadow> get sheet => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
          blurRadius: 60, offset: const Offset(0, -20),
        ),
      ];

  @override
  AnotaloShadows copyWith({bool? isDark}) => AnotaloShadows(isDark: isDark ?? this.isDark);
  @override
  AnotaloShadows lerp(ThemeExtension<AnotaloShadows>? other, double t) => this;
}

/// Motion tokens — durations and curves, referenced by animations.
@immutable
class AnotaloMotion extends ThemeExtension<AnotaloMotion> {
  final Duration fast;
  final Duration base;
  final Duration slow;
  final Duration pageTransition;
  final Curve emphasized;
  final Curve standard;
  final Curve decelerate;

  const AnotaloMotion({
    required this.fast, required this.base, required this.slow,
    required this.pageTransition,
    required this.emphasized, required this.standard, required this.decelerate,
  });

  static const standard = AnotaloMotion(
    fast: Duration(milliseconds: 160),
    base: Duration(milliseconds: 240),
    slow: Duration(milliseconds: 360),
    pageTransition: Duration(milliseconds: 300),
    emphasized: Cubic(0.2, 0.0, 0.0, 1.0),    // Material 3 emphasized
    standard: Cubic(0.2, 0.0, 0.0, 1.0),
    decelerate: Cubic(0.0, 0.0, 0.2, 1.0),
  );

  @override
  AnotaloMotion copyWith() => this;
  @override
  AnotaloMotion lerp(ThemeExtension<AnotaloMotion>? other, double t) => this;
}

// ═══════════════════════════════════════════════════════════════
// CONVENIENCE EXTENSIONS
// ═══════════════════════════════════════════════════════════════

/// Short-hand accessors so you can write `context.colors.primary`
/// instead of `Theme.of(context).colorScheme.primary`.
extension AnotaloThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  AnotaloSpacing get space => Theme.of(this).extension<AnotaloSpacing>()!;
  AnotaloRadii get radii => Theme.of(this).extension<AnotaloRadii>()!;
  AnotaloAreaColors get areas => Theme.of(this).extension<AnotaloAreaColors>()!;
  AnotaloShadows get shadows => Theme.of(this).extension<AnotaloShadows>()!;
  AnotaloMotion get motion => Theme.of(this).extension<AnotaloMotion>()!;
}
