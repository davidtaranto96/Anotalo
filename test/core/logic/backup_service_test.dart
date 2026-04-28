import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arquitectura_enfoque/core/database/app_database.dart';
import 'package:arquitectura_enfoque/core/logic/backup_service.dart';
import 'package:arquitectura_enfoque/core/logic/task_service.dart';
import 'package:arquitectura_enfoque/features/hoy/domain/models/task.dart';

void main() {
  late AppDatabase db;
  late BackupService backup;
  late TaskService tasks;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    backup = BackupService(db);
    tasks = TaskService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('BackupService roundtrip', () {
    test('export incluye app, version, schemaVersion y createdAt', () async {
      final json = await backup.exportToJson();
      final map = jsonDecode(json) as Map<String, dynamic>;

      expect(map['app'], 'Apunto');
      expect(map['version'], isA<int>());
      expect(map['schemaVersion'], isA<int>());
      expect(map['schemaVersion'], greaterThanOrEqualTo(5));
      expect(map['createdAt'], isA<String>());
    });

    test('export incluye todas las tablas esperadas', () async {
      final json = await backup.exportToJson();
      final map = jsonDecode(json) as Map<String, dynamic>;
      final tables = map['tables'] as Map<String, dynamic>;

      expect(tables.keys,
          containsAll(['tasks', 'habits', 'projects', 'quickNotes', 'taskAreas']));
    });

    test('roundtrip: export + wipe + import devuelve los mismos datos',
        () async {
      // Insertar data
      await tasks.addTask(Task(
        id: 't1',
        title: 'Pre-backup',
        priority: TaskPriority.primordial,
        status: TaskStatus.pending,
        dayId: '2026-04-28',
        createdAt: DateTime.now(),
      ));

      final json = await backup.exportToJson();

      // Wipe (simulando "Restaurar destructivo")
      await db.delete(db.tasksTable).go();
      var rows = await db.select(db.tasksTable).get();
      expect(rows, isEmpty);

      // Import
      await backup.importFromJson(json);

      rows = await db.select(db.tasksTable).get();
      expect(rows, hasLength(1));
      expect(rows.first.id, 't1');
      expect(rows.first.title, 'Pre-backup');
      expect(rows.first.priority, 'primordial');
    });

    test('importFromJson tira FormatException con JSON sin app=Apunto',
        () async {
      const fake = '{"app": "Other", "tables": {}}';
      expect(
        () => backup.importFromJson(fake),
        throwsA(isA<FormatException>()),
      );
    });

    test('importFromJson tira BackupVersionException si schemaVersion futuro',
        () async {
      const fake = '{"app": "Apunto", "schemaVersion": 999, "tables": {}}';
      expect(
        () => backup.importFromJson(fake),
        throwsA(isA<BackupVersionException>()),
      );
    });

    test('importFromJson acepta backup viejo sin schemaVersion', () async {
      // Backups generados antes de v3 no tienen 'schemaVersion'.
      // Deberíamos seguir aceptándolos para no romper restores legacy.
      const legacy = '{'
          '"app":"Apunto",'
          '"version":2,'
          '"tables":{'
            '"tasks":[],"habits":[],"habitCompletions":[],'
            '"projects":[],"quickNotes":[],"journalEntries":[],'
            '"weeklyPlans":[],"weekDays":[],"timerSessions":[],'
            '"taskAreas":[],"dailyReviews":[]'
          '}}';
      // No debería lanzar.
      await backup.importFromJson(legacy);
      expect(true, isTrue);
    });

    test('summarizeJson devuelve null cuando no es de Apunto', () async {
      final summary = backup.summarizeJson('{"app": "Other"}');
      expect(summary, isNull);
    });

    test('summarizeJson cuenta tareas/hábitos/proyectos del backup', () async {
      await tasks.addTask(Task(
        id: 't1',
        title: 'A',
        priority: TaskPriority.importante,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      ));
      final json = await backup.exportToJson();

      final summary = backup.summarizeJson(json);
      expect(summary, isNotNull);
      expect(summary!.tasks, 1);
    });
  });
}
