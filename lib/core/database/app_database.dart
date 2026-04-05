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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    onUpgrade: (m, from, to) async {},
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'arquitectura_enfoque.db'));
    return NativeDatabase.createInBackground(file);
  });
}
