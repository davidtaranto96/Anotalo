import 'package:drift/drift.dart';

class QuickNotesTable extends Table {
  TextColumn get id                   => text()();
  TextColumn get content              => text()();
  TextColumn get type                 => text().withDefault(const Constant('general'))();
  BoolColumn get isProcessed          => boolean().withDefault(const Constant(false))();
  TextColumn get processedToType      => text().nullable()();
  TextColumn get processedToTargetId  => text().nullable()();
  TextColumn get tags                 => text().nullable()();
  /// Notas fijadas aparecen al tope de la lista (estilo Keep). Default
  /// false. Agregado en schema v5.
  BoolColumn get isPinned             => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt        => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
