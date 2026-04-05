import 'package:drift/drift.dart';

class HabitsTable extends Table {
  TextColumn get id          => text()();
  TextColumn get title       => text()();
  TextColumn get description => text().nullable()();
  TextColumn get frequency   => text()();
  TextColumn get area        => text().nullable()();
  TextColumn get color       => text().nullable()();
  TextColumn get icon        => text().nullable()();
  BoolColumn get isArchived  => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
