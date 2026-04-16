import '../models/task_area.dart';
import '../utils/format_utils.dart';
import '../../features/hoy/domain/models/task.dart';

/// Result of parsing natural-language task text.
class ParsedTask {
  final String cleanTitle;
  final String? dayId;            // yyyy-MM-dd if detected
  final String? scheduledTime;    // "HH:mm" if detected
  final TaskPriority? priority;
  final String? areaId;
  final String? projectMatchId;   // if a project title matched

  const ParsedTask({
    required this.cleanTitle,
    this.dayId,
    this.scheduledTime,
    this.priority,
    this.areaId,
    this.projectMatchId,
  });

  bool get hasDetections =>
      dayId != null || scheduledTime != null || priority != null || areaId != null || projectMatchId != null;
}

/// Parses free-form Spanish text into structured task fields.
/// Everything is heuristic and local — no API calls.
class TaskParser {
  /// [projects] is a map of lowercase project title → project id,
  /// used to suggest attachment to an existing project when the title mentions it.
  static ParsedTask parse(
    String raw, {
    Map<String, String> projects = const {},
    DateTime? now,
  }) {
    final n = now ?? DateTime.now();
    var text = ' ${raw.toLowerCase()} ';
    var stripped = ' $raw ';

    String? dayId;
    String? time;
    TaskPriority? priority;
    String? areaId;
    String? projectId;

    // ── Date keywords ────────────────────────────────────────────────
    final dateMatches = <RegExp, DateTime Function()>{
      RegExp(r'\bpasado mañana\b'): () => n.add(const Duration(days: 2)),
      RegExp(r'\bmañana\b'): () => n.add(const Duration(days: 1)),
      RegExp(r'\bhoy\b'): () => n,
      RegExp(r'\bayer\b'): () => n.subtract(const Duration(days: 1)),
    };
    for (final entry in dateMatches.entries) {
      if (entry.key.hasMatch(text)) {
        dayId = dateToId(entry.value());
        text = text.replaceAll(entry.key, ' ');
        stripped = stripped.replaceAll(RegExp(entry.key.pattern, caseSensitive: false), ' ');
        break;
      }
    }

    // Weekday: "el lunes", "el martes", etc.  Picks next occurrence.
    if (dayId == null) {
      const weekdays = {
        'lunes': DateTime.monday, 'martes': DateTime.tuesday,
        'miércoles': DateTime.wednesday, 'miercoles': DateTime.wednesday,
        'jueves': DateTime.thursday, 'viernes': DateTime.friday,
        'sábado': DateTime.saturday, 'sabado': DateTime.saturday,
        'domingo': DateTime.sunday,
      };
      for (final w in weekdays.entries) {
        final pattern = RegExp('\\b(?:el |este )?${w.key}\\b');
        if (pattern.hasMatch(text)) {
          final target = w.value;
          var d = n;
          while (d.weekday != target) {
            d = d.add(const Duration(days: 1));
          }
          dayId = dateToId(d);
          text = text.replaceAll(pattern, ' ');
          stripped = stripped.replaceAll(RegExp(pattern.pattern, caseSensitive: false), ' ');
          break;
        }
      }
    }

    // ── Time ─────────────────────────────────────────────────────────
    // "a las 15", "a las 15:30", "a las 3pm", "a las 3 pm"
    final timeAt = RegExp(r'\ba las (\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b');
    final mAt = timeAt.firstMatch(text);
    if (mAt != null) {
      var h = int.parse(mAt.group(1)!);
      final min = int.tryParse(mAt.group(2) ?? '0') ?? 0;
      final ampm = mAt.group(3);
      if (ampm == 'pm' && h < 12) h += 12;
      if (ampm == 'am' && h == 12) h = 0;
      time = '${h.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
      text = text.replaceFirst(timeAt, ' ');
      stripped = stripped.replaceFirst(RegExp(timeAt.pattern, caseSensitive: false), ' ');
    } else {
      // "15:30" / "3pm" standalone
      final t2 = RegExp(r'\b(\d{1,2}):(\d{2})\b').firstMatch(text);
      if (t2 != null) {
        final h = int.parse(t2.group(1)!);
        final min = int.parse(t2.group(2)!);
        if (h < 24 && min < 60) {
          time = '${h.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
          text = text.replaceFirst(t2.group(0)!, ' ');
          stripped = stripped.replaceFirst(RegExp.escape(t2.group(0)!), ' ').replaceAll(RegExp(r'\s+'), ' ');
        }
      } else {
        final t3 = RegExp(r'\b(\d{1,2})\s*(am|pm)\b').firstMatch(text);
        if (t3 != null) {
          var h = int.parse(t3.group(1)!);
          final ampm = t3.group(2);
          if (ampm == 'pm' && h < 12) h += 12;
          if (ampm == 'am' && h == 12) h = 0;
          time = '${h.toString().padLeft(2, '0')}:00';
          text = text.replaceFirst(t3.group(0)!, ' ');
          stripped = stripped.replaceFirst(RegExp.escape(t3.group(0)!), ' ').replaceAll(RegExp(r'\s+'), ' ');
        }
      }
    }

    // ── Priority ─────────────────────────────────────────────────────
    final priorityMap = <RegExp, TaskPriority>{
      RegExp(r'\b(urgente|urgentísim[oa]|urgentisim[oa]|crítico|critico)\b'): TaskPriority.primordial,
      RegExp(r'!{3,}'): TaskPriority.primordial,
      RegExp(r'\b(importante|prioritari[oa])\b'): TaskPriority.importante,
      RegExp(r'!{2}'): TaskPriority.importante,
      RegExp(r'\b(cuando pueda|sin apuro|tranqui[lo]*|después|despues)\b'): TaskPriority.puedeEsperar,
    };
    for (final e in priorityMap.entries) {
      if (e.key.hasMatch(text)) {
        priority = e.value;
        text = text.replaceAll(e.key, ' ');
        stripped = stripped.replaceAll(RegExp(e.key.pattern, caseSensitive: false), ' ');
        break;
      }
    }

    // ── Area ─────────────────────────────────────────────────────────
    // Match area label ("trabajo", "casa", "salud", "personal", "facultad")
    // or area-implying keywords ("médico" → salud, "reunión" → trabajo, "tarea/parcial" → estudio).
    final areaHints = <String, String>{
      'trabajo': 'trabajo', 'oficina': 'trabajo', 'reunión': 'trabajo', 'reunion': 'trabajo', 'jefe': 'trabajo',
      'facultad': 'estudio', 'estudio': 'estudio', 'estudiar': 'estudio', 'parcial': 'estudio', 'examen': 'estudio',
      'casa': 'casa', 'comprar': 'casa', 'limpiar': 'casa',
      'salud': 'salud', 'médico': 'salud', 'medico': 'salud', 'doctor': 'salud', 'dentista': 'salud', 'turno': 'salud',
      'personal': 'personal', 'familia': 'personal', 'amigos': 'personal',
    };
    for (final hint in areaHints.entries) {
      final pat = RegExp('\\b${hint.key}\\b');
      if (pat.hasMatch(text)) {
        final match = getTaskArea(hint.value);
        if (match != null) {
          areaId = match.id;
          // Do NOT remove the hint word if it's content-bearing (keep "médico" in title).
          // Only remove when it's an explicit area tag like "trabajo", "casa", "facultad".
          if ({'trabajo', 'facultad', 'estudio', 'casa', 'salud', 'personal', 'oficina'}.contains(hint.key)) {
            // leave in title; area is just a hint
          }
          break;
        }
      }
    }

    // ── Project match ────────────────────────────────────────────────
    // If any project title appears as a whole word, attach.
    for (final p in projects.entries) {
      if (p.key.length < 3) continue;
      if (RegExp('\\b${RegExp.escape(p.key)}\\b').hasMatch(text)) {
        projectId = p.value;
        break;
      }
    }

    // ── Clean title ──────────────────────────────────────────────────
    final clean = stripped
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return ParsedTask(
      cleanTitle: clean.isEmpty ? raw.trim() : _capitalize(clean),
      dayId: dayId,
      scheduledTime: time,
      priority: priority,
      areaId: areaId,
      projectMatchId: projectId,
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
