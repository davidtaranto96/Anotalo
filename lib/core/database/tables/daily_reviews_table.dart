import 'package:drift/drift.dart';

/// End-of-day review: recap of tasks, habits, journal-like mood entry.
///
/// One row per `dayId`. While `completedAt` is null, the review is "open"
/// and the user can still edit it. Once completed, it locks (but can be
/// re-opened for editing from the history view).
class DailyReviewsTable extends Table {
  TextColumn get id             => text()();
  TextColumn get dayId          => text()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn  get mood           => integer().nullable()(); // 1..5
  TextColumn get moodNote       => text().nullable()();
  BoolColumn get smoked         => boolean().nullable()();
  BoolColumn get tookMedication => boolean().nullable()();
  TextColumn get patterns       => text().nullable()(); // free-form "lo que noté"
  TextColumn get highlights     => text().nullable()(); // "lo mejor del día"
  DateTimeColumn get createdAt  => dateTime()();
  DateTimeColumn get updatedAt  => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {dayId},
      ];
}
