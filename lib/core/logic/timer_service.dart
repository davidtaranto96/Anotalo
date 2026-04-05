import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../utils/format_utils.dart';
import '../../features/enfoque/domain/models/timer_state.dart';

class TimerService {
  final AppDatabase _db;
  TimerService(this._db);

  static const _uuid = Uuid();

  Future<void> saveSession({
    required TimerMode mode,
    required int durationSecs,
    required bool wasCompleted,
    String? taskId,
  }) async {
    final now = DateTime.now();
    await _db.into(_db.timerSessionsTable).insert(TimerSessionsTableCompanion.insert(
      id: _uuid.v4(),
      mode: mode.dbValue,
      taskId: Value(taskId),
      durationSecs: durationSecs,
      wasCompleted: wasCompleted,
      dayId: todayId(),
      startedAt: now.subtract(Duration(seconds: durationSecs)),
      finishedAt: Value(now),
    ));
  }

  Future<int> getTotalFocusMinutesToday() async {
    final rows = await (_db.select(_db.timerSessionsTable)
      ..where((t) => t.dayId.equals(todayId()) & t.wasCompleted.equals(true)))
      .get();
    final totalSecs = rows.fold<int>(0, (sum, r) => sum + r.durationSecs);
    return totalSecs ~/ 60;
  }
}
