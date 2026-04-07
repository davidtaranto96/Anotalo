import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/journal_service.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/models/journal_entry.dart';

final journalServiceProvider = Provider((ref) =>
    JournalService(ref.watch(databaseProvider)));

final todayJournalProvider = StreamProvider<JournalEntry?>((ref) =>
    ref.watch(journalServiceProvider).watchEntryForDay(todayId()));

final allJournalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) =>
    ref.watch(journalServiceProvider).watchAllEntries());
