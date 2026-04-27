import 'package:equatable/equatable.dart';

enum TaskPriority { primordial, importante, puedeEsperar, secundaria }
enum TaskStatus   { pending, inProgress, done, deferred, delegated, deleted }
enum TaskAction   { doIt, delegate, defer, delete }

extension TaskPriorityX on TaskPriority {
  String get value => switch (this) {
    TaskPriority.primordial  => 'primordial',
    TaskPriority.importante  => 'importante',
    TaskPriority.puedeEsperar => 'puede_esperar',
    TaskPriority.secundaria  => 'secundaria',
  };
  static TaskPriority fromString(String s) => switch (s) {
    'primordial'   => TaskPriority.primordial,
    'importante'   => TaskPriority.importante,
    'puede_esperar' => TaskPriority.puedeEsperar,
    _              => TaskPriority.secundaria,
  };
}

extension TaskStatusX on TaskStatus {
  String get value => switch (this) {
    TaskStatus.pending    => 'pending',
    TaskStatus.inProgress => 'in_progress',
    TaskStatus.done       => 'done',
    TaskStatus.deferred   => 'deferred',
    TaskStatus.delegated  => 'delegated',
    TaskStatus.deleted    => 'deleted',
  };
  static TaskStatus fromString(String s) => switch (s) {
    'in_progress' => TaskStatus.inProgress,
    'done'        => TaskStatus.done,
    'deferred'    => TaskStatus.deferred,
    'delegated'   => TaskStatus.delegated,
    'deleted'     => TaskStatus.deleted,
    _             => TaskStatus.pending,
  };
}

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final TaskAction? action;
  final String? area;
  final String? delegatedTo;
  final String? deferredTo;
  final String? scheduledDate;
  final String? reminder;
  final String? parentProjectId;
  final List<String> subtaskIds;
  /// Día asignado a la tarea (yyyy-mm-dd). `null` = "sin programar"
  /// — pasa con tareas creadas dentro de un proyecto que el usuario
  /// no asignó a ningún día específico todavía.
  final String? dayId;
  final int? estimatedMinutes;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.status,
    this.action,
    this.area,
    this.delegatedTo,
    this.deferredTo,
    this.scheduledDate,
    this.reminder,
    this.parentProjectId,
    this.subtaskIds = const [],
    this.dayId,
    this.estimatedMinutes,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    TaskAction? action,
    String? area,
    String? delegatedTo,
    String? deferredTo,
    String? scheduledDate,
    String? reminder,
    String? parentProjectId,
    List<String>? subtaskIds,
    String? dayId,
    bool clearDayId = false,
    int? estimatedMinutes,
    DateTime? completedAt,
  }) => Task(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    action: action ?? this.action,
    area: area ?? this.area,
    delegatedTo: delegatedTo ?? this.delegatedTo,
    deferredTo: deferredTo ?? this.deferredTo,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    reminder: reminder ?? this.reminder,
    parentProjectId: parentProjectId ?? this.parentProjectId,
    subtaskIds: subtaskIds ?? this.subtaskIds,
    dayId: clearDayId ? null : (dayId ?? this.dayId),
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    createdAt: createdAt,
    completedAt: completedAt ?? this.completedAt,
  );

  @override
  List<Object?> get props => [id, title, priority, status, dayId, completedAt];
}
