import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../utils/json_utils.dart';
import '../../features/hoy/domain/models/task.dart';
import 'notification_service.dart';

class TaskService {
  final AppDatabase _db;
  TaskService(this._db);

  static const _uuid = Uuid();
  // Singleton — el plugin se inicializa una sola vez en main.
  final NotificationService _notif = NotificationService();

  /// Programa la notif de una tarea si tiene `reminder` y `dayId`.
  /// Lee el "avisar N min antes" de prefs en cada llamado para que el
  /// toggle de Settings tome efecto inmediato.
  Future<void> _syncTaskReminder(Task task) async {
    final reminder = task.reminder;
    final dayId = task.dayId;
    if (reminder == null || reminder.isEmpty || dayId == null) {
      await _notif.cancelTaskReminder(task.id);
      return;
    }
    final advance = await NotificationService.getRemindBeforeMinutes();
    await _notif.scheduleTaskReminder(
      taskId: task.id,
      taskTitle: task.title,
      dayId: dayId,
      time: reminder,
      advanceMinutes: advance,
    );
  }

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
    sortOrder: row.sortOrder,
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

  /// Watches tasks that should appear in the "Hoy" view:
  /// - All tasks scheduled for today (any status except deleted), AND
  /// - All pending tasks from previous days that were never completed,
  ///   deferred, delegated or deleted (rollover behavior).
  ///
  /// This way the user doesn't lose pending tasks when a day rolls over —
  /// they keep "raining down" into today until acted on.
  Stream<List<Task>> watchTodayTasks(String today) {
    return (_db.select(_db.tasksTable)
      ..where((t) =>
          (t.dayId.equals(today) & t.status.isNotIn(['deleted'])) |
          (t.dayId.isSmallerThanValue(today) & t.status.equals('pending')))
      ..orderBy([
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.createdAt),
      ]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Stream<List<Task>> watchTasksByProject(String projectId) {
    return (_db.select(_db.tasksTable)
      ..where((t) => t.parentProjectId.equals(projectId) & t.status.isNotIn(['deleted'])))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  /// Tareas dentro de un rango de días — para la vista mensual. Excluye
  /// las eliminadas. Devuelve cualquier status (pending / done / etc).
  Stream<List<Task>> watchTasksInRange(String fromDayId, String toDayId) {
    return (_db.select(_db.tasksTable)
      ..where((t) =>
          t.dayId.isBiggerOrEqualValue(fromDayId) &
          t.dayId.isSmallerOrEqualValue(toDayId) &
          t.status.isNotIn(['deleted']))
      ..orderBy([
        (t) => OrderingTerm.asc(t.dayId),
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.priority),
      ]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  /// Mueve una tarea a otro día (drag-and-drop entre celdas del mes).
  Future<void> moveTaskToDay(String taskId, String newDayId) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(taskId)))
        .write(TasksTableCompanion(dayId: Value(newDayId)));
  }

  /// Persiste el orden manual del usuario (drag-and-drop dentro de una
  /// priority section en Hoy). `idsInOrder` debe traer los ids en el
  /// orden visual deseado.
  Future<void> reorderTasks(List<String> idsInOrder) async {
    await _db.batch((batch) {
      for (var i = 0; i < idsInOrder.length; i++) {
        batch.update(
          _db.tasksTable,
          TasksTableCompanion(sortOrder: Value(i)),
          where: (t) => t.id.equals(idsInOrder[i]),
        );
      }
    });
  }

  /// Tareas pendientes (status pending) que pertenecen a algún proyecto.
  /// Sirve para armar la sección "Proyectos activos" en Hoy con un solo
  /// stream en vez de uno por proyecto. Ordenadas por prioridad asc
  /// (primordial primero) y luego por createdAt asc (la más vieja
  /// primero) — así el "next task" sale a la cabeza.
  Stream<List<Task>> watchAllPendingProjectTasks() {
    return (_db.select(_db.tasksTable)
      ..where((t) =>
          t.parentProjectId.isNotNull() &
          t.status.equals('pending'))
      ..orderBy([
        (t) => OrderingTerm.asc(t.priority),
        (t) => OrderingTerm.asc(t.createdAt),
      ]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> addTask(Task task) async {
    final id = task.id.isEmpty ? _uuid.v4() : task.id;
    await _db.into(_db.tasksTable).insert(TasksTableCompanion.insert(
      id: id,
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
      dayId: Value(task.dayId),
      estimatedMinutes: Value(task.estimatedMinutes),
      createdAt: task.createdAt,
      completedAt: Value(task.completedAt),
    ));
    // Notif al agregar (si tiene reminder + dayId).
    await _syncTaskReminder(task.id == id
        ? task
        : Task(
            id: id,
            title: task.title,
            priority: task.priority,
            status: task.status,
            reminder: task.reminder,
            dayId: task.dayId,
            createdAt: task.createdAt,
          ));
  }

  Future<void> completeTask(String id) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(
      status: const Value('done'),
      completedAt: Value(DateTime.now()),
    ));
    await _notif.cancelTaskReminder(id);
  }

  Future<void> uncompleteTask(String id) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(const TasksTableCompanion(
      status: Value('pending'),
      completedAt: Value(null),
    ));
    // Reagenda si la tarea tenía reminder y todavía está en el futuro.
    final task = await _findById(id);
    if (task != null) await _syncTaskReminder(task);
  }

  Future<void> deferTask(String id, String newDayId) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(
      status: const Value('deferred'),
      deferredTo: Value(newDayId),
      dayId: Value(newDayId),
    ));
    // El día cambió: la notif vieja no es válida — reagendamos con el nuevo dayId.
    final task = await _findById(id);
    if (task != null) await _syncTaskReminder(task);
  }

  Future<void> delegateTask(String id, String delegateTo) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(TasksTableCompanion(
      status: const Value('delegated'),
      delegatedTo: Value(delegateTo),
    ));
    await _notif.cancelTaskReminder(id);
  }

  Future<void> deleteTask(String id) async {
    await (_db.update(_db.tasksTable)..where((t) => t.id.equals(id)))
        .write(const TasksTableCompanion(status: Value('deleted')));
    await _notif.cancelTaskReminder(id);
  }

  Future<Task?> _findById(String id) async {
    final row = await (_db.select(_db.tasksTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
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
    // Re-sync notif: si limpiaron el reminder, cancela; si lo cambiaron,
    // reagenda al nuevo horario.
    final updated = await _findById(id);
    if (updated != null) await _syncTaskReminder(updated);
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
