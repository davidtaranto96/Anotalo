import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../utils/json_utils.dart';
import '../../features/hoy/domain/models/task.dart';

class TaskService {
  final AppDatabase _db;
  TaskService(this._db);

  static const _uuid = Uuid();

  Task _fromRow(TasksTableData row) => Task(
    id: row.id,
    title: row.title,
    description: row.description,
    priority: TaskPriorityX.fromString(row.priority),
    status: TaskStatusX.fromString(row.status),
    area: row.area,
    delegatedTo: row.delegatedTo,
    deferredTo: row.deferredTo,
    scheduledDate: row.scheduledDate,
    reminder: row.reminder,
    parentProjectId: row.parentProjectId,
    subtaskIds: decodeStringList(row.subtaskIds),
    dayId: row.dayId,
    estimatedMinutes: row.estimatedMinutes,
    createdAt: row.createdAt,
    completedAt: row.completedAt,
  );

  Stream<List<Task>> watchTasksByDay(String dayId) {
    return (_db.select(_db.tasksTable)
      ..where((t) => t.dayId.equals(dayId) & t.status.isNotIn(['deleted']))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<List<Task>> watchTasksByProject(String projectId) {
    return (_db.select(_db.tasksTable)
      ..where((t) => t.parentProjectId.equals(projectId) & t.status.isNotIn(['deleted'])))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> addTask(Task task) async {
    await _db.into(_db.tasksTable).insert(TasksTableCompanion.insert(
      id: task.id.isEmpty ? _uuid.v4() : task.id,
      title: task.title,
      description: Value(task.description),
      priority: Value(task.priority.value),
      status: Value(task.status.value),
      area: Value(task.area),
      delegatedTo: Value(task.delegatedTo),
      deferredTo: Value(task.deferredTo),
      scheduledDate: Value(task.scheduledDate),
      reminder: Value(task.reminder),
      parentProjectId: Value(task.parentProjectId),
      subtaskIds: Value(encodeStringList(task.subtaskIds)),
      dayId: task.dayId,
      estimatedMinutes: Value(task.estimatedMinutes),
      createdAt: task.createdAt,
      completedAt: Value(task.completedAt),
    ));
  }

  Future<void> completeTask(String id) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(
      status: const Value('done'),
      completedAt: Value(DateTime.now()),
    ));
  }

  Future<void> uncompleteTask(String id) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(const TasksTableCompanion(
      status: Value('pending'),
      completedAt: Value(null),
    ));
  }

  Future<void> deferTask(String id, String newDayId) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(
      status: const Value('deferred'),
      deferredTo: Value(newDayId),
      dayId: Value(newDayId),
    ));
  }

  Future<void> delegateTask(String id, String delegateTo) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(
      status: const Value('delegated'),
      delegatedTo: Value(delegateTo),
    ));
  }

  Future<void> deleteTask(String id) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(const TasksTableCompanion(status: Value('deleted')));
  }

  Future<void> updatePriority(String id, TaskPriority priority) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(priority: Value(priority.value)));
  }

  /// Update the editable fields of a task. Fields not provided stay untouched.
  /// The created-at / id / dayId are intentionally not touched here — use a
  /// dedicated defer/reschedule method for day changes.
  Future<void> updateTask({
    required String id,
    String? title,
    TaskPriority? priority,
    String? area,
    String? reminder,
    int? estimatedMinutes,
    String? dayId,
    bool clearArea = false,
    bool clearReminder = false,
  }) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(
      title: title == null ? const Value.absent() : Value(title),
      priority: priority == null ? const Value.absent() : Value(priority.value),
      area: clearArea
          ? const Value<String?>(null)
          : (area == null ? const Value.absent() : Value(area)),
      reminder: clearReminder
          ? const Value<String?>(null)
          : (reminder == null ? const Value.absent() : Value(reminder)),
      estimatedMinutes:
          estimatedMinutes == null ? const Value.absent() : Value(estimatedMinutes),
      dayId: dayId == null ? const Value.absent() : Value(dayId),
    ));
  }

  Future<int> countCompletedToday(String dayId) async {
    final rows = await (_db.select(_db.tasksTable)
      ..where((t) => t.dayId.equals(dayId) & t.status.equals('done')))
      .get();
    return rows.length;
  }

  Future<int> countTotalToday(String dayId) async {
    final rows = await (_db.select(_db.tasksTable)
      ..where((t) => t.dayId.equals(dayId) & t.status.isNotIn(['deleted'])))
      .get();
    return rows.length;
  }
}
