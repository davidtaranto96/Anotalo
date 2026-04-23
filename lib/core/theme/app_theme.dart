import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'accent.dart';
import 'anotalo_tokens.dart';

class AppTheme {
  AppTheme._();

  // Paleta default (terracota) para los getters legacy.
  static const AccentPalette _defaultAccent = AccentPalette(
    primary: Color(0xFFD97757),
    primaryDark: Color(0xFFC06240),
    primarySurface: Color(0x24D97757),
    primaryBorder: Color(0x66D97757),
    label: 'Terracota',
  );

  // ── Area colors (tarjetas / pills por categoría) ──
  static const areaWork     = Color(0xFF7AAED4); // slate blue
  static const areaStudy    = Color(0xFFB890D4); // dusty violet
  static const areaPersonal = Color(0xFF7FB069); // sage green
  static const areaHealth   = Color(0xFFD96A6A); // muted red
  static const areaTravel   = Color(0xFFE8B77A); // warm tan

  // ── Fondos y superficies ──
  static const surfaceBase     = Color(0xFFF4F3EE);
  static const surfaceCard     = Color(0xFFFFFFFF);
  static const surfaceElevated = Color(0xFFEDE9E3);
  static const surfaceSheet    = Color(0xFFFAFAF7);
  static const surfaceInput    = Color(0xFFF0EDE8);
  static const divider         = Color(0xFFE5E0D8);

  // ── Marca ──
  static const colorPrimary      = Color(0xFFC15F3C);
  static const colorPrimaryDark  = Color(0xFFA8502F);
  static const colorPrimaryLight = Color(0xFFF5DDD3);
  static const colorAccent       = Color(0xFFD97757);

  // ── Texto ──
  static const textPrimary   = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6560);
  static const textTertiary  = Color(0xFF9C9590);

  // ── Semanticos ──
  static const colorSuccess      = Color(0xFF5B8A5E);
  static const colorSuccessLight = Color(0xFFE8F0E8);
  static const colorWarning      = Color(0xFFC4963A);
  static const colorWarningLight = Color(0xFFFFF3E0);
  static const colorDanger       = Color(0xFFC44B4B);
  static const colorDangerLight  = Color(0xFFFDE8E8);
  static const colorInfo         = Color(0xFF5B7E9E);

  // ── Neutrales ──
  static const neutral50  = Color(0xFFFAFAF7);
  static const neutral100 = Color(0xFFF4F3EE);
  static const neutral200 = Color(0xFFEDE9E3);
  static const neutral300 = Color(0xFFE5E0D8);
  static const neutral400 = Color(0xFFB1ADA1);
  static const neutral500 = Color(0xFF9C9590);
  static const neutral600 = Color(0xFF6B6560);
  static const neutral700 = Color(0xFF4A4540);
  static const neutral800 = Color(0xFF2D2A27);
  static const neutral900 = Color(0xFF1A1A1A);

  // ── Radii ──
  static final r8    = BorderRadius.circular(8);
  static final r12   = BorderRadius.circular(12);
  static final r16   = BorderRadius.circular(16);
  static final r20   = BorderRadius.circular(20);
  static final rFull = BorderRadius.circular(999);

  // ── Sombras ──
  static const shadowSm = [BoxShadow(
    offset: Offset(0, 1), blurRadius: 2,
    color: Color(0x0A000000),
  )];
  static const shadowMd = [BoxShadow(
    offset: Offset(0, 2), blurRadius: 8,
    color: Color(0x0F000000),
  )];
  static const shadowLg = [BoxShadow(
    offset: Offset(0, 4), blurRadius: 16,
    color: Color(0x14000000),
  )];
  static const shadowFocus = [BoxShadow(
    color: Color(0x1FC15F3C),
    blurRadius: 0,
    spreadRadius: 3,
  )];

  // ── Spacing constants ──
  static const spaceXs  = 4.0;
  static const spaceSm  = 8.0;
  static const spaceMd  = 12.0;
  static const spaceBase = 16.0;
  static const spaceLg  = 20.0;
  static const spaceXl  = 24.0;
  static const space2xl = 32.0;
  static const space3xl = 48.0;

  // ── Dark mode palette (Claude-inspired warm grays) ──
  static const darkSurfaceBase     = Color(0xFF1A1A1E);
  static const darkSurfaceCard     = Color(0xFF242428);
  static const darkSurfaceElevated = Color(0xFF2E2E33);
  static const darkSurfaceSheet    = Color(0xFF2A2A2F);
  static const darkSurfaceInput    = Color(0xFF323238);
  static const darkDivider         = Color(0xFF3A3A40);
  static const darkTextPrimary     = Color(0xFFE8E6E3);
  static const darkTextSecondary   = Color(0xFFA8A5A0);
  static const darkTextTertiary    = Color(0xFF777470);

  // Brand colors slightly brighter for dark backgrounds
  static const darkColorPrimary = Color(0xFFD4704E);
  static const darkColorAccent  = Color(0xFFE88B6A);

  // ── ThemeData (Light) ──
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: surfaceBase,
    colorScheme: const ColorScheme.light(
      primary: colorPrimary,
      secondary: colorAccent,
      surface: surfaceBase,
      error: colorDanger,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 32, fontWeight: FontWeight.w700,
        color: textPrimary, letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: textPrimary, letterSpacing: -0.3,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w600,
        color: textPrimary, letterSpacing: -0.2,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 17, fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w400,
        color: textPrimary, height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w400,
        color: textSecondary, height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: textTertiary, letterSpacing: 0.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(color: textSecondary),
    ),
    cardTheme: CardThemeData(
      color: surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: r16,
        side: const BorderSide(color: divider),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceInput,
      border: OutlineInputBorder(
        borderRadius: r12,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: r12,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: r12,
        borderSide: const BorderSide(color: colorPrimary, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 15, color: textTertiary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: r12),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorPrimary,
        side: const BorderSide(color: colorPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: r12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceCard,
      selectedItemColor: colorPrimary,
      unselectedItemColor: neutral500,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 1,
      space: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: r16),
      elevation: 2,
    ),
  );

  // ── ThemeData (Dark) ──
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkSurfaceBase,
    colorScheme: const ColorScheme.dark(
      primary: darkColorPrimary,
      secondary: darkColorAccent,
      surface: darkSurfaceBase,
      error: colorDanger,
      onSurface: darkTextPrimary,
      onPrimary: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 32, fontWeight: FontWeight.w700,
        color: darkTextPrimary, letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: darkTextPrimary, letterSpacing: -0.3,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w600,
        color: darkTextPrimary, letterSpacing: -0.2,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 17, fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w400,
        color: darkTextPrimary, height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13, fontWeight: FontWeight.w400,
        color: darkTextSecondary, height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: darkTextTertiary, letterSpacing: 0.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.fraunces(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      iconTheme: const IconThemeData(color: darkTextSecondary),
    ),
    cardTheme: CardThemeData(
      color: darkSurfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: r16,
        side: const BorderSide(color: darkDivider),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceInput,
      border: OutlineInputBorder(
        borderRadius: r12,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: r12,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: r12,
        borderSide: const BorderSide(color: darkColorPrimary, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 15, color: darkTextTertiary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: darkColorPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: r12),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkColorPrimary,
        side: const BorderSide(color: darkColorPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: r12),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceCard,
      selectedItemColor: darkColorPrimary,
      unselectedItemColor: darkTextTertiary,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: darkDivider,
      thickness: 1,
      space: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColorPrimary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: r16),
      elevation: 2,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: darkSurfaceSheet,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: darkSurfaceCard,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return darkColorPrimary;
        return darkTextTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return darkColorPrimary.withAlpha(80);
        }
        return darkSurfaceInput;
      }),
    ),
  );

  // ═══════════════════════════════════════════════════════════════
  // Factories con acento + ThemeExtensions (sistema 1.6)
  //   Uso: MaterialApp(theme: AppTheme.light(palette), darkTheme: AppTheme.dark(palette))
  //   Los getters .theme / .darkTheme siguen disponibles con el acento default.
  // ═══════════════════════════════════════════════════════════════

  static ThemeData light([AccentPalette? accent]) =>
      _withAccent(theme, accent ?? _defaultAccent, isDark: false);

  static ThemeData dark([AccentPalette? accent]) =>
      _withAccent(darkTheme, accent ?? _defaultAccent, isDark: true);

  static ThemeData _withAccent(ThemeData base, AccentPalette accent,
      {required bool isDark}) {
    final scheme = base.colorScheme.copyWith(
      primary: accent.primary,
      secondary: accent.primaryDark,
      onPrimary: Colors.white,
    );

    return base.copyWith(
      colorScheme: scheme,
      primaryColor: accent.primary,
      iconTheme: base.iconTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: r12),
          textStyle: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent.primary,
          side: BorderSide(color: accent.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: r12),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        focusedBorder: OutlineInputBorder(
          borderRadius: r12,
          borderSide: BorderSide(color: accent.primary, width: 1.5),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: r16),
        elevation: 0,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedItemColor: accent.primary,
      ),
      extensions: <ThemeExtension<dynamic>>[
        AnotaloSpacing.standard,
        AnotaloRadii.standard,
        AnotaloMotion.standard,
        AnotaloShadows(isDark: isDark, accent: accent.primary),
      ],
    );
  }
}
