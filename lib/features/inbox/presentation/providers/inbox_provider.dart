import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/logic/quick_note_service.dart';
import '../../domain/models/quick_note.dart';

final quickNoteServiceProvider = Provider((ref) =>
    QuickNoteService(ref.watch(databaseProvider)));

final unprocessedNotesProvider = StreamProvider<List<QuickNote>>((ref) =>
    ref.watch(quickNoteServiceProvider).watchUnprocessed());
