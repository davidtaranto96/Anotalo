import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/daily_review_service.dart';
import '../../domain/models/daily_review.dart';

final dailyReviewServiceProvider = Provider<DailyReviewService>(
  (ref) => DailyReviewService(ref.watch(databaseProvider)),
);

/// All reviews, newest first.
final allDailyReviewsProvider = StreamProvider<List<DailyReview>>(
  (ref) => ref.watch(dailyReviewServiceProvider).watchAll(),
);

/// A single day's review, reactive.
final dailyReviewForDayProvider =
    StreamProvider.family<DailyReview?, String>(
  (ref, dayId) => ref.watch(dailyReviewServiceProvider).watchByDay(dayId),
);
