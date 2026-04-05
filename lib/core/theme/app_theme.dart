import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  // Semantic colors
  static const colorPrimary   = Color(0xFF7C6EF7);
  static const colorAccent    = Color(0xFF5ECFB1);
  static const colorDanger    = Color(0xFFFF5C6E);
  static const colorWarning   = Color(0xFFFFB347);
  static const colorNeutral   = Color(0xFF9A9BBF);

  // Surfaces
  static const surfaceBase     = Color(0xFF1E1E2C);
  static const surfaceCard     = Color(0xFF242740);
  static const surfaceElevated = Color(0xFF2E3253);
  static const surfaceSheet    = Color(0xFF18181F);

  // Border radius scale
  static const r4  = BorderRadius.all(Radius.circular(4));
  static const r8  = BorderRadius.all(Radius.circular(8));
  static const r12 = BorderRadius.all(Radius.circular(12));
  static const r16 = BorderRadius.all(Radius.circular(16));
  static const r20 = BorderRadius.all(Radius.circular(20));
  static const r24 = BorderRadius.all(Radius.circular(24));
  static const r32 = BorderRadius.all(Radius.circular(32));

  static ThemeData dark() {
    const cs = ColorScheme(
      brightness: Brightness.dark,
      primary: colorPrimary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF3D3580),
      onPrimaryContainer: Color(0xFFD4CCFF),
      secondary: colorAccent,
      onSecondary: Colors.black,
      error: colorDanger,
      onError: Colors.white,
      surface: Color(0xFF1A1D2E),
      onSurface: Color(0xFFF0F0FF),
      onSurfaceVariant: Color(0xFF9A9BBF),
      surfaceContainerHighest: Color(0xFF2E3253),
      surfaceContainerHigh: Color(0xFF242740),
      surfaceContainer: Color(0xFF242740),
      outline: Color(0xFF3D4070),
      outlineVariant: Color(0xFF2B2E50),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: surfaceBase,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceBase,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: cs.onSurface, fontSize: 20, fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cs.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outlineVariant)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2)),
        hintStyle: GoogleFonts.inter(color: cs.onSurfaceVariant, fontSize: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
