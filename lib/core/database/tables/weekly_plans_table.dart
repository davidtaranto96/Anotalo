import 'package:drift/drift.dart';

class WeeklyPlansTable extends Table {
  TextColumn get id              => text()();
  TextColumn get weekStart       => text()();
  TextColumn get weekEnd         => text()();
  TextColumn get primordialGoals => text().nullable()();
  TextColumn get projectFocus    => text().nullable()();
  TextColumn get reflection      => text().nullable()();
  BoolColumn get isComplete      => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt   => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
