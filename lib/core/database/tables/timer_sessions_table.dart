import 'package:drift/drift.dart';

class TimerSessionsTable extends Table {
  TextColumn get id           => text()();
  TextColumn get mode         => text()();
  TextColumn get taskId       => text().nullable()();
  IntColumn  get durationSecs => integer()();
  BoolColumn get wasCompleted => boolean()();
  TextColumn get dayId        => text()();
  DateTimeColumn get startedAt  => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
