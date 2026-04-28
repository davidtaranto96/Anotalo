import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tasks_table.dart';
import 'tables/habits_table.dart';
import 'tables/habit_completions_table.dart';
import 'tables/projects_table.dart';
import 'tables/quick_notes_table.dart';
import 'tables/journal_entries_table.dart';
import 'tables/weekly_plans_table.dart';
import 'tables/week_days_table.dart';
import 'tables/timer_sessions_table.dart';
import 'tables/task_areas_table.dart';
import 'tables/daily_reviews_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  TasksTable,
  HabitsTable,
  HabitCompletionsTable,
  ProjectsTable,
  QuickNotesTable,
  JournalEntriesTable,
  WeeklyPlansTable,
  WeekDaysTable,
  TimerSessionsTable,
  TaskAreasTable,
  DailyReviewsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedBuiltinAreas();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(taskAreasTable);
        await m.createTable(dailyReviewsTable);
        await _seedBuiltinAreas();
      }
      if (from < 3) {
        // Hábitos N/semana + reordering. Las columnas son nullables-default
        // para que las filas existentes no se rompan al subir el schema.
        await m.addColumn(habitsTable, habitsTable.targetPerWeek);
        await m.addColumn(habitsTable, habitsTable.sortOrder);
        await m.addColumn(projectsTable, projectsTable.sortOrder);
        await m.addColumn(tasksTable, tasksTable.sortOrder);
      }
      if (from < 4) {
        // dayId pasa a nullable: las tareas de proyecto pueden estar
        // "sin programar". SQLite no permite cambiar nullability con
        // ALTER COLUMN, así que recreamos la tabla.
        await m.alterTable(TableMigration(tasksTable));
      }
      if (from < 5) {
        // QuickNotes: agrego isPinned para fijar notas estilo Keep.
        await m.addColumn(quickNotesTable, quickNotesTable.isPinned);
      }
    },
    beforeOpen: (details) async {
      // Defensive: if the areas table exists but is empty (e.g. an old
      // restore wiped it), re-seed defaults so the UI has something to show.
      final count = await (selectOnly(taskAreasTable)
            ..addColumns([taskAreasTable.id.count()]))
          .getSingleOrNull();
      final total = count?.read(taskAreasTable.id.count()) ?? 0;
      if (total == 0) {
        await _seedBuiltinAreas();
      }
    },
  );

  Future<void> _seedBuiltinAreas() async {
    final now = DateTime.now();
    final defaults = [
      ('trabajo',  'Trabajo',  '\u{1F4BC}', '#5B7E9E', 0),
      ('estudio',  'Facultad', '\u{1F4DA}', '#7B5EA7', 1),
      ('personal', 'Personal', '\u{1F3E0}', '#5B8A5E', 2),
      ('casa',     'Casa',     '\u{1F3E1}', '#C4963A', 3),
      ('salud',    'Salud',    '\u{1F3E5}', '#C44B4B', 4),
    ];
    for (final d in defaults) {
      await into(taskAreasTable).insertOnConflictUpdate(
        TaskAreasTableCompanion.insert(
          id: d.$1,
          label: d.$2,
          emoji: Value(d.$3),
          colorHex: d.$4,
          sortOrder: Value(d.$5),
          isBuiltin: const Value(true),
          createdAt: now,
        ),
      );
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'arquitectura_enfoque.db'));
    return NativeDatabase.createInBackground(file);
  });
}
