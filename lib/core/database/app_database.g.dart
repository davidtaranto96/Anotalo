// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('puede_esperar'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _delegatedToMeta = const VerificationMeta(
    'delegatedTo',
  );
  @override
  late final GeneratedColumn<String> delegatedTo = GeneratedColumn<String>(
    'delegated_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deferredToMeta = const VerificationMeta(
    'deferredTo',
  );
  @override
  late final GeneratedColumn<String> deferredTo = GeneratedColumn<String>(
    'deferred_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<String> scheduledDate = GeneratedColumn<String>(
    'scheduled_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderMeta = const VerificationMeta(
    'reminder',
  );
  @override
  late final GeneratedColumn<String> reminder = GeneratedColumn<String>(
    'reminder',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentProjectIdMeta = const VerificationMeta(
    'parentProjectId',
  );
  @override
  late final GeneratedColumn<String> parentProjectId = GeneratedColumn<String>(
    'parent_project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtaskIdsMeta = const VerificationMeta(
    'subtaskIds',
  );
  @override
  late final GeneratedColumn<String> subtaskIds = GeneratedColumn<String>(
    'subtask_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    priority,
    status,
    action,
    area,
    delegatedTo,
    deferredTo,
    scheduledDate,
    reminder,
    parentProjectId,
    subtaskIds,
    dayId,
    estimatedMinutes,
    sortOrder,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('delegated_to')) {
      context.handle(
        _delegatedToMeta,
        delegatedTo.isAcceptableOrUnknown(
          data['delegated_to']!,
          _delegatedToMeta,
        ),
      );
    }
    if (data.containsKey('deferred_to')) {
      context.handle(
        _deferredToMeta,
        deferredTo.isAcceptableOrUnknown(data['deferred_to']!, _deferredToMeta),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    }
    if (data.containsKey('reminder')) {
      context.handle(
        _reminderMeta,
        reminder.isAcceptableOrUnknown(data['reminder']!, _reminderMeta),
      );
    }
    if (data.containsKey('parent_project_id')) {
      context.handle(
        _parentProjectIdMeta,
        parentProjectId.isAcceptableOrUnknown(
          data['parent_project_id']!,
          _parentProjectIdMeta,
        ),
      );
    }
    if (data.containsKey('subtask_ids')) {
      context.handle(
        _subtaskIdsMeta,
        subtaskIds.isAcceptableOrUnknown(data['subtask_ids']!, _subtaskIdsMeta),
      );
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      ),
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      ),
      delegatedTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delegated_to'],
      ),
      deferredTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deferred_to'],
      ),
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_date'],
      ),
      reminder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder'],
      ),
      parentProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_project_id'],
      ),
      subtaskIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtask_ids'],
      ),
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      ),
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;
  final String title;
  final String? description;
  final String priority;
  final String status;
  final String? action;
  final String? area;
  final String? delegatedTo;
  final String? deferredTo;
  final String? scheduledDate;
  final String? reminder;
  final String? parentProjectId;
  final String? subtaskIds;
  final String? dayId;
  final int? estimatedMinutes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? completedAt;
  const TasksTableData({
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
    this.subtaskIds,
    this.dayId,
    this.estimatedMinutes,
    required this.sortOrder,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || action != null) {
      map['action'] = Variable<String>(action);
    }
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || delegatedTo != null) {
      map['delegated_to'] = Variable<String>(delegatedTo);
    }
    if (!nullToAbsent || deferredTo != null) {
      map['deferred_to'] = Variable<String>(deferredTo);
    }
    if (!nullToAbsent || scheduledDate != null) {
      map['scheduled_date'] = Variable<String>(scheduledDate);
    }
    if (!nullToAbsent || reminder != null) {
      map['reminder'] = Variable<String>(reminder);
    }
    if (!nullToAbsent || parentProjectId != null) {
      map['parent_project_id'] = Variable<String>(parentProjectId);
    }
    if (!nullToAbsent || subtaskIds != null) {
      map['subtask_ids'] = Variable<String>(subtaskIds);
    }
    if (!nullToAbsent || dayId != null) {
      map['day_id'] = Variable<String>(dayId);
    }
    if (!nullToAbsent || estimatedMinutes != null) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      priority: Value(priority),
      status: Value(status),
      action: action == null && nullToAbsent
          ? const Value.absent()
          : Value(action),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      delegatedTo: delegatedTo == null && nullToAbsent
          ? const Value.absent()
          : Value(delegatedTo),
      deferredTo: deferredTo == null && nullToAbsent
          ? const Value.absent()
          : Value(deferredTo),
      scheduledDate: scheduledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledDate),
      reminder: reminder == null && nullToAbsent
          ? const Value.absent()
          : Value(reminder),
      parentProjectId: parentProjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentProjectId),
      subtaskIds: subtaskIds == null && nullToAbsent
          ? const Value.absent()
          : Value(subtaskIds),
      dayId: dayId == null && nullToAbsent
          ? const Value.absent()
          : Value(dayId),
      estimatedMinutes: estimatedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedMinutes),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory TasksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      action: serializer.fromJson<String?>(json['action']),
      area: serializer.fromJson<String?>(json['area']),
      delegatedTo: serializer.fromJson<String?>(json['delegatedTo']),
      deferredTo: serializer.fromJson<String?>(json['deferredTo']),
      scheduledDate: serializer.fromJson<String?>(json['scheduledDate']),
      reminder: serializer.fromJson<String?>(json['reminder']),
      parentProjectId: serializer.fromJson<String?>(json['parentProjectId']),
      subtaskIds: serializer.fromJson<String?>(json['subtaskIds']),
      dayId: serializer.fromJson<String?>(json['dayId']),
      estimatedMinutes: serializer.fromJson<int?>(json['estimatedMinutes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'action': serializer.toJson<String?>(action),
      'area': serializer.toJson<String?>(area),
      'delegatedTo': serializer.toJson<String?>(delegatedTo),
      'deferredTo': serializer.toJson<String?>(deferredTo),
      'scheduledDate': serializer.toJson<String?>(scheduledDate),
      'reminder': serializer.toJson<String?>(reminder),
      'parentProjectId': serializer.toJson<String?>(parentProjectId),
      'subtaskIds': serializer.toJson<String?>(subtaskIds),
      'dayId': serializer.toJson<String?>(dayId),
      'estimatedMinutes': serializer.toJson<int?>(estimatedMinutes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  TasksTableData copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? priority,
    String? status,
    Value<String?> action = const Value.absent(),
    Value<String?> area = const Value.absent(),
    Value<String?> delegatedTo = const Value.absent(),
    Value<String?> deferredTo = const Value.absent(),
    Value<String?> scheduledDate = const Value.absent(),
    Value<String?> reminder = const Value.absent(),
    Value<String?> parentProjectId = const Value.absent(),
    Value<String?> subtaskIds = const Value.absent(),
    Value<String?> dayId = const Value.absent(),
    Value<int?> estimatedMinutes = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => TasksTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    action: action.present ? action.value : this.action,
    area: area.present ? area.value : this.area,
    delegatedTo: delegatedTo.present ? delegatedTo.value : this.delegatedTo,
    deferredTo: deferredTo.present ? deferredTo.value : this.deferredTo,
    scheduledDate: scheduledDate.present
        ? scheduledDate.value
        : this.scheduledDate,
    reminder: reminder.present ? reminder.value : this.reminder,
    parentProjectId: parentProjectId.present
        ? parentProjectId.value
        : this.parentProjectId,
    subtaskIds: subtaskIds.present ? subtaskIds.value : this.subtaskIds,
    dayId: dayId.present ? dayId.value : this.dayId,
    estimatedMinutes: estimatedMinutes.present
        ? estimatedMinutes.value
        : this.estimatedMinutes,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      action: data.action.present ? data.action.value : this.action,
      area: data.area.present ? data.area.value : this.area,
      delegatedTo: data.delegatedTo.present
          ? data.delegatedTo.value
          : this.delegatedTo,
      deferredTo: data.deferredTo.present
          ? data.deferredTo.value
          : this.deferredTo,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      reminder: data.reminder.present ? data.reminder.value : this.reminder,
      parentProjectId: data.parentProjectId.present
          ? data.parentProjectId.value
          : this.parentProjectId,
      subtaskIds: data.subtaskIds.present
          ? data.subtaskIds.value
          : this.subtaskIds,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('action: $action, ')
          ..write('area: $area, ')
          ..write('delegatedTo: $delegatedTo, ')
          ..write('deferredTo: $deferredTo, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('reminder: $reminder, ')
          ..write('parentProjectId: $parentProjectId, ')
          ..write('subtaskIds: $subtaskIds, ')
          ..write('dayId: $dayId, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    priority,
    status,
    action,
    area,
    delegatedTo,
    deferredTo,
    scheduledDate,
    reminder,
    parentProjectId,
    subtaskIds,
    dayId,
    estimatedMinutes,
    sortOrder,
    createdAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.action == this.action &&
          other.area == this.area &&
          other.delegatedTo == this.delegatedTo &&
          other.deferredTo == this.deferredTo &&
          other.scheduledDate == this.scheduledDate &&
          other.reminder == this.reminder &&
          other.parentProjectId == this.parentProjectId &&
          other.subtaskIds == this.subtaskIds &&
          other.dayId == this.dayId &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> priority;
  final Value<String> status;
  final Value<String?> action;
  final Value<String?> area;
  final Value<String?> delegatedTo;
  final Value<String?> deferredTo;
  final Value<String?> scheduledDate;
  final Value<String?> reminder;
  final Value<String?> parentProjectId;
  final Value<String?> subtaskIds;
  final Value<String?> dayId;
  final Value<int?> estimatedMinutes;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.action = const Value.absent(),
    this.area = const Value.absent(),
    this.delegatedTo = const Value.absent(),
    this.deferredTo = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.reminder = const Value.absent(),
    this.parentProjectId = const Value.absent(),
    this.subtaskIds = const Value.absent(),
    this.dayId = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.action = const Value.absent(),
    this.area = const Value.absent(),
    this.delegatedTo = const Value.absent(),
    this.deferredTo = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.reminder = const Value.absent(),
    this.parentProjectId = const Value.absent(),
    this.subtaskIds = const Value.absent(),
    this.dayId = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<String>? action,
    Expression<String>? area,
    Expression<String>? delegatedTo,
    Expression<String>? deferredTo,
    Expression<String>? scheduledDate,
    Expression<String>? reminder,
    Expression<String>? parentProjectId,
    Expression<String>? subtaskIds,
    Expression<String>? dayId,
    Expression<int>? estimatedMinutes,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (action != null) 'action': action,
      if (area != null) 'area': area,
      if (delegatedTo != null) 'delegated_to': delegatedTo,
      if (deferredTo != null) 'deferred_to': deferredTo,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (reminder != null) 'reminder': reminder,
      if (parentProjectId != null) 'parent_project_id': parentProjectId,
      if (subtaskIds != null) 'subtask_ids': subtaskIds,
      if (dayId != null) 'day_id': dayId,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? priority,
    Value<String>? status,
    Value<String?>? action,
    Value<String?>? area,
    Value<String?>? delegatedTo,
    Value<String?>? deferredTo,
    Value<String?>? scheduledDate,
    Value<String?>? reminder,
    Value<String?>? parentProjectId,
    Value<String?>? subtaskIds,
    Value<String?>? dayId,
    Value<int?>? estimatedMinutes,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
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
      dayId: dayId ?? this.dayId,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (delegatedTo.present) {
      map['delegated_to'] = Variable<String>(delegatedTo.value);
    }
    if (deferredTo.present) {
      map['deferred_to'] = Variable<String>(deferredTo.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<String>(scheduledDate.value);
    }
    if (reminder.present) {
      map['reminder'] = Variable<String>(reminder.value);
    }
    if (parentProjectId.present) {
      map['parent_project_id'] = Variable<String>(parentProjectId.value);
    }
    if (subtaskIds.present) {
      map['subtask_ids'] = Variable<String>(subtaskIds.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('action: $action, ')
          ..write('area: $area, ')
          ..write('delegatedTo: $delegatedTo, ')
          ..write('deferredTo: $deferredTo, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('reminder: $reminder, ')
          ..write('parentProjectId: $parentProjectId, ')
          ..write('subtaskIds: $subtaskIds, ')
          ..write('dayId: $dayId, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTableTable extends HabitsTable
    with TableInfo<$HabitsTableTable, HabitsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPerWeekMeta = const VerificationMeta(
    'targetPerWeek',
  );
  @override
  late final GeneratedColumn<int> targetPerWeek = GeneratedColumn<int>(
    'target_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    frequency,
    targetPerWeek,
    area,
    color,
    icon,
    isArchived,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('target_per_week')) {
      context.handle(
        _targetPerWeekMeta,
        targetPerWeek.isAcceptableOrUnknown(
          data['target_per_week']!,
          _targetPerWeekMeta,
        ),
      );
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      targetPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_per_week'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HabitsTableTable createAlias(String alias) {
    return $HabitsTableTable(attachedDatabase, alias);
  }
}

class HabitsTableData extends DataClass implements Insertable<HabitsTableData> {
  final String id;
  final String title;
  final String? description;
  final String frequency;
  final int targetPerWeek;
  final String? area;
  final String? color;
  final String? icon;
  final bool isArchived;
  final int sortOrder;
  final DateTime createdAt;
  const HabitsTableData({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    required this.targetPerWeek,
    this.area,
    this.color,
    this.icon,
    required this.isArchived,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['frequency'] = Variable<String>(frequency);
    map['target_per_week'] = Variable<int>(targetPerWeek);
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      frequency: Value(frequency),
      targetPerWeek: Value(targetPerWeek),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isArchived: Value(isArchived),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory HabitsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      frequency: serializer.fromJson<String>(json['frequency']),
      targetPerWeek: serializer.fromJson<int>(json['targetPerWeek']),
      area: serializer.fromJson<String?>(json['area']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'frequency': serializer.toJson<String>(frequency),
      'targetPerWeek': serializer.toJson<int>(targetPerWeek),
      'area': serializer.toJson<String?>(area),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'isArchived': serializer.toJson<bool>(isArchived),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HabitsTableData copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? frequency,
    int? targetPerWeek,
    Value<String?> area = const Value.absent(),
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    bool? isArchived,
    int? sortOrder,
    DateTime? createdAt,
  }) => HabitsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    frequency: frequency ?? this.frequency,
    targetPerWeek: targetPerWeek ?? this.targetPerWeek,
    area: area.present ? area.value : this.area,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    isArchived: isArchived ?? this.isArchived,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  HabitsTableData copyWithCompanion(HabitsTableCompanion data) {
    return HabitsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      targetPerWeek: data.targetPerWeek.present
          ? data.targetPerWeek.value
          : this.targetPerWeek,
      area: data.area.present ? data.area.value : this.area,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('targetPerWeek: $targetPerWeek, ')
          ..write('area: $area, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    frequency,
    targetPerWeek,
    area,
    color,
    icon,
    isArchived,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.frequency == this.frequency &&
          other.targetPerWeek == this.targetPerWeek &&
          other.area == this.area &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.isArchived == this.isArchived &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class HabitsTableCompanion extends UpdateCompanion<HabitsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> frequency;
  final Value<int> targetPerWeek;
  final Value<String?> area;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<bool> isArchived;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HabitsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.frequency = const Value.absent(),
    this.targetPerWeek = const Value.absent(),
    this.area = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required String frequency,
    this.targetPerWeek = const Value.absent(),
    this.area = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       frequency = Value(frequency),
       createdAt = Value(createdAt);
  static Insertable<HabitsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? frequency,
    Expression<int>? targetPerWeek,
    Expression<String>? area,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<bool>? isArchived,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (frequency != null) 'frequency': frequency,
      if (targetPerWeek != null) 'target_per_week': targetPerWeek,
      if (area != null) 'area': area,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (isArchived != null) 'is_archived': isArchived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? frequency,
    Value<int>? targetPerWeek,
    Value<String?>? area,
    Value<String?>? color,
    Value<String?>? icon,
    Value<bool>? isArchived,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HabitsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      targetPerWeek: targetPerWeek ?? this.targetPerWeek,
      area: area ?? this.area,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (targetPerWeek.present) {
      map['target_per_week'] = Variable<int>(targetPerWeek.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('frequency: $frequency, ')
          ..write('targetPerWeek: $targetPerWeek, ')
          ..write('area: $area, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitCompletionsTableTable extends HabitCompletionsTable
    with TableInfo<$HabitCompletionsTableTable, HabitCompletionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCompletionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, habitId, dayId, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_completions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitCompletionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitCompletionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCompletionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $HabitCompletionsTableTable createAlias(String alias) {
    return $HabitCompletionsTableTable(attachedDatabase, alias);
  }
}

class HabitCompletionsTableData extends DataClass
    implements Insertable<HabitCompletionsTableData> {
  final String id;
  final String habitId;
  final String dayId;
  final DateTime completedAt;
  const HabitCompletionsTableData({
    required this.id,
    required this.habitId,
    required this.dayId,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['day_id'] = Variable<String>(dayId);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  HabitCompletionsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsTableCompanion(
      id: Value(id),
      habitId: Value(habitId),
      dayId: Value(dayId),
      completedAt: Value(completedAt),
    );
  }

  factory HabitCompletionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCompletionsTableData(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      dayId: serializer.fromJson<String>(json['dayId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'dayId': serializer.toJson<String>(dayId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  HabitCompletionsTableData copyWith({
    String? id,
    String? habitId,
    String? dayId,
    DateTime? completedAt,
  }) => HabitCompletionsTableData(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    dayId: dayId ?? this.dayId,
    completedAt: completedAt ?? this.completedAt,
  );
  HabitCompletionsTableData copyWithCompanion(
    HabitCompletionsTableCompanion data,
  ) {
    return HabitCompletionsTableData(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionsTableData(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('dayId: $dayId, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, dayId, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitCompletionsTableData &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.dayId == this.dayId &&
          other.completedAt == this.completedAt);
}

class HabitCompletionsTableCompanion
    extends UpdateCompanion<HabitCompletionsTableData> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> dayId;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const HabitCompletionsTableCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.dayId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitCompletionsTableCompanion.insert({
    required String id,
    required String habitId,
    required String dayId,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       dayId = Value(dayId),
       completedAt = Value(completedAt);
  static Insertable<HabitCompletionsTableData> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? dayId,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (dayId != null) 'day_id': dayId,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitCompletionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<String>? dayId,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return HabitCompletionsTableCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      dayId: dayId ?? this.dayId,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitCompletionsTableCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('dayId: $dayId, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTableTable extends ProjectsTable
    with TableInfo<$ProjectsTableTable, ProjectsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<String> targetDate = GeneratedColumn<String>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdsMeta = const VerificationMeta(
    'taskIds',
  );
  @override
  late final GeneratedColumn<String> taskIds = GeneratedColumn<String>(
    'task_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyGoalsMeta = const VerificationMeta(
    'weeklyGoals',
  );
  @override
  late final GeneratedColumn<String> weeklyGoals = GeneratedColumn<String>(
    'weekly_goals',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    status,
    color,
    icon,
    targetDate,
    taskIds,
    weeklyGoals,
    notes,
    sortOrder,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('task_ids')) {
      context.handle(
        _taskIdsMeta,
        taskIds.isAcceptableOrUnknown(data['task_ids']!, _taskIdsMeta),
      );
    }
    if (data.containsKey('weekly_goals')) {
      context.handle(
        _weeklyGoalsMeta,
        weeklyGoals.isAcceptableOrUnknown(
          data['weekly_goals']!,
          _weeklyGoalsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_date'],
      ),
      taskIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_ids'],
      ),
      weeklyGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekly_goals'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $ProjectsTableTable createAlias(String alias) {
    return $ProjectsTableTable(attachedDatabase, alias);
  }
}

class ProjectsTableData extends DataClass
    implements Insertable<ProjectsTableData> {
  final String id;
  final String title;
  final String? description;
  final String category;
  final String status;
  final String color;
  final String? icon;
  final String? targetDate;
  final String? taskIds;
  final String? weeklyGoals;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? completedAt;
  const ProjectsTableData({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.status,
    required this.color,
    this.icon,
    this.targetDate,
    this.taskIds,
    this.weeklyGoals,
    this.notes,
    required this.sortOrder,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category'] = Variable<String>(category);
    map['status'] = Variable<String>(status);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<String>(targetDate);
    }
    if (!nullToAbsent || taskIds != null) {
      map['task_ids'] = Variable<String>(taskIds);
    }
    if (!nullToAbsent || weeklyGoals != null) {
      map['weekly_goals'] = Variable<String>(weeklyGoals);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  ProjectsTableCompanion toCompanion(bool nullToAbsent) {
    return ProjectsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: Value(category),
      status: Value(status),
      color: Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      taskIds: taskIds == null && nullToAbsent
          ? const Value.absent()
          : Value(taskIds),
      weeklyGoals: weeklyGoals == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyGoals),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory ProjectsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      color: serializer.fromJson<String>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      targetDate: serializer.fromJson<String?>(json['targetDate']),
      taskIds: serializer.fromJson<String?>(json['taskIds']),
      weeklyGoals: serializer.fromJson<String?>(json['weeklyGoals']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String>(category),
      'status': serializer.toJson<String>(status),
      'color': serializer.toJson<String>(color),
      'icon': serializer.toJson<String?>(icon),
      'targetDate': serializer.toJson<String?>(targetDate),
      'taskIds': serializer.toJson<String?>(taskIds),
      'weeklyGoals': serializer.toJson<String?>(weeklyGoals),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  ProjectsTableData copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? category,
    String? status,
    String? color,
    Value<String?> icon = const Value.absent(),
    Value<String?> targetDate = const Value.absent(),
    Value<String?> taskIds = const Value.absent(),
    Value<String?> weeklyGoals = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => ProjectsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    category: category ?? this.category,
    status: status ?? this.status,
    color: color ?? this.color,
    icon: icon.present ? icon.value : this.icon,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    taskIds: taskIds.present ? taskIds.value : this.taskIds,
    weeklyGoals: weeklyGoals.present ? weeklyGoals.value : this.weeklyGoals,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  ProjectsTableData copyWithCompanion(ProjectsTableCompanion data) {
    return ProjectsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      taskIds: data.taskIds.present ? data.taskIds.value : this.taskIds,
      weeklyGoals: data.weeklyGoals.present
          ? data.weeklyGoals.value
          : this.weeklyGoals,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('targetDate: $targetDate, ')
          ..write('taskIds: $taskIds, ')
          ..write('weeklyGoals: $weeklyGoals, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    status,
    color,
    icon,
    targetDate,
    taskIds,
    weeklyGoals,
    notes,
    sortOrder,
    createdAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.status == this.status &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.targetDate == this.targetDate &&
          other.taskIds == this.taskIds &&
          other.weeklyGoals == this.weeklyGoals &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class ProjectsTableCompanion extends UpdateCompanion<ProjectsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> category;
  final Value<String> status;
  final Value<String> color;
  final Value<String?> icon;
  final Value<String?> targetDate;
  final Value<String?> taskIds;
  final Value<String?> weeklyGoals;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const ProjectsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.taskIds = const Value.absent(),
    this.weeklyGoals = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required String category,
    this.status = const Value.absent(),
    required String color,
    this.icon = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.taskIds = const Value.absent(),
    this.weeklyGoals = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       category = Value(category),
       color = Value(color),
       createdAt = Value(createdAt);
  static Insertable<ProjectsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? status,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<String>? targetDate,
    Expression<String>? taskIds,
    Expression<String>? weeklyGoals,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (targetDate != null) 'target_date': targetDate,
      if (taskIds != null) 'task_ids': taskIds,
      if (weeklyGoals != null) 'weekly_goals': weeklyGoals,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? category,
    Value<String>? status,
    Value<String>? color,
    Value<String?>? icon,
    Value<String?>? targetDate,
    Value<String?>? taskIds,
    Value<String?>? weeklyGoals,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return ProjectsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      targetDate: targetDate ?? this.targetDate,
      taskIds: taskIds ?? this.taskIds,
      weeklyGoals: weeklyGoals ?? this.weeklyGoals,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<String>(targetDate.value);
    }
    if (taskIds.present) {
      map['task_ids'] = Variable<String>(taskIds.value);
    }
    if (weeklyGoals.present) {
      map['weekly_goals'] = Variable<String>(weeklyGoals.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('targetDate: $targetDate, ')
          ..write('taskIds: $taskIds, ')
          ..write('weeklyGoals: $weeklyGoals, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuickNotesTableTable extends QuickNotesTable
    with TableInfo<$QuickNotesTableTable, QuickNotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuickNotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _isProcessedMeta = const VerificationMeta(
    'isProcessed',
  );
  @override
  late final GeneratedColumn<bool> isProcessed = GeneratedColumn<bool>(
    'is_processed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_processed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _processedToTypeMeta = const VerificationMeta(
    'processedToType',
  );
  @override
  late final GeneratedColumn<String> processedToType = GeneratedColumn<String>(
    'processed_to_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processedToTargetIdMeta =
      const VerificationMeta('processedToTargetId');
  @override
  late final GeneratedColumn<String> processedToTargetId =
      GeneratedColumn<String>(
        'processed_to_target_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    type,
    isProcessed,
    processedToType,
    processedToTargetId,
    tags,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quick_notes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuickNotesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('is_processed')) {
      context.handle(
        _isProcessedMeta,
        isProcessed.isAcceptableOrUnknown(
          data['is_processed']!,
          _isProcessedMeta,
        ),
      );
    }
    if (data.containsKey('processed_to_type')) {
      context.handle(
        _processedToTypeMeta,
        processedToType.isAcceptableOrUnknown(
          data['processed_to_type']!,
          _processedToTypeMeta,
        ),
      );
    }
    if (data.containsKey('processed_to_target_id')) {
      context.handle(
        _processedToTargetIdMeta,
        processedToTargetId.isAcceptableOrUnknown(
          data['processed_to_target_id']!,
          _processedToTargetIdMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuickNotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuickNotesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isProcessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_processed'],
      )!,
      processedToType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processed_to_type'],
      ),
      processedToTargetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processed_to_target_id'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QuickNotesTableTable createAlias(String alias) {
    return $QuickNotesTableTable(attachedDatabase, alias);
  }
}

class QuickNotesTableData extends DataClass
    implements Insertable<QuickNotesTableData> {
  final String id;
  final String content;
  final String type;
  final bool isProcessed;
  final String? processedToType;
  final String? processedToTargetId;
  final String? tags;
  final DateTime createdAt;
  const QuickNotesTableData({
    required this.id,
    required this.content,
    required this.type,
    required this.isProcessed,
    this.processedToType,
    this.processedToTargetId,
    this.tags,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['type'] = Variable<String>(type);
    map['is_processed'] = Variable<bool>(isProcessed);
    if (!nullToAbsent || processedToType != null) {
      map['processed_to_type'] = Variable<String>(processedToType);
    }
    if (!nullToAbsent || processedToTargetId != null) {
      map['processed_to_target_id'] = Variable<String>(processedToTargetId);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuickNotesTableCompanion toCompanion(bool nullToAbsent) {
    return QuickNotesTableCompanion(
      id: Value(id),
      content: Value(content),
      type: Value(type),
      isProcessed: Value(isProcessed),
      processedToType: processedToType == null && nullToAbsent
          ? const Value.absent()
          : Value(processedToType),
      processedToTargetId: processedToTargetId == null && nullToAbsent
          ? const Value.absent()
          : Value(processedToTargetId),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
    );
  }

  factory QuickNotesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuickNotesTableData(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      isProcessed: serializer.fromJson<bool>(json['isProcessed']),
      processedToType: serializer.fromJson<String?>(json['processedToType']),
      processedToTargetId: serializer.fromJson<String?>(
        json['processedToTargetId'],
      ),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<String>(type),
      'isProcessed': serializer.toJson<bool>(isProcessed),
      'processedToType': serializer.toJson<String?>(processedToType),
      'processedToTargetId': serializer.toJson<String?>(processedToTargetId),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QuickNotesTableData copyWith({
    String? id,
    String? content,
    String? type,
    bool? isProcessed,
    Value<String?> processedToType = const Value.absent(),
    Value<String?> processedToTargetId = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    DateTime? createdAt,
  }) => QuickNotesTableData(
    id: id ?? this.id,
    content: content ?? this.content,
    type: type ?? this.type,
    isProcessed: isProcessed ?? this.isProcessed,
    processedToType: processedToType.present
        ? processedToType.value
        : this.processedToType,
    processedToTargetId: processedToTargetId.present
        ? processedToTargetId.value
        : this.processedToTargetId,
    tags: tags.present ? tags.value : this.tags,
    createdAt: createdAt ?? this.createdAt,
  );
  QuickNotesTableData copyWithCompanion(QuickNotesTableCompanion data) {
    return QuickNotesTableData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      isProcessed: data.isProcessed.present
          ? data.isProcessed.value
          : this.isProcessed,
      processedToType: data.processedToType.present
          ? data.processedToType.value
          : this.processedToType,
      processedToTargetId: data.processedToTargetId.present
          ? data.processedToTargetId.value
          : this.processedToTargetId,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuickNotesTableData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('isProcessed: $isProcessed, ')
          ..write('processedToType: $processedToType, ')
          ..write('processedToTargetId: $processedToTargetId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    type,
    isProcessed,
    processedToType,
    processedToTargetId,
    tags,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuickNotesTableData &&
          other.id == this.id &&
          other.content == this.content &&
          other.type == this.type &&
          other.isProcessed == this.isProcessed &&
          other.processedToType == this.processedToType &&
          other.processedToTargetId == this.processedToTargetId &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt);
}

class QuickNotesTableCompanion extends UpdateCompanion<QuickNotesTableData> {
  final Value<String> id;
  final Value<String> content;
  final Value<String> type;
  final Value<bool> isProcessed;
  final Value<String?> processedToType;
  final Value<String?> processedToTargetId;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const QuickNotesTableCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.isProcessed = const Value.absent(),
    this.processedToType = const Value.absent(),
    this.processedToTargetId = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuickNotesTableCompanion.insert({
    required String id,
    required String content,
    this.type = const Value.absent(),
    this.isProcessed = const Value.absent(),
    this.processedToType = const Value.absent(),
    this.processedToTargetId = const Value.absent(),
    this.tags = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<QuickNotesTableData> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? type,
    Expression<bool>? isProcessed,
    Expression<String>? processedToType,
    Expression<String>? processedToTargetId,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (isProcessed != null) 'is_processed': isProcessed,
      if (processedToType != null) 'processed_to_type': processedToType,
      if (processedToTargetId != null)
        'processed_to_target_id': processedToTargetId,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuickNotesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String>? type,
    Value<bool>? isProcessed,
    Value<String?>? processedToType,
    Value<String?>? processedToTargetId,
    Value<String?>? tags,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return QuickNotesTableCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      isProcessed: isProcessed ?? this.isProcessed,
      processedToType: processedToType ?? this.processedToType,
      processedToTargetId: processedToTargetId ?? this.processedToTargetId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isProcessed.present) {
      map['is_processed'] = Variable<bool>(isProcessed.value);
    }
    if (processedToType.present) {
      map['processed_to_type'] = Variable<String>(processedToType.value);
    }
    if (processedToTargetId.present) {
      map['processed_to_target_id'] = Variable<String>(
        processedToTargetId.value,
      );
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuickNotesTableCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('isProcessed: $isProcessed, ')
          ..write('processedToType: $processedToType, ')
          ..write('processedToTargetId: $processedToTargetId, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTableTable extends JournalEntriesTable
    with TableInfo<$JournalEntriesTableTable, JournalEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reflectionMeta = const VerificationMeta(
    'reflection',
  );
  @override
  late final GeneratedColumn<String> reflection = GeneratedColumn<String>(
    'reflection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gratitudeMeta = const VerificationMeta(
    'gratitude',
  );
  @override
  late final GeneratedColumn<String> gratitude = GeneratedColumn<String>(
    'gratitude',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lessonsLearnedMeta = const VerificationMeta(
    'lessonsLearned',
  );
  @override
  late final GeneratedColumn<String> lessonsLearned = GeneratedColumn<String>(
    'lessons_learned',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tomorrowFocusMeta = const VerificationMeta(
    'tomorrowFocus',
  );
  @override
  late final GeneratedColumn<String> tomorrowFocus = GeneratedColumn<String>(
    'tomorrow_focus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayId,
    reflection,
    mood,
    gratitude,
    lessonsLearned,
    tomorrowFocus,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('reflection')) {
      context.handle(
        _reflectionMeta,
        reflection.isAcceptableOrUnknown(data['reflection']!, _reflectionMeta),
      );
    } else if (isInserting) {
      context.missing(_reflectionMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('gratitude')) {
      context.handle(
        _gratitudeMeta,
        gratitude.isAcceptableOrUnknown(data['gratitude']!, _gratitudeMeta),
      );
    }
    if (data.containsKey('lessons_learned')) {
      context.handle(
        _lessonsLearnedMeta,
        lessonsLearned.isAcceptableOrUnknown(
          data['lessons_learned']!,
          _lessonsLearnedMeta,
        ),
      );
    }
    if (data.containsKey('tomorrow_focus')) {
      context.handle(
        _tomorrowFocusMeta,
        tomorrowFocus.isAcceptableOrUnknown(
          data['tomorrow_focus']!,
          _tomorrowFocusMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      reflection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      ),
      gratitude: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gratitude'],
      ),
      lessonsLearned: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lessons_learned'],
      ),
      tomorrowFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tomorrow_focus'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $JournalEntriesTableTable createAlias(String alias) {
    return $JournalEntriesTableTable(attachedDatabase, alias);
  }
}

class JournalEntriesTableData extends DataClass
    implements Insertable<JournalEntriesTableData> {
  final String id;
  final String dayId;
  final String reflection;
  final int? mood;
  final String? gratitude;
  final String? lessonsLearned;
  final String? tomorrowFocus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntriesTableData({
    required this.id,
    required this.dayId,
    required this.reflection,
    this.mood,
    this.gratitude,
    this.lessonsLearned,
    this.tomorrowFocus,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_id'] = Variable<String>(dayId);
    map['reflection'] = Variable<String>(reflection);
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    if (!nullToAbsent || gratitude != null) {
      map['gratitude'] = Variable<String>(gratitude);
    }
    if (!nullToAbsent || lessonsLearned != null) {
      map['lessons_learned'] = Variable<String>(lessonsLearned);
    }
    if (!nullToAbsent || tomorrowFocus != null) {
      map['tomorrow_focus'] = Variable<String>(tomorrowFocus);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesTableCompanion(
      id: Value(id),
      dayId: Value(dayId),
      reflection: Value(reflection),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      gratitude: gratitude == null && nullToAbsent
          ? const Value.absent()
          : Value(gratitude),
      lessonsLearned: lessonsLearned == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonsLearned),
      tomorrowFocus: tomorrowFocus == null && nullToAbsent
          ? const Value.absent()
          : Value(tomorrowFocus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      dayId: serializer.fromJson<String>(json['dayId']),
      reflection: serializer.fromJson<String>(json['reflection']),
      mood: serializer.fromJson<int?>(json['mood']),
      gratitude: serializer.fromJson<String?>(json['gratitude']),
      lessonsLearned: serializer.fromJson<String?>(json['lessonsLearned']),
      tomorrowFocus: serializer.fromJson<String?>(json['tomorrowFocus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayId': serializer.toJson<String>(dayId),
      'reflection': serializer.toJson<String>(reflection),
      'mood': serializer.toJson<int?>(mood),
      'gratitude': serializer.toJson<String?>(gratitude),
      'lessonsLearned': serializer.toJson<String?>(lessonsLearned),
      'tomorrowFocus': serializer.toJson<String?>(tomorrowFocus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntriesTableData copyWith({
    String? id,
    String? dayId,
    String? reflection,
    Value<int?> mood = const Value.absent(),
    Value<String?> gratitude = const Value.absent(),
    Value<String?> lessonsLearned = const Value.absent(),
    Value<String?> tomorrowFocus = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => JournalEntriesTableData(
    id: id ?? this.id,
    dayId: dayId ?? this.dayId,
    reflection: reflection ?? this.reflection,
    mood: mood.present ? mood.value : this.mood,
    gratitude: gratitude.present ? gratitude.value : this.gratitude,
    lessonsLearned: lessonsLearned.present
        ? lessonsLearned.value
        : this.lessonsLearned,
    tomorrowFocus: tomorrowFocus.present
        ? tomorrowFocus.value
        : this.tomorrowFocus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  JournalEntriesTableData copyWithCompanion(JournalEntriesTableCompanion data) {
    return JournalEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      reflection: data.reflection.present
          ? data.reflection.value
          : this.reflection,
      mood: data.mood.present ? data.mood.value : this.mood,
      gratitude: data.gratitude.present ? data.gratitude.value : this.gratitude,
      lessonsLearned: data.lessonsLearned.present
          ? data.lessonsLearned.value
          : this.lessonsLearned,
      tomorrowFocus: data.tomorrowFocus.present
          ? data.tomorrowFocus.value
          : this.tomorrowFocus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesTableData(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('reflection: $reflection, ')
          ..write('mood: $mood, ')
          ..write('gratitude: $gratitude, ')
          ..write('lessonsLearned: $lessonsLearned, ')
          ..write('tomorrowFocus: $tomorrowFocus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayId,
    reflection,
    mood,
    gratitude,
    lessonsLearned,
    tomorrowFocus,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntriesTableData &&
          other.id == this.id &&
          other.dayId == this.dayId &&
          other.reflection == this.reflection &&
          other.mood == this.mood &&
          other.gratitude == this.gratitude &&
          other.lessonsLearned == this.lessonsLearned &&
          other.tomorrowFocus == this.tomorrowFocus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesTableCompanion
    extends UpdateCompanion<JournalEntriesTableData> {
  final Value<String> id;
  final Value<String> dayId;
  final Value<String> reflection;
  final Value<int?> mood;
  final Value<String?> gratitude;
  final Value<String?> lessonsLearned;
  final Value<String?> tomorrowFocus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JournalEntriesTableCompanion({
    this.id = const Value.absent(),
    this.dayId = const Value.absent(),
    this.reflection = const Value.absent(),
    this.mood = const Value.absent(),
    this.gratitude = const Value.absent(),
    this.lessonsLearned = const Value.absent(),
    this.tomorrowFocus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesTableCompanion.insert({
    required String id,
    required String dayId,
    required String reflection,
    this.mood = const Value.absent(),
    this.gratitude = const Value.absent(),
    this.lessonsLearned = const Value.absent(),
    this.tomorrowFocus = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayId = Value(dayId),
       reflection = Value(reflection),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<JournalEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? dayId,
    Expression<String>? reflection,
    Expression<int>? mood,
    Expression<String>? gratitude,
    Expression<String>? lessonsLearned,
    Expression<String>? tomorrowFocus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayId != null) 'day_id': dayId,
      if (reflection != null) 'reflection': reflection,
      if (mood != null) 'mood': mood,
      if (gratitude != null) 'gratitude': gratitude,
      if (lessonsLearned != null) 'lessons_learned': lessonsLearned,
      if (tomorrowFocus != null) 'tomorrow_focus': tomorrowFocus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? dayId,
    Value<String>? reflection,
    Value<int?>? mood,
    Value<String?>? gratitude,
    Value<String?>? lessonsLearned,
    Value<String?>? tomorrowFocus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return JournalEntriesTableCompanion(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      reflection: reflection ?? this.reflection,
      mood: mood ?? this.mood,
      gratitude: gratitude ?? this.gratitude,
      lessonsLearned: lessonsLearned ?? this.lessonsLearned,
      tomorrowFocus: tomorrowFocus ?? this.tomorrowFocus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (reflection.present) {
      map['reflection'] = Variable<String>(reflection.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (gratitude.present) {
      map['gratitude'] = Variable<String>(gratitude.value);
    }
    if (lessonsLearned.present) {
      map['lessons_learned'] = Variable<String>(lessonsLearned.value);
    }
    if (tomorrowFocus.present) {
      map['tomorrow_focus'] = Variable<String>(tomorrowFocus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('reflection: $reflection, ')
          ..write('mood: $mood, ')
          ..write('gratitude: $gratitude, ')
          ..write('lessonsLearned: $lessonsLearned, ')
          ..write('tomorrowFocus: $tomorrowFocus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyPlansTableTable extends WeeklyPlansTable
    with TableInfo<$WeeklyPlansTableTable, WeeklyPlansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyPlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<String> weekStart = GeneratedColumn<String>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekEndMeta = const VerificationMeta(
    'weekEnd',
  );
  @override
  late final GeneratedColumn<String> weekEnd = GeneratedColumn<String>(
    'week_end',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primordialGoalsMeta = const VerificationMeta(
    'primordialGoals',
  );
  @override
  late final GeneratedColumn<String> primordialGoals = GeneratedColumn<String>(
    'primordial_goals',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectFocusMeta = const VerificationMeta(
    'projectFocus',
  );
  @override
  late final GeneratedColumn<String> projectFocus = GeneratedColumn<String>(
    'project_focus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reflectionMeta = const VerificationMeta(
    'reflection',
  );
  @override
  late final GeneratedColumn<String> reflection = GeneratedColumn<String>(
    'reflection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompleteMeta = const VerificationMeta(
    'isComplete',
  );
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
    'is_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekStart,
    weekEnd,
    primordialGoals,
    projectFocus,
    reflection,
    isComplete,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_plans_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyPlansTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('week_end')) {
      context.handle(
        _weekEndMeta,
        weekEnd.isAcceptableOrUnknown(data['week_end']!, _weekEndMeta),
      );
    } else if (isInserting) {
      context.missing(_weekEndMeta);
    }
    if (data.containsKey('primordial_goals')) {
      context.handle(
        _primordialGoalsMeta,
        primordialGoals.isAcceptableOrUnknown(
          data['primordial_goals']!,
          _primordialGoalsMeta,
        ),
      );
    }
    if (data.containsKey('project_focus')) {
      context.handle(
        _projectFocusMeta,
        projectFocus.isAcceptableOrUnknown(
          data['project_focus']!,
          _projectFocusMeta,
        ),
      );
    }
    if (data.containsKey('reflection')) {
      context.handle(
        _reflectionMeta,
        reflection.isAcceptableOrUnknown(data['reflection']!, _reflectionMeta),
      );
    }
    if (data.containsKey('is_complete')) {
      context.handle(
        _isCompleteMeta,
        isComplete.isAcceptableOrUnknown(data['is_complete']!, _isCompleteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyPlansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyPlansTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_start'],
      )!,
      weekEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_end'],
      )!,
      primordialGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primordial_goals'],
      ),
      projectFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_focus'],
      ),
      reflection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection'],
      ),
      isComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_complete'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeeklyPlansTableTable createAlias(String alias) {
    return $WeeklyPlansTableTable(attachedDatabase, alias);
  }
}

class WeeklyPlansTableData extends DataClass
    implements Insertable<WeeklyPlansTableData> {
  final String id;
  final String weekStart;
  final String weekEnd;
  final String? primordialGoals;
  final String? projectFocus;
  final String? reflection;
  final bool isComplete;
  final DateTime createdAt;
  const WeeklyPlansTableData({
    required this.id,
    required this.weekStart,
    required this.weekEnd,
    this.primordialGoals,
    this.projectFocus,
    this.reflection,
    required this.isComplete,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['week_start'] = Variable<String>(weekStart);
    map['week_end'] = Variable<String>(weekEnd);
    if (!nullToAbsent || primordialGoals != null) {
      map['primordial_goals'] = Variable<String>(primordialGoals);
    }
    if (!nullToAbsent || projectFocus != null) {
      map['project_focus'] = Variable<String>(projectFocus);
    }
    if (!nullToAbsent || reflection != null) {
      map['reflection'] = Variable<String>(reflection);
    }
    map['is_complete'] = Variable<bool>(isComplete);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WeeklyPlansTableCompanion toCompanion(bool nullToAbsent) {
    return WeeklyPlansTableCompanion(
      id: Value(id),
      weekStart: Value(weekStart),
      weekEnd: Value(weekEnd),
      primordialGoals: primordialGoals == null && nullToAbsent
          ? const Value.absent()
          : Value(primordialGoals),
      projectFocus: projectFocus == null && nullToAbsent
          ? const Value.absent()
          : Value(projectFocus),
      reflection: reflection == null && nullToAbsent
          ? const Value.absent()
          : Value(reflection),
      isComplete: Value(isComplete),
      createdAt: Value(createdAt),
    );
  }

  factory WeeklyPlansTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyPlansTableData(
      id: serializer.fromJson<String>(json['id']),
      weekStart: serializer.fromJson<String>(json['weekStart']),
      weekEnd: serializer.fromJson<String>(json['weekEnd']),
      primordialGoals: serializer.fromJson<String?>(json['primordialGoals']),
      projectFocus: serializer.fromJson<String?>(json['projectFocus']),
      reflection: serializer.fromJson<String?>(json['reflection']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'weekStart': serializer.toJson<String>(weekStart),
      'weekEnd': serializer.toJson<String>(weekEnd),
      'primordialGoals': serializer.toJson<String?>(primordialGoals),
      'projectFocus': serializer.toJson<String?>(projectFocus),
      'reflection': serializer.toJson<String?>(reflection),
      'isComplete': serializer.toJson<bool>(isComplete),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WeeklyPlansTableData copyWith({
    String? id,
    String? weekStart,
    String? weekEnd,
    Value<String?> primordialGoals = const Value.absent(),
    Value<String?> projectFocus = const Value.absent(),
    Value<String?> reflection = const Value.absent(),
    bool? isComplete,
    DateTime? createdAt,
  }) => WeeklyPlansTableData(
    id: id ?? this.id,
    weekStart: weekStart ?? this.weekStart,
    weekEnd: weekEnd ?? this.weekEnd,
    primordialGoals: primordialGoals.present
        ? primordialGoals.value
        : this.primordialGoals,
    projectFocus: projectFocus.present ? projectFocus.value : this.projectFocus,
    reflection: reflection.present ? reflection.value : this.reflection,
    isComplete: isComplete ?? this.isComplete,
    createdAt: createdAt ?? this.createdAt,
  );
  WeeklyPlansTableData copyWithCompanion(WeeklyPlansTableCompanion data) {
    return WeeklyPlansTableData(
      id: data.id.present ? data.id.value : this.id,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      weekEnd: data.weekEnd.present ? data.weekEnd.value : this.weekEnd,
      primordialGoals: data.primordialGoals.present
          ? data.primordialGoals.value
          : this.primordialGoals,
      projectFocus: data.projectFocus.present
          ? data.projectFocus.value
          : this.projectFocus,
      reflection: data.reflection.present
          ? data.reflection.value
          : this.reflection,
      isComplete: data.isComplete.present
          ? data.isComplete.value
          : this.isComplete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlansTableData(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('weekEnd: $weekEnd, ')
          ..write('primordialGoals: $primordialGoals, ')
          ..write('projectFocus: $projectFocus, ')
          ..write('reflection: $reflection, ')
          ..write('isComplete: $isComplete, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weekStart,
    weekEnd,
    primordialGoals,
    projectFocus,
    reflection,
    isComplete,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyPlansTableData &&
          other.id == this.id &&
          other.weekStart == this.weekStart &&
          other.weekEnd == this.weekEnd &&
          other.primordialGoals == this.primordialGoals &&
          other.projectFocus == this.projectFocus &&
          other.reflection == this.reflection &&
          other.isComplete == this.isComplete &&
          other.createdAt == this.createdAt);
}

class WeeklyPlansTableCompanion extends UpdateCompanion<WeeklyPlansTableData> {
  final Value<String> id;
  final Value<String> weekStart;
  final Value<String> weekEnd;
  final Value<String?> primordialGoals;
  final Value<String?> projectFocus;
  final Value<String?> reflection;
  final Value<bool> isComplete;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WeeklyPlansTableCompanion({
    this.id = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.weekEnd = const Value.absent(),
    this.primordialGoals = const Value.absent(),
    this.projectFocus = const Value.absent(),
    this.reflection = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyPlansTableCompanion.insert({
    required String id,
    required String weekStart,
    required String weekEnd,
    this.primordialGoals = const Value.absent(),
    this.projectFocus = const Value.absent(),
    this.reflection = const Value.absent(),
    this.isComplete = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       weekStart = Value(weekStart),
       weekEnd = Value(weekEnd),
       createdAt = Value(createdAt);
  static Insertable<WeeklyPlansTableData> custom({
    Expression<String>? id,
    Expression<String>? weekStart,
    Expression<String>? weekEnd,
    Expression<String>? primordialGoals,
    Expression<String>? projectFocus,
    Expression<String>? reflection,
    Expression<bool>? isComplete,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStart != null) 'week_start': weekStart,
      if (weekEnd != null) 'week_end': weekEnd,
      if (primordialGoals != null) 'primordial_goals': primordialGoals,
      if (projectFocus != null) 'project_focus': projectFocus,
      if (reflection != null) 'reflection': reflection,
      if (isComplete != null) 'is_complete': isComplete,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyPlansTableCompanion copyWith({
    Value<String>? id,
    Value<String>? weekStart,
    Value<String>? weekEnd,
    Value<String?>? primordialGoals,
    Value<String?>? projectFocus,
    Value<String?>? reflection,
    Value<bool>? isComplete,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WeeklyPlansTableCompanion(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      weekEnd: weekEnd ?? this.weekEnd,
      primordialGoals: primordialGoals ?? this.primordialGoals,
      projectFocus: projectFocus ?? this.projectFocus,
      reflection: reflection ?? this.reflection,
      isComplete: isComplete ?? this.isComplete,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<String>(weekStart.value);
    }
    if (weekEnd.present) {
      map['week_end'] = Variable<String>(weekEnd.value);
    }
    if (primordialGoals.present) {
      map['primordial_goals'] = Variable<String>(primordialGoals.value);
    }
    if (projectFocus.present) {
      map['project_focus'] = Variable<String>(projectFocus.value);
    }
    if (reflection.present) {
      map['reflection'] = Variable<String>(reflection.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlansTableCompanion(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('weekEnd: $weekEnd, ')
          ..write('primordialGoals: $primordialGoals, ')
          ..write('projectFocus: $projectFocus, ')
          ..write('reflection: $reflection, ')
          ..write('isComplete: $isComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeekDaysTableTable extends WeekDaysTable
    with TableInfo<$WeekDaysTableTable, WeekDaysTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeekDaysTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekIdMeta = const VerificationMeta('weekId');
  @override
  late final GeneratedColumn<String> weekId = GeneratedColumn<String>(
    'week_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signalTaskIdsMeta = const VerificationMeta(
    'signalTaskIds',
  );
  @override
  late final GeneratedColumn<String> signalTaskIds = GeneratedColumn<String>(
    'signal_task_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noiseTaskIdsMeta = const VerificationMeta(
    'noiseTaskIds',
  );
  @override
  late final GeneratedColumn<String> noiseTaskIds = GeneratedColumn<String>(
    'noise_task_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dayId,
    weekId,
    signalTaskIds,
    noiseTaskIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'week_days_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeekDaysTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('week_id')) {
      context.handle(
        _weekIdMeta,
        weekId.isAcceptableOrUnknown(data['week_id']!, _weekIdMeta),
      );
    } else if (isInserting) {
      context.missing(_weekIdMeta);
    }
    if (data.containsKey('signal_task_ids')) {
      context.handle(
        _signalTaskIdsMeta,
        signalTaskIds.isAcceptableOrUnknown(
          data['signal_task_ids']!,
          _signalTaskIdsMeta,
        ),
      );
    }
    if (data.containsKey('noise_task_ids')) {
      context.handle(
        _noiseTaskIdsMeta,
        noiseTaskIds.isAcceptableOrUnknown(
          data['noise_task_ids']!,
          _noiseTaskIdsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dayId};
  @override
  WeekDaysTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeekDaysTableData(
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      weekId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}week_id'],
      )!,
      signalTaskIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signal_task_ids'],
      ),
      noiseTaskIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}noise_task_ids'],
      ),
    );
  }

  @override
  $WeekDaysTableTable createAlias(String alias) {
    return $WeekDaysTableTable(attachedDatabase, alias);
  }
}

class WeekDaysTableData extends DataClass
    implements Insertable<WeekDaysTableData> {
  final String dayId;
  final String weekId;
  final String? signalTaskIds;
  final String? noiseTaskIds;
  const WeekDaysTableData({
    required this.dayId,
    required this.weekId,
    this.signalTaskIds,
    this.noiseTaskIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day_id'] = Variable<String>(dayId);
    map['week_id'] = Variable<String>(weekId);
    if (!nullToAbsent || signalTaskIds != null) {
      map['signal_task_ids'] = Variable<String>(signalTaskIds);
    }
    if (!nullToAbsent || noiseTaskIds != null) {
      map['noise_task_ids'] = Variable<String>(noiseTaskIds);
    }
    return map;
  }

  WeekDaysTableCompanion toCompanion(bool nullToAbsent) {
    return WeekDaysTableCompanion(
      dayId: Value(dayId),
      weekId: Value(weekId),
      signalTaskIds: signalTaskIds == null && nullToAbsent
          ? const Value.absent()
          : Value(signalTaskIds),
      noiseTaskIds: noiseTaskIds == null && nullToAbsent
          ? const Value.absent()
          : Value(noiseTaskIds),
    );
  }

  factory WeekDaysTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeekDaysTableData(
      dayId: serializer.fromJson<String>(json['dayId']),
      weekId: serializer.fromJson<String>(json['weekId']),
      signalTaskIds: serializer.fromJson<String?>(json['signalTaskIds']),
      noiseTaskIds: serializer.fromJson<String?>(json['noiseTaskIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dayId': serializer.toJson<String>(dayId),
      'weekId': serializer.toJson<String>(weekId),
      'signalTaskIds': serializer.toJson<String?>(signalTaskIds),
      'noiseTaskIds': serializer.toJson<String?>(noiseTaskIds),
    };
  }

  WeekDaysTableData copyWith({
    String? dayId,
    String? weekId,
    Value<String?> signalTaskIds = const Value.absent(),
    Value<String?> noiseTaskIds = const Value.absent(),
  }) => WeekDaysTableData(
    dayId: dayId ?? this.dayId,
    weekId: weekId ?? this.weekId,
    signalTaskIds: signalTaskIds.present
        ? signalTaskIds.value
        : this.signalTaskIds,
    noiseTaskIds: noiseTaskIds.present ? noiseTaskIds.value : this.noiseTaskIds,
  );
  WeekDaysTableData copyWithCompanion(WeekDaysTableCompanion data) {
    return WeekDaysTableData(
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      weekId: data.weekId.present ? data.weekId.value : this.weekId,
      signalTaskIds: data.signalTaskIds.present
          ? data.signalTaskIds.value
          : this.signalTaskIds,
      noiseTaskIds: data.noiseTaskIds.present
          ? data.noiseTaskIds.value
          : this.noiseTaskIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeekDaysTableData(')
          ..write('dayId: $dayId, ')
          ..write('weekId: $weekId, ')
          ..write('signalTaskIds: $signalTaskIds, ')
          ..write('noiseTaskIds: $noiseTaskIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dayId, weekId, signalTaskIds, noiseTaskIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeekDaysTableData &&
          other.dayId == this.dayId &&
          other.weekId == this.weekId &&
          other.signalTaskIds == this.signalTaskIds &&
          other.noiseTaskIds == this.noiseTaskIds);
}

class WeekDaysTableCompanion extends UpdateCompanion<WeekDaysTableData> {
  final Value<String> dayId;
  final Value<String> weekId;
  final Value<String?> signalTaskIds;
  final Value<String?> noiseTaskIds;
  final Value<int> rowid;
  const WeekDaysTableCompanion({
    this.dayId = const Value.absent(),
    this.weekId = const Value.absent(),
    this.signalTaskIds = const Value.absent(),
    this.noiseTaskIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeekDaysTableCompanion.insert({
    required String dayId,
    required String weekId,
    this.signalTaskIds = const Value.absent(),
    this.noiseTaskIds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dayId = Value(dayId),
       weekId = Value(weekId);
  static Insertable<WeekDaysTableData> custom({
    Expression<String>? dayId,
    Expression<String>? weekId,
    Expression<String>? signalTaskIds,
    Expression<String>? noiseTaskIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dayId != null) 'day_id': dayId,
      if (weekId != null) 'week_id': weekId,
      if (signalTaskIds != null) 'signal_task_ids': signalTaskIds,
      if (noiseTaskIds != null) 'noise_task_ids': noiseTaskIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeekDaysTableCompanion copyWith({
    Value<String>? dayId,
    Value<String>? weekId,
    Value<String?>? signalTaskIds,
    Value<String?>? noiseTaskIds,
    Value<int>? rowid,
  }) {
    return WeekDaysTableCompanion(
      dayId: dayId ?? this.dayId,
      weekId: weekId ?? this.weekId,
      signalTaskIds: signalTaskIds ?? this.signalTaskIds,
      noiseTaskIds: noiseTaskIds ?? this.noiseTaskIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (weekId.present) {
      map['week_id'] = Variable<String>(weekId.value);
    }
    if (signalTaskIds.present) {
      map['signal_task_ids'] = Variable<String>(signalTaskIds.value);
    }
    if (noiseTaskIds.present) {
      map['noise_task_ids'] = Variable<String>(noiseTaskIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeekDaysTableCompanion(')
          ..write('dayId: $dayId, ')
          ..write('weekId: $weekId, ')
          ..write('signalTaskIds: $signalTaskIds, ')
          ..write('noiseTaskIds: $noiseTaskIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimerSessionsTableTable extends TimerSessionsTable
    with TableInfo<$TimerSessionsTableTable, TimerSessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimerSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecsMeta = const VerificationMeta(
    'durationSecs',
  );
  @override
  late final GeneratedColumn<int> durationSecs = GeneratedColumn<int>(
    'duration_secs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wasCompletedMeta = const VerificationMeta(
    'wasCompleted',
  );
  @override
  late final GeneratedColumn<bool> wasCompleted = GeneratedColumn<bool>(
    'was_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    taskId,
    durationSecs,
    wasCompleted,
    dayId,
    startedAt,
    finishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timer_sessions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimerSessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('duration_secs')) {
      context.handle(
        _durationSecsMeta,
        durationSecs.isAcceptableOrUnknown(
          data['duration_secs']!,
          _durationSecsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecsMeta);
    }
    if (data.containsKey('was_completed')) {
      context.handle(
        _wasCompletedMeta,
        wasCompleted.isAcceptableOrUnknown(
          data['was_completed']!,
          _wasCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wasCompletedMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimerSessionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimerSessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      durationSecs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_secs'],
      )!,
      wasCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_completed'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
    );
  }

  @override
  $TimerSessionsTableTable createAlias(String alias) {
    return $TimerSessionsTableTable(attachedDatabase, alias);
  }
}

class TimerSessionsTableData extends DataClass
    implements Insertable<TimerSessionsTableData> {
  final String id;
  final String mode;
  final String? taskId;
  final int durationSecs;
  final bool wasCompleted;
  final String dayId;
  final DateTime startedAt;
  final DateTime? finishedAt;
  const TimerSessionsTableData({
    required this.id,
    required this.mode,
    this.taskId,
    required this.durationSecs,
    required this.wasCompleted,
    required this.dayId,
    required this.startedAt,
    this.finishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['duration_secs'] = Variable<int>(durationSecs);
    map['was_completed'] = Variable<bool>(wasCompleted);
    map['day_id'] = Variable<String>(dayId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  TimerSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return TimerSessionsTableCompanion(
      id: Value(id),
      mode: Value(mode),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      durationSecs: Value(durationSecs),
      wasCompleted: Value(wasCompleted),
      dayId: Value(dayId),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory TimerSessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimerSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      durationSecs: serializer.fromJson<int>(json['durationSecs']),
      wasCompleted: serializer.fromJson<bool>(json['wasCompleted']),
      dayId: serializer.fromJson<String>(json['dayId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mode': serializer.toJson<String>(mode),
      'taskId': serializer.toJson<String?>(taskId),
      'durationSecs': serializer.toJson<int>(durationSecs),
      'wasCompleted': serializer.toJson<bool>(wasCompleted),
      'dayId': serializer.toJson<String>(dayId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  TimerSessionsTableData copyWith({
    String? id,
    String? mode,
    Value<String?> taskId = const Value.absent(),
    int? durationSecs,
    bool? wasCompleted,
    String? dayId,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
  }) => TimerSessionsTableData(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    taskId: taskId.present ? taskId.value : this.taskId,
    durationSecs: durationSecs ?? this.durationSecs,
    wasCompleted: wasCompleted ?? this.wasCompleted,
    dayId: dayId ?? this.dayId,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
  );
  TimerSessionsTableData copyWithCompanion(TimerSessionsTableCompanion data) {
    return TimerSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      durationSecs: data.durationSecs.present
          ? data.durationSecs.value
          : this.durationSecs,
      wasCompleted: data.wasCompleted.present
          ? data.wasCompleted.value
          : this.wasCompleted,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimerSessionsTableData(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('taskId: $taskId, ')
          ..write('durationSecs: $durationSecs, ')
          ..write('wasCompleted: $wasCompleted, ')
          ..write('dayId: $dayId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    taskId,
    durationSecs,
    wasCompleted,
    dayId,
    startedAt,
    finishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimerSessionsTableData &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.taskId == this.taskId &&
          other.durationSecs == this.durationSecs &&
          other.wasCompleted == this.wasCompleted &&
          other.dayId == this.dayId &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt);
}

class TimerSessionsTableCompanion
    extends UpdateCompanion<TimerSessionsTableData> {
  final Value<String> id;
  final Value<String> mode;
  final Value<String?> taskId;
  final Value<int> durationSecs;
  final Value<bool> wasCompleted;
  final Value<String> dayId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> rowid;
  const TimerSessionsTableCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.taskId = const Value.absent(),
    this.durationSecs = const Value.absent(),
    this.wasCompleted = const Value.absent(),
    this.dayId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimerSessionsTableCompanion.insert({
    required String id,
    required String mode,
    this.taskId = const Value.absent(),
    required int durationSecs,
    required bool wasCompleted,
    required String dayId,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mode = Value(mode),
       durationSecs = Value(durationSecs),
       wasCompleted = Value(wasCompleted),
       dayId = Value(dayId),
       startedAt = Value(startedAt);
  static Insertable<TimerSessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? mode,
    Expression<String>? taskId,
    Expression<int>? durationSecs,
    Expression<bool>? wasCompleted,
    Expression<String>? dayId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (taskId != null) 'task_id': taskId,
      if (durationSecs != null) 'duration_secs': durationSecs,
      if (wasCompleted != null) 'was_completed': wasCompleted,
      if (dayId != null) 'day_id': dayId,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimerSessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? mode,
    Value<String?>? taskId,
    Value<int>? durationSecs,
    Value<bool>? wasCompleted,
    Value<String>? dayId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? rowid,
  }) {
    return TimerSessionsTableCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      taskId: taskId ?? this.taskId,
      durationSecs: durationSecs ?? this.durationSecs,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      dayId: dayId ?? this.dayId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (durationSecs.present) {
      map['duration_secs'] = Variable<int>(durationSecs.value);
    }
    if (wasCompleted.present) {
      map['was_completed'] = Variable<bool>(wasCompleted.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimerSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('taskId: $taskId, ')
          ..write('durationSecs: $durationSecs, ')
          ..write('wasCompleted: $wasCompleted, ')
          ..write('dayId: $dayId, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskAreasTableTable extends TaskAreasTable
    with TableInfo<$TaskAreasTableTable, TaskAreasTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskAreasTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isBuiltinMeta = const VerificationMeta(
    'isBuiltin',
  );
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
    'is_builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    emoji,
    colorHex,
    iconName,
    sortOrder,
    isBuiltin,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_areas_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskAreasTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_builtin')) {
      context.handle(
        _isBuiltinMeta,
        isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskAreasTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskAreasTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isBuiltin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_builtin'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskAreasTableTable createAlias(String alias) {
    return $TaskAreasTableTable(attachedDatabase, alias);
  }
}

class TaskAreasTableData extends DataClass
    implements Insertable<TaskAreasTableData> {
  final String id;
  final String label;
  final String emoji;
  final String colorHex;
  final String? iconName;
  final int sortOrder;
  final bool isBuiltin;
  final DateTime createdAt;
  const TaskAreasTableData({
    required this.id,
    required this.label,
    required this.emoji,
    required this.colorHex,
    this.iconName,
    required this.sortOrder,
    required this.isBuiltin,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['emoji'] = Variable<String>(emoji);
    map['color_hex'] = Variable<String>(colorHex);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_builtin'] = Variable<bool>(isBuiltin);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskAreasTableCompanion toCompanion(bool nullToAbsent) {
    return TaskAreasTableCompanion(
      id: Value(id),
      label: Value(label),
      emoji: Value(emoji),
      colorHex: Value(colorHex),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      sortOrder: Value(sortOrder),
      isBuiltin: Value(isBuiltin),
      createdAt: Value(createdAt),
    );
  }

  factory TaskAreasTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskAreasTableData(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      emoji: serializer.fromJson<String>(json['emoji']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'emoji': serializer.toJson<String>(emoji),
      'colorHex': serializer.toJson<String>(colorHex),
      'iconName': serializer.toJson<String?>(iconName),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskAreasTableData copyWith({
    String? id,
    String? label,
    String? emoji,
    String? colorHex,
    Value<String?> iconName = const Value.absent(),
    int? sortOrder,
    bool? isBuiltin,
    DateTime? createdAt,
  }) => TaskAreasTableData(
    id: id ?? this.id,
    label: label ?? this.label,
    emoji: emoji ?? this.emoji,
    colorHex: colorHex ?? this.colorHex,
    iconName: iconName.present ? iconName.value : this.iconName,
    sortOrder: sortOrder ?? this.sortOrder,
    isBuiltin: isBuiltin ?? this.isBuiltin,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskAreasTableData copyWithCompanion(TaskAreasTableCompanion data) {
    return TaskAreasTableData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskAreasTableData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('emoji: $emoji, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    emoji,
    colorHex,
    iconName,
    sortOrder,
    isBuiltin,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskAreasTableData &&
          other.id == this.id &&
          other.label == this.label &&
          other.emoji == this.emoji &&
          other.colorHex == this.colorHex &&
          other.iconName == this.iconName &&
          other.sortOrder == this.sortOrder &&
          other.isBuiltin == this.isBuiltin &&
          other.createdAt == this.createdAt);
}

class TaskAreasTableCompanion extends UpdateCompanion<TaskAreasTableData> {
  final Value<String> id;
  final Value<String> label;
  final Value<String> emoji;
  final Value<String> colorHex;
  final Value<String?> iconName;
  final Value<int> sortOrder;
  final Value<bool> isBuiltin;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaskAreasTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.emoji = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskAreasTableCompanion.insert({
    required String id,
    required String label,
    this.emoji = const Value.absent(),
    required String colorHex,
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       colorHex = Value(colorHex),
       createdAt = Value(createdAt);
  static Insertable<TaskAreasTableData> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? emoji,
    Expression<String>? colorHex,
    Expression<String>? iconName,
    Expression<int>? sortOrder,
    Expression<bool>? isBuiltin,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (emoji != null) 'emoji': emoji,
      if (colorHex != null) 'color_hex': colorHex,
      if (iconName != null) 'icon_name': iconName,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskAreasTableCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String>? emoji,
    Value<String>? colorHex,
    Value<String?>? iconName,
    Value<int>? sortOrder,
    Value<bool>? isBuiltin,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TaskAreasTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      emoji: emoji ?? this.emoji,
      colorHex: colorHex ?? this.colorHex,
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
      isBuiltin: isBuiltin ?? this.isBuiltin,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskAreasTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('emoji: $emoji, ')
          ..write('colorHex: $colorHex, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyReviewsTableTable extends DailyReviewsTable
    with TableInfo<$DailyReviewsTableTable, DailyReviewsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyReviewsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
    'day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodNoteMeta = const VerificationMeta(
    'moodNote',
  );
  @override
  late final GeneratedColumn<String> moodNote = GeneratedColumn<String>(
    'mood_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smokedMeta = const VerificationMeta('smoked');
  @override
  late final GeneratedColumn<bool> smoked = GeneratedColumn<bool>(
    'smoked',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("smoked" IN (0, 1))',
    ),
  );
  static const VerificationMeta _tookMedicationMeta = const VerificationMeta(
    'tookMedication',
  );
  @override
  late final GeneratedColumn<bool> tookMedication = GeneratedColumn<bool>(
    'took_medication',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("took_medication" IN (0, 1))',
    ),
  );
  static const VerificationMeta _patternsMeta = const VerificationMeta(
    'patterns',
  );
  @override
  late final GeneratedColumn<String> patterns = GeneratedColumn<String>(
    'patterns',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _highlightsMeta = const VerificationMeta(
    'highlights',
  );
  @override
  late final GeneratedColumn<String> highlights = GeneratedColumn<String>(
    'highlights',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayId,
    completedAt,
    mood,
    moodNote,
    smoked,
    tookMedication,
    patterns,
    highlights,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_reviews_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyReviewsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_id')) {
      context.handle(
        _dayIdMeta,
        dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('mood_note')) {
      context.handle(
        _moodNoteMeta,
        moodNote.isAcceptableOrUnknown(data['mood_note']!, _moodNoteMeta),
      );
    }
    if (data.containsKey('smoked')) {
      context.handle(
        _smokedMeta,
        smoked.isAcceptableOrUnknown(data['smoked']!, _smokedMeta),
      );
    }
    if (data.containsKey('took_medication')) {
      context.handle(
        _tookMedicationMeta,
        tookMedication.isAcceptableOrUnknown(
          data['took_medication']!,
          _tookMedicationMeta,
        ),
      );
    }
    if (data.containsKey('patterns')) {
      context.handle(
        _patternsMeta,
        patterns.isAcceptableOrUnknown(data['patterns']!, _patternsMeta),
      );
    }
    if (data.containsKey('highlights')) {
      context.handle(
        _highlightsMeta,
        highlights.isAcceptableOrUnknown(data['highlights']!, _highlightsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {dayId},
  ];
  @override
  DailyReviewsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyReviewsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      ),
      moodNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_note'],
      ),
      smoked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}smoked'],
      ),
      tookMedication: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}took_medication'],
      ),
      patterns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patterns'],
      ),
      highlights: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}highlights'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyReviewsTableTable createAlias(String alias) {
    return $DailyReviewsTableTable(attachedDatabase, alias);
  }
}

class DailyReviewsTableData extends DataClass
    implements Insertable<DailyReviewsTableData> {
  final String id;
  final String dayId;
  final DateTime? completedAt;
  final int? mood;
  final String? moodNote;
  final bool? smoked;
  final bool? tookMedication;
  final String? patterns;
  final String? highlights;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyReviewsTableData({
    required this.id,
    required this.dayId,
    this.completedAt,
    this.mood,
    this.moodNote,
    this.smoked,
    this.tookMedication,
    this.patterns,
    this.highlights,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_id'] = Variable<String>(dayId);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    if (!nullToAbsent || moodNote != null) {
      map['mood_note'] = Variable<String>(moodNote);
    }
    if (!nullToAbsent || smoked != null) {
      map['smoked'] = Variable<bool>(smoked);
    }
    if (!nullToAbsent || tookMedication != null) {
      map['took_medication'] = Variable<bool>(tookMedication);
    }
    if (!nullToAbsent || patterns != null) {
      map['patterns'] = Variable<String>(patterns);
    }
    if (!nullToAbsent || highlights != null) {
      map['highlights'] = Variable<String>(highlights);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyReviewsTableCompanion toCompanion(bool nullToAbsent) {
    return DailyReviewsTableCompanion(
      id: Value(id),
      dayId: Value(dayId),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      moodNote: moodNote == null && nullToAbsent
          ? const Value.absent()
          : Value(moodNote),
      smoked: smoked == null && nullToAbsent
          ? const Value.absent()
          : Value(smoked),
      tookMedication: tookMedication == null && nullToAbsent
          ? const Value.absent()
          : Value(tookMedication),
      patterns: patterns == null && nullToAbsent
          ? const Value.absent()
          : Value(patterns),
      highlights: highlights == null && nullToAbsent
          ? const Value.absent()
          : Value(highlights),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyReviewsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyReviewsTableData(
      id: serializer.fromJson<String>(json['id']),
      dayId: serializer.fromJson<String>(json['dayId']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      mood: serializer.fromJson<int?>(json['mood']),
      moodNote: serializer.fromJson<String?>(json['moodNote']),
      smoked: serializer.fromJson<bool?>(json['smoked']),
      tookMedication: serializer.fromJson<bool?>(json['tookMedication']),
      patterns: serializer.fromJson<String?>(json['patterns']),
      highlights: serializer.fromJson<String?>(json['highlights']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayId': serializer.toJson<String>(dayId),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'mood': serializer.toJson<int?>(mood),
      'moodNote': serializer.toJson<String?>(moodNote),
      'smoked': serializer.toJson<bool?>(smoked),
      'tookMedication': serializer.toJson<bool?>(tookMedication),
      'patterns': serializer.toJson<String?>(patterns),
      'highlights': serializer.toJson<String?>(highlights),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyReviewsTableData copyWith({
    String? id,
    String? dayId,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> mood = const Value.absent(),
    Value<String?> moodNote = const Value.absent(),
    Value<bool?> smoked = const Value.absent(),
    Value<bool?> tookMedication = const Value.absent(),
    Value<String?> patterns = const Value.absent(),
    Value<String?> highlights = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyReviewsTableData(
    id: id ?? this.id,
    dayId: dayId ?? this.dayId,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    mood: mood.present ? mood.value : this.mood,
    moodNote: moodNote.present ? moodNote.value : this.moodNote,
    smoked: smoked.present ? smoked.value : this.smoked,
    tookMedication: tookMedication.present
        ? tookMedication.value
        : this.tookMedication,
    patterns: patterns.present ? patterns.value : this.patterns,
    highlights: highlights.present ? highlights.value : this.highlights,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyReviewsTableData copyWithCompanion(DailyReviewsTableCompanion data) {
    return DailyReviewsTableData(
      id: data.id.present ? data.id.value : this.id,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      mood: data.mood.present ? data.mood.value : this.mood,
      moodNote: data.moodNote.present ? data.moodNote.value : this.moodNote,
      smoked: data.smoked.present ? data.smoked.value : this.smoked,
      tookMedication: data.tookMedication.present
          ? data.tookMedication.value
          : this.tookMedication,
      patterns: data.patterns.present ? data.patterns.value : this.patterns,
      highlights: data.highlights.present
          ? data.highlights.value
          : this.highlights,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyReviewsTableData(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('completedAt: $completedAt, ')
          ..write('mood: $mood, ')
          ..write('moodNote: $moodNote, ')
          ..write('smoked: $smoked, ')
          ..write('tookMedication: $tookMedication, ')
          ..write('patterns: $patterns, ')
          ..write('highlights: $highlights, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayId,
    completedAt,
    mood,
    moodNote,
    smoked,
    tookMedication,
    patterns,
    highlights,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyReviewsTableData &&
          other.id == this.id &&
          other.dayId == this.dayId &&
          other.completedAt == this.completedAt &&
          other.mood == this.mood &&
          other.moodNote == this.moodNote &&
          other.smoked == this.smoked &&
          other.tookMedication == this.tookMedication &&
          other.patterns == this.patterns &&
          other.highlights == this.highlights &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyReviewsTableCompanion
    extends UpdateCompanion<DailyReviewsTableData> {
  final Value<String> id;
  final Value<String> dayId;
  final Value<DateTime?> completedAt;
  final Value<int?> mood;
  final Value<String?> moodNote;
  final Value<bool?> smoked;
  final Value<bool?> tookMedication;
  final Value<String?> patterns;
  final Value<String?> highlights;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyReviewsTableCompanion({
    this.id = const Value.absent(),
    this.dayId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.mood = const Value.absent(),
    this.moodNote = const Value.absent(),
    this.smoked = const Value.absent(),
    this.tookMedication = const Value.absent(),
    this.patterns = const Value.absent(),
    this.highlights = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyReviewsTableCompanion.insert({
    required String id,
    required String dayId,
    this.completedAt = const Value.absent(),
    this.mood = const Value.absent(),
    this.moodNote = const Value.absent(),
    this.smoked = const Value.absent(),
    this.tookMedication = const Value.absent(),
    this.patterns = const Value.absent(),
    this.highlights = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayId = Value(dayId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyReviewsTableData> custom({
    Expression<String>? id,
    Expression<String>? dayId,
    Expression<DateTime>? completedAt,
    Expression<int>? mood,
    Expression<String>? moodNote,
    Expression<bool>? smoked,
    Expression<bool>? tookMedication,
    Expression<String>? patterns,
    Expression<String>? highlights,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayId != null) 'day_id': dayId,
      if (completedAt != null) 'completed_at': completedAt,
      if (mood != null) 'mood': mood,
      if (moodNote != null) 'mood_note': moodNote,
      if (smoked != null) 'smoked': smoked,
      if (tookMedication != null) 'took_medication': tookMedication,
      if (patterns != null) 'patterns': patterns,
      if (highlights != null) 'highlights': highlights,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyReviewsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? dayId,
    Value<DateTime?>? completedAt,
    Value<int?>? mood,
    Value<String?>? moodNote,
    Value<bool?>? smoked,
    Value<bool?>? tookMedication,
    Value<String?>? patterns,
    Value<String?>? highlights,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyReviewsTableCompanion(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      completedAt: completedAt ?? this.completedAt,
      mood: mood ?? this.mood,
      moodNote: moodNote ?? this.moodNote,
      smoked: smoked ?? this.smoked,
      tookMedication: tookMedication ?? this.tookMedication,
      patterns: patterns ?? this.patterns,
      highlights: highlights ?? this.highlights,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (moodNote.present) {
      map['mood_note'] = Variable<String>(moodNote.value);
    }
    if (smoked.present) {
      map['smoked'] = Variable<bool>(smoked.value);
    }
    if (tookMedication.present) {
      map['took_medication'] = Variable<bool>(tookMedication.value);
    }
    if (patterns.present) {
      map['patterns'] = Variable<String>(patterns.value);
    }
    if (highlights.present) {
      map['highlights'] = Variable<String>(highlights.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyReviewsTableCompanion(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('completedAt: $completedAt, ')
          ..write('mood: $mood, ')
          ..write('moodNote: $moodNote, ')
          ..write('smoked: $smoked, ')
          ..write('tookMedication: $tookMedication, ')
          ..write('patterns: $patterns, ')
          ..write('highlights: $highlights, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $HabitsTableTable habitsTable = $HabitsTableTable(this);
  late final $HabitCompletionsTableTable habitCompletionsTable =
      $HabitCompletionsTableTable(this);
  late final $ProjectsTableTable projectsTable = $ProjectsTableTable(this);
  late final $QuickNotesTableTable quickNotesTable = $QuickNotesTableTable(
    this,
  );
  late final $JournalEntriesTableTable journalEntriesTable =
      $JournalEntriesTableTable(this);
  late final $WeeklyPlansTableTable weeklyPlansTable = $WeeklyPlansTableTable(
    this,
  );
  late final $WeekDaysTableTable weekDaysTable = $WeekDaysTableTable(this);
  late final $TimerSessionsTableTable timerSessionsTable =
      $TimerSessionsTableTable(this);
  late final $TaskAreasTableTable taskAreasTable = $TaskAreasTableTable(this);
  late final $DailyReviewsTableTable dailyReviewsTable =
      $DailyReviewsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasksTable,
    habitsTable,
    habitCompletionsTable,
    projectsTable,
    quickNotesTable,
    journalEntriesTable,
    weeklyPlansTable,
    weekDaysTable,
    timerSessionsTable,
    taskAreasTable,
    dailyReviewsTable,
  ];
}

typedef $$TasksTableTableCreateCompanionBuilder =
    TasksTableCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<String> priority,
      Value<String> status,
      Value<String?> action,
      Value<String?> area,
      Value<String?> delegatedTo,
      Value<String?> deferredTo,
      Value<String?> scheduledDate,
      Value<String?> reminder,
      Value<String?> parentProjectId,
      Value<String?> subtaskIds,
      Value<String?> dayId,
      Value<int?> estimatedMinutes,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    TasksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> priority,
      Value<String> status,
      Value<String?> action,
      Value<String?> area,
      Value<String?> delegatedTo,
      Value<String?> deferredTo,
      Value<String?> scheduledDate,
      Value<String?> reminder,
      Value<String?> parentProjectId,
      Value<String?> subtaskIds,
      Value<String?> dayId,
      Value<int?> estimatedMinutes,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get delegatedTo => $composableBuilder(
    column: $table.delegatedTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deferredTo => $composableBuilder(
    column: $table.deferredTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminder => $composableBuilder(
    column: $table.reminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentProjectId => $composableBuilder(
    column: $table.parentProjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtaskIds => $composableBuilder(
    column: $table.subtaskIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get delegatedTo => $composableBuilder(
    column: $table.delegatedTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deferredTo => $composableBuilder(
    column: $table.deferredTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminder => $composableBuilder(
    column: $table.reminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentProjectId => $composableBuilder(
    column: $table.parentProjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtaskIds => $composableBuilder(
    column: $table.subtaskIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get delegatedTo => $composableBuilder(
    column: $table.delegatedTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deferredTo => $composableBuilder(
    column: $table.deferredTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminder =>
      $composableBuilder(column: $table.reminder, builder: (column) => column);

  GeneratedColumn<String> get parentProjectId => $composableBuilder(
    column: $table.parentProjectId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subtaskIds => $composableBuilder(
    column: $table.subtaskIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          TasksTableData,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (
            TasksTableData,
            BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>,
          ),
          TasksTableData,
          PrefetchHooks Function()
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> action = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> delegatedTo = const Value.absent(),
                Value<String?> deferredTo = const Value.absent(),
                Value<String?> scheduledDate = const Value.absent(),
                Value<String?> reminder = const Value.absent(),
                Value<String?> parentProjectId = const Value.absent(),
                Value<String?> subtaskIds = const Value.absent(),
                Value<String?> dayId = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                title: title,
                description: description,
                priority: priority,
                status: status,
                action: action,
                area: area,
                delegatedTo: delegatedTo,
                deferredTo: deferredTo,
                scheduledDate: scheduledDate,
                reminder: reminder,
                parentProjectId: parentProjectId,
                subtaskIds: subtaskIds,
                dayId: dayId,
                estimatedMinutes: estimatedMinutes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> action = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> delegatedTo = const Value.absent(),
                Value<String?> deferredTo = const Value.absent(),
                Value<String?> scheduledDate = const Value.absent(),
                Value<String?> reminder = const Value.absent(),
                Value<String?> parentProjectId = const Value.absent(),
                Value<String?> subtaskIds = const Value.absent(),
                Value<String?> dayId = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                priority: priority,
                status: status,
                action: action,
                area: area,
                delegatedTo: delegatedTo,
                deferredTo: deferredTo,
                scheduledDate: scheduledDate,
                reminder: reminder,
                parentProjectId: parentProjectId,
                subtaskIds: subtaskIds,
                dayId: dayId,
                estimatedMinutes: estimatedMinutes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      TasksTableData,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (
        TasksTableData,
        BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>,
      ),
      TasksTableData,
      PrefetchHooks Function()
    >;
typedef $$HabitsTableTableCreateCompanionBuilder =
    HabitsTableCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required String frequency,
      Value<int> targetPerWeek,
      Value<String?> area,
      Value<String?> color,
      Value<String?> icon,
      Value<bool> isArchived,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$HabitsTableTableUpdateCompanionBuilder =
    HabitsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> frequency,
      Value<int> targetPerWeek,
      Value<String?> area,
      Value<String?> color,
      Value<String?> icon,
      Value<bool> isArchived,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HabitsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPerWeek => $composableBuilder(
    column: $table.targetPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPerWeek => $composableBuilder(
    column: $table.targetPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get targetPerWeek => $composableBuilder(
    column: $table.targetPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HabitsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTableTable,
          HabitsTableData,
          $$HabitsTableTableFilterComposer,
          $$HabitsTableTableOrderingComposer,
          $$HabitsTableTableAnnotationComposer,
          $$HabitsTableTableCreateCompanionBuilder,
          $$HabitsTableTableUpdateCompanionBuilder,
          (
            HabitsTableData,
            BaseReferences<_$AppDatabase, $HabitsTableTable, HabitsTableData>,
          ),
          HabitsTableData,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableTableManager(_$AppDatabase db, $HabitsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int> targetPerWeek = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsTableCompanion(
                id: id,
                title: title,
                description: description,
                frequency: frequency,
                targetPerWeek: targetPerWeek,
                area: area,
                color: color,
                icon: icon,
                isArchived: isArchived,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required String frequency,
                Value<int> targetPerWeek = const Value.absent(),
                Value<String?> area = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitsTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                frequency: frequency,
                targetPerWeek: targetPerWeek,
                area: area,
                color: color,
                icon: icon,
                isArchived: isArchived,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTableTable,
      HabitsTableData,
      $$HabitsTableTableFilterComposer,
      $$HabitsTableTableOrderingComposer,
      $$HabitsTableTableAnnotationComposer,
      $$HabitsTableTableCreateCompanionBuilder,
      $$HabitsTableTableUpdateCompanionBuilder,
      (
        HabitsTableData,
        BaseReferences<_$AppDatabase, $HabitsTableTable, HabitsTableData>,
      ),
      HabitsTableData,
      PrefetchHooks Function()
    >;
typedef $$HabitCompletionsTableTableCreateCompanionBuilder =
    HabitCompletionsTableCompanion Function({
      required String id,
      required String habitId,
      required String dayId,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$HabitCompletionsTableTableUpdateCompanionBuilder =
    HabitCompletionsTableCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<String> dayId,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

class $$HabitCompletionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTableTable> {
  $$HabitCompletionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitCompletionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTableTable> {
  $$HabitCompletionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitCompletionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitCompletionsTableTable> {
  $$HabitCompletionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$HabitCompletionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitCompletionsTableTable,
          HabitCompletionsTableData,
          $$HabitCompletionsTableTableFilterComposer,
          $$HabitCompletionsTableTableOrderingComposer,
          $$HabitCompletionsTableTableAnnotationComposer,
          $$HabitCompletionsTableTableCreateCompanionBuilder,
          $$HabitCompletionsTableTableUpdateCompanionBuilder,
          (
            HabitCompletionsTableData,
            BaseReferences<
              _$AppDatabase,
              $HabitCompletionsTableTable,
              HabitCompletionsTableData
            >,
          ),
          HabitCompletionsTableData,
          PrefetchHooks Function()
        > {
  $$HabitCompletionsTableTableTableManager(
    _$AppDatabase db,
    $HabitCompletionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitCompletionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$HabitCompletionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HabitCompletionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsTableCompanion(
                id: id,
                habitId: habitId,
                dayId: dayId,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required String dayId,
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitCompletionsTableCompanion.insert(
                id: id,
                habitId: habitId,
                dayId: dayId,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitCompletionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitCompletionsTableTable,
      HabitCompletionsTableData,
      $$HabitCompletionsTableTableFilterComposer,
      $$HabitCompletionsTableTableOrderingComposer,
      $$HabitCompletionsTableTableAnnotationComposer,
      $$HabitCompletionsTableTableCreateCompanionBuilder,
      $$HabitCompletionsTableTableUpdateCompanionBuilder,
      (
        HabitCompletionsTableData,
        BaseReferences<
          _$AppDatabase,
          $HabitCompletionsTableTable,
          HabitCompletionsTableData
        >,
      ),
      HabitCompletionsTableData,
      PrefetchHooks Function()
    >;
typedef $$ProjectsTableTableCreateCompanionBuilder =
    ProjectsTableCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required String category,
      Value<String> status,
      required String color,
      Value<String?> icon,
      Value<String?> targetDate,
      Value<String?> taskIds,
      Value<String?> weeklyGoals,
      Value<String?> notes,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableTableUpdateCompanionBuilder =
    ProjectsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> category,
      Value<String> status,
      Value<String> color,
      Value<String?> icon,
      Value<String?> targetDate,
      Value<String?> taskIds,
      Value<String?> weeklyGoals,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

class $$ProjectsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskIds => $composableBuilder(
    column: $table.taskIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weeklyGoals => $composableBuilder(
    column: $table.weeklyGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskIds => $composableBuilder(
    column: $table.taskIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weeklyGoals => $composableBuilder(
    column: $table.weeklyGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskIds =>
      $composableBuilder(column: $table.taskIds, builder: (column) => column);

  GeneratedColumn<String> get weeklyGoals => $composableBuilder(
    column: $table.weeklyGoals,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$ProjectsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTableTable,
          ProjectsTableData,
          $$ProjectsTableTableFilterComposer,
          $$ProjectsTableTableOrderingComposer,
          $$ProjectsTableTableAnnotationComposer,
          $$ProjectsTableTableCreateCompanionBuilder,
          $$ProjectsTableTableUpdateCompanionBuilder,
          (
            ProjectsTableData,
            BaseReferences<
              _$AppDatabase,
              $ProjectsTableTable,
              ProjectsTableData
            >,
          ),
          ProjectsTableData,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableTableManager(_$AppDatabase db, $ProjectsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> targetDate = const Value.absent(),
                Value<String?> taskIds = const Value.absent(),
                Value<String?> weeklyGoals = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsTableCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                status: status,
                color: color,
                icon: icon,
                targetDate: targetDate,
                taskIds: taskIds,
                weeklyGoals: weeklyGoals,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required String category,
                Value<String> status = const Value.absent(),
                required String color,
                Value<String?> icon = const Value.absent(),
                Value<String?> targetDate = const Value.absent(),
                Value<String?> taskIds = const Value.absent(),
                Value<String?> weeklyGoals = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                status: status,
                color: color,
                icon: icon,
                targetDate: targetDate,
                taskIds: taskIds,
                weeklyGoals: weeklyGoals,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTableTable,
      ProjectsTableData,
      $$ProjectsTableTableFilterComposer,
      $$ProjectsTableTableOrderingComposer,
      $$ProjectsTableTableAnnotationComposer,
      $$ProjectsTableTableCreateCompanionBuilder,
      $$ProjectsTableTableUpdateCompanionBuilder,
      (
        ProjectsTableData,
        BaseReferences<_$AppDatabase, $ProjectsTableTable, ProjectsTableData>,
      ),
      ProjectsTableData,
      PrefetchHooks Function()
    >;
typedef $$QuickNotesTableTableCreateCompanionBuilder =
    QuickNotesTableCompanion Function({
      required String id,
      required String content,
      Value<String> type,
      Value<bool> isProcessed,
      Value<String?> processedToType,
      Value<String?> processedToTargetId,
      Value<String?> tags,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$QuickNotesTableTableUpdateCompanionBuilder =
    QuickNotesTableCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String> type,
      Value<bool> isProcessed,
      Value<String?> processedToType,
      Value<String?> processedToTargetId,
      Value<String?> tags,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$QuickNotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $QuickNotesTableTable> {
  $$QuickNotesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processedToType => $composableBuilder(
    column: $table.processedToType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processedToTargetId => $composableBuilder(
    column: $table.processedToTargetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuickNotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $QuickNotesTableTable> {
  $$QuickNotesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processedToType => $composableBuilder(
    column: $table.processedToType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processedToTargetId => $composableBuilder(
    column: $table.processedToTargetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuickNotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuickNotesTableTable> {
  $$QuickNotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processedToType => $composableBuilder(
    column: $table.processedToType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processedToTargetId => $composableBuilder(
    column: $table.processedToTargetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$QuickNotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuickNotesTableTable,
          QuickNotesTableData,
          $$QuickNotesTableTableFilterComposer,
          $$QuickNotesTableTableOrderingComposer,
          $$QuickNotesTableTableAnnotationComposer,
          $$QuickNotesTableTableCreateCompanionBuilder,
          $$QuickNotesTableTableUpdateCompanionBuilder,
          (
            QuickNotesTableData,
            BaseReferences<
              _$AppDatabase,
              $QuickNotesTableTable,
              QuickNotesTableData
            >,
          ),
          QuickNotesTableData,
          PrefetchHooks Function()
        > {
  $$QuickNotesTableTableTableManager(
    _$AppDatabase db,
    $QuickNotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuickNotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuickNotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuickNotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isProcessed = const Value.absent(),
                Value<String?> processedToType = const Value.absent(),
                Value<String?> processedToTargetId = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuickNotesTableCompanion(
                id: id,
                content: content,
                type: type,
                isProcessed: isProcessed,
                processedToType: processedToType,
                processedToTargetId: processedToTargetId,
                tags: tags,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                Value<String> type = const Value.absent(),
                Value<bool> isProcessed = const Value.absent(),
                Value<String?> processedToType = const Value.absent(),
                Value<String?> processedToTargetId = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => QuickNotesTableCompanion.insert(
                id: id,
                content: content,
                type: type,
                isProcessed: isProcessed,
                processedToType: processedToType,
                processedToTargetId: processedToTargetId,
                tags: tags,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuickNotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuickNotesTableTable,
      QuickNotesTableData,
      $$QuickNotesTableTableFilterComposer,
      $$QuickNotesTableTableOrderingComposer,
      $$QuickNotesTableTableAnnotationComposer,
      $$QuickNotesTableTableCreateCompanionBuilder,
      $$QuickNotesTableTableUpdateCompanionBuilder,
      (
        QuickNotesTableData,
        BaseReferences<
          _$AppDatabase,
          $QuickNotesTableTable,
          QuickNotesTableData
        >,
      ),
      QuickNotesTableData,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableTableCreateCompanionBuilder =
    JournalEntriesTableCompanion Function({
      required String id,
      required String dayId,
      required String reflection,
      Value<int?> mood,
      Value<String?> gratitude,
      Value<String?> lessonsLearned,
      Value<String?> tomorrowFocus,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$JournalEntriesTableTableUpdateCompanionBuilder =
    JournalEntriesTableCompanion Function({
      Value<String> id,
      Value<String> dayId,
      Value<String> reflection,
      Value<int?> mood,
      Value<String?> gratitude,
      Value<String?> lessonsLearned,
      Value<String?> tomorrowFocus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$JournalEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTableTable> {
  $$JournalEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gratitude => $composableBuilder(
    column: $table.gratitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonsLearned => $composableBuilder(
    column: $table.lessonsLearned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tomorrowFocus => $composableBuilder(
    column: $table.tomorrowFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTableTable> {
  $$JournalEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gratitude => $composableBuilder(
    column: $table.gratitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonsLearned => $composableBuilder(
    column: $table.lessonsLearned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tomorrowFocus => $composableBuilder(
    column: $table.tomorrowFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTableTable> {
  $$JournalEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get gratitude =>
      $composableBuilder(column: $table.gratitude, builder: (column) => column);

  GeneratedColumn<String> get lessonsLearned => $composableBuilder(
    column: $table.lessonsLearned,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tomorrowFocus => $composableBuilder(
    column: $table.tomorrowFocus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JournalEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTableTable,
          JournalEntriesTableData,
          $$JournalEntriesTableTableFilterComposer,
          $$JournalEntriesTableTableOrderingComposer,
          $$JournalEntriesTableTableAnnotationComposer,
          $$JournalEntriesTableTableCreateCompanionBuilder,
          $$JournalEntriesTableTableUpdateCompanionBuilder,
          (
            JournalEntriesTableData,
            BaseReferences<
              _$AppDatabase,
              $JournalEntriesTableTable,
              JournalEntriesTableData
            >,
          ),
          JournalEntriesTableData,
          PrefetchHooks Function()
        > {
  $$JournalEntriesTableTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<String> reflection = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<String?> gratitude = const Value.absent(),
                Value<String?> lessonsLearned = const Value.absent(),
                Value<String?> tomorrowFocus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesTableCompanion(
                id: id,
                dayId: dayId,
                reflection: reflection,
                mood: mood,
                gratitude: gratitude,
                lessonsLearned: lessonsLearned,
                tomorrowFocus: tomorrowFocus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayId,
                required String reflection,
                Value<int?> mood = const Value.absent(),
                Value<String?> gratitude = const Value.absent(),
                Value<String?> lessonsLearned = const Value.absent(),
                Value<String?> tomorrowFocus = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesTableCompanion.insert(
                id: id,
                dayId: dayId,
                reflection: reflection,
                mood: mood,
                gratitude: gratitude,
                lessonsLearned: lessonsLearned,
                tomorrowFocus: tomorrowFocus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTableTable,
      JournalEntriesTableData,
      $$JournalEntriesTableTableFilterComposer,
      $$JournalEntriesTableTableOrderingComposer,
      $$JournalEntriesTableTableAnnotationComposer,
      $$JournalEntriesTableTableCreateCompanionBuilder,
      $$JournalEntriesTableTableUpdateCompanionBuilder,
      (
        JournalEntriesTableData,
        BaseReferences<
          _$AppDatabase,
          $JournalEntriesTableTable,
          JournalEntriesTableData
        >,
      ),
      JournalEntriesTableData,
      PrefetchHooks Function()
    >;
typedef $$WeeklyPlansTableTableCreateCompanionBuilder =
    WeeklyPlansTableCompanion Function({
      required String id,
      required String weekStart,
      required String weekEnd,
      Value<String?> primordialGoals,
      Value<String?> projectFocus,
      Value<String?> reflection,
      Value<bool> isComplete,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$WeeklyPlansTableTableUpdateCompanionBuilder =
    WeeklyPlansTableCompanion Function({
      Value<String> id,
      Value<String> weekStart,
      Value<String> weekEnd,
      Value<String?> primordialGoals,
      Value<String?> projectFocus,
      Value<String?> reflection,
      Value<bool> isComplete,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$WeeklyPlansTableTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTableTable> {
  $$WeeklyPlansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekEnd => $composableBuilder(
    column: $table.weekEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primordialGoals => $composableBuilder(
    column: $table.primordialGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectFocus => $composableBuilder(
    column: $table.projectFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyPlansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTableTable> {
  $$WeeklyPlansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekEnd => $composableBuilder(
    column: $table.weekEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primordialGoals => $composableBuilder(
    column: $table.primordialGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectFocus => $composableBuilder(
    column: $table.projectFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyPlansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTableTable> {
  $$WeeklyPlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<String> get weekEnd =>
      $composableBuilder(column: $table.weekEnd, builder: (column) => column);

  GeneratedColumn<String> get primordialGoals => $composableBuilder(
    column: $table.primordialGoals,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectFocus => $composableBuilder(
    column: $table.projectFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WeeklyPlansTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyPlansTableTable,
          WeeklyPlansTableData,
          $$WeeklyPlansTableTableFilterComposer,
          $$WeeklyPlansTableTableOrderingComposer,
          $$WeeklyPlansTableTableAnnotationComposer,
          $$WeeklyPlansTableTableCreateCompanionBuilder,
          $$WeeklyPlansTableTableUpdateCompanionBuilder,
          (
            WeeklyPlansTableData,
            BaseReferences<
              _$AppDatabase,
              $WeeklyPlansTableTable,
              WeeklyPlansTableData
            >,
          ),
          WeeklyPlansTableData,
          PrefetchHooks Function()
        > {
  $$WeeklyPlansTableTableTableManager(
    _$AppDatabase db,
    $WeeklyPlansTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyPlansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyPlansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyPlansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> weekStart = const Value.absent(),
                Value<String> weekEnd = const Value.absent(),
                Value<String?> primordialGoals = const Value.absent(),
                Value<String?> projectFocus = const Value.absent(),
                Value<String?> reflection = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyPlansTableCompanion(
                id: id,
                weekStart: weekStart,
                weekEnd: weekEnd,
                primordialGoals: primordialGoals,
                projectFocus: projectFocus,
                reflection: reflection,
                isComplete: isComplete,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String weekStart,
                required String weekEnd,
                Value<String?> primordialGoals = const Value.absent(),
                Value<String?> projectFocus = const Value.absent(),
                Value<String?> reflection = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WeeklyPlansTableCompanion.insert(
                id: id,
                weekStart: weekStart,
                weekEnd: weekEnd,
                primordialGoals: primordialGoals,
                projectFocus: projectFocus,
                reflection: reflection,
                isComplete: isComplete,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyPlansTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyPlansTableTable,
      WeeklyPlansTableData,
      $$WeeklyPlansTableTableFilterComposer,
      $$WeeklyPlansTableTableOrderingComposer,
      $$WeeklyPlansTableTableAnnotationComposer,
      $$WeeklyPlansTableTableCreateCompanionBuilder,
      $$WeeklyPlansTableTableUpdateCompanionBuilder,
      (
        WeeklyPlansTableData,
        BaseReferences<
          _$AppDatabase,
          $WeeklyPlansTableTable,
          WeeklyPlansTableData
        >,
      ),
      WeeklyPlansTableData,
      PrefetchHooks Function()
    >;
typedef $$WeekDaysTableTableCreateCompanionBuilder =
    WeekDaysTableCompanion Function({
      required String dayId,
      required String weekId,
      Value<String?> signalTaskIds,
      Value<String?> noiseTaskIds,
      Value<int> rowid,
    });
typedef $$WeekDaysTableTableUpdateCompanionBuilder =
    WeekDaysTableCompanion Function({
      Value<String> dayId,
      Value<String> weekId,
      Value<String?> signalTaskIds,
      Value<String?> noiseTaskIds,
      Value<int> rowid,
    });

class $$WeekDaysTableTableFilterComposer
    extends Composer<_$AppDatabase, $WeekDaysTableTable> {
  $$WeekDaysTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekId => $composableBuilder(
    column: $table.weekId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signalTaskIds => $composableBuilder(
    column: $table.signalTaskIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noiseTaskIds => $composableBuilder(
    column: $table.noiseTaskIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeekDaysTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WeekDaysTableTable> {
  $$WeekDaysTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekId => $composableBuilder(
    column: $table.weekId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signalTaskIds => $composableBuilder(
    column: $table.signalTaskIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noiseTaskIds => $composableBuilder(
    column: $table.noiseTaskIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeekDaysTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeekDaysTableTable> {
  $$WeekDaysTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<String> get weekId =>
      $composableBuilder(column: $table.weekId, builder: (column) => column);

  GeneratedColumn<String> get signalTaskIds => $composableBuilder(
    column: $table.signalTaskIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get noiseTaskIds => $composableBuilder(
    column: $table.noiseTaskIds,
    builder: (column) => column,
  );
}

class $$WeekDaysTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeekDaysTableTable,
          WeekDaysTableData,
          $$WeekDaysTableTableFilterComposer,
          $$WeekDaysTableTableOrderingComposer,
          $$WeekDaysTableTableAnnotationComposer,
          $$WeekDaysTableTableCreateCompanionBuilder,
          $$WeekDaysTableTableUpdateCompanionBuilder,
          (
            WeekDaysTableData,
            BaseReferences<
              _$AppDatabase,
              $WeekDaysTableTable,
              WeekDaysTableData
            >,
          ),
          WeekDaysTableData,
          PrefetchHooks Function()
        > {
  $$WeekDaysTableTableTableManager(_$AppDatabase db, $WeekDaysTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeekDaysTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeekDaysTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeekDaysTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dayId = const Value.absent(),
                Value<String> weekId = const Value.absent(),
                Value<String?> signalTaskIds = const Value.absent(),
                Value<String?> noiseTaskIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeekDaysTableCompanion(
                dayId: dayId,
                weekId: weekId,
                signalTaskIds: signalTaskIds,
                noiseTaskIds: noiseTaskIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dayId,
                required String weekId,
                Value<String?> signalTaskIds = const Value.absent(),
                Value<String?> noiseTaskIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeekDaysTableCompanion.insert(
                dayId: dayId,
                weekId: weekId,
                signalTaskIds: signalTaskIds,
                noiseTaskIds: noiseTaskIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeekDaysTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeekDaysTableTable,
      WeekDaysTableData,
      $$WeekDaysTableTableFilterComposer,
      $$WeekDaysTableTableOrderingComposer,
      $$WeekDaysTableTableAnnotationComposer,
      $$WeekDaysTableTableCreateCompanionBuilder,
      $$WeekDaysTableTableUpdateCompanionBuilder,
      (
        WeekDaysTableData,
        BaseReferences<_$AppDatabase, $WeekDaysTableTable, WeekDaysTableData>,
      ),
      WeekDaysTableData,
      PrefetchHooks Function()
    >;
typedef $$TimerSessionsTableTableCreateCompanionBuilder =
    TimerSessionsTableCompanion Function({
      required String id,
      required String mode,
      Value<String?> taskId,
      required int durationSecs,
      required bool wasCompleted,
      required String dayId,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });
typedef $$TimerSessionsTableTableUpdateCompanionBuilder =
    TimerSessionsTableCompanion Function({
      Value<String> id,
      Value<String> mode,
      Value<String?> taskId,
      Value<int> durationSecs,
      Value<bool> wasCompleted,
      Value<String> dayId,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> rowid,
    });

class $$TimerSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TimerSessionsTableTable> {
  $$TimerSessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasCompleted => $composableBuilder(
    column: $table.wasCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimerSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TimerSessionsTableTable> {
  $$TimerSessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasCompleted => $composableBuilder(
    column: $table.wasCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimerSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimerSessionsTableTable> {
  $$TimerSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get durationSecs => $composableBuilder(
    column: $table.durationSecs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wasCompleted => $composableBuilder(
    column: $table.wasCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );
}

class $$TimerSessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimerSessionsTableTable,
          TimerSessionsTableData,
          $$TimerSessionsTableTableFilterComposer,
          $$TimerSessionsTableTableOrderingComposer,
          $$TimerSessionsTableTableAnnotationComposer,
          $$TimerSessionsTableTableCreateCompanionBuilder,
          $$TimerSessionsTableTableUpdateCompanionBuilder,
          (
            TimerSessionsTableData,
            BaseReferences<
              _$AppDatabase,
              $TimerSessionsTableTable,
              TimerSessionsTableData
            >,
          ),
          TimerSessionsTableData,
          PrefetchHooks Function()
        > {
  $$TimerSessionsTableTableTableManager(
    _$AppDatabase db,
    $TimerSessionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimerSessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimerSessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimerSessionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int> durationSecs = const Value.absent(),
                Value<bool> wasCompleted = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimerSessionsTableCompanion(
                id: id,
                mode: mode,
                taskId: taskId,
                durationSecs: durationSecs,
                wasCompleted: wasCompleted,
                dayId: dayId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mode,
                Value<String?> taskId = const Value.absent(),
                required int durationSecs,
                required bool wasCompleted,
                required String dayId,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimerSessionsTableCompanion.insert(
                id: id,
                mode: mode,
                taskId: taskId,
                durationSecs: durationSecs,
                wasCompleted: wasCompleted,
                dayId: dayId,
                startedAt: startedAt,
                finishedAt: finishedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TimerSessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimerSessionsTableTable,
      TimerSessionsTableData,
      $$TimerSessionsTableTableFilterComposer,
      $$TimerSessionsTableTableOrderingComposer,
      $$TimerSessionsTableTableAnnotationComposer,
      $$TimerSessionsTableTableCreateCompanionBuilder,
      $$TimerSessionsTableTableUpdateCompanionBuilder,
      (
        TimerSessionsTableData,
        BaseReferences<
          _$AppDatabase,
          $TimerSessionsTableTable,
          TimerSessionsTableData
        >,
      ),
      TimerSessionsTableData,
      PrefetchHooks Function()
    >;
typedef $$TaskAreasTableTableCreateCompanionBuilder =
    TaskAreasTableCompanion Function({
      required String id,
      required String label,
      Value<String> emoji,
      required String colorHex,
      Value<String?> iconName,
      Value<int> sortOrder,
      Value<bool> isBuiltin,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TaskAreasTableTableUpdateCompanionBuilder =
    TaskAreasTableCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String> emoji,
      Value<String> colorHex,
      Value<String?> iconName,
      Value<int> sortOrder,
      Value<bool> isBuiltin,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TaskAreasTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskAreasTableTable> {
  $$TaskAreasTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskAreasTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskAreasTableTable> {
  $$TaskAreasTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskAreasTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskAreasTableTable> {
  $$TaskAreasTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltin =>
      $composableBuilder(column: $table.isBuiltin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TaskAreasTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskAreasTableTable,
          TaskAreasTableData,
          $$TaskAreasTableTableFilterComposer,
          $$TaskAreasTableTableOrderingComposer,
          $$TaskAreasTableTableAnnotationComposer,
          $$TaskAreasTableTableCreateCompanionBuilder,
          $$TaskAreasTableTableUpdateCompanionBuilder,
          (
            TaskAreasTableData,
            BaseReferences<
              _$AppDatabase,
              $TaskAreasTableTable,
              TaskAreasTableData
            >,
          ),
          TaskAreasTableData,
          PrefetchHooks Function()
        > {
  $$TaskAreasTableTableTableManager(
    _$AppDatabase db,
    $TaskAreasTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskAreasTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskAreasTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskAreasTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskAreasTableCompanion(
                id: id,
                label: label,
                emoji: emoji,
                colorHex: colorHex,
                iconName: iconName,
                sortOrder: sortOrder,
                isBuiltin: isBuiltin,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<String> emoji = const Value.absent(),
                required String colorHex,
                Value<String?> iconName = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskAreasTableCompanion.insert(
                id: id,
                label: label,
                emoji: emoji,
                colorHex: colorHex,
                iconName: iconName,
                sortOrder: sortOrder,
                isBuiltin: isBuiltin,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskAreasTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskAreasTableTable,
      TaskAreasTableData,
      $$TaskAreasTableTableFilterComposer,
      $$TaskAreasTableTableOrderingComposer,
      $$TaskAreasTableTableAnnotationComposer,
      $$TaskAreasTableTableCreateCompanionBuilder,
      $$TaskAreasTableTableUpdateCompanionBuilder,
      (
        TaskAreasTableData,
        BaseReferences<_$AppDatabase, $TaskAreasTableTable, TaskAreasTableData>,
      ),
      TaskAreasTableData,
      PrefetchHooks Function()
    >;
typedef $$DailyReviewsTableTableCreateCompanionBuilder =
    DailyReviewsTableCompanion Function({
      required String id,
      required String dayId,
      Value<DateTime?> completedAt,
      Value<int?> mood,
      Value<String?> moodNote,
      Value<bool?> smoked,
      Value<bool?> tookMedication,
      Value<String?> patterns,
      Value<String?> highlights,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DailyReviewsTableTableUpdateCompanionBuilder =
    DailyReviewsTableCompanion Function({
      Value<String> id,
      Value<String> dayId,
      Value<DateTime?> completedAt,
      Value<int?> mood,
      Value<String?> moodNote,
      Value<bool?> smoked,
      Value<bool?> tookMedication,
      Value<String?> patterns,
      Value<String?> highlights,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyReviewsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyReviewsTableTable> {
  $$DailyReviewsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodNote => $composableBuilder(
    column: $table.moodNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get smoked => $composableBuilder(
    column: $table.smoked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tookMedication => $composableBuilder(
    column: $table.tookMedication,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patterns => $composableBuilder(
    column: $table.patterns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get highlights => $composableBuilder(
    column: $table.highlights,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyReviewsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyReviewsTableTable> {
  $$DailyReviewsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayId => $composableBuilder(
    column: $table.dayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodNote => $composableBuilder(
    column: $table.moodNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get smoked => $composableBuilder(
    column: $table.smoked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tookMedication => $composableBuilder(
    column: $table.tookMedication,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patterns => $composableBuilder(
    column: $table.patterns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get highlights => $composableBuilder(
    column: $table.highlights,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyReviewsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyReviewsTableTable> {
  $$DailyReviewsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayId =>
      $composableBuilder(column: $table.dayId, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get moodNote =>
      $composableBuilder(column: $table.moodNote, builder: (column) => column);

  GeneratedColumn<bool> get smoked =>
      $composableBuilder(column: $table.smoked, builder: (column) => column);

  GeneratedColumn<bool> get tookMedication => $composableBuilder(
    column: $table.tookMedication,
    builder: (column) => column,
  );

  GeneratedColumn<String> get patterns =>
      $composableBuilder(column: $table.patterns, builder: (column) => column);

  GeneratedColumn<String> get highlights => $composableBuilder(
    column: $table.highlights,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyReviewsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyReviewsTableTable,
          DailyReviewsTableData,
          $$DailyReviewsTableTableFilterComposer,
          $$DailyReviewsTableTableOrderingComposer,
          $$DailyReviewsTableTableAnnotationComposer,
          $$DailyReviewsTableTableCreateCompanionBuilder,
          $$DailyReviewsTableTableUpdateCompanionBuilder,
          (
            DailyReviewsTableData,
            BaseReferences<
              _$AppDatabase,
              $DailyReviewsTableTable,
              DailyReviewsTableData
            >,
          ),
          DailyReviewsTableData,
          PrefetchHooks Function()
        > {
  $$DailyReviewsTableTableTableManager(
    _$AppDatabase db,
    $DailyReviewsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyReviewsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyReviewsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyReviewsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<String?> moodNote = const Value.absent(),
                Value<bool?> smoked = const Value.absent(),
                Value<bool?> tookMedication = const Value.absent(),
                Value<String?> patterns = const Value.absent(),
                Value<String?> highlights = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyReviewsTableCompanion(
                id: id,
                dayId: dayId,
                completedAt: completedAt,
                mood: mood,
                moodNote: moodNote,
                smoked: smoked,
                tookMedication: tookMedication,
                patterns: patterns,
                highlights: highlights,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayId,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<String?> moodNote = const Value.absent(),
                Value<bool?> smoked = const Value.absent(),
                Value<bool?> tookMedication = const Value.absent(),
                Value<String?> patterns = const Value.absent(),
                Value<String?> highlights = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyReviewsTableCompanion.insert(
                id: id,
                dayId: dayId,
                completedAt: completedAt,
                mood: mood,
                moodNote: moodNote,
                smoked: smoked,
                tookMedication: tookMedication,
                patterns: patterns,
                highlights: highlights,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyReviewsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyReviewsTableTable,
      DailyReviewsTableData,
      $$DailyReviewsTableTableFilterComposer,
      $$DailyReviewsTableTableOrderingComposer,
      $$DailyReviewsTableTableAnnotationComposer,
      $$DailyReviewsTableTableCreateCompanionBuilder,
      $$DailyReviewsTableTableUpdateCompanionBuilder,
      (
        DailyReviewsTableData,
        BaseReferences<
          _$AppDatabase,
          $DailyReviewsTableTable,
          DailyReviewsTableData
        >,
      ),
      DailyReviewsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$HabitsTableTableTableManager get habitsTable =>
      $$HabitsTableTableTableManager(_db, _db.habitsTable);
  $$HabitCompletionsTableTableTableManager get habitCompletionsTable =>
      $$HabitCompletionsTableTableTableManager(_db, _db.habitCompletionsTable);
  $$ProjectsTableTableTableManager get projectsTable =>
      $$ProjectsTableTableTableManager(_db, _db.projectsTable);
  $$QuickNotesTableTableTableManager get quickNotesTable =>
      $$QuickNotesTableTableTableManager(_db, _db.quickNotesTable);
  $$JournalEntriesTableTableTableManager get journalEntriesTable =>
      $$JournalEntriesTableTableTableManager(_db, _db.journalEntriesTable);
  $$WeeklyPlansTableTableTableManager get weeklyPlansTable =>
      $$WeeklyPlansTableTableTableManager(_db, _db.weeklyPlansTable);
  $$WeekDaysTableTableTableManager get weekDaysTable =>
      $$WeekDaysTableTableTableManager(_db, _db.weekDaysTable);
  $$TimerSessionsTableTableTableManager get timerSessionsTable =>
      $$TimerSessionsTableTableTableManager(_db, _db.timerSessionsTable);
  $$TaskAreasTableTableTableManager get taskAreasTable =>
      $$TaskAreasTableTableTableManager(_db, _db.taskAreasTable);
  $$DailyReviewsTableTableTableManager get dailyReviewsTable =>
      $$DailyReviewsTableTableTableManager(_db, _db.dailyReviewsTable);
}
