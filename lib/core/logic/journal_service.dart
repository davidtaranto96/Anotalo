import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../../features/revision/domain/models/journal_entry.dart';

class JournalService {
  final AppDatabase _db;
  JournalService(this._db);

  static const _uuid = Uuid();

  JournalEntry _fromRow(JournalEntriesTableData row) => JournalEntry(
    id: row.id,
    dayId: row.dayId,
    reflection: row.reflection,
    mood: row.mood,
    gratitude: row.gratitude,
    lessonsLearned: row.lessonsLearned,
    tomorrowFocus: row.tomorrowFocus,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  Stream<List<JournalEntry>> watchAllEntries() {
    return (_db.select(_db.journalEntriesTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> deleteEntry(String dayId) async {
    await (_db.delete(_db.journalEntriesTable)
      ..where((t) => t.dayId.equals(dayId))).go();
  }

  Stream<JournalEntry?> watchEntryForDay(String dayId) {
    return (_db.select(_db.journalEntriesTable)
      ..where((t) => t.dayId.equals(dayId)))
      .watchSingleOrNull()
      .map((row) => row == null ? null : _fromRow(row));
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final existing = await (_db.select(_db.journalEntriesTable)
      ..where((t) => t.dayId.equals(entry.dayId))).getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.journalEntriesTable)
        ..where((t) => t.dayId.equals(entry.dayId)))
        .write(JournalEntriesTableCompanion(
          reflection: Value(entry.reflection),
          mood: Value(entry.mood),
          gratitude: Value(entry.gratitude),
          lessonsLearned: Value(entry.lessonsLearned),
          tomorrowFocus: Value(entry.tomorrowFocus),
          updatedAt: Value(DateTime.now()),
        ));
    } else {
      await _db.into(_db.journalEntriesTable).insert(JournalEntriesTableCompanion.insert(
        id: _uuid.v4(),
        dayId: entry.dayId,
        reflection: entry.reflection,
        mood: Value(entry.mood),
        gratitude: Value(entry.gratitude),
        lessonsLearned: Value(entry.lessonsLearned),
        tomorrowFocus: Value(entry.tomorrowFocus),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }
}
