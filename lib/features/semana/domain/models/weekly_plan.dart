import 'package:equatable/equatable.dart';

class WeeklyPlan extends Equatable {
  final String id;
  final String weekStart;
  final String weekEnd;
  final List<String> primordialGoals;
  final List<String> projectFocusIds;
  final String? reflection;
  final bool isComplete;
  final DateTime createdAt;

  const WeeklyPlan({
    required this.id,
    required this.weekStart,
    required this.weekEnd,
    this.primordialGoals = const [],
    this.projectFocusIds = const [],
    this.reflection,
    this.isComplete = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, weekStart, weekEnd, primordialGoals, projectFocusIds, reflection, isComplete, createdAt];
}
