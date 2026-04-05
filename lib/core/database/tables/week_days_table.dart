import 'package:drift/drift.dart';

class WeekDaysTable extends Table {
  TextColumn get dayId         => text()();
  TextColumn get weekId        => text()();
  TextColumn get signalTaskIds => text().nullable()();
  TextColumn get noiseTaskIds  => text().nullable()();

  @override
  Set<Column> get primaryKey => {dayId};
}
