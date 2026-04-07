import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../utils/json_utils.dart';

class WeeklyPlanService {
  final AppDatabase _db;
  WeeklyPlanService(this._db);

  static const _uuid = Uuid();

  Stream<WeeklyPlansTableData?> watchWeeklyPlan(String weekStart) {
    return (_db.select(_db.weeklyPlansTable)
      ..where((t) => t.weekStart.equals(weekStart)))
      .watchSingleOrNull();
  }

  Future<WeeklyPlansTableData> getOrCreatePlan(String weekStart, String weekEnd) async {
    final existing = await (_db.select(_db.weeklyPlansTable)
      ..where((t) => t.weekStart.equals(weekStart)))
      .getSingleOrNull();

    if (existing != null) return existing;

    final id = _uuid.v4();
    await _db.into(_db.weeklyPlansTable).insert(WeeklyPlansTableCompanion.insert(
      id: id,
      weekStart: weekStart,
      weekEnd: weekEnd,
      createdAt: DateTime.now(),
    ));

    return (await (_db.select(_db.weeklyPlansTable)
      ..where((t) => t.id.equals(id)))
      .getSingle());
  }

  Future<void> updatePrimordialGoals(String weekStart, List<String> goals) async {
    await (_db.update(_db.weeklyPlansTable)
      ..where((t) => t.weekStart.equals(weekStart)))
      .write(WeeklyPlansTableCompanion(
        primordialGoals: Value(encodeStringList(goals)),
      ));
  }

  Future<void> updateProjectFocus(String weekStart, List<String> projectIds) async {
    await (_db.update(_db.weeklyPlansTable)
      ..where((t) => t.weekStart.equals(weekStart)))
      .write(WeeklyPlansTableCompanion(
        projectFocus: Value(encodeStringList(projectIds)),
      ));
  }

  Future<void> updateReflection(String weekStart, String reflection) async {
    await (_db.update(_db.weeklyPlansTable)
      ..where((t) => t.weekStart.equals(weekStart)))
      .write(WeeklyPlansTableCompanion(
        reflection: Value(reflection),
      ));
  }

  List<String> decodePrimordialGoals(WeeklyPlansTableData? plan) {
    return decodeStringList(plan?.primordialGoals);
  }

  // Toggle completion of a goal - prepend/remove checkmark marker
  Future<void> toggleGoalCompletion(String weekStart, List<String> goals, int index) async {
    final updated = List<String>.from(goals);
    if (updated[index].startsWith('\u2713')) {
      updated[index] = updated[index].substring(1);
    } else {
      updated[index] = '\u2713${updated[index]}';
    }
    await updatePrimordialGoals(weekStart, updated);
  }

  // Helper to check if goal is done
  static bool isGoalDone(String goal) => goal.startsWith('\u2713');
  static String goalText(String goal) => goal.startsWith('\u2713') ? goal.substring(1) : goal;
}
