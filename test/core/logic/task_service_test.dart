import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arquitectura_enfoque/core/database/app_database.dart';
import 'package:arquitectura_enfoque/core/logic/task_service.dart';
import 'package:arquitectura_enfoque/features/hoy/domain/models/task.dart';

void main() {
  late AppDatabase db;
  late TaskService svc;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    svc = TaskService(db);
  });

  tearDown(() async {
    await db.close();
  });

  Task makeTask({
    String? id,
    String title = 'Test',
    TaskPriority priority = TaskPriority.importante,
    String? dayId = '2026-04-28',
    String? reminder,
  }) =>
      Task(
        id: id ?? 'task-${title.hashCode}',
        title: title,
        priority: priority,
        status: TaskStatus.pending,
        dayId: dayId,
        reminder: reminder,
        createdAt: DateTime.now(),
      );

  group('TaskService', () {
    test('addTask persiste la tarea con todos los campos', () async {
      final task = makeTask(title: 'Comprar pan', dayId: '2026-04-28');
      await svc.addTask(task);

      final rows = await db.select(db.tasksTable).get();
      expect(rows, hasLength(1));
      expect(rows.first.title, 'Comprar pan');
      expect(rows.first.priority, 'importante');
      expect(rows.first.dayId, '2026-04-28');
      expect(rows.first.status, 'pending');
    });

    test('completeTask marca status=done y completedAt', () async {
      final task = makeTask(id: 't1');
      await svc.addTask(task);

      await svc.completeTask('t1');

      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(row.status, 'done');
      expect(row.completedAt, isNotNull);
    });

    test('uncompleteTask devuelve a pending', () async {
      await svc.addTask(makeTask(id: 't1'));
      await svc.completeTask('t1');
      await svc.uncompleteTask('t1');

      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(row.status, 'pending');
      expect(row.completedAt, isNull);
    });

    test('deleteTask soft-deletes con status=deleted', () async {
      await svc.addTask(makeTask(id: 't1'));
      await svc.deleteTask('t1');

      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(row.status, 'deleted');
    });

    test('updateTask cambia título / prioridad / área sin tocar otros campos',
        () async {
      await svc.addTask(makeTask(id: 't1', title: 'Old'));
      await svc.updateTask(
        id: 't1',
        title: 'New',
        priority: TaskPriority.primordial,
        area: 'trabajo',
      );

      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(row.title, 'New');
      expect(row.priority, 'primordial');
      expect(row.area, 'trabajo');
      expect(row.dayId, '2026-04-28'); // se mantiene
    });

    test('countCompletedToday solo cuenta done del día', () async {
      await svc.addTask(makeTask(id: 'a', dayId: '2026-04-28'));
      await svc.addTask(makeTask(id: 'b', dayId: '2026-04-28'));
      await svc.addTask(makeTask(id: 'c', dayId: '2026-04-27'));
      await svc.completeTask('a');
      await svc.completeTask('c');

      final today = await svc.countCompletedToday('2026-04-28');
      final yesterday = await svc.countCompletedToday('2026-04-27');
      expect(today, 1);
      expect(yesterday, 1);
    });

    test('deferTask cambia dayId y status=deferred', () async {
      await svc.addTask(makeTask(id: 't1', dayId: '2026-04-28'));
      await svc.deferTask('t1', '2026-04-29');

      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(row.dayId, '2026-04-29');
      expect(row.deferredTo, '2026-04-29');
      expect(row.status, 'deferred');
    });

    test('updatePriority aislado no toca otros campos', () async {
      await svc.addTask(makeTask(
          id: 't1', priority: TaskPriority.puedeEsperar, title: 'Hold'));
      await svc.updatePriority('t1', TaskPriority.primordial);

      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(row.priority, 'primordial');
      expect(row.title, 'Hold');
    });

    test('addTask sin id genera uno automáticamente', () async {
      final task = Task(
        id: '', // empty → service should generate
        title: 'Auto-id',
        priority: TaskPriority.secundaria,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      );
      await svc.addTask(task);

      final rows = await db.select(db.tasksTable).get();
      expect(rows, hasLength(1));
      expect(rows.first.id, isNotEmpty);
      expect(rows.first.title, 'Auto-id');
    });

    test('insertar tareas con dayId nullable funciona (proyectos sin programar)',
        () async {
      await svc.addTask(makeTask(id: 'unscheduled', dayId: null));

      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('unscheduled')))
          .getSingle();
      expect(row.dayId, isNull);
    });

    test('updateTask con clearArea limpia el área', () async {
      // ignore: unused_local_variable
      final base = makeTask(id: 't1');
      await db.into(db.tasksTable).insert(TasksTableCompanion.insert(
            id: 't1',
            title: 'WithArea',
            area: const Value('trabajo'),
            createdAt: DateTime.now(),
          ));

      await svc.updateTask(id: 't1', clearArea: true);
      final row = await (db.select(db.tasksTable)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(row.area, isNull);
    });
  });
}
