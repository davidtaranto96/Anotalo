import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../utils/json_utils.dart';
import '../../features/proyectos/domain/models/project.dart';

class ProjectService {
  final AppDatabase _db;
  ProjectService(this._db);

  static const _uuid = Uuid();

  Project _fromRow(ProjectsTableData row) => Project(
    id: row.id,
    title: row.title,
    description: row.description,
    category: ProjectCategory.values.firstWhere(
      (e) => e.name == row.category,
      orElse: () => ProjectCategory.personal,
    ),
    status: ProjectStatus.values.firstWhere(
      (e) => e.name == row.status,
      orElse: () => ProjectStatus.active,
    ),
    color: row.color,
    icon: row.icon,
    targetDate: row.targetDate,
    taskIds: decodeStringList(row.taskIds),
    weeklyGoals: decodeStringList(row.weeklyGoals),
    notes: row.notes,
    createdAt: row.createdAt,
    completedAt: row.completedAt,
  );

  Stream<List<Project>> watchAllProjects() {
    return (_db.select(_db.projectsTable)
      ..where((t) => t.status.isNotIn(['archived']))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> addProject(Project project) async {
    await _db.into(_db.projectsTable).insert(ProjectsTableCompanion.insert(
      id: project.id.isEmpty ? _uuid.v4() : project.id,
      title: project.title,
      description: Value(project.description),
      category: project.category.name,
      status: Value(project.status.name),
      color: project.color,
      icon: Value(project.icon),
      targetDate: Value(project.targetDate),
      taskIds: Value(encodeStringList(project.taskIds)),
      weeklyGoals: Value(encodeStringList(project.weeklyGoals)),
      notes: Value(project.notes),
      createdAt: project.createdAt,
      completedAt: Value(project.completedAt),
    ));
  }

  Future<void> completeProject(String id) async {
    await (_db.update(_db.projectsTable)..where((t) => t.id.equals(id)))
        .write(ProjectsTableCompanion(
      status: const Value('completed'),
      completedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateNotes(String id, String notes) async {
    await (_db.update(_db.projectsTable)..where((t) => t.id.equals(id)))
        .write(ProjectsTableCompanion(notes: Value(notes)));
  }

  Future<void> updateStatus(String id, ProjectStatus status) async {
    final companion = ProjectsTableCompanion(
      status: Value(status.name),
      completedAt: status == ProjectStatus.completed
          ? Value(DateTime.now())
          : const Value.absent(),
    );
    await (_db.update(_db.projectsTable)..where((t) => t.id.equals(id)))
        .write(companion);
  }

  Stream<List<Project>> watchAllProjectsIncludingArchived() {
    return (_db.select(_db.projectsTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> addTaskToProject(String projectId, String taskId) async {
    final project = await (_db.select(_db.projectsTable)
      ..where((t) => t.id.equals(projectId))).getSingleOrNull();
    if (project == null) return;
    final ids = decodeStringList(project.taskIds);
    if (!ids.contains(taskId)) {
      ids.add(taskId);
      await (_db.update(_db.projectsTable)..where((t) => t.id.equals(projectId)))
          .write(ProjectsTableCompanion(taskIds: Value(encodeStringList(ids))));
    }
  }

  Future<void> removeTaskFromProject(String projectId, String taskId) async {
    final project = await (_db.select(_db.projectsTable)
      ..where((t) => t.id.equals(projectId))).getSingleOrNull();
    if (project == null) return;
    final ids = decodeStringList(project.taskIds);
    ids.remove(taskId);
    await (_db.update(_db.projectsTable)..where((t) => t.id.equals(projectId)))
        .write(ProjectsTableCompanion(taskIds: Value(encodeStringList(ids))));
  }
}
