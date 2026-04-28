import 'package:equatable/equatable.dart';

enum QuickNoteType { idea, nota, tarea, proyecto, general }

class QuickNote extends Equatable {
  final String id;
  final String content;
  final QuickNoteType type;
  final bool isProcessed;
  final String? processedToType;
  final String? processedToTargetId;
  final List<String> tags;
  /// Fijadas aparecen al tope de la lista, estilo Keep.
  final bool isPinned;
  final DateTime createdAt;

  const QuickNote({
    required this.id,
    required this.content,
    required this.type,
    this.isProcessed = false,
    this.processedToType,
    this.processedToTargetId,
    this.tags = const [],
    this.isPinned = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, isProcessed, isPinned];
}
