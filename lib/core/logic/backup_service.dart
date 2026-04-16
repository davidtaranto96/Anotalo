import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../database/app_database.dart';

/// Full-database JSON export / import.
///
/// Serialises every table via Drift's generated `toJson()` / `fromJson()`.
/// The file is plain JSON so the user can open it, diff it, or inspect it
/// without needing the app.
///
/// Import semantics: **destructive** — wipes each table before inserting
/// the backup rows (matches what the user expects from "Restaurar backup").
class BackupService {
  final AppDatabase _db;
  BackupService(this._db);

  static const int _backupVersion = 2;

  /// Produce a JSON string that encodes every row in every table.
  Future<String> exportToJson() async {
    final tasks = await _db.select(_db.tasksTable).get();
    final habits = await _db.select(_db.habitsTable).get();
    final habitCompletions =
        await _db.select(_db.habitCompletionsTable).get();
    final projects = await _db.select(_db.projectsTable).get();
    final quickNotes = await _db.select(_db.quickNotesTable).get();
    final journalEntries = await _db.select(_db.journalEntriesTable).get();
    final weeklyPlans = await _db.select(_db.weeklyPlansTable).get();
    final weekDays = await _db.select(_db.weekDaysTable).get();
    final timerSessions = await _db.select(_db.timerSessionsTable).get();
    final taskAreas = await _db.select(_db.taskAreasTable).get();
    final dailyReviews = await _db.select(_db.dailyReviewsTable).get();

    final payload = <String, dynamic>{
      'app': 'Anotalo',
      'version': _backupVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'counts': {
        'tasks': tasks.length,
        'habits': habits.length,
        'habitCompletions': habitCompletions.length,
        'projects': projects.length,
        'quickNotes': quickNotes.length,
        'journalEntries': journalEntries.length,
        'weeklyPlans': weeklyPlans.length,
        'weekDays': weekDays.length,
        'timerSessions': timerSessions.length,
        'taskAreas': taskAreas.length,
        'dailyReviews': dailyReviews.length,
      },
      'tables': {
        'tasks': tasks.map((r) => r.toJson()).toList(),
        'habits': habits.map((r) => r.toJson()).toList(),
        'habitCompletions':
            habitCompletions.map((r) => r.toJson()).toList(),
        'projects': projects.map((r) => r.toJson()).toList(),
        'quickNotes': quickNotes.map((r) => r.toJson()).toList(),
        'journalEntries':
            journalEntries.map((r) => r.toJson()).toList(),
        'weeklyPlans': weeklyPlans.map((r) => r.toJson()).toList(),
        'weekDays': weekDays.map((r) => r.toJson()).toList(),
        'timerSessions':
            timerSessions.map((r) => r.toJson()).toList(),
        'taskAreas': taskAreas.map((r) => r.toJson()).toList(),
        'dailyReviews': dailyReviews.map((r) => r.toJson()).toList(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Writes the export to a temp file with a timestamped name and returns
  /// the file handle. The caller is responsible for sharing/moving it.
  Future<File> createBackupFile() async {
    final jsonStr = await exportToJson();
    final dir = await getTemporaryDirectory();
    final stamp = _timestamp();
    final file = File(p.join(dir.path, 'anotalo-backup-$stamp.json'));
    await file.writeAsString(jsonStr, flush: true);
    return file;
  }

  /// On Android: saves the backup directly to the public Downloads folder
  /// (`/storage/emulated/0/Download/`). Requests storage permission first.
  /// Returns the saved file. Throws if permission denied or path unwritable.
  Future<File> saveBackupToDownloads() async {
    if (!Platform.isAndroid) {
      // On other platforms, fall back to the temp file path.
      return createBackupFile();
    }

    final granted = await _ensureStoragePermission();
    if (!granted) {
      throw const _BackupPermissionException(
          'Necesito permiso de almacenamiento para guardar el backup en Descargas.');
    }

    final downloads = Directory('/storage/emulated/0/Download');
    if (!await downloads.exists()) {
      await downloads.create(recursive: true);
    }

    final jsonStr = await exportToJson();
    final stamp = _timestamp();
    final file = File(p.join(downloads.path, 'anotalo-backup-$stamp.json'));
    await file.writeAsString(jsonStr, flush: true);
    return file;
  }

  /// On Android: finds the most recent `anotalo-backup-*.json` in Downloads.
  /// Returns null if none or on non-Android platforms.
  Future<File?> findLatestBackupInDownloads() async {
    if (!Platform.isAndroid) return null;
    final granted = await _ensureStoragePermission();
    if (!granted) return null;

    final downloads = Directory('/storage/emulated/0/Download');
    if (!await downloads.exists()) return null;

    final matches = <File>[];
    await for (final entry in downloads.list(followLinks: false)) {
      if (entry is! File) continue;
      final name = p.basename(entry.path);
      if (name.startsWith('anotalo-backup-') && name.endsWith('.json')) {
        matches.add(entry);
      }
    }
    if (matches.isEmpty) return null;
    matches.sort((a, b) =>
        b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return matches.first;
  }

  /// Requests the best-available storage permission for writing to Downloads.
  /// On Android 11+ this is `MANAGE_EXTERNAL_STORAGE`; on older, `storage`.
  Future<bool> _ensureStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Try MANAGE_EXTERNAL_STORAGE first (Android 11+).
    if (await Permission.manageExternalStorage.isGranted) return true;
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) return true;

    // Fall back to legacy storage permission (Android 10 and below).
    if (await Permission.storage.isGranted) return true;
    status = await Permission.storage.request();
    return status.isGranted;
  }

  String _timestamp() => DateTime.now()
      .toIso8601String()
      .substring(0, 19)
      .replaceAll(':', '-')
      .replaceAll('T', '_');

  /// Summary of a backup payload — rendered in the confirm dialog so the
  /// user knows what they're about to overwrite.
  BackupSummary? summarizeJson(String jsonStr) {
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (map['app'] != 'Anotalo') return null;
      final counts = (map['counts'] as Map?)?.cast<String, dynamic>() ?? {};
      return BackupSummary(
        version: (map['version'] as int?) ?? 0,
        createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
        tasks: (counts['tasks'] as int?) ?? 0,
        habits: (counts['habits'] as int?) ?? 0,
        habitCompletions: (counts['habitCompletions'] as int?) ?? 0,
        projects: (counts['projects'] as int?) ?? 0,
        quickNotes: (counts['quickNotes'] as int?) ?? 0,
        journalEntries: (counts['journalEntries'] as int?) ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  /// Wipes every table, then inserts every row from the backup. Runs inside
  /// a transaction so a mid-restore crash leaves the DB untouched.
  Future<void> importFromJson(String jsonStr) async {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    if (map['app'] != 'Anotalo') {
      throw const FormatException('No es un backup de Anotalo');
    }
    final tables = (map['tables'] as Map).cast<String, dynamic>();

    List<Map<String, dynamic>> rows(String key) {
      final list = tables[key];
      if (list is! List) return const [];
      return list
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    }

    await _db.transaction(() async {
      // Clear everything first — explicit about the destructive nature.
      await _db.delete(_db.dailyReviewsTable).go();
      await _db.delete(_db.timerSessionsTable).go();
      await _db.delete(_db.weekDaysTable).go();
      await _db.delete(_db.weeklyPlansTable).go();
      await _db.delete(_db.journalEntriesTable).go();
      await _db.delete(_db.quickNotesTable).go();
      await _db.delete(_db.projectsTable).go();
      await _db.delete(_db.habitCompletionsTable).go();
      await _db.delete(_db.habitsTable).go();
      await _db.delete(_db.tasksTable).go();
      await _db.delete(_db.taskAreasTable).go();

      // Re-insert each table from JSON. If the backup is v1 (no areas/reviews),
      // re-seed the built-in areas so the UI doesn't start empty.
      final areaRows = rows('taskAreas');
      if (areaRows.isEmpty) {
        final now = DateTime.now();
        for (final seed in const [
          ('trabajo',  'Trabajo',  '\u{1F4BC}', '#5B7E9E', 0),
          ('estudio',  'Facultad', '\u{1F4DA}', '#7B5EA7', 1),
          ('personal', 'Personal', '\u{1F3E0}', '#5B8A5E', 2),
          ('casa',     'Casa',     '\u{1F3E1}', '#C4963A', 3),
          ('salud',    'Salud',    '\u{1F3E5}', '#C44B4B', 4),
        ]) {
          await _db.into(_db.taskAreasTable).insert(
                TaskAreasTableCompanion.insert(
                  id: seed.$1,
                  label: seed.$2,
                  emoji: Value(seed.$3),
                  colorHex: seed.$4,
                  sortOrder: Value(seed.$5),
                  isBuiltin: const Value(true),
                  createdAt: now,
                ),
              );
        }
      } else {
        for (final row in areaRows) {
          await _db
              .into(_db.taskAreasTable)
              .insert(TaskAreasTableData.fromJson(row));
        }
      }
      for (final row in rows('tasks')) {
        await _db
            .into(_db.tasksTable)
            .insert(TasksTableData.fromJson(row));
      }
      for (final row in rows('habits')) {
        await _db
            .into(_db.habitsTable)
            .insert(HabitsTableData.fromJson(row));
      }
      for (final row in rows('habitCompletions')) {
        await _db
            .into(_db.habitCompletionsTable)
            .insert(HabitCompletionsTableData.fromJson(row));
      }
      for (final row in rows('projects')) {
        await _db
            .into(_db.projectsTable)
            .insert(ProjectsTableData.fromJson(row));
      }
      for (final row in rows('quickNotes')) {
        await _db
            .into(_db.quickNotesTable)
            .insert(QuickNotesTableData.fromJson(row));
      }
      for (final row in rows('journalEntries')) {
        await _db
            .into(_db.journalEntriesTable)
            .insert(JournalEntriesTableData.fromJson(row));
      }
      for (final row in rows('weeklyPlans')) {
        await _db
            .into(_db.weeklyPlansTable)
            .insert(WeeklyPlansTableData.fromJson(row));
      }
      for (final row in rows('weekDays')) {
        await _db
            .into(_db.weekDaysTable)
            .insert(WeekDaysTableData.fromJson(row));
      }
      for (final row in rows('timerSessions')) {
        await _db
            .into(_db.timerSessionsTable)
            .insert(TimerSessionsTableData.fromJson(row));
      }
      for (final row in rows('dailyReviews')) {
        await _db
            .into(_db.dailyReviewsTable)
            .insert(DailyReviewsTableData.fromJson(row));
      }
    });
  }
}

class BackupSummary {
  final int version;
  final DateTime? createdAt;
  final int tasks;
  final int habits;
  final int habitCompletions;
  final int projects;
  final int quickNotes;
  final int journalEntries;

  const BackupSummary({
    required this.version,
    required this.createdAt,
    required this.tasks,
    required this.habits,
    required this.habitCompletions,
    required this.projects,
    required this.quickNotes,
    required this.journalEntries,
  });
}

/// Thrown by [BackupService] when the user denied the storage permission.
class _BackupPermissionException implements Exception {
  final String message;
  const _BackupPermissionException(this.message);
  @override
  String toString() => message;
}
