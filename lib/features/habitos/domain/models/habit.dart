import 'package:equatable/equatable.dart';

enum HabitFrequency { daily, weekly }

class Habit extends Equatable {
  final String id;
  final String title;
  final String? description;
  final HabitFrequency frequency;
  /// Sólo aplica si frequency == weekly. 1..7. Default 1.
  final int targetPerWeek;
  final String? area;
  final String? color;
  final String? icon;
  final bool isArchived;
  /// Orden manual definido por drag-and-drop. Más bajo = más arriba.
  final int sortOrder;
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    this.targetPerWeek = 1,
    this.area,
    this.color,
    this.icon,
    this.isArchived = false,
    this.sortOrder = 0,
    required this.createdAt,
  });

  Habit copyWith({
    String? title,
    String? description,
    HabitFrequency? frequency,
    int? targetPerWeek,
    String? area,
    String? color,
    String? icon,
    bool? isArchived,
    int? sortOrder,
  }) => Habit(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    frequency: frequency ?? this.frequency,
    targetPerWeek: targetPerWeek ?? this.targetPerWeek,
    area: area ?? this.area,
    color: color ?? this.color,
    icon: icon ?? this.icon,
    isArchived: isArchived ?? this.isArchived,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props =>
      [id, title, frequency, targetPerWeek, isArchived, sortOrder];
}

class HabitCompletion extends Equatable {
  final String id;
  final String habitId;
  final String dayId;
  final DateTime completedAt;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.dayId,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [id, habitId, dayId];
}
