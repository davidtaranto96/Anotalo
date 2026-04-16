import 'package:drift/drift.dart';

/// User-editable task areas (categories).
///
/// Seeded with 5 defaults (`trabajo`, `estudio`, `personal`, `casa`, `salud`)
/// so existing tasks keep resolving after the migration. Users can add new
/// ones, rename/recolor any, reorder, and delete non-builtin entries.
class TaskAreasTable extends Table {
  TextColumn get id          => text()();
  TextColumn get label       => text()();
  TextColumn get emoji       => text().withDefault(const Constant(''))();
  TextColumn get colorHex    => text()(); // "#RRGGBB"
  TextColumn get iconName    => text().nullable()(); // material icon name (optional)
  IntColumn  get sortOrder   => integer().withDefault(const Constant(0))();
  BoolColumn get isBuiltin   => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
