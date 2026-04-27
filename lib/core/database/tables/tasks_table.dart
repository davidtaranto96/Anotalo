import 'package:drift/drift.dart';

class TasksTable extends Table {
  TextColumn get id              => text()();
  TextColumn get title           => text()();
  TextColumn get description     => text().nullable()();
  TextColumn get priority        => text().withDefault(const Constant('puede_esperar'))();
  TextColumn get status          => text().withDefault(const Constant('pending'))();
  TextColumn get action          => text().nullable()();
  TextColumn get area            => text().nullable()();
  TextColumn get delegatedTo     => text().nullable()();
  TextColumn get deferredTo      => text().nullable()();
  TextColumn get scheduledDate   => text().nullable()();
  TextColumn get reminder        => text().nullable()();
  TextColumn get parentProjectId => text().nullable()();
  TextColumn get subtaskIds      => text().nullable()();
  // Nullable: las tareas que pertenecen a un proyecto pueden estar
  // "sin programar" hasta que el usuario les ponga fecha. Las tareas
  // sueltas siempre tienen dayId (se asigna a today por default).
  TextColumn get dayId           => text().nullable()();
  IntColumn  get estimatedMinutes => integer().nullable()();
  // Orden manual del usuario dentro de la lista de Hoy/área (drag).
  IntColumn  get sortOrder       => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt   => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
