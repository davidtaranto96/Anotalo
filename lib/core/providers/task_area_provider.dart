import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_providers.dart';
import '../logic/task_area_service.dart';
import '../models/task_area.dart';

final taskAreaServiceProvider = Provider<TaskAreaService>(
  (ref) => TaskAreaService(ref.watch(databaseProvider)),
);

/// All areas, reactive, ordered by sortOrder then label.
/// Widgets should watch this and use [getTaskAreaFrom] to look up by id.
final taskAreasStreamProvider = StreamProvider<List<TaskArea>>(
  (ref) => ref.watch(taskAreaServiceProvider).watchAreas(),
);

/// Synchronous fallback provider — returns the current cached list, or the
/// built-in defaults if the stream hasn't emitted yet. Safe to read from
/// widgets that need a list right now.
final taskAreasSyncProvider = Provider<List<TaskArea>>(
  (ref) => ref.watch(taskAreasStreamProvider).maybeWhen(
        data: (list) => list,
        orElse: () => kBuiltinAreas,
      ),
);
