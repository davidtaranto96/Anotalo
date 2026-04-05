import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final String dayId;
  final String reflection;
  final int? mood;
  final String? gratitude;
  final String? lessonsLearned;
  final String? tomorrowFocus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JournalEntry({
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
  List<Object?> get props => [id, dayId];
}
