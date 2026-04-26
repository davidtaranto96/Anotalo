import 'package:drift/drift.dart';

class HabitsTable extends Table {
  TextColumn get id          => text()();
  TextColumn get title       => text()();
  TextColumn get description => text().nullable()();
  // 'daily' = todos los días; 'weekly' = N veces por semana (lunes a domingo).
  TextColumn get frequency   => text()();
  // Sólo usado si frequency == 'weekly'. 1..7. Para 'daily' es ignorado.
  IntColumn  get targetPerWeek => integer().withDefault(const Constant(1))();
  TextColumn get area        => text().nullable()();
  TextColumn get color       => text().nullable()();
  TextColumn get icon        => text().nullable()();
  BoolColumn get isArchived  => boolean().withDefault(const Constant(false))();
  // Orden manual definido por el usuario (drag-and-drop). Más bajo = más arriba.
  IntColumn  get sortOrder   => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
