import 'package:drift/drift.dart';

class HabitCompletionsTable extends Table {
  TextColumn get id        => text()();
  TextColumn get habitId   => text()();
  TextColumn get dayId     => text()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
