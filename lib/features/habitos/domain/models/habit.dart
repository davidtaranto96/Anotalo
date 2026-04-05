import 'package:equatable/equatable.dart';

enum HabitFrequency { daily, weekly }

class Habit extends Equatable {
  final String id;
  final String title;
  final String? description;
  final HabitFrequency frequency;
  final String? area;
  final String? color;
  final String? icon;
  final bool isArchived;
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    this.area,
    this.color,
    this.icon,
    this.isArchived = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, frequency, isArchived];
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
