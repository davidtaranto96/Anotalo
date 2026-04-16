import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../../features/revision/domain/models/daily_review.dart';

/// Manages the per-day review objects (mood, patterns, smoked, medication).
/// One-per-day uniqueness is enforced by the table's unique key on `dayId`.
class DailyReviewService {
  final AppDatabase _db;
  final _uuid = const Uuid();
  DailyReviewService(this._db);

  /// Watches every review, newest day first. History view lives on this.
  Stream<List<DailyReview>> watchAll() {
    final query = _db.select(_db.dailyReviewsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.dayId)]);
    return query.watch().map((rows) => rows.map(DailyReview.fromRow).toList());
  }

  /// Watches a single day's review (or emits null if none exists yet).
  Stream<DailyReview?> watchByDay(String dayId) {
    final query = _db.select(_db.dailyReviewsTable)
      ..where((t) => t.dayId.equals(dayId))
      ..limit(1);
    return query.watchSingleOrNull().map(
          (row) => row == null ? null : DailyReview.fromRow(row),
        );
  }

  Future<DailyReview?> getByDayOnce(String dayId) async {
    final row = await (_db.select(_db.dailyReviewsTable)
          ..where((t) => t.dayId.equals(dayId))
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : DailyReview.fromRow(row);
  }

  /// Creates an empty (not-yet-completed) review for [dayId] if none exists,
  /// otherwise returns the existing one.
  Future<DailyReview> getOrCreate(String dayId) async {
    final existing = await getByDayOnce(dayId);
    if (existing != null) return existing;
    final now = DateTime.now();
    final id = _uuid.v4();
    await _db.into(_db.dailyReviewsTable).insert(
          DailyReviewsTableCompanion.insert(
            id: id,
            dayId: dayId,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (await getByDayOnce(dayId))!;
  }

  Future<void> update(
    String id, {
    int? mood,
    String? moodNote,
    bool? smoked,
    bool? tookMedication,
    String? patterns,
    String? highlights,
    bool clearMood = false,
    bool clearSmoked = false,
    bool clearMedication = false,
  }) async {
    await (_db.update(_db.dailyReviewsTable)..where((t) => t.id.equals(id))).write(
      DailyReviewsTableCompanion(
        mood: clearMood
            ? const Value(null)
            : (mood == null ? const Value.absent() : Value(mood)),
        moodNote: moodNote == null ? const Value.absent() : Value(moodNote),
        smoked: clearSmoked
            ? const Value(null)
            : (smoked == null ? const Value.absent() : Value(smoked)),
        tookMedication: clearMedication
            ? const Value(null)
            : (tookMedication == null
                ? const Value.absent()
                : Value(tookMedication)),
        patterns: patterns == null ? const Value.absent() : Value(patterns),
        highlights: highlights == null ? const Value.absent() : Value(highlights),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markCompleted(String id) async {
    await (_db.update(_db.dailyReviewsTable)..where((t) => t.id.equals(id))).write(
      DailyReviewsTableCompanion(
        completedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Re-opens a completed review for editing.
  Future<void> reopen(String id) async {
    await (_db.update(_db.dailyReviewsTable)..where((t) => t.id.equals(id))).write(
      DailyReviewsTableCompanion(
        completedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.dailyReviewsTable)..where((t) => t.id.equals(id))).go();
  }
}
