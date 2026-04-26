import 'package:drift/drift.dart';

class ProjectsTable extends Table {
  TextColumn get id          => text()();
  TextColumn get title       => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category    => text()();
  TextColumn get status      => text().withDefault(const Constant('active'))();
  TextColumn get color       => text()();
  TextColumn get icon        => text().nullable()();
  TextColumn get targetDate  => text().nullable()();
  TextColumn get taskIds     => text().nullable()();
  TextColumn get weeklyGoals => text().nullable()();
  TextColumn get notes       => text().nullable()();
  // Orden manual del usuario (drag-and-drop reordering en Proyectos).
  IntColumn  get sortOrder   => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt   => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
