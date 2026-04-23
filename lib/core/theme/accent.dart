import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Los 6 acentos curados del redesign 1.6. Comparten chroma en OKLCH —
/// solo cambia el hue, así se sienten familia sobre el mismo dark.
enum AnotaloAccent { terracota, indigo, bosque, oceano, violeta, grafito }

@immutable
class AccentPalette {
  final Color primary;
  final Color primaryDark;
  final Color primarySurface; // ~14% alpha fill
  final Color primaryBorder; // ~40% alpha
  final String label;

  const AccentPalette({
    required this.primary,
    required this.primaryDark,
    required this.primarySurface,
    required this.primaryBorder,
    required this.label,
  });
}

const Map<AnotaloAccent, AccentPalette> accentPalettes = {
  AnotaloAccent.terracota: AccentPalette(
    primary: Color(0xFFD97757),
    primaryDark: Color(0xFFC06240),
    primarySurface: Color(0x24D97757),
    primaryBorder: Color(0x66D97757),
    label: 'Terracota',
  ),
  AnotaloAccent.indigo: AccentPalette(
    primary: Color(0xFF6B7BFF),
    primaryDark: Color(0xFF5564E0),
    primarySurface: Color(0x246B7BFF),
    primaryBorder: Color(0x666B7BFF),
    label: 'Índigo',
  ),
  AnotaloAccent.bosque: AccentPalette(
    primary: Color(0xFF5A8A6A),
    primaryDark: Color(0xFF457054),
    primarySurface: Color(0x245A8A6A),
    primaryBorder: Color(0x665A8A6A),
    label: 'Bosque',
  ),
  AnotaloAccent.oceano: AccentPalette(
    primary: Color(0xFF4A8FA8),
    primaryDark: Color(0xFF377589),
    primarySurface: Color(0x244A8FA8),
    primaryBorder: Color(0x664A8FA8),
    label: 'Océano',
  ),
  AnotaloAccent.violeta: AccentPalette(
    primary: Color(0xFF9B6BBB),
    primaryDark: Color(0xFF7F5399),
    primarySurface: Color(0x249B6BBB),
    primaryBorder: Color(0x669B6BBB),
    label: 'Violeta',
  ),
  AnotaloAccent.grafito: AccentPalette(
    primary: Color(0xFF6B7280),
    primaryDark: Color(0xFF4B5563),
    primarySurface: Color(0x246B7280),
    primaryBorder: Color(0x666B7280),
    label: 'Grafito',
  ),
};

/// Controlador del acento — ChangeNotifier simple para escuchar desde
/// MaterialApp y cualquier widget que quiera pintar en el acento vivo.
class AccentController extends ChangeNotifier {
  static const _key = 'user.accent';
  static final AccentController instance = AccentController._();
  AccentController._();

  AnotaloAccent _current = AnotaloAccent.terracota;

  AnotaloAccent get current => _current;
  AccentPalette get palette => accentPalettes[_current]!;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_key);
      if (stored != null) {
        _current = AnotaloAccent.values.firstWhere(
          (e) => e.name == stored,
          orElse: () => AnotaloAccent.terracota,
        );
        notifyListeners();
      }
    } catch (_) {
      // si falla, nos quedamos con el default
    }
  }

  Future<void> set(AnotaloAccent accent) async {
    if (_current == accent) return;
    _current = accent;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, accent.name);
    } catch (_) {}
  }
}
