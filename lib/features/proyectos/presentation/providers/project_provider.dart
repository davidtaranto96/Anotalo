import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/project_service.dart';
import '../../domain/models/project.dart';

final projectServiceProvider = Provider((ref) =>
    ProjectService(ref.watch(databaseProvider)));

final allProjectsProvider = StreamProvider<List<Project>>((ref) =>
    ref.watch(projectServiceProvider).watchAllProjects());

final activeProjectsProvider = Provider<List<Project>>((ref) =>
    ref.watch(allProjectsProvider).valueOrNull
        ?.where((p) => p.status == ProjectStatus.active).toList() ?? []);
