import 'package:flutter/material.dart';

import '../database/app_database.dart';

/// In-memory representation of a task area (category).
///
/// Hydrated either from [TaskAreasTableData] rows at runtime, or from the
/// [kBuiltinAreas] list when no DB is available (tests, early startup).
class TaskArea {
  final String id;
  final String label;
  final String emoji;
  final Color color;
  final IconData? icon;
  final int sortOrder;
  final bool isBuiltin;

  const TaskArea({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    this.icon,
    this.sortOrder = 0,
    this.isBuiltin = false,
  });

  factory TaskArea.fromRow(TaskAreasTableData row) => TaskArea(
        id: row.id,
        label: row.label,
        emoji: row.emoji,
        color: _parseHex(row.colorHex),
        icon: _iconFromName(row.iconName),
        sortOrder: row.sortOrder,
        isBuiltin: row.isBuiltin,
      );
}

/// The 5 built-in areas. Kept as a constant so code paths that can't easily
/// reach the DB (task parser, early boot) still have sensible defaults.
const List<TaskArea> kBuiltinAreas = [
  TaskArea(id: 'trabajo',  label: 'Trabajo',  emoji: '\u{1F4BC}', color: Color(0xFF5B7E9E), sortOrder: 0, isBuiltin: true),
  TaskArea(id: 'estudio',  label: 'Facultad', emoji: '\u{1F4DA}', color: Color(0xFF7B5EA7), sortOrder: 1, isBuiltin: true),
  TaskArea(id: 'personal', label: 'Personal', emoji: '\u{1F3E0}', color: Color(0xFF5B8A5E), sortOrder: 2, isBuiltin: true),
  TaskArea(id: 'casa',     label: 'Casa',     emoji: '\u{1F3E1}', color: Color(0xFFC4963A), sortOrder: 3, isBuiltin: true),
  TaskArea(id: 'salud',    label: 'Salud',    emoji: '\u{1F3E5}', color: Color(0xFFC44B4B), sortOrder: 4, isBuiltin: true),
];

/// Back-compat alias — many widgets import `kTaskAreas`.
const List<TaskArea> kTaskAreas = kBuiltinAreas;

/// Synchronous lookup against the built-in list. Use [getTaskAreaFrom] to
/// resolve against the user's current (possibly-edited) DB list.
TaskArea? getTaskArea(String? areaId) => getTaskAreaFrom(kBuiltinAreas, areaId);

/// Look up an area by id inside an arbitrary list (e.g. one watched from
/// the DB stream). Returns null if not found or id is null.
TaskArea? getTaskAreaFrom(List<TaskArea> areas, String? areaId) {
  if (areaId == null) return null;
  for (final a in areas) {
    if (a.id == areaId) return a;
  }
  return null;
}

/// Color palette offered by the edit-area sheet.
const List<Color> kAreaColorPalette = [
  Color(0xFF5B7E9E), // azul acero
  Color(0xFF7B5EA7), // violeta
  Color(0xFF5B8A5E), // verde musgo
  Color(0xFFC4963A), // ambar
  Color(0xFFC44B4B), // rojo
  Color(0xFF3A8DAD), // turquesa
  Color(0xFFD97757), // naranja terracota
  Color(0xFF8B6B4A), // marron
  Color(0xFF5A6773), // gris pizarra
  Color(0xFFB85C8F), // rosa vino
  Color(0xFF4A7F6F), // verde bosque
  Color(0xFF9C7F3B), // mostaza
];

Color _parseHex(String hex) {
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  final v = int.tryParse(h, radix: 16);
  return v == null ? const Color(0xFF5B7E9E) : Color(v);
}

String colorToHex(Color c) {
  final a = (c.a * 255).round() & 0xff;
  final r = (c.r * 255).round() & 0xff;
  final g = (c.g * 255).round() & 0xff;
  final b = (c.b * 255).round() & 0xff;
  // Drop alpha for storage (areas don't use alpha).
  final _ = a;
  final rr = r.toRadixString(16).padLeft(2, '0');
  final gg = g.toRadixString(16).padLeft(2, '0');
  final bb = b.toRadixString(16).padLeft(2, '0');
  return '#$rr$gg$bb'.toUpperCase();
}

IconData? _iconFromName(String? name) {
  if (name == null) return null;
  return kAreaIconChoices[name];
}

/// Optional named-icon palette users can attach to an area.
/// (Icons are `IconData` instances; they must be const because Flutter trees
/// through `--tree-shake-icons` — use only icons that will always be kept.)
const Map<String, IconData> kAreaIconChoices = {
  'work': Icons.work_rounded,
  'school': Icons.school_rounded,
  'home': Icons.home_rounded,
  'favorite': Icons.favorite_rounded,
  'hospital': Icons.local_hospital_rounded,
  'fitness': Icons.fitness_center_rounded,
  'book': Icons.book_rounded,
  'money': Icons.attach_money_rounded,
  'travel': Icons.flight_rounded,
  'shopping': Icons.shopping_bag_rounded,
  'music': Icons.music_note_rounded,
  'code': Icons.code_rounded,
  'restaurant': Icons.restaurant_rounded,
  'pets': Icons.pets_rounded,
  'palette': Icons.palette_rounded,
  'star': Icons.star_rounded,
};
