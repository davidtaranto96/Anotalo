import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../models/task_area.dart';

/// CRUD + ordering for user-editable task areas.
class TaskAreaService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  TaskAreaService(this._db);

  /// Streams all areas ordered by `sortOrder` then label.
  Stream<List<TaskArea>> watchAreas() {
    final query = _db.select(_db.taskAreasTable)
      ..orderBy([
        (t) => OrderingTerm(expression: t.sortOrder),
        (t) => OrderingTerm(expression: t.label),
      ]);
    return query.watch().map((rows) => rows.map(TaskArea.fromRow).toList());
  }

  Future<List<TaskArea>> getAllOnce() async {
    final query = _db.select(_db.taskAreasTable)
      ..orderBy([
        (t) => OrderingTerm(expression: t.sortOrder),
        (t) => OrderingTerm(expression: t.label),
      ]);
    final rows = await query.get();
    return rows.map(TaskArea.fromRow).toList();
  }

  Future<String> addArea({
    required String label,
    String emoji = '',
    required String colorHex,
    String? iconName,
  }) async {
    final id = _uuid.v4();
    final current = await getAllOnce();
    final maxOrder = current.fold<int>(-1, (m, a) => a.sortOrder > m ? a.sortOrder : m);
    await _db.into(_db.taskAreasTable).insert(
          TaskAreasTableCompanion.insert(
            id: id,
            label: label,
            emoji: Value(emoji),
            colorHex: colorHex,
            iconName: Value(iconName),
            sortOrder: Value(maxOrder + 1),
            isBuiltin: const Value(false),
            createdAt: DateTime.now(),
          ),
        );
    return id;
  }

  Future<void> updateArea({
    required String id,
    String? label,
    String? emoji,
    String? colorHex,
    String? iconName,
  }) async {
    await (_db.update(_db.taskAreasTable)..where((t) => t.id.equals(id))).write(
      TaskAreasTableCompanion(
        label: label == null ? const Value.absent() : Value(label),
        emoji: emoji == null ? const Value.absent() : Value(emoji),
        colorHex: colorHex == null ? const Value.absent() : Value(colorHex),
        iconName: iconName == null ? const Value.absent() : Value(iconName),
      ),
    );
  }

  /// Deletes an area. Also clears the `areaId` on any tasks that referenced
  /// it, so those tasks simply become "Sin area" instead of broken.
  /// Built-in areas can't be deleted.
  Future<bool> deleteArea(String id) async {
    final row = await (_db.select(_db.taskAreasTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return false;
    if (row.isBuiltin) return false;

    await _db.transaction(() async {
      // Null out references on tasks.
      await (_db.update(_db.tasksTable)
            ..where((t) => t.area.equals(id)))
          .write(const TasksTableCompanion(area: Value(null)));
      await (_db.delete(_db.taskAreasTable)..where((t) => t.id.equals(id))).go();
    });
    return true;
  }

  /// Applies a new order. [orderedIds] is the full list after a drag.
  Future<void> reorderAreas(List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.taskAreasTable)
              ..where((t) => t.id.equals(orderedIds[i])))
            .write(TaskAreasTableCompanion(sortOrder: Value(i)));
      }
    });
  }
}
