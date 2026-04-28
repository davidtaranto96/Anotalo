import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../utils/json_utils.dart';
import '../../features/inbox/domain/models/quick_note.dart';

class QuickNoteService {
  final AppDatabase _db;
  QuickNoteService(this._db);

  static const _uuid = Uuid();

  QuickNote _fromRow(QuickNotesTableData row) => QuickNote(
    id: row.id,
    content: row.content,
    type: QuickNoteType.values.firstWhere(
      (e) => e.name == row.type,
      orElse: () => QuickNoteType.general,
    ),
    isProcessed: row.isProcessed,
    processedToType: row.processedToType,
    processedToTargetId: row.processedToTargetId,
    tags: decodeStringList(row.tags),
    isPinned: row.isPinned,
    createdAt: row.createdAt,
  );

  /// Stream de notas no procesadas — fijadas primero, luego por createdAt
  /// descendente. La UI confía en este orden para no recalcular cada
  /// vez.
  Stream<List<QuickNote>> watchUnprocessed() {
    return (_db.select(_db.quickNotesTable)
      ..where((t) => t.isProcessed.equals(false))
      ..orderBy([
        (t) => OrderingTerm.desc(t.isPinned),
        (t) => OrderingTerm.desc(t.createdAt),
      ]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> addNote(String content) async {
    await _db.into(_db.quickNotesTable).insert(QuickNotesTableCompanion.insert(
      id: _uuid.v4(),
      content: content,
      createdAt: DateTime.now(),
    ));
  }

  Stream<List<QuickNote>> watchProcessed() {
    return (_db.select(_db.quickNotesTable)
      ..where((t) => t.isProcessed.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch()
      .map((rows) => rows.map(_fromRow).toList());
  }

  Future<void> addNoteWithType(String content, QuickNoteType type) async {
    await _db.into(_db.quickNotesTable).insert(QuickNotesTableCompanion.insert(
      id: _uuid.v4(),
      content: content,
      type: Value(type.name),
      createdAt: DateTime.now(),
    ));
  }

  Future<void> deleteNote(String id) async {
    await (_db.delete(_db.quickNotesTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> processNote(String id, {
    required String processedToType,
    String? processedToTargetId,
  }) async {
    await (_db.update(_db.quickNotesTable)..where((t) => t.id.equals(id)))
        .write(QuickNotesTableCompanion(
      isProcessed: const Value(true),
      processedToType: Value(processedToType),
      processedToTargetId: Value(processedToTargetId),
    ));
  }

  /// Reabre una nota procesada — útil si el user la archivó por error.
  Future<void> reopenNote(String id) async {
    await (_db.update(_db.quickNotesTable)..where((t) => t.id.equals(id)))
        .write(const QuickNotesTableCompanion(
      isProcessed: Value(false),
      processedToType: Value(null),
      processedToTargetId: Value(null),
    ));
  }

  /// Toggle pin / unpin de una nota.
  Future<void> setPinned(String id, bool pinned) async {
    await (_db.update(_db.quickNotesTable)..where((t) => t.id.equals(id)))
        .write(QuickNotesTableCompanion(isPinned: Value(pinned)));
  }

  /// Edita el contenido y/o tipo de una nota existente.
  Future<void> updateNote(String id, {String? content, QuickNoteType? type}) async {
    await (_db.update(_db.quickNotesTable)..where((t) => t.id.equals(id)))
        .write(QuickNotesTableCompanion(
      content: content == null ? const Value.absent() : Value(content),
      type: type == null ? const Value.absent() : Value(type.name),
    ));
  }
}
