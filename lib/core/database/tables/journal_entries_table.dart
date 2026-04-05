import 'package:drift/drift.dart';

class JournalEntriesTable extends Table {
  TextColumn get id              => text()();
  TextColumn get dayId           => text()();
  TextColumn get reflection      => text()();
  IntColumn  get mood            => integer().nullable()();
  TextColumn get gratitude       => text().nullable()();
  TextColumn get lessonsLearned  => text().nullable()();
  TextColumn get tomorrowFocus   => text().nullable()();
  DateTimeColumn get createdAt   => dateTime()();
  DateTimeColumn get updatedAt   => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
