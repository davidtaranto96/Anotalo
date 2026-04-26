import 'package:equatable/equatable.dart';

enum ProjectStatus { active, completed, paused, archived }
enum ProjectCategory { professional, personal, health, learning, travel }

class Project extends Equatable {
  final String id;
  final String title;
  final String? description;
  final ProjectCategory category;
  final ProjectStatus status;
  final String color;
  final String? icon;
  final String? targetDate;
  final List<String> taskIds;
  final List<String> weeklyGoals;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Project({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.status,
    required this.color,
    this.icon,
    this.targetDate,
    this.taskIds = const [],
    this.weeklyGoals = const [],
    this.notes,
    this.sortOrder = 0,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [id, title, status, category, sortOrder];
}
