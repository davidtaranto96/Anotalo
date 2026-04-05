import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../utils/format_utils.dart';
import '../../features/habitos/domain/models/habit.dart';

class HabitService {
  final AppDatabase _db;
  HabitService(this._db);

  static const _uuid = Uuid();

  Habit _habitFromRow(HabitsTableData row) => Habit(
    id: row.id,
    title: row.title,
    description: row.description,
    frequency: row.frequency == 'daily' ? HabitFrequency.daily : HabitFrequency.weekly,
    area: row.area,
    color: row.color,
    icon: row.icon,
    isArchived: row.isArchived,
    createdAt: row.createdAt,
  );

  HabitCompletion _completionFromRow(HabitCompletionsTableData row) => HabitCompletion(
    id: row.id,
    habitId: row.habitId,
    dayId: row.dayId,
    completedAt: row.completedAt,
  );

  Stream<List<Habit>> watchActiveHabits() {
    return (_db.select(_db.habitsTable)
      ..where((t) => t.isArchived.equals(false)))
      .watch()
      .map((rows) => rows.map(_habitFromRow).toList());
  }

  Stream<List<HabitCompletion>> watchCompletionsForDay(String dayId) {
    return (_db.select(_db.habitCompletionsTable)
      ..where((t) => t.dayId.equals(dayId)))
      .watch()
      .map((rows) => rows.map(_completionFromRow).toList());
  }

  Future<void> addHabit(Habit habit) async {
    await _db.into(_db.habitsTable).insert(HabitsTableCompanion.insert(
      id: habit.id.isEmpty ? _uuid.v4() : habit.id,
      title: habit.title,
      description: Value(habit.description),
      frequency: habit.frequency == HabitFrequency.daily ? 'daily' : 'weekly',
      area: Value(habit.area),
      color: Value(habit.color),
      icon: Value(habit.icon),
      createdAt: habit.createdAt,
    ));
  }

  Future<void> toggleCompletion(String habitId, String dayId) async {
    final existing = await (_db.select(_db.habitCompletionsTable)
      ..where((t) => t.habitId.equals(habitId) & t.dayId.equals(dayId)))
      .getSingleOrNull();

    if (existing != null) {
      await (_db.delete(_db.habitCompletionsTable)
        ..where((t) => t.id.equals(existing.id))).go();
    } else {
      await _db.into(_db.habitCompletionsTable).insert(
        HabitCompletionsTableCompanion.insert(
          id: _uuid.v4(),
          habitId: habitId,
          dayId: dayId,
          completedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<int> getStreak(String habitId) async {
    final completions = await (_db.select(_db.habitCompletionsTable)
      ..where((t) => t.habitId.equals(habitId))
      ..orderBy([(t) => OrderingTerm.desc(t.dayId)]))
      .get();

    if (completions.isEmpty) return 0;

    int streak = 0;
    DateTime expected = DateTime.now();

    for (final c in completions) {
      final cDate = idToDate(c.dayId);
      final expectedId = dateToId(expected);
      final yesterdayId = dateToId(expected.subtract(const Duration(days: 1)));

      if (c.dayId == expectedId || c.dayId == yesterdayId) {
        streak++;
        expected = cDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  Future<void> archiveHabit(String id) async {
    await (_db.update(_db.habitsTable)..where((t) => t.id.equals(id)))
        .write(const HabitsTableCompanion(isArchived: Value(true)));
  }

  Stream<List<HabitCompletion>> watchAllCompletionsForHabit(String habitId) {
    return (_db.select(_db.habitCompletionsTable)
      ..where((t) => t.habitId.equals(habitId))
      ..orderBy([(t) => OrderingTerm.desc(t.dayId)]))
      .watch()
      .map((rows) => rows.map(_completionFromRow).toList());
  }
}
