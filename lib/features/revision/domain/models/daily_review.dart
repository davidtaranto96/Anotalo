import 'package:equatable/equatable.dart';

import '../../../../core/database/app_database.dart';

/// Structured end-of-day review bound to a single [dayId] (`YYYY-MM-DD`).
class DailyReview extends Equatable {
  final String id;
  final String dayId;
  final DateTime? completedAt;
  final int? mood; // 1..5
  final String? moodNote;
  final bool? smoked;
  final bool? tookMedication;
  final String? patterns;
  final String? highlights;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyReview({
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

  bool get isCompleted => completedAt != null;

  DailyReview copyWith({
    DateTime? completedAt,
    int? mood,
    String? moodNote,
    bool? smoked,
    bool? tookMedication,
    String? patterns,
    String? highlights,
    DateTime? updatedAt,
  }) => DailyReview(
        id: id,
        dayId: dayId,
        completedAt: completedAt ?? this.completedAt,
        mood: mood ?? this.mood,
        moodNote: moodNote ?? this.moodNote,
        smoked: smoked ?? this.smoked,
        tookMedication: tookMedication ?? this.tookMedication,
        patterns: patterns ?? this.patterns,
        highlights: highlights ?? this.highlights,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory DailyReview.fromRow(DailyReviewsTableData r) => DailyReview(
        id: r.id,
        dayId: r.dayId,
        completedAt: r.completedAt,
        mood: r.mood,
        moodNote: r.moodNote,
        smoked: r.smoked,
        tookMedication: r.tookMedication,
        patterns: r.patterns,
        highlights: r.highlights,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      );

  @override
  List<Object?> get props => [
        id, dayId, completedAt, mood, moodNote, smoked,
        tookMedication, patterns, highlights, createdAt, updatedAt,
      ];
}
