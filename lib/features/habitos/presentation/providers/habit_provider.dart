import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/habit_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/habit.dart';

final habitServiceProvider = Provider((ref) =>
    HabitService(ref.watch(databaseProvider)));

final activeHabitsProvider = StreamProvider<List<Habit>>((ref) =>
    ref.watch(habitServiceProvider).watchActiveHabits());

final todayCompletionsProvider = StreamProvider<List<HabitCompletion>>((ref) =>
    ref.watch(habitServiceProvider).watchCompletionsForDay(todayId()));

final habitStreakProvider = FutureProvider.family<int, String>((ref, habitId) =>
    ref.watch(habitServiceProvider).getStreak(habitId));
